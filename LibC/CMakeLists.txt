cmake_minimum_required(VERSION 3.20)

FvlProject(LibC)
FvlAddLibrary(TARGET Shared Static Hybrid)
FvlTargetLinkLibraries(Core LibA LibB)
FvlTargetSources(LibC.cpp)
FvlTargetIncludeDirectories(API)
FvlProjectEnd()
