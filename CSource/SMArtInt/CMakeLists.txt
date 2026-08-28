cmake_minimum_required(VERSION 3.16)
cmake_policy(SET CMP0091 NEW)

################################################################################
# Source groups
################################################################################
set(Headerdateien
		${CMAKE_CURRENT_SOURCE_DIR}/../External/tensorflow/tensorflow/lite/c/c_api.h
		${CMAKE_CURRENT_SOURCE_DIR}/../External/onnx/onnxruntime/include/onnxruntime_cxx_api.h
		"OnnxRuntimeDllHandler.h"
		"InputManagement.h"
		"InputManagementONNX.h"
		"InputManagementTF.h"
		"InterfaceFunctions.h"
		"NeuralNet.h"
		"NeuralNetTF.h"
		"NeuralNetONNX.h"
		"Utils.h"
		"NNBuffer.h"
		"TensorflowDllHandler.h"
)
if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
	list(APPEND Headerdateien "TensorflowDllHandlerLinux.h")
    list(APPEND Headerdateien "OnnxRuntimeDllHandlerLinux.h")
else()
	list(APPEND Headerdateien "TensorflowDllHandlerWin.h")
    list(APPEND Headerdateien "OnnxRuntimeDllHandlerWin.h")
endif()
source_group("Headerdateien" FILES ${Headerdateien})

set(Quelldateien
    "InputManagement.cpp"
	"InputManagementONNX.cpp"
	"InputManagementTF.cpp"
    "InterfaceFunctions.cpp"
    "NeuralNet.cpp"
	"NeuralNetTF.cpp"
	"NeuralNetONNX.cpp"
    "Utils.cpp"
)
if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
	list(APPEND Quelldateien "TensorflowDllHandlerLinux.cpp")
	list(APPEND Quelldateien "OnnxRuntimeDllHandlerLinux.cpp")
else()
	list(APPEND Quelldateien "TensorflowDllHandlerWin.cpp")
	list(APPEND Quelldateien "OnnxRuntimeDllHandlerWin.cpp")
endif()
source_group("Quelldateien" FILES ${Quelldateien})

set(ALL_FILES
    ${Headerdateien}
    ${Quelldateien}
)

################################################################################
# Target
################################################################################
add_library(${PROJECT_NAME} SHARED ${ALL_FILES})


################################################################################
# Dependencies
################################################################################

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../External/tensorflow/)
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/../External/tensorflow/)

# Use ONNX Runtime C++ API with manual init so we can delay/dynamically load the library at runtime
target_compile_definitions(${PROJECT_NAME} PRIVATE ORT_API_MANUAL_INIT)
