#pragma once
#include <stdbool.h>
#include <stddef.h>

struct IAPAllocResult {
    void* ptr;
    int   handle;
};

bool iap_alloc_buffer(size_t size, struct IAPAllocResult* result);
bool iap_alloc_usb_send_buffer(size_t size, struct IAPAllocResult* result);
