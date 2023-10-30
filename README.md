# OOO-Processor-in-SystemVerilog
Going to start with a simple, single-cycle RISC-V (RV32IM) processor, and take it as far as possible. 

## Initial Design: 

![image](https://github.com/zayamtariq/OOO-Processor-in-SystemVerilog/assets/31855609/5f80ef4a-d6f7-4e58-80c0-9b365f722dbb)

The first step is to get it working in SystemVerilog, and learn how to fully test with SystemVerilog's "coverage" technique. This isn't even the full ISA. I've largely left out anything referencing the CSR or privelige modes, and the multiplication and division units are also glaringly not present. The point is to take baby steps, though. 
