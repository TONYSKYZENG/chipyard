ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 2K
}

SECTIONS
{
    .text : {
        *(.text.entry)
        *(.text*)
        *(.rodata*)
    } > RAM

    .data : {
        __data_start = .;
        *(.data*)
        __data_end = .;
    } > RAM

    .bss : {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    } > RAM

    . = ORIGIN(RAM) + LENGTH(RAM);
    PROVIDE(_stack_top = .);
}