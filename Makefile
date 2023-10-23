# -Wall turns on all warningsdout
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/block.sv hdl/systolic_array.sv hdl/shifter.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_sys_array : testbenches/test_systolic_array.sv ${SRCS}
	${IVERILOG} $^ -o test_sys_array.bin && ${VVP} test_sys_array.bin ${VVP_POST} && gtkwave systolic_array.fst
test_shifter : testbenches/test_shifter.sv ${SRCS}
	${IVERILOG} $^ -o test_shifter.bin && ${VVP} test_shifter.bin ${VVP_POST} && gtkwave shifter.fst
# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil