//
// Dynamic ONNX Runtime loader for Linux
//
#pragma once

#include "OnnxRuntimeDllHandler.h"
#include "../External/onnx/onnxruntime/include/onnxruntime_cxx_api.h"

class OnnxRuntimeDllHandlerLinux : public OnnxRuntimeDllHandler {
public:
    explicit OnnxRuntimeDllHandlerLinux(const char* soPath);
    ~OnnxRuntimeDllHandlerLinux() override;
private:
    void* _handle{nullptr};
};
