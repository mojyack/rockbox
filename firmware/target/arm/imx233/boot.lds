#include "config.h"
#include "cpu.h"

ENTRY(start)
OUTPUT_FORMAT(elf32-littlearm)
OUTPUT_ARCH(arm)

/* Leave a hole at the beginning of the RAM to load the firmware */
#define RAM_HOLE    1024 * 1024

/* Make a difference between virtual and physical address so that we can use
 * the resulting elf file with the elftosb tools which loads at the *physical*
 * address */

MEMORY
{
    IRAM : ORIGIN = IRAM_ORIG, LENGTH = IRAM_SIZE
    DRAM : ORIGIN = CACHED_DRAM_ADDR + RAM_HOLE, LENGTH = DRAM_SIZE - TTB_SIZE - FRAME_SIZE - RAM_HOLE
    UDRAM : ORIGIN = UNCACHED_DRAM_ADDR + RAM_HOLE, LENGTH = DRAM_SIZE - TTB_SIZE - FRAME_SIZE - RAM_HOLE
    /* LLD requires NOLOAD sections to have non-overlapping LMAs */
    NOLOAD_LMA : ORIGIN = ORIGIN(DRAM) + LENGTH(DRAM), LENGTH = 0x10000000
}

SECTIONS
{
    /DISCARD/ :
    {
        *(.eh_frame)
        *(.ARM.exidx*)
        *(.ARM.extab*)
    }

    loadaddress = UNCACHED_DRAM_ADDR;
    _loadaddress = UNCACHED_DRAM_ADDR;
    loadaddressend = UNCACHED_DRAM_ADDR + RAM_HOLE;
    _loadaddressend = UNCACHED_DRAM_ADDR + RAM_HOLE;

    _dramcopystart = ORIGIN(DRAM);

    .text :
    {
        *(.text*)
        *(.data*)
        *(.rodata*)
    } > DRAM

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

    _dramcopyend = LOADADDR(.itext) + SIZEOF(.itext);

    .ibss (NOLOAD) :
    {
        _iedata = .;
        *(.qharray)
        *(.ibss*)
        _iend = .;
    } > IRAM AT> NOLOAD_LMA

    .stack (NOLOAD) :
    {
        *(.stack)
        stackbegin = .;
        . += 0x2000;
        stackend = .;
    } > DRAM AT> NOLOAD_LMA

    /* physical address of the stack */
    crt0_tmpstack_phys = stackend - CACHED_DRAM_ADDR + UNCACHED_DRAM_ADDR;

    /* treat .bss and .ncbss as a single section */
    .bss (NOLOAD) :
    {
        _edata = .;
        *(.bss*);
    } > DRAM AT> NOLOAD_LMA

    /* align on cache size boundary to avoid mixing cached and noncached stuff */
    _ncbss_start = . - CACHED_DRAM_ADDR + UNCACHED_DRAM_ADDR;
    .ncbss _ncbss_start (NOLOAD) :
    {
        . = ALIGN(CACHEALIGN_SIZE);
        *(.ncbss*)
        . = ALIGN(CACHEALIGN_SIZE);
    } > UDRAM AT> NOLOAD_LMA

    _end = .;
}
