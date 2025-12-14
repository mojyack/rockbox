#include "core_alloc.h"

#include "buffer.h"
#include "macros.h"

bool iap_alloc_buffer(size_t size, struct IAPAllocResult* result) {
    int handle = core_alloc_ex(size, &buflib_ops_locked);
    check_act(handle > 0, return false);
    uint8_t* ptr = core_get_data(handle);

    result->handle = handle;
    result->ptr    = ptr;
    return true;
}

bool iap_alloc_usb_send_buffer(size_t size, struct IAPAllocResult* result) {
    /* + 31 to handle worst-case misalignment */
    check_act(iap_alloc_buffer(size + 31, result), return false);

    /* align to 32 */
    result->ptr = (void*)((uintptr_t)(result->ptr + 31) & 0xffffffe0);
    /* uncached */
#if defined(UNCACHED_ADDR) && CONFIG_CPU != AS3525
    result->ptr = UNCACHED_ADDR(result->ptr);
#endif

    return true;
}
