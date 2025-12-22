
#pragma once

#include "LibA/ILibA.h"

class LibA : public ILibA
{
public:
    LibA();
    virtual ~LibA();

    virtual int VirtualFct() const;

    LibA(const LibA &) = delete;
    LibA &operator=(const LibA &) = delete;
};

