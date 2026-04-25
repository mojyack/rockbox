#include "config.h"
#include "cpu.h"

ENTRY(start)
OUTPUT_FORMAT(elf32-littlearm)
OUTPUT_ARCH(arm)

#define PLUGINSIZE PLUGIN_BUFFER_SIZE
#define CODECSIZE CODEC_SIZE

#define IRAMSIZE IRAM_SIZE

#define DRAMSIZE (DRAM_SIZE - PLUGINSIZE - CODECSIZE - FRAME_SIZE - TTB_SIZE)

MEMORY
{
    IRAM :      ORIGIN = IRAM_ORIG,                           LENGTH = IRAMSIZE
    DRAM :      ORIGIN = CACHED_DRAM_ADDR,                    LENGTH = DRAMSIZE
    UDRAM :     ORIGIN = UNCACHED_DRAM_ADDR,                  LENGTH = DRAMSIZE
    CODECBUF :  ORIGIN = ORIGIN(DRAM) + LENGTH(DRAM),         LENGTH = CODECSIZE
    PLUGINBUF : ORIGIN = ORIGIN(CODECBUF) + LENGTH(CODECBUF), LENGTH = PLUGINSIZE
    /* LLD requires NOLOAD sections to have non-overlapping LMAs */
    NOLOAD_LMA : ORIGIN = ORIGIN(PLUGINBUF) + LENGTH(PLUGINBUF), LENGTH = 0x10000000
}

SECTIONS
{
    loadaddress = UNCACHED_DRAM_ADDR;
    _loadaddress = UNCACHED_DRAM_ADDR;

    _dramcopystart = ORIGIN(DRAM);

    .text :
    {
        *(.text*)
        *(.data*)
        *(.rodata*)
    } > DRAM

    _dramtextend = .;

    .itext :
    {
        _iramstart = .; // always 0
        KEEP(*(.vectors));// otherwise there are no references to it and the linker strip it
        *(.icode*)
        *(.irodata*)
        *(.idata*)
        _iramend = .;
    } > IRAM AT> DRAM

    _iramcopy = LOADADDR(.itext);

    .ibss (NOLOAD) :
        AT(ORIGIN(NOLOAD_LMA))
    {
        _iedata = .;
        *(.qharray)
        *(.ibss*)
        _iend = .;
    } > IRAM

    .init :
    {
        _initstart = .;
        *(.init*)
        _initend = .;
    } > CODECBUF AT> DRAM

    _initcopy = LOADADDR(.init);
    _dramcopyend = LOADADDR(.init) + SIZEOF(.init);

    /* crt0 needs a temporary stack which does not overlap with init and itext
     * and is in physical memory: put it *after* init and itext. A small one suffices */
    crt0_tmpstack_phys = _dramcopyend + 0x200 - CACHED_DRAM_ADDR + UNCACHED_DRAM_ADDR;

    /* the stack overlaps the init and itext region, to reclaim space */
    .stack _dramtextend (NOLOAD) :
        AT(LOADADDR(.ibss) + SIZEOF(.ibss))
    {
        *(.stack)
        stackbegin = .;
        . += 0x2000;
        stackend = .;
    } > DRAM

    /* treat .bss and .ncbss as a single section */
    .bss (NOLOAD) :
        AT(LOADADDR(.stack) + SIZEOF(.stack))
    {
        _edata = .;
        *(.bss*);
    } > DRAM

    /* align on cache size boundary to avoid mixing cached and noncached stuff */
    _ncbss_start = . - CACHED_DRAM_ADDR + UNCACHED_DRAM_ADDR;
    .ncbss _ncbss_start (NOLOAD) :
        AT(LOADADDR(.bss) + SIZEOF(.bss))
    {
        . = ALIGN(CACHEALIGN_SIZE);
        *(.ncbss*)
        . = ALIGN(CACHEALIGN_SIZE);
    } > UDRAM

    _end = . - UNCACHED_DRAM_ADDR + CACHED_DRAM_ADDR;

    audiobuffer = ALIGN(_end, 0x4);
    audiobufend = ORIGIN(CODECBUF);
    codecbuf = ORIGIN(CODECBUF);
    pluginbuf = ORIGIN(PLUGINBUF);

    /DISCARD/ :
    {
        *(.eh_frame)
        *(.ARM.exidx*)
        *(.ARM.extab*)
    }
}
