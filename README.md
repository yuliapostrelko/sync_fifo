# Synchronous FIFO in Verilog

A parameterized, synthesizable **Synchronous FIFO (First-In, First-Out)** buffer implemented in Verilog HDL, complete with a verification testbench, block diagram, and simulation waveforms.

This project demonstrates core digital design concepts including synchronous sequential logic, pointer wrap-around management, occupancy tracking, and zero-latency status flag generation.

---

## Key Features
* **Fully Parameterized:** Configurable `DATA_WIDTH` (default: 8-bit) and `DEPTH` (default: 16 entries) using `$clog2(DEPTH)` for automatic address width calculation.
* **Single Clock Domain:** All write, read, and pointer operations are synchronized to the rising edge of `clk` with an active-low asynchronous reset (`rst_n`).
* **Combinational Status Flags:** `full` and `empty` flags are driven combinationally from the occupancy counter (`count`) to prevent single-cycle flag latency and protect against overflow/underflow.
* **Simultaneous Read/Write Support:** Safely handles concurrent `wr_en` and `rd_en` assertions within the same clock cycle without corrupting the occupancy count.
* **BRAM-Friendly Memory Modeling:** The internal memory array (`fifo_mem`) is intentionally excluded from the reset block to allow synthesis tools to infer Block RAM (BRAM) rather than distributed flip-flops.

---

## Architecture & Block Diagram

![Block Diagram](docs/block_diagram.png)

### How It Works
1. **Memory Array (`fifo_mem`):** A `DEPTH x DATA_WIDTH` register array indexed by independent write (`wr_ptr`) and read (`rd_ptr`) pointers.
2. **Pointer Management:** 
   * On `wr_en && !full`, incoming data (`din`) is written to `fifo_mem[wr_ptr]` and `wr_ptr` increments (wrapping around naturally at `DEPTH`).
   * On `rd_en && !empty`, stored data is read onto `dout` from `fifo_mem[rd_ptr]` and `rd_ptr` increments.
3. **Full vs. Empty Distinction:** An internal occupancy counter (`count [ADDR_WIDTH:0]`) tracks the exact number of stored words:
   * `empty = (count == 0)`
   * `full  = (count == DEPTH)`

---

## Module Interface (`sync_fifo`)

| Port | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | System clock (rising-edge triggered) |
| `rst_n` | Input | 1 | Active-low asynchronous reset |
| `wr_en` | Input | 1 | Write enable request |
| `rd_en` | Input | 1 | Read enable request |
| `din` | Input | `DATA_WIDTH` | Input data bus |
| `dout` | Output | `DATA_WIDTH` | Output data bus |
| `full` | Output | 1 | High (`1`) when FIFO reaches `DEPTH` |
| `empty` | Output | 1 | High (`1`) when FIFO contains `0` entries |

---

## Repository Structure

```text
Synchronous-FIFO-Verilog/
├── rtl/
│   └── sync_fifo.v         # Synthesizable RTL design
├── tb/
│   └── sync_fifo_tb.v      # Simulation testbench
├── docs/
│   ├── block_diagram.png   # RTL architecture diagram
│   └── waveforms.png       # Simulation waveform capture
└── README.md               # Project documentation