cmake_minimum_required(VERSION 3.20)

project(LibB)

FvlAddLibrary(TARGET Shared Static Hybrid)
FvlTargetLinkLibraries(Core LibA)
FvlTargetSources(LibB.cpp)
FvlTargetIncludeDirectories(API)
FvlProjectEnd()
