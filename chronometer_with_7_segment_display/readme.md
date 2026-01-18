📟 Chronometer (Tang Nano – VHDL)
---
  This project implements a simple chronometer (stopwatch) design for the Tang Nano 20K FPGA board using VHDL.  
  The chronometer supports start/stop and reset functionality and displays elapsed seconds on two 7-segment displays.

🔧 Features
---
- Start / Stop controlled chronometer
- Reset button support
- Seconds counting based on 27 MHz onboard clock
- Two 7-segment display outputs (ones and tens of seconds)
- Modular design using BCD incrementor and 7-segment decoder

📷 Demo
---
  [▶ Watch Demo Video](https://github.com/user-attachments/assets/c5c4d1e0-bd91-4580-82f2-3e00c215ccd4)

🛠️ Tools Used
---
- VHDL
- Gowin EDA
- Tang Nano FPGA

📌 Notes
---
- Default clock frequency: 27 MHz (onboard oscillator)
- Clock input should be routed via a Global Clock (GCLK) pin
- Start/Stop button toggles the running state
