
#pragma once

#define FVL_STRINGIFY(x) #x
#define FVL_TOSTRING(x) FVL_STRINGIFY(x)

#ifdef __linux__
#define FVL_MSVC_PRAGMA_WARNING_PUSH
#define FVL_MSVC_PRAGMA_WARNING(x)
#define FVL_MSVC_PRAGMA_WARNING_POP
#define FVL_GCC_PRAGMA_WARNING_PUSH _Pragma("GCC diagnostic push")
#define FVL_GCC_PRAGMA_WARNING(x) _Pragma(FVL_TOSTRING(GCC diagnostic ignored x))
#define FVL_GCC_PRAGMA_WARNING_POP _Pragma("GCC diagnostic pop")
#else
#define FVL_MSVC_PRAGMA_WARNING_PUSH __pragma(warning(push))
#define FVL_MSVC_PRAGMA_WARNING(x) __pragma(warning(disable: x))
#define FVL_MSVC_PRAGMA_WARNING_POP __pragma(warning(pop))
#define FVL_GCC_PRAGMA_WARNING_PUSH
#define FVL_GCC_PRAGMA_WARNING(x)
#define FVL_GCC_PRAGMA_WARNING_POP
#endif

#define FVL_VIRTUAL_DESTRUCTOR(name)\
    FVL_MSVC_PRAGMA_WARNING_PUSH\
    FVL_MSVC_PRAGMA_WARNING(4710)\
    name() = default;\
    virtual ~name() = default;\
    name(const name &) = default;\
    name &operator=(const name &) = default;\
    FVL_MSVC_PRAGMA_WARNING_POP

