all:
	$(MAKE) -C sim $@

debug:
	$(MAKE) -C sim $@

clean:
	rm -rf sim/work
	rm -rf work
	rm -rf sim/transcript
	rm -rf transcript
	rm -rf sim/vsim.wlf
	rm -rf sim/simu.do
	rm -rf sim/*.bin
	rm -rf sim/*.elf
	rm -rf sim/*.o
	rm -rf sim/*.tmp
