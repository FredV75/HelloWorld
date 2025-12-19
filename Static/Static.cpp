
#include "Static.h"

IStatic *IStatic::Create()
{
    return new Static;
}

void IStatic::Delete(IStatic *a_pIStatic)
{
    delete a_pIStatic;
}

Static::Static()
{
}

Static::~Static()
{
}

