cmake_minimum_required(VERSION 3.3)

include(CMakeParseArguments)

function(add_custom_executable)
    cmake_parse_arguments(
        PARSED_ARGS # prefix of output variables
        "" # list of names of the boolean arguments (only defined ones will be true)
        "NAME" # list of names of mono-valued arguments
        "SRCS;DEPS" # list of names of multi-valued arguments (output variables are lists)
        ${ARGN} # arguments of the function to parse, here we take the all original ones
    )
    # note: if it remains unparsed arguments, here, they can be found in variable PARSED_ARGS_UNPARSED_ARGUMENTS
    if(NOT PARSED_ARGS_NAME)
        message(FATAL_ERROR "You must provide a name")
    endif(NOT PARSED_ARGS_NAME)

    set(TARGET_SRCS "")
    set(TARGET_DEPS "")

    foreach(src ${PARSED_ARGS_SRCS})
        list(APPEND TARGET_SRCS ${src})
    endforeach(src)

    foreach(dep ${PARSED_ARGS_DEPS})
        list(APPEND TARGET_DEPS ${dep})
    endforeach(dep)

    if(ANDROID)
        add_library(${PARSED_ARGS_NAME} ${TARGET_SRCS})
    else()
        add_executable(${PARSED_ARGS_NAME} ${TARGET_SRCS})
    endif()

    target_include_directories(${PARSED_ARGS_NAME}
        PUBLIC
            $<INSTALL_INTERFACE:include>
            $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
        PRIVATE
            ${CMAKE_CURRENT_LIST_DIR}/src
    )

    target_link_libraries(${PARSED_ARGS_NAME} ${TARGET_DEPS})

endfunction(add_custom_executable)

#================================================

function(add_custom_library)
    cmake_parse_arguments(
        PARSED_ARGS # prefix of output variables
        "" # list of names of the boolean arguments (only defined ones will be true)
        "NAME" # list of names of mono-valued arguments
        "SRCS;DEPS" # list of names of multi-valued arguments (output variables are lists)
        ${ARGN} # arguments of the function to parse, here we take the all original ones
    )
    # note: if it remains unparsed arguments, here, they can be found in variable PARSED_ARGS_UNPARSED_ARGUMENTS
    if(NOT PARSED_ARGS_NAME)
        message(FATAL_ERROR "You must provide a name")
    endif(NOT PARSED_ARGS_NAME)

    set(TARGET_SRCS "")
    set(TARGET_DEPS "")

    foreach(src ${PARSED_ARGS_SRCS})
        list(APPEND TARGET_SRCS ${src})
    endforeach(src)

    foreach(dep ${PARSED_ARGS_DEPS})
        list(APPEND TARGET_DEPS ${dep})
    endforeach(dep)

    if(IOS_PLATFORM)
        add_library(${PARSED_ARGS_NAME} STATIC ${TARGET_SRCS})
    else()
        add_library(${PARSED_ARGS_NAME} SHARED ${TARGET_SRCS})
    endif()

    target_include_directories(${PARSED_ARGS_NAME}
        PUBLIC
            $<INSTALL_INTERFACE:include>
            $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
        PRIVATE
            ${CMAKE_CURRENT_LIST_DIR}/src
    )

    if(NOT IOS_PLATFORM)
        target_link_libraries(${PARSED_ARGS_NAME} ${TARGET_DEPS})
    endif()

endfunction(add_custom_library)

#================================================

function(add_custom_module)
    cmake_parse_arguments(
        PARSED_ARGS # prefix of output variables
        "" # list of names of the boolean arguments (only defined ones will be true)
        "NAME" # list of names of mono-valued arguments
        "SRCS;DEPS" # list of names of multi-valued arguments (output variables are lists)
        ${ARGN} # arguments of the function to parse, here we take the all original ones
    )
    # note: if it remains unparsed arguments, here, they can be found in variable PARSED_ARGS_UNPARSED_ARGUMENTS
    if(NOT PARSED_ARGS_NAME)
        message(FATAL_ERROR "You must provide a name")
    endif(NOT PARSED_ARGS_NAME)

    set(TARGET_SRCS "")
    set(TARGET_DEPS "")

    foreach(src ${PARSED_ARGS_SRCS})
        list(APPEND TARGET_SRCS ${src})
    endforeach(src)

    foreach(dep ${PARSED_ARGS_DEPS})
        list(APPEND TARGET_DEPS ${dep})
    endforeach(dep)

    if(IOS_PLATFORM)
        add_library(${PARSED_ARGS_NAME} STATIC ${TARGET_SRCS})
    else()
        add_library(${PARSED_ARGS_NAME} MODULE ${TARGET_SRCS})
    endif()

    target_include_directories(${PARSED_ARGS_NAME}
        PUBLIC
            $<INSTALL_INTERFACE:include>
            $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
        PRIVATE
            ${CMAKE_CURRENT_LIST_DIR}/src
    )

    if(NOT IOS_PLATFORM)
        target_link_libraries(${PARSED_ARGS_NAME} ${TARGET_DEPS})
    endif()

endfunction(add_custom_module)
