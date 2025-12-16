
#pragma once

#ifdef LIBC_EXPORTS
#ifdef __linux__
#define LIBC_API __attribute__((visibility("default")))
#else
#define LIBC_API __declspec(dllexport)
#endif
#elif defined(LIBC_IMPORTS)
#ifdef __linux__
#define LIBC_API
#else
#define LIBC_API __declspec(dllimport)
#endif
#else
#define LIBC_API
#endif
