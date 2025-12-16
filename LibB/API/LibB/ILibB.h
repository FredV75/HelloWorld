
#pragma once

#include "LibBApi.h"
#include "Core/Macros.h"
#include "LibA/ILibA.h"

FVL_MSVC_PRAGMA_WARNING_PUSH;
FVL_MSVC_PRAGMA_WARNING(4275); // non dll-interface class used as base for dll-interface class

class LIBB_API ILibB : public ILibA
{
public:
    static ILibB *Create();
    static void Delete(ILibB *a_pILibB);

    FVL_VIRTUAL_DESTRUCTOR(ILibB);
};

FVL_MSVC_PRAGMA_WARNING_POP;

