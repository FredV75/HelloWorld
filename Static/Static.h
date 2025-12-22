
#pragma once

#include "Static/IStatic.h"

class Static : public IStatic
{
public:
    Static();
    virtual ~Static();

    Static(const Static &) = delete;
    Static &operator=(const Static &) = delete;
};

