# OOO-Processor-in-SystemVerilog
Going to start with a simple, single-cycle RISC-V (RV32IM) processor, and take it as far as possible. 

## Current Design: 

![image](https://github.com/zayamtariq/OOO-Processor-in-SystemVerilog/assets/31855609/bf886e4d-5450-417b-9bab-565236d117ce)

After getting the initial base, User-Mode-Only version of the core running, I extended the design out to include the privelige mode level instructions, as well as an I/O controller to allow a user to interface with the core via a keyboard and a monitor. Furthermore, I included the M extension, thus extending the execute unit to include Multiply and Divide units as well. 

## Initial Design: 

![image](https://github.com/zayamtariq/OOO-Processor-in-SystemVerilog/assets/31855609/5f80ef4a-d6f7-4e58-80c0-9b365f722dbb)

The first step is to get it working in SystemVerilog, and learn how to fully test with SystemVerilog's "coverage" technique. This isn't even the full ISA. I've largely left out anything referencing the CSR or privelige modes, and the multiplication and division units are also glaringly not present. The point is to take baby steps, though. 

## Small Optimization: 

![image](https://github.com/zayamtariq/OOO-Processor-in-SystemVerilog/assets/31855609/505903a1-7183-4d0e-b68a-e01bf09fce96)

I realized early on that I could reduce hardware by combining the ALU and SHF units (and that this is something I'd want once I get to functional units), so I ended up doing just that. Also pre-computed the "Shift Amount" immediate bits in the immediate/offset calculator component. 

## Notes: 
- H_B_W Mux for store operations is not necessary, can be a part of the memory's architecture itself
- AUIPC and LUI instructions will need a special unit for themselves, or the architecture will need to be specially extended just for those two. 

## In-Depth Data Memory Design 
While trying to figure out how to write the SystemVerilog implementation for the Data Memory, I realized that it was a lot more involved/complicated than the Instruction Memory. RISC-V uses byte-addressable memory, which makes certain loads and stores a lot more complicated, and requires a lot more logic than the Instruction Memory, which only reads from an address, and isn't really concerned with byte-addressability (because why would you ever only want a half-word or a byte from an instruction?). The design I am proposing right now, which I'm not married to at all, is the following 

![image](https://github.com/zayamtariq/OOO-Processor-in-SystemVerilog/assets/31855609/16b4893c-d67f-4548-a72f-79c6f6046463)

- Write_Enable signal (0 for Read, 1 for Write)
- B_H_W signal (reading/writing a Byte, a Half-Word, or a Word?)
- Signed_or_Unsigned signal (necessary in the event of a LBU or LHU instruction) 
- 32 bit address provided by the ALU/SHF unit
- 4 8-bit write_data inputs, all separate-but-parallelized for the case of Bytes, Half-Words, or Words
- 32 bit output of what's being read
