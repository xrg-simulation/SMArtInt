//
// Dynamic loader for ONNX Runtime (minimal)
// Loads the shared library and initializes the C++ API via ORT_API_MANUAL_INIT
//

#pragma once

#include <string>

class OnnxRuntimeDllHandler {
public:
    virtual ~OnnxRuntimeDllHandler() = default;
};
