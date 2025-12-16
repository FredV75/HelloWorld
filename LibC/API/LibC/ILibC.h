
#pragma once

#include "LibCApi.h"

class LIBC_API ILibC
{
public:
    virtual ~ILibC() {}

    static ILibC *Create();
    static void Delete(ILibC *a_pILibC);
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

