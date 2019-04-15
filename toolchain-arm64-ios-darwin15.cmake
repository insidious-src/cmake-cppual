set (CMAKE_SYSTEM_NAME Darwin)

# specify the cross compiler
set (CMAKE_C_COMPILER o64-clang)
set (CMAKE_CXX_COMPILER o64-clang++)

# where is the target environment
set (CMAKE_FIND_ROOT_PATH /opt/osxcross/SDK/iPhoneOS9.3.sdk)

# search for programs in the build host directories
set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Make sure Qt can be detected by CMake
#set (QT_BINARY_DIR /opt/osxcross/bin /opt/osxcross/x86_64-apple-darwin15/lib/qt/bin)
#set (QT_INCLUDE_DIRS_NO_SYSTEM ON)

set (CMAKE_AR:FILEPATH x86_64-apple-darwin15-ar)
set (CMAKE_RANLIB:FILEPATH x86_64-apple-darwin15-ranlib)

include_directories(BEFORE SYSTEM
    /opt/osxcross/SDK/iPhoneOS9.3.sdk/usr/include/
    /opt/osxcross/SDK/iPhoneOS9.3.sdk/usr/include/c++/v1
    )
