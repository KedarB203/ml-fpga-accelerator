# Documentation

This folder contains supporting documentation for the RTL neural network accelerator. The files here expand on the main repository `README.md` and focus on the design itself: the architecture, the reasoning behind the structure, and the performance characteristics that can be discussed from the current RTL and simulation setup.

## Files

- `architecture.md`
  Detailed explanation of the accelerator structure, control flow, buffering strategy, systolic array organization, and multi-layer feedback path.

- `design_choices.md`
  Rationale behind the main architectural decisions, including why the project uses a systolic array, why weights are double-buffered, why activations are buffered, and why the controller is separated from the datapath.

- `performance.md`
  Honest discussion of what can currently be said about latency, parallelism, data movement, and output behavior from the existing RTL.

- `README.md`
  This file.

## Suggested Reading Order

1. Start with the repository `README.md` for the main project overview.
2. Read `architecture.md` for the detailed block-level explanation.
3. Read `design_choices.md` for the reasoning behind the structure.
4. Read `performance.md` for the current performance picture and limitations.

## Scope Of These Docs

These files are written to explain the project clearly without assuming prior familiarity with the codebase. They are intended to help a reader understand:

- what the accelerator is trying to do
- how data moves through it
- why the project is structured this way
- what the current implementation proves today
- what would naturally come next

## Related Source Files

- Top-level integration: `topModule/topModule.sv`
- Controller: `control/fsm_controller.sv`
- Compute fabric: `compute/systolic_array.sv`, `compute/pe.sv`, `compute/mac.sv`
- Memory path: `memory/input_buffer.sv`, `memory/weight_buffer.sv`, `memory/output_buffer.sv`
- Verification: `tests/toplevel_tb.sv`, `tests/pe_tb.sv`, `tests/mac_tb.sv`
- Build flow: `Makefile`

## Running The Project

Run the integrated simulation:

```bash
make sim
```

Clean generated artifacts:

```bash
make clean
```

The top-level simulation writes a waveform dump that can be inspected to follow controller state transitions, buffer activity, and systolic-array timing.
