find_package(PackageHandleStandardArgs)

set(OPENCL_VERSION_STRING "0.1.0")
set(OPENCL_VERSION_MAJOR 0)
set(OPENCL_VERSION_MINOR 1)
set(OPENCL_VERSION_PATCH 0)

if(DEFINED ANDROID)
    set(OPENCL_INCLUDE_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/")
    set(OPENCL_LIBRARY_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/lib/${ANDROID_TOOLCHAIN_MACHINE_NAME}/${ANDROID_NATIVE_API_LEVEL}")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(OPENCL_INCLUDE_HINT_PATH "/usr/${TOOLCHAIN_PREFIX}")
    set(OPENCL_LIBRARY_HINT_PATH "/usr/${TOOLCHAIN_PREFIX}")
else()
    set(OPENCL_INCLUDE_HINT_PATH "/usr")
    set(OPENCL_LIBRARY_HINT_PATH "/usr")
endif()

find_path(OPENCL_INCLUDE_DIR
  NAMES
    CL/cl.h OpenCL/cl.h
  PATHS
    ${OPENCL_INCLUDE_HINT_PATH}
    ENV AMDAPPSDKROOT
    ENV INTELOCLSDKROOT
    ENV NVSDKCOMPUTE_ROOT
    ENV CUDA_PATH
    ENV ATISTREAMSDKROOT
  PATH_SUFFIXES
    include
    OpenCL/common/inc
    "AMD APP/include"
  NO_DEFAULT_PATH
  )

find_path(_OPENCL_CPP_INCLUDE_DIR CL/cl.hpp OpenCL/cl.hpp DOC "Include for OpenCL CPP bindings"
        PATHS ${OPENCL_INCLUDE_DIR})

if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    find_library(OPENCL_LIBRARY
      NAMES OpenCL
      HINTS
        ${OPENCL_LIBRARY_HINT_PATH}
        ENV AMDAPPSDKROOT
        ENV INTELOCLSDKROOT
        ENV CUDA_PATH
        ENV NVSDKCOMPUTE_ROOT
        ENV ATISTREAMSDKROOT
      PATH_SUFFIXES
        "AMD APP/lib/x86"
        bin
        lib32
        lib
        lib/x86
        lib/Win32
        lib/arm-linux-gnueabihf
        OpenCL/common/lib/Win32
      NO_DEFAULT_PATH
      )
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
    find_library(OPENCL_LIBRARY
      NAMES OpenCL
      HINTS
        ${OPENCL_LIBRARY_HINT_PATH}
        ENV AMDAPPSDKROOT
        ENV INTELOCLSDKROOT
        ENV CUDA_PATH
        ENV NVSDKCOMPUTE_ROOT
        ENV ATISTREAMSDKROOT
      PATH_SUFFIXES
        "AMD APP/lib/x86_64"
        bin
        lib
        lib64
        lib/x86_64-linux-gnu
        lib/aarch64-linux-gnu
        lib/x86_64
        lib/x64
        OpenCL/common/lib/x64
      NO_DEFAULT_PATH
      )
endif()

find_package_handle_standard_args(OpenCL REQUIRED_VARS OPENCL_LIBRARY OPENCL_INCLUDE_DIR)

if(_OPENCL_CPP_INCLUDE_DIR)
                set(OPENCL_HAS_CPP_BINDINGS TRUE)
endif(_OPENCL_CPP_INCLUDE_DIR)

if(OPENCL_FOUND AND NOT TARGET OpenCL::Library)
        add_library(OpenCL::Library UNKNOWN IMPORTED)
        set_target_properties(OpenCL::Library PROPERTIES
                IMPORTED_LOCATION "${OPENCL_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${OPENCL_INCLUDE_DIR}"
                )
endif()

mark_as_advanced(OPENCL_LIBRARY OPENCL_INCLUDE_DIR)
