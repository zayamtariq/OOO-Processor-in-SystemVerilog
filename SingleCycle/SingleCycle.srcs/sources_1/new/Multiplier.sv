`timescale 1ns / 1ps

// multiply two 32 bit sources 
// will need to account for both signed and unsigned components 

module Multiplier(
    input wire logic [31:0] SrcA, 
    input wire logic [31:0] SrcB, 
    // will need control store signals for signed and unsigned 
    input wire logic [1:0] Mult_Instruction, // 2 bits for 4 different multiply instructions
    output logic [31:0] Product 
    );
    
    logic [63:0] Intermediate_Product; 
    
    always_comb begin 
        case (Mult_Instruction) 
            2'b00: 
            begin
                Intermediate_Product = ($signed(SrcA) * $signed(SrcB));              
            end  
            2'b01: 
            begin
                Intermediate_Product = ($signed(SrcA) * $signed(SrcB)); 
            end 
            2'b10: 
            begin 
                Intermediate_Product = ($signed(SrcA) * $unsigned(SrcB)); 
            end 
            2'b11: 
            begin
                Intermediate_Product = ($unsigned(SrcA) * $unsigned(SrcB));  
            end 
        endcase 
    end 
    
    assign Product = (Mult_Instruction == 2'b00) ? Intermediate_Product[31:0] : 
                     (Mult_Instruction == 2'b01) ? $signed(Intermediate_Product[63:32]) : 
                     (Mult_Instruction == 2'b10) ? $signed(Intermediate_Product[63:32]) : 
                     (Mult_Instruction == 2'b11) ? $unsigned(Intermediate_Product[63:32]) : 
                     Product; // if somehow mult instruction doesnt exist, just let it be itself (high z state) 
    
endmodule
