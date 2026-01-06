//
// Created by TimHanke on 08.10.2024.
//

#include <algorithm>
#include "NeuralNetONNX.h"
#include <cstdlib>
#include <iostream>
#include <sstream>
#include <chrono>
#include "Utils.h"
#ifdef _WIN32
#include "OnnxRuntimeDllHandlerWin.h"
#else
#include "OnnxRuntimeDllHandlerLinux.h"
#endif

OnnxNeuralNet::OnnxNeuralNet(ModelicaUtilityHelper *p_modelicaUtilityHelper, const char *onnxModelPath,
                             unsigned int dymInputDim, unsigned int *p_dymInputSizes, unsigned int dymOutputDim,
                             unsigned int *p_dymOutputSizes, bool stateful, double fixInterval,
                             int nThreads,  bool useGpu, int gpuDevice, int executionMode) : NeuralNet(
        p_modelicaUtilityHelper, onnxModelPath,
        dymInputDim, p_dymInputSizes, dymOutputDim, p_dymOutputSizes,
        stateful, fixInterval, nThreads) {

    mp_timeStepMngmt = new InputManagementONNX(stateful, fixInterval, m_nInputEntries, mp_inputSizes[0]);

    // define some settings
    m_useGPU = useGpu;
    m_gpuDeviceId = gpuDevice;
    m_executionMode = (executionMode==1) ? ExecutionMode::ORT_SEQUENTIAL : ExecutionMode::ORT_PARALLEL;

    // perform steps to create model
    OnnxNeuralNet::loadAndInit(onnxModelPath);
}

OnnxNeuralNet::~OnnxNeuralNet() {
    //mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: Destructor ONNX Neural Network\n");
    // clean up allocated onnx stuff - Correct way?
    // delete(mp_session);
    // delete(mp_binding);
    // delete(mp_model);
    // delete(input_data);
    // delete(tensorData);
    //clean up time step manager
    delete mp_timeStepMngmt;
}

void OnnxNeuralNet::loadAndInit(const char* onnxModelPath)
{
    m_onnxModelPath = onnxModelPath;

    // Ensure ONNX Runtime is loaded dynamically before using any Ort::* APIs
    if (!mp_onnxDll) {
#ifdef _WIN32
        try {
            mp_onnxDll = std::make_unique<OnnxRuntimeDllHandlerWin>(nullptr, m_useGPU);
        } catch (const std::exception& ex) {
            auto msg = std::string("SMArtInt: Failed to load onnxruntime_c.dll: ") + ex.what() + "\n";
            mp_modelicaUtilityHelper->ModelicaError(msg.c_str());
            // Abort further initialization to avoid using uninitialized ORT API
            return;
        }
#else
        try {
            mp_onnxDll = std::make_unique<OnnxRuntimeDllHandlerLinux>(nullptr, m_useGPU);
        } catch (const std::exception& ex) {
            auto msg = std::string("SMArtInt: Failed to load libonnxruntime_c.so: ") + ex.what() + "\n";
            mp_modelicaUtilityHelper->ModelicaError(msg.c_str());
            // Abort further initialization to avoid using uninitialized ORT API
            return;
        }
#endif
    }

    // Now that ORT API is initialized, create CPU MemoryInfo
    if (!memInfo) {
        memInfo = Ort::MemoryInfo::CreateCpu(OrtAllocatorType::OrtDeviceAllocator, OrtMemTypeDefault);
    }

#ifdef _MSC_VER
    // convert const char* in wchar_t*
    size_t length = 0;
    mbstowcs_s(&length, nullptr, 0, onnxModelPath, _TRUNCATE);
    auto* model_path_wchar = new wchar_t[length + 1];
    mbstowcs_s(nullptr, model_path_wchar, length + 1, onnxModelPath, length);
#endif


    mp_model = new Ort::Env(ORT_LOGGING_LEVEL_WARNING, "test_onnx");

    // Optional CUDA Provider
    if (m_useGPU) {
        try {
            // Ensure SessionOptions is constructed after ORT API init
            mp_options = Ort::SessionOptions();
            OrtCUDAProviderOptions cuda_options;
            cuda_options.device_id = m_gpuDeviceId;
            //cuda_options.arena_extend_strategy = 0;
            cuda_options.do_copy_in_default_stream = 1;
            cuda_options.arena_extend_strategy = 1;

            mp_options.AppendExecutionProvider_CUDA(cuda_options);
            // mp_options.DisableMemPattern();
            mp_options.SetExecutionMode(m_executionMode);
            mp_options.SetGraphOptimizationLevel(GraphOptimizationLevel::ORT_ENABLE_EXTENDED);

            // Create the interpreter.
#ifdef _MSC_VER
            mp_session = new Ort::Session(*mp_model,  model_path_wchar, mp_options);
#else
            mp_session = new Ort::Session(*mp_model,  onnxModelPath, mp_options);
#endif
            m_cudaAvailable = true;
        } catch (const Ort::Exception &e) {
            auto msg = std::string("SMArtInt: [ONNX Runtime] CUDA Provider could not be initialized: ") + e.what() +
                       "\nFalling back to CPU.\n";
            mp_modelicaUtilityHelper->ModelicaMessage(msg.c_str());
            m_cudaAvailable = false;
        }
    }

    if (m_cudaAvailable) {
        mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: Using CUDA Provider\n");
    } else {
        try {
        mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: Using CPU Provider\n");
        if (!mp_options) {
            mp_options = Ort::SessionOptions();
        }

        // thread management
        mp_options.SetInterOpNumThreads(m_nThreads);
        mp_options.SetIntraOpNumThreads(m_nThreads);
        mp_options.SetGraphOptimizationLevel(GraphOptimizationLevel::ORT_ENABLE_ALL);
        mp_options.SetExecutionMode(m_executionMode);

        // Create the interpreter.
#ifdef _MSC_VER
        mp_session = new Ort::Session(*mp_model,  model_path_wchar, mp_options);
#else
        mp_session = new Ort::Session(*mp_model,  onnxModelPath, mp_options);
#endif
        } catch (const Ort::Exception &e) {
            auto msg = std::string("SMArtInt: [ONNX Runtime] CPU Provider could not be initialized: ") + e.what() + "\n";
            mp_modelicaUtilityHelper->ModelicaError(msg.c_str());
        }
    }

    // Create IO binding for faster I/O paths
    try {
        mp_binding = new Ort::IoBinding(*mp_session);
    } catch (const Ort::Exception &e) {
        // If binding creation fails, continue without it
        mp_binding = nullptr;
        m_cudaAvailable = false; // ensure we don't try to use binding/GPU path
        mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: [ONNX Runtime] IoBinding could not be created. Falling back to standard Run.\n");
    }

    if (m_cudaAvailable && mp_binding) {
        // Initialize CUDA MemoryInfo for binding outputs to GPU
        try {
            // Initialize CudaPinned for fast host transfers
            memInfoCudaPinned = Ort::MemoryInfo("CudaPinned", OrtAllocatorType::OrtDeviceAllocator, m_gpuDeviceId, OrtMemTypeDefault);
        } catch (const Ort::Exception &e) {
            // If CUDA MemoryInfo is not available, disable CUDA path
            m_cudaAvailable = false;
            mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: [ONNX Runtime] CUDA MemoryInfo init failed. Falling back to CPU path.\n");
        }
    }

    // Allocate tensor buffers.
    Ort::AllocatorWithDefaultOptions allocator;
    for (std::size_t i = 0; i < mp_session->GetInputCount(); i++) {
        m_input_names.emplace_back(std::move(mp_session->GetInputNameAllocated(i, allocator)).get());
        m_input_shapes = mp_session->GetInputTypeInfo(i).GetTensorTypeAndShapeInfo().GetShape();
    }
    m_input_shapes = mp_session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape();

    for (std::size_t i = 0; i < mp_session->GetOutputCount(); i++) {
        m_output_names.emplace_back(std::move(mp_session->GetOutputNameAllocated(i, allocator)).get());
        m_output_shapes = mp_session->GetOutputTypeInfo(i).GetTensorTypeAndShapeInfo().GetShape();
    }
    m_output_shapes = mp_session->GetOutputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape();

    input_names_char = std::vector<const char *>(m_input_names.size(), nullptr);
    std::transform(std::begin(m_input_names), std::end(m_input_names), std::begin(input_names_char),
                   [&](const std::string &str) { return str.c_str(); });

    output_names_char = std::vector<const char *>(m_output_names.size(), nullptr);
    std::transform(std::begin(m_output_names), std::end(m_output_names), std::begin(output_names_char),
                   [&](const std::string &str) { return str.c_str(); });

    if (mp_session->GetInputCount() != 1 && !mp_timeStepMngmt->isActive()) {
        mp_modelicaUtilityHelper->ModelicaError("SMArtInt can only handle models with single input");
    }

    // adjust first dimension which is batch size if batch size is dynamic
    m_input_shapes[0] = (m_input_shapes[0] == -1 && mp_inputSizes[0] == 1) ? 1 : m_input_shapes[0];
    m_output_shapes[0] = (m_output_shapes[0] == -1 && mp_outputSizes[0] == 1) ? 1 : m_output_shapes[0];

    // ToDo Adjusting Batchsize for stateful models: every input and output (state in- and outputs) needed to be adjusted with an batchsize
    if (m_input_shapes[0] != mp_inputSizes[0]){
        std::string message = "SMArtInt: Adjust first dimension of primary input from " + Utils::string_format("%i", m_input_shapes[0]) + " to batch size " + Utils::string_format("%i\n", mp_inputSizes[0]);
        mp_modelicaUtilityHelper->ModelicaMessage(message.c_str());

        m_input_shapes[0] = mp_inputSizes[0]; //1
        m_output_shapes[0] = mp_outputSizes[0];
    }

    // If binding available, pre-bind inputs and outputs once
    if (mp_binding) {
        try {
            // Prepare persistent primary input tensor; prefer CudaPinned when CUDA is available for faster H2D
            input_data = new std::vector<float>(m_nInputEntries);
            const Ort::MemoryInfo& inMemInfo = (m_cudaAvailable && memInfoCudaPinned) ? memInfoCudaPinned : memInfo;
            m_inputTensor = Ort::Value::CreateTensor<float>(inMemInfo, input_data->data(), input_data->size(), m_input_shapes.data(), m_input_shapes.size());

            // Bind primary input
            mp_binding->ClearBoundInputs();
            mp_binding->BindInput(input_names_char[0], m_inputTensor);

            // If stateful, bind state inputs using the tensors created in initialize
            if (mp_timeStepMngmt->isActive()) {
                // Ensure state input tensors are already prepared below after we create them
                // The actual bind will be done after state tensors are created (see further below)
            }

            // Bind outputs: prefer CudaPinned when CUDA is available for fast D2H; otherwise CPU
            mp_binding->ClearBoundOutputs();
            for (const auto &out_name : output_names_char) {
                if (m_cudaAvailable && memInfoCudaPinned) {
                    mp_binding->BindOutput(out_name, memInfoCudaPinned);
                } else {
                    mp_binding->BindOutput(out_name, memInfo);
                }
            }

            // One-time info: which I/O binding mode is used for outputs
            if (m_cudaAvailable && memInfoCudaPinned) {
                mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: ONNX I/O binding mode for outputs: CudaPinned\n");
            } else {
                mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: ONNX I/O binding mode for outputs: CPU\n");
            }
        } catch (const Ort::Exception &e) {
            // If binding outputs fails, fall back to standard Run path
            mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: [ONNX Runtime] Pre-binding failed. Falling back to standard Run.\n");
            delete mp_binding; mp_binding = nullptr;
        }
    }
    else {
        // No IoBinding available
        mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: ONNX I/O binding mode: None (standard Run path)\n");
    }

    // check input and output size
    checkInputTensorSize();
    checkOutputTensorSize();

    // check the number of outputs
    if (mp_session->GetOutputCount() != 1) {
        if (mp_timeStepMngmt->isActive()) {
            if (mp_session->GetOutputCount() != mp_session->GetInputCount()) {
                mp_modelicaUtilityHelper->ModelicaError("SMArtInt: Stateful handling can only be done if model has the same number of inputs (=) and outputs");
            }
        }
        else {
            mp_modelicaUtilityHelper->ModelicaError("SMArtInt can only handle models with single output!");
        }
    }

    // Handle states as additional inputs
    if (mp_timeStepMngmt->isActive()) {
        mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: Handling additional inputs as states");
        tensorData = new std::vector<std::vector<float>>(static_cast<int>(mp_session->GetInputCount()) -1);
        for (int i = 1; i < mp_session->GetInputCount(); ++i) {
            try {
                std::vector<int64_t> input_shape;
                input_shape = mp_session->GetInputTypeInfo(i).GetTensorTypeAndShapeInfo().GetShape();
                
                // Adjust batch size if it's dynamic (-1) or if it doesn't match the desired batch size
                if (input_shape[0] == -1 || input_shape[0] != mp_inputSizes[0]) {
                    std::string message = "SMArtInt: Adjusting first dimension of state input " + std::to_string(i) + " from " + std::to_string(input_shape[0]) + " to batch size " + std::to_string(mp_inputSizes[0]) + "\n";
                    mp_modelicaUtilityHelper->ModelicaMessage(message.c_str());
                    input_shape[0] = mp_inputSizes[0];
                }

                size_t totalSize = 1;
                for (int64_t dim : input_shape) {
                    totalSize *= dim;
                }
                tensorData->at(i-1) = std::vector<float>(totalSize, 0.0f);
                auto* tensor = new Ort::Value(Ort::Value::CreateTensor<float>(memInfo, (*tensorData)[i-1].data(), (*tensorData)[i-1].size(), input_shape.data(), input_shape.size()));
                mp_timeStepMngmt->addStateInp(tensor);

            }
            catch (const std::invalid_argument& e) {
                mp_modelicaUtilityHelper->ModelicaError(e.what());
            }
        }
    }
    // Ensure input_data exists if not created above (e.g., when mp_binding was not available)
    if (!input_data) input_data = new std::vector<float>(m_nInputEntries);

    // After state tensors are created, if binding is available, bind them once
    if (mp_binding && mp_timeStepMngmt->isActive()) {
        try {
            for (int i = 1; i < mp_session->GetInputCount(); ++i) {
                mp_binding->BindInput(input_names_char[i], *mp_timeStepMngmt->mp_OnnxStateInpTensors[i-1]);
            }
        } catch (const Ort::Exception &e) {
            mp_modelicaUtilityHelper->ModelicaMessage("SMArtInt: [ONNX Runtime] Binding state inputs failed. Using standard per-step inputs for states.\n");
        }
    }
}

std::string OnnxNeuralNet::print_shape(const std::vector<std::int64_t>& v) {
    std::stringstream ss("");
    for (std::size_t i = 0; i < v.size() - 1; i++) ss << v[i] << "x";
    ss << v[v.size() - 1];
    return ss.str();
}

void OnnxNeuralNet::runInferenceFlatTensor(double time, double* input, unsigned int inputLength, double* output, unsigned int outputLength)
{
    // check the sizes
    if (m_nInputEntries != inputLength) {
        std::string message = Utils::string_format("SMArtInt: Wrong input length: in the interface were %i entries defined, whereas in current function call %i is specified!", m_nInputEntries, inputLength);
        mp_modelicaUtilityHelper->ModelicaError(message.c_str());
    }
    // check output size
    if (m_nOutputEntries != outputLength) {
        std::string message = Utils::string_format("SMArtInt: Wrong output length: in the interface were %i entries defined, whereas in current function call %i is specified!", m_nOutputEntries, outputLength);
        mp_modelicaUtilityHelper->ModelicaError(message.c_str());
    }

    if (mp_timeStepMngmt->isActive() && m_firstInvoke && !m_statesInitialized) {
        // Initialize states if available
        mp_timeStepMngmt->InputManagement::initialize(time);
        m_statesInitialized = true;
    }

    // Avoid per-step temporary result allocations; we'll read directly from the bound output tensor
    unsigned int nSteps = 0;
    try {
        mp_timeStepMngmt->storeInputs(time, input);
        nSteps = mp_timeStepMngmt->calculateNumberOfSteps(time, m_firstInvoke);
    } catch (std::exception& e) {
        mp_modelicaUtilityHelper->ModelicaError(e.what());
    }

    for (unsigned int i = 0; i < nSteps; ++i)
    {
        double* inpInput = mp_timeStepMngmt->handleInpts(time, i, input, m_firstInvoke);

        // we write the data directly into the data array of the tensor
        for (unsigned int j = 0; j < m_nInputEntries; ++j) {
            (*input_data)[j] = static_cast<float>(inpInput[j]);
        }

        // If we have IoBinding set up, inputs/outputs are pre-bound and persistent
        // Otherwise, we will create per-step input tensors as before
        std::vector<Ort::Value> input_tensors;
        if (!mp_binding) {
            // Feature input tensor (CPU)
            input_tensors.emplace_back(Ort::Value::CreateTensor<float>(memInfo, input_data->data(), input_data->size(), m_input_shapes.data(), m_input_shapes.size()));

            // Additional state inputs: wrap the persistent state buffer in lightweight Ort::Value wrappers (no memcpy)
            // This avoids per-step data copies and ensures states come strictly from the state manager (rollback-safe)
            for (size_t si = 0; si < mp_timeStepMngmt->mp_OnnxStateInpTensors.size(); ++si) {
                Ort::Value* p_state_tensor = mp_timeStepMngmt->mp_OnnxStateInpTensors[si];
                if (p_state_tensor && p_state_tensor->IsTensor()) {
                    auto sinfo = p_state_tensor->GetTensorTypeAndShapeInfo();
                    if (sinfo.GetElementType() == ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT) {
                        auto sshape = sinfo.GetShape();
                        size_t elem_count = static_cast<size_t>(sinfo.GetElementCount());
                        float* sdata = reinterpret_cast<float*>(p_state_tensor->GetTensorMutableRawData());
                        Ort::Value sval = Ort::Value::CreateTensor<float>(memInfo, sdata, elem_count, sshape.data(), sshape.size());
                        input_tensors.emplace_back(std::move(sval));
                    } else {
                        mp_modelicaUtilityHelper->ModelicaError("SMArtInt: State tensor type is not float (unsupported).\n");
                    }
                } else {
                    mp_modelicaUtilityHelper->ModelicaError("SMArtInt: Invalid state tensor provided by state manager.\n");
                }
            }
        }

        // Run inference (prefer IoBinding on CUDA)
        try {
            // auto start = std::chrono::high_resolution_clock::now();
            if (mp_binding) {
                // Inputs/Outputs are already bound persistently
                mp_session->Run(Ort::RunOptions{nullptr}, *mp_binding);
                // For CPU or CudaPinned bindings we can read directly from bound buffers
                output_tensors = mp_binding->GetOutputValues();
            } else {
                // Standard Run path
                output_tensors = mp_session->Run(Ort::RunOptions{nullptr}, input_names_char.data(), input_tensors.data(),
                                                 input_names_char.size(), output_names_char.data(), output_names_char.size());
            }
            // auto end = std::chrono::high_resolution_clock::now();
            // std::chrono::duration<double> duration = end - start;

            if (m_firstInvoke) {
                for (int j = 1; j < mp_session->GetOutputCount(); ++j) {
                    try {
                        mp_timeStepMngmt->addStateOut(&output_tensors[j]);
                    }
                    catch (const std::invalid_argument &e) {
                        mp_modelicaUtilityHelper->ModelicaError(e.what());
                    }
                }
                m_firstInvoke = false;
            } else {
                mp_timeStepMngmt->mp_OnnxStateOutTensors.clear();
                for (int j = 1; j < mp_session->GetOutputCount(); ++j) {
                    mp_timeStepMngmt->updateStateOut(&output_tensors[j]);
                }
            }

        } catch (const Ort::Exception& exception) {
            std::string message = "ERROR running model inference: " + std::string(exception.what()) + "\n";
            mp_modelicaUtilityHelper->ModelicaError(message.c_str());
            exit(-1);
        }
        // no per-step temporary state buffers allocated anymore
    }

    // Copy directly from the last step's bound output tensor into the provided double* buffer
    if (!output_tensors.empty() && output_tensors[0].IsTensor()) {
        auto tensor_info = output_tensors[0].GetTensorTypeAndShapeInfo();
        if (tensor_info.GetElementType() == ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT) {
            const float* tensor_data = output_tensors[0].GetTensorData<float>();
            const size_t elem_count = static_cast<size_t>(tensor_info.GetElementCount());
            const size_t copy_count = (elem_count < static_cast<size_t>(m_nOutputEntries))
                                      ? elem_count
                                      : static_cast<size_t>(m_nOutputEntries);
            for (size_t j = 0; j < copy_count; ++j) {
                output[j] = static_cast<double>(tensor_data[j]);
            }
        } else {
            mp_modelicaUtilityHelper->ModelicaError("SMArtInt: Output tensor element type is not float (unsupported for direct copy).\n");
        }
    } else {
        mp_modelicaUtilityHelper->ModelicaError("SMArtInt: No output tensor available after inference.\n");
    }

    mp_timeStepMngmt->updateFinishedStep(nSteps);

}

void OnnxNeuralNet::initializeStates(double time, double* p_stateValues, const unsigned int& nStateValues)
{
    try {
        mp_timeStepMngmt->initialize(time, p_stateValues, nStateValues);
    }
    catch (const std::invalid_argument& e) {
        mp_modelicaUtilityHelper->ModelicaError(e.what());
    }
}

void OnnxNeuralNet::checkInputTensorSize()
{
    if (mp_session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetDimensionsCount() != m_inputDim)
    {
        std::string message = Utils::string_format("SMArtInt: Wrong input dimensions : the loaded model has %i dimensions whereas in the interface %i is specified!", mp_session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetDimensionsCount(), m_inputDim);
        mp_modelicaUtilityHelper->ModelicaError(message.c_str());
    }
    // check the sizes in each dimension except for the first which is the batch size
    for (unsigned int i = 1; i < m_inputDim; ++i) {
        if (mp_session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape()[i] != int(mp_inputSizes[i]))
        {
            std::string message = "SMArtInt: Wrong input sizes. The loaded model has the sizes {";
            for (unsigned int j = 0; j < m_inputDim; ++j) {
                message += Utils::string_format("%i", abs(mp_session->GetInputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape()[j]));
                if (j < (m_inputDim - 1)) message += ", ";
            }
            message += "}, whereas in the interface the sizes {";
            for (unsigned int j = 0; j < m_inputDim; ++j) {
                message += Utils::string_format("%i", mp_inputSizes[j]);
                if (j < m_inputDim - 1) message += ", ";
            }
            message += "} were specified!";
            mp_modelicaUtilityHelper->ModelicaError(message.c_str());
        }
    }
}

void OnnxNeuralNet::checkOutputTensorSize()
{
    // check dimensions
    if (mp_session->GetOutputTypeInfo(0).GetTensorTypeAndShapeInfo().GetDimensionsCount() != m_outputDim)
    {
        std::string message = Utils::string_format("SMArtInt: Wrong output dimensions : the loaded model has %i dimensions whereas in the interface %i is specified!", mp_session->GetOutputTypeInfo(0).GetTensorTypeAndShapeInfo().GetDimensionsCount(), m_outputDim);
        mp_modelicaUtilityHelper->ModelicaError(message.c_str());
    }
    for (unsigned int i = 0; i < m_outputDim; ++i) {
        if (i == 0 && mp_session->GetOutputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape()[i] == -1){

        }
        else if (abs(mp_session->GetOutputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape()[i]) != int(mp_outputSizes[i]))
        {
            std::string message = "SMArtInt: Wrong output sizes. The loaded model has the sizes {";
            for (unsigned int j = 0; j < m_outputDim; ++j) {
                message += Utils::string_format("%i", abs(mp_session->GetOutputTypeInfo(0).GetTensorTypeAndShapeInfo().GetShape()[j])); // abs for not defined batch size (-1)
                if (j < (m_outputDim - 1)) message += ", ";
            }
            message += "}, whereas in the interface the sizes {";
            for (unsigned int j = 0; j < m_outputDim; ++j) {
                message += Utils::string_format("%i", mp_outputSizes[j]);
                if (j < m_outputDim - 1) message += ", ";
            }
            message += "} were specified!";
            mp_modelicaUtilityHelper->ModelicaError(message.c_str());
        }
    }
}


std::vector<float> OnnxNeuralNet::values_to_float(const std::vector<Ort::Value>& values) {
    std::vector<float> result;
    for (const auto& value : values) {
        if (value.IsTensor()) {
            auto tensor_info = value.GetTensorTypeAndShapeInfo();
            if (tensor_info.GetElementType() == ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT) {
                // get values as floats
                auto* tensor_data = value.GetTensorData<float>();
                result.insert(result.end(), tensor_data, tensor_data + tensor_info.GetElementCount());
            } else {
                throw std::runtime_error("Tensor Data Type not supported!");
            }
        } else {
            throw std::runtime_error("Value is not a Tensor!");
        }
    }
    return result;
}

void OnnxNeuralNet::print_tensor_data(const Ort::Value& value) {
    // check if value is tensor
    if (value.IsTensor()) {
        // access the tensor shape
        auto tensor_info = value.GetTensorTypeAndShapeInfo();
        auto tensor_shape = tensor_info.GetShape();

        // check if type of tensor is a float
        if (tensor_info.GetElementType() == ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT) {
            // access data
            const auto* tensor_data = value.GetTensorData<float>();

            // print data
            std::cout << "Tensor Data: [";
            for (size_t i = 0; i < tensor_info.GetElementCount(); ++i) {
                std::cout << tensor_data[i];
                if (i < tensor_info.GetElementCount() - 1) std::cout << ", ";
            }
            std::cout << "]\n" << std::endl;
        } else {
            std::cout << "Tensor Data Type not supported!" << std::endl;
        }
    } else {
        std::cout << "Value is not a Tensor!" << std::endl;
    }
}