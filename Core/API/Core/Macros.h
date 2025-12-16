
#pragma once

#ifdef __linux__
#define FVL_PRAGMA_WARNING(x)
#else
#define FVL_PRAGMA_WARNING(x) __pragma(warning(x))
#endif

#define FVL_VIRTUAL_DESTRUCTOR(name)\
    FVL_PRAGMA_WARNING(push)\
    FVL_PRAGMA_WARNING(disable: 4710)\
    name() = default;\
    virtual ~name() = default;\
    name(const name &) = default;\
    name &operator=(const name &) = default;\
    FVL_PRAGMA_WARNING(pop)
