find_package(PackageHandleStandardArgs)

set(HEADER_FILES    AL/al.h OpenAL/al.h)
set(LIBRARY_NAMES   OpenAL32 soft_oal openal OpenAL al)
set(LIBRARY_NAMES64 OpenAL64 OpenAL32 soft_oal openal OpenAL al)

if(DEFINED ANDROID)
    set(OPENAL_INCLUDE_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/")
    set(OPENAL_LIBRARY_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/lib/${ANDROID_TOOLCHAIN_MACHINE_NAME}/${ANDROID_NATIVE_API_LEVEL}")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(RT_INCLUDE_HINT_PATH "/usr/${TOOLCHAIN_PREFIX}")
    set(RT_LIBRARY_HINT_PATH "/usr/${TOOLCHAIN_PREFIX}")
else()
    set(OPENAL_INCLUDE_HINT_PATH "/usr")
    set(OPENAL_LIBRARY_HINT_PATH "/usr")
endif()

find_path(OPENAL_INCLUDE_DIR NAMES ${HEADER_FILES}
  HINTS
    ${OPENAL_INCLUDE_HINT_PATH}
    ENV OPENALDIR
  PATH_SUFFIXES include
  PATHS
    ${CMAKE_SOURCE_DIR}
    ~/Library/Frameworks
    /Library/Frameworks
    /sw # Fink
    /opt/local # DarwinPorts
    /opt/csw # Blastwave
    /opt
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Creative\ Labs\\OpenAL\ 1.1\ Software\ Development\ Kit\\1.00.0000;InstallDir]
)
if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    find_library(OPENAL_LIBRARY
        NAMES ${LIBRARY_NAMES}
        HINTS
            ${OPENAL_LIBRARY_HINT_PATH}
            ENV OPENALDIR
        PATH_SUFFIXES bin lib32 lib lib/Win32 libs/Win32
        PATHS
        ${OPENAL_LIBRARY_HINT_PATH}
        ${CMAKE_FIND_ROOT_PATH}
        ${CMAKE_SOURCE_DIR}
        ~/Library/Frameworks
        /Library/Frameworks
        /sw
        /opt/local
        /opt/csw
        /opt
        [HKEY_LOCAL_MACHINE\\SOFTWARE\\Creative\ Labs\\OpenAL\ 1.1\ Software\ Development\ Kit\\1.00.0000;InstallDir]
        )
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
    find_library(OPENAL_LIBRARY
        NAMES ${LIBRARY_NAMES64}
        HINTS
            ${OPENAL_LIBRARY_HINT_PATH}
            ENV OPENALDIR
        PATH_SUFFIXES bin lib lib64 lib/Win64 libs/Win64
        PATHS
        ${OPENAL_LIBRARY_HINT_PATH}
        ${CMAKE_FIND_ROOT_PATH}
        ${CMAKE_SOURCE_DIR}
        ~/Library/Frameworks
        /Library/Frameworks
        /sw
        /opt/local
        /opt/csw
        /opt
        [HKEY_LOCAL_MACHINE\\SOFTWARE\\Creative\ Labs\\OpenAL\ 1.1\ Software\ Development\ Kit\\1.00.0000;InstallDir]
        )
endif()

find_package_handle_standard_args(OpenAL REQUIRED_VARS OPENAL_LIBRARY OPENAL_INCLUDE_DIR)

if(OPENAL_FOUND AND NOT TARGET OpenAL::Library)
    add_library(OpenAL::Library UNKNOWN IMPORTED)
    set_target_properties(OpenAL::Library PROPERTIES
        IMPORTED_LOCATION "${OPENAL_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${OPENAL_INCLUDE_DIR}"
        )
endif()

mark_as_advanced(OPENAL_LIBRARY OPENAL_INCLUDE_DIR)
