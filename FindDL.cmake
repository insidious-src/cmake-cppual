find_package(PackageHandleStandardArgs)

set(DL_LIBRARIES dl psapi)

if(DEFINED ANDROID)
    set(DL_INCLUDE_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/")
    set(DL_LIBRARY_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/lib/${ANDROID_TOOLCHAIN_MACHINE_NAME}/${ANDROID_NATIVE_API_LEVEL}")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(DL_INCLUDE_HINT_PATH "/usr/${TOOLCHAIN_PREFIX}")
    set(DL_LIBRARY_HINT_PATH "/usr/${TOOLCHAIN_PREFIX}")
else()
    set(DL_INCLUDE_HINT_PATH "/usr")
    set(DL_LIBRARY_HINT_PATH "/usr")
endif()

find_path(DL_INCLUDE_DIR
        NAMES
                dlfcn.h libloaderapi.h
        HINTS
                ${DL_INCLUDE_HINT_PATH}
        PATH_SUFFIXES
                include
        )

if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        find_library(DL_LIBRARY
                NAMES
                        ${DL_LIBRARIES}
                HINTS
                        ${DL_LIBRARY_HINT_PATH}
                PATH_SUFFIXES
                        bin lib32
                )
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
        find_library(DL_LIBRARY
                NAMES
                        ${DL_LIBRARIES}
                HINTS
                        ${DL_LIBRARY_HINT_PATH}
                PATH_SUFFIXES
                        bin lib lib64 lib/aarch64-linux-gnu
                )
endif()

find_package_handle_standard_args(DL REQUIRED_VARS DL_LIBRARY DL_INCLUDE_DIR)

if(DL_FOUND AND NOT TARGET DL::Library)
        add_library(DL::Library UNKNOWN IMPORTED)
        set_target_properties(DL::Library PROPERTIES
                IMPORTED_LOCATION "${DL_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${DL_INCLUDE_DIR}"
                )
endif()

mark_as_advanced(DL_LIBRARY DL_INCLUDE_DIR)
