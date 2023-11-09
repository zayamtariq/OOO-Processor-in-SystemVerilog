`timescale 1ns / 1ps

module CPU_test();

logic CLK; 

initial CLK = 0; 

always #10 CLK = ~CLK; 

Top CPU(.CLK(CLK));

endmodule
