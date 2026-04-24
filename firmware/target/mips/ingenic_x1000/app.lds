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

#ifdef BOOTLOADER
# undef PLUGIN_BUFFER_SIZE
# undef CODEC_SIZE
# define PLUGIN_BUFFER_SIZE 0
# define CODEC_SIZE 0
# if defined(HAVE_INIT_ATTR)
/* This needs to be fixed for the bootloader */
#  error "bootloader does not support INIT_ATTR"
# endif
#endif

/* End of the audio buffer, where the codec buffer starts */
#define ENDAUDIOADDR (X1000_DRAM_END - PLUGIN_BUFFER_SIZE - CODEC_SIZE)

/* Where the codec buffer ends, and the plugin buffer starts */
#define ENDCODECADDR  (ENDAUDIOADDR + CODEC_SIZE)

/* Place init code in the codec buffer */
#define INIT_BASE   ENDAUDIOADDR
#define INIT_SIZE   CODEC_SIZE

MEMORY
{
    IRAM : ORIGIN = X1000_IRAM_BASE, LENGTH = X1000_IRAM_SIZE
    DRAM : ORIGIN = X1000_DRAM_BASE, LENGTH = X1000_DRAM_SIZE
    TCSM : ORIGIN = X1000_TCSM_BASE, LENGTH = X1000_TCSM_SIZE
    INIT : ORIGIN = INIT_BASE, LENGTH = INIT_SIZE
    /* LLD requires NOLOAD sections to have non-overlapping LMAs */
    NOLOAD_LMA : ORIGIN = X1000_DRAM_BASE + X1000_DRAM_SIZE, LENGTH = X1000_DRAM_SIZE
}

SECTIONS
{
    .startup :
    {
        loadaddress = .;
        _loadaddress = .;
        *(.startup.text);
    } > DRAM

    .text :
    {
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

    /*
     * The following sections are loaded after normal DRAM sections
     * but are copied elsewhere by the startup code.
     */
    _noloaddram = ALIGN(4);

    .iram :
    {
        _iramstart = ALIGN(4);
        . = ORIGIN(IRAM) + 0x000; /* TLB refill */
        KEEP(*(.vectors.1));
        . = ORIGIN(IRAM) + 0x100; /* Cache error */
        KEEP(*(.vectors.2));
        . = ORIGIN(IRAM) + 0x180; /* General exception */
        KEEP(*(.vectors.3));
        . = ORIGIN(IRAM) + 0x200; /* Interrupt */
        KEEP(*(.vectors.4));
        KEEP(*(.vectors));

        *(.icode*);
        *(.irodata);
        *(.idata);
        _iramend = ALIGN(4);
    } > IRAM AT> DRAM
    _iramcopy = LOADADDR(.iram);

    .tcsm :
    {
        _tcsmstart = ALIGN(4);
        KEEP(*(.tcsm*));
        _tcsmend = ALIGN(4);
    } > TCSM AT> DRAM
    _tcsmcopy = LOADADDR(.tcsm);

#ifdef HAVE_INIT_ATTR
    .init :
    {
        _initstart = ALIGN(4);
        *(.init*);
        _initend = ALIGN(4);
    } > INIT AT> DRAM
    _initcopy = LOADADDR(.init);
#endif

    /* Sections below have no data. */

    . = ALIGN(4);
    .stack (NOLOAD) :
    {
         *(.stack);
         stackbegin = ALIGN(4);
         . += X1000_STACKSIZE;
         stackend = ALIGN(4);
         _irqstackbegin = ALIGN(4);
         . += X1000_IRQSTACKSIZE;
         _irqstackend = ALIGN(4);
    } > IRAM AT> NOLOAD_LMA

    .bss _noloaddram (NOLOAD) :
    {
        _bssbegin = ALIGN(4);
        *(.sbss*);
        *(.bss*);
        *(COMMON);
        *(.scommon*);
        _bssend = ALIGN(4);
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

#if defined(HAVE_NOCROSSREFS_TO) && defined(HAVE_INIT_ATTR)
/* Prevent accidental references to the .init section from other sections */
NOCROSSREFS_TO(.init .text .iram .tcsm);
#endif
