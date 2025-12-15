    .section .text.entry
    .globl _start
_start:
    # 设置栈顶
    la sp, _stack_top

    # 清零 .bss 段
    la t0, __bss_start
    la t1, __bss_end
1:
    bge t0, t1, 2f
    sd x0, 0(t0)        # 写 0 (64 位)
    addi t0, t0, 8
    j 1b
2:

    # 调用 main
    call main
    #.insn r 0x0B, 2, 0, x0, t0, x0
    # main 返回后的处理
3:  j 3b