#!/bin/sh

if    [ ! command -v riscv32-unknown-elf-as &> /dev/null ] \
   || [ ! command -v riscv32-unknown-elf-ld &> /dev/null ] \
   || [ ! command -v riscv32-unknown-elf-objcopy &> /dev/null ]
then
    echo "riscv32-unknown-elf could not be found"
    exit 1
fi

if [ $# -eq 0 ]
then
    echo "Usage: $0 <file>"
    exit 1
fi

NAME=$(basename $1)
NAME=${NAME%.*}
FOLDER=$(dirname $1)

riscv32-unknown-elf-as -march=rv32i -mabi=ilp32 ${FOLDER}/${NAME}.S -o test.o
riscv32-unknown-elf-ld -Ttext=0x0 test.o -o test.elf
riscv32-unknown-elf-objcopy -O binary test.elf test.bin

rm -rf test.o test.elf

exit 0
