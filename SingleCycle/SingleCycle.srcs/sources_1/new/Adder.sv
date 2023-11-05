`timescale 1ns / 1ps

// a general purpose adder, will be reused in a couple of instances 

module Adder(
    input wire logic [31:0] input_one, input_two, 
    output logic [31:0] adder_output 
    );
    
    assign adder_output = input_one + input_two; 
    
endmodule 