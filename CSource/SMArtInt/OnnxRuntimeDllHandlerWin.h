//
// Dynamic ONNX Runtime loader for Windows
//
#pragma once

#include "OnnxRuntimeDllHandler.h"
#include "../External/onnx/onnxruntime/include/onnxruntime_cxx_api.h"
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <windows.h>

class OnnxRuntimeDllHandlerWin : public OnnxRuntimeDllHandler {
public:
    explicit OnnxRuntimeDllHandlerWin(LPCSTR dllPath);
    ~OnnxRuntimeDllHandlerWin() override {
        if (_module) FreeLibrary(_module);
    }

private:
    HMODULE _module{nullptr};
};
