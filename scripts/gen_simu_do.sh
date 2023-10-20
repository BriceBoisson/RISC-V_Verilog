#! /bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 <file_name> [signal]"
    exit 1
fi

FILE_NAME=$1

echo 'puts "Simulation script for ModelSim"
' > ./sim/simu.do

# test if "$1".v and tb_"$1".v files exist
if [ ! -f "rtl/""$FILE_NAME"".v" ]; then
    echo "Error: $FILE_NAME.v file not found!"
    exit 1
fi
if [ ! -f "tb/tb_""$FILE_NAME"".v" ]; then
    echo "Error: tb_$FILE_NAME.v file not found!"
    exit 1
fi

echo 'vlib work
vlog ../rtl/*.v
vlog ../tb/tb_'"$FILE_NAME"'.v
' >> ./sim/simu.do

echo 'vsim tb_'"$FILE_NAME"'
add wave -radix unsigned *' >> ./sim/simu.do

# loop through all arguments from $3

echo 'run -all' >> ./sim/simu.do

exit 0
