all:
	./../scripts/get_bin.sh ../tb/test_source_code/tb_riscv_cpu/test
	vsim -c -do "do simu.do; quit -f"

debug:
	vsim -do "do simu.do"