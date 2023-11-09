`timescale 1ns / 1ps

module CPU_Top(
    input CLK, 
    input [31:0] data, // can be an instruction or just data 
    output [31:0] address // can be the PC or an address in data memory 
    );
endmodule
