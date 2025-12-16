
#pragma once

#ifdef LIBB_EXPORTS
#ifdef __linux__
#define LIBB_API __attribute__((visibility("default")))
#else
#define LIBB_API __declspec(dllexport)
#endif
#elif defined(LIBB_IMPORTS)
#ifdef __linux__
#define LIBB_API
#else
#define LIBB_API __declspec(dllimport)
#endif
#else
#define LIBB_API
#endif
