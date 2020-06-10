all: run

# load to os emulator
run: build/os-image.bin
	qemu-system-x86_64 -drive format=raw,file=build/os-image.bin -drive format=raw,file=build/empty_drive.bin

clean:
	rm *.bin *.o

# final os image
build/os-image.bin: build/kernel.bin build/boot.bin
	cat build/boot.bin build/kernel.bin > build/os-image.bin

# binary file of bootloader
build/boot.bin: boot.asm
	nasm boot.asm -o build/boot.bin -f bin

# binary file of kernel written in C
build/kernel.bin: build/kernel.o build/kernel_entry.o
	ld -m elf_i386 -o build/kernel.bin -Ttext 0x1000 --oformat binary build/kernel_entry.o build/kernel.o

# kernel obj
build/kernel.o : c/kernel.c
	gcc -m32 -fno-pie -ffreestanding -c c/kernel.c -o build/kernel.o

# extern call of main 
build/kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -o build/kernel_entry.o -f elf
