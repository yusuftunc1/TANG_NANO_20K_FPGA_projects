📟 UART RX (VHDL)
---
  This project implements a UART Receiver (RX) in VHDL together with a self-written testbench.  
  The design is verified via RTL simulation using **GHDL** and waveform inspection with **GTKWave**.  
  
🔧 Features
---
The UART RX module receives serial data and reconstructs it into 8-bit parallel output using a standard UART frame format:  
- 1 Start bit (logic 0)
- 8 Data bits (LSB first)
- Configurable Stop bits (1 or 2)

The implementation is clock-driven and parameterized via generics for easy reuse.  

🧠 Internal Architecture
---
The design is based on a Finite State Machine (FSM) with the following states:  
- S_IDLE – Line idle, waiting for start bit
- S_START – Start bit validation at mid-bit sample
- S_DATA – Data bits reception (LSB first)
- S_STOP – Stop bit timing and frame completion

A bit timer derived from the system clock ensures accurate baud-rate sampling.  
The received bits are shifted into an internal shift register and transferred to the output when the frame is complete.  

🧪 Testbench & Verification
---
A dedicated VHDL testbench (tb_uart_rx.vhd) is provided to verify correct functionality.  
The testbench generates a clock and transmits predefined UART frames to the receiver.

Two bytes are transmitted during simulation:
- 0x43
- 0xA5  

### Simulation Flow (GHDL)
1. Compile the design and testbench:  
    ```bash
    ghdl --clean
    ghdl -a uart_rx.vhd
    ghdl -a tb_uart_rx.vhd
    ghdl -e tb_uart_rx
2. Run the simulation and generate waveform data:
   ```bash
    ghdl -r tb_uart_rx --vcd=uart_rx.vcd

3. View waveforms using GTKWave:
    ```bash
   gtkwave uart_rx.vcd
  
The simulation ends with an intentional assertion message (SIM DONE), indicating successful completion.   

📷 Demo
---

<img width="1308" height="163" alt="uart_rx" src="https://github.com/user-attachments/assets/1402a768-2df2-4d90-a1d2-615348a15f7b" />

🛠️ Tools Used
---
- VHDL (RTL design)
- GHDL – VHDL simulator
- GTKWave – Waveform viewer

📌 Notes
---
- UART RX input: Pin 70 of the FPGA
- The design is vendor-agnostic and can be synthesized for different FPGA platforms.
- Simulation is performed outside the vendor toolchain due to educational license limitations.
- The project focuses on clarity and learning-oriented structure.
