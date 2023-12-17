`timescale 1ns / 1ps

module Remainder(
    input wire logic [31:0] SrcA, 
    input wire logic [31:0] SrcB, 
    input wire logic Rem_Instruction, 
    output logic [31:0] Modulus 
    );
    
    always_comb begin 
        case (Rem_Instruction)  
            1'b0: Modulus = SrcA % $signed(SrcB); 
            1'b1: Modulus = SrcA % $unsigned(SrcB); 
        endcase 
    end 
    
endmodule
