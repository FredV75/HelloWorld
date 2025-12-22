
#include "LibB.h"

ILibB *ILibB::Create()
{
    return new LibB;
}

void ILibB::Delete(ILibB *a_pILibB)
{
    delete a_pILibB;
}

LibB::LibB()
{
}

LibB::~LibB()
{
}

int LibB::VirtualFct() const
{
    return 0;
}

