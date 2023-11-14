`timescale 1ns / 1ps

module PC_Module(
    input wire logic CLK, 
    input wire logic [31:0] NextPC, 
    output logic PC_Value
    );
    
    logic [31:0] PC; 
    
    always_ff @ (posedge CLK) begin 
        PC_Value <= NextPC; 
    end 
    
    assign PC_Value = PC; 
    
endmodule
