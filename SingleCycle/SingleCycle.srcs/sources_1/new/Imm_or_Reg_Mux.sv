`timescale 1ns / 1ps

module Imm_or_Reg_Mux(
    input wire logic Imm_or_Reg, 
    input wire logic [31:0] Reg2, Immediate, 
    output logic [31:0] SrcB 
    );
    
    // 1 when immediate, 0 when not immediate
    
    assign SrcB = (Imm_or_Reg) ? Immediate : Reg2; 
    
endmodule
