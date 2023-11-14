`timescale 1ns / 1ps

module BranchLogicBlock(
    input wire logic [31:0] R1_Value, R2_Value, 
    input wire logic [2:0] PC_Select, 
    output logic PCMux_CS // 1 for taken, 0 for not taken  
    );
    
    always_comb begin
        case (PC_Select) 
        3'b000: PCMux_CS = 0; // non branch instruction 
        3'b001: PCMux_CS = 1; // JAL/JALR (always taken)
        3'b010: PCMux_CS = (R1_Value == R2_Value) ? 1 : 0; // beq
        3'b011: PCMux_CS = (R1_Value != R2_Value) ? 1 : 0; // bne 
        3'b100: PCMux_CS = ($signed(R1_Value) < $signed(R2_Value)) ? 1 : 0; // blt (signed!!!)  
        3'b101: PCMux_CS = ($signed(R1_Value) >= $signed(R2_Value)) ? 1 : 0; // bge (signed!!!) 
        3'b110: PCMux_CS = (R1_Value < R2_Value) ? 1 : 0; // bltu (unsigned!!!)
        3'b111: PCMux_CS = (R1_Value >= R2_Value) ? 1 : 0; // bgeu (unsigned!!!) 
        default: PCMux_CS = 0; // dont take dat branch!
        endcase
    end 
    
endmodule
