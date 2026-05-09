# ML FPGA Accelerator RTL

This repository contains the current RTL for a small FPGA-oriented ML compute prototype built around a `4x4` systolic array. The design is written in SystemVerilog and currently includes:

- a top-level integration module
- activation and weight buffers
- a control FSM
- PE and MAC compute blocks
- basic unit testbenches

The project is still work in progress. The core pieces are present, but the output path, top-level verification flow, and some control sequencing are not finished yet.

## Current Architecture


activation_in + in_valid --> input_buffer ----\
                                               \
weight_in ----------------> weight_buffer ------> systolic_array --> out_data[0:3], out_valid
                                                   ^
                                                   |
                                             fsm_controller
```

At a high level:

- `input_buffer` stores incoming activations and feeds 4 values at a time into the array.
- `weight_buffer` stores incoming weights and feeds 4 values at a time into the array.
- `systolic_array` instantiates a `4x4` grid of processing elements.
- `fsm_controller` drives the load/read/compute control signals.
- `topModule` wires everything together and currently exposes the array output directly.

## Repository Layout

```text
.
|-- compute/
|   |-- mac.sv
|   |-- pe.sv
|   `-- systolic_array.sv
|-- memory/
|   |-- input_buffer.sv
|   |-- output_buffer.sv
|   `-- weight_buffer.sv
|-- tests/
|   |-- mac_tb.sv
|   |-- pe_tb.sv
|   `-- toplevel_tb.sv
|-- fsm_controller.sv
`-- topModule/
    `-- topModule.sv
```

## Module Summary

### Top Level

- `topModule/topModule.sv`
  - Integrates the controller, buffers, and systolic array.
  - Accepts `activation_in`, `weight_in`, and `in_valid`.
  - Exposes `out_data[0:3]` as four parallel `32-bit` outputs.
  - Generates `out_valid` from the array's `done` pulse.
  - Includes `out_ready` in the interface, but it is not used yet.

### Control

- `fsm_controller.sv`
  - Defines the states:
    - `init`
    - `loadW`
    - `loadI`
    - `compute`
    - `writeBack`
    - `nextTile`
  - Currently drives:
    - `load_input`
    - `load_weight`
    - `start_compute`
    - `input_read_en`
    - `weight_read_en`
  - The intended control flow is present, but completion handling is not fully implemented yet.

### Compute

- `compute/mac.sv`
  - Signed `8-bit x 8-bit` multiply with `32-bit` accumulation.
  - Forms the arithmetic core used by each PE.

- `compute/pe.sv`
  - A single processing element.
  - Latches a weight into `w_reg` when `w_load` is asserted.
  - Forwards activation data and produces accumulated output.

- `compute/systolic_array.sv`
  - Instantiates a `4x4` grid of `pe` modules.
  - Accepts 4 activation lanes and 4 weight lanes.
  - Exposes 4 result lanes (`32-bit` each).
  - Uses `TOTAL_CYCLES = 4` and raises `done` when the compute window finishes.

### Memory

- `memory/input_buffer.sv`
  - `16 x 8-bit` activation storage.
  - Supports `in_valid` / `in_ready` style loading.
  - Outputs 4 entries per read into the systolic array.

- `memory/weight_buffer.sv`
  - `16 x 8-bit` weight storage.
  - Outputs 4 entries per read into the systolic array.
  - Simpler than `input_buffer`; it does not currently implement a matching valid/ready handshake.

- `memory/output_buffer.sv`
  - Declared, but not implemented yet.

## Data Widths and Shape

- Activation input width: `8 bits`
- Weight input width: `8 bits`
- MAC accumulation width: `32 bits`
- Output lanes: `4`
- Array size: `4x4` PEs
- Input/weight buffer depth: `16` entries each

## Verification Status

The repository includes early unit testbenches, but it does not yet include a polished, checked-in simulation flow.

- `tests/mac_tb.sv`
  - Basic MAC-level stimulus exists.
  - The bench is useful as a starting point, but it does not currently line up cleanly with the pipelined MAC timing under `iverilog`.

- `tests/pe_tb.sv`
  - Basic PE-level stimulus exists.
  - As written, it uses whole-array assignments in the testbench, which `iverilog` does not elaborate cleanly.

- `tests/toplevel_tb.sv`
  - Currently empty.

There is no checked-in `Makefile`, simulator script, or automated regression setup yet.

## Current Limitations / Work In Progress

- `output_buffer` is only a stub.
- `out_ready` is exposed by `topModule` but not used in the current data path.
- `fsm_controller` defines `writeBack` and `nextTile`, but the active flow does not fully transition through them yet.
- The `done` signal is wired into the controller interface, but compute completion is not fully used to advance the FSM.
- Top-level verification is not implemented yet.
- The activation and weight input paths are not symmetric; `input_buffer` has handshake support, while `weight_buffer` is more basic.
- No project-level simulation or synthesis scripts are included yet.

## What You Have So Far

In practical terms, this repo already gives you:

- a first-pass top-level RTL integration
- a reusable `mac` block
- a reusable `pe` block
- a `4x4` systolic array skeleton
- simple activation and weight buffering
- an initial control FSM
- starter testbenches for unit-level verification


## Good Next Steps

The most impactful next steps would be:

1. Finish the FSM transition logic around `done`, `writeBack`, and `nextTile`.
2. Implement `output_buffer` and connect `out_ready`.
3. Add a real `toplevel_tb.sv`.
4. Clean up the unit testbenches so they run cleanly with a chosen simulator.
5. Add a simple simulation flow (`Makefile` or script) for repeatable testing.
