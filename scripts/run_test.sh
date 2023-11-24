#!/bin/sh

rm -rf work runtime_test.tmp final_test.tmp

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
    if [ ! -f "$TEST_FILE_PATH" ]; then
        echo "test file: ""$TEST_FILE_PATH"": does not exit"
        exit 1
    fi

    ./${SCRIPT_FOLDER}/get_bin.sh $TEST_FILE_PATH
    python3 ./${SCRIPT_FOLDER}/gen_test.py $TEST_FILE_PATH

    if [ -z $2 ]; then
        # display only if line contains '[FAIL]' or '[PASS]'
        vsim -c -do "do simu.do; quit -f" >& /dev/null # | tr -cd '[:print:]\t\n' | print_result # print_result #| sed -n 's/^# \(.*\[FAIL\|\PASS\].*\)/\1/p'
    else
        vsim -do "do simu.do"
    fi

    print_result $(basename $TEST_FILE_PATH .S)
}

print_result ()
{
    while read line; do
        if [[ $line = *"# Errors: "* ]]; then
            # Errors: 0, Warnings: 0 - get only the number of errors
            if [ $(echo "$line" | sed 's/^# Errors: \([[:digit:]]*\).*/\1/') -ne 0 ]; then
                cat ./transcript
                return 1
            fi
        fi
    done < ./transcript

    nb_test=0
    nb_pass=0
    nb_fail=0
    while read line; do
        if [[ $line = *"[FAIL]"* ]]; then
            echo "$line" | cut -c 3-
            ((nb_fail++))
            ((nb_test++))
        elif [[ $line == *"[PASS]"* ]]; then
            ((nb_pass++))
            ((nb_test++))
        elif [[ $line == *"\*\* Warning"* ]]; then
            echo "$line" | cut -c 3-
        fi
    done < ./transcript

    bold=$(tput bold)
    normal=$(tput sgr0)
    echo -e "[\033[0;34m$bold$1$normal\033[0m]$bold Test: $nb_test | Passed: $normal\033[0;32m$bold$nb_pass$normal\033[0m$bold | Failed: $normal\033[0;31m$bold$nb_fail$normal\033[0m"
}

if [ -z "$TEST_FILE" ] || [ "$TEST_FILE" = "all" ]; then
    ./${SCRIPT_FOLDER}/gen_simu_do.sh "$TEST_BENCH"

    if [ -z $2 ]; then
        vsim -c -do "do simu.do; quit -f" >& /dev/null
    else
        vsim -do "do simu.do"
    fi

    print_result $TEST_BENCH
fi

if [ ! -z "$TEST_FILE" ]; then
    TEST_BENCH_PATH="$TEST_BENCH_FOLDER""/tb_""$TEST_BENCH""-dyn"
    if [ ! -f "$TEST_BENCH_PATH"".v" ]; then
        exit 0
    fi

    ./${SCRIPT_FOLDER}/gen_simu_do.sh "$TEST_BENCH""-dyn"

    if [ "$TEST_FILE" == "all" ]; then
        for f in "$TEST_BENCH_FOLDER""/""$TEST_FOLDER"/*; do
            run_test "$f" "$2"
        done
    else
        run_test "$TEST_BENCH_FOLDER""/""$TEST_FOLDER""/"$TEST_FILE".S" "$2"
    fi
fi

exit 0
