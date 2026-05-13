# Performance

This document summarizes the performance-relevant characteristics that can be discussed from the current RTL and simulation setup. It intentionally stays within what the repository actually shows today.

## 1. What Can Be Said Today

From the current codebase, the project clearly demonstrates:

- fixed-size parallel compute with a 4x4 systolic array
- multi-cycle execution controlled by an FSM
- local staging of activations and weights
- double-buffered weight storage
- valid/ready style output handling
- internal reuse of layer outputs

These are all performance-relevant architectural properties, even without synthesis or FPGA timing reports.

## 2. Raw Architectural Capacity

The compute fabric is a 4x4 systolic array, which means the design contains 16 processing elements operating in a regular structure.

At a high level, that gives the architecture:

- 16 concurrent PE instances
- local data movement across the array
- structured accumulation rather than a single sequential MAC pipeline

That does not automatically translate into a measured throughput claim, but it does establish that the project is exploring parallel hardware execution rather than purely serial computation.

## 3. Data Widths And Their Implications

Current widths:

- activations: 8-bit signed
- weights: 8-bit signed
- outputs / accumulation: 32-bit signed

Implications:

- 8-bit streams keep storage and I/O relatively compact
- 32-bit outputs give headroom for accumulation
- the project is aligned with the idea of quantized inference, even though it is not yet presented as a full quantization framework

## 4. Layer Work Per Inference

At the current project scale, one layer involves:

- loading 16 weight values into a weight buffer
- loading 4 activation values into the input buffer
- running the systolic array for a fixed compute window
- latching the 4 output values

From the current RTL:

- weight matrix load size: 16 cycles of valid weight input
- activation vector load size: 4 cycles of valid activation input
- compute window inside `systolic_array`: 4 cycles

These figures come directly from the current architecture and are useful for reasoning about latency composition, even though the exact end-to-end total also depends on controller sequencing and output handshake timing.

## 5. Why Double Buffering Matters For Performance

The use of two weight buffers is the most obviously performance-oriented structural choice in the design.

It creates the architectural possibility of:

- keeping one matrix active for compute
- preparing another matrix separately
- reducing direct interference between data movement and active execution

That is important because accelerator performance is often constrained as much by data delivery as by arithmetic itself.

Even in a small prototype, this design choice points in the right direction.

## 6. Why Internal Feedback Matters For Performance

The feedback path allows one layer's outputs to become the next layer's inputs without requiring those intermediate values to leave the chip boundary and come back as new external activations.

That matters because it:

- reduces unnecessary I/O
- keeps frequently reused data local
- makes multi-layer execution more accelerator-like

From a performance point of view, this is a meaningful architectural optimization concept, even before any measured implementation numbers are available.

## 7. Output Handshake And Backpressure

The output path uses a valid/ready style boundary.

This means:

- results can be held until the consumer is ready
- compute completion and result consumption are not forced to happen on the same cycle

That is good system design, but it also means the final observed throughput depends partly on downstream behavior. If `out_ready` is delayed, the visible output rate can be lower than the raw compute core's internal completion cadence.

## 8. What The Current Performance Discussion Should Avoid

The repository does **not** currently provide:

- post-synthesis clock frequency
- FPGA resource utilization
- ASIC area estimates
- measured power
- measured throughput on hardware
- timing-closure results

Because of that, the project should not claim:

- a peak TOPS figure
- FPGA-specific operating frequency
- implementation-ready throughput numbers
- silicon-class efficiency metrics

Those numbers would only be credible after synthesis, implementation, and measurement.

## 9. What Can Be Claimed Honestly

The current project can honestly claim:

- it implements a parallel 4x4 systolic compute fabric
- it stages weights and activations locally
- it uses double-buffered weights to organize data reuse
- it supports a three-layer scheduled flow
- it includes on-chip reuse of intermediate activations
- it has a top-level testbench that exercises the architecture end to end

These are architectural performance properties, even if they are not yet benchmark-style results.

## 10. Current Bottlenecks And Constraints

From the current RTL structure, the main constraints are:

- fixed array size
- fixed layer count in the controller
- stream-based input loading rather than a wider bulk interface
- simulation-focused validation rather than implementation-driven tuning

These are appropriate trade-offs for the current stage of the project, but they also explain why the repository is best described as a prototype rather than a fully optimized accelerator.

## 11. What Would Strengthen The Performance Story

The strongest next additions would be:

- synthesis results with target frequency
- FPGA utilization numbers
- measured end-to-end latency per layer and per inference
- measured cycles-per-inference across several workloads
- a software model to compare functional correctness and timing behavior
- a short table summarizing load cycles, compute cycles, and output latency

Those additions would turn the current architectural performance story into a measured implementation performance story.

## 12. Summary

The current repository already shows several performance-oriented design instincts:

- parallel structured compute
- local buffering
- weight double buffering
- internal reuse of intermediate activations
- explicit separation of compute and output consumption

What it does not yet show is finalized implementation data. That distinction is important, and keeping it explicit makes the project easier to trust and easier to discuss accurately.
