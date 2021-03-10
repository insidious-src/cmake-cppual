find_package(PackageHandleStandardArgs)

set(WMEWMH_HEADER_FILES  xcb/xcb_ewmh.h)
set(WMEWMH_LIBRARY_NAMES xcb-ewmh)

set(WMEWMH_INCLUDE_HINT_PATH "/usr")
set(WMEWMH_LIBRARY_HINT_PATH "/usr")

find_path(WMEWMH_INCLUDE_DIR
        NAMES
                ${WMEWMH_HEADER_FILES}
        HINTS
                ${WMEWMH_INCLUDE_HINT_PATH}
        PATHS
                ${CMAKE_SOURCE_DIR}
        PATH_SUFFIXES
                include
        NO_DEFAULT_PATH
        )

    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
            find_library(WMEWMH_LIBRARY
                NAMES
                        ${WMEWMH_LIBRARY_NAMES}
                PATH_SUFFIXES
                        lib32 lib
                )
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
            find_library(WMEWMH_LIBRARY
                NAMES
                        ${WMEWMH_LIBRARY_NAMES}
                PATH_SUFFIXES
                        lib lib64
                )
    endif()

find_package_handle_standard_args(WMEwmh REQUIRED_VARS WMEWMH_LIBRARY WMEWMH_INCLUDE_DIR)

if(WMEWMH_FOUND AND NOT TARGET WMEwmh::Library)
                add_library(WMEwmh::Library UNKNOWN IMPORTED)
                set_target_properties(WMEwmh::Library PROPERTIES
                                IMPORTED_LOCATION "${WMEWMH_LIBRARY}"
                                INTERFACE_INCLUDE_DIRECTORIES "${WM_INCLUDE_DIR}"
                                )
endif()

mark_as_advanced(WMEWMH_LIBRARY WMEWMH_INCLUDE_DIR)
