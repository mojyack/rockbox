#pragma once
#include <stdint.h>

#include "libiap/datetime.h"
#include "powermgmt.h"
#include "time.h"

#include "buffer.h"

struct Platform {
    struct IAPAllocResult malloc_results[4]; /* allow up to 4 mallocs */

    int aa_slot;
};

/* helper functions */
uint8_t _iap_convert_play_status(int rb_audio_status);
uint8_t _iap_convert_volume(int rb_volume);
uint8_t _iap_convert_shuffle_state(bool rb_state);
uint8_t _iap_convert_repeat_state(int rb_state);
uint8_t _iap_convert_battery_level(int rb_battery_level);
uint8_t _iap_convert_charge_status(enum charge_state_type rb_charge_state);
void    _iap_convert_datetime(struct tm* rb_time, struct IAPDateTime* time);
