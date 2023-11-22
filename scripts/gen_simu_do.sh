#! /bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 <file_name> [signal]"
    exit 1
fi

TB_FILE_NAME=tb_$1
FILE_NAME=$(echo "$1" | sed 's/\([[:alnum:]_]*\)[-.].*/\1/')

echo 'puts "Simulation script for ModelSim"
' > ./simu.do

# test if "$1".v and tb_"$1".v files exist
if [ ! -f "../rtl/""$FILE_NAME"".v" ]; then
    echo "Error: $FILE_NAME.v file not found!"
    exit 1
fi
if [ ! -f "../tb/""$TB_FILE_NAME"".v" ]; then
    echo "Error: ""$TB_FILE_NAME"".v file not found!"
    exit 1
fi

echo 'vlib work
vlog ../rtl/*.v
vlog ../tb/'"$TB_FILE_NAME"'.v
' >> ./simu.do

echo 'vsim tb_'"$FILE_NAME"'
' >> ./simu.do

# loop through all arguments from $3

echo 'run -all' >> ./simu.do

exit 0
