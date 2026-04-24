#include "config.h"
#include "imx31l.h"

ENTRY(start)
OUTPUT_FORMAT(elf32-littlearm)
OUTPUT_ARCH(arm)

#define DRAMSIZE (1 << 20) /* Limit 1 MB for bootloader */

#define DRAMORIG  0x02000000
/* #define IRAMORIG 0x1FFFC000 */
#define IRAM      DRAM
#define IRAMSIZE  IRAM_SIZE
#define IRAMORIG  DRAMORIG
#define FLASHORIG 0x0000000
#define FLASHSIZE 1M

MEMORY
{
   DRAM : ORIGIN = DRAMORIG, LENGTH = DRAMSIZE
   QHARRAY : ORIGIN = QHARRAY_PHYS_ADDR, LENGTH = QHARRAY_SIZE
   /* LLD requires NOLOAD sections to have non-overlapping LMAs */
   NOLOAD_LMA : ORIGIN = ORIGIN(QHARRAY) + LENGTH(QHARRAY), LENGTH = 0x10000000
}

SECTIONS
{
    . = DRAMORIG;

    .text :
    {
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
        /* Pseudo-allocate the copies of the data sections */
        _datacopy = .;
    } > DRAM

    .data :
    {
        *(.data*)
        *(.idata*)
        _dataend = . ;
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
    
    /*
     * See .vectors of app-pp.lds for the rationale on placing .vectors
     * in NOLOAD_LMA.
     */
    .vectors :
    {
        KEEP(*(.vectors));
    } > NOLOAD_LMA AT> DRAM

    _vectorsstart = 0;
    _vectorsend = SIZEOF(.vectors);
    _vectorscopy = LOADADDR(.vectors);

    .stack (NOLOAD) :
    {
        *(.stack)
        _stackbegin = .;
        stackbegin = .;
        . += 0x2000;
        _stackend = .;
        stackend = .;
    } > IRAM AT> NOLOAD_LMA

    /* .bss and .ncbss are treated as a single section to use one init loop to
     * zero it - note "_edata" and "_end" */
    .bss (NOLOAD) :
    {
         _edata = .;
         *(.bss*);
         *(.ibss*);
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

    .qharray (NOLOAD) :
    {
        _qharray = .;
        *(.qharray)
        _qharrayend = .;
    } > QHARRAY AT> NOLOAD_LMA
}
