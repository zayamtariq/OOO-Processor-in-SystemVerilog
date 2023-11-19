`timescale 1ns / 1ps

// two entries in register aliasing table: 
// a bit to represent if pointing to ROB or architectural register file
// a pointer to latest ROB entry (if pointing to ROB) 
// tentative: 128 entry [7 bit indexing] ROB 

module RegisterAliasingTable(
    input wire logic CLK, 
    input wire logic [4:0] SR1_Bits, 
    input wire logic [4:0] SR2_Bits, 
    input wire logic [4:0] DR_Bits,
    input wire logic reg_or_imm // 1 for immediate, 0 for reg 
    );
    
    logic ROB_or_ARF [31:0]; // 1 for ROB, 0 for ARF (32 entries for this) 
    logic [6:0] ROB_Address [31:0]; // xFFFFFFFF if no entry to ROB (32 entries in RAT, 7 bit wide addressing for 128 entry ROB) 
    
    always_ff @ (posedge CLK) begin 
        if (reg_or_imm == 1'b1) begin // immediate 
            
        end else begin // reg 
            
        end 
    end 
    
endmodule
