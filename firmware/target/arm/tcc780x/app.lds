#include "config.h"

ENTRY(start)

OUTPUT_FORMAT(elf32-littlearm)
OUTPUT_ARCH(arm)

#define PLUGINSIZE PLUGIN_BUFFER_SIZE
#define CODECSIZE CODEC_SIZE

#include "cpu.h"
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGINSIZE - CODECSIZE - TTB_SIZE

#define DRAMORIG 0x20000000
#define ITCMORIG 0x00000000
#define ITCMSIZE 0x1000
#define DTCMORIG 0xA0000000
#define DTCMSIZE 0x2000
#define SRAMORIG 0x10000000
#define SRAMSIZE 0xc000

MEMORY
{
    DRAM : ORIGIN = DRAMORIG, LENGTH = DRAMSIZE
    CODECBUF : ORIGIN = ORIGIN(DRAM) + LENGTH(DRAM), LENGTH = CODECSIZE
    PLUGINBUF : ORIGIN = ORIGIN(CODECBUF) + LENGTH(CODECBUF), LENGTH = PLUGINSIZE
    /* Seperate data & instruction TCMs plus SRAM. */
    ITCM : ORIGIN = ITCMORIG, LENGTH = ITCMSIZE
    DTCM : ORIGIN = DTCMORIG, LENGTH = DTCMSIZE
    SRAM : ORIGIN = SRAMORIG, LENGTH = SRAMSIZE
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

    .vectors ITCMORIG :
    {
        _vectorsstart = .;
        KEEP(*(.vectors));
        _vectorsend = .;
    } > ITCM AT> DRAM

    _vectorscopy = LOADADDR(.vectors);

    .itcm :
    {
        _itcmstart = .;
        _itcmend = .;
    } > ITCM AT> DRAM

    _itcmcopy = LOADADDR(.itcm);
    
    .dtcm :
    {
        _dtcmstart = .;
        _dtcmend = .;
    } > DTCM AT> DRAM

    _dtcmcopy = LOADADDR(.dtcm);

    .iram :
    {
        _iramstart = .;
        *(.irodata*)
        *(.idata*)
        *(.icode*)
        . = ALIGN(0x4);
        _iramend = .;
    } > SRAM AT> DRAM

    _iramcopy = LOADADDR(.iram);
    
    .ibss (NOLOAD) :
    {
        _iedata = .;
        *(.ibss*)
        . = ALIGN(0x4);
        _iend = .;
    } > SRAM AT> NOLOAD_LMA

    .stack :
    {
       *(.stack)
       stackbegin = .;
       . += 0x2000;
       stackend = .;
    } > SRAM

    .bss :
    {
       _edata = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(0x4);
       _end = .;
    } > DRAM

    audiobuffer = ALIGN(_end, 0x4);
    audiobufend = ORIGIN(CODECBUF);
    codecbuf = ORIGIN(CODECBUF);
    pluginbuf = ORIGIN(PLUGINBUF);
}
