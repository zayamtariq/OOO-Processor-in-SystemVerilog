`timescale 1ns / 1ps

// 00 = ALU/SHF 
// 01 = MUL 
// 10 = DIV 
// 11 = REM 

module Execution_Mux(
    input wire logic [1:0] InstructionType, 
    input wire logic [31:0] ALU_Result, 
    input wire logic [31:0] MUL_Result, 
    input wire logic [31:0] DIV_Result, 
    input wire logic [31:0] REM_Result, 
    output     logic [31:0] EXE_Result  
    );
    
    always_comb begin 
        case (InstructionType) 
            2'b00: EXE_Result = ALU_Result;
            2'b01: EXE_Result = MUL_Result;
            2'b10: EXE_Result = DIV_Result;
            2'b11: EXE_Result = REM_Result;
        endcase         
    end 
    
endmodule
