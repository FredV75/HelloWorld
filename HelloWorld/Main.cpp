
#include "LibC/ILibC.h"

#ifndef __linux__
#pragma warning(push, 1)
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
    HMODULE hLib = ::LoadLibrary(LIBC_NAME);
    if (hLib)
    {
#pragma warning(push)
#pragma warning(disable: 4191) // 'type cast': unsafe conversion
        FctCreate pFctCreate = (FctCreate)(::GetProcAddress(hLib, "ILibC_Create"));
        ILibC *pC = (*pFctCreate)();

        FctDelete pFctDelete = (FctDelete)(::GetProcAddress(hLib, "ILibC_Delete"));
        (*pFctDelete)(pC);
#pragma warning(pop)

        ::FreeLibrary(hLib);
    }
#else
    ILibC *pC = ILibC::Create();
    ILibC::Delete(pC);
#endif

    char *pNew = new char[123];
    (void)pNew;
}
