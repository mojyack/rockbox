#define __ASSEMBLER__
#include "cpu.h"

/* Will have been included from app.lds */
ENTRY(start)

OUTPUT_FORMAT(elf32-littlearm)
OUTPUT_ARCH(arm)

#define PLUGINSIZE PLUGIN_BUFFER_SIZE
#define CODECSIZE CODEC_SIZE

#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGINSIZE - CODECSIZE

#define DRAMORIG 0x00000000
#define IRAMORIG 0x40000000
#define IRAMSIZE 0xc000

MEMORY
{
    DRAM :      ORIGIN = DRAMORIG,                            LENGTH = DRAMSIZE
    CODECBUF :  ORIGIN = ORIGIN(DRAM) + LENGTH(DRAM),         LENGTH = CODECSIZE
    PLUGINBUF : ORIGIN = ORIGIN(CODECBUF) + LENGTH(CODECBUF), LENGTH = PLUGINSIZE
    IRAM :      ORIGIN = IRAMORIG,                            LENGTH = IRAMSIZE
#if NOCACHE_BASE != 0
    NCRAM :     ORIGIN = ORIGIN(DRAM) + NOCACHE_BASE,         LENGTH = DRAMSIZE
#endif
   /* LLD requires NOLOAD sections to have non-overlapping LMAs */
    NOLOAD_LMA : ORIGIN = ORIGIN(PLUGINBUF) + LENGTH(PLUGINBUF), LENGTH = 0x10000000
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
        *(.glue_7)
        *(.glue_7t)
        . = ALIGN(0x4);
    } > DRAM

    .rodata :
    {
        *(.rodata)  /* problems without this, dunno why */
        *(.rodata*)
        *(.rodata.str1.1)
        *(.rodata.str1.4)
        . = ALIGN(0x4);
    } > DRAM

    .data :
    {
        *(.data*)
        . = ALIGN(0x4);
    } > DRAM

#if NOCACHE_BASE != 0
    /* .ncdata section is placed at uncached physical alias address and is
     * loaded at the proper cached virtual address - no copying is
     * performed in the init code */
    .ncdata ALIGN(ADDR(.data) + SIZEOF(.data) + NOCACHE_BASE, CACHEALIGN_SIZE) :
        AT(ALIGN(ADDR(.data) + SIZEOF(.data), CACHEALIGN_SIZE))
    {
        . = ALIGN(CACHEALIGN_SIZE);
        *(.ncdata*)
        . = ALIGN(CACHEALIGN_SIZE);
    } > NCRAM

    /* See .ncdata_vma of plugin.lds */
    .ncdata_vma (NOLOAD) : ALIGN(CACHEALIGN_SIZE)
    {
        . += SIZEOF(.ncdata);
    } > DRAM AT> NOLOAD_LMA
#endif
    
    /DISCARD/ :
    {
        *(.eh_frame)
    }

    /*
     * Originally ".vectors{...} > DRAM" however lld is strict about
     * VMA overlapping with ".bss".
     * Therefore, it was necessary to move the VMA of .vectors to
     * somewhere else that didn't overlap (e.g. NOLOAD_LMA).
     * Since ".vectors" is only accessed via "_vectors{start,end,copy}",
     * it doesn't matter what the VMA is set to.
     * */
    .vectors :
    {
        KEEP(*(.vectors));
    } > NOLOAD_LMA AT> DRAM

    _vectorsstart = 0;
    _vectorsend = SIZEOF(.vectors);
    _vectorscopy = LOADADDR(.vectors);
    _noloaddram = LOADADDR(.vectors);

    .ibss (NOLOAD) :
    {
        _iedata = .;
        *(.qharray)
        *(.ibss*)
        . = ALIGN(0x4);
        _iend = .;
    } > IRAM AT> NOLOAD_LMA

    .iram _iend :
    {
        _iramstart = .;
        *(.icode*)
        *(.irodata*)
        *(.idata*)
        . = ALIGN(0x4);
        _iramend = .;
    } > IRAM AT> DRAM

    _iramcopy = LOADADDR(.iram);


    .init :
    {
        . = ALIGN(4);
        _initstart = .;
        *(.init*)
        _initend = .;
    } > CODECBUF AT> DRAM

    _initcopy = LOADADDR(.init);

    .idle_stacks (NOLOAD) :
    {
       *(.idle_stacks)
       . = ALIGN(8);
#if NUM_CORES > 1
       cpu_idlestackbegin = .;
       . += IDLE_STACK_SIZE;
       cpu_idlestackend = .;
#endif
       cop_idlestackbegin = .;
       . += IDLE_STACK_SIZE;
       cop_idlestackend = .;
    } > IRAM AT> NOLOAD_LMA

    .stack (NOLOAD) :
    {
       *(.stack)
       stackbegin = .;
       . += 0x2000;
       stackend = .;
    } > IRAM AT> NOLOAD_LMA
    
    /* .bss and .ncbss are treated as a single section to use one init loop to
     * zero it - note "_edata" and "_end" */
    .bss _noloaddram (NOLOAD) :
    {
       _edata = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(0x4);
    } > DRAM AT> NOLOAD_LMA

#if NOCACHE_BASE != 0
    .ncbss ALIGN(ADDR(.bss) + SIZEOF(.bss) + NOCACHE_BASE, CACHEALIGN_SIZE) (NOLOAD):
    {
    	. = ALIGN(CACHEALIGN_SIZE);
        *(.ncbss*)
    	. = ALIGN(CACHEALIGN_SIZE);
    } > NCRAM AT> NOLOAD_LMA

    /* same as .ncdata_vma */
    .ncbss_vma (NOLOAD) : ALIGN(CACHEALIGN_SIZE)
    {
        . += SIZEOF(.ncbss);
    } > DRAM AT> NOLOAD_LMA
#endif

    _end = .;

    audiobuffer = ALIGN(_end, 0x4);
#ifdef IPOD_VIDEO
    audiobufend_lds = ORIGIN(CODECBUF);
#else
    audiobufend = ORIGIN(CODECBUF);
#endif
    codecbuf = ORIGIN(CODECBUF);
    pluginbuf = ORIGIN(PLUGINBUF);
}
