all: run

# load to os emulator
run: build/os-image.bin build/empty_drive.bin
	qemu-system-x86_64 -drive format=raw,file=$(word 1,$^) -drive format=raw,file=$(word 2,$^)

clean:
	rm build/*.*

# final os image
build/os-image.bin: build/boot.bin build/kernel.bin
	cat $^ > $@

# binary file of bootloader
build/boot.bin: boot.asm
	nasm $< -o $@ -f bin

# binary file of kernel written in C
build/kernel.bin: build/kernel_entry.o build/kernel.o build/port_utils.o build/screen.o build/utils.o
	ld -m elf_i386 -o $@ -Ttext 0x7e00 $^ --oformat binary

# kernel obj
build/kernel.o : c/kernel.c
	gcc -I_include_ -m32 -fno-pie -ffreestanding -c $< -o $@

build/port_utils.o : c/port_utils.c
	gcc -I_include_ -m32 -fno-pie -ffreestanding -c $< -o $@

build/screen.o : c/screen.c
	gcc -I_include_ -m32 -fno-pie -ffreestanding -c $< -o $@

build/utils.o : c/utils.c
	gcc -I_include_ -m32 -fno-pie -ffreestanding -c $< -o $@

# extern call of main 
build/kernel_entry.o: kernel_entry.asm
	nasm $< -o $@ -f elf
