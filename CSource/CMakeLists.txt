cmake_minimum_required(VERSION 3.16.0 FATAL_ERROR)

set(CMAKE_SYSTEM_VERSION 10.0 CACHE STRING "" FORCE)

set(CMAKE_CXX_STANDARD 17)

project(SMArtInt CXX)
message("Specified build type: ${CMAKE_BUILD_TYPE}")
if(NOT DEFINED CMAKE_BUILD_TYPE)
	message("Build type not specified - use release mode")
endif()

################################################################################
# Set target arch type if empty. Visual studio solution generator provides it.
################################################################################
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    # 64 bits
	if(NOT CMAKE_VS_PLATFORM_NAME)
		set(CMAKE_VS_PLATFORM_NAME "x64")
	endif()
elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
    # 32 bits
	if(NOT CMAKE_VS_PLATFORM_NAME)
		set(CMAKE_VS_PLATFORM_NAME "x86")
	endif()
endif()

message("${CMAKE_VS_PLATFORM_NAME} architecture in use")

if(NOT ("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64"))
    message(WARNING "${CMAKE_VS_PLATFORM_NAME} arch is not supported for tensorflow - only ClaRaDelay will be created!")
endif()

################################################################################
# Global configuration types
################################################################################
set(CMAKE_CONFIGURATION_TYPES
    "Debug"
    "Release"
    CACHE STRING "" FORCE
)

# Detect target platform
if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    if(MSYS OR MINGW)
        if("$ENV{MSYSTEM}" STREQUAL "UCRT64")
            set(TARGET_SYSTEM_NAME "ucrt")
        elseif("$ENV{MSYSTEM}" STREQUAL "MINGW64" OR "$ENV{MSYSTEM}" STREQUAL "MINGW32")
            message(FATAL_ERROR "mingw system is not supported by onnx!")
        else()
            set(TARGET_SYSTEM_NAME "win")
        endif()
    else(MSYS OR MINGW)
        set(TARGET_SYSTEM_NAME "win")
    endif(MSYS OR MINGW)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  set(TARGET_SYSTEM_NAME "linux")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
  set(TARGET_SYSTEM_NAME "darwin")
else()
  message(FATAL_ERROR "Unknown target system: ${CMAKE_SYSTEM_NAME}")
endif()

if(${CMAKE_SIZEOF_VOID_P} EQUAL 8)
  set(TARGET_PLATFORM "${TARGET_SYSTEM_NAME}64")
else()
  message(FATAL_ERROR "x86 platform is not supported by tensorflow!")

endif()

# set the output directory - we all the targets point to the same location; only setting the non specialized directory does not work
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/../SMArtInt/Resources/Library/${TARGET_PLATFORM}/")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/../SMArtInt/Resources/Library/${TARGET_PLATFORM}/")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/../SMArtInt/Resources/Library/${TARGET_PLATFORM}/")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/../SMArtInt/Resources/Library/${TARGET_PLATFORM}/")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/../SMArtInt/Resources/Library/${TARGET_PLATFORM}/")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/../SMArtInt/Resources/Library/${TARGET_PLATFORM}/")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}/../SMArtInt/Resources/Library/${TARGET_PLATFORM}/")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}/../SMArtInt/Resources/Library/${TARGET_PLATFORM}/")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}/../SMArtInt/Resources/Library/${TARGET_PLATFORM}/")


################################################################################
# Sub-projects
################################################################################
if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64")
	add_subdirectory(${PROJECT_SOURCE_DIR}/SMArtInt)
endif()

add_subdirectory(${PROJECT_SOURCE_DIR}/../External/ClaRaDelay/CSource "ClaRaDelay")
