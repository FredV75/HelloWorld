
#pragma once

#include "SharedApi.h"
#include "Core/Macros.h"

class SHARED_API IShared
{
public:
    static IShared *Create();
    static void Delete(IShared *a_pIShared);

    FVL_VIRTUAL_DESTRUCTOR(IShared);
};

