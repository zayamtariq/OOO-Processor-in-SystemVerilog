`timescale 1ns / 1ps

// the branch target buffer acts as a cache that stores target addresses 
// indexed with first 7 bits of the BTB (2^7 = 128 entries) 
// tag matching with remaining 25 bits 
// each address contains: 
// 1. whether to take branch or not (branch history table -> 2 bit saturating counter, also 128 entries)  
// 2. what the target address is 

module BranchTargetBuffer(
    input wire logic [31:0] PC, // used for indexing into BTB, and for matching tags 
    input wire logic CLK, 
    output logic [31:0] TargetAddress, 
    output logic [1:0] Prediction // 1 for taken, 0 for not taken 
    );
    
    logic [31:0] TargetAddresses [127:0];   
    logic [1:0] BranchHistoryTable [127:0]; // entry updated upon execution of branch unit 
    logic [24:0] Tags [127:0]; 
    
    always_ff @ (posedge CLK) begin  
        if (Tags[PC[6:0]] == PC[31:7]) begin // cache hit 
            Prediction <= BranchHistoryTable[PC[6:0]]; 
            TargetAddress <= TargetAddresses[PC[6:0]]; 
        end else begin                       // cache miss 
            Prediction <= 2'b00;           // not taken 
            TargetAddress <= 32'hFFFFFFFF; // invalid address 
            // a miss doesn't necessarily mean we need to fill in the entry 
            // we *only* fill in the entry on a misprediction (handled by recovery logic...) 
        end 
    end    
    
endmodule
