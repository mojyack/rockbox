#pragma once
#include <stdbool.h>
#include <stdint.h>

#include "config.h"

#ifdef USB_ENABLE_IAP
/* usbstack/iap/notification.c */
void iap_on_track_time_position(uint32_t pos_ms);
void iap_on_track_playback_index(uint32_t index, bool track_ready);
void iap_on_tracks_count(uint32_t count);
void iap_on_play_status(int status /* AUDIO_STATUS_* */);
void iap_on_volume(int volume);
void iap_on_shuffle_state(bool state);
void iap_on_repeat_state(int state);
#else
#define iap_on_track_time_position(...) {}
#define iap_on_track_playback_index(...) {}
#define iap_on_tracks_count(...) {}
#define iap_on_play_status(...) {}
#define iap_on_volume(...) {}
#define iap_on_shuffle_state(...) {}
#define iap_on_repeat_state(...) {}
#endif
