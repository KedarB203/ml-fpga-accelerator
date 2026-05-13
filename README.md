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
# RTL Neural Network Accelerator

This repository contains a SystemVerilog prototype of a small neural-network-style accelerator built around a 4x4 systolic array. The design focuses on the parts that matter in real hardware work: dataflow, control, buffering, arithmetic, and verification.

At a high level, the accelerator:

- Streams in 8-bit signed weights and activations.
- Stores weights in double-buffered on-chip memories.
- Buffers a 4-element activation vector.
- Runs matrix-vector style compute on a 4x4 systolic array.
- Accumulates into 32-bit outputs.
- Supports a 3-layer inference flow with internal activation feedback between layers.
- Uses a ready/valid-style output interface and directed simulation testbenches.


## What This Accelerator Computes

The current design is a fixed-size prototype for a 3-layer inference flow operating on 4-element vectors and 4x4 weight matrices.

Current configuration:

- Activation width: 8-bit signed
- Weight width: 8-bit signed
- Accumulator / output width: 32-bit signed
- Array size: 4x4 processing elements
- Number of layers orchestrated by the controller: 3
- Compute completion window inside the array: 7 cycles

The implementation behaves like a matrix-vector engine that, for the current array wiring, effectively computes:

```
y = W^T * x
```

where:

- `x` is a 4-element activation vector
- `W` is a 4x4 weight matrix streamed row-by-row into a weight buffer
- `y` is a 4-element output vector

That transpose behavior is a natural consequence of the current column-wise accumulation pattern in the systolic array.

## Architecture At A Glance

```text
                    +-----------------------------+
weight_in --------> |  Weight Buffer A           | --+
weight_valid -----> |  16 x 8-bit                |   |
                    +-----------------------------+   |
                                                      |   +-------------------+
                    +-----------------------------+   +--> | Active Weight Mux | ---> systolic_array
weight_in --------> |  Weight Buffer B           |       +-------------------+
weight_valid -----> |  16 x 8-bit                |              ^
                    +-----------------------------+              |
                                                                 |
                                                     bufSel / loadSel from FSM


activation_in ----+                                            +------------------+
activation_valid -|------------------------------------------> | Input Buffer      |
                  |                                            | 4 x 8-bit         |
                  |     +-------------------------+            +------------------+
                  +---> | Input / Feedback Mux    | -------------------------------+
                        +-------------------------+                               |
                                  ^                                              |
                                  |                                              v
                             feedback_data[0:3]                           +------------------+
                                                                         | 4x4 Systolic Array|
                                                                         +------------------+
                                                                                  |
                                                                                  v
                                                                         +------------------+
                                                                         | Output Buffer    |
                                                                         | bias + ReLU      |
                                                                         | ready / valid    |
                                                                         +------------------+
                                                                                  |
                                                                                  v
                                                                         out_data[0:3]
                                                                         out_valid
```

## Top-Level Design Philosophy

The project is organized around a few important hardware ideas:

- Separate control from compute. The `fsm_controller` decides when to load, read, compute, and advance layers.
- Keep the compute array simple. The systolic array is a regular grid of identical processing elements.
- Use buffering to decouple external streams from internal compute timing.
- Overlap work where possible. Double-buffered weights let one matrix be read while the next one is prepared.
- Reuse outputs internally. Intermediate layer outputs can be fed back as the next layer's activations instead of always requiring new external inputs.

That combination is exactly what real accelerator design looks like: not just arithmetic, but careful movement and scheduling of data.

## Module Breakdown

### `topModule/topModule.sv`

`topModule` is the system integration point. It connects the external interface, input path, weight memories, compute array, output stage, and controller.

Responsibilities:

- Accepts streamed weights and activations.
- Multiplexes external activations with internally fed-back activations.
- Selects which weight buffer is currently active for compute.
- Connects the array result into the output stage.
- Instantiates the central FSM.

Important behavior:

- `weight_valid` and `activation_valid` are separate, which is better than forcing both through one shared valid signal.
- `bufSel` chooses which buffer is read by compute.
- `loadSel` chooses which buffer is written next.
- Intermediate outputs are captured and reused as the next layer's activation vector.

This is the highest-leverage module in the project because it is where architectural intent becomes a working system.

### `control/fsm_controller.sv`

The controller sequences the accelerator through its operating phases:

1. `INIT`
2. `LOAD_W`
3. `LOAD_I`
4. `COMPUTE`
5. `WAIT_DONE`
6. `WRITEBACK`
7. `NEXT_TILE`

What it does:

- Waits for a full weight matrix to be loaded.
- Waits for a full activation vector to be loaded.
- Starts compute and enables the array's inputs.
- Keeps track of the current layer.
- Coordinates background loading for the next layer.
- Flips active/inactive weight buffers as execution advances.

Why it matters:

This controller is where system-level reasoning shows up. The project is not a single combinational datapath; it is a sequenced accelerator with state, staging, and reuse. That is exactly the kind of thinking expected in serious RTL roles.

### `memory/input_buffer.sv`

The input buffer collects a 4-element activation vector and presents it to the array as a parallel bundle.

Key characteristics:

- Stores 4 values of 8 bits each.
- Raises `input_load_done` when a complete vector has been written.
- Exposes `in_ready` based on fullness.
- Supports being reloaded between layers.

Architecturally, this module turns a serial activation stream into the parallel format the array expects.

### `memory/weight_buffer.sv`

Each weight buffer stores a full 4x4 matrix as 16 streamed bytes.

Key characteristics:

- 16 x 8-bit storage
- Load completion pulse via `load_done`
- Readout as a 4x4 array for the systolic fabric
- Used in a ping-pong / double-buffered arrangement

Double buffering is an important design choice. It reflects a real accelerator pattern: decouple "what compute is using now" from "what software or the input stream is loading next."

### `compute/systolic_array.sv`

The systolic array is the heart of the accelerator.

Structure:

- 4 rows x 4 columns of processing elements
- A wave of activations moves horizontally
- Partial sums move vertically
- Compute runs for a fixed cycle window (`TOTAL_CYCLES = 7`)

Key outputs:

- `result_out[0:3]`
- `done`

Why this matters:

Systolic arrays are a canonical accelerator structure because they expose parallelism, local reuse, and regular layout. Building one in RTL shows strong understanding of both algorithmic mapping and hardware implementation.

### `compute/pe.sv`

Each processing element consumes:

- One activation input
- One weight input
- One incoming partial sum

And produces:

- Forwarded activation output
- Forwarded weight output slot (currently present in the PE interface)
- Updated accumulated result

This regular PE-based decomposition is a strong architectural choice because it makes the array scalable and easy to reason about.

### `compute/mac.sv`

The MAC is the primitive arithmetic block:

```text
acc_out = acc_in + (a_in * b_in)
```

In real accelerator design, getting the primitive arithmetic block correct is critical because every microarchitectural optimization depends on confidence in the leaf cells.

### `memory/output_buffer.sv`

The output stage:

- Captures final 32-bit results when the array asserts `done`
- Holds `valid` until `out_ready`
- Applies simple bias + ReLU behavior

In the current implementation, the bias array is initialized to zero, so the stage mostly acts as a result register plus output handshake and ReLU placeholder.

This is useful because it separates "compute completion" from "external consumption," which is a good systems-level design habit.

## End-To-End Dataflow

The full inference flow looks like this:

1. Reset the accelerator.
2. Stream 16 weights into the selected weight buffer.
3. Stream 4 activations into the input buffer.
4. Transition into `COMPUTE`.
5. Present buffered activations and the active 4x4 weight matrix to the systolic array.
6. Run the array for the configured compute window.
7. Capture the 4 output values in the output buffer.
8. If more layers remain:
   - capture the output vector
   - narrow it to 8-bit feedback values
   - feed it back through the input path
   - switch weight buffers
   - repeat with the next layer's weights
9. Assert `out_valid` for the final consumer and wait for `out_ready`.

This mix of external streaming plus internal reuse is one of the strongest parts of the architecture. It shows an understanding that accelerator performance is driven as much by data movement as by math.

## Example From The Provided Testbench

The top-level testbench uses these example matrices:

- Layer 0:

```text
[ 1 2 3 4 ]
[ 5 6 7 8 ]
[ 1 2 3 4 ]
[ 5 6 7 8 ]
```

- Layer 1: 4x4 identity
- Layer 2: 2 x identity

For an input vector:

```text
x = [1 1 1 1]^T
```

the design expects:

- Layer 0 output: `[12, 16, 20, 24]`
- Layer 1 output: `[12, 16, 20, 24]`
- Layer 2 output: `[24, 32, 40, 48]`

The testbench also includes:

- all-twos input
- all-zeros input
- mixed input `[1, 2, 3, 4]`
- reset recovery behavior

This is a good directed verification strategy for an accelerator prototype because it exercises arithmetic correctness, sequencing, and reset behavior without requiring a huge random test environment.

## Verification Strategy

Verification in this repository is layered:

- `tests/mac_tb.sv` checks the arithmetic primitive.
- `tests/pe_tb.sv` checks a single processing element.
- `tests/toplevel_tb.sv` drives the full accelerator and validates layer-by-layer outputs.

The top-level bench is architecture-aware. It does not simply drive random values; it aligns stimulus with the controller's execution model:

- initial layer-0 weight load
- activation load
- compute
- background load of later layers
- layer-by-layer result checks

That is the correct style for validating a stateful accelerator. It shows an understanding that the right verification approach depends on the microarchitecture.

## Repository Layout

```text
rtl design/
├── control/
│   └── fsm_controller.sv
├── compute/
│   ├── mac.sv
│   ├── pe.sv
│   └── systolic_array.sv
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
└── Makefile
```

## How To Run It

Run the top-level simulation:

```bash
make sim
```

Clean generated artifacts:

```bash
make clean
```

The top-level testbench writes a waveform dump you can inspect in a viewer:

```text
tb_topModule.fst
```

The repository also contains unit-level benches for the MAC and PE that can be compiled manually if you want focused debugging at lower levels.

## Technical Highlights

This project demonstrates several design patterns that are important in real accelerator and silicon work:

- **Systolic compute fabric**: maps structured linear algebra onto a regular PE grid.
- **Double-buffered weights**: allows one matrix to be consumed while another is prepared.
- **Controller-driven sequencing**: clean separation of scheduling from datapath logic.
- **Activation buffering**: converts a serial stream into a parallel compute-ready vector.
- **Internal layer-to-layer feedback**: reuses intermediate outputs without requiring the host to restream them.
- **Handshake-aware output stage**: separates result production from result consumption.
- **Directed verification**: validates behavior at both unit and integrated levels.

## Potential Next Steps

Some strong next iterations for this project would be:

- Parameterize the 4x4 array into an `N x N` generator.
- Add a measured latency / throughput section after synthesis or FPGA implementation.
- Add a simple software model to auto-generate expected outputs for arbitrary tests.
- Expose performance counters for cycles-per-inference.
- Add a cleaner quantized activation pipeline between layers.
- Document synthesis results on a target FPGA platform.

Those additions would turn a strong architecture prototype into an even stronger portfolio piece.

## Closing Note

This project is a solid demonstration of end-to-end digital design thinking: arithmetic blocks, pipelined dataflow, controller design, memory staging, multi-layer reuse, and verification.
