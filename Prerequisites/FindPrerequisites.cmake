find_package(PackageHandleStandardArgs)

find_library(ZLIB_LIBRARY
    NAMES zlib1 z
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(FREETYPE_LIBRARY
    NAMES freetype-6 freetype
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(BZ2_LIBRARY
    NAMES bz2-1 bz2
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(GCC_LIBRARY
    NAMES gcc_s_seh-1 gcc_s_sjlj-1 gcc_s
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(GLIB_LIBRARY
    NAMES glib-2.0-0 glib-2.0
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(GRAPHITE_LIBRARY
    NAMES graphite2
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(HARFBUZZ_LIBRARY
    NAMES harfbuzz-0 harfbuzz
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(ICONV_LIBRARY
    NAMES iconv-2 iconv
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(INTL_LIBRARY
    NAMES intl-8 intl
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(PCRE_LIBRARY
    NAMES pcre-1 pcre
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(PCRE2_LIBRARY
    NAMES pcre2-16-0 pcre2-16
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(PNG_LIBRARY
    NAMES png16-16 png16
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(STDCXX_LIBRARY
    NAMES stdc++-6 stdc++
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )
find_library(PTHREAD_LIBRARY
    NAMES winpthread-1 pthread
    $<$<OR:WIN32,WIN64>:HINTS /usr/${TOOLCHAIN_PREFIX}/bin>
    $<$<OR:WIN32,WIN64>:NO_DEFAULT_PATH>
    )

find_package_handle_standard_args(Bz2 REQUIRED_VARS BZ2_LIBRARY)
find_package_handle_standard_args(Freetype REQUIRED_VARS FREETYPE_LIBRARY)
find_package_handle_standard_args(Pcre REQUIRED_VARS PCRE_LIBRARY PCRE2_LIBRARY)
find_package_handle_standard_args(Harfbuzz REQUIRED_VARS HARFBUZZ_LIBRARY)
find_package_handle_standard_args(PThread REQUIRED_VARS PTHREAD_LIBRARY)
find_package_handle_standard_args(STDCXX REQUIRED_VARS STDCXX_LIBRARY)
find_package_handle_standard_args(PNG REQUIRED_VARS PNG_LIBRARY)
find_package_handle_standard_args(Intl REQUIRED_VARS INTL_LIBRARY)
find_package_handle_standard_args(Graphite REQUIRED_VARS GRAPHITE_LIBRARY)
find_package_handle_standard_args(GCC REQUIRED_VARS GCC_LIBRARY)
find_package_handle_standard_args(GLib REQUIRED_VARS GLIB_LIBRARY)
find_package_handle_standard_args(Zlib REQUIRED_VARS ZLIB_LIBRARY)
find_package_handle_standard_args(Iconv REQUIRED_VARS ICONV_LIBRARY)

if(BZ2_FOUND AND NOT TARGET Bz2::Library)
        add_library(Bz2::Library UNKNOWN IMPORTED)
        set_target_properties(Bz2::Library PROPERTIES
                IMPORTED_LOCATION "${BZ2_LIBRARY}"
                )
endif()

if(FREETYPE_FOUND AND NOT TARGET Freetype::Library)
        add_library(Freetype::Library UNKNOWN IMPORTED)
        set_target_properties(Freetype::Library PROPERTIES
                IMPORTED_LOCATION "${FREETYPE_LIBRARY}"
                )
endif()

if(PCRE_FOUND AND NOT TARGET Pcre::Core)
        add_library(Pcre::Core UNKNOWN IMPORTED)
        set_target_properties(Pcre::Core PROPERTIES
                IMPORTED_LOCATION "${PCRE_LIBRARY}"
                )
endif()

if(PCRE_FOUND AND NOT TARGET Pcre::Extension)
        add_library(Pcre::Extension UNKNOWN IMPORTED)
        set_target_properties(Pcre::Extension PROPERTIES
                IMPORTED_LOCATION "${PCRE2_LIBRARY}"
                )
endif()

if(HARFBUZZ_FOUND AND NOT TARGET Harfbuzz::Library)
        add_library(Harfbuzz::Library UNKNOWN IMPORTED)
        set_target_properties(Harfbuzz::Library PROPERTIES
                IMPORTED_LOCATION "${HARFBUZZ_LIBRARY}"
                )
endif()

if(PTHREAD_FOUND AND NOT TARGET PThread::Library)
        add_library(PThread::Library UNKNOWN IMPORTED)
        set_target_properties(PThread::Library PROPERTIES
                IMPORTED_LOCATION "${PTHREAD_LIBRARY}"
                )
endif()

if(STDCXX_FOUND AND NOT TARGET STDCXX::Library)
        add_library(STDCXX::Library UNKNOWN IMPORTED)
        set_target_properties(STDCXX::Library PROPERTIES
                IMPORTED_LOCATION "${STDCXX_LIBRARY}"
                )
endif()

if(PNG_FOUND AND NOT TARGET PNG::Library)
        add_library(PNG::Library UNKNOWN IMPORTED)
        set_target_properties(PNG::Library PROPERTIES
                IMPORTED_LOCATION "${PNG_LIBRARY}"
                )
endif()

if(INTL_FOUND AND NOT TARGET Intl::Library)
        add_library(Intl::Library UNKNOWN IMPORTED)
        set_target_properties(Intl::Library PROPERTIES
                IMPORTED_LOCATION "${INTL_LIBRARY}"
                )
endif()

if(GRAPHITE_FOUND AND NOT TARGET Graphite::Library)
        add_library(Graphite::Library UNKNOWN IMPORTED)
        set_target_properties(Graphite::Library PROPERTIES
                IMPORTED_LOCATION "${GRAPHITE_LIBRARY}"
                )
endif()

if(GCC_FOUND AND NOT TARGET GCC::Library)
        add_library(GCC::Library UNKNOWN IMPORTED)
        set_target_properties(GCC::Library PROPERTIES
                IMPORTED_LOCATION "${GCC_LIBRARY}"
                )
endif()

if(GLIB_FOUND AND NOT TARGET GLib::Library)
        add_library(GLib::Library UNKNOWN IMPORTED)
        set_target_properties(GLib::Library PROPERTIES
                IMPORTED_LOCATION "${GLIB_LIBRARY}"
                )
endif()

if(ZLIB_FOUND AND NOT TARGET Zlib::Library)
        add_library(Zlib::Library UNKNOWN IMPORTED)
        set_target_properties(Zlib::Library PROPERTIES
                IMPORTED_LOCATION "${ZLIB_LIBRARY}"
                )
endif()

if(ICONV_FOUND AND NOT TARGET Iconv::Library)
        add_library(Iconv::Library UNKNOWN IMPORTED)
        set_target_properties(Iconv::Library PROPERTIES
                IMPORTED_LOCATION "${ICONV_LIBRARY}"
                )
endif()

mark_as_advanced(BZ2_LIBRARY)
mark_as_advanced(FREETYPE_LIBRARY)
mark_as_advanced(HARFBUZZ_LIBRARY)
mark_as_advanced(PCRE_LIBRARY)
mark_as_advanced(PCRE2_LIBRARY)
mark_as_advanced(PTHREAD_LIBRARY)
mark_as_advanced(STDCXX_LIBRARY)
mark_as_advanced(PNG_LIBRARY)
mark_as_advanced(INTL_LIBRARY)
mark_as_advanced(GRAPHITE_LIBRARY)
mark_as_advanced(GCC_LIBRARY)
mark_as_advanced(GLIB_LIBRARY)
mark_as_advanced(ZLIB_LIBRARY)
mark_as_advanced(ICONV_LIBRARY)
