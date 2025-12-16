
#pragma once

#ifdef LIBA_EXPORTS
#ifdef __linux__
#define LIBA_API __attribute__((visibility("default")))
#else
#define LIBA_API __declspec(dllexport)
#endif
#elif defined(LIBA_IMPORTS)
#ifdef __linux__
#define LIBA_API
#else
#define LIBA_API __declspec(dllimport)
#endif
#else
#define LIBA_API
#endif
