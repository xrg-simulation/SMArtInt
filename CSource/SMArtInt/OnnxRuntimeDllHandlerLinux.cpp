#include "OnnxRuntimeDllHandlerLinux.h"
#include "Utils.h"
#include <dlfcn.h>

using OrtGetApiBaseFn = const OrtApiBase* (*)(void);

OnnxRuntimeDllHandlerLinux::OnnxRuntimeDllHandlerLinux(const char* soPath)
{
    void* handle = nullptr;
    if (soPath && soPath[0] != '\0') {
        handle = dlopen(soPath, RTLD_LAZY | RTLD_LOCAL);
    }
    if (!handle) {
        auto path = Utils::getOnnxRuntimeDllPathLinux();
        handle = dlopen(path.c_str(), RTLD_LAZY | RTLD_LOCAL);
    }
    _handle = handle;
    if (!_handle) {
        throw std::runtime_error("Failed to load libonnxruntime.so");
    }

    auto getApiBase = reinterpret_cast<OrtGetApiBaseFn>(dlsym(_handle, "OrtGetApiBase"));
    if (!getApiBase) {
        throw std::runtime_error("Failed to resolve OrtGetApiBase in libonnxruntime.so");
    }
    const OrtApiBase* base = getApiBase();
    Ort::InitApi(base->GetApi(ORT_API_VERSION));
}

OnnxRuntimeDllHandlerLinux::~OnnxRuntimeDllHandlerLinux()
{
    if (_handle) dlclose(_handle);
}
