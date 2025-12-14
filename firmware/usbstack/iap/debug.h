#pragma once

/* debug switches */
#define DEBUG_ENABLE_INFO     0
#define DEBUG_ENABLE_ERROR    1
#define DEBUG_LCD_PRINT       0
#define DEBUG_DUMP_TX         0
#define DEBUG_DUMP_RX         0
#define DEBUG_HEXDUMP_NOLIMIT 0

#if DEBUG_ENABLE_INFO == 1 || DEBUG_ENABLE_ERROR == 1
#define LOGF_ENABLE
#include "logf.h"
#endif

void iap_lcd_scatter(const char* fmt, ...);

#if DEBUG_LCD_PRINT == 1
#undef logf
#define logf(...) iap_lcd_scatter(__VA_ARGS__)
#endif
