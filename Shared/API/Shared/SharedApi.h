
#pragma once

#ifdef SHARED_EXPORTS
#ifdef __linux__
#define SHARED_API __attribute__((visibility("default")))
#else
#define SHARED_API __declspec(dllexport)
#endif
#elif defined(SHARED_IMPORTS)
#ifdef __linux__
#define SHARED_API
#else
#define SHARED_API __declspec(dllimport)
#endif
#else
#define SHARED_API
#endif
