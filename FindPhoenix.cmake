find_package(PackageHandleStandardArgs)

find_path(PHOENIX_INCLUDE_DIR
                        NAMES
                            phoenix/root.h
                        PATH_SUFFIXES
                            include
                        PATHS
                            ${CMAKE_CURRENT_SOURCE_DIR}/../phoenix
            )

find_path(PHOENIX_LIBRARIES_DIR
    NAMES
        libphnx-core.so phnx-core.dll phnx-core
    PATHS
        ${CMAKE_CURRENT_SOURCE_DIR}/../phoenix/bin/${CMAKE_BUILD_TYPE}/${CMAKE_SYSTEM_NAME}-${CMAKE_CXX_COMPILER_ID}-${CMAKE_SYSTEM_PROCESSOR}
        ${CMAKE_CURRENT_SOURCE_DIR}/../build-phoenix-Desktop-${CMAKE_BUILD_TYPE}
    )

find_package_handle_standard_args(Phoenix REQUIRED_VARS PHOENIX_LIBRARIES_DIR PHOENIX_INCLUDE_DIR)
mark_as_advanced(PHOENIX_LIBRARIES_DIR PHOENIX_INCLUDE_DIR)
