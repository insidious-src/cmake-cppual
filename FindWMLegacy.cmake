find_package(PackageHandleStandardArgs)

set(WMLEGACY_HEADER_FILES  xcb/xcb_icccm.h)
set(WMLEGACY_LIBRARY_NAMES xcb-icccm)

set(WMLEGACY_INCLUDE_HINT_PATH "/usr")
set(WMLEGACY_LIBRARY_HINT_PATH "/usr")

find_path(WMLEGACY_INCLUDE_DIR
        NAMES
                ${WMLEGACY_HEADER_FILES}
        HINTS
                ${WMLEGACY_INCLUDE_HINT_PATH}
        PATHS
                ${CMAKE_SOURCE_DIR}
        PATH_SUFFIXES
                include
        NO_DEFAULT_PATH
        )

    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
            find_library(WMLEGACY_LIBRARY
                NAMES
                        ${WMLEGACY_LIBRARY_NAMES}
                PATH_SUFFIXES
                        lib32 lib
                )
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
            find_library(WMLEGACY_LIBRARY
                NAMES
                        ${LIBRARY_NAMES}
                PATH_SUFFIXES
                        lib lib64
                )
    endif()

find_package_handle_standard_args(WMLegacy REQUIRED_VARS WMLEGACY_LIBRARY WMLEGACY_INCLUDE_DIR)

if(WMLEGACY_FOUND AND NOT TARGET WMLegacy::Library)
                add_library(WMLegacy::Library UNKNOWN IMPORTED)
                set_target_properties(WMLegacy::Library PROPERTIES
                                IMPORTED_LOCATION "${WM_LEGACY_LIBRARY}"
                                INTERFACE_INCLUDE_DIRECTORIES "${WM_INCLUDE_DIR}"
                                )
endif()

mark_as_advanced(WMLEGACY_LIBRARY WMLEGACY_INCLUDE_DIR)
