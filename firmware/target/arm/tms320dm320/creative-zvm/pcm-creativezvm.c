/***************************************************************************
 *             __________               __   ___.
 *   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
 *   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
 *   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
 *   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
 *                     \/            \/     \/    \/            \/
 * $Id$
 *
 * Copyright (C) 2007 by Karl Kurbjun
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ****************************************************************************/
#include "system.h"
#include "kernel.h"
#include "logf.h"
#include "audio.h"
#include "sound.h"
#include "file.h"
#include "dm320.h"
#include "audiohw.h"
#include "dsp-target.h"
#include "pcm-internal.h"
#include "pcm_sink.h"

static void sink_dma_init(void)
{
    IO_CLK_O1DIV = 3;
    /* Set GIO25 to CLKOUT1A */
    IO_GIO_FSEL2 |= 3;
    sleep(5);

    audiohw_init();

    audiohw_set_frequency(HW_FREQ_DEFAULT);

    /* init DSP */
//    dsp_init();
}

static void sink_dma_postinit(void)
{
    audiohw_postinit();

    /* wake DSP */
//    dsp_wake();
}

static void sink_set_freq(uint16_t freq)
{
    audiohw_set_frequency(freq);
}

static void sink_dma_start(const void *addr, size_t size)
{
    (void)addr;
    (void)size;
    DEBUGF("sink_dma_start(0x%x, %d)", addr, size);
}

static void sink_dma_stop(void)
{

}

static void sink_lock(void)
{

}

static void sink_unlock(void)
{

}

struct pcm_sink hardware_pcm_sink = {
    .samprs       = hw_freq_sampr,
    .num_samprs   = HW_NUM_FREQ,
    .default_freq = HW_FREQ_DEFAULT,
    .init         = sink_dma_init,
    .postinit     = sink_dma_postinit,
    .set_freq     = sink_set_freq,
    .lock         = sink_lock,
    .unlock       = sink_unlock,
    .play         = sink_dma_start,
    .stop         = sink_dma_stop,
};
