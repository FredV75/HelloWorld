
#include "LibC/ILibC.h"

#ifndef __linux__
#pragma warning(push, 1)
#pragma warning(disable: 4668) // '' is not defined as a preprocessor macro, replacing with '0' for '#if/#elif'
#pragma warning(disable: 4865) // the underlying type will change from 'int' to '__int64' when '/Zc:enumTypes' is specified
#include <Windows.h>
#include <crtdbg.h>
#pragma warning(pop)
#endif

int main(int a_argc, char *a_argv[], char *a_envs[])
{
#ifndef __linux__
    (void)_CrtSetDbgFlag(_CrtSetDbgFlag(_CRTDBG_REPORT_FLAG) | _CRTDBG_LEAK_CHECK_DF);
    // _CrtSetBreakAlloc(171);
    ::SetConsoleOutputCP(65001);
#endif

    (void)a_argc;
    (void)a_argv;
    (void)a_envs;

#ifdef HYBRID
#ifndef __linux__
    HMODULE hLib = ::LoadLibrary(LIBC_NAME);
    if (hLib)
    {
        FVL_MSVC_PRAGMA_WARNING_PUSH;
        FVL_MSVC_PRAGMA_WARNING(4191); // 'type cast': unsafe conversion

        FctCreate pFctCreate = (FctCreate)(::GetProcAddress(hLib, "ILibC_Create"));
        ILibC *pC = (*pFctCreate)();

        FctDelete pFctDelete = (FctDelete)(::GetProcAddress(hLib, "ILibC_Delete"));
        (*pFctDelete)(pC);

        FVL_MSVC_PRAGMA_WARNING_POP;

        ::FreeLibrary(hLib);
    }
#endif
#else
    ILibC *pC = ILibC::Create();
    ILibC::Delete(pC);
#endif

    char *pNew = new char[123];
    (void)pNew;
}

#if 0

// x64-linux.cmake
set(CMAKE_CXX_COMPILER "g++" CACHE STRING "")
set(CMAKE_C_COMPILER "gcc" CACHE STRING "")
set(CMAKE_ASM_COMPILER "gcc" CACHE STRING "")
set(CMAKE_ASM-ATT_COMPILER "as" CACHE STRING "")

ilammy/msvc-dev-cmd
arch: 'x86'
toolset: ''


#endif

