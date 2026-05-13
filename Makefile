SRC = control/fsm_controller.sv \
      compute/mac.sv \
      compute/pe.sv \
      compute/systolic_array.sv \
      memory/input_buffer.sv \
      memory/output_buffer.sv \
      memory/weight_buffer.sv \
      topModule/topModule.sv \
      tests/toplevel_tb.sv

sim:
	iverilog -g2012 -o sim.out $(SRC) && vvp sim.out

clean:
	rm -f sim.out *.fst