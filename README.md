# RTL Neural Network Accelerator

This repository contains a SystemVerilog prototype of a small neural-network-style accelerator built around a 4x4 systolic array. The project is organized as a complete hardware subsystem rather than a single arithmetic block: it includes control logic, input and weight buffering, a compute fabric, an output stage, and verification collateral.

The design focuses on the hardware questions that matter most in accelerator work:

- how streamed inputs are staged for compute
- how weights are stored and reused
- how a controller sequences a multi-cycle datapath
- how intermediate layer outputs can be reused on chip
- how to verify a stateful accelerator in simulation

## At A Glance

- Inputs: 8-bit signed activations and 8-bit signed weights
- Core compute fabric: 4x4 systolic array
- Accumulation width: 32-bit signed outputs
- Control: FSM-driven multi-stage execution
- Weight storage: double-buffered 4x4 matrices
- Activation storage: buffered 4-element vector
- Layer flow: 3-layer sequence with internal feedback path
- Output interface: valid/ready style handshake

## What The Project Does

At a high level, the accelerator:

1. streams in a 4x4 weight matrix
2. streams in a 4-element activation vector
3. stages both into local buffers
4. runs the data through a 4x4 systolic array
5. captures the resulting 4-element output vector
6. optionally feeds that output back as the next layer's input
7. repeats the process across three scheduled layers

This makes the repository a good example of end-to-end RTL system design. It is not just "a MAC in Verilog"; it is a small inference-style engine with real architectural structure.

## Compute Model

For the current array wiring, the implementation behaves like a matrix-vector engine that effectively computes:

```text
y = W^T * x
```

where:

- `x` is a 4-element activation vector
- `W` is a streamed 4x4 weight matrix
- `y` is a 4-element output vector

The transpose comes from the current accumulation direction inside the systolic array. That detail matters because it explains both the expected outputs in simulation and the way the testbench is written.

## Architecture Overview

The architecture is composed of five main pieces:

1. `fsm_controller`
   Sequences the accelerator through weight load, activation load, compute, output, and layer advancement.

2. `input_buffer`
   Collects a serial activation stream and presents a 4-element vector to the compute fabric.

3. `weight_buffer A` and `weight_buffer B`
   Store 4x4 weight matrices and support ping-pong style buffering.

4. `systolic_array`
   Performs the matrix-vector style computation using a regular grid of processing elements.

5. `output_buffer`
   Captures the final results, applies the output-stage behavior, and presents a handshake-friendly interface.

These blocks are integrated in `topModule/topModule.sv`, which also contains the internal feedback logic used to carry intermediate outputs into later layers.

## Top-Level Dataflow

```text
external weights                     external activations
weight_valid / weight_in             activation_valid / activation_in
          |                                      |
          v                                      v
 +------------------+                 +---------------------------+
 | weight_buffer A  |                 | external / feedback mux   |
 +------------------+                 +---------------------------+
          |                                      |
 +------------------+                            v
 | weight_buffer B  |                    +------------------+
 +------------------+                    |   input_buffer   |
          |                              +------------------+
          +----------- active weights -----------+
                                                  |
                                                  v
                                         +------------------+
                                         |  systolic_array  |
                                         +------------------+
                                                  |
                                                  v
                                         +------------------+
                                         |  output_buffer   |
                                         +------------------+
                                                  |
                          +-----------------------+----------------------+
                          |                                              |
                          v                                              v
                  internal feedback path                         out_data / out_valid
```

## How The Main Modules Work

### `topModule/topModule.sv`

The top module is the architectural center of the project. It wires together:

- the external streaming interface
- the activation input path
- the double-buffered weight memories
- the systolic array
- the output stage
- the FSM controller
- the internal activation feedback path

Two ideas are especially important here:

- `bufSel` chooses which weight buffer is currently active for compute
- `loadSel` chooses which weight buffer is currently receiving newly streamed weights

This separation lets the architecture keep one matrix available for compute while preparing the next one in the background.

The top module also captures output values and routes them back into the activation path for the next layer. That keeps intermediate activations on chip instead of forcing them back through the external interface.

### `control/fsm_controller.sv`

The controller sequences the accelerator through these phases:

1. `INIT`
2. `LOAD_W`
3. `LOAD_I`
4. `COMPUTE`
5. `WAIT_DONE`
6. `WRITEBACK`
7. `NEXT_TILE`

The FSM is responsible for:

- deciding when weights can be loaded
- deciding when activations can be loaded
- starting compute
- enabling reads from the staged buffers
- tracking layer progress
- switching active and inactive weight buffers

This control-path separation is one of the strongest aspects of the project. It keeps sequencing logic explicit and makes the datapath easier to understand.

### `memory/input_buffer.sv`

The input buffer turns a serial activation stream into a parallel 4-element bundle.

It:

- stores four 8-bit values
- raises `input_load_done` when a full vector is available
- exposes `in_ready`
- drives the vector seen by the systolic array

This is the bridge between the external stream and the array's structured input format.

### `memory/weight_buffer.sv`

Each weight buffer stores a full 4x4 matrix as 16 streamed values.

It:

- accepts one weight per valid cycle
- tracks completion of a matrix load
- exposes a 4x4 matrix to the compute fabric

Using two instances of this module is what enables the weight ping-pong scheme.

### `compute/systolic_array.sv`

The systolic array is the compute core.

Current structure:

- 4 rows
- 4 columns
- identical processing elements
- fixed compute completion window of 7 cycles

Conceptually:

- activations move horizontally
- partial sums move vertically
- each PE performs one multiply-accumulate contribution

This type of structure is widely used in accelerator design because it exposes regular parallelism and local reuse.

### `compute/pe.sv`

Each processing element:

- takes one activation input
- takes one weight input
- takes one incoming accumulated value
- forwards activation data onward
- outputs an updated accumulated result

The PE-level abstraction makes the compute fabric regular and scalable.

### `compute/mac.sv`

The MAC implements the arithmetic primitive:

```text
acc_out = acc_in + (a_in * b_in)
```

This is the smallest compute block in the design, but it is foundational because every PE depends on it.

### `memory/output_buffer.sv`

The output stage:

- latches the result vector when compute finishes
- holds `valid` until `out_ready`
- provides the place for output-stage behavior such as bias and ReLU

In the current project, the bias values are initialized to zero, so this block primarily serves as the registered result and handshake boundary.

## Multi-Layer Behavior

The project is not limited to a single matrix-vector multiply. The architecture supports a 3-layer sequence by reusing outputs as future inputs.

The flow is:

1. load layer-0 weights
2. load the external activation vector
3. compute the first output vector
4. capture that vector internally
5. feed it back through the activation path
6. load the next layer's weights into the alternate weight buffer
7. repeat until the final layer completes

This is one of the most interesting parts of the design because it demonstrates that the architecture is thinking about data reuse, not just arithmetic correctness.

## Why Double Buffering Matters

The double-buffered weight path is a central design choice.

Without it, the accelerator would need to fully stop compute before every new matrix load. With two buffers, the architecture can separate:

- the matrix currently being used by the array
- the matrix currently being prepared for a later layer

That does not make the project magically high performance on its own, but it shows the right architectural instinct: decouple communication from compute where possible.

## Example Test Case

The current top-level testbench uses a 3-layer example:

- Layer 0: a nontrivial 4x4 matrix
- Layer 1: identity matrix
- Layer 2: 2x identity

For an input:

```text
x = [1 1 1 1]^T
```

the expected outputs are:

- after layer 0: `[12, 16, 20, 24]`
- after layer 1: `[12, 16, 20, 24]`
- after layer 2: `[24, 32, 40, 48]`

This is useful because it makes the architecture easy to validate with human-checkable numbers.

## Verification Approach

The repository uses layered verification:

- `tests/mac_tb.sv`
  Validates the arithmetic primitive.

- `tests/pe_tb.sv`
  Validates a single processing element.

- `tests/toplevel_tb.sv`
  Validates the integrated accelerator across staged loads, compute, feedback, and output checks.

This verification style matches the structure of the project:

- verify leaf blocks first
- verify intermediate composition next
- verify full control-plus-datapath behavior last

That is a practical way to debug stateful RTL systems.

## Repository Structure

```text
rtl design/
├── control/
│   └── fsm_controller.sv
├── compute/
│   ├── mac.sv
│   ├── pe.sv
│   └── systolic_array.sv
├── docs/
│   ├── architecture.md
│   ├── design_choices.md
│   ├── performance.md
│   └── README.md
├── memory/
│   ├── input_buffer.sv
│   ├── output_buffer.sv
│   └── weight_buffer.sv
├── tests/
│   ├── mac_tb.sv
│   ├── pe_tb.sv
│   └── toplevel_tb.sv
├── topModule/
│   └── topModule.sv
├── Makefile
└── README.md
```

## How To Run The Project

Run the full top-level simulation:

```bash
make sim
```

Clean generated artifacts:

```bash
make clean
```

The integrated testbench writes an `fst` waveform dump for inspection in a waveform viewer.

## Additional Documentation

The root `README.md` is the main architecture overview. The `docs/` folder contains supporting documents:

- `docs/README.md`
  documentation index

- `docs/architecture.md`
  deeper explanation of block structure, control flow, and end-to-end data movement

- `docs/design_choices.md`
  rationale behind the main architectural decisions

- `docs/performance.md`
  honest discussion of the performance-relevant properties currently visible in the RTL and simulation

## Current Scope

This repository is best understood as an accelerator prototype.

It already demonstrates:

- nontrivial multi-module RTL integration
- explicit control-path and datapath separation
- structured parallel compute
- double-buffered weight staging
- internal activation reuse across layers
- simulation-based verification

It is not yet presented as a production-ready hardware IP block with synthesis, timing, and implementation reports. That is a normal and reasonable scope boundary for this stage of the project.

## Next Steps

Natural next improvements would be:

- parameterize the 4x4 array into a scalable generator
- formalize quantization or saturation behavior between layers
- add measured latency and throughput tables
- add synthesis or FPGA implementation reports
- add a software reference model for automatic result generation

## Summary

This project is a compact but meaningful example of accelerator-oriented RTL design. It combines buffering, scheduling, structured compute, internal data reuse, and verification into a single coherent system. The result is a repository that is technically substantive, easy to inspect, and well suited for deeper architectural discussion.


