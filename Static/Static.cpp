
#include "Static.h"

IStatic *IStatic::Create()
{
    return new Static;
}

void IStatic::Delete(IStatic *a_pIStatic)
{
    delete a_pIStatic;
}

Static::Static() : m_pILibC(0)
{
    m_pILibC = ILibC::Create();
}

Static::~Static()
{
    ILibC::Delete(m_pILibC);
}

