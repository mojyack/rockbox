#include "config.h"

#if defined(__clang__)
OUTPUT_FORMAT("elf32-tradlittlemips")
#else
OUTPUT_FORMAT("elf32-littlemips")
#endif
OUTPUT_ARCH(MIPS)
ENTRY(_start)

/* Pull exception-mips.o */
EXTERN(mips_exception_vectors)

#define DRAMSIZE ((MEMORYSIZE-4) * 0x100000)

#define DRAMORIG 0x80E04000
#define IRAMORIG 0x80000000
#define IRAMSIZE 16K

MEMORY
{
   DRAM : ORIGIN = DRAMORIG, LENGTH = DRAMSIZE
   IRAM : ORIGIN = IRAMORIG, LENGTH = IRAMSIZE
   /* LLD requires NOLOAD sections to have non-overlapping LMAs */
   NOLOAD_LMA : ORIGIN = DRAMORIG + DRAMSIZE, LENGTH = 0x10000000
}

SECTIONS
{
    . = DRAMORIG;

    .text :
    {
        _loadaddress = .;
        *(.init.text);
        *(.text*);
    } > DRAM

    . = ALIGN(4);

    .rodata :
    {
        *(.rodata*);
    } > DRAM

    . = ALIGN(4);

    .data :
    {
        *(.data*);
        *(.sdata*);
    } > DRAM

    . = ALIGN(4);

    .iram :
    {
        . = ORIGIN(IRAM);
        _iramstart = .;
        KEEP(*(.vectors.1));
        . = ORIGIN(IRAM) + 0x100;
        KEEP(*(.vectors.2));
        . = ORIGIN(IRAM) + 0x180;
        KEEP(*(.vectors.3));
        . = ORIGIN(IRAM) + 0x200;
        KEEP(*(.vectors.4));
        KEEP(*(.vectors));

        *(.icode*);
        *(.irodata);
        *(.idata);
        KEEP(*(.vectors*))
        _iramend = .;
    } > IRAM AT> DRAM
    _iramcopy = LOADADDR(.iram);

    . = ALIGN(4);

    .bss (NOLOAD):
    {
         _edata = .;
         *(.sbss*);
         *(.bss*);
         *(.ibss*);
         *(COMMON);
         *(.scommon*);
         _end = .;
    } > DRAM AT> NOLOAD_LMA

    _bootend = .;

    .stack (NOLOAD):
    {
         *(.stack)
         stackbegin = .;
         . += 0x1d00;
         stackend = .;
         _irqstackbegin = .;
         . += 0x400;
         _irqstackend = .;
    } > IRAM AT> NOLOAD_LMA

    /DISCARD/ :
    {
        *(.MIPS.abiflags);
        *(.eh_frame);
        *(.rel.dyn);
        *(.reginfo);
    }
}
