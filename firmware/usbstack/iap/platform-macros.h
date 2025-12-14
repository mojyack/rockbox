#pragma once
#include "debug.h"

#if DEBUG_ENABLE_INFO == 1
#define IAP_LOGF(...)   logf(__VA_ARGS__)
#else
#define IAP_LOGF(...)
#endif

#if DEBUG_ENABLE_ERROR == 1
#define IAP_ERRORF(...) logf(__VA_ARGS__)
#else
#define IAP_ERRORF(...)
#endif

#define IAP_ARTWORK_WIDTH  128
#define IAP_ARTWORK_HEIGHT 128
#define IAP_COLOR_ARTWORK  iap_true
