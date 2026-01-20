📟 WS2812 LED Driver (VHDL – FPGA)
---
This project implements a WS2812 (NeoPixel) LED driver using VHDL, designed to run on an FPGA with a fixed system clock.  
The driver generates the strict timing required by the WS2812 one-wire protocol using a finite state machine (FSM) and cycle-accurate counters.

The module accepts a 24-bit RGB value and serializes it according to the WS2812 communication protocol.

✨ Overview
---
WS2812 LEDs use a single-wire, non-return-to-zero (NRZ) protocol where logic 0 and logic 1 are distinguished only by pulse width, not voltage level.
Because of this, precise timing is critical and makes WS2812 a good example of:  
- Cycle-accurate digital design  
- FSM-based protocol implementation  
- FPGA-driven LED control  
This project demonstrates how the WS2812 protocol can be implemented purely in hardware, without a CPU or softcore.

🔧 Features
---
- 24-bit RGB (8-bit per color) data transmission
- MSB-first bit ordering
- Fully synchronous FSM-based design
- Configurable timing via constants
- busy signal for transmission status
- Proper reset (latch) timing (>50 µs)
- Compatible with standard WS2812 / NeoPixel LEDs

📷 Demo
---
  [▶ Watch Demo Video](https://github.com/user-attachments/assets/dd1abad7-8ff4-4a80-8531-8fa35970afc1) 

🛠️ Tools Used
---
-VHDL
-Gowin EDA
-Tang Nano FPGA

📌 Notes
---
- Timing constants must be adjusted if system clock frequency changes
- WS2812 LEDs are timing-sensitive; synthesis and routing should be checked
- Designed for single LED, but can be extended for LED chains
