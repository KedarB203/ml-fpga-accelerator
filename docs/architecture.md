# Architecture

This document explains the current RTL architecture of the accelerator. The project is a small inference-style engine built around a 4x4 systolic array, explicit controller sequencing, staged activation input, double-buffered weights, and an internal feedback path that carries one layer's results into the next layer.

## 1. Architectural Intent

The design is meant to prototype the core structure of a neural-network accelerator in hardware:

- accept streamed weights and activations
- stage those values in local memories
- run structured multiply-accumulate compute in parallel
- sequence multiple layers with a controller
- reuse intermediate outputs internally

The implementation is fixed-size, which keeps the project compact enough to simulate and debug while still showing meaningful architectural ideas.

Current operating scale:

- activation vector length: 4
- weight matrix size: 4x4
- activation width: 8-bit signed
- weight width: 8-bit signed
- output / accumulation width: 32-bit signed
- scheduled layer count: 3

## 2. Top-Level Interface

The top-level module is `topModule/topModule.sv`.

External inputs:

- `clk`
- `rst`
- `weight_valid`
- `weight_in`
- `activation_valid`
- `activation_in`
- `out_ready`

External outputs:

- `in_ready`
- `out_valid`
- `out_data[0:3]`

The interface is intentionally simple:

- weights arrive as a byte stream
- activations arrive as a byte stream
- results leave as a 4-element vector with valid/ready handshaking

This keeps the architecture focused on the compute system rather than on bus-wrapper complexity.

## 3. Block-Level Structure

```text
weight stream                         activation stream
weight_valid / weight_in              activation_valid / activation_in
         |                                       |
         v                                       v
 +------------------+                  +---------------------------+
 | weight_buffer A  |                  | external / feedback mux   |
 +------------------+                  +---------------------------+
         |                                       |
 +------------------+                            v
 | weight_buffer B  |                    +------------------+
 +------------------+                    |   input_buffer   |
         |                               +------------------+
         +------------ active matrix ------------+
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
                feedback registers / mux                         out_data / out_valid

                           fsm_controller
               drives load, read, start, and buffer selection
```

## 4. Main Architectural Blocks

### 4.1 Top-Level Integration

`topModule/topModule.sv` is where the system comes together.

It is responsible for:

- wiring the external inputs into the internal data path
- choosing between external activations and internally fed-back activations
- instantiating two weight buffers
- selecting the active weight buffer for compute
- connecting buffered data into the systolic array
- connecting the array output into the output stage
- instantiating and wiring the controller

This module is the architectural hub of the repository.

### 4.2 Input Buffer

`memory/input_buffer.sv` converts a serial activation stream into a parallel 4-element vector.

It:

- stores four incoming activation bytes
- raises `input_load_done` when the vector is ready
- exposes `in_ready` based on available space
- presents the buffered vector to the array

This is a standard but important accelerator pattern: an external stream is reshaped into the format needed by the compute core.

### 4.3 Weight Buffers

`memory/weight_buffer.sv` stores one full 4x4 weight matrix as 16 streamed values.

The architecture instantiates two copies:

- buffer A
- buffer B

Together they form a ping-pong or double-buffered weight path.

Each buffer:

- accepts one 8-bit value per valid cycle
- stores 16 values
- raises `load_done` when the matrix has been fully loaded
- exposes the stored values as a 4x4 matrix

### 4.4 Weight Buffer Selection

Two control signals organize the double-buffered path:

- `bufSel`
  Chooses which buffer is currently active for compute reads.

- `loadSel`
  Chooses which buffer is currently receiving the incoming weight stream.

This separation is one of the most important design choices in the project because it allows compute and future weight preparation to be logically decoupled.

### 4.5 Systolic Array

`compute/systolic_array.sv` is the compute fabric.

The current implementation uses:

- 4 rows
- 4 columns
- one PE per array position
- fixed-cycle completion tracking

Inside the array:

- activations move horizontally
- partial sums move vertically
- each PE contributes one multiply-accumulate step

The array currently uses `TOTAL_CYCLES = 7` to mark compute completion.

### 4.6 Processing Elements

`compute/pe.sv` defines the repeated building block of the array.

Each PE:

- receives one activation input
- receives one weight input
- receives one incoming partial sum
- forwards activation data to the next stage
- updates the accumulated result

This regular PE-based construction gives the array its structured form.

### 4.7 MAC Primitive

`compute/mac.sv` implements the leaf arithmetic operation:

```text
acc_out = acc_in + (a_in * b_in)
```

This is the primitive computation used throughout the array.

### 4.8 Output Buffer

`memory/output_buffer.sv` sits after the array.

It:

- latches the output vector when compute completes
- holds the result valid until `out_ready`
- provides the output-stage behavior, including the bias / ReLU hook

This creates a clean boundary between the internal compute schedule and whatever consumes the results.

### 4.9 Controller

`control/fsm_controller.sv` is the control path for the accelerator.

It drives:

- `load_input`
- `load_weight`
- `start_compute`
- `input_read_en`
- `weight_read_en`
- `bufSel`
- `loadSel`

It also tracks layer progress and coordinates buffer switching.

Without the controller, the architecture would just be a collection of modules. The FSM is what makes it behave like a scheduled accelerator.

## 5. Control Flow

The controller sequences the design through these phases:

1. `INIT`
2. `LOAD_W`
3. `LOAD_I`
4. `COMPUTE`
5. `WAIT_DONE`
6. `WRITEBACK`
7. `NEXT_TILE`

Meaning of each phase:

- `INIT`
  Entry or reset state.

- `LOAD_W`
  Stream a full 4x4 matrix into the selected load-side buffer.

- `LOAD_I`
  Stream a full 4-element activation vector into the input buffer.

- `COMPUTE`
  Present staged data to the array and run the active compute window.

- `WAIT_DONE`
  Hold system state while compute completion and background activity settle.

- `WRITEBACK`
  Transfer completed results into the output path.

- `NEXT_TILE`
  Advance to the next layer and flip the active / load-side buffer roles.

This explicit phase structure makes the project easy to debug in waveforms and easy to explain as a hardware system.

## 6. Internal Feedback Path

One of the most interesting parts of the design is the activation feedback path in `topModule/topModule.sv`.

The top-level logic:

- captures output values when a layer completes
- stores the low 8 bits of each output element in local feedback registers
- muxes those values into the input path
- uses controller state to determine when feedback should replace external activation input

That allows one layer's outputs to become the next layer's inputs without leaving the chip boundary.

Architecturally, this matters because it directly addresses data movement. In accelerator design, keeping frequently reused data local is often just as important as the arithmetic itself.

## 7. End-To-End Execution

A simplified inference flow looks like this:

1. Reset the design.
2. Load a 4x4 weight matrix into the selected weight buffer.
3. Load a 4-element activation vector into the input buffer.
4. Start compute.
5. Run the systolic array for the configured compute window.
6. Capture the resulting output vector.
7. If another layer remains:
   - store the output vector in feedback registers
   - switch the input path to feedback mode
   - switch weight-buffer roles
   - continue with the next layer
8. Present the final output vector on `out_data[0:3]` with `out_valid`.

## 8. Compute Interpretation

Because of the current accumulation direction in the array, the design behaves like:

```text
y = W^T * x
```

where:

- `x` is the activation vector
- `W` is the stored 4x4 weight matrix
- `y` is the output vector

That interpretation is important when checking expected outputs in simulation.

## 9. Example Layer Progression

The top-level testbench uses a three-layer example:

- layer 0: nontrivial 4x4 matrix
- layer 1: identity matrix
- layer 2: 2x identity

For an all-ones input vector:

```text
x = [1 1 1 1]^T
```

the expected progression is:

- layer 0 output: `[12, 16, 20, 24]`
- layer 1 output: `[12, 16, 20, 24]`
- layer 2 output: `[24, 32, 40, 48]`

This is useful because it shows both the base matrix-vector behavior and the layer-to-layer reuse path.

## 10. What This Architecture Demonstrates

Even at prototype scale, this architecture demonstrates several important hardware concepts in one coherent system:

- structured parallel compute
- explicit control-path and datapath separation
- staged input handling
- double-buffered memory use
- internal reuse of computed data
- valid/ready style output handling
- top-level verification that follows the architecture rather than ignoring it

That combination is what gives the project technical depth.

## 11. Current Scope

The architecture is intentionally compact and fixed-size.

That means:

- it is easy to simulate and inspect
- it clearly shows the intended dataflow
- it is well suited to iteration and debugging

It also means the project is currently a prototype architecture, not a parameterized or implementation-optimized accelerator IP block.
