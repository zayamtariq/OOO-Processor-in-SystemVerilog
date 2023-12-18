`timescale 1ns / 1ps

module CPU_test();

logic CLK; 
logic [31:0] DataWrittenBack; 

initial CLK = 0; 

always #20000 CLK = ~CLK; 

Top CPU(.CLK(CLK), 
        .DataWrittenBack(DataWrittenBack));

endmodule
