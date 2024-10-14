OFL   = openFPGALoader
RM    = rm -rf

CC_TOOL_DIR=$(CC_TOOL)
YOSYS = $(CC_TOOL)/bin/yosys/yosys
P_R   = $(CC_TOOL)/bin/p_r/p_r

PRFLAGS = --verbose -cCP
#YS_OPTS = -D DISP_640x480_60Hz=1

SOURCEDIR = ../../..
TOP    = galaksija_olimex_gatemate
CONSTR = olimex.ccf

#all: galaksija_olimex_gatemate prog

galaksija_olimex_gatemate.bin: galaksija_olimex_gatemate.asc
galaksija_olimex_gatemate.asc: galaksija_olimex_gatemate.blif
galaksija_olimex_gatemate.blif: galaksija_olimex_gatemate.v
OBJS += galaksija_olimex_gatemate.v
OBJS += clock/gatemate_10MHz_25MHz_pll.v
OBJS += $(SOURCEDIR)/galaksija.v
OBJS += $(SOURCEDIR)/rom_memory.v
OBJS += $(SOURCEDIR)/font_rom.v
OBJS += $(SOURCEDIR)/video.v
OBJS += $(SOURCEDIR)/uart_rx.v
OBJS += $(SOURCEDIR)/tv80_alu.v
OBJS += $(SOURCEDIR)/tv80_core.v
OBJS += $(SOURCEDIR)/tv80_mcode.v
OBJS += $(SOURCEDIR)/tv80n.v
OBJS += $(SOURCEDIR)/tv80_reg.v
OBJS += $(SOURCEDIR)/rtl_emard/generic/bram_true2p_2clk.v


info:
	@echo "       To build: make all"
	@echo "    To clean up: make clean"

all:impl
synth: $(TOP)_synth.v
$(TOP)_synth.v: $(OBJS)
	$(YOSYS) -ql synth.log -p 'read -sv $^; synth_gatemate -top $(TOP) -nomx8 -vlog $(TOP)_synth.v'

$(TOP)_00.cfg: $(TOP)_synth.v $(CONSTR)
	$(P_R) -v -i $(TOP)_synth.v -ccf $(CONSTR) -o $(TOP) $(PRFLAGS)
impl:$(TOP)_00.cfg

# ------ Galaksija Olimex Gatemate ------
galaksija_olimex_gatemate: dir galaksija_olimex_gatemate.bit

galaksija_olimex_gatemate.bin: galaksija_olimex_gatemate.asc
galaksija_olimex_gatemate.asc: galaksija_olimex_gatemate.json
galaksija_olimex_gatemate.json: $(SOURCEDIR)/galaksija_olimex_gatemate.v \

jtag: $(TOP)_00.cfg
	$(OFL) $(OFLFLAGS) -b $(BOARD) $^

jtag-flash: $(TOP)_00.cfg
	$(OFL) $(OFLFLAGS) -b $(BOARD) -f --verify $^

# ------ HELPERS ------
clean:
	$(RM) *.log *_synth.v *.history *.txt *.refwire *.refparam
	$(RM) *.refcomp *.pos *.pathes *.path_struc *.net *.id *.prn
	$(RM) *_00.v *.used *.sdf *.place *.pin *.cfg* *.cdf

.SECONDARY:
.PHONY: all jtag jtag-flash clean
