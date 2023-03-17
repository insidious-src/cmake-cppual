find_package(PackageHandleStandardArgs)

set(X11_HEADER_FILES  X11/Xlib-xcb.h)
set(X11_LIBRARY_NAMES X11-xcb)

set(X11_INCLUDE_HINT_PATH "/usr")
set(X11_LIBRARY_HINT_PATH "/usr")

find_path(X11_INCLUDE_DIR
        NAMES
                ${X11_HEADER_FILES}
        HINTS
                ${X11_INCLUDE_HINT_PATH}
        PATHS
                ${CMAKE_SOURCE_DIR}
        PATH_SUFFIXES
                include
        NO_DEFAULT_PATH
        )

    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
            find_library(X11_LIBRARY
                NAMES
                        ${X11_LIBRARY_NAMES}
                PATH_SUFFIXES
                        lib32 lib
                )
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
            find_library(X11_LIBRARY
                NAMES
                        ${X11_LIBRARY_NAMES}
                PATH_SUFFIXES
                        lib lib64 lib/x86_64-linux-gnu lib/aarch64-linux-gnu
                )
    endif()

find_package_handle_standard_args(X11 REQUIRED_VARS X11_LIBRARY X11_INCLUDE_DIR)

if(X11_FOUND AND NOT TARGET X11::Library)
                add_library(X11::Library UNKNOWN IMPORTED)
                set_target_properties(X11::Library PROPERTIES
                                IMPORTED_LOCATION "${X11_LIBRARY}"
                                INTERFACE_INCLUDE_DIRECTORIES "${X11_INCLUDE_DIR}"
                                )
endif()

mark_as_advanced(X11_LIBRARY X11_INCLUDE_DIR)
