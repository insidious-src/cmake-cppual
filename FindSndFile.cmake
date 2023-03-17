find_package(PackageHandleStandardArgs)

set(HEADER_FILES  sndfile.h)
set(LIBRARY_NAMES sndfile-1 sndfile)

if(DEFINED ANDROID)
    set(SNDFILE_INCLUDE_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/")
    set(SNDFILE_LIBRARY_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/lib/${ANDROID_TOOLCHAIN_MACHINE_NAME}/${ANDROID_NATIVE_API_LEVEL}")
else()
    set(SNDFILE_INCLUDE_HINT_PATH "/usr")
    set(SNDFILE_LIBRARY_HINT_PATH "/usr")
endif()

find_path(SNDFILE_INCLUDE_DIR
    NAMES ${HEADER_FILES}
    PATH_SUFFIXES include
    HINTS ${SNDFILE_INCLUDE_HINT_PATH}
    PATHS ${CMAKE_SOURCE_DIR}
    )

if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    find_library(SNDFILE_LIBRARY
            NAMES ${LIBRARY_NAMES}
            PATH_SUFFIXES bin lib32 lib
            PATHS
            ${SNDFILE_LIBRARY_HINT_PATH}
            ${CMAKE_FIND_ROOT_PATH}
            ${CMAKE_SOURCE_DIR}
            NO_DEFAULT_PATH
            )
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
    find_library(SNDFILE_LIBRARY
            NAMES ${LIBRARY_NAMES}
            PATH_SUFFIXES bin lib lib64 lib/x86_64-linux-gnu lib/aarch64-linux-gnu
            PATHS
            ${SNDFILE_LIBRARY_HINT_PATH}
            ${CMAKE_FIND_ROOT_PATH}
            ${CMAKE_SOURCE_DIR}
            NO_DEFAULT_PATH
            )
endif()

find_package_handle_standard_args(SndFile REQUIRED_VARS SNDFILE_LIBRARY SNDFILE_INCLUDE_DIR)

if(SNDFILE_FOUND AND NOT TARGET SndFile::Library)
        add_library(SndFile::Library UNKNOWN IMPORTED)
    set_target_properties(SndFile::Library PROPERTIES
        IMPORTED_LOCATION "${SNDFILE_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${SNDFILE_INCLUDE_DIR}"
        )
endif()

mark_as_advanced(SNDFILE_LIBRARY SNDFILE_INCLUDE_DIR)
