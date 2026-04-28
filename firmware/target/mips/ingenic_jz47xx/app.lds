#define __ASSEMBLER__
#include "config.h"
#include "cpu.h"

#if defined(__clang__)
OUTPUT_FORMAT("elf32-tradlittlemips")
#else
OUTPUT_FORMAT("elf32-littlemips")
#endif
OUTPUT_ARCH(MIPS)
ENTRY(_start)

/* Pull exception-mips.o */
EXTERN(mips_exception_vectors)

#define IRAMORIG      0x80000000
#define IRAMSIZE      0x4000
#define DRAMORIG      (IRAMORIG + IRAMSIZE)
#define DRAMSIZE      (MEMORYSIZE * 0x100000 - IRAMSIZE)

/* End of the audio buffer, where the codec buffer starts */
#define ENDAUDIOADDR  (DRAMORIG + DRAMSIZE - PLUGIN_BUFFER_SIZE - CODEC_SIZE)

/* Where the codec buffer ends, and the plugin buffer starts */
#define ENDCODECADDR  (ENDAUDIOADDR + CODEC_SIZE)

/* Place init code in the codec buffer */
#define INITBASE   ENDAUDIOADDR
#define INITSIZE   CODEC_SIZE

MEMORY
{
   DRAM : ORIGIN = DRAMORIG, LENGTH = DRAMSIZE
   IRAM : ORIGIN = IRAMORIG, LENGTH = IRAMSIZE
   INIT : ORIGIN = INITBASE, LENGTH = INITSIZE
   /* LLD requires NOLOAD sections to have non-overlapping LMAs */
   NOLOAD_LMA : ORIGIN = DRAMORIG + DRAMSIZE, LENGTH = 0x10000000
}

SECTIONS
{
    . = DRAMORIG;

    .text :
    {
        loadaddress = .;
        _loadaddress = .;
        *(.init.text);
        *(.text*);
#ifndef HAVE_INIT_ATTR
        *(.init*);
#endif
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

    /* Set the load address of .iram at the same address as .bss
     * so RAM won't be wasted as .iram in the end will get copied
     * to IRAM. */
    .iram : AT (_edata)
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
        KEEP(*(.vectors))
        *(.vectors);
        _iramend = .;
    } > IRAM
    _iramcopy = LOADADDR(.iram);

#ifdef HAVE_INIT_ATTR
    .init :
    {
        _initstart = .;
        *(.init*);
        _initend = .;
    } > INIT AT> DRAM
    _initcopy = LOADADDR(.init);
#endif

    . = ALIGN(4);

    .stack (NOLOAD):
    {
         *(.stack);
         stackbegin = .;
         . += 0x1d00;
         stackend = .;
         _irqstackbegin = .;
         . += 0x400;
         _irqstackend = .;
    } > IRAM AT> NOLOAD_LMA

    .bss (NOLOAD):
    {
         _edata = .;
         *(.sbss*);
         *(.bss*);
         *(.ibss*); /* Don't put this in IRAM as there's not enough space */
         *(COMMON);
         *(.scommon*);
         _end = .;
    } > DRAM AT> NOLOAD_LMA

    .audiobuf :
    {
        . = ALIGN(4);
        audiobuffer = .;
    } > DRAM

    audiobufend = ENDAUDIOADDR;
    codecbuf = ENDAUDIOADDR;
    pluginbuf = ENDCODECADDR;

    /DISCARD/ :
    {
        *(.MIPS.abiflags);
        *(.eh_frame);
        *(.rel.dyn);
        *(.got);
        *(.got.plt);
        *(.reginfo);
    }
}
