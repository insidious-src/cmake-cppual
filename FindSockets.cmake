find_package(PackageHandleStandardArgs)

set(HEADER_FILES  winsock.h winsock2.h arpa/inet.h sys/socket.h)
set(LIBRARY_NAMES ws2_32 wsock32 rt c)

if(DEFINED ANDROID)
    set(SOCKETS_INCLUDE_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/")
    set(SOCKETS_LIBRARY_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/lib/${ANDROID_TOOLCHAIN_MACHINE_NAME}/${ANDROID_NATIVE_API_LEVEL}")
else()
    set(SOCKETS_INCLUDE_HINT_PATH "/")
    set(SOCKETS_LIBRARY_HINT_PATH "/")
endif()

find_path(SOCKETS_INCLUDE_DIR NAMES ${HEADER_FILES})

if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        find_library(SOCKETS_LIBRARY
                     NAMES ${LIBRARY_NAMES}
                     HINTS ${SOCKETS_LIBRARY_HINT_PATH}
                     PATHS ${CMAKE_FIND_ROOT_PATH}
                     PATH_SUFFIXES 
                         usr/lib32
                         usr/lib 
                         usr/lib/arm-linux-gnueabihf
                         system/lib
                     NO_DEFAULT_PATH
                     )
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
        find_library(SOCKETS_LIBRARY
                     NAMES ${LIBRARY_NAMES}
                     HINTS ${SOCKETS_LIBRARY_HINT_PATH}
                     PATHS ${CMAKE_FIND_ROOT_PATH}
                     PATH_SUFFIXES 
                         usr/lib 
                         usr/lib64 
                         usr/lib/x86_64-linux-gnu 
                         usr/lib/aarch64-linux-gnu
                         system/lib
                     NO_DEFAULT_PATH
                     )
endif()

find_package_handle_standard_args(Sockets REQUIRED_VARS SOCKETS_LIBRARY SOCKETS_INCLUDE_DIR)

if(SOCKETS_FOUND AND NOT TARGET Sockets::Library)
        add_library(Sockets::Library UNKNOWN IMPORTED)
        set_target_properties(Sockets::Library PROPERTIES
                IMPORTED_LOCATION "${SOCKETS_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${SOCKETS_INCLUDE_DIR}"
                )
endif()

mark_as_advanced(SOCKETS_LIBRARY SOCKETS_INCLUDE_DIR)
