cmake_minimum_required(VERSION 3.20)

FvlProject(HelloWorldApp)
FvlAddExecutable(TARGET Shared Static Hybrid)
FvlTargetLinkLibraries(Core LibC LibB LibA Shared Static)
FvlTargetSources(Main.cpp)
FvlProjectEnd()
