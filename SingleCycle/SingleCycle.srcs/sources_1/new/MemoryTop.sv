`timescale 1ns / 1ps

// basically multiported memory

module MemoryTop(
    // for instruction AND data memory
    input [31:0] Address, 
    output [31:0] InstructionData,
    // for just data
    input [31:0] ALU_Result, 
    input [31:0] Write_Data, 
    input [1:0] B_H_W, 
    input Write_Enable, 
    input is_unsigned, 
    input CLK, 
    output [31:0] MemoryData
    );
    
    InstructionMemory i_mem(.PC_Address(Address), 
                            .Instruction(InstructionData)); 
                            
    DataMemory d_mem(.CLK(CLK),
                     .address(ALU_Result), 
                     .write_data(write_data),
                     .B_H_W(B_H_W), 
                     .memory_write_enable(Write_Enable), 
                     .is_unsigned(is_unsigned), 
                     .read_data(MemoryData));                         
    
endmodule
