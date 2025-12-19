
#pragma once

#ifdef STATIC_EXPORTS
#ifdef __linux__
#define STATIC_API __attribute__((visibility("default")))
#else
#define STATIC_API __declspec(dllexport)
#endif
#elif defined(STATIC_IMPORTS)
#ifdef __linux__
#define STATIC_API
#else
#define STATIC_API __declspec(dllimport)
#endif
#else
#define STATIC_API
#endif
