cmake_minimum_required(VERSION 3.20)

FvlProject(Shared)
FvlAddLibrary(TARGET Shared)
FvlTargetLinkLibraries(Core)
FvlTargetSources(Shared.cpp)
FvlTargetIncludeDirectories(API)
FvlProjectEnd()
