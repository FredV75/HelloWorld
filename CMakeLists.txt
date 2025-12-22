cmake_minimum_required(VERSION 3.20)

include(CMake/FvlHelpers.cmake)

project(HelloWorld)

include(CTest)
enable_testing()

add_subdirectory(Core)
add_subdirectory(LibA)
add_subdirectory(LibB)
add_subdirectory(LibC)
add_subdirectory(Shared)
add_subdirectory(Static)
add_subdirectory(HelloWorld)
add_subdirectory(UnitTest)

message(STATUS "########################################################################################################################")
#FvlPrintVariables()
FvlPrintVariables(FVL_)
#FvlPrintDefinitions(LibB-Shared)
#FvlPrintDefinitions(LibB-Static)
#FvlPrintDefinitions(LibB-Interface)
#FvlPrintDefinitions(LibB-Hybrid)
#FvlPrintVariables("^FVL_|^l_|^a_")
#message(STATUS "########################################################################################################################")

get_property(FVL_CMAKELISTS_TXT_LIST_L_LIST GLOBAL PROPERTY FVL_CMAKELISTS_TXT_LIST)
message(STATUS "!!! TXT => ${FVL_CMAKELISTS_TXT_LIST_L_LIST}")

get_property(FVL_TEST_EXE_LIST_L_LIST GLOBAL PROPERTY FVL_TEST_EXE_LIST)
message(STATUS "!!! EXE => ${FVL_TEST_EXE_LIST_L_LIST}")

FvlGenerateCoverageBat()

