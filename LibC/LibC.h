
#pragma once

#include "LibC/ILibC.h"
#include "LibA/ILibA.h"
#include "LibB/ILibB.h"

class LibC : public ILibC
{
public:
    LibC();
    virtual ~LibC();

    ILibA *m_pILibA;
    ILibB *m_pILibB;
};

