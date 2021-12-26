find_package(PackageHandleStandardArgs)

set(HEADER_FILES  android/native_window.h wayland-client-protocol.h winuser.h)
set(LIBRARY_NAMES android wayland-client user32)

if(DEFINED ANDROID)
    set(WM_INCLUDE_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/")
    set(WM_LIBRARY_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/lib/${ANDROID_TOOLCHAIN_MACHINE_NAME}/${ANDROID_NATIVE_API_LEVEL}")
else()
    set(WM_INCLUDE_HINT_PATH "/usr")
    set(WM_LIBRARY_HINT_PATH "/usr")
endif()

find_path(WM_INCLUDE_DIR
        NAMES
                ${HEADER_FILES}
        HINTS
                ${WM_INCLUDE_HINT_PATH}
        PATHS
                ${CMAKE_SOURCE_DIR}
        PATH_SUFFIXES
                include
        )

if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        find_library(WM_LIBRARY
                        NAMES ${LIBRARY_NAMES}
                        HINTS ${WM_LIBRARY_HINT_PATH}
                        PATH_SUFFIXES lib32 lib
                        )
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
        find_library(WM_LIBRARY
                        NAMES ${LIBRARY_NAMES}
                        HINTS ${WM_LIBRARY_HINT_PATH}
                        PATH_SUFFIXES lib lib64
                        )
endif()

find_package_handle_standard_args(WM REQUIRED_VARS WM_LIBRARY WM_INCLUDE_DIR)

if(WM_FOUND AND NOT TARGET WM::Library)
        add_library(WM::Library UNKNOWN IMPORTED)
        set_target_properties(WM::Library PROPERTIES
                IMPORTED_LOCATION "${WM_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${WM_INCLUDE_DIR}"
                )
endif()

mark_as_advanced(WM_LIBRARY WM_INCLUDE_DIR)
