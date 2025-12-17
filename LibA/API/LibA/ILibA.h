
#pragma once

#include "LibAApi.h"
#include "Core/Macros.h"

class LIBA_API ILibA
{
public:
    static ILibA *Create();
    static void Delete(ILibA *a_pILibA);

    FVL_VIRTUAL_DESTRUCTOR(ILibA);
};

