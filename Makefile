# Makefile

# アセンブラとリンカの指定
AS = nasm
CC = gcc
LD = ld

# ビルドオプション
ASFLAGS = -f bin
CFLAGS = -ffreestanding -m32 -nostdlib -nostdinc -Wall -Wextra -c
LDFLAGS = -m elf_i386 -Ttext 0x1000 -nostdlib

# ビルド対象
BOOT_OBJ = boot/boot.o
KERNEL_OBJ = kernel/kernel.o
BOOT_BIN = boot/boot.bin
KERNEL_BIN = kernel/kernel.bin

# ビルドターゲット
all: $(BOOT_BIN) $(KERNEL_BIN) yuki-os.flp

# ブートローダのビルド
$(BOOT_BIN): $(BOOT_OBJ)
	$(LD) $(LDFLAGS) -o $@ $<

$(BOOT_OBJ): boot/boot.asm
	$(AS) $(ASFLAGS) -o $@ $<

# カーネルのビルド
$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o $@ $<

$(KERNEL_OBJ): kernel/kernel.c
	$(CC) $(CFLAGS) -o $@ $<

# フロッピーディスクイメージの作成
yuki-os.flp: $(BOOT_BIN) $(KERNEL_BIN)
	dd if=/dev/zero of=yuki-os.flp bs=512 count=2880
	dd if=$(BOOT_BIN) of=yuki-os.flp bs=512 conv=notrunc
	dd if=$(KERNEL_BIN) of=yuki-os.flp bs=512 seek=1 conv=notrunc

# クリーン
clean:
	rm -f $(BOOT_OBJ) $(BOOT_BIN) $(KERNEL_OBJ) $(KERNEL_BIN) yuki-os.flp

.PHONY: all clean
