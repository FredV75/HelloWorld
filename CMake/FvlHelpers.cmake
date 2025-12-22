cmake_minimum_required(VERSION 3.20)

include(CMakePackageConfigHelpers)

set(FVL_CMAKE_MODULES_DIR ${CMAKE_CURRENT_SOURCE_DIR})

########################################################################################################################
set(CMAKE_INSTALL_BINDIR "bin" CACHE PATH "User executables (bin)")
set(CMAKE_INSTALL_SBINDIR "bin" CACHE PATH "System admin executables (sbin)")
set(CMAKE_INSTALL_SYSCONFDIR "etc" CACHE PATH "Read-only single-machine data (etc)")
set(CMAKE_INSTALL_LIBDIR "${CMAKE_INSTALL_BINDIR}" CACHE PATH "Object code libraries (lib)")
set(CMAKE_INSTALL_LIBEXECDIR "${CMAKE_INSTALL_LIBDIR}" CACHE PATH "Program executables (libexec)")
set(CMAKE_INSTALL_ARCHIVEDIR "lib" CACHE PATH "Object code archives")
set(CMAKE_INSTALL_SOURCESDIR "sources" CACHE PATH "Sources archives")
set(CMAKE_INSTALL_EXPORTDIR "lib/cmake" CACHE PATH "CMake configurations l_dir")
set(CMAKE_INSTALL_INCLUDEDIR "include" CACHE PATH "CMake include l_dir")

########################################################################################################################
if(FVL_LINUX_32)
    set(CMAKE_SYSTEM_PROCESSOR "x86")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m32")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -m32")
endif()

########################################################################################################################
function(FvlPrintVariables)
    get_cmake_property(FVL_PRINT_VARIABLES_L_VARIABLES VARIABLES)
    list(REMOVE_DUPLICATES FVL_PRINT_VARIABLES_L_VARIABLES)
    list(SORT FVL_PRINT_VARIABLES_L_VARIABLES)
    foreach(FVL_PRINT_VARIABLES_L_VAR ${FVL_PRINT_VARIABLES_L_VARIABLES})
        if(ARGV0)
            string(TOLOWER "${ARGV0}" FVL_PRINT_VARIABLES_L_ARGV0_LOWER)
            string(TOLOWER "${FVL_PRINT_VARIABLES_L_VAR}" FVL_PRINT_VARIABLES_L_VAR_LOWER)
            string(REGEX MATCH ${FVL_PRINT_VARIABLES_L_ARGV0_LOWER} FVL_PRINT_VARIABLES_L_MATCHED ${FVL_PRINT_VARIABLES_L_VAR_LOWER})
            unset(FVL_PRINT_VARIABLES_L_ARGV0_LOWER)
            unset(FVL_PRINT_VARIABLES_L_VAR_LOWER)

            if(NOT FVL_PRINT_VARIABLES_L_MATCHED)
                continue()
            endif()
            unset(FVL_PRINT_VARIABLES_L_MATCHED)
        endif()
        message(STATUS "${FVL_PRINT_VARIABLES_L_VAR}=${${FVL_PRINT_VARIABLES_L_VAR}}")
    endforeach()
    unset(FVL_PRINT_VARIABLES_L_VARIABLES)
    unset(FVL_PRINT_VARIABLES_L_VAR)
endfunction()

########################################################################################################################
function(FvlPrintDefinitions a_target)
    if(TARGET ${a_target})
        get_target_property(FVL_PRINT_DEFINITIONS_L_DEFINES ${a_target} COMPILE_DEFINITIONS)
        if(FVL_PRINT_DEFINITIONS_L_DEFINES)
            message(STATUS "${a_target} DEFINES: ${FVL_PRINT_DEFINITIONS_L_DEFINES}")
        endif()
    endif()
endfunction()

########################################################################################################################
function(FvlSetCompilerOptions a_target)
    get_target_property(FVL_SET_COMPILER_OPTIONS_L_TYPE ${a_target} TYPE)

    string(TOUPPER "${FVL_SET_COMPILER_OPTIONS_L_TYPE}" FVL_SET_COMPILER_OPTIONS_L_TYPE_UPPER)
    if(FVL_SET_COMPILER_OPTIONS_L_TYPE_UPPER STREQUAL "INTERFACE_LIBRARY")
        return()
    endif()

    string(TOUPPER "${CMAKE_BUILD_TYPE}" FVL_SET_COMPILER_OPTIONS_L_BUILD_TYPE_UPPER)
    if(FVL_SET_COMPILER_OPTIONS_L_BUILD_TYPE_UPPER STREQUAL "DEBUG")
        target_compile_definitions(${a_target} PRIVATE DEBUG=1 _DEBUG=1)
    else()
        target_compile_definitions(${a_target} PRIVATE NDEBUG=1 RELEASE=1)

        if(WIN32)
            target_compile_options(${a_target} PRIVATE "/Oy-")
        endif()
    endif()

    if(WIN32)
        target_compile_options(${a_target} PRIVATE "/EHs")
        target_compile_options(${a_target} PRIVATE "/Wall")
        target_compile_options(${a_target} PRIVATE "/WX")
        target_compile_options(${a_target} PRIVATE "/GS")
        target_compile_options(${a_target} PRIVATE "/Zc:__cplusplus")
        # !!! target_compile_options(${a_target} PRIVATE "/Qspectre")
        target_compile_options(${a_target} PRIVATE "/bigobj")

        target_link_options(${a_target} PRIVATE "/DYNAMICBASE")
        target_link_options(${a_target} PRIVATE "/NXCOMPAT")

        if(FVL_SET_COMPILER_OPTIONS_L_BUILD_TYPE_UPPER STREQUAL "DEBUG")
            target_link_options(${a_target} PRIVATE "/PROFILE")
            target_link_options(${a_target} PRIVATE "/INCREMENTAL:NO")
        endif()
    endif()

    if(UNIX)
        target_compile_options(${a_target} PRIVATE "-Wall")
        target_compile_options(${a_target} PRIVATE "-Wextra")
        target_compile_options(${a_target} PRIVATE "-Werror")
        target_compile_options(${a_target} PRIVATE "-pedantic")
        target_compile_options(${a_target} PRIVATE "-fstack-protector")
        target_compile_options(${a_target} PRIVATE "-fsigned-char")
        target_compile_options(${a_target} PRIVATE "-Werror=return-type")
        target_compile_options(${a_target} PRIVATE "-Wno-unknown-pragmas")

        target_link_options(${a_target} PRIVATE "-Wl,--no-undefined")
        target_link_options(${a_target} PRIVATE "-Wl,--error-unresolved-symbols")
    endif()

    unset(FVL_SET_COMPILER_OPTIONS_L_TYPE)
    unset(FVL_SET_COMPILER_OPTIONS_L_TYPE_UPPER)
    unset(FVL_SET_COMPILER_OPTIONS_L_BUILD_TYPE_UPPER)
endfunction()

########################################################################################################################
macro(FvlMessageScope a_public a_private a_interface)
    unset(FVL_MESSAGE_SCOPE)
    if(NOT "${a_public}" STREQUAL "")
        list(APPEND FVL_MESSAGE_SCOPE "PUBLIC")
        list(APPEND FVL_MESSAGE_SCOPE "${a_public}")
    endif()
    if(NOT "${a_private}" STREQUAL "")
        list(APPEND FVL_MESSAGE_SCOPE "PRIVATE")
        list(APPEND FVL_MESSAGE_SCOPE "${a_private}")
    endif()
    if(NOT "${a_interface}" STREQUAL "")
        list(APPEND FVL_MESSAGE_SCOPE "INTERFACE")
        list(APPEND FVL_MESSAGE_SCOPE "${a_interface}")
    endif()
endmacro()

########################################################################################################################
macro(FvlTargetLinkLibrariesDo a_target a_scope a_link)
    message(DEBUG "target_link_libraries(${a_target} ${a_scope} ${a_link})")
    target_link_libraries("${a_target}" "${a_scope}" "${a_link}")
endmacro()

########################################################################################################################
macro(FvlTargetLinkLibraries)
    cmake_parse_arguments(FVL_TARGET_LINK_LIBRARIES "OPTIONAL" "NAME;FIND" "PUBLIC;PRIVATE;INTERFACE;IF;TARGET" ${ARGN})

    if(NOT FVL_TARGET_LINK_LIBRARIES_IF)
        set(FVL_TARGET_LINK_LIBRARIES_IF ON)
    endif()

    if(${FVL_TARGET_LINK_LIBRARIES_IF})
        if(NOT FVL_TARGET_LINK_LIBRARIES_NAME)
            set(FVL_TARGET_LINK_LIBRARIES_NAME ${PROJECT_NAME})
        endif()

        if(NOT FVL_TARGET_LINK_LIBRARIES_TARGET)
            set(FVL_TARGET_LINK_LIBRARIES_TARGET ${FVL_TARGET_LIST})
        endif()

        if(FVL_TARGET_LINK_LIBRARIES_UNPARSED_ARGUMENTS)
            list(APPEND FVL_TARGET_LINK_LIBRARIES_PRIVATE ${FVL_TARGET_LINK_LIBRARIES_UNPARSED_ARGUMENTS})
        endif()

        FvlMessageScope("${FVL_TARGET_LINK_LIBRARIES_PUBLIC}" "${FVL_TARGET_LINK_LIBRARIES_PRIVATE}" "${FVL_TARGET_LINK_LIBRARIES_INTERFACE}")
        if(FVL_TARGET_LINK_LIBRARIES_OPTIONAL)
            list(APPEND FVL_MESSAGE_SCOPE "OPTIONAL")
        endif()
        message(DEBUG "FvlTargetLinkLibraries(NAME;${FVL_TARGET_LINK_LIBRARIES_NAME};TARGET;${FVL_TARGET_LINK_LIBRARIES_TARGET};${FVL_MESSAGE_SCOPE})")
        unset(FVL_MESSAGE_SCOPE)

        foreach(FVL_TARGET_LINK_LIBRARIES_L_TARGET IN LISTS FVL_TARGET_LINK_LIBRARIES_TARGET)
            if(NOT ${FVL_TARGET_LINK_LIBRARIES_L_TARGET} IN_LIST FVL_TARGET_LIST)
                message(FATAL_ERROR "FvlTargetLinkLibraries() to unknown TARGET named \"${FVL_TARGET_LINK_LIBRARIES_L_TARGET}\"")
            endif()

            if(NOT TARGET ${FVL_TARGET_LINK_LIBRARIES_NAME}-${FVL_TARGET_LINK_LIBRARIES_L_TARGET})
                continue()
            endif()

            get_target_property(FVL_TARGET_LINK_LIBRARIES_L_TYPE ${FVL_TARGET_LINK_LIBRARIES_NAME}-${FVL_TARGET_LINK_LIBRARIES_L_TARGET} TYPE)
            if("${FVL_TARGET_LINK_LIBRARIES_L_TYPE}" STREQUAL "INTERFACE_LIBRARY")
                set(FVL_TARGET_LINK_LIBRARIES_L_SCOPES "INTERFACE")
            else()
                set(FVL_TARGET_LINK_LIBRARIES_L_SCOPES "PUBLIC;PRIVATE;INTERFACE")
            endif()

            string(TOUPPER "${FVL_TARGET_LINK_LIBRARIES_L_TARGET}" FVL_TARGET_LINK_LIBRARIES_L_TARGET_UPPER)

            foreach(FVL_TARGET_LINK_LIBRARIES_L_SCOPE IN LISTS FVL_TARGET_LINK_LIBRARIES_L_SCOPES)
                if(NOT FVL_TARGET_LINK_LIBRARIES_${FVL_TARGET_LINK_LIBRARIES_L_SCOPE})
                    continue()
                endif()

                foreach(FVL_TARGET_LINK_LIBRARIES_L_PROJECT IN LISTS FVL_TARGET_LINK_LIBRARIES_${FVL_TARGET_LINK_LIBRARIES_L_SCOPE})

                    if(FVL_TARGET_LINK_LIBRARIES_FIND)
                        set(FVL_TARGET_LINK_LIBRARIES_L_FIND ${FVL_TARGET_LINK_LIBRARIES_FIND})
                    else()
                        set(FVL_TARGET_LINK_LIBRARIES_L_FIND ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT})
                    endif()

                    set(FVL_TARGET_LINK_LIBRARIES_L_FOUND ${${FVL_TARGET_LINK_LIBRARIES_L_FIND}_FOUND})
                    if(NOT FVL_TARGET_LINK_LIBRARIES_L_FOUND)
                        if(CMAKE_INSTALL_PREFIX)
                            find_package(${FVL_TARGET_LINK_LIBRARIES_L_FIND} QUIET PATHS "${CMAKE_INSTALL_PREFIX}" NO_DEFAULT_PATH)
                        endif()

                        set(FVL_TARGET_LINK_LIBRARIES_L_FOUND ${${FVL_TARGET_LINK_LIBRARIES_L_FIND}_FOUND})
                        if(NOT FVL_TARGET_LINK_LIBRARIES_L_FOUND)
                            if(FVL_TARGET_LINK_LIBRARIES_OPTIONAL)
                                find_package(${FVL_TARGET_LINK_LIBRARIES_L_FIND} QUIET)
                            else()
                                find_package(${FVL_TARGET_LINK_LIBRARIES_L_FIND} REQUIRED)
                            endif()
                        endif()

                        set(FVL_TARGET_LINK_LIBRARIES_L_FOUND ${${FVL_TARGET_LINK_LIBRARIES_L_FIND}_FOUND})
                    endif()

                    if(FVL_TARGET_LINK_LIBRARIES_L_FOUND)

                        if("${FVL_TARGET_LINK_LIBRARIES_L_TYPE}" STREQUAL "EXECUTABLE" OR "${FVL_TARGET_LINK_LIBRARIES_L_TYPE}" STREQUAL "SHARED_LIBRARY")
                            if(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT})
                                set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}")

                            elseif(${FVL_TARGET_LINK_LIBRARIES_L_TARGET_UPPER} STREQUAL "SHARED")
                                if(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Shared)
                                    set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Shared")
                                elseif(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Static)
                                    set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Static")
                                elseif(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Interface)
                                    set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Interface")
                                endif()

                            elseif(${FVL_TARGET_LINK_LIBRARIES_L_TARGET_UPPER} STREQUAL "STATIC")
                                if(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Static)
                                    set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Static")
                                elseif(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Shared)
                                    set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Shared")
                                elseif(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Interface)
                                    set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Interface")
                                endif()

                            elseif(${FVL_TARGET_LINK_LIBRARIES_L_TARGET_UPPER} STREQUAL "HYBRID")

                                if("${FVL_TARGET_LINK_LIBRARIES_L_TYPE}" STREQUAL "EXECUTABLE")
                                    if(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Hybrid)
                                        set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Hybrid")
                                    elseif(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Static)
                                        set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Static")
                                    elseif(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Shared)
                                        set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Shared")
                                    elseif(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Interface)
                                        set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Interface")
                                    endif()
                                else()
                                    if(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Hybrid)
                                        set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Hybrid")
                                    elseif(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Static)
                                        set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Static")
                                    elseif(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Shared)
                                        set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Shared")
                                    elseif(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Interface)
                                        set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Interface")
                                    endif()
                                endif()
                            endif()

                        elseif("${FVL_TARGET_LINK_LIBRARIES_L_TYPE}" STREQUAL "STATIC_LIBRARY" OR "${FVL_TARGET_LINK_LIBRARIES_L_TYPE}" STREQUAL "INTERFACE_LIBRARY")
                            if(TARGET ${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Interface)
                                set(FVL_TARGET_LINK_LIBRARIES_L_LINK "${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}-Interface")
                            endif()

                        endif()

                        if(FVL_TARGET_LINK_LIBRARIES_L_LINK)
                            message(DEBUG "${FVL_TARGET_LINK_LIBRARIES_NAME}-${FVL_TARGET_LINK_LIBRARIES_L_TARGET} link on target \"${FVL_TARGET_LINK_LIBRARIES_L_LINK}\"")
                            FvlTargetLinkLibrariesDo(${FVL_TARGET_LINK_LIBRARIES_NAME}-${FVL_TARGET_LINK_LIBRARIES_L_TARGET} ${FVL_TARGET_LINK_LIBRARIES_L_SCOPE} ${FVL_TARGET_LINK_LIBRARIES_L_LINK})
                        else()
                            message(FATAL_ERROR "FvlTargetLinkLibraries() trying to link on unknown target named \"${FVL_TARGET_LINK_LIBRARIES_L_PROJECT}\"")
                        endif()

                        unset(FVL_TARGET_LINK_LIBRARIES_L_LINK)
                        set(FVL_TARGET_LINK_LIBRARIES_L_ONCE ON)
                    endif()
                    unset(FVL_TARGET_LINK_LIBRARIES_L_FIND)
                    unset(FVL_TARGET_LINK_LIBRARIES_L_FOUND)

                endforeach()
                unset(FVL_TARGET_LINK_LIBRARIES_L_PROJECT)

            endforeach()
            unset(FVL_TARGET_LINK_LIBRARIES_L_TYPE)
            unset(FVL_TARGET_LINK_LIBRARIES_L_SCOPES)
            unset(FVL_TARGET_LINK_LIBRARIES_L_TARGET_UPPER)
            unset(FVL_TARGET_LINK_LIBRARIES_L_SCOPE)

        endforeach()
        unset(FVL_TARGET_LINK_LIBRARIES_L_TARGET)

        if(NOT FVL_TARGET_LINK_LIBRARIES_L_ONCE AND NOT FVL_TARGET_LINK_LIBRARIES_OPTIONAL)
            message(FATAL_ERROR "FvlTargetLinkLibraries() doing nothing ?")
        endif()
        unset(FVL_TARGET_LINK_LIBRARIES_L_ONCE)
    endif()

    foreach(FVL_TARGET_LINK_LIBRARIES_L_VAR FIND IF INTERFACE NAME OPTIONAL PRIVATE PUBLIC TARGET UNPARSED_ARGUMENTS)
        unset(FVL_TARGET_LINK_LIBRARIES_${FVL_TARGET_LINK_LIBRARIES_L_VAR})
    endforeach()
    unset(FVL_TARGET_LINK_LIBRARIES_L_VAR)
endmacro()

########################################################################################################################
macro(FvlAddTarget a_name)
    cmake_parse_arguments(FVL_ADD_TARGET "" "TYPE;SUFFIX" "IF" ${ARGN})

    if(NOT FVL_ADD_TARGET_IF)
        set(FVL_ADD_TARGET_IF ON)
    endif()

    if(${FVL_ADD_TARGET_IF})
        if(FVL_ADD_TARGET_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "FvlAddTarget() called with unknown parameter \"${FVL_ADD_TARGET_UNPARSED_ARGUMENTS}\"")
        endif()

        if(${a_name} IN_LIST FVL_TARGET_LIST)
            message(FATAL_ERROR "FvlAddTarget() trying to add existing target named \"${a_name}\"")
        endif()

        list(APPEND FVL_TARGET_LIST ${a_name})

        if(NOT FVL_ADD_TARGET_TYPE)
            set(FVL_ADD_TARGET_TYPE "SHARED")
        endif()

        string(TOUPPER "${a_name}" FVL_ADD_TARGET_L_NAME_UPPER)
        string(TOUPPER "${FVL_ADD_TARGET_TYPE}" FVL_ADD_TARGET_L_TYPE_UPPER)

        set(FVL_TARGET_${FVL_ADD_TARGET_L_NAME_UPPER}_TYPE ${FVL_ADD_TARGET_L_TYPE_UPPER})
        set(FVL_TARGET_${FVL_ADD_TARGET_L_NAME_UPPER}_SUFFIX ${FVL_ADD_TARGET_SUFFIX})

        unset(FVL_ADD_TARGET_L_NAME_UPPER)
        unset(FVL_ADD_TARGET_L_TYPE_UPPER)
    endif()

    foreach(FVL_ADD_TARGET_L_VAR IF SUFFIX TYPE UNPARSED_ARGUMENTS)
        unset(FVL_ADD_TARGET_${FVL_ADD_TARGET_L_VAR})
    endforeach()
    unset(FVL_ADD_TARGET_L_VAR)
endmacro()

########################################################################################################################
function(FvlTargetSources)
    cmake_parse_arguments(PARSE_ARGV 0 FVL_TARGET_SOURCES "" "NAME;FROM" "PUBLIC;PRIVATE;INTERFACE;IF;TARGET")

    if(NOT FVL_TARGET_SOURCES_IF)
        set(FVL_TARGET_SOURCES_IF ON)
    endif()

    if(${FVL_TARGET_SOURCES_IF})
        if(NOT FVL_TARGET_SOURCES_NAME)
            set(FVL_TARGET_SOURCES_NAME "${PROJECT_NAME}")
        endif()

        if(NOT FVL_TARGET_SOURCES_TARGET)
            set(FVL_TARGET_SOURCES_TARGET "${FVL_TARGET_LIST}")
        endif()

        if(FVL_TARGET_SOURCES_UNPARSED_ARGUMENTS)
            list(APPEND FVL_TARGET_SOURCES_PRIVATE ${FVL_TARGET_SOURCES_UNPARSED_ARGUMENTS})
        endif()

        foreach(FVL_TARGET_SOURCES_L_TARGET IN LISTS FVL_TARGET_SOURCES_TARGET)
            if(NOT ${FVL_TARGET_SOURCES_L_TARGET} IN_LIST FVL_TARGET_LIST)
                message(FATAL_ERROR "FvlTargetSources() to unknown TARGET named \"${FVL_TARGET_SOURCES_L_TARGET}\"")
            endif()

            if(NOT TARGET ${FVL_TARGET_SOURCES_NAME}-${FVL_TARGET_SOURCES_L_TARGET})
                continue()
            endif()

            get_target_property(FVL_TARGET_SOURCES_L_TYPE ${FVL_TARGET_SOURCES_NAME}-${FVL_TARGET_SOURCES_L_TARGET} TYPE)
            if("${FVL_TARGET_SOURCES_L_TYPE}" STREQUAL "INTERFACE_LIBRARY")
                set(FVL_TARGET_SOURCES_L_SCOPES "INTERFACE")
            else()
                set(FVL_TARGET_SOURCES_L_SCOPES "PUBLIC;PRIVATE;INTERFACE")
            endif()

            foreach(FVL_TARGET_SOURCES_L_SCOPE IN LISTS FVL_TARGET_SOURCES_L_SCOPES)
                if(NOT FVL_TARGET_SOURCES_${FVL_TARGET_SOURCES_L_SCOPE})
                    continue()
                endif()

                target_sources(${FVL_TARGET_SOURCES_NAME}-${FVL_TARGET_SOURCES_L_TARGET} ${FVL_TARGET_SOURCES_L_SCOPE} ${FVL_TARGET_SOURCES_${FVL_TARGET_SOURCES_L_SCOPE}})

                set(FVL_TARGET_SOURCES_L_ONCE ON)
            endforeach()
            unset(FVL_TARGET_SOURCES_L_TYPE)
            unset(FVL_TARGET_SOURCES_L_SCOPES)
            unset(FVL_TARGET_SOURCES_L_SCOPE)

        endforeach()
        unset(FVL_TARGET_SOURCES_L_TARGET)

        if(NOT FVL_TARGET_SOURCES_L_ONCE)
            message(FATAL_ERROR "FvlTargetSources() doing nothing ?")
        endif()
        unset(FVL_TARGET_SOURCES_L_ONCE)
    endif()
endfunction()

########################################################################################################################
function(FvlTargetIncludeDirectories)
    cmake_parse_arguments(PARSE_ARGV 0 FVL_TARGET_INCLUDE_DIRECTORIES "" "NAME" "DIRECTORIES;IF;TARGET")

    if(NOT FVL_TARGET_INCLUDE_DIRECTORIES_IF)
        set(FVL_TARGET_INCLUDE_DIRECTORIES_IF ON)
    endif()

    if(${FVL_TARGET_INCLUDE_DIRECTORIES_IF})
        if(NOT FVL_TARGET_INCLUDE_DIRECTORIES_NAME)
            set(FVL_TARGET_INCLUDE_DIRECTORIES_NAME "${PROJECT_NAME}")
        endif()

        if(NOT FVL_TARGET_INCLUDE_DIRECTORIES_TARGET)
            set(FVL_TARGET_INCLUDE_DIRECTORIES_TARGET "${FVL_TARGET_LIST}")
        endif()

        if(FVL_TARGET_INCLUDE_DIRECTORIES_UNPARSED_ARGUMENTS)
            list(APPEND FVL_TARGET_INCLUDE_DIRECTORIES_DIRECTORIES ${FVL_TARGET_INCLUDE_DIRECTORIES_UNPARSED_ARGUMENTS})
        endif()

        if(NOT FVL_TARGET_INCLUDE_DIRECTORIES_DIRECTORIES)
            message(FATAL_ERROR "FvlTargetIncludeDirectories() called without a directory to add")
        endif()

        foreach(FVL_TARGET_INCLUDE_DIRECTORIES_L_DIR IN LISTS FVL_TARGET_INCLUDE_DIRECTORIES_DIRECTORIES)
            get_filename_component(FVL_TARGET_INCLUDE_DIRECTORIES_L_ABS ${FVL_TARGET_INCLUDE_DIRECTORIES_L_DIR} ABSOLUTE)

            foreach(FVL_TARGET_INCLUDE_DIRECTORIES_L_TARGET IN LISTS FVL_TARGET_INCLUDE_DIRECTORIES_TARGET)
                if(NOT ${FVL_TARGET_INCLUDE_DIRECTORIES_L_TARGET} IN_LIST FVL_TARGET_LIST)
                    message(FATAL_ERROR "FvlTargetIncludeDirectories() to unknown TARGET named \"${FVL_TARGET_INCLUDE_DIRECTORIES_L_TARGET}\"")
                endif()

                if(NOT TARGET ${FVL_TARGET_INCLUDE_DIRECTORIES_NAME}-${FVL_TARGET_INCLUDE_DIRECTORIES_L_TARGET})
                    continue()
                endif()

                get_target_property(FVL_TARGET_INCLUDE_DIRECTORIES_L_TYPE ${FVL_TARGET_INCLUDE_DIRECTORIES_NAME}-${FVL_TARGET_INCLUDE_DIRECTORIES_L_TARGET} TYPE)
                if("${FVL_TARGET_INCLUDE_DIRECTORIES_L_TYPE}" STREQUAL "INTERFACE_LIBRARY")
                    target_include_directories(${FVL_TARGET_INCLUDE_DIRECTORIES_NAME}-${FVL_TARGET_INCLUDE_DIRECTORIES_L_TARGET} INTERFACE $<BUILD_INTERFACE:${FVL_TARGET_INCLUDE_DIRECTORIES_L_ABS}>)
                    target_include_directories(${FVL_TARGET_INCLUDE_DIRECTORIES_NAME}-${FVL_TARGET_INCLUDE_DIRECTORIES_L_TARGET} INTERFACE $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
                else()
                    target_include_directories(${FVL_TARGET_INCLUDE_DIRECTORIES_NAME}-${FVL_TARGET_INCLUDE_DIRECTORIES_L_TARGET} PUBLIC $<BUILD_INTERFACE:${FVL_TARGET_INCLUDE_DIRECTORIES_L_ABS}>)
                    target_include_directories(${FVL_TARGET_INCLUDE_DIRECTORIES_NAME}-${FVL_TARGET_INCLUDE_DIRECTORIES_L_TARGET} PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
                endif()
                unset(FVL_TARGET_INCLUDE_DIRECTORIES_L_TYPE)

                install(DIRECTORY "${FVL_TARGET_INCLUDE_DIRECTORIES_L_ABS}/" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")

                set(FVL_TARGET_INCLUDE_DIRECTORIES_L_ONCE ON)
            endforeach()
            unset(FVL_TARGET_INCLUDE_DIRECTORIES_L_ABS)
            unset(FVL_TARGET_INCLUDE_DIRECTORIES_L_TARGET)

        endforeach()
        unset(FVL_TARGET_INCLUDE_DIRECTORIES_L_DIR)

        if(NOT FVL_TARGET_INCLUDE_DIRECTORIES_L_ONCE)
            message(FATAL_ERROR "FvlTargetIncludeDirectories() doing nothing ?")
        endif()
        unset(FVL_TARGET_INCLUDE_DIRECTORIES_L_ONCE)
    endif()
endfunction()

########################################################################################################################
macro(FvlAddLibrary)
    cmake_parse_arguments(FVL_ADD_LIBRARY "" "NAME" "IF;TARGET" ${ARGN})

    if(NOT FVL_ADD_LIBRARY_IF)
        set(FVL_ADD_LIBRARY_IF ON)
    endif()

    if(${FVL_ADD_LIBRARY_IF})
        if(FVL_ADD_LIBRARY_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "FvlAddLibrary() called with unknown parameter \"${FVL_ADD_LIBRARY_UNPARSED_ARGUMENTS}\"")
        endif()

        if(NOT FVL_ADD_LIBRARY_NAME)
            set(FVL_ADD_LIBRARY_NAME "${PROJECT_NAME}")
        endif()

        if(NOT FVL_ADD_LIBRARY_TARGET)
            set(FVL_ADD_LIBRARY_TARGET "Shared;Static;Interface")
        endif()

        message(DEBUG "FvlAddLibrary(NAME;${FVL_ADD_LIBRARY_NAME};TARGET;${FVL_ADD_LIBRARY_TARGET})")

        foreach(FVL_ADD_LIBRARY_L_TARGET IN LISTS FVL_ADD_LIBRARY_TARGET)
            if(NOT ${FVL_ADD_LIBRARY_L_TARGET} IN_LIST FVL_TARGET_LIST)
                message(FATAL_ERROR "FvlAddLibrary() to unknown TARGET named \"${FVL_ADD_LIBRARY_L_TARGET}\"")
            endif()

            string(TOUPPER "${FVL_ADD_LIBRARY_L_TARGET}" FVL_ADD_LIBRARY_L_TARGET_UPPER)
            add_library(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} ${FVL_TARGET_${FVL_ADD_LIBRARY_L_TARGET_UPPER}_TYPE})

            if("${FVL_TARGET_${FVL_ADD_LIBRARY_L_TARGET_UPPER}_TYPE}" STREQUAL "INTERFACE")

                install(TARGETS ${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} EXPORT ${FVL_ADD_LIBRARY_NAME}-Targets)

            else()

                install(
                    TARGETS ${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET}
                    EXPORT ${FVL_ADD_LIBRARY_NAME}-Targets
                    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
                    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
                    ARCHIVE DESTINATION "${CMAKE_INSTALL_ARCHIVEDIR}"
                    OBJECTS DESTINATION "${CMAKE_INSTALL_ARCHIVEDIR}"
                )

                FvlSetCompilerOptions(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET})

                set_target_properties(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PROPERTIES POSITION_INDEPENDENT_CODE ON)
                set_target_properties(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PROPERTIES INSTALL_RPATH "$ORIGIN")
                set_target_properties(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)

                target_include_directories(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}")

                string(TOUPPER "${CMAKE_BUILD_TYPE}" FVL_ADD_LIBRARY_L_BUILD_TYPE_UPPER)

                if(FVL_ADD_LIBRARY_L_BUILD_TYPE_UPPER STREQUAL "DEBUG")
                    set(FVL_ADD_LIBRARY_L_DEBUG_SUFFIX "D")
                endif()

                if(${FVL_TARGET_${FVL_ADD_LIBRARY_L_TARGET_UPPER}_TYPE} STREQUAL "SHARED")

                    set_target_properties(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PROPERTIES OUTPUT_NAME "${FVL_ADD_LIBRARY_NAME}${FVL_TARGET_${FVL_ADD_LIBRARY_L_TARGET_UPPER}_SUFFIX}")
                    set_target_properties(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PROPERTIES DEBUG_POSTFIX "D")

                    target_compile_definitions(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PRIVATE "$<UPPER_CASE:${FVL_ADD_LIBRARY_NAME}>_EXPORTS")
                    target_compile_definitions(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} INTERFACE "$<UPPER_CASE:${FVL_ADD_LIBRARY_NAME}>_IMPORTS")

                    if(WIN32)
                        install(FILES $<TARGET_PDB_FILE:${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET}> DESTINATION "${CMAKE_INSTALL_BINDIR}" OPTIONAL)
                    endif()

                elseif(${FVL_TARGET_${FVL_ADD_LIBRARY_L_TARGET_UPPER}_TYPE} STREQUAL "STATIC")

                    set_target_properties(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PROPERTIES OUTPUT_NAME "${FVL_ADD_LIBRARY_NAME}${FVL_TARGET_${FVL_ADD_LIBRARY_L_TARGET_UPPER}_SUFFIX}")
                    set_target_properties(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PROPERTIES DEBUG_POSTFIX "D")
                    set_target_properties(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PROPERTIES COMPILE_PDB_NAME "${FVL_ADD_LIBRARY_NAME}${FVL_TARGET_${FVL_ADD_LIBRARY_L_TARGET_UPPER}_SUFFIX}${FVL_ADD_LIBRARY_L_DEBUG_SUFFIX}")
                    set_target_properties(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PROPERTIES COMPILE_PDB_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

                    target_compile_definitions(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PRIVATE _LIB)

                    if(WIN32)
                        get_target_property(FVL_ADD_LIBRARY_L_PDB ${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} COMPILE_PDB_NAME)
                        install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${FVL_ADD_LIBRARY_L_PDB}.pdb" DESTINATION "${CMAKE_INSTALL_ARCHIVEDIR}" OPTIONAL)
                        unset(FVL_ADD_LIBRARY_L_PDB)
                    endif()

                else()
                    message(FATAL_ERROR "FvlAddLibrary() on unknown TARGET type named \"FVL_TARGET_${FVL_ADD_LIBRARY_L_TARGET_UPPER}_TYPE\"")
                endif()

                if(${FVL_ADD_LIBRARY_L_TARGET_UPPER} STREQUAL "HYBRID")
                    target_compile_definitions(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PRIVATE HYBRID)
                    target_compile_definitions(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PRIVATE USE_LIB)
                endif()

                target_compile_definitions(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PRIVATE "WINVER=0x0601")
                target_compile_definitions(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PRIVATE "_WIN32_WINNT=0x0601")

                if(CMAKE_SIZEOF_VOID_P EQUAL 4)
                    target_compile_definitions(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PRIVATE "FVL_32B=1")
                elseif (CMAKE_SIZEOF_VOID_P EQUAL 8)
                    target_compile_definitions(${FVL_ADD_LIBRARY_NAME}-${FVL_ADD_LIBRARY_L_TARGET} PRIVATE "FVL_64B=1")
                endif()

                unset(FVL_ADD_LIBRARY_L_TARGET_UPPER)
                unset(FVL_ADD_LIBRARY_L_BUILD_TYPE_UPPER)
                unset(FVL_ADD_LIBRARY_L_DEBUG_SUFFIX)
            endif()

            set(FVL_ADD_LIBRARY_L_ONCE ON)

        endforeach()
        unset(FVL_ADD_LIBRARY_L_TARGET)

        if(NOT FVL_ADD_LIBRARY_L_ONCE)
            message(FATAL_ERROR "FvlAddLibrary() doing nothing ?")
        endif()
        unset(FVL_ADD_LIBRARY_L_ONCE)

        if(NOT TARGET ${FVL_ADD_LIBRARY_NAME}-Interface)
            add_library(${FVL_ADD_LIBRARY_NAME}-Interface INTERFACE)
            install(TARGETS ${FVL_ADD_LIBRARY_NAME}-Interface EXPORT ${FVL_ADD_LIBRARY_NAME}-Targets)
        endif()

        set(FVL_NAME_${FVL_ADD_LIBRARY_NAME}_LIBRARY ON)
    endif()

    foreach(FVL_ADD_LIBRARY_L_VAR IF NAME TARGET UNPARSED_ARGUMENTS)
        unset(FVL_ADD_LIBRARY_${FVL_ADD_LIBRARY_L_VAR})
    endforeach()
    unset(FVL_ADD_LIBRARY_L_VAR)
endmacro()

########################################################################################################################
macro(FvlAddExecutable)
    cmake_parse_arguments(FVL_ADD_EXECUTABLE "" "NAME" "IF;TARGET" ${ARGN})

    if(NOT FVL_ADD_EXECUTABLE_IF)
        set(FVL_ADD_EXECUTABLE_IF ON)
    endif()

    if(${FVL_ADD_EXECUTABLE_IF})
        if(FVL_ADD_EXECUTABLE_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "FvlAddExecutable() called with unknown parameter \"${FVL_ADD_EXECUTABLE_UNPARSED_ARGUMENTS}\"")
        endif()

        if(NOT FVL_ADD_EXECUTABLE_NAME)
            set(FVL_ADD_EXECUTABLE_NAME "${PROJECT_NAME}")
        endif()

        if(NOT FVL_ADD_EXECUTABLE_TARGET)
            set(FVL_ADD_EXECUTABLE_TARGET "Shared;Static")
        endif()

        message(DEBUG "FvlAddExecutable(NAME;${FVL_ADD_EXECUTABLE_NAME};TARGET;${FVL_ADD_EXECUTABLE_TARGET})")

        foreach(FVL_ADD_EXECUTABLE_L_TARGET IN LISTS FVL_ADD_EXECUTABLE_TARGET)
            if(NOT ${FVL_ADD_EXECUTABLE_L_TARGET} IN_LIST FVL_TARGET_LIST)
                message(FATAL_ERROR "FvlAddExecutable() to unknown TARGET named \"${FVL_ADD_EXECUTABLE_L_TARGET}\"")
            endif()

            string(TOUPPER "${FVL_ADD_EXECUTABLE_L_TARGET}" FVL_ADD_EXECUTABLE_L_TARGET_UPPER)

            add_executable(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET})

            install(
                TARGETS ${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET}
                RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
            )

            FvlSetCompilerOptions(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET})

            set_target_properties(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PROPERTIES POSITION_INDEPENDENT_CODE ON)
            set_target_properties(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PROPERTIES INSTALL_RPATH "$ORIGIN;$ORIGIN/../lib")
            set_target_properties(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)

            target_include_directories(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}")

            string(TOUPPER "${CMAKE_BUILD_TYPE}" FVL_ADD_EXECUTABLE_L_BUILD_TYPE_UPPER)

            if(FVL_ADD_EXECUTABLE_L_BUILD_TYPE_UPPER STREQUAL "DEBUG")
                set(FVL_ADD_EXECUTABLE_L_DEBUG_SUFFIX "D")
            endif()

            if(${FVL_TARGET_${FVL_ADD_EXECUTABLE_L_TARGET_UPPER}_TYPE} STREQUAL "SHARED")

                set_target_properties(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PROPERTIES OUTPUT_NAME "${FVL_ADD_EXECUTABLE_NAME}${FVL_TARGET_${FVL_ADD_EXECUTABLE_L_TARGET_UPPER}_SUFFIX}")
                set_target_properties(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PROPERTIES DEBUG_POSTFIX "D")

                if(WIN32)
                    install(FILES $<TARGET_PDB_FILE:${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET}> DESTINATION "${CMAKE_INSTALL_BINDIR}" OPTIONAL)
                endif()

            elseif(${FVL_TARGET_${FVL_ADD_EXECUTABLE_L_TARGET_UPPER}_TYPE} STREQUAL "STATIC")

                set_target_properties(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PROPERTIES OUTPUT_NAME "${FVL_ADD_EXECUTABLE_NAME}${FVL_TARGET_${FVL_ADD_EXECUTABLE_L_TARGET_UPPER}_SUFFIX}")
                set_target_properties(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PROPERTIES DEBUG_POSTFIX "D")
                set_target_properties(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PROPERTIES COMPILE_PDB_NAME "${FVL_ADD_EXECUTABLE_NAME}${FVL_TARGET_${FVL_ADD_EXECUTABLE_L_TARGET_UPPER}_SUFFIX}${FVL_ADD_EXECUTABLE_L_DEBUG_SUFFIX}")
                set_target_properties(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PROPERTIES COMPILE_PDB_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

                target_compile_definitions(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PRIVATE USE_LIB)

                if(WIN32)
                    get_target_property(FVL_ADD_EXECUTABLE_L_PDB ${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} COMPILE_PDB_NAME)
                    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${FVL_ADD_EXECUTABLE_L_PDB}.pdb" DESTINATION "${CMAKE_INSTALL_BINDIR}" OPTIONAL)
                    unset(FVL_ADD_EXECUTABLE_L_PDB)
                endif()

            else()
                message(FATAL_ERROR "FvlAddExecutable() on unknown TARGET type named \"FVL_TARGET_${FVL_ADD_EXECUTABLE_L_TARGET_UPPER}_TYPE\"")
            endif()

            if(${FVL_ADD_EXECUTABLE_L_TARGET_UPPER} STREQUAL "HYBRID")
                target_compile_definitions(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PRIVATE HYBRID)
            endif()

            target_compile_definitions(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PRIVATE "WINVER=0x0601")
            target_compile_definitions(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PRIVATE "_WIN32_WINNT=0x0601")

            if(CMAKE_SIZEOF_VOID_P EQUAL 4)
                target_compile_definitions(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PRIVATE "FVL_32B=1")
            elseif (CMAKE_SIZEOF_VOID_P EQUAL 8)
                target_compile_definitions(${FVL_ADD_EXECUTABLE_NAME}-${FVL_ADD_EXECUTABLE_L_TARGET} PRIVATE "FVL_64B=1")
            endif()

            set(FVL_ADD_EXECUTABLE_L_ONCE ON)

            unset(FVL_ADD_EXECUTABLE_L_TARGET_UPPER)
            unset(FVL_ADD_EXECUTABLE_L_BUILD_TYPE_UPPER)
            unset(FVL_ADD_EXECUTABLE_L_DEBUG_SUFFIX)

        endforeach()
        unset(FVL_ADD_EXECUTABLE_L_TARGET)

        if(NOT FVL_ADD_EXECUTABLE_L_ONCE)
            message(FATAL_ERROR "FvlAddExecutable() doing nothing ?")
        endif()
        unset(FVL_ADD_EXECUTABLE_L_ONCE)
    endif()

    foreach(FVL_ADD_EXECUTABLE_L_VAR IF NAME TARGET UNPARSED_ARGUMENTS)
        unset(FVL_ADD_EXECUTABLE_${FVL_ADD_EXECUTABLE_L_VAR})
    endforeach()
    unset(FVL_ADD_EXECUTABLE_L_VAR)
endmacro()

########################################################################################################################
macro(FvlAddTest)
    cmake_parse_arguments(FVL_ADD_TEST "" "NAME" "IF;TARGET" ${ARGN})

    if(NOT FVL_ADD_TEST_IF)
        set(FVL_ADD_TEST_IF ON)
    endif()

    if(${FVL_ADD_TEST_IF})
        if(FVL_ADD_TEST_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "FvlAddTest() called with unknown parameter \"${FVL_ADD_TEST_UNPARSED_ARGUMENTS}\"")
        endif()

        if(NOT FVL_ADD_TEST_NAME)
            set(FVL_ADD_TEST_NAME "${PROJECT_NAME}")
        endif()

        if(NOT FVL_ADD_TEST_TARGET)
            set(FVL_ADD_TEST_TARGET "Shared;Static")
        endif()

        message(DEBUG "FvlAddTest(NAME;${FVL_ADD_TEST_NAME};TARGET;${FVL_ADD_TEST_TARGET})")

        foreach(FVL_ADD_TEST_L_TARGET IN LISTS FVL_ADD_TEST_TARGET)
            if(NOT ${FVL_ADD_TEST_L_TARGET} IN_LIST FVL_TARGET_LIST)
                message(FATAL_ERROR "FvlAddTest() to unknown TARGET named \"${FVL_ADD_TEST_L_TARGET}\"")
            endif()

            string(TOUPPER "${FVL_ADD_TEST_L_TARGET}" FVL_ADD_TEST_L_TARGET_UPPER)

            FvlAddExecutable(NAME ${FVL_ADD_TEST_NAME} TARGET ${FVL_ADD_TEST_L_TARGET})

            add_test(NAME ${FVL_ADD_TEST_NAME}-${FVL_ADD_TEST_L_TARGET} COMMAND "$<TARGET_FILE_NAME:${FVL_ADD_TEST_NAME}-${FVL_ADD_TEST_L_TARGET}>" WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}")

            file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/tests")

            # For some reason, $<TARGET_FILE_NAME: does not work here ... work-around it
            set(FVL_ADD_TEST_TARGET_FILE_NAME "${FVL_ADD_TEST_NAME}${FVL_TARGET_${FVL_ADD_TEST_L_TARGET_UPPER}_SUFFIX}")
            string(TOUPPER "${CMAKE_BUILD_TYPE}" FVL_ADD_TEST_L_BUILD_TYPE_UPPER)
            if(FVL_ADD_TEST_L_BUILD_TYPE_UPPER STREQUAL "DEBUG")
                set(FVL_ADD_TEST_TARGET_FILE_NAME "${FVL_ADD_TEST_TARGET_FILE_NAME}D")
            endif()
            if(WIN32)
                set(FVL_ADD_TEST_TARGET_FILE_NAME "${FVL_ADD_TEST_TARGET_FILE_NAME}.exe")
            endif()

            file(
                GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/tests/${FVL_ADD_TEST_NAME}-${FVL_ADD_TEST_L_TARGET}.ctest"
                CONTENT "add_test(${FVL_ADD_TEST_NAME}-${FVL_ADD_TEST_L_TARGET} \"${FVL_ADD_TEST_TARGET_FILE_NAME}\")\nset_tests_properties(${FVL_ADD_TEST_NAME}-${FVL_ADD_TEST_L_TARGET} PROPERTIES WORKING_DIRECTORY \"\$\{CMAKE_CURRENT_LIST_DIR\}/../${CMAKE_INSTALL_BINDIR}\")\n"
            )

            install(FILES "${CMAKE_CURRENT_BINARY_DIR}/tests/${FVL_ADD_TEST_NAME}-${FVL_ADD_TEST_L_TARGET}.ctest" DESTINATION tests)

            get_property(FVL_TEST_EXE_LIST_L_LIST GLOBAL PROPERTY FVL_TEST_EXE_LIST)
            list(APPEND FVL_TEST_EXE_LIST_L_LIST "${FVL_ADD_TEST_TARGET_FILE_NAME}")
            set_property(GLOBAL PROPERTY FVL_TEST_EXE_LIST ${FVL_TEST_EXE_LIST_L_LIST})
            unset(FVL_TEST_EXE_LIST_L_LIST)

            set(FVL_ADD_TEST_L_ONCE ON)
        endforeach()
        unset(FVL_ADD_TEST_L_TARGET)

        if(NOT FVL_ADD_TEST_L_ONCE)
            message(FATAL_ERROR "FvlAddTest() doing nothing ?")
        endif()
        unset(FVL_ADD_TEST_L_ONCE)

        if (NOT FVL_GENERATE_CTESTS_ONCE)
            configure_file(
                "${FVL_CMAKE_MODULES_DIR}/CMake/CTestTestfile.cmake.in"
                "${CMAKE_CURRENT_BINARY_DIR}/tests/CTestTestfile.cmake"
                @ONLY
            )

            install(FILES "${CMAKE_CURRENT_BINARY_DIR}/tests/CTestTestfile.cmake" DESTINATION tests)
            set(FVL_GENERATE_CTESTS_ONCE TRUE CACHE STRING "CTestTestfile.cmake")
        endif()
    endif()

    foreach(FVL_ADD_TEST_L_VAR IF NAME TARGET UNPARSED_ARGUMENTS)
        unset(FVL_ADD_TEST_${FVL_ADD_TEST_L_VAR})
    endforeach()
    unset(FVL_ADD_TEST_L_VAR)
endmacro()

########################################################################################################################
macro(FvlProject)
    cmake_parse_arguments(FVL_PROJECT "" "NAME" "IF" ${ARGN})

    if(NOT FVL_PROJECT_IF)
        set(FVL_PROJECT_IF ON)
    endif()

    if(${FVL_PROJECT_IF})
        if(FVL_PROJECT_UNPARSED_ARGUMENTS)
            set(FVL_PROJECT_NAME "${FVL_PROJECT_UNPARSED_ARGUMENTS}")
        endif()

        if(NOT FVL_PROJECT_NAME)
            message(FATAL_ERROR "FvlProject() called without a name")
        endif()

        project(${FVL_PROJECT_NAME})

        get_property(FVL_CMAKELISTS_TXT_LIST_L_LIST GLOBAL PROPERTY FVL_CMAKELISTS_TXT_LIST)
        list(APPEND FVL_CMAKELISTS_TXT_LIST_L_LIST ${CMAKE_CURRENT_LIST_FILE})
        set_property(GLOBAL PROPERTY FVL_CMAKELISTS_TXT_LIST ${FVL_CMAKELISTS_TXT_LIST_L_LIST})
        unset(FVL_CMAKELISTS_TXT_LIST_L_LIST)
    endif()

    foreach(FVL_PROJECT_L_VAR IF NAME)
        unset(FVL_PROJECT_${FVL_PROJECT_L_VAR})
    endforeach()
    unset(FVL_PROJECT_L_VAR)
endmacro()

########################################################################################################################
macro(FvlProjectEnd)
    cmake_parse_arguments(FVL_PROJECT_END "" "NAME" "IF;TARGET" ${ARGN})

    if(NOT FVL_PROJECT_END_IF)
        set(FVL_PROJECT_END_IF ON)
    endif()

    if(${FVL_PROJECT_END_IF})
        if(FVL_PROJECT_END_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "FvlProjectEnd() called with unknown parameter \"${FVL_PROJECT_END_UNPARSED_ARGUMENTS}\"")
        endif()

        if(NOT FVL_PROJECT_END_NAME)
            set(FVL_PROJECT_END_NAME "${PROJECT_NAME}")
        endif()

        if(NOT FVL_PROJECT_END_TARGET)
            set(FVL_PROJECT_END_TARGET ${FVL_TARGET_LIST})
        endif()

        message(DEBUG "FvlProjectEnd(NAME;${FVL_PROJECT_END_NAME};TARGET;${FVL_PROJECT_END_TARGET})")
    endif()

    if(FVL_NAME_${FVL_PROJECT_END_NAME}_LIBRARY)
        string(TOLOWER "${FVL_PROJECT_END_NAME}" FVL_PROJECT_END_L_NAME_LOWER)

        file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/${FVL_PROJECT_END_L_NAME_LOWER}-config.cmake")

        configure_package_config_file("${FVL_CMAKE_MODULES_DIR}/CMake/config.cmake.in" "${CMAKE_CURRENT_BINARY_DIR}/${FVL_PROJECT_END_L_NAME_LOWER}-config.cmake.in" INSTALL_DESTINATION "${CMAKE_INSTALL_EXPORTDIR}/${FVL_PROJECT_END_NAME}")
        file(GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${FVL_PROJECT_END_L_NAME_LOWER}-config.cmake" INPUT "${CMAKE_CURRENT_BINARY_DIR}/${FVL_PROJECT_END_L_NAME_LOWER}-config.cmake.in")

        install(EXPORT ${FVL_PROJECT_END_NAME}-Targets FILE "${FVL_PROJECT_END_L_NAME_LOWER}-targets.cmake" DESTINATION "${CMAKE_INSTALL_EXPORTDIR}/${FVL_PROJECT_END_NAME}")
        install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${FVL_PROJECT_END_L_NAME_LOWER}-config.cmake" DESTINATION "${CMAKE_INSTALL_EXPORTDIR}/${FVL_PROJECT_END_NAME}")

        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/PackageConfig/${FVL_PROJECT_END_L_NAME_LOWER}-config.cmake" "# Empty file to trick find_package when added by add_subdirectory")
        set(${FVL_PROJECT_END_NAME}_DIR "${CMAKE_CURRENT_BINARY_DIR}/PackageConfig" CACHE PATH "${FVL_PROJECT_END_NAME} config directory" FORCE)

        export(PACKAGE ${FVL_PROJECT_END_NAME})

        unset(FVL_PROJECT_END_L_NAME_LOWER)
    endif()

    foreach(FVL_PROJECT_END_L_VAR IF NAME TARGET UNPARSED_ARGUMENTS)
        unset(FVL_PROJECT_END_${FVL_PROJECT_END_L_VAR})
    endforeach()
    unset(FVL_PROJECT_END_L_VAR)
endmacro()

########################################################################################################################
macro(FvlGenerateCoverageBat)
    get_property(FVL_GENERATE_COVERAGE_BAT_L_LIST GLOBAL PROPERTY FVL_TEST_EXE_LIST)
    message(STATUS "FvlGenerateCoverageBat(${FVL_GENERATE_COVERAGE_BAT_L_LIST})")

    set(FVL_GENERATE_COVERAGE_BAT_CONTENT "mkdir Temp")
    foreach(FVL_GENERATE_COVERAGE_BAT_L_EXE IN LISTS FVL_GENERATE_COVERAGE_BAT_L_LIST)
        set(FVL_GENERATE_COVERAGE_BAT_CONTENT "${FVL_GENERATE_COVERAGE_BAT_CONTENT}\nMicrosoft.CodeCoverage.Console collect ../bin/${FVL_GENERATE_COVERAGE_BAT_L_EXE} -f cobertura -o Temp/${FVL_GENERATE_COVERAGE_BAT_L_EXE}.xml")
    endforeach()
    set(FVL_GENERATE_COVERAGE_BAT_CONTENT "${FVL_GENERATE_COVERAGE_BAT_CONTENT}\nMicrosoft.CodeCoverage.Console merge \"Temp/*.xml\" -f cobertura -o cobertura.xml\n")

    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cover")

    file(
        GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/cover/Coverage.bat"
        CONTENT "${FVL_GENERATE_COVERAGE_BAT_CONTENT}"
    )

    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/cover/Coverage.bat" DESTINATION cover)
endmacro()

########################################################################################################################
FvlAddTarget(Shared TYPE Shared)
FvlAddTarget(Static TYPE Static SUFFIX Lib)
FvlAddTarget(Interface TYPE Interface)
FvlAddTarget(Hybrid TYPE Shared SUFFIX Hybrid)

