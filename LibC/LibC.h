
#pragma once

#include "LibC/ILibC.h"
#include "LibA/ILibA.h"
#include "LibB/ILibB.h"

class LibC : public ILibC
{
public:
    LibC();
    virtual ~LibC();

    LibC(const LibC &) = delete;
    LibC &operator=(const LibC &) = delete;

    ILibA *m_pILibA;
    ILibB *m_pILibB;
};

