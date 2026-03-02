//
// Created by RobertFlesch on 07.10.2024.
//

#include "InputManagementTF.h"

InputManagementTF::InputManagementTF(bool stateful, double fixInterval, unsigned int nInputEntries, TensorflowDllHandler* p_tfDll, unsigned int batchSize) :
        InputManagement(stateful, fixInterval, nInputEntries, batchSize){
    mp_tfDll = p_tfDll;
}

bool InputManagementTF::addStateOut(const TfLiteTensor* stateOutTensor)
{
    size_t i = mp_stateOutTensors.size();
    if (i < m_nStateArr) {
        mp_stateOutTensors.push_back(stateOutTensor);
        unsigned int unmatchedVals[2];
        int ret = Utils::compareTensorSizes(mp_stateInpTensors[i], mp_stateOutTensors[i],
                                            unmatchedVals, mp_tfDll);
        if (ret < 0) {
            throw std::invalid_argument(Utils::string_format("Unmatched number of dimension for state "
                                                             "input and output # %i (Input has %i dimensions whereas "
                                                             "output has %i dimensions)!",
                                                             i, unmatchedVals[0], unmatchedVals[1]));
        }
        else if (ret > 0) {
            throw std::invalid_argument(Utils::string_format("Unmatched number of sizes for state input "
                                                             "and output # %i in dimension %i (Input has %i entries "
                                                             "whereas output has %i entries)!",
                                                             i, ret, unmatchedVals[0], unmatchedVals[1]));
        }
    }
    else {
        // Error
        throw std::invalid_argument("SMArtInt can only handle states in "
                                    "stateful=True if state inputs and state outputs are "
                                    "matching!");
    }
    //ToDo check type (and sizes??)
    return true;
}

double* InputManagementTF::handleInpts(double time, unsigned int iStep, double* flatInp, bool firstInvoke)
{
    // stateful NN need to be evaluated a grid times. This method interpolates the inputs @time to the previous grid
    // interval specified with iStep; additionally the states itself are either taken from the buffer for an initial
    // step (iStep=0) or they are copied from the outputs which contain the values from the previous invoke

    double* input_pointer;

    if (m_active && m_fixTimeIntv > 0) {
        // Interpolation of the regular input onto grid
        if (mp_inputBuffer.size() > 1) {
            std::vector<double>* currentInput = mp_inputBuffer.getCurrentValue();
            std::vector<double>* prevInput = mp_inputBuffer.getPrevValue();
            // calculate the grid time at which the NNs has to be evaluated
            double gridTime = m_startTime + (int((mp_inputBuffer.getPrevIdx() - m_startTime) / m_fixTimeIntv)
                                             + (iStep + 1.0)) * m_fixTimeIntv;
            for (std::size_t i = 0; i < currentInput->size(); ++i) {
                mp_flatInterpolatedInp[i] = prevInput->at(i) +
                                            (flatInp[i] - prevInput->at(i)) / (time - mp_inputBuffer.getPrevIdx())
                                            * (gridTime - mp_inputBuffer.getPrevIdx());
            }
        }
        else {
            for (unsigned int i = 0; i < m_nInputEntries; ++i) {
                mp_flatInterpolatedInp[i] = flatInp[i];
            }
        }
        // Handling of the state inputs
        if (iStep == 0) {
            // initialize states with results from previously accepted step (take it from buffer)
            // previously an empty entry is created in the state buffer - this point here will be called multiple times
            // when iterating the current step: in order to use the value of the previous accepted step we will create
            // the empty entry first and use the previous value
            for (unsigned int b = 0; b < m_batchSize; ++b) {
                Utils::StateInputsContainer* stateInputs = m_stateBuffers[b].getPrevValue();
                for (unsigned int i = 0; i < m_nStateArr; ++i) {
                    size_t stateSize = stateInputs->byteSizeAt(i);
                    std::memcpy(reinterpret_cast<char*>(mp_tfDll->tensorData(mp_stateInpTensors[i])) + b * stateSize,
                                stateInputs->at(i), stateSize);
                }
            }
        }
        else {
            // copy state output to input
            for (unsigned int i = 0; i < m_nStateArr; ++i) {
                std::memcpy(mp_tfDll->tensorData(mp_stateInpTensors[i]),
                            mp_tfDll->tensorData(mp_stateOutTensors[i]),
                            mp_tfDll->tensorByteSize(mp_stateOutTensors[i]));
            }
        }
        input_pointer = mp_flatInterpolatedInp;
    }
    else {
        input_pointer = flatInp;
    }

    return input_pointer;
}

bool InputManagementTF::addStateInp(TfLiteTensor* stateInpTensor)
{
    m_nStateArr += 1;
    mp_stateInpTensors.push_back(stateInpTensor);
    m_nStateValues += Utils::getNumElementsTensor(stateInpTensor, mp_tfDll);
    return true;
}

bool InputManagementTF::updateFinishedStep(unsigned int nSteps)
{
    if (m_active && nSteps > 0) {
        for (unsigned int b = 0; b < m_batchSize; ++b) {
            const auto test = new Utils::StateInputsContainer();
            for (unsigned int i = 0; i < m_nStateArr; ++i) {
                test->addStateInput(mp_stateInpTensors[i], mp_tfDll, m_batchSize);
                // handle the states
                size_t stateSize = test->byteSizeAt(i);
                std::memcpy(test->at(i), reinterpret_cast<char*>(mp_tfDll->tensorData(mp_stateOutTensors[i])) + b * stateSize,
                            stateSize);
            }
            m_stateBuffers[b].store(m_currentGridTime, test);
        }
    }
    return true;
}

void InputManagementTF::initialize(double time, double* p_stateValues, const unsigned int &nStateValues)
{
    if (!m_active) return;

    if (nStateValues != m_nStateValues) {
        throw std::invalid_argument(Utils::string_format(
                "SMArtInt needs to initialize %i but %i are given", m_nStateValues, nStateValues));
    }

    unsigned int counter = 0;
    for (unsigned int b = 0; b < m_batchSize; ++b) {
        const auto test = new Utils::StateInputsContainer();
        for (unsigned int iInput = 0; iInput < m_nStateArr; ++iInput) {
            void (*castFunc)(const double &, void *, unsigned int);

            switch (mp_tfDll->tensorType(mp_stateInpTensors[iInput])) {
                case kTfLiteFloat32:
                    castFunc = &Utils::castToFloat;
                    break;
                default:
                    throw std::invalid_argument(
                            "Could not convert state data - SMArtInt currently only supports TFLite models using floats)!");
            }

            test->addStateInput(mp_stateInpTensors[iInput], mp_tfDll, m_batchSize);
            void *p_data = test->at(iInput);
            unsigned int n = Utils::getNumElementsTensor(mp_stateInpTensors[iInput], mp_tfDll) / m_batchSize;

            for (unsigned int i = 0; i < n; ++i) {
                castFunc(p_stateValues[counter++], p_data, i);
            }
        }
        m_stateBuffers[b].initialize(test);
    }
}

