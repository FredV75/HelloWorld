
#include "LibC/ILibC.h"
#include "Shared/IShared.h"
#include "Static/IStatic.h"

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

#ifdef FVL_32B
    static_assert(sizeof(void*) == 4, "mismatch");
#else
    static_assert(sizeof(void*) == 8, "mismatch");
#endif

#ifdef FVL_64B
    static_assert(sizeof(void*) == 8, "mismatch");
#else
    static_assert(sizeof(void*) == 4, "mismatch");
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

    IShared *pShared = IShared::Create();
    IShared::Delete(pShared);

    IStatic *pStatic = IStatic::Create();
    IStatic::Delete(pStatic);

    char *pNew = new char[123];
    (void)pNew;

    return 0;
}

