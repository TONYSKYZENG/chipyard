CROSS   = riscv64-unknown-elf
CC      = $(CROSS)-gcc
AS      = $(CROSS)-as
OBJCOPY = $(CROSS)-objcopy
OBJDUMP = $(CROSS)-objdump

CFLAGS  = -march=rv64if -mabi=lp64 -Wall -O2 -ffreestanding -nostdlib -nostartfiles
LDFLAGS = -T link.ld
HEX = prog.hex


all: prog.elf prog.bin prog.dump prog.hex
prog.hex: prog.bin
	python3 bin2hex.py prog.bin $(HEX)
prog.elf: start.o main.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

main.o: main.c
	$(CC) $(CFLAGS) -c -o $@ $<

start.o: start.S
	$(AS) -march=rv64if -o $@ $<

prog.bin: prog.elf
	$(OBJCOPY) -O binary $< $@

prog.dump: prog.elf
	$(OBJDUMP) -D -S $< > $@

clean:
	rm -f *.o *.elf *.bin *.dump