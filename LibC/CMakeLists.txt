cmake_minimum_required(VERSION 3.16)

project(LibC)

FvlAddLibrary(TARGET Shared Static Hybrid)
FvlTargetLinkLibraries(LibA LibB)
FvlTargetSources(LibC.cpp)
FvlTargetIncludeDirectories(API)
FvlProjectEnd()
