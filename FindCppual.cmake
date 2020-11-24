find_package(PackageHandleStandardArgs)

find_path(CPPUAL_INCLUDE_DIR
                        NAMES
                            cppual/decl.h
                        PATH_SUFFIXES
                            include
                        PATHS
                            ${CMAKE_CURRENT_SOURCE_DIR}/../cppual
            )
            
find_path(CPPUAL_LIBRARIES_DIR
    NAMES
        libcppual-host.so cppual-host.dll cppual-host
    PATHS
        ${CMAKE_CURRENT_SOURCE_DIR}/../cppual/bin/${CMAKE_BUILD_TYPE}/${CMAKE_SYSTEM_NAME}-${CMAKE_CXX_COMPILER_ID}-${CMAKE_SYSTEM_PROCESSOR}
        ${CMAKE_CURRENT_SOURCE_DIR}/../build-cppual-Desktop-${CMAKE_BUILD_TYPE}
    )

find_package_handle_standard_args(Cppual REQUIRED_VARS CPPUAL_LIBRARIES_DIR CPPUAL_INCLUDE_DIR)
mark_as_advanced(CPPUAL_LIBRARIES_DIR CPPUAL_INCLUDE_DIR)
