cmake_minimum_required(VERSION 3.16)

project(LibA)

FvlAddLibrary()
FvlTargetSources(LibA.cpp)
FvlTargetIncludeDirectories(API)
FvlProjectEnd()
