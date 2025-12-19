
#pragma once

#include "StaticApi.h"
#include "Core/Macros.h"

class STATIC_API IStatic
{
public:
    static IStatic *Create();
    static void Delete(IStatic *a_pIStatic);

    FVL_VIRTUAL_DESTRUCTOR(IStatic);
};

