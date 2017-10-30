nasm=nasm
qemu=qemu-system-x86_64

all: BOOTLOADER

BOOTLOADER: BOOTLOADER.asm
	$(nasm) BOOTLOADER.asm -o OUTPUT/BOOTLOADER.bin
		
qemu: OUTPUT/BOOTLOADER.bin
	$(qemu) OUTPUT/BOOTLOADER.bin
