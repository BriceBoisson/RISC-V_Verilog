#!/bin/sh

rm -rf runtime_test.tmp final_test.tmp

SCRIPT_FOLDER="./../scripts"
TEST_BENCH_FOLDER="./../tb"
TEST_BENCH="${1%-*}"
TEST_FOLDER="test_source_code/tb_""$TEST_BENCH"
TEST_FILE=$(echo "${1}" | awk -F'-' '{if (NF>1) {print $NF}}')

TEST_BENCH_PATH="$TEST_BENCH_FOLDER""/tb_""$TEST_BENCH"
if [ ! -f "$TEST_BENCH_PATH"".v" ]; then
    echo "testbench: ""$TEST_BENCH_PATH"": does not exit"
    exit 1
fi

run_test ()
{
    TEST_FILE_PATH=$1
    if [ ! -f $TEST_FILE_PATH ]; then
        echo "test file: ""$TEST_FILE_PATH"": does not exit"
        exit 1
    fi

    ./${SCRIPT_FOLDER}/get_bin.sh $TEST_FILE_PATH
    python3 ./${SCRIPT_FOLDER}/gen_test.py $TEST_FILE_PATH

    if [ -z $2 ]; then
        vsim -c -do "do simu.do; quit -f"
    else
        vsim -do "do simu.do"
    fi
}

if [ -z "$TEST_FILE" ] || [ "$TEST_FILE" = "all" ]; then
    ./${SCRIPT_FOLDER}/gen_simu_do.sh "$TEST_BENCH"

    if [ -z $2 ]; then
        vsim -c -do "do simu.do; quit -f"
    else
        vsim -do "do simu.do"
    fi
fi

if [ ! -z "$TEST_FILE" ]; then
    TEST_BENCH_PATH="$TEST_BENCH_FOLDER""/tb_""$TEST_BENCH""-dyn"
    if [ ! -f "$TEST_BENCH_PATH"".v" ]; then
        exit 0
    fi

    ./${SCRIPT_FOLDER}/gen_simu_do.sh "$TEST_BENCH""-dyn"

    if [ "$TEST_FILE" == "all" ]; then
        for f in "$TEST_BENCH_FOLDER""/""$TEST_FOLDER""/*"; do
            run_test $f $2
        done
    else
        run_test $TEST_FILE".S" $2
    fi
fi

exit 0
