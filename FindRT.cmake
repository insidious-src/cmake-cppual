find_package(PackageHandleStandardArgs)

set(RT_LIBRARIES rt)

if(DEFINED ANDROID)
    set(RT_INCLUDE_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/")
    set(RT_LIBRARY_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/lib/${ANDROID_TOOLCHAIN_MACHINE_NAME}/${ANDROID_NATIVE_API_LEVEL}")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(RT_INCLUDE_HINT_PATH "/usr/${TOOLCHAIN_PREFIX}")
    set(RT_LIBRARY_HINT_PATH "/usr/${TOOLCHAIN_PREFIX}")
else()
    set(RT_INCLUDE_HINT_PATH "/usr")
    set(RT_LIBRARY_HINT_PATH "/usr")
endif()

find_path(RT_INCLUDE_DIR
        NAMES
                sys/mman.h
        HINTS
                ${RT_INCLUDE_HINT_PATH}
        PATH_SUFFIXES
                include
        )

if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        find_library(RT_LIBRARY
                NAMES
                        ${RT_LIBRARIES}
                HINTS
                        ${RT_LIBRARY_HINT_PATH}
                PATH_SUFFIXES
                        bin lib32
                )
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
        find_library(RT_LIBRARY
                NAMES
                        ${RT_LIBRARIES}
                HINTS
                        ${RT_LIBRARY_HINT_PATH}
                PATH_SUFFIXES
                        bin lib lib64
                )
endif()

find_package_handle_standard_args(RT REQUIRED_VARS RT_LIBRARY RT_INCLUDE_DIR)

if(RT_FOUND AND NOT TARGET RT::Library)
        add_library(RT::Library UNKNOWN IMPORTED)
        set_target_properties(RT::Library PROPERTIES
                IMPORTED_LOCATION "${RT_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${RT_INCLUDE_DIR}"
                )
endif()

mark_as_advanced(RT_LIBRARY RT_INCLUDE_DIR)
