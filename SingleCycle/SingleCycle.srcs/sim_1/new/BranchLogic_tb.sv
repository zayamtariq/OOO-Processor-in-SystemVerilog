`timescale 1ns / 1ps


module BranchLogic_tb();

// inputs: 
logic [31:0] R1_Value, R2_Value; 
logic [2:0] PC_Select; 

// outputs: 
logic PCMux_CS; 


BranchLogicBlock blb(.R1_Value(R1_Value), 
                     .R2_Value(R2_Value),
                     .PC_Select(PC_Select), 
                     .PCMux_CS(PCMux_CS)); 

initial begin

R1_Value = 32'hF0000000;
R2_Value = 32'h00000001; 
PC_Select = 3'b000; 

#20 

PC_Select = 3'b001;

#20 

PC_Select = 3'b010; 

#20 

PC_Select = 3'b011; 

#20 

PC_Select = 3'b100; 

#20 

PC_Select = 3'b101; 

#20 

PC_Select = 3'b110; 

#20 

PC_Select = 3'b111; 

end 

endmodule
