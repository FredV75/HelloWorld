
#include "LibA.h"

ILibA *ILibA::Create()
{
    return new LibA;
}

void ILibA::Delete(ILibA *a_pILibA)
{
    delete a_pILibA;
}

LibA::LibA()
{
}

LibA::~LibA()
{
}

