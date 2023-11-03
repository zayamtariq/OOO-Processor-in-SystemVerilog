`timescale 1ns / 1ps

module InstructionMemory(
    input [31:0] PC_Address, 
    output [31:0] Instruction 
    );
    
    // instructions aren't read "halfway" 
    // need to 32-bit aligned 
    // but also PC increments by 4, not by 1
    // so we need to abstract away bottom 2 bits 
    // and only index based on the last 30 bits 
    // no aliasing can occur from this, realistically
    
    reg [31:0] instruction_mem [1023:0]; // 1024 entry, 32 bit addresses 
    
    // initial $readmemh("code.txt", instruction_mem)
    
    // shift 2 to ensure we stay aligned 
    assign Instruction = instruction_mem[PC_Address >> 2]; 
    
    
endmodule
