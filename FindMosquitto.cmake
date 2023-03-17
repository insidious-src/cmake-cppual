find_package(PackageHandleStandardArgs)

set(HEADER_FILES  mosquitto.h mosquitto_plugin.h mosquitto/mosquitto_plugin.h)
set(LIBRARY_NAMES mosquitto)

if(ANDROID)
    find_path(MOSQUITTO_INCLUDE_DIRS
              NAMES ${HEADER_FILES}
              HINTS "/opt/android-mosquitto"
              PATH_SUFFIXES include
              )

    find_library(MOSQUITTO_LIBRARY
                NAMES ${LIBRARY_NAMES}
                HINTS "/opt/android-mosquitto"
                PATH_SUFFIXES lib
                )
    find_library(MOSQUITTO_LIBRARY_CPP
                NAMES mosquittopp
                HINTS "/opt/android-mosquitto"
                PATH_SUFFIXES lib
                )
else()
    find_path(MOSQUITTO_INCLUDE_DIRS
              NAMES ${HEADER_FILES}
              PATHS "C:/Program Files/mosquitto"
              "C:/Program Files (x86)/mosquitto"
              "/usr/x86_64-w64-mingw32"
              PATH_SUFFIXES devel include
              )

    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
            find_library(MOSQUITTO_LIBRARY
                        NAMES ${LIBRARY_NAMES}
                        PATHS "C:/Program Files/mosquitto"
                        "/usr/i686-w64-mingw32"
                        PATH_SUFFIXES lib32 lib bin
                        )
            find_library(MOSQUITTO_LIBRARY_CPP
                    NAMES mosquittopp
                    PATHS "C:/Program Files/mosquitto"
                    "/usr/i686-w64-mingw32"
                    PATH_SUFFIXES lib32 lib bin
                    )
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
            find_library(MOSQUITTO_LIBRARY
                        NAMES ${LIBRARY_NAMES}
                        PATHS "C:/Program Files/mosquitto"
                        "C:/Program Files (x86)/mosquitto"
                        "/usr/x86_64-w64-mingw32"
                        PATH_SUFFIXES bin lib64 lib lib/x86_64-linux-gnu lib/aarch64-linux-gnu
                        )
            find_library(MOSQUITTO_LIBRARY_CPP
                    NAMES mosquittopp
                    PATHS "C:/Program Files/mosquitto"
                    "C:/Program Files (x86)/mosquitto"
                    "/usr/x86_64-w64-mingw32"
                    PATH_SUFFIXES bin lib64 lib lib/x86_64-linux-gnu lib/aarch64-linux-gnu
                    )
    endif()
endif()

#find_package_handle_standard_args(Mosquitto REQUIRED_VARS MOSQUITTO_LIBRARY MOSQUITTO_LIBRARY_CPP MOSQUITTO_INCLUDE_DIRS)
find_package_handle_standard_args(Mosquitto REQUIRED_VARS MOSQUITTO_LIBRARY MOSQUITTO_INCLUDE_DIRS)

if(MOSQUITTO_FOUND AND NOT TARGET Mosquitto::Library)
        add_library(Mosquitto::Library UNKNOWN IMPORTED)
        set_target_properties(Mosquitto::Library PROPERTIES
                IMPORTED_LOCATION "${MOSQUITTO_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${MOSQUITTO_INCLUDE_DIRS}"
                )
endif()

if(MOSQUITTO_FOUND AND NOT TARGET Mosquitto::LibraryCpp)
        add_library(Mosquitto::LibraryCpp UNKNOWN IMPORTED)
        set_target_properties(Mosquitto::LibraryCpp PROPERTIES
                IMPORTED_LOCATION "${MOSQUITTO_LIBRARY_CPP}"
                INTERFACE_INCLUDE_DIRECTORIES "${MOSQUITTO_INCLUDE_DIRS}"
                )
endif()

mark_as_advanced(MOSQUITTO_LIBRARY MOSQUITTO_LIBRARY_CPP MOSQUITTO_INCLUDE_DIRS)
