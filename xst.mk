#XDIR = /cygdrive/c/Xilinx/12.3/ISE_DS/ISE

############################################################################
# Some nice targets
############################################################################

all: $(PROJECT).bit

floorplan: $(PROJECT).ngd $(PROJECT).par.ncd
	$(FLOORPLAN) $^

report:
	cat *.srp

clean::
	rm -f *.work *.xst
	rm -f *.ngc *.ngd *.bld *.srp *.lso *.prj
	rm -f *.map.mrp *.map.ncd *.map.ngm *.mcs *.par.ncd *.par.pad
	rm -f *.pcf *.prm *.bgn *.drc
	rm -f *.par_pad.csv *.par_pad.txt *.par.par *.par.xpi
	rm -f *.bit
	rm -f *.vcd *.vvp
	rm -f verilog.dump verilog.log
	rm -rf _ngo/
	rm -rf xst/

############################################################################
# Xilinx tools and wine
############################################################################

XST_DEFAULT_OPT_MODE = Speed
XST_DEFAULT_OPT_LEVEL = 1
DEFAULT_ARCH = spartan3
DEFAULT_PART = xc3s700an-fgg484-4

XBIN = $(XDIR)/bin/nt64
#XBIN = $(XDIR)/bin/nt
#XBIN = $(XDIR)/bin/lin
#XENV = XILINX=$(XDIR) LD_LIBRARY_PATH=$(XBIN)

#XST 	   = $(XENV) $(XBIN)/xst
#NGDBUILD  = $(XENV) $(XBIN)/ngdbuild
#MAP       = $(XENV) $(XBIN)/map
#PAR       = $(XENV) $(XBIN)/par
#TRCE      = $(XENV) $(XBIN)/trce
#BITGEN    = $(XENV) $(XBIN)/bitgen
#PROMGEN   = $(XENV) $(XBIN)/promgen
#FLOORPLAN = $(XENV) $(XBIN)/floorplanner

XST=$(XBIN)/xst
NGDBUILD=$(XBIN)/ngdbuild
MAP=$(XBIN)/map
PAR=$(XBIN)/par
TRCE=$(XBIN)/trce
BITGEN=$(XBIN)/bitgen
PROMGEN=$(XBIN)/promgen
FLOORPLAN=$(XBIN)/floorplanner

XSTWORK   = $(PROJECT).work
XSTSCRIPT = $(PROJECT).xst

IMPACT_OPTIONS_FILE   ?= _impact.cmd    

#.PRECIOUS: %.ngc %.ngc %.ngd %.map.ncd %.bit %.par.ncd %.bin

ifndef XST_OPT_MODE
XST_OPT_MODE = $(XST_DEFAULT_OPT_MODE)
endif
ifndef XST_OPT_LEVEL
XST_OPT_LEVEL = $(XST_DEFAULT_OPT_LEVEL)
endif
ifndef ARCH
ARCH = $(DEFAULT_ARCH)
endif
ifndef PART
PART = $(DEFAULT_PART)
endif

$(XSTWORK): $(SOURCES)
	> $@
	for a in $(SOURCES); do echo "vhdl work $$a" >> $@; done   
    
$(XSTSCRIPT): $(XSTWORK)
	> $@
	echo -n "run -ifn $(XSTWORK) -ifmt mixed -top $(TOP) -ofn $(PROJECT).ngc" >> $@
	echo " -ofmt NGC -p $(PART) -iobuf yes -opt_mode $(XST_OPT_MODE) -opt_level $(XST_OPT_LEVEL)" >> $@

$(PROJECT).bit: $(XSTSCRIPT)
	$(XST) -intstyle ise -ifn $(PROJECT).xst -ofn $(PROJECT).syr
	$(NGDBUILD) -intstyle ise -dd _ngo -nt timestamp -uc $(PROJECT).ucf -p $(PART) $(PROJECT).ngc $(PROJECT).ngd
	$(MAP) -intstyle ise -p $(PART) -w -ol high -t 1 -global_opt off -o $(PROJECT).map.ncd $(PROJECT).ngd $(PROJECT).pcf
	$(PAR) -w -intstyle ise -ol high $(PROJECT).map.ncd $(PROJECT).ncd $(PROJECT).pcf
	$(TRCE) -intstyle ise -v 4 -s 4 -n 4 -fastpaths -xml $(PROJECT).twx $(PROJECT).ncd -o $(PROJECT).twr $(PROJECT).pcf
	$(BITGEN) -intstyle ise $(PROJECT).ncd

$(PROJECT).bin: $(PROJECT).bit
	$(PROMGEN) -w -p bin -o $(PROJECT).bin -u 0 $(PROJECT).bin
    
############################################################################
# End
############################################################################
