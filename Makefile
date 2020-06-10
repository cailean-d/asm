all: run

# load to os emulator
run: os-image.bin
	qemu-system-x86_64 -drive format=raw,file=os-image.bin -drive format=raw,file=empty_drive.bin

clean:
	rm *.bin *.o

# final os image
os-image.bin: kernel.bin boot.bin
	cat boot.bin kernel.bin > os-image.bin

# binary file of bootloader
boot.bin: boot.asm
	nasm boot.asm -o boot.bin -f bin

# binary file of kernel written in C
kernel.bin: kernel.o kernel_entry.o
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 --oformat binary kernel_entry.o kernel.o

# kernel obj
kernel.o : c/kernel.c
	gcc -m32 -fno-pie -ffreestanding -c c/kernel.c -o kernel.o

# extern call of main 
kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -o kernel_entry.o -f elf
