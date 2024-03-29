if(DEFINED ANDROID)
    set(FREETYPE_INCLUDE_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/")
    set(FREETYPE_LIBRARY_HINT_PATH
        "${ANDROID_TOOLCHAIN_ROOT}/sysroot/usr/lib/${ANDROID_TOOLCHAIN_MACHINE_NAME}/${ANDROID_NATIVE_API_LEVEL}")
else()
    set(FREETYPE_LIBRARY_HINT_PATH "/usr")
    set(FREETYPE_LIBRARY_HINT_PATH "/usr")
endif()

set(FREETYPE_FIND_ARGS
  PATHS
    ENV GTKMM_BASEPATH
    [HKEY_CURRENT_USER\\SOFTWARE\\gtkmm\\2.4;Path]
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\gtkmm\\2.4;Path]
)

find_path(
  FREETYPE_INCLUDE_DIR_ft2build
  ft2build.h
  ${FREETYPE_FIND_ARGS}
  HINTS
    ${SNDFILE_INCLUDE_HINT_PATH}
    ENV FREETYPE_DIR
  PATH_SUFFIXES
    include/freetype2
    include
    freetype2
)

find_path(
  FREETYPE_INCLUDE_DIR_freetype2
  NAMES
    freetype/config/ftheader.h
    config/ftheader.h
  ${FREETYPE_FIND_ARGS}
  HINTS
    ${SNDFILE_INCLUDE_HINT_PATH}
    ENV FREETYPE_DIR
  PATH_SUFFIXES
    include/freetype2
    include
    freetype2
)

if(NOT FREETYPE_LIBRARY)
  find_library(FREETYPE_LIBRARY_RELEASE
    NAMES
      freetype-6
      freetype6
      freetype
      libfreetype
      freetype219
    ${FREETYPE_FIND_ARGS}
    HINTS
      ${SNDFILE_LIBRARY_HINT_PATH}
      ENV FREETYPE_DIR
    PATH_SUFFIXES
      lib
      lib/x86_64-linux-gnu
      lib/aarch64-linux-gnu
      lib/arm-linux-gnueabihf
  )
  find_library(FREETYPE_LIBRARY_DEBUG
    NAMES
      freetype-6
      freetype6
      freetype
      freetyped
      libfreetyped
      freetype219d
    ${FREETYPE_FIND_ARGS}
    HINTS
      ${SNDFILE_LIBRARY_HINT_PATH}
      ENV FREETYPE_DIR
    PATH_SUFFIXES
      lib
      lib/x86_64-linux-gnu
      lib/aarch64-linux-gnu
      lib/arm-linux-gnueabihf
  )
  include(SelectLibraryConfigurations)
  select_library_configurations(FREETYPE)
else()
  # on Windows, ensure paths are in canonical format (forward slahes):
  file(TO_CMAKE_PATH "${FREETYPE_LIBRARY}" FREETYPE_LIBRARY)
endif()

unset(FREETYPE_FIND_ARGS)

# set the user variables
if(FREETYPE_INCLUDE_DIR_ft2build AND FREETYPE_INCLUDE_DIR_freetype2)
  set(FREETYPE_INCLUDE_DIRS "${FREETYPE_INCLUDE_DIR_ft2build};${FREETYPE_INCLUDE_DIR_freetype2}")
  list(REMOVE_DUPLICATES FREETYPE_INCLUDE_DIRS)
endif()
set(FREETYPE_LIBRARIES "${FREETYPE_LIBRARY}")

if(EXISTS "${FREETYPE_INCLUDE_DIR_freetype2}/freetype/freetype.h")
  set(FREETYPE_H "${FREETYPE_INCLUDE_DIR_freetype2}/freetype/freetype.h")
elseif(EXISTS "${FREETYPE_INCLUDE_DIR_freetype2}/freetype.h")
  set(FREETYPE_H "${FREETYPE_INCLUDE_DIR_freetype2}/freetype.h")
endif()

if(FREETYPE_INCLUDE_DIR_freetype2 AND FREETYPE_H)
  file(STRINGS "${FREETYPE_H}" freetype_version_str
       REGEX "^#[\t ]*define[\t ]+FREETYPE_(MAJOR|MINOR|PATCH)[\t ]+[0-9]+$")

  unset(FREETYPE_VERSION_STRING)
  foreach(VPART MAJOR MINOR PATCH)
    foreach(VLINE ${freetype_version_str})
      if(VLINE MATCHES "^#[\t ]*define[\t ]+FREETYPE_${VPART}[\t ]+([0-9]+)$")
        set(FREETYPE_VERSION_PART "${CMAKE_MATCH_1}")
        if(FREETYPE_VERSION_STRING)
          string(APPEND FREETYPE_VERSION_STRING ".${FREETYPE_VERSION_PART}")
        else()
          set(FREETYPE_VERSION_STRING "${FREETYPE_VERSION_PART}")
        endif()
        unset(FREETYPE_VERSION_PART)
      endif()
    endforeach()
  endforeach()
endif()

find_package(PackageHandleStandardArgs)

find_package_handle_standard_args(
  Freetype
  REQUIRED_VARS
    FREETYPE_LIBRARY
    FREETYPE_INCLUDE_DIRS
  VERSION_VAR
    FREETYPE_VERSION_STRING
)

mark_as_advanced(
  FREETYPE_INCLUDE_DIR_freetype2
  FREETYPE_INCLUDE_DIR_ft2build
)

if(Freetype_FOUND)
  if(NOT TARGET Freetype::Library)
    add_library(Freetype::Library UNKNOWN IMPORTED)
    set_target_properties(Freetype::Library PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${FREETYPE_INCLUDE_DIRS}")

    if(FREETYPE_LIBRARY_RELEASE)
      set_property(TARGET Freetype::Library APPEND PROPERTY
        IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(Freetype::Library PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
        IMPORTED_LOCATION_RELEASE "${FREETYPE_LIBRARY_RELEASE}")
    endif()

    if(FREETYPE_LIBRARY_DEBUG)
      set_property(TARGET Freetype::Library APPEND PROPERTY
        IMPORTED_CONFIGURATIONS DEBUG)
      set_target_properties(Freetype::Library PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "C"
        IMPORTED_LOCATION_DEBUG "${FREETYPE_LIBRARY_DEBUG}")
    endif()

    if(NOT FREETYPE_LIBRARY_RELEASE AND NOT FREETYPE_LIBRARY_DEBUG)
      set_target_properties(Freetype::Library PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${FREETYPE_LIBRARY}")
    endif()
  endif()
endif()
