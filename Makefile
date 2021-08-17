INCLUDE_PATH = _include_
BUILD_PATH = build
CC = gcc
CFLAGS = -I$(INCLUDE_PATH) -m32 -fno-pie -ffreestanding -static -nostdlib -Wall
ASM = nasm
ASM_FLAGS = -i boot

_MODULES_DEPS = port_utils.h screen.h utils.h
MODULES_DEPS = $(patsubst %,$(INCLUDE_PATH)/%,$(_MODULES_DEPS))

_KERNEL_BIN_DEPS = kernel_entry.o kernel.o port_utils.o screen.o utils.o
KERNEL_BIN_DEPS = $(patsubst %,$(BUILD_PATH)/%,$(_KERNEL_BIN_DEPS))

_OS_IMAGE_DEPS = boot.bin kernel.bin
OS_IMAGE_DEPS = $(patsubst %,$(BUILD_PATH)/%,$(_OS_IMAGE_DEPS))

$(BUILD_PATH)/%.o: %.c $(MODULES_DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

all: run

# load to os emulator
run: build/os-image.bin build/empty_drive.bin
	qemu-system-x86_64 -drive format=raw,file=$(word 1,$^) -drive format=raw,file=$(word 2,$^)

clean:
	rm build/*.*

# final os image, concat files
$(BUILD_PATH)/os-image.bin: $(OS_IMAGE_DEPS)
	cat $^ > $@

# binary file of kernel written in C
$(BUILD_PATH)/kernel.bin: $(KERNEL_BIN_DEPS)
	ld -m elf_i386 -o $@ -Ttext 0x7e00 $^ --oformat binary

# kernel obj
$(BUILD_PATH)/kernel.o : init/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

# binary file of bootloader
$(BUILD_PATH)/boot.bin: boot/boot.asm
	$(ASM) $(ASM_FLAGS) $< -o $@ -f bin

# extern call of main 
$(BUILD_PATH)/kernel_entry.o: boot/kernel_entry.asm
	$(ASM) $(ASM_FLAGS) $< -o $@ -f elf
