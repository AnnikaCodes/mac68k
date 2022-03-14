#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

function green_echo() {
    echo -e "\033[0;32m${1}\033[0m"
}

green_echo "Cleaning build directory..."
mkdir -p build
rm build/*

green_echo "Compiling Zig code..."
zig build-obj -target m68k-freestanding src/enter.zig -fno-LLVM -ofmt=c -femit-bin=build/enter.c
# yes, I hate this too, but Zig expects 128-bit int types that don't exist on m68k
sed -i'.bak' 's/^.*int128_t.*$/ /g' build/*.c
m68k-elf-gcc -nostdlib -c -Iinclude/ -o build/enter.o build/enter.c

green_echo "Compiling 68k assembly..."
m68k-elf-gcc src/init.s build/*.o  -o "build/linked" -nostdlib

green_echo "Converting to floppy disk image..."
m68k-elf-objcopy -O binary build/linked floppy.img
dd if=/dev/zero of=floppy.img bs=1 count=0 seek=1474560

green_echo "Done"
