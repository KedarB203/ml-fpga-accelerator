# Design Choices

This document explains why the accelerator is structured the way it is. The goal is not just to describe what the RTL contains, but to make the reasoning behind the architecture clear.

## 1. Why Use A Systolic Array?

The project uses a 4x4 systolic array because systolic fabrics are a natural hardware structure for dense linear algebra.

That is a good fit for this project because a systolic array:

- exposes parallelism cleanly
- uses regular, repeated compute elements
- moves data locally between neighboring blocks
- maps well to matrix-vector and matrix-matrix style workloads

Using a systolic array makes the project about architecture rather than only arithmetic. It turns the repository into a small accelerator system instead of a flat collection of MAC units.

## 2. Why Use A Fixed 4x4 Array?

The 4x4 size is a deliberate prototype choice.

It is large enough to demonstrate:

- repeated PE structure
- nontrivial control logic
- multi-cycle compute behavior
- input and weight staging
- multi-layer sequencing

At the same time, it is small enough to:

- simulate quickly
- debug easily in waveforms
- keep expected outputs human-checkable
- keep the codebase compact and readable

That trade-off makes the project a good architecture prototype.

## 3. Why Separate Control And Datapath?

The design uses a dedicated `fsm_controller` rather than distributing sequencing logic across the datapath.

This is important because it:

- localizes state transitions
- makes the datapath easier to understand
- makes simulation debug easier
- gives the architecture a cleaner structure

In practical terms, this means the data path modules can focus on storage and compute, while the FSM handles when each stage should be active.

## 4. Why Buffer Activations?

External inputs arrive serially, one value at a time. The compute array, however, wants a structured 4-element activation vector.

The `input_buffer` exists to bridge that mismatch.

That is a good design choice because it:

- decouples the external stream from the compute fabric
- gives the controller a clear point of readiness (`input_load_done`)
- makes the compute side consume a clean parallel vector rather than a partially assembled stream

This is a small but important architectural decision. Many accelerator systems depend on this exact kind of staging.

## 5. Why Double-Buffer The Weights?

The design has two weight buffers and uses `bufSel` and `loadSel` to distinguish:

- the buffer currently active for compute
- the buffer currently being filled by the weight stream

This is one of the strongest design choices in the project.

Double buffering matters because it:

- separates active compute data from incoming replacement data
- creates a path toward overlapping communication and computation
- makes multi-layer execution more structured
- reflects a real optimization pattern used in accelerator design

Without double buffering, every new weight load would directly interfere with the currently active matrix.

## 6. Why Reuse Outputs Internally?

The top-level design captures outputs and feeds them back into the input path for later layers.

This choice is important because it keeps intermediate activations on chip.

That improves the architecture conceptually by:

- reducing dependence on external restreaming
- showing that the design is thinking about data reuse
- modeling how accelerators often reduce unnecessary data movement

This feedback path makes the project meaningfully more interesting than a single-layer matrix-vector engine.

## 7. Why Keep The External Interface Simple?

The top-level interface uses a small set of control signals:

- `weight_valid`
- `activation_valid`
- `in_ready`
- `out_valid`
- `out_ready`

This is a good choice at the current stage because it keeps attention on the architecture rather than on wrapper complexity.

The interface is simple enough to:

- drive directly from a simulation testbench
- reason about without a large protocol layer
- expose the main execution phases clearly

That simplicity helps the project stay focused.

## 8. Why Use 8-Bit Inputs And 32-Bit Outputs?

The project uses:

- 8-bit signed activations
- 8-bit signed weights
- 32-bit signed accumulation / output

This is a practical prototype configuration because:

- 8-bit inputs are common in quantized ML discussions
- narrow inputs keep storage and streams compact
- 32-bit outputs reduce overflow pressure during accumulation

This width selection gives the project a realistic feel without complicating the design unnecessarily.

## 9. Why Use A Fixed Compute Window?

The systolic array uses a fixed completion counter rather than dynamically inferring completion from deeper internal state.

That is a reasonable choice for a project at this stage because it:

- simplifies controller design
- makes timing easier to inspect in simulation
- matches the idea that wavefront compute has a known latency window

A fixed compute window is a clean way to make the system deterministic and explainable.

## 10. Why Keep The Output Stage Separate?

The output buffer exists as a separate stage after the array.

This is useful because it:

- captures final results at a clear boundary
- decouples compute completion from downstream consumption
- creates a place for output-stage logic such as biasing or activation behavior
- supports a valid/ready style interface

Even when the output stage is simple, this separation makes the overall architecture cleaner.

## 11. Why Use Directed Testbenches?

The repository includes:

- a MAC testbench
- a PE testbench
- a top-level system testbench

This layered verification structure is a good match for the architecture.

It allows the project to:

- validate leaf arithmetic in isolation
- validate PE behavior before full integration
- validate controller-plus-datapath behavior at top level

The top-level bench also uses small, understandable input cases, which makes failures much easier to diagnose.

## 12. Why Keep The Design Fixed-Function For Now?

The current project is fixed in several ways:

- fixed array size
- fixed vector length
- fixed layer count in the controller
- simulation-first workflow

Those are reasonable trade-offs for a prototype because they help the project emphasize architecture rather than configuration machinery.

A fixed-function prototype is often the right first step before parameterization or implementation tuning.

## 13. What The Current Design Prioritizes

The current architecture clearly prioritizes:

- structural clarity
- understandable dataflow
- local data reuse
- explicit sequencing
- simulation-based verification

It does not yet prioritize:

- broad configurability
- standardized bus integration
- post-synthesis timing closure
- implementation metrics

That scope is appropriate for the current stage of the project.

## 14. Summary Of The Core Decisions

The most important architectural choices in this repository are:

- using a systolic array instead of an unstructured datapath
- separating the controller from the compute path
- buffering activations before compute
- double-buffering weights
- reusing outputs internally between layers
- isolating the output stage behind a handshake
- validating the system with architecture-aware testbenches

Together, those choices make the project a coherent accelerator prototype rather than a collection of unrelated RTL files.
# Design Choices

This document explains why the accelerator is structured the way it is.

## 1. Why A Systolic Array?

The design uses a 4x4 systolic array because it is one of the most hardware-natural ways to map dense linear algebra into a regular compute fabric.

Why that is a strong choice:

- it exposes parallelism cleanly
- it keeps communication local between neighboring elements
- it creates a regular layout that scales better than ad hoc datapaths
- it reflects a widely used accelerator pattern in both research and industry

## 2. Why 4x4?

The 4x4 size is a deliberate prototype-scale choice.

It is large enough to demonstrate:

- PE replication
- nontrivial control
- staged buffers
- layer-to-layer sequencing
- multi-cycle completion

but still small enough to:

- simulate quickly
- debug in waveforms

That balance is smart engineering. A portfolio project does not need to be huge; it needs to show the right ideas clearly.

## 3. Why Separate Control And Datapath?

The design uses an explicit `fsm_controller` instead of embedding control inside each datapath module.

That is the right design choice because:

- it localizes sequencing complexity
- it makes the datapath easier to reason about and reuse
- it improves debuggability
- it mirrors how real accelerator blocks are often organized

This separation is one of the best signals of engineering maturity in the project. It means the design is architected, not just written.

## 4. Why Buffer Activations?

The input buffer converts a serial stream into a 4-element vector that the systolic array can consume in parallel.

This solves an important architectural problem:

- external interfaces often deliver one value per cycle
- compute arrays often want a staged, structured view of data

The input buffer acts as the bridge between those worlds.


## 5. Why Double-Buffered Weights?

The design instantiates two weight buffers and uses `bufSel` and `loadSel` to distinguish:

- which buffer is being read for compute
- which buffer is being written with future weights

This is one of the strongest design choices in the repository.

Why it matters:

- it reduces the coupling between weight loading and active compute
- it opens the door to overlapping communication and computation
- it reflects a real hardware optimization pattern
- it demonstrates throughput-oriented thinking

A recruiter may not care about the exact signal names, but they will care that the project includes a genuine architectural optimization rather than a purely functional implementation.

## 6. Why Internal Feedback Between Layers?

The top-level design captures output vectors and can feed them back into the input path for later layers.

This is important because it addresses a major accelerator concern: data movement.

Instead of forcing software or a testbench to restream every intermediate activation vector, the design keeps that data on chip and reuses it.

That is exactly the kind of idea that makes accelerator projects compelling:

- it shows systems thinking
- it reduces unnecessary I/O
- it aligns with how real inference pipelines try to maximize reuse

Even at prototype scale, this is a meaningful architectural decision.

## 7. Why 8-Bit Inputs And 32-Bit Accumulation?

The project uses:

- 8-bit signed activations
- 8-bit signed weights
- 32-bit accumulated outputs

This is a sensible trade-off for a prototype because:

- 8-bit inputs are common in quantized inference discussions
- narrow inputs keep storage and stream widths small
- wider accumulation prevents obvious overflow during repeated MAC operations

## 8. Why A Fixed Compute Window?

The array uses a fixed completion counter instead of trying to infer done combinationally from deep datapath state.

Why that is reasonable in a prototype:

- it simplifies control
- it makes simulation easier to debug
- it captures the idea that wavefront-style compute has a known latency window

This is a classic hardware trade-off: use explicit timing knowledge to simplify logic.

## 9. Why A Handshaked Output Stage?

The output buffer decouples result production from result consumption with `out_valid` and `out_ready`.

This is a good choice because:

- it creates a clean boundary between compute and downstream logic
- it makes the system more composable
- it avoids assuming the consumer is always ready on the same cycle compute finishes

Even in a small project, including a valid/ready boundary makes the design feel much closer to production-quality hardware.

## 10. Why Directed Testbenches?

The repository includes unit-level and top-level testbenches.

That is the right verification strategy for a project at this stage because:

- it validates leaf arithmetic first
- it validates a single PE separately from the full array
- it validates controller-plus-datapath interaction at top level
- it makes debug much faster than starting with only a large integration bench

The top-level bench also uses meaningful, human-checkable examples like:

- all ones
- all twos
- all zeros
- a mixed vector
- reset recovery

This is strong engineering practice because it creates understandable checkpoints for debugging.

## 11. What Trade-Offs Does The Current Design Make?

The design is optimized for architectural clarity and proof of concept, not yet for full production polish.

Examples of deliberate trade-offs:

- fixed 4x4 size instead of parameterization
- simulation-first validation instead of immediate synthesis reporting
- simple buffering instead of a standardized bus protocol wrapper
- explicit layer count in the controller instead of a fully programmable schedule

These are reasonable trade-offs for a prototype. They make the system easier to finish, explain, and iterate on.
