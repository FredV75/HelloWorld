
#include "Shared.h"

IShared *IShared::Create()
{
    return new Shared;
}

void IShared::Delete(IShared *a_pIShared)
{
    delete a_pIShared;
}

Shared::Shared()
{
}

Shared::~Shared()
{
}

