# Makefile
all: os.flp

boot.bin: boot.asm
	nasm -f bin -o boot.bin boot.asm

kernel.bin: kernel.c
	i686-elf-gcc -ffreestanding -c kernel.c -o kernel.o
	i686-elf-ld -o kernel.bin -Ttext 0x0800 --oformat binary kernel.o

os.flp: boot.bin kernel.bin
	dd if=/dev/zero of=os.flp bs=512 count=288
	dd if=boot.bin of=os.flp bs=512 count=1 conv=notrunc
	dd if=kernel.bin of=os.flp bs=512 seek=1 conv=notrunc

clean:
	rm -f *.bin *.o os.flp
