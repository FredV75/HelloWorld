
#pragma once

#include "LibAApi.h"

#pragma warning(push)
#pragma warning(disable: 5267) // definition of implicit copy constructor for 'ILibA' is deprecated because it has a user-provided destructor

class LIBA_API ILibA
{
public:
    virtual ~ILibA() {}

    static ILibA *Create();
    static void Delete(ILibA *a_pILibA);
};

#pragma warning(pop)

