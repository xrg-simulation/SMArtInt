
#include "Utils.h"
#include "InterfaceFunctions.h"
#include <fstream>
#include <filesystem>
#ifdef _WIN32
#include "windows.h"
#else
#include <dlfcn.h>
#include <climits>
#include <unistd.h>
#include <cerrno>     // For errno
#include <cstring>    // For strerror
#include <sys/stat.h> // For lstat
#include <vector>
#endif

int Utils::compareTensorSizes(const TfLiteTensor* A, const TfLiteTensor* B, unsigned int* unmatchedVals,
                              TensorflowDllHandler* p_tfDll)
{
	// used to compare two tensors - return 0 if their sizes are equal - returns -1 if dimensions mismatchs - returns dimension
	// where size do not match
	if (p_tfDll->tensorNumDims(A) != p_tfDll->tensorNumDims(B))
	{
		unmatchedVals[0] = p_tfDll->tensorNumDims(A);
		unmatchedVals[1] = p_tfDll->tensorNumDims(B);
		return -1;
	}
	// check the sizes in each dimension except for the first which is the batch size
	for (int i = 1; i < p_tfDll->tensorNumDims(A); ++i) {
		if (p_tfDll->tensorDim(A, i) != p_tfDll->tensorDim(A, i)) {
			unmatchedVals[0] = p_tfDll->tensorDim(A, i);
			unmatchedVals[1] = p_tfDll->tensorDim(B, i);
			return i;
		}
	}
	return 0;
}

int Utils::compareTensorSizes(Ort::Value* A, Ort::Value* B, unsigned int* unmatchedVals)
{
    // used to compare two tensors - return 0 if their sizes are equal - returns -1 if dimensions mismatchs - returns dimension
    // where size do not match
    if (A->GetTensorTypeAndShapeInfo().GetDimensionsCount() != B->GetTensorTypeAndShapeInfo().GetDimensionsCount())
    {
        unmatchedVals[0] = A->GetTensorTypeAndShapeInfo().GetDimensionsCount();
        unmatchedVals[1] = B->GetTensorTypeAndShapeInfo().GetDimensionsCount();
        return -1;
    }
    // check the sizes in each dimension except for the first which is the batch size
    for (int i = 1; i < A->GetTensorTypeAndShapeInfo().GetDimensionsCount(); ++i) {
        if (A->GetTensorTypeAndShapeInfo().GetShape()[i] != B->GetTensorTypeAndShapeInfo().GetShape()[i]) {
            unmatchedVals[0] = A->GetTensorTypeAndShapeInfo().GetShape()[i];
            unmatchedVals[1] = B->GetTensorTypeAndShapeInfo().GetShape()[i];
            return i;
        }
    }
    return 0;
}

int Utils::getNumElementsTensor(const TfLiteTensor* A, TensorflowDllHandler* p_tfDll)
{
	int nElements = 1;
	int dim = p_tfDll->tensorNumDims(A);
	for (int iDim = 0; iDim < dim; ++iDim) {
		nElements *= p_tfDll->tensorDim(A, iDim);
	}
	return nElements;
}

void Utils::castToFloat(const double& value, void* p_store, unsigned int pos)
{
	// p_stores stores float values
	auto* p_float = (float*)p_store;
	p_float[pos] = (float)value;
}

void Utils::castFromFloat(double& value, void* p_store, unsigned int pos)
{
	// p_stores stores float values
	auto* p_float = (float*)p_store;
	value = p_float[pos];
}

#ifdef _WIN32
std::string Utils::getTensorflowDllPathWin(bool flexDelegate) {
    char path[MAX_PATH];
    HMODULE hm = NULL;

    if (GetModuleHandleEx(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                          GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                          (LPCSTR) &NeuralNet_createObject, &hm) == 0)
    {
        std::string message = Utils::string_format("SMArtInt: Unable to locate tensorflow dll");
        //mp_modelicaUtilityHelper->ModelicaError(message.c_str());
        throw std::runtime_error(message);
    }
    if (GetModuleFileName(hm, path, sizeof(path)) == 0)
    {
        std::string message = Utils::string_format("SMArtInt: Unable to locate tensorflow dll");
        throw std::runtime_error(message);
    }

    std::string folderPath(path);
    size_t lastSlash = folderPath.find_last_of("\\/");
    if (lastSlash != std::string::npos) {
        folderPath = folderPath.substr(0, lastSlash + 1);
    }
    if (flexDelegate){
        // Build the new path for tensorflow_flex.dll
        return folderPath + "tensorflowlite_flex.dll";
    }
    // Build the new path for tensorflow_c.dll
    return folderPath + "tensorflowlite_c.dll";
}

std::string Utils::getOnnxRuntimeDllPathWin(bool useGPU) {
    char path[MAX_PATH];
    HMODULE hm = NULL;

    if (GetModuleHandleEx(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                          GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                          (LPCSTR) &NeuralNet_createObject, &hm) == 0)
    {
        std::string message = Utils::string_format("SMArtInt: Unable to locate onnxruntime dll");
        throw std::runtime_error(message);
    }
    if (GetModuleFileName(hm, path, sizeof(path)) == 0)
    {
        std::string message = Utils::string_format("SMArtInt: Unable to locate onnxruntime dll");
        throw std::runtime_error(message);
    }

    std::string folderPath(path);
    size_t lastSlash = folderPath.find_last_of("\\/");
    if (lastSlash != std::string::npos) {
        folderPath = folderPath.substr(0, lastSlash + 1);
    }

    // Build the new path depending on useGPU flag
    // GPU: default onnxruntime_c.dll (with CUDA provider available)
    // CPU: CPU-optimized DLL name
    if (useGPU) {
        return folderPath + "onnxruntime_c.dll";
    } else {
        return folderPath + "onnxruntime_c_cpu.dll";
    }
}
#else
namespace {
    // This fallback is necessary for Modelon Impact to ensure correct path resolution.
    // Due to the standard behavior of the Linux dynamic loader, shared libraries (like SMArtInt.so)
    // may remain loaded in memory and be reused across different FMU instances within the same process.
    // This can prevent the detection of the correct library path from the current FMU,
    // making this model-path-based fallback essential.
    std::filesystem::path getModelBasedLibraryFolder(const char* modelPath, const char* libraryName)
    {
        if (modelPath == nullptr) {
            return {};
        }

        std::filesystem::path modelFilePath(modelPath);
        if (modelFilePath.empty()) {
            return {};
        }

        std::filesystem::path modelDir = modelFilePath.parent_path();
        if (modelDir.empty()) {
            return {};
        }

        std::vector<std::filesystem::path> candidateFolders = {
            modelDir.parent_path().parent_path() / "binaries" / "linux64",
            modelDir.parent_path() / "binaries" / "linux64",
            modelDir,
            modelDir / "Library" / "linux64",
            modelDir / "library" / "linux64",
            modelDir.parent_path() / "Library" / "linux64",
            modelDir.parent_path() / "library" / "linux64"
        };

        std::error_code ec;
        for (const auto& candidateFolder : candidateFolders) {
            std::filesystem::path runtimePath = candidateFolder / libraryName;
            if (!candidateFolder.empty() && std::filesystem::exists(runtimePath, ec)) {
                return runtimePath;
            }
            ec.clear();
        }

        return modelDir;
    }
}

std::string Utils::getTensorflowDllPathLinux(bool flexDelegate, const char* modelPath)
{
    const char* libraryName = flexDelegate ? "libtensorflowlite_flex.so" : "libtensorflowlite_c.so";
    std::error_code ec;
    try
    {
        // Step 1: Get library name via dladdr
        Dl_info dl_info;
        if (dladdr((void*)&NeuralNet_createObject, &dl_info) == 0) {
            throw std::runtime_error(
                "SMArtInt: Unable to determine library name via dladdr");
        }

        std::filesystem::path libName(dl_info.dli_fname);
        libName = libName.filename();   // only the filename

        // Step 2: Open /proc/self/maps
        std::ifstream maps("/proc/self/maps");
        if (!maps.is_open()) {
            throw std::runtime_error(
                "SMArtInt: Unable to open /proc/self/maps");
        }

        std::string line;
        std::string libraryPath;

        // Step 3: Search for full absolute path in memory map
        while (std::getline(maps, line)) {
            if (line.find(libName.string()) != std::string::npos) {

                std::istringstream iss(line);
                std::string address, perms, offset, dev, inode, path;

                iss >> address >> perms >> offset >> dev >> inode >> path;

                libraryPath = path;
                break;
            }
        }

        if (libraryPath.empty()) {
            throw std::runtime_error(
                "SMArtInt: Could not determine absolute path of loaded library");
        }

        std::filesystem::path folderPath(libraryPath);
        folderPath = folderPath.parent_path();

        std::filesystem::path tfPath = folderPath / libraryName;

        if (std::filesystem::exists(tfPath, ec)) {
            return tfPath.string();
        }
        throw std::runtime_error(
            std::string("SMArtInt: Could not determine Tensorflow Runtime library path at ") + libraryPath);
    }
    catch (const std::exception& e)
    {
        auto errorMessage = std::string("SMArtInt: Error determining Tensorflow library path: ") + e.what();

        // This is a necessary fallback in case the library path cannot be determined with the method above
        // (e.g., in Modelon Impact)
        std::filesystem::path fallbackTfPath = getModelBasedLibraryFolder(modelPath, libraryName);
        if (!fallbackTfPath.empty()) {
            if (std::filesystem::exists(fallbackTfPath, ec)) {
                return fallbackTfPath.string();
            }
        }
        throw std::runtime_error(
            errorMessage + "\n" + "SMArtInt: Error in fallback Tensorflow library path detection");
    }
}

std::string Utils::getOnnxRuntimeDllPathLinux(bool useGPU, const char* modelPath)
{
    const char* libraryName = useGPU ? "libonnxruntime_c.so" : "libonnxruntime_c_cpu.so";
    std::error_code ec;
    try
    {
        // Step 1: Get library name via dladdr
        Dl_info dl_info;
        if (dladdr((void*)&NeuralNet_createObject, &dl_info) == 0) {
            throw std::runtime_error(
                "SMArtInt: Unable to determine library name via dladdr");
        }

        std::filesystem::path libName(dl_info.dli_fname);
        libName = libName.filename();   // only the filename

        // Step 2: Open /proc/self/maps
        std::ifstream maps("/proc/self/maps");
        if (!maps.is_open()) {
            throw std::runtime_error(
                "SMArtInt: Unable to open /proc/self/maps");
        }

        std::string line;
        std::string libraryPath;

        // Step 3: Search for full absolute path in memory map
        while (std::getline(maps, line)) {
            if (line.find(libName.string()) != std::string::npos) {

                std::istringstream iss(line);
                std::string address, perms, offset, dev, inode, path;

                iss >> address >> perms >> offset >> dev >> inode >> path;

                libraryPath = path;
                break;
            }
        }

        if (libraryPath.empty()) {
            throw std::runtime_error(
                "SMArtInt: Could not determine absolute path of loaded library");
        }

        std::filesystem::path folderPath(libraryPath);
        folderPath = folderPath.parent_path();

        std::filesystem::path onnxPath = folderPath / libraryName;

        if (std::filesystem::exists(onnxPath, ec)) {
            return onnxPath.string();
        }
        throw std::runtime_error(
            std::string("SMArtInt: Could not determine ONNX Runtime library path at ") + libraryPath);
    }
    catch (const std::exception& e)
    {
        auto errorMessage = std::string("SMArtInt: Error determining ONNX Runtime library path: ") + e.what();

        // This is a necessary fallback in case the library path cannot be determined with the method above
        // (e.g., in Modelon Impact)
        std::filesystem::path fallbackOnnxPath = getModelBasedLibraryFolder(modelPath, libraryName);
        if (!fallbackOnnxPath.empty()) {
            if (std::filesystem::exists(fallbackOnnxPath, ec)) {
                return fallbackOnnxPath.string();
            }
        }
        throw std::runtime_error(
            errorMessage + "\n"+ "SMArtInt: Error in fallback ONNX Runtime library path detection");
    }
}

#ifdef _WIN32
#include <windows.h>
#include <stdio.h>
int Utils::is_debugger_present() {
    return IsDebuggerPresent();
}

void Utils::wait_for_debugger() {
    while (!is_debugger_present()) {
        printf("Waiting for debugger...\n");
        Sleep(1000); // Sleep for a second before checking again
    }
    printf("Debugger detected!\n");
}
#else
#include <cstdio>
#include <sys/ptrace.h>
#include <unistd.h>

int Utils::is_debugger_present() {

    // Attempt to trace the current process
    if (ptrace(PTRACE_TRACEME, 0, 1, 0) == -1) {
        return 1; // Debugger is present
    }
    // Detach if no debugger is detected
    ptrace(PTRACE_DETACH, 0, 1, 0);
    return 0;
}

void Utils::wait_for_debugger() {
    sleep(10);
    while (!is_debugger_present()) {
        printf("Waiting for debugger...\n");
        sleep(1); // Sleep for a second before checking again
    }
    printf("Debugger detected!\n");
}
#endif

#endif
