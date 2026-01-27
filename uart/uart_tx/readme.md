📟 UART TX (VHDL)
---
  This project implements a UART Transmitter (TX) in VHDL together with a self-written testbench.   
  The design is verified via RTL simulation using **GHDL** and waveform inspection with **GTKWave**.  
  
🔧 Features
---
The UART TX module serializes 8-bit parallel data and transmits it using a standard UART frame format:  
- 1 Start bit (logic 0)
- 8 Data bits (LSB first)
- Configurable Stop bits (1 or 2)

The implementation is clock-driven and parameterized via generics for easy reuse.  

🧠 Internal Architecture
---
The design is based on a Finite State Machine (FSM) with the following states:  
- S_IDLE – Line idle, waiting for tx_start_i
- S_START – Start bit transmission
- S_DATA – Data bits transmission (LSB first)
- S_STOP – Stop bit(s) transmission
A bit timer derived from the system clock ensures accurate baud timing.  

🧪 Testbench & Verification
---
A dedicated VHDL testbench (tb_uart_tx.vhd) is provided to verify correct functionality.    

### Simulation Flow (GHDL)
1. Compile the design and testbench:  
    ```bash
    ghdl --clean
    ghdl -a uart_tx.vhd
    ghdl -a tb_uart_tx.vhd
    ghdl -e tb_uart_tx
2. Run the simulation and generate waveform data:
   ```bash
    ghdl -r tb_uart_tx --vcd=uart.vcd

3. View waveforms using GTKWave:
    ```bash
   gtkwave uart.vcd
  
The simulation ends with an intentional assertion message (SIM DONE), indicating successful completion.   

📷 Demo
---
  <img width="1717" height="222" alt="uart_tx" src="https://github.com/user-attachments/assets/32336e85-d4b4-4fca-bb23-c4cd43e71389" />

🛠️ Tools Used
---
- VHDL (RTL design)
- GHDL – VHDL simulator
- GTKWave – Waveform viewer

📌 Notes
---
- The design is vendor-agnostic and can be synthesized for different FPGA platforms.
- Simulation is performed outside the vendor toolchain due to educational license limitations.
- The project focuses on clarity and learning-oriented structure.
