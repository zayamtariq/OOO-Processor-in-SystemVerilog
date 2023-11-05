`timescale 1ns / 1ps

module ImmediateOffsetLogic(
    input wire logic [31:0] instruction, 
    input wire logic [2:0] Immediate_Calc, 
    output logic [31:0] Immediate_Offset 
    );
    
    // is signed/unsigned a consideration that we need to make?
    // no, alu will abstract this for us, all immediates/offsets here are sign extended 
    
    always_comb begin 
        case (Immediate_Calc)   
        3'b000: Immediate_Offset = {{20{instruction[31]}}, instruction[31:20]}; 
        3'b001: Immediate_Offset = {{27{instruction[24]}}, instruction[24:20]}; 
        3'b010: Immediate_Offset = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; 
        3'b011: Immediate_Offset = {{20{instruction[31]}}, instruction[31], instruction[7], instruction[30-25], instruction[11-8]}; 
        3'b100: Immediate_Offset = {{12{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30-21]}; 
        3'b101:; // reserved for future use
        3'b110:; // reserved for future use
        3'b111:; // reserved for future use
        endcase
    end 
    
endmodule
