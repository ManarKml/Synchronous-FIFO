# Synchronous FIFO Verification Project

## Overview
This project implements and verifies a **Synchronous FIFO (First-In First-Out)** design using **SystemVerilog**. The verification environment includes a **testbench, monitor, scoreboard, coverage model, and assertions** to ensure full functional correctness.

### Objectives
- Ensure correct FIFO functionality  
- Achieve 100% functional, code, and assertion coverage  
- Apply constrained random verification techniques  

---

## Parameters

| Parameter     | Description                          | Default |
|--------------|--------------------------------------|---------|
| FIFO_WIDTH   | Data width (input/output & memory)   | 16      |
| FIFO_DEPTH   | FIFO memory depth                    | 8       |

---

## Ports Description

### Inputs

| Port     | Description |
|----------|------------|
| data_in  | Input data bus used for writing into FIFO |
| wr_en    | Write enable (writes if FIFO not full) |
| rd_en    | Read enable (reads if FIFO not empty) |
| clk      | Clock signal |
| rst_n    | Active-low asynchronous reset |

### Outputs

| Port          | Description |
|---------------|------------|
| data_out      | Output data bus for read operations |
| full          | FIFO is full (writes ignored) |
| almostfull    | One slot left before full |
| empty         | FIFO is empty (reads ignored) |
| almostempty   | One read left before empty |
| overflow      | Write attempted when FIFO is full |
| underflow     | Read attempted when FIFO is empty |
| wr_ack        | Write operation successful |

---

## Testbench Architecture

### Components

- **Top Module**
  - Generates clock
  - Instantiates DUT, interface, testbench, and monitor

- **Interface**
  - Connects DUT with verification components

- **Testbench (TB)**
  - Applies reset
  - Generates randomized inputs
  - Signals test completion (`test_finished`)

- **Monitor**
  - Samples interface signals
  - Sends transactions to:
    - Coverage model
    - Scoreboard

- **Shared Package (`shared_pkg`)**
  - Contains:
    - `test_finished`
    - `error_count`
    - `correct_count`

---

## Verification Components

### 1. FIFO Transaction Class
- Stores all FIFO inputs and outputs  
- Includes configurable distributions:
  - `WR_EN_ON_DIST` (default: 70%)
  - `RD_EN_ON_DIST` (default: 30%)

#### Constraints
- Reset occurs less frequently  
- Write enable distribution control  
- Read enable distribution control  

---

### 2. Functional Coverage (`FIFO_coverage`)

- Cross coverage between:
  - `wr_en`
  - `rd_en`
  - FIFO control outputs (excluding `data_out`)

- Ensures all FIFO states are exercised  
- Uses `sample_data()` method for sampling  

---

### 3. Scoreboard (`FIFO_scoreboard`)

- Implements a reference (golden) model  
- Compares DUT outputs with expected outputs  
- Updates:
  - `correct_count`
  - `error_count`  
- Displays mismatch messages  

---

## Assertions (Design-Level Verification)

Assertions are added inside the RTL to verify:

### Checks
- Reset behavior (pointers & counters reset)
- Write acknowledge correctness
- Overflow detection
- Underflow detection
- Empty flag correctness
- Full flag correctness
- Almost full condition
- Almost empty condition
- Pointer wraparound
- Pointer and counter limits
