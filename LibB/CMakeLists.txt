cmake_minimum_required(VERSION 3.16)

project(LibB)

FvlAddLibrary(TARGET Shared Static Hybrid)
FvlTargetLinkLibraries(Core LibA)
FvlTargetSources(LibB.cpp)
FvlTargetIncludeDirectories(API)
FvlProjectEnd()
