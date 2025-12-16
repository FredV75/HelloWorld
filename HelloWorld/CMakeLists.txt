cmake_minimum_required(VERSION 3.16)

project(HelloWorldApp)

FvlAddExecutable(TARGET Shared Static Hybrid)
FvlTargetLinkLibraries(Core LibC LibB LibA)
FvlTargetSources(Main.cpp)
FvlProjectEnd()
