find_package(PackageHandleStandardArgs)

if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".dll" ".DLL")
endif()

set(CRYPTO_LIBRARIES crypto_1_1 crypto-1_1-x64 crypto-1_1 crypto)
set(SSL_LIBRARIES ssl_1_1 ssl-1_1-x64 ssl-1_1 ssl)

if (ANDROID)
    add_subdirectory("${ANDROID_SDK}/android_openssl" "latest")

    if(ANDROID_ABI STREQUAL "arm64-v8a")
        if (CMAKE_BUILD_TYPE EQUAL "DEBUG")
            set(SSL_DIR "${ANDROID_SDK}/android_openssl/no-asm/latest/arm64")
        else()
            set(SSL_DIR "${ANDROID_SDK}/android_openssl/latest/arm64")
        endif()
    elseif(ANDROID_ABI STREQUAL "armeabi-v7a")
        if (CMAKE_BUILD_TYPE EQUAL "DEBUG")
            set(SSL_DIR "${ANDROID_SDK}/android_openssl/no-asm/latest/arm")
        else()
            set(SSL_DIR "${ANDROID_SDK}/android_openssl/latest/arm")
        endif()
    elseif(ANDROID_ABI STREQUAL "x86")
        if (CMAKE_BUILD_TYPE EQUAL "DEBUG")
            set(SSL_DIR "${ANDROID_SDK}/android_openssl/no-asm/latest/x86")
        else()
            set(SSL_DIR "${ANDROID_SDK}/android_openssl/latest/x86")
        endif()
    elseif(ANDROID_ABI STREQUAL "x86_64")
        if (CMAKE_BUILD_TYPE EQUAL "DEBUG")
            set(SSL_DIR "${ANDROID_SDK}/android_openssl/no-asm/latest/x86_64")
        else()
            set(SSL_DIR "${ANDROID_SDK}/android_openssl/latest/x86_64")
        endif()
    endif()
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(SSL_DIR "/usr/${TOOLCHAIN_PREFIX}")
else()
    set(SSL_DIR "/usr")
endif()

if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        find_library(CRYPTO_LIBRARY
                NAMES
                        ${CRYPTO_LIBRARIES}
                PATHS
                        ${SSL_DIR}
                PATH_SUFFIXES
                        bin lib32 lib
                NO_DEFAULT_PATH
                )

        find_library(SSL_LIBRARY
                NAMES
                        ${SSL_LIBRARIES}
                PATHS
                        ${SSL_DIR}
                PATH_SUFFIXES
                        bin lib32 lib
                NO_DEFAULT_PATH
                )
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
        find_library(CRYPTO_LIBRARY
                NAMES
                        ${CRYPTO_LIBRARIES}
                PATHS
                        ${SSL_DIR}
                PATH_SUFFIXES
                        bin lib lib64
                NO_DEFAULT_PATH
                )

        find_library(SSL_LIBRARY
                NAMES
                        ${SSL_LIBRARIES}
                PATHS
                        ${SSL_DIR}
                PATH_SUFFIXES
                        bin lib lib64
                NO_DEFAULT_PATH
                )
endif()

find_package_handle_standard_args(SSL REQUIRED_VARS CRYPTO_LIBRARY SSL_LIBRARY)

if(SSL_FOUND AND NOT TARGET Crypto::Library)
        add_library(Crypto::Library UNKNOWN IMPORTED)
        set_target_properties(Crypto::Library PROPERTIES
                IMPORTED_LOCATION "${CRYPTO_LIBRARY}"
                )
endif()

if(SSL_FOUND AND NOT TARGET SSL::Library)
        add_library(SSL::Library UNKNOWN IMPORTED)
        set_target_properties(SSL::Library PROPERTIES
                IMPORTED_LOCATION "${SSL_LIBRARY}"
                )
endif()

mark_as_advanced(CRYPTO_LIBRARY SSL_LIBRARY)