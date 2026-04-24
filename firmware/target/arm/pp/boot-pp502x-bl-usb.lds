#define __ASSEMBLER__
#include "cpu.h"

/* Will have been included from boot.lds */
ENTRY(start)
OUTPUT_FORMAT(elf32-littlearm)
OUTPUT_ARCH(arm)

#define DRAMORIG        0x01000000 /* Load at 16 MB */
#define DRAMSIZE        0x00100000 /* 1MB for bootloader */
#define MEMEND          (MEMORYSIZE*0x100000) /* From virtual mapping at 0 */
#ifndef IRAMORIG
#define IRAMORIG 0x40000000
#endif
#define IRAMSIZE 0x20000
#define FLASHORIG 0x001f0000
#define FLASHSIZE 2M

MEMORY
{
    DRAM : ORIGIN = DRAMORIG, LENGTH = DRAMSIZE
    IRAM : ORIGIN = IRAMORIG, LENGTH = IRAMSIZE
#if NOCACHE_BASE != 0
    NCRAM : ORIGIN = ORIGIN(DRAM) + NOCACHE_BASE, LENGTH = DRAMSIZE
#endif
    /* LLD requires NOLOAD sections to have non-overlapping LMAs */
    NOLOAD_LMA : ORIGIN = DRAMORIG + DRAMSIZE + 0x10000000, LENGTH = 0x10000000
}

SECTIONS
{
    _loadaddress = DRAMORIG + NOCACHE_BASE;

    .text :
    {
        *(.init.text)
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

    _noloaddram = .;

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
        _iramend = .;
    } > IRAM AT> DRAM

    _iramcopy = LOADADDR(.iram);

    _loadaddressend = LOADADDR(.iram) + SIZEOF(.iram) + NOCACHE_BASE;

    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        *(.stack)
        stackbegin = .;
        . += 0x2000;
        stackend = .;
    } > IRAM AT> NOLOAD_LMA

    /* .bss and .ncbss are treated as a single section to use one init loop
     * to zero them - note "_edata" and "_end" */
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

    /* Reference to all DRAM after loaded bootloader image */
    freebuffer = ALIGN(_end, 4);
    freebufferend = MEMEND - 1;
}
