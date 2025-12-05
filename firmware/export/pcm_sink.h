#pragma once
#include <stddef.h>
#include <stdint.h>

struct pcm_sink {
    /* characteristics */
    const unsigned long* samprs;
    uint16_t             num_samprs;
    uint16_t             default_sampr_index;

    /* operations */
    void (*init)(void);
    void (*postinit)(void);
    void (*set_sampr)(uint16_t index);
    void (*lock)(void);
    void (*unlock)(void);
    void (*play)(const void* addr, size_t size);
    void (*stop)(void);

    /* runtime states */
    unsigned long pending_sampr_index;
    unsigned long configured_sampr_index;
};

enum pcm_sink_ids {
    PCM_SINK_HARDWARE = 0,
};

/* defined in each platform pcm source */
extern struct pcm_sink hardware_pcm_sink;
