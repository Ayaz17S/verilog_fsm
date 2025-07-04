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
- **Functionality**: Accepts ₹1 and ₹2 coins. Dispenses item when ₹5 is inserted.
- **Inputs**: clk, reset, coin
- **Outputs**: dispense
- **Waveform**:
  ![vending_machine_waveform](image-1.png)
