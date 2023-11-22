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

riscv32-unknown-elf-as -march=rv32i -mabi=ilp32 ${FOLDER}/${NAME}.S -o ${NAME}.o
riscv32-unknown-elf-ld -Ttext=0x0 ${NAME}.o -o ${NAME}.elf
riscv32-unknown-elf-objcopy -O binary ${NAME}.elf ${NAME}.bin

rm -rf ${NAME}.o ${NAME}.elf

exit 0
