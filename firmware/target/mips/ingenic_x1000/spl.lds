#include "config.h"
#include "cpu.h"

#if defined(__clang__)
OUTPUT_FORMAT("elf32-tradlittlemips")
#else
OUTPUT_FORMAT("elf32-littlemips")
#endif
OUTPUT_ARCH(MIPS)
ENTRY(_spl_start)

MEMORY {
    TCSM : ORIGIN = X1000_SPL_EXEC_ADDR,
           LENGTH = X1000_SPL_SIZE
    /* LLD requires NOLOAD sections to have non-overlapping LMAs */
    NOLOAD_LMA : ORIGIN = X1000_DRAM_BASE + X1000_DRAM_SIZE,
                 LENGTH = X1000_DRAM_SIZE
}

SECTIONS
{
    .text :
    {
        *(.startup.spl);
        *(.text*);
        *(.icode*);
        *(.init*);
    } > TCSM

    . = ALIGN(4);
    .rodata :
    {
        *(.rodata*);
    } > TCSM

    . = ALIGN(4);
    .data :
    {
        *(.data*);
        *(.sdata*);
    } > TCSM

    . = ALIGN(4);
    .bss (NOLOAD) :
    {
        _bssbegin = .;
        *(.sbss*);
        *(.bss*);
        *(COMMON);
        *(.scommon*);
        _bssend = .;
    } > TCSM AT> NOLOAD_LMA

    /DISCARD/ :
    {
        *(.MIPS.abiflags);
        *(.eh_frame);
        *(.rel.dyn);
        *(.reginfo);
    }
}
