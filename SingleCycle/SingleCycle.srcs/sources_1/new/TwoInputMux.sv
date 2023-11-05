`timescale 1ns / 1ps

// general purpose two input mux, will be used throughout the design
// whenever calling mux: A = 1, B = 0

module TwoInputMux(
    input wire logic [31:0] A, B, // inputs 
    input wire logic CS, // control signal  
    output wire logic [31:0] C // output 
    );
    
    assign C = (CS == 1) ? A : B;  
    
endmodule
