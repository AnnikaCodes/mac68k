#!/usr/bin/env bash

set -o pipefail

function green_echo() {
    echo -e "\033[0;32m${1}\033[0m"
}
function orange_echo() {
    echo -e "\033[0;33m${1}\033[0m"
}

if [ -z "$ZIG" ]; then
    ZIG=$(which zig)
    if [ -z "$ZIG" ]; then
        echo "Please set the ZIG environment variable to the path of your Zig executable."
        exit 1
    fi
fi
CC="m68k-elf-gcc -nostdlib -mno-rtd -m68000 -Iinclude"

mkdir -p build

if [ ! -f build/compiler_rt.o ] || [ ! -f build/memtools.o ]; then
    green_echo "=> Compiling helpers for Zig build"
    $CC -c -o build/compiler_rt.o include/compiler_rt.c
    $CC -c -o build/memtools.o include/memtools.c
else
    orange_echo "=> Zig helpers already built, skipping..."
fi

# default to Debug
if (( $# == 0 )); then
    BUILD_MODE="Debug"
else
    BUILD_MODE="$1"
fi

green_echo "==> Compiling Zig code (in ${BUILD_MODE} mode)"
$ZIG  build-obj src/enter.zig "-O${BUILD_MODE}" -ofmt=c -femit-bin="build/enter.c" -target m68k-freestanding

$CC -c -o build/enter.o build/enter.c

green_echo "===> Compiling C traps file"
$CC -c -o build/traps.o src/traps.c

# green_echo "(The integer overflow warnings are due to a hack necessary to compile Zig to C on platforms without 128-bit integers in C.)"

green_echo "====> Compiling 68k assembly"
$CC -c -o build/asm.o src/*.s

green_echo "=====> Linking"
# order MATTERS
$CC -o "build/linked" build/asm.o build/traps.o build/enter.o  build/compiler_rt.o build/memtools.o

green_echo "======> Converting to floppy disk image"
m68k-elf-objcopy -O binary build/linked floppy.img
dd if=/dev/zero of=floppy.img bs=1 count=0 seek=1474560

green_echo "=======> Done!"
