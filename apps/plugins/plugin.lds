#define __ASSEMBLER__
#include "config.h"
#include "cpu.h"

/* These output formats should be in the config-files */

#ifdef CPU_COLDFIRE
OUTPUT_FORMAT(elf32-m68k)
#elif defined(CPU_ARM)
OUTPUT_FORMAT(elf32-littlearm)
#elif defined(CPU_MIPS)
#if defined(__clang__)
OUTPUT_FORMAT(elf32-tradlittlemips)
#else
OUTPUT_FORMAT(elf32-littlemips)
#endif
#else
/* We can have an #error here we don't use this file when build sims! */
#error Unknown CPU architecture
#endif

/* MCF5249 have 96KB of IRAM */
#if CONFIG_CPU == MCF5249
#define DRAMORIG 0x31000000
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE
#define IRAMORIG 0x1000c000
#define IRAMSIZE 0xc000

/* MCF5250 have 128KB of IRAM */
#elif CONFIG_CPU == MCF5250
#define DRAMORIG 0x31000000
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE
#define IRAMORIG 0x1000c800
#define IRAMSIZE 0x13800

#elif CONFIG_CPU == PP5022 || CONFIG_CPU == PP5024
/* PP5022/24 have 128KB of IRAM */
#define DRAMORIG 0x00000000
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE
#define IRAMORIG 0x4000c000
#define IRAMSIZE 0x14000

#elif defined(CPU_PP)
/* all other PP's have 96KB of IRAM */
#define DRAMORIG 0x00000000
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE
#define IRAMORIG 0x4000c000
#define IRAMSIZE 0x0c000

#elif CONFIG_CPU == IMX31L
#define DRAMORIG 0x0
#define DRAMSIZE ((MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE \
                  - CODEC_SIZE - QHARRAY_SIZE - FRAME_SIZE - TTB_SIZE)

#elif CONFIG_CPU == S3C2440
#define DRAMORIG 0x0
#define DRAMSIZE ((MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE \
                  - CODEC_SIZE - LCD_BUFFER_SIZE - TTB_SIZE)

#elif CONFIG_CPU==DM320
#define DRAMORIG CONFIG_SDRAM_START
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE - LCD_TTB_AREA
/* The bit of IRAM that is available is used in the core */

#elif CONFIG_CPU==TCC7801
#define DRAMORIG 0x20000000
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE - TTB_SIZE
#define IRAMORIG 0x1000c000
#define IRAMSIZE 0xc000

#elif CONFIG_CPU==AS3525 && !defined(AMS_LOWMEM)
#define DRAMORIG DRAM_ORIG
#define DRAMSIZE (DRAM_SIZE - PLUGIN_BUFFER_SIZE - CODEC_SIZE - TTB_SIZE)
#define IRAMORIG (IRAM_ORIG + 0x20000)
#define IRAMSIZE (IRAM_ORIG + IRAM_SIZE - IRAMORIG)

#elif CONFIG_CPU==AS3525v2 || (CONFIG_CPU == AS3525 && defined(AMS_LOWMEM))
#define DRAMORIG DRAM_ORIG
#define DRAMSIZE (DRAM_SIZE - PLUGIN_BUFFER_SIZE - TTB_SIZE)
/* No IRAM defined, instead IRAM is exclusively used for the entire codec */
#define CODEC_ORIGIN (IRAM_ORIG + IRAM_SIZE - CODEC_SIZE)
#define PLUGIN_ORIGIN (DRAM_ORIG + DRAMSIZE)

#elif CONFIG_CPU==S5L8700
/* S5L8700 have 256KB of IRAM */
#define DRAMORIG 0x08000000
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE
#define IRAMORIG (0x00000000 + (48*1024))
#define IRAMSIZE (208*1024)

#elif CONFIG_CPU==S5L8701
/* S5L8701 have 176KB of IRAM */
#define DRAMORIG 0x08000000
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE
#define IRAMORIG (0x00000000 + (48*1024))
#define IRAMSIZE (128*1024)

#elif CONFIG_CPU==S5L8702
/* S5L8702 have 256KB of IRAM */
/* IRAM1 (2nd 128KB block) is not used because it is slower than DRAM */
#define DRAMORIG 0x08000000
#define DRAMSIZE (DRAM_SIZE - PLUGIN_BUFFER_SIZE - CODEC_SIZE - TTB_SIZE)
#define IRAMORIG (0x00000000 + (48*1024))
#define IRAMSIZE (80*1024)

#elif CONFIG_CPU==S5L8720
/* S5L8720 have 192KB of IRAM */
/* TODO: check if IRAM1 is also slow as in S5L8702 above */
#define DRAMORIG 0x08000000
#define DRAMSIZE (DRAM_SIZE - PLUGIN_BUFFER_SIZE - CODEC_SIZE - TTB_SIZE)
#define IRAMORIG (0x00000000 + (56*1024))
#define IRAMSIZE (136*1024)

#elif CONFIG_CPU == JZ4732 || CONFIG_CPU == JZ4760B
/* fake 'iram' region occupies first 16k */
#define DRAMORIG 0x80004000
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE - 0x4000
/* The bit of IRAM that is available is used in the core */

#elif CONFIG_CPU == X1000
#define DRAMORIG X1000_DRAM_BASE
#define DRAMSIZE (X1000_DRAM_SIZE - PLUGIN_BUFFER_SIZE - CODEC_SIZE)

#elif CONFIG_CPU == RK27XX
#define DRAMORIG 0x60000000
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE

#elif CONFIG_CPU == IMX233
/* The IRAM is too small and already partly used by the core */
#define DRAMORIG CACHED_DRAM_ADDR
#define DRAMSIZE (DRAM_SIZE - PLUGIN_BUFFER_SIZE - CODEC_SIZE - FRAME_SIZE - TTB_SIZE)

#elif CONFIG_CPU == STM32H743
#define DRAMORIG STM32_SDRAM1_BASE
#define DRAMSIZE (MEMORYSIZE * 0x100000) - PLUGIN_BUFFER_SIZE - CODEC_SIZE

#else
# error "DRAM/IRAM memory map not defined!"
#endif

#define PLUGIN_LENGTH PLUGIN_BUFFER_SIZE


#ifndef CODEC_ORIGIN /* targets can specify another origin */
#define CODEC_ORIGIN (DRAMORIG + (DRAMSIZE))
#endif

#ifndef PLUGIN_ORIGIN /* targets can specify another origin */
#define PLUGIN_ORIGIN (CODEC_ORIGIN + CODEC_SIZE)
#endif

#ifdef CODEC
#define THIS_LENGTH CODEC_SIZE
#define THIS_ORIGIN CODEC_ORIGIN
#elif defined OVERLAY_OFFSET
#define THIS_LENGTH (DRAMSIZE - OVERLAY_OFFSET)
#define THIS_ORIGIN (DRAMORIG + OVERLAY_OFFSET)
#elif defined IMGVDECODER_OFFSET
#define THIS_LENGTH (PLUGIN_LENGTH - IMGVDECODER_OFFSET)
#define THIS_ORIGIN (PLUGIN_ORIGIN + IMGVDECODER_OFFSET)
#else /* plugin */
#define THIS_LENGTH PLUGIN_LENGTH
#define THIS_ORIGIN PLUGIN_ORIGIN
#endif

#if defined(USE_IRAM) && (!defined(IRAMORIG) || !defined(IRAMSIZE))
# error "USE_IRAM is set, but no IRAM region is defined!"
#endif

MEMORY
{
   PLUGIN_RAM : ORIGIN = THIS_ORIGIN, LENGTH = THIS_LENGTH
#if defined(USE_IRAM)
   PLUGIN_IRAM : ORIGIN = IRAMORIG, LENGTH = IRAMSIZE
#endif
#if defined(NOCACHE_BASE)
   PLUGIN_NCRAM : ORIGIN = THIS_ORIGIN + NOCACHE_BASE, LENGTH = THIS_LENGTH
#endif
   /* LLD requires NOLOAD sections to have non-overlapping LMAs, so
      provide a dummy region past PLUGIN_RAM for their LMA tracking. */
   NOLOAD_LMA : ORIGIN = THIS_ORIGIN + THIS_LENGTH, LENGTH = THIS_LENGTH
}

ENTRY(plugin_start_addr)

SECTIONS
{
    .header : {
        _plugin_start_addr = .;
        plugin_start_addr = .;
        KEEP(*(.header))
    } > PLUGIN_RAM

    .text :
    {
        *(.text*)
#ifdef CPU_ARM
        *(.glue_7)
        *(.glue_7t)
#endif
    } > PLUGIN_RAM

    .rodata :
    {
        *(.rodata*)
    } > PLUGIN_RAM

    .data :
    {
        *(.data*)
    } > PLUGIN_RAM

#if defined(NOCACHE_BASE)
    /*
     * Allocate .ncdata based on the following constraints:
     *
     * 1. the LMA must be allocated at the next free LMA in
     *    PLUGIN_RAM and aligned to a cacheline boundary.
     * 2. the VMA - LMA offset must equal NOCACHE_BASE.
     */
    .ncdata ALIGN(ADDR(.data) + SIZEOF(.data) + NOCACHE_BASE, CACHEALIGN_SIZE) :
        AT(ALIGN(ADDR(.data) + SIZEOF(.data), CACHEALIGN_SIZE))
    {
        *(.ncdata*)
        . = ALIGN(CACHEALIGN_SIZE);
    } > PLUGIN_NCRAM

    /*
     * Physically, PLUGIN_RAM and PLUGIN_NCRAM are in the same bank.
     * Since .ncdata consumed PLUGIN_NCRAM, place a dummy section in
     * PLUGIN_RAM to reserve the same amount of space, and synchronize
     * subsequent VMA allocations.
     */
    .ncdata_vma (NOLOAD) : ALIGN(CACHEALIGN_SIZE)
    {
        . += SIZEOF(.ncdata);
    } > PLUGIN_RAM AT> NOLOAD_LMA
#endif

    /DISCARD/ :
    {
        *(.eh_frame)
#if !defined(USE_IRAM)
		*(.icode)
        *(.irodata)
        *(.idata)
        *(.ibss)
#endif
#ifdef CPU_MIPS
        *(.MIPS.abiflags)
        *(.reginfo)
        *(.rel.dyn)
#endif
    }

    .bss (NOLOAD) :
    {
    	plugin_bss_start = .;
    	_plugin_bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(0x4);
    } > PLUGIN_RAM AT> NOLOAD_LMA

#if defined(NOCACHE_BASE)
    /* has the same constraints as the .ncdata section above */
    .ncbss ALIGN(ADDR(.bss) + SIZEOF(.bss) + NOCACHE_BASE, CACHEALIGN_SIZE) (NOLOAD) :
    {
    	*(.ncbss*)
        . = ALIGN(CACHEALIGN_SIZE);
    } > PLUGIN_NCRAM AT> NOLOAD_LMA

    /* same as .ncdata_vma */
    .ncbss_vma (NOLOAD) : ALIGN(CACHEALIGN_SIZE)
    {
        . += SIZEOF(.ncbss);
    } > PLUGIN_RAM AT> NOLOAD_LMA
#endif

    /* Final end of plugin after IRAM setup. The plugin or codec buffer
       is considered unused by the in-RAM image at this point once IRAM
       is copied. */
    .pluginend (NOLOAD) :
    {
        _plugin_end_addr = .;
        plugin_end_addr = .;
    } > PLUGIN_RAM AT> NOLOAD_LMA

#if defined(USE_IRAM)
#if defined(NOCACHE_BASE)
    .iram IRAMORIG : AT(LOADADDR(.ncdata) + SIZEOF(.ncdata))
#else
    .iram IRAMORIG : AT(LOADADDR(.data) + SIZEOF(.data))
#endif
    {
        iramstart = .;
        *(.icode)
        *(.irodata)
        *(.idata)
        iramend = .;
    } > PLUGIN_IRAM
    iramcopy = LOADADDR(.iram);

    .ibss (NOLOAD) :
    {
        iedata = .;
        *(.ibss)
        . = ALIGN(0x4);
        iend = .;
    } > PLUGIN_IRAM AT> NOLOAD_LMA

    loadendaddr = MAX(plugin_end_addr, LOADADDR(.iram) + SIZEOF(.iram));
#else
    loadendaddr = plugin_end_addr;
#endif

    /* This is for ovl_offset.pl and is the highest address that must
       be loaded into the plugin buffer (past the end of last data in
       stored image). */
    _plugin_load_end_addr = loadendaddr;
    plugin_load_end_addr = loadendaddr;

    _plugin_ram_end = ORIGIN(PLUGIN_RAM) + LENGTH(PLUGIN_RAM);
    plugin_ram_end = ORIGIN(PLUGIN_RAM) + LENGTH(PLUGIN_RAM);

    /* Special trick to avoid a linker error when no other sections are
       left after garbage collection (plugin not for this platform) */
    .comment 0 :
    {
        KEEP(*(.comment))
    }
}

#if defined(NOCACHE_BASE)
/* Some asserts to make sure nocache sections appear correctly defined */
ASSERT(LOADADDR(.ncdata) == ADDR(.ncdata) - NOCACHE_BASE, ".ncdata has incorrect LMA/VMA address");
ASSERT(LOADADDR(.ncdata) % CACHEALIGN_SIZE == 0,          ".ncdata incorrectly aligned");
ASSERT(SIZEOF(.ncdata_vma) == SIZEOF(.ncdata),            ".ncdata_vma has wrong size");
ASSERT(ADDR(.ncdata_vma) == LOADADDR(.ncdata),            ".ncdata_vma has wrong address");
ASSERT(ADDR(.ncbss) == ADDR(.ncbss_vma) + NOCACHE_BASE,   ".ncbss has incorrect VMA address");
ASSERT(ADDR(.ncbss) % CACHEALIGN_SIZE == 0,               ".ncbss incorrectly aligned");
ASSERT(SIZEOF(.ncbss_vma) == SIZEOF(.ncbss),              ".ncbss_vma has wrong size");
#endif
