cmake_minimum_required(VERSION 3.20)

project(LibA)

FvlAddLibrary()
FvlTargetLinkLibraries(Core)
FvlTargetSources(LibA.cpp)
FvlTargetIncludeDirectories(API)
FvlProjectEnd()
