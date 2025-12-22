
#pragma once

#include "LibB/ILibB.h"

class LibB : public ILibB
{
public:
    LibB();
    virtual ~LibB();

    virtual int VirtualFct() const;

    LibB(const LibB &) = delete;
    LibB &operator=(const LibB &) = delete;
};

