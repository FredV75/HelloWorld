cmake_minimum_required(VERSION 3.20)

project(Static)

FvlAddLibrary(TARGET Static)
FvlTargetLinkLibraries(Core LibC)
FvlTargetSources(Static.cpp)
FvlTargetIncludeDirectories(API)
FvlProjectEnd()
