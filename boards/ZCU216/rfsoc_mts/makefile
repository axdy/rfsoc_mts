.PHONY: all block_design bitstream clean

all: bitstream

block_design: rfsoc_mts/rfsoc_mts.xpr

rfsoc_mts/rfsoc_mts.xpr:
	vivado -mode batch -source make_block_design.tcl -notrace

bitstream: block_design
	vivado -mode batch -source make_bitstream.tcl -notrace

clean:
	rm -rf rfsoc_mts *.jou *.log NA .Xil
