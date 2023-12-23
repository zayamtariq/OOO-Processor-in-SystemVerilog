`timescale 1ns / 1ps

module VGA_Memory_tb();

// clock input stuff  
logic CLK; 
localparam halfperiod = 5; 

always #halfperiod CLK = ~CLK; 

// inputs: 
logic [9:0] x_coordinate; 
logic [9:0] y_coordinate; 
logic WriteVGA; 
logic [7:0] byte_to_write; 

VGA_Memory vga_mem(.x_coordinate(x_coordinate), 
                   .y_coordinate(y_coordinate), 
                   .CLK(CLK), 
                   .WriteVGA(WriteVGA), 
                   .byte_to_write(byte_to_write));  

initial begin 
    x_coordinate = 1; 
    y_coordinate = 2; 
    WriteVGA = 1; 
    byte_to_write = 8'b10101010; 
    
    #100 
    
    $finish; 
end 

endmodule
