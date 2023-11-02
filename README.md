# OOO-Processor-in-SystemVerilog
Going to start with a simple, single-cycle RISC-V (RV32IM) processor, and take it as far as possible. 

## Initial Design: 

![image](https://github.com/zayamtariq/OOO-Processor-in-SystemVerilog/assets/31855609/5f80ef4a-d6f7-4e58-80c0-9b365f722dbb)

The first step is to get it working in SystemVerilog, and learn how to fully test with SystemVerilog's "coverage" technique. This isn't even the full ISA. I've largely left out anything referencing the CSR or privelige modes, and the multiplication and division units are also glaringly not present. The point is to take baby steps, though. 

## Small Optimization: 

![image](https://github.com/zayamtariq/OOO-Processor-in-SystemVerilog/assets/31855609/505903a1-7183-4d0e-b68a-e01bf09fce96)

I realized early on that I could reduce hardware by combining the ALU and SHF units (and that this is something I'd want once I get to functional units), so I ended up doing just that. Also pre-computed the "Shift Amount" immediate bits in the immediate/offset calculator component. 

## Notes: 
- H_B_W Mux for store operations is not necessary, can be a part of the memory's architecture itself
- AUIPC and LUI instructions will need a special unit for themselves, or the architecture will need to be specially extended just for those two. 
