
#pragma once

#include "Static/IStatic.h"
#include "LibC/ILibC.h"

class Static : public IStatic
{
public:
    Static();
    virtual ~Static();

    ILibC *m_pILibC;
};

