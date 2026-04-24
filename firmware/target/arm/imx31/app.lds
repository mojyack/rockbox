#include "config.h"

ENTRY(start)

OUTPUT_FORMAT(elf32-littlearm)
OUTPUT_ARCH(arm)

#define PLUGINSIZE PLUGIN_BUFFER_SIZE
#define CODECSIZE CODEC_SIZE

#include "imx31l.h"
/* Subtract 1MB for the FRAME/TTB section */
#define DRAMSIZE ((MEMORYSIZE * 0x100000) - CODECSIZE - \
                  PLUGINSIZE - QHARRAY_SIZE - FRAME_SIZE - TTB_SIZE)

#define DRAMORIG 0x0
/* #define IRAMORIG 0x1FFFC000 */
#define IRAMORIG DRAMORIG
#define IRAM     DRAM
#define IRAMSIZE IRAM_SIZE

/* INIT section is the codec buffer */
#define INITSIZE  CODECSIZE

MEMORY
{
    DRAM :      ORIGIN = DRAMORIG,                            LENGTH = DRAMSIZE
    CODECBUF :  ORIGIN = ORIGIN(DRAM) + LENGTH(DRAM),         LENGTH = CODECSIZE
    PLUGINBUF : ORIGIN = ORIGIN(CODECBUF) + LENGTH(CODECBUF), LENGTH = PLUGINSIZE
    QHARRAY :   ORIGIN = QHARRAY_PHYS_ADDR,                   LENGTH = QHARRAY_SIZE
    /* LLD requires NOLOAD sections to have non-overlapping LMAs */
    NOLOAD_LMA : ORIGIN = ORIGIN(QHARRAY) + LENGTH(QHARRAY),  LENGTH = 0x10000000
}

SECTIONS
{
    .text :
    {
        loadaddress = .;
        _loadaddress = .;
        . = ALIGN(0x200);
        *(.init.text)
        *(.text*)
        *(.icode*)
        *(.glue_7)
        *(.glue_7t)
        . = ALIGN(0x4);
    } > DRAM

    .rodata :
    {
        *(.rodata*)
        *(.irodata*)
        . = ALIGN(0x4);
    } > DRAM

    .data :
    {
        *(.data*)
        *(.idata*)
        . = ALIGN(0x4);
    } > DRAM

#if 0 /* Unneeded at the moment */
    /* .ncdata section is placed at uncached physical alias address and is
     * loaded at the proper cached virtual address - no copying is
     * performed in the init code */
    .ncdata . + NOCACHE_BASE :
    {
        . = ALIGN(CACHEALIGN_SIZE); /* >= Cache line boundary */
        *(.ncdata*)
        . = ALIGN(CACHEALIGN_SIZE); /* >= Cache line boundary */
    } AT> DRAM
#endif
    /DISCARD/ :
    {
        *(.eh_frame)
    }

    /*
     * See .vectors of app-pp.lds for the rationale on placing .vectors
     * in NOLOAD_LMA.
     */
    .vectors :
    {
        KEEP(*(.vectors))
    } > NOLOAD_LMA AT> DRAM

    _vectorsstart = 0;
    _vectorsend = SIZEOF(.vectors);
    _vectorscopy = LOADADDR(.vectors);
    _noloaddram = LOADADDR(.vectors);

    .init :
    {
        . = ALIGN(4);
        _initstart = .;
        *(.init*)
        _initend = .;
    } > CODECBUF AT> DRAM

    _initcopy = LOADADDR(.init);

    .stack _noloaddram (NOLOAD) :
    {
        . = ALIGN(4);
        *(.stack)
        stackbegin = .;
        . += 0x2000;
        stackend = .;
    } > DRAM AT> NOLOAD_LMA

    /* .bss and .ncbss are treated as a single section to use one init loop
     * to zero them */
    .bss (NOLOAD) :
    {
        _edata = .;
        *(.bss*)
        *(.ibss*)
        *(COMMON)
        . = ALIGN(0x4);
    } > DRAM AT> NOLOAD_LMA

    .ncbss (NOLOAD) :
    {
        . = ALIGN(CACHEALIGN_SIZE); /* >= Cache line boundary */
        *(.ncbss*)
        . = ALIGN(CACHEALIGN_SIZE); /* >= Cache line boundary */
    } > DRAM AT> NOLOAD_LMA

    _end = .;

    audiobuffer = ALIGN(_end, 0x4);
    audiobufend = ORIGIN(CODECBUF);
    codecbuf = ORIGIN(CODECBUF);
    pluginbuf = ORIGIN(PLUGINBUF);

    .qharray (NOLOAD) :
    {
        _qharray = .;
        *(.qharray)
        _qharrayend = .;
    } > QHARRAY AT> NOLOAD_LMA
}

