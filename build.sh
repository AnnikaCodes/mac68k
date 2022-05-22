#!/usr/bin/env bash
# if this project grows we should use a Makefile or similar

set -o errexit
set -o nounset
set -o pipefail

function green_echo() {
    echo -e "\033[0;32m${1}\033[0m"
}

mkdir -p build

green_echo "Compiling C code..."
m68k-elf-gcc -nostdlib -mpcrel -m68000 -c -o build/enter.o src/enter.c
m68k-elf-gcc -nostdlib -mpcrel -m68000 -c -o build/video.o src/video.c
m68k-elf-gcc -nostdlib -mpcrel -m68000 -c -o build/terminal.o src/terminal.c

green_echo "Compiling 68k assembly..."
m68k-elf-gcc src/*.s build/*.o  -o "build/linked" -nostdlib

green_echo "Converting to floppy disk image..."
m68k-elf-objcopy -O binary build/linked floppy.img
dd if=/dev/zero of=floppy.img bs=1 count=0 seek=1474560

green_echo "Done"
