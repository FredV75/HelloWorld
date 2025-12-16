
#pragma once

#include "LibCApi.h"
#include "Core/Macros.h"

class LIBC_API ILibC
{
public:
    static ILibC *Create();
    static void Delete(ILibC *a_pILibC);

    FVL_VIRTUAL_DESTRUCTOR(ILibC);
};

#ifdef HYBRID
extern "C"
{
#ifdef _DEBUG
#define LIBC_NAME "LibCHybridD.dll"
#else
#define LIBC_NAME "LibCHybrid.dll"
#endif

    typedef ILibC *(*FctCreate)();
    LIBC_API ILibC *ILibC_Create();

    typedef void (*FctDelete)(ILibC *);
    LIBC_API void ILibC_Delete(ILibC *a_pILibC);
}
#endif

