
#pragma once

#include "Shared/IShared.h"

class Shared : public IShared
{
public:
    Shared();
    virtual ~Shared();

    Shared(const Shared &) = delete;
    Shared &operator=(const Shared &) = delete;
};

