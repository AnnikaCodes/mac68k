#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail


debug_or_release="debug"
target_dir="target/mac68k/${debug_or_release}"
function green_echo() {
    echo -e "\033[0;32m${1}\033[0m"
}

green_echo "Compiling Rust code..."
cargo rustc --target mac68k.json -- --emit=obj
green_echo "Compiling 68k assembly..."
m68k-elf-gcc src/asm/init.s -c -o "${target_dir}/deps/asm.o" -nostdlib
green_echo "Linking..."
m68k-elf-ld $target_dir/deps/*.o -o "${target_dir}/mac68k"
green_echo "Converting to floppy disk image..."
m68k-elf-objcopy -O binary "${target_dir}/mac68k" floppy.img
dd if=/dev/zero of=floppy.img bs=1 count=0 seek=819200
green_echo "Done"