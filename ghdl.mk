# Filename: ghdl.mk
# Author: Nikolaos Kavvadias (C) 2016-2021

GHDL=ghdl
GHDLFLAGS=--ieee=standard --std=08 --workdir=work
# Simulation will run up to this limit and end by the forced assert.
GHDLRUNFLAGS=--stop-time=75000000ns

all : run

# Elaborate target.  Almost useless
elab : force
	$(GHDL) -c $(GHDLFLAGS) -e color_maker_top_tb

# Run target
run : force
	$(GHDL) --elab-run $(GHDLFLAGS) color_maker_top_tb $(GHDLRUNFLAGS)

# Target to analyze libraries
init : force
	mkdir work
	$(GHDL) -a $(GHDLFLAGS) clockdiv.vhd
	$(GHDL) -a $(GHDLFLAGS) vgactrl.vhd
	$(GHDL) -a $(GHDLFLAGS) color_maker.vhd
	$(GHDL) -a $(GHDLFLAGS) color_maker_top.vhd
	$(GHDL) -a $(GHDLFLAGS) color_maker_top_tb.vhd

force : 

clean :
	rm -rf *.o *.ghdl work *_results.txt
