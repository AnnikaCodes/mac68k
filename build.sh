#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

function green_echo() {
    echo -e "\033[0;32m${1}\033[0m"
}

green_echo "Cleaning build directory..."
mkdir -p build

green_echo "Compiling Zig code..."
~/zig/build/zig build-obj -Iinclude/ -target m68k-freestanding src/enter.zig -fno-LLVM -ofmt=c -femit-bin=build/enter.c
# Zig bug: 128-bit integer types are included even when targeting platforms whose C compilers
# do not support them. This `sed` hack removes them.
sed -i'.bak' 's/__int128/__INT64_TYPE__/g' build/*.c
sed -i'.bak' 's/__uint128/__UINT64_TYPE__/g' build/*.c
m68k-elf-gcc -nostdlib -c -Iinclude/ -o build/enter.o build/enter.c
green_echo "(The integer overflow warnings are due to a hack necessary to compile Zig to C on platforms without 128-bit integers in C.)"

green_echo "Compiling 68k assembly..."
m68k-elf-gcc src/*.s build/*.o  -o "build/linked" -nostdlib

green_echo "Converting to floppy disk image..."
m68k-elf-objcopy -O binary build/linked floppy.img
dd if=/dev/zero of=floppy.img bs=1 count=0 seek=1474560

green_echo "Done"
