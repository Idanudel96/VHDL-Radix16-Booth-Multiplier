# Radix-16 Booth Multiplier (VHDL) 

## Overview
A hardware description logic (RTL) implementation of a signed integer multiplier based on the Radix-16 Booth algorithm. The system is designed to efficiently multiply two N-bit signed integers, producing a 2N-bit product. By utilizing Radix-16, the architecture significantly reduces the number of required shift-and-add iterations, optimizing computational speed.

## Hardware Architecture
The design follows a classic Datapath and Controller separation:
* **Top Level (`top.vhd`):** Integrates the Control Unit and Operational Unit, exposing a clean interface (Start, Done, A, B, P) with a generic N-bit width (default 8-bit).
* **Control Unit (`cu.vhd`):** A Finite State Machine (FSM) with four states (`IDLE`, `LOAD`, `SHIFT`, `DONE`) that orchestrates the data flow, load timing, and computation cycles.
* **Operational Unit (`ou.vhd`):** The datapath responsible for the arithmetic. It uses a 5-bit sliding window to determine the Booth digit (ranging from -16 to +15), calculates the partial products, and accumulates the shifted results.

## Validation & Simulation
The project includes a robust, self-checking testbench (`top_tb.vhd`) designed to verify corner cases and general functionality.
* **Test Cases:** Evaluates positive × positive, negative × positive, negative × negative, and multiplication by zero.
* **Automated Assertions:** The testbench automatically compares the RTL output against the expected mathematical product, pausing execution and reporting errors if a mismatch occurs.
* **Simulation:** Verified using standard VHDL simulation tools (e.g., ModelSim), yielding complete signal waveforms and asserting `All multiplication tests passed`.

## Project Structure
* `src/top.vhd` - Top-level wrapper.
* `src/cu.vhd` - FSM Control Unit.
* `src/ou.vhd` - Datapath and Booth logic.
* `sim/top_tb.vhd` - Self-checking testbench.
* `Project Summary.pdf` - Complete documentation including RTL synthesis schematics, FSM state diagrams, and simulation waveforms.
