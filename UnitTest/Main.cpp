
#include "LibA/ILibA.h"
#include "LibB/ILibB.h"
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

#include <memory>

void Test32bits()
{
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
}

void TestILibA()
{
    ILibA *pILibA = ILibA::Create();
    std::unique_ptr <ILibA, void (*)(ILibA*)> autoDeleteA(pILibA, [](ILibA *a_pILibA){ ILibA::Delete(a_pILibA); });
}

void TestILibB()
{
    ILibB *pILibB = ILibB::Create();
    std::unique_ptr <ILibB, void (*)(ILibB*)> autoDeleteB(pILibB, [](ILibB *a_pILibB){ ILibB::Delete(a_pILibB); });
}

void TestILibC()
{
    ILibC *pILibC = ILibC::Create();
    std::unique_ptr <ILibC, void (*)(ILibC*)> autoDeleteC(pILibC, [](ILibC *a_pILibC){ ILibC::Delete(a_pILibC); });
}

void TestShared()
{
    IShared *pIShared = IShared::Create();
    std::unique_ptr <IShared, void (*)(IShared*)> autoDeleteShared(pIShared, [](IShared *a_pIShared){ IShared::Delete(a_pIShared); });
}

void TestStatic()
{
    IStatic *pIStatic = IStatic::Create();
    std::unique_ptr <IStatic, void (*)(IStatic*)> autoDeleteStatic(pIStatic, [](IStatic *a_pIStatic){ IStatic::Delete(a_pIStatic); });
}

void TestHybrid()
{
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
}

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

    Test32bits();
    TestILibA();
    TestILibB();
    TestILibC();
    TestShared();
    TestStatic();
    TestHybrid();

    return 0;
}

