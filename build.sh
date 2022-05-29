#!/usr/bin/env bash
# if this project grows we should use a Makefile or similar

set -o errexit
set -o pipefail

function green_echo() {
    echo -e "\033[0;32m${1}\033[0m"
}

if [ -z $1 ]; then
    PREFIX='m68k-elf'
else
    PREFIX=${1}
fi

mkdir -p build

green_echo "Compiling C code..."
BUILD="$PREFIX-gcc -nostdlib -mpcrel -m68000 -Isrc/headers -c -o"
$BUILD build/enter.o src/enter.c
$BUILD build/video.o src/video.c
$BUILD build/terminal.o src/terminal.c
$BUILD build/utils.o src/utils.c

green_echo "Compiling 68k assembly..."
"$PREFIX-gcc" src/*.s build/*.o  -o "build/linked" -nostdlib

green_echo "Converting to floppy disk image..."
"$PREFIX-objcopy" -O binary build/linked floppy.img
dd if=/dev/zero of=floppy.img bs=1 count=0 seek=1474560

green_echo "Done"
