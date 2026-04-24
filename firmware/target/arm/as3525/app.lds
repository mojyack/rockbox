#include "config.h"
#include "cpu.h"

ENTRY(start)

OUTPUT_FORMAT(elf32-littlearm)
OUTPUT_ARCH(arm)

#define PLUGINSIZE PLUGIN_BUFFER_SIZE
#define CODECSIZE CODEC_SIZE

/* End of the audio buffer, where the codec buffer starts */
#define ENDAUDIOADDR  (DRAM_ORIG + DRAMSIZE)

#if defined(AMS_LOWMEM) || (CONFIG_CPU == AS3525v2)
#define CODEC_BUFFER_FILLS_IRAM 1
#else
#define CODEC_BUFFER_FILLS_IRAM 0
#endif

#if CODEC_BUFFER_FILLS_IRAM
/* Entire codec buffer in IRAM */
#define DRAMSIZE (DRAM_SIZE - PLUGINSIZE - TTB_SIZE)
#define CODECORIG (IRAM_ORIG + (IRAM_SIZE - CODEC_SIZE))
#define IRAMSIZE (IRAM_SIZE - CODEC_SIZE)
#else
#define DRAMSIZE (DRAM_SIZE - PLUGINSIZE - CODECSIZE - TTB_SIZE)
#define CODECORIG (ENDAUDIOADDR)
#define IRAMSIZE (0x20000)
#endif


/* Where the codec buffer ends, and the plugin buffer starts */
#if CODEC_BUFFER_FILLS_IRAM
#define ENDADDR (ENDAUDIOADDR)
#else
#define ENDADDR (ENDAUDIOADDR + CODECSIZE)
#endif

MEMORY
{
#if CODEC_BUFFER_FILLS_IRAM
    CODEC_IRAM : ORIGIN = CODECORIG, LENGTH = CODEC_SIZE
#endif
    IRAM : ORIGIN = IRAM_ORIG, LENGTH = IRAMSIZE
    DRAM : ORIGIN = DRAM_ORIG, LENGTH = DRAMSIZE
    CODECBUF :   ORIGIN = CODECORIG,                          LENGTH = CODECSIZE
    PLUGINBUF :  ORIGIN = ENDADDR,                            LENGTH = PLUGINSIZE
    /* LLD requires NOLOAD sections to have non-overlapping LMAs */
    NOLOAD_LMA : ORIGIN = ORIGIN(PLUGINBUF) + LENGTH(PLUGINBUF), LENGTH = 0x10000000
}

SECTIONS
{
    loadaddress = DRAM_ORIG;

    .vectors :
    {
        _vectors_start = .;
        *(.init.text)
    } > DRAM

    .text :
    {
        _loadaddress = .;
        _textstart = .;
        *(.text*)
        *(.glue_7)
        *(.glue_7t)
        . = ALIGN(0x4);
    } > DRAM

    .rodata :
    {
        *(.rodata*)
        . = ALIGN(0x4);
    } > DRAM

    .data :
    {
        *(.data*)
        . = ALIGN(0x4);
    } > DRAM

    /DISCARD/ :
    {
        *(.eh_frame)
    }

    .iram :
    {
        _iramstart = .;
        *(.icode*)
        *(.irodata*)
        *(.idata*)
        . = ALIGN(0x4);
        _iramend = .;
    } > IRAM AT> DRAM

    _iramcopy = LOADADDR(.iram);

    .ibss (NOLOAD) :
    {
        _iedata = .;
        *(.qharray)
        *(.ibss*)
        . = ALIGN(0x4);
        _iend = .;
    } > IRAM AT> NOLOAD_LMA

    .init :
    {
        . = ALIGN(4);
        _initstart = .;
        *(.init*)
        _initend = .;
    } > CODECBUF AT> DRAM

    _initcopy = LOADADDR(.init);

    .stack _iramcopy (NOLOAD) :
    {
       *(.stack)
       stackbegin = .;
       . += 0x2000;
       stackend = .;
    } > DRAM AT> NOLOAD_LMA

    .bss (NOLOAD) :
    {
       _edata = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(0x4);
       _end = .;
    } > DRAM AT> NOLOAD_LMA

    audiobuffer = ALIGN(_end, 0x4);
    audiobufend = ENDAUDIOADDR;
    codecbuf = CODECORIG;
    pluginbuf = ORIGIN(PLUGINBUF);
}
