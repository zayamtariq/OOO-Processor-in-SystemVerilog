`timescale 1ns / 1ps

module Divider(
    input wire logic [31:0] SrcA, 
    input wire logic [31:0] SrcB, 
    input wire logic Div_Instruction, // control signal 
    output logic [31:0] Quotient
    );
    
    always_comb begin 
        case (Div_Instruction) 
            1'b0: Quotient = SrcA / $signed(SrcB); 
            1'b1: Quotient = SrcA / $unsigned(SrcB); 
        endcase
    end 
    
endmodule
