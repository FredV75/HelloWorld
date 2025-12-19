cmake_minimum_required(VERSION 3.20)

project(Shared)

FvlAddLibrary(TARGET Shared)
FvlTargetLinkLibraries(Core)
FvlTargetSources(Shared.cpp)
FvlTargetIncludeDirectories(API)
FvlProjectEnd()
