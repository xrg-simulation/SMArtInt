#include "OnnxRuntimeDllHandlerLinux.h"
#include "Utils.h"
#include <dlfcn.h>

using OrtGetApiBaseFn = const OrtApiBase* (*)(void);

OnnxRuntimeDllHandlerLinux::OnnxRuntimeDllHandlerLinux(const char* soPath, bool useGPU)
{
    void* handle = nullptr;
    if (soPath && soPath[0] != '\0') {
        handle = dlopen(soPath, RTLD_LAZY | RTLD_LOCAL);
    }
    if (!handle) {
        auto path = Utils::getOnnxRuntimeDllPathLinux(useGPU);
        handle = dlopen(path.c_str(), RTLD_LAZY | RTLD_LOCAL);
    }
    _handle = handle;
    if (!_handle) {
        throw std::runtime_error("Failed to load libonnxruntime_c.so");
    }

    auto getApiBase = reinterpret_cast<OrtGetApiBaseFn>(dlsym(_handle, "OrtGetApiBase"));
    if (!getApiBase) {
        throw std::runtime_error("Failed to resolve OrtGetApiBase in libonnxruntime_c.so");
    }
    const OrtApiBase* base = getApiBase();
    Ort::InitApi(base->GetApi(ORT_API_VERSION));
}

OnnxRuntimeDllHandlerLinux::~OnnxRuntimeDllHandlerLinux()
{
    if (_handle) dlclose(_handle);
}
