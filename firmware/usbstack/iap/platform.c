#include "audio.h"
#include "buffering.h"
#include "core_alloc.h"
#include "metadata.h"
#include "pcm_sink.h"
#include "playback.h"
#include "playlist.h"
#include "powermgmt.h"
#include "settings.h"
#include "sound.h"
#include "usb_drv.h"

#include "../usb_iap.h"
#include "debug.h"
#include "libiap/platform.h"
#include "macros.h"
#include "platform.h"

void* iap_platform_malloc(void* platform, size_t size, int flags) {
    struct Platform* plt = platform;
    for(size_t i = 0; i < ARRAYLEN(plt->malloc_results); i += 1) {
        if(plt->malloc_results[i].ptr != NULL) {
            continue;
        }
        struct IAPAllocResult result;
        if(flags & IAPPlatformMallocFlags_Uncached) {
            check_act(iap_alloc_usb_send_buffer(size, &result), return NULL);
        } else {
            check_act(iap_alloc_buffer(size, &result), return NULL);
        }
        plt->malloc_results[i] = result;
        return result.ptr;
    }
    ERROR("no free malloc slot");
    return NULL;
}

void iap_platform_free(void* platform, void* ptr) {
    struct Platform* plt = platform;
    for(size_t i = 0; i < ARRAYLEN(plt->malloc_results); i += 1) {
        if(plt->malloc_results[i].ptr == ptr) {
            core_free(plt->malloc_results[i].handle);
            plt->malloc_results[i].ptr = NULL;
            return;
        }
    }
    ERROR("no matching malloc slot");
}

int iap_platform_send_hid_report(void* platform, const void* ptr, size_t size) {
    (void)platform;
#if DEBUG_DUMP_TX == 1
    logf("==== dev ==== %p %u > %d", ptr, size, HID_EP_IN);
    iap_platform_dump_hex(ptr, MIN(size, 48));
#endif
    const int ret = usb_drv_send_nonblocking(HID_EP_IN, (void*)ptr, size);
    return ret == 0 ? (int)size : ret;
}

IAPBool iap_platform_get_ipod_serial_num(void* platform, struct IAPSpan* serial) {
    (void)platform;
    static const char* serial_num = "000000000000";
    return iap_span_append(serial, serial_num, strlen(serial_num) + 1);
}

enum IAPPlatformUSBSpeed iap_platform_get_usb_speed(void* platform) {
    (void)platform;
    return usb_drv_port_speed() ? IAPPlatformUSBSpeed_High : IAPPlatformUSBSpeed_Full;
}

IAPBool iap_platform_get_play_status(void* platform, struct IAPPlatformPlayStatus* status) {
    struct Platform* plt = platform;

    status->state = _iap_convert_play_status(audio_status());
    if(status->state == IAPIPodStatePlayStatus_PlaybackStopped) {
        return iap_true;
    }

    struct mp3entry* id3 = audio_current_track();
    check_act(id3 != NULL, return iap_false);
    status->track_total_ms = id3->length;
    status->track_pos_ms   = id3->elapsed;
    status->track_index    = playlist_get_display_index() - 1;
    status->track_count    = playlist_amount();
    status->track_caps     = IAPIPodStateTrackCapBits_HasReleaseDate;
    if(plt->aa_slot >= 0 && playback_current_aa_hid(plt->aa_slot) >= 0) {
        status->track_caps |= IAPIPodStateTrackCapBits_HasAlbumArts;
    }

    return iap_true;
}

IAPBool iap_platform_control(void* platform, enum IAPPlatformControl control) {
    (void)platform;

    long button = BUTTON_NONE;
    switch(control) {
    case IAPPlatformControl_TogglePlayPause:
        button = BUTTON_MULTIMEDIA_PLAYPAUSE;
        break;
    case IAPPlatformControl_Play:
        if(audio_status() != AUDIO_STATUS_PLAY) {
            button = BUTTON_MULTIMEDIA_PLAYPAUSE;
        }
        break;
    case IAPPlatformControl_Pause:
        if(audio_status() != AUDIO_STATUS_PAUSE) {
            button = BUTTON_MULTIMEDIA_PLAYPAUSE;
        }
        break;
    case IAPPlatformControl_Stop:
        button = BUTTON_MULTIMEDIA_STOP;
        break;
    case IAPPlatformControl_Next:
        button = BUTTON_MULTIMEDIA_NEXT;
        break;
    case IAPPlatformControl_Prev:
        button = BUTTON_MULTIMEDIA_PREV;
        break;
    }

    return button == BUTTON_NONE || button_queue_try_post(button, 0);
}

static uint8_t normalize_8(int val, int min, int max) {
    return 0xFF * (val - min) / (max - min);
}

IAPBool iap_platform_get_volume(void* platform, struct IAPPlatformVolumeStatus* status) {
    (void)platform;

    status->volume = _iap_convert_volume(global_status.volume);
    status->muted  = iap_false;
    return iap_true;
}

IAPBool iap_platform_get_power_status(void* platform, struct IAPPlatformPowerStatus* status) {
    (void)platform;
    status->battery_level = _iap_convert_battery_level(battery_level());
    status->state         = _iap_convert_charge_status(charge_state);
    return iap_true;
}

IAPBool iap_platform_get_shuffle_setting(void* platform, uint8_t* status) {
    (void)platform;
    *status = _iap_convert_shuffle_state(global_settings.playlist_shuffle);
    return iap_true;
}

IAPBool iap_platform_set_shuffle_setting(void* platform, uint8_t status) {
    (void)platform;

    if(status == IAPIPodStateShuffleSettingState_Tracks && !global_settings.playlist_shuffle) {
        global_settings.playlist_shuffle = true;
        settings_save();
        if(audio_status() & AUDIO_STATUS_PLAY) {
            playlist_randomise(NULL, current_tick, true);
        }
    } else if(status == IAPIPodStateShuffleSettingState_Off && global_settings.playlist_shuffle) {
        global_settings.playlist_shuffle = false;
        settings_save();
        if(audio_status() & AUDIO_STATUS_PLAY) {
            playlist_sort(NULL, true);
        }
    }
    return iap_true;
}

IAPBool iap_platform_get_repeat_setting(void* platform, uint8_t* status) {
    (void)platform;

    switch(global_settings.repeat_mode) {
    case REPEAT_OFF:
        *status = IAPIPodStateRepeatSettingState_Off;
        break;
    case REPEAT_ONE:
        *status = IAPIPodStateRepeatSettingState_Tracks;
        break;
    default:
        *status = IAPIPodStateRepeatSettingState_Albums;
        break;
    }
    return iap_true;
}

IAPBool iap_platform_set_repeat_setting(void* platform, uint8_t status) {
    (void)platform;

    int mode = global_settings.repeat_mode;
    switch(status) {
    case IAPIPodStateRepeatSettingState_Off:
        mode = REPEAT_OFF;
        break;
    case IAPIPodStateRepeatSettingState_Tracks:
        mode = REPEAT_ONE;
        break;
    case IAPIPodStateRepeatSettingState_Albums:
        mode = REPEAT_ALL;
        break;
    }
    if(global_settings.repeat_mode != mode) {
        global_settings.repeat_mode = mode;
        settings_save();
        if(audio_status() & AUDIO_STATUS_PLAY) {
            audio_flush_and_reload_tracks();
        }
    }
    return iap_true;
}

IAPBool iap_platform_get_date_time(void* platform, struct IAPDateTime* time) {
    (void)platform;
    _iap_convert_datetime(get_time(), time);
    return iap_true;
}

IAPBool iap_platform_get_backlight_level(void* platform, uint8_t* level) {
    (void)platform;

    *level = normalize_8(global_settings.brightness, MIN_BRIGHTNESS_SETTING, MAX_BRIGHTNESS_SETTING);
    return iap_true;
}

IAPBool iap_platform_get_hold_switch_state(void* platform, IAPBool* state) {
    (void)platform;

    *state = button_hold();
    return iap_true;
}

/* from uart iap */
/* TODO: do not depend on that */
void iap_get_trackinfo(const unsigned int track, struct mp3entry* id3);

IAPBool iap_platform_get_indexed_track_info(void* platform, uint32_t index, struct IAPPlatformTrackInfo* info) {
    struct Platform* plt = platform;

    struct playlist_track_info track;
    struct mp3entry            id3;
    check_act(playlist_get_track_info(NULL, index, &track) == 0, return iap_false);
    iap_get_trackinfo(index, &id3);

    if(info->total_ms != NULL) {
        *info->total_ms = id3.length;
    }
    if(info->caps != NULL) {
        *info->caps = IAPIPodStateTrackCapBits_HasReleaseDate;
        /* FIXME: respect index */
        if(plt->aa_slot >= 0 && playback_current_aa_hid(plt->aa_slot) >= 0) {
            *info->caps |= IAPIPodStateTrackCapBits_HasAlbumArts;
        }
    }
    if(info->release_date != NULL) {
        info->release_date->year    = id3.year;
        info->release_date->month   = 0;
        info->release_date->day     = 0;
        info->release_date->hour    = 0;
        info->release_date->minute  = 0;
        info->release_date->seconds = 0;
    }
    if(info->artist != NULL) {
        check_act(iap_span_append(info->artist, id3.artist, strlen(id3.artist) + 1), return iap_false);
    }
    if(info->composer != NULL) {
        check_act(iap_span_append(info->composer, id3.composer, strlen(id3.composer) + 1), return iap_false);
    }
    if(info->album != NULL) {
        check_act(iap_span_append(info->album, id3.album, strlen(id3.album) + 1), return iap_false);
    }
    if(info->title != NULL) {
        check_act(iap_span_append(info->title, id3.title, strlen(id3.title) + 1), return iap_false);
    }
    return iap_true;
}

IAPBool iap_platform_set_playing_track(void* platform, uint32_t index) {
    audio_skip((int)index - playlist_next(0));
    return iap_true;
}

IAPBool iap_platform_open_artwork(void* platform, uint32_t index, struct IAPPlatformArtwork* artwork) {
    struct Platform* plt = platform;
    /* only aa for currently playing track is available */
    check_act((int)index == playlist_get_display_index() - 1, return iap_false);
    const int hid = playback_current_aa_hid(plt->aa_slot);
    check_act(hid >= 0, return iap_false, "%d %d", plt->aa_slot, hid);
    struct bitmap* bmp;
    check_act(bufgetdata(hid, 0, (void*)&bmp) > 0, return iap_false);
    artwork->color  = iap_true;
    artwork->width  = bmp->width;
    artwork->height = bmp->height;
    artwork->opaque = hid;
    return iap_true;
}

IAPBool iap_platform_get_artwork_ptr(void* platform, struct IAPPlatformArtwork* artwork, struct IAPSpan* span) {
    struct Platform* plt = platform;

    /* check the albumart has not reloaded */
    /* FIXME: not a correct check due to possibility of hid confliction */
    const int hid = playback_current_aa_hid(plt->aa_slot);
    check_act(hid == (int)artwork->opaque, return iap_false);

    struct bitmap* bmp;
    /* more checks */
    check_act(bufgetdata(hid, 0, (void*)&bmp) > 0, return iap_false);
    check_act(bmp->width == artwork->width && bmp->height == artwork->height, return iap_false);

    span->ptr  = bmp->data;
    span->size = bmp->width * bmp->height * 2;
    return iap_true;
}

IAPBool iap_platform_close_artwork(void* platform, struct IAPPlatformArtwork* artwork) {
    (void)platform;
    (void)artwork;
    return iap_true;
}

void iap_platform_dump_hex(const void* ptr, size_t size) {
    if(ptr == NULL) {
        logf("(null)");
        return;
    }

#if DEBUG_HEXDUMP_NOLIMIT != 1
    size = MIN(size, 32);
#endif

    static const char chars[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

    char line[4 * (8 + 1) + 1];
    for(size_t l = 0; l * 16 < size; l += 1) {
        char* c = line;
        for(size_t b = 0; b < 4; b += 1) {
            for(size_t i = 0; i < 4; i += 1) {
                size_t index = l * 16 + b * 4 + i;
                if(index >= size) {
                    break;
                }
                *c++ = chars[((uint8_t*)ptr)[index] >> 4];
                *c++ = chars[((uint8_t*)ptr)[index] & 0xF];
            }
            *c++ = ' ';
        }
        *c++ = '\0';
        logf("%04X: %s", l * 16, line);
    }
}

IAPBool iap_platform_on_acc_samprs_received(void* platform, struct IAPSpan* samprs) {
    (void)platform;

    bool has_44k = false;
    bool has_48k = false;
    while(samprs->size > 0) {
        uint32_t sample_rate;
        check_act(iap_span_read_32(samprs, &sample_rate), return iap_false);
        has_44k |= sample_rate == SAMPR_44;
        has_48k |= sample_rate == SAMPR_48;
    }
    check_act(has_44k && has_48k, return iap_false, "accessory lacks mandatory freq support: 44k=%d 48k=%d", has_44k, has_48k);
    check_act(pcm_switch_sink(PCM_SINK_IAP), return false);
    return iap_true;
}

uint8_t _iap_convert_play_status(int rb_audio_status) {
    if(rb_audio_status & AUDIO_STATUS_PAUSE) {
        return IAPIPodStatePlayStatus_PlaybackPaused;
    } else if(rb_audio_status & AUDIO_STATUS_PLAY) {
        return IAPIPodStatePlayStatus_Playing;
    } else {
        return IAPIPodStatePlayStatus_PlaybackStopped;
    }
}

uint8_t _iap_convert_volume(int rb_volume) {
    return normalize_8(rb_volume, sound_min(SOUND_VOLUME), sound_max(SOUND_VOLUME));
}

uint8_t _iap_convert_shuffle_state(bool rb_state) {
    return rb_state ? IAPIPodStateShuffleSettingState_Tracks : IAPIPodStateShuffleSettingState_Off;
}

uint8_t _iap_convert_repeat_state(int rb_state) {
    switch(rb_state) {
    case REPEAT_OFF:
        return IAPIPodStateRepeatSettingState_Off;
    case REPEAT_ONE:
        return IAPIPodStateRepeatSettingState_Tracks;
    default:
        return IAPIPodStateRepeatSettingState_Albums;
    }
}

uint8_t _iap_convert_battery_level(int rb_battery_level) {
    return 0xFF * rb_battery_level / 100;
}

uint8_t _iap_convert_charge_status(enum charge_state_type rb_charge_state) {
    switch(rb_charge_state) {
    case CHARGING:
        return IAPIPodStatePowerState_ExternalCharging;
    case TOPOFF:
    case TRICKLE:
        return IAPIPodStatePowerState_ExternalCharged;
        break;
    default:
        return IAPIPodStatePowerState_Internal;
    }
}

void _iap_convert_datetime(struct tm* rb_time, struct IAPDateTime* time) {
    time->year    = rb_time->tm_year + 1900;
    time->month   = rb_time->tm_mon + 1;
    time->day     = rb_time->tm_mday;
    time->hour    = rb_time->tm_hour;
    time->minute  = rb_time->tm_min;
    time->seconds = rb_time->tm_sec;
}
