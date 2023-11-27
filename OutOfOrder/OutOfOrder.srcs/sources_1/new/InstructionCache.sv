`timescale 1ns / 1ps

// specifications of this cache: 
// starting out with a direct mapped cache for simplicity 
// no virtual addresses yet either 

// cache is tightly involved with cache controller, too 

// on miss we need to stall previous pipeline 

module InstructionCache(
    input wire logic CLK, 
    input wire logic [31:0] InstructionAddress, 
    output logic HitMiss, // 1 for hit, 0 for miss 
    output logic [31:0] Address 
    );
    
    // lets tentatively say: 512 entry cache 
    logic [511:0] cache; 
    
    always_ff @ (posedge CLK) begin 
    
    end 
    
endmodule
