# OOO-Processor-in-SystemVerilog
Going to start with a simple, single-cycle RISC-V (RV32IM) processor, and take it as far as possible, with the ultimate goal of **running Linux**. 

## Current *SINGLE CYCLE* Design: 

![image](https://github.com/zayamtariq/OOO-Processor-in-SystemVerilog/assets/31855609/bf886e4d-5450-417b-9bab-565236d117ce)

After getting the initial base, User-Mode-Only version of the core running, I extended the design out to include the privelige mode level instructions, as well as an I/O controller to allow a user to interface with the core via a keyboard and a monitor. Furthermore, I included the M extension, thus extending the execute unit to include Multiply and Divide units as well. I wanted to have something working, and in the meantime, I worked parallelly on the following, more involved design: 

## Out of Order Design (User Mode Only): 

![image](https://github.com/zayamtariq/OOO-Processor-in-SystemVerilog/assets/31855609/f0516109-d737-4526-aeee-e3307d5d615d)

I-Cache and D-Cache are obviously a lot more involved with their designs, as well as the recovery logic. Furthermore, the I/O Controller is mostly separate from the core, as it communicates directly to and from memory (this is a concept known as Memory-Mapped I/O). The most convoluted part of this whole thing was how to conduct elaborate logic such as communication between the RAT, the ROB, and the Issue/Load/Store Queues. I also wasn't sure how tightly pipelined the whole thing should be. Specifications for what entries are in the ROB, the RAT, the Queues, and the Functional Units can be found in the respective SystemVerilog files. 

Further necessary to note that currently the Zicsr extension has not been implemented. Understanding it will be crucial to getting Linux running on the system, but, of course, it is an extremely involved process learning the intricacies of the ISA. 
