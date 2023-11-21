all:
	./../scripts/get_bin.sh ../tb/test_source_code/tb_riscv_cpu/test
	python3 ./../scripts/gen_test.py ../tb/test_source_code/tb_riscv_cpu test.S
	vsim -c -do "do simu.do; quit -f"

debug:
	vsim -do "do simu.do"