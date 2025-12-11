#include "OnnxRuntimeDllHandlerWin.h"
#include "Utils.h"

using OrtGetApiBaseFn = const OrtApiBase* (ORT_API_CALL *)(void);

OnnxRuntimeDllHandlerWin::OnnxRuntimeDllHandlerWin(LPCSTR dllPath)
{
    // Load ONNX Runtime DLL dynamically and initialize C++ API
    // If dllPath is null, try to get from Utils
    HMODULE mod = nullptr;
    if (dllPath && dllPath[0] != '\0') {
        mod = ::LoadLibraryA(dllPath);
    }
    if (!mod) {
        auto path = Utils::getOnnxRuntimeDllPathWin();
        mod = ::LoadLibraryA(path.c_str());
    }
    _module = mod;
    if (!_module) {
        throw std::runtime_error("Failed to load onnxruntime.dll");
    }

    auto getApiBase = reinterpret_cast<OrtGetApiBaseFn>(::GetProcAddress(_module, "OrtGetApiBase"));
    if (!getApiBase) {
        throw std::runtime_error("Failed to resolve OrtGetApiBase in onnxruntime.dll");
    }
    const OrtApiBase* base = getApiBase();
    Ort::InitApi(base->GetApi(ORT_API_VERSION));
}
