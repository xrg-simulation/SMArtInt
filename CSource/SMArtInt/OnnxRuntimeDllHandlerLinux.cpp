#include "OnnxRuntimeDllHandlerLinux.h"
#include "Utils.h"
#include <dlfcn.h>

using OrtGetApiBaseFn = const OrtApiBase* (*)(void);

OnnxRuntimeDllHandlerLinux::OnnxRuntimeDllHandlerLinux(const char* soPath)
{
    if (!soPath || soPath[0] == '\0') {
        throw std::runtime_error("OnnxRuntimeDllHandlerLinux: soPath is null or empty");
    }

    std::cout << "Loading libonnxruntime_c.so from " << soPath << std::endl;
    _handle = dlopen(soPath, RTLD_LAZY);

    if (!_handle) {
        std::string errorMsg = "Failed to load libonnxruntime_c.so at " + std::string(soPath) + ". Error: " + dlerror();
        throw std::runtime_error(errorMsg);
    }

    auto getApiBase = reinterpret_cast<OrtGetApiBaseFn>(dlsym(_handle, "OrtGetApiBase"));
    if (!getApiBase) {
        std::string errorMsg = "Failed to resolve OrtGetApiBase in libonnxruntime_c.so. Error: " + std::string(dlerror());
        throw std::runtime_error(errorMsg);
    }
    const OrtApiBase* base = getApiBase();
    Ort::InitApi(base->GetApi(ORT_API_VERSION));
}

OnnxRuntimeDllHandlerLinux::~OnnxRuntimeDllHandlerLinux()
{
    if (_handle) dlclose(_handle);
}
