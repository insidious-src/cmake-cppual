find_package(PackageHandleStandardArgs)

set(GL_HEADER_FILES GL/gl.h OpenGL/gl.h GLES3/gl3.h GLES2/gl2.h ES2/gl.h gl.h)
set(GL_LIBRARY_NAMES opengl32 GL GLESv3 GLESv2 OpenGLES.tbd)
set(GL_LIBRARY_NAMES64 opengl64 ${GL_LIBRARY_NAMES})

if(DEFINED ANDROID)
    set(GL_INCLUDE_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/")
    set(GL_LIBRARY_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/lib/${ANDROID_TOOLCHAIN_MACHINE_NAME}/${ANDROID_NATIVE_API_LEVEL}")
else()
    set(GL_INCLUDE_HINT_PATH "/")
    set(GL_LIBRARY_HINT_PATH "/")
endif()

find_path(GL_INCLUDE_DIR
          NAMES ${GL_HEADER_FILES}
          PATHS ${CMAKE_FIND_ROOT_PATH}
          HINTS ${GL_INCLUDE_HINT_PATH}
          PATH_SUFFIXES
            include
            Headers
            System/Library/Frameworks/OpenGLES.framework/Headers
            System/Library/Frameworks/OpenGL.framework/Headers
          )

if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        find_library(GL_LIBRARY
                     NAMES ${GL_LIBRARY_NAMES}
                     PATH_SUFFIXES
                        bin
                        usr/lib32
                        usr/lib
                        usr/lib/arm-linux-gnueabihf
                        system/lib
                        System/Library/Frameworks/OpenGLES.framework
                        System/Library/Frameworks/OpenGL.framework/Libraries
                     PATHS
                        ${GL_LIBRARY_HINT_PATH}
                        ${CMAKE_FIND_ROOT_PATH}
                     NO_DEFAULT_PATH
                     )
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
        find_library(GL_LIBRARY
                     NAMES ${GL_LIBRARY_NAMES64}
                     PATH_SUFFIXES
                        bin
                        usr/lib
                        usr/lib64
                        lib/x86_64-linux-gnu
                        usr/lib/aarch64-linux-gnu
                        system/lib
                        System/Library/Frameworks/OpenGLES.framework
                        System/Library/Frameworks/OpenGL.framework/Libraries
                     PATHS
                        ${GL_LIBRARY_HINT_PATH}
                        ${CMAKE_FIND_ROOT_PATH}
                     NO_DEFAULT_PATH
                     )
endif()

find_package_handle_standard_args(OpenGL REQUIRED_VARS GL_LIBRARY GL_INCLUDE_DIR)

if(OPENGL_FOUND AND NOT TARGET OpenGL::Library)
        add_library(OpenGL::Library UNKNOWN IMPORTED)
        set_target_properties(OpenGL::Library PROPERTIES
                IMPORTED_LOCATION "${GL_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${GL_INCLUDE_DIR}"
                )
endif()

mark_as_advanced(GL_LIBRARY GL_INCLUDE_DIR)
