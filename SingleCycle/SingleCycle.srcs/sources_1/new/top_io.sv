`timescale 1ns / 1ps

// this hypothetically acts as our i/o controller 

module top_io(
    input wire logic clk,
    input wire logic PS2Data,
    input wire logic PS2Clk,
    input wire logic reset, // reset signal sent in through a button 
    output     logic vga_hsync, 
    output     logic vga_vsync, // just allows us to sync up our display with vga cable, make sure on same page
    output     logic [3:0] VGA_Red, 
    output     logic [3:0] VGA_Blue, 
    output     logic [3:0] VGA_Green // all vga color signals are 4-bit DACs
    );
    
    logic [7:0] ScanCode;
    
    top_keyboard kboard(.clk(clk), 
                        .PS2Data(PS2Data), 
                        .PS2Clk(PS2Clk), 
                        .ScanCode(ScanCode));  
    
    top_square vga(.clock(clk), 
                   .reset(reset), 
                   .ScanCode(ScanCode), 
                   .vga_hsync(vga_hsync), 
                   .vga_vsync(vga_vsync), 
                   .VGA_Red(VGA_Red),
                   .VGA_Blue(VGA_Blue),
                   .VGA_Green(VGA_Green)); 
    
endmodule