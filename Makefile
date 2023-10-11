all: simulation
	$(MAKE) -C sim $@

debug: simulation
	$(MAKE) -C sim $@

simulation:
	./scripts/gen_simu_do.sh $(TARGET) $(WAVE)

clean:
	rm -rf sim/work
	rm -rf sim/transcript
	rm -rf sim/vsim.wlf
	rm -rf sim/simu.do
