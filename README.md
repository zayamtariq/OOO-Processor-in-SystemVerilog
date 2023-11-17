# OOO-Processor-in-SystemVerilog
Going to start with a simple, single-cycle RISC-V (RV32IM) processor, and take it as far as possible. 

## Current Design: 

![image](https://github.com/zayamtariq/OOO-Processor-in-SystemVerilog/assets/31855609/bf886e4d-5450-417b-9bab-565236d117ce)

After getting the initial base, User-Mode-Only version of the core running, I extended the design out to include the privelige mode level instructions, as well as an I/O controller to allow a user to interface with the core via a keyboard and a monitor. Furthermore, I included the M extension, thus extending the execute unit to include Multiply and Divide units as well. 
