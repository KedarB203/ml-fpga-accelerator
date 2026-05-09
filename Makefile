SRCS = fsm_controller.v \
       compute/mac.v compute/pe.v compute/systolic_array.v \
       memory/input_buffer.v memory/output_buffer.v memory/weight_buffer.v \
       topModule/topModule.v

TB_TOP  = tests/toplevel_tb.v
TB_MAC  = tests/mac_tb.v
TB_PE   = tests/pe_tb.v

all: sim

sim:
	iverilog -o sim.out $(SRCS) $(TB_TOP) && vvp sim.out

mac:
	iverilog -o mac.out compute/mac.v $(TB_MAC) && vvp mac.out

pe:
	iverilog -o pe.out compute/mac.v compute/pe.v $(TB_PE) && vvp pe.out

clean:
	rm -f *.out *.vcd