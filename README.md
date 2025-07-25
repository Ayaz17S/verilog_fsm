# Verilog FSM Projects 🚦🔁

A collection of **Finite State Machine (FSM)** based projects written in **Verilog**, complete with testbenches and waveform simulations using **Icarus Verilog** and **GTKWave**.

These projects demonstrate real-world control logic designs implemented using **Moore** and **Mealy** FSM models.

---

## 🛠️ Tools Used

- **Verilog (RTL)**
- **Icarus Verilog (iverilog)**
- **GTKWave** (for waveform viewing)
- **VS Code + Verilog HDL Extension**

---

## 📂 Projects

### 1. 🔁 Sequence Detector (1011)

- **Model**: Mealy
- **Functionality**: Detects 1011 in a serial stream (overlapping allowed).
- **Inputs**: clk, reset, in
- **Output**: detected (high when sequence found)
- **Waveform**: ![waveform sequence detector](image.png)

---

### 2. 🚦 Traffic Light Controller

- **Model**: Moore
- **Functionality**: Cycles through Red → Green → Yellow with programmable timing.
- **Inputs**: clk, reset
- **Outputs**: red, yellow, green
- **Waveform**:
  ![traffic_light_waveform](Screenshot 2025-07-03 185250.png)

---

### 3. Vending Machine FSM

- **Model**: Moore
- **Functionality**: Accepts ₹5 and ₹10 coins. Dispenses item when ₹15 is inserted.
- **Inputs**: clk, reset, coin
- **Outputs**: dispense
- **Waveform**:
  ![vending_machine_waveform](image-1.png)

### 4. 🔤 UART Transmitter + Receiver (FSM-based)

- **Model**: FSM (Moore + Mealy mix)
- **Functionality**: Simulates UART communication protocol with TX and RX FSMs.
- **Modules**:
  - `baud_generator.v`: Generates baud rate tick based on system clock.
  - `uart_tx.v`: Serializes data for transmission (FSM-based).
  - `uart_rx.v`: Deserializes incoming bits and reconstructs bytes.
  - `uart_top.v`: Connects TX and RX via internal wire.
  - `uart_tb.v`: Testbench to simulate full transmit-receive cycle.
- **Tested Data**: 8-bit input `0xAA` (10101010) sent from TX and received by RX.
- **Waveform**:
  ![uart_waveform](image-2.png)
- **Outcome**: Reliable bit-by-bit UART simulation with matching RX output.

### 5. 🧠 RAM with Read/Write Control (FSM-ready)

- **Model**: Procedural (FSM integration planned)
- **Functionality**: Implements an 8-bit, 1KB RAM with read and write capabilities via tri-state data bus.
- **Inputs**: `clk`, `rd`, `wr`, `cs`, `addr[9:0]`
- **Inout**: `data[7:0]`
- **Features**:
  - Synchronous read/write operations
  - Uses bidirectional data bus logic (`inout`)
  - Read/Write verified with testbench
- **Waveform**:  
  ![ram_waveform](image-3.png)
- **Outcome**: Basic RAM module working with read/write logic. Will be extended with FSM controller next.

---

### 6. 📥 FIFO Buffer with FSM Control

- **Model**: FSM (Moore)
- **Functionality**: Implements an 8-entry FIFO (First-In First-Out) queue with controlled read/write operations via FSM.
- **Inputs**:
  - `clk`, `reset`
  - `wr_en` (write enable)
  - `rd_en` (read enable)
  - `data_in [7:0]`
- **Outputs**:
  - `data_out [7:0]`
  - `full`, `empty`
- **Internal Structure**:
  - `mem [7:0]` → FIFO buffer (8 elements of 8-bit width)
  - `write_ptr`, `read_ptr`, and `count` for pointer control
  - FSM states: `IDLE`, `WRITE`, `READ`
- **Waveform**:
  ![fifo_waveform](image-4.png)
- **Outcome**: Verified FIFO functionality with proper `data_in` → `data_out` flow, preserving order. Handles full and empty states correctly.
