
#pragma once

#include "LibBApi.h"
#include "Core/Macros.h"
#include "LibA/ILibA.h"

#pragma warning(push)
#pragma warning(disable: 4275) // non dll-interface class used as base for dll-interface class

class LIBB_API ILibB : public ILibA
{
public:
    static ILibB *Create();
    static void Delete(ILibB *a_pILibB);

    FVL_VIRTUAL_DESTRUCTOR(ILibB)
};

#pragma warning(pop)

