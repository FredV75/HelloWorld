
#include "LibC.h"

ILibC *ILibC::Create()
{
    return new LibC;
}

void ILibC::Delete(ILibC *a_pILibC)
{
    delete a_pILibC;
}

LibC::LibC() : m_pILibA(0), m_pILibB(0)
{
    m_pILibA = ILibA::Create();
    m_pILibB = ILibB::Create();
}

LibC::~LibC()
{
    ILibB::Delete(m_pILibB);
    ILibA::Delete(m_pILibA);
}

#ifdef HYBRID
extern "C"
{
    LIBC_API ILibC *ILibC_Create()
    {
        return ILibC::Create();
    }

    LIBC_API void ILibC_Delete(ILibC *a_pILibC)
    {
        ILibC::Delete(a_pILibC);
    }
}
#endif

