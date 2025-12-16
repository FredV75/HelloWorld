
#pragma once

#define FVL_STRINGIFY(x) #x
#define FVL_TOSTRING(x) FVL_STRINGIFY(x)

#define FVL_TYPEDEF_LINE(line) typedef void Line##line
#define FVL_TYPEDEF FVL_TYPEDEF_LINE(__LINE__)

#ifdef __linux__
#define FVL_MSVC_PRAGMA_WARNING_PUSH FVL_TYPEDEF
#define FVL_MSVC_PRAGMA_WARNING(x) FVL_TYPEDEF
#define FVL_MSVC_PRAGMA_WARNING_POP FVL_TYPEDEF
#define FVL_GCC_PRAGMA_WARNING_PUSH _Pragma("GCC diagnostic push"); FVL_TYPEDEF
#define FVL_GCC_PRAGMA_WARNING(x) _Pragma(FVL_TOSTRING(GCC diagnostic ignored x)); FVL_TYPEDEF
#define FVL_GCC_PRAGMA_WARNING_POP _Pragma("GCC diagnostic pop"); FVL_TYPEDEF
#else
#define FVL_MSVC_PRAGMA_WARNING_PUSH __pragma(warning(push)); FVL_TYPEDEF
#define FVL_MSVC_PRAGMA_WARNING(x) __pragma(warning(disable: x)); FVL_TYPEDEF
#define FVL_MSVC_PRAGMA_WARNING_POP __pragma(warning(pop)); FVL_TYPEDEF
#define FVL_GCC_PRAGMA_WARNING_PUSH FVL_TYPEDEF
#define FVL_GCC_PRAGMA_WARNING(x) FVL_TYPEDEF
#define FVL_GCC_PRAGMA_WARNING_POP FVL_TYPEDEF
#endif

#define FVL_VIRTUAL_DESTRUCTOR(name)\
    FVL_MSVC_PRAGMA_WARNING_PUSH;\
    FVL_MSVC_PRAGMA_WARNING(4710);\
    name() = default;\
    virtual ~name() = default;\
    name(const name &) = default;\
    name &operator=(const name &) = default;\
    FVL_MSVC_PRAGMA_WARNING_POP

