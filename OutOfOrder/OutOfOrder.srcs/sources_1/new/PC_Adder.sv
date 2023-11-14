`timescale 1ns / 1ps

module PC_Adder(
    input wire logic [31:0] PC_Value, 
    output logic [31:0] PC_Plus_Four 
    );
    
    always_comb begin 
        PC_Plus_Four = PC_Value + 4; 
    end 
    
endmodule
