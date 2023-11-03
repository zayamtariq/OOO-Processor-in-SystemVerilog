`timescale 1ns / 1ps

module PC(
    input wire logic CLK, 
    input wire logic [31:0] NextPC, 
    output logic PC_Value 
    );
    
    reg [31:0] PC; 
    
    // instruction memory, for us, starts at 0
    initial begin 
        PC = 32'd0; 
    end 
    
    always_ff @ (posedge CLK) begin 
        PC <= NextPC; 
    end 
    
    assign PC_Value = PC; 
    
endmodule
