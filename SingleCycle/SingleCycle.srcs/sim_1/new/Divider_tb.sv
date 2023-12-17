`timescale 1ns / 1ps


module Divider_tb();

// divider result
logic [31:0] quotient_result; 

// divider inputs 
logic [31:0] SrcA, SrcB; 
logic Div_Instruction_Signal; // control store signal  

Divider div_test(.SrcA(SrcA), 
        .SrcB(SrcB),
        .Div_Instruction(Div_Instruction_Signal),
        .Quotient(quotient_result));

initial begin 
    
    SrcA = 32'd10; 
    SrcB = 32'd2; 
    Div_Instruction_Signal = 0; 
    
    #100 
    
    SrcA = 32'd711; 
    
    #100 
    
    $finish; 
    
end 

endmodule
