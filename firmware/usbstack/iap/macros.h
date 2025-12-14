#include "debug.h"

#if DEBUG_ENABLE_INFO == 1
#define LOG(fmt, ...) logf("%s:%d " fmt, __func__, __LINE__ __VA_OPT__(, __VA_ARGS__));
#else
#define LOG(...)
#endif

#if DEBUG_ENABLE_ERROR == 1
#define ERROR(fmt, ...) logf("%s:%d " fmt, __func__, __LINE__ __VA_OPT__(, __VA_ARGS__));
#else
#define ERROR(...)
#endif

#define check_act(cond, act, ...)                              \
    if(!(cond)) {                                              \
        ERROR("assertion failed" __VA_OPT__(":" __VA_ARGS__)); \
        act;                                                   \
    }

#define AS_PACKET_SIZE 192
#define AS_EP_IN       usb_iap_ep_allocs[0].ep
#define HID_EP_IN      usb_iap_ep_allocs[1].ep
