# Radix-16 Booth Multiplier – VHDL

A VHDL implementation of a **signed integer multiplier based on the Radix-16 Booth algorithm**.

The RTL architecture separates the design into a dedicated **Control Unit (FSM)** and **Operational Unit (Datapath)** and includes a self-checking testbench for functional verification.

## Project Overview

The multiplier accepts two signed N-bit operands and produces a signed 2N-bit product.

Radix-16 Booth recoding reduces the number of multiplication iterations by processing multiple multiplier bits during each computation step.

The design follows a classic **Controller + Datapath** architecture.

## Hardware Architecture

### Top-Level Entity

`top.vhd`

The top-level module integrates the Control Unit and Operational Unit and exposes the external interface of the multiplier.

The interface includes:

- Input operands
- Start control
- Done indication
- Product output

The operand width is defined using a generic parameter, allowing the multiplier width to be configured.

### Control Unit

`cu.vhd`

The Control Unit is implemented as a Finite State Machine (FSM) that coordinates the multiplication sequence.

The FSM contains four main states:

- `IDLE`
- `LOAD`
- `SHIFT`
- `DONE`

The controller manages operand loading, datapath operation, computation sequencing, and completion signaling.

### Operational Unit

`ou.vhd`

The Operational Unit contains the arithmetic datapath used to perform the Booth multiplication.

Its responsibilities include:

- Operand storage
- Booth recoding
- Partial-product generation
- Shift operations
- Partial-product accumulation
- Final product generation

## Design Architecture

The RTL structure follows the architecture:

**Input Operands**
→ **Control / Load**
→ **Booth Recoding**
→ **Partial Product Generation**
→ **Shift & Accumulate**
→ **Final Product**

The Control Unit determines when each datapath operation is executed.

## Verification

The project includes a self-checking testbench:

`top_tb.vhd`

The testbench automatically applies multiplication test cases and compares the RTL output with the expected mathematical result.

### Test Scenarios

The verification includes cases such as:

- Positive × Positive
- Negative × Positive
- Positive × Negative
- Negative × Negative
- Multiplication by zero

### Self-Checking Testbench

Assertions are used to automatically detect incorrect multiplication results.

Instead of relying only on manual waveform inspection, the testbench compares the hardware result against the expected product and reports mismatches during simulation.

## Project Structure

- `top.vhd` – Top-level multiplier entity
- `cu.vhd` – FSM-based Control Unit
- `ou.vhd` – Operational Unit and Booth arithmetic datapath
- `top_tb.vhd` – Self-checking VHDL testbench
- `VHDL-Radix16-Booth-Multiplier.pdf` – Project documentation including architecture, FSM, synthesis, and simulation results
- `README.md` – Project overview and documentation

## Tools & Technologies

- VHDL
- RTL Design
- Finite State Machines
- Datapath / Controller Architecture
- Booth Multiplication
- Signed Arithmetic
- Self-Checking Testbenches
- ModelSim

## Engineering Topics

This project provided hands-on experience with:

- RTL architecture design
- Arithmetic hardware implementation
- Signed binary arithmetic
- Booth recoding
- Datapath design
- FSM-based control
- Controller/datapath separation
- Parameterized VHDL design
- Hardware verification
- Self-checking testbenches
- Assertion-based functional checking
- Simulation and waveform analysis

## Verification Approach

The design was verified at the RTL level using simulation.

The self-checking testbench provides automated PASS/FAIL behavior by comparing the multiplier output against the expected mathematical result for each test case.

Additional signal-level behavior can be inspected through simulation waveforms.

## Project Documentation

Detailed design documentation, including architecture descriptions, FSM diagrams, RTL/synthesis views, and simulation results, is available in:

`VHDL-Radix16-Booth-Multiplier.pdf`
