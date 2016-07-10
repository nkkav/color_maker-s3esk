# Filename: ghdl.mk
# Author: Nikolaos Kavvadias (C) 2016

GHDL=ghdl
GHDLFLAGS=--ieee=synopsys --workdir=work
GHDLRUNFLAGS=--stop-time=48000000ns

all : run

elab : force
	$(GHDL) -c $(GHDLFLAGS) -e color_maker_top_tb

run : force
	./color_maker_top.ghdl $(GHDLRUNFLAGS)

init : force
	mkdir work
	$(GHDL) -i $(GHDLFLAGS) clockdiv.vhd
	$(GHDL) -i $(GHDLFLAGS) vgactrl.vhd
	$(GHDL) -i $(GHDLFLAGS) color_maker.vhd
	$(GHDL) -i $(GHDLFLAGS) color_maker_top.vhd
	$(GHDL) -i $(GHDLFLAGS) color_maker_top_tb.vhd
	$(GHDL) -m $(GHDLFLAGS) -o color_maker_top.ghdl color_maker_top_tb
force : 

clean :
	rm -rf *.o *.ghdl work
