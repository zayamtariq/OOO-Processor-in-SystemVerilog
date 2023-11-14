`timescale 1ns / 1ps

module DataMemory_tb();

// clock input stuff  
logic CLK; 
localparam halfperiod = 5; 

always #halfperiod CLK = ~CLK; 

// input 
logic [31:0] address, write_data; 
logic memory_write_enable, is_unsigned;
logic [1:0] B_H_W; 

// output 
logic [31:0] read_data; 


DataMemory datamem(.CLK(CLK), 
           .address(address), 
           .write_data(write_data), 
           .memory_write_enable(memory_write_enable), 
           .is_unsigned(is_unsigned), 
           .B_H_W(B_H_W), 
           .read_data(read_data)); 

// data memory is clocked on the positive edge 
// testing plan: 

// 1. write a byte 0xF at 0 
// 2. write a half-word 0xA0 at 4 
// 3. write a word 0xC000 at 8 

// 4. read at location 0, signed 
// 5. read at location 0, unsigned 
// 6. read at location 4, signed 
// 7. read at location 4, unsigned 
// 8. read at location 8 

initial begin 
    CLK = 0; 
    is_unsigned = 0; 
    
    // write 0xF at location 0 first (byte) 
    address = 32'h0000; 
    write_data = 32'h00FF; 
    memory_write_enable = 1; 
    B_H_W = 2'b01; 
    
    #(2 * halfperiod) 
    
    // write 0xA0 at location 1 next (half-word) 
    address = 32'h0004; 
    write_data = 32'ha0a0; 
    memory_write_enable = 1; 
    B_H_W = 2'b10; 
    
    #(2 * halfperiod) 
    
    // write 0xC000 at location 2 next (word) 
    address = 32'h0008; 
    write_data = 32'hc000; 
    memory_write_enable = 1; 
    B_H_W = 2'b11; 
    
    #(2 * halfperiod) 
    
    // read at location 0, unsigned (byte) 
    address = 32'h0000; 
    memory_write_enable = 0; 
    B_H_W = 2'b01; 
    is_unsigned = 1; 
    
    #(2 * halfperiod) 
    
    // read at location 0, signed (byte)
    is_unsigned = 0; 
    
    #(2 * halfperiod) 
    
    // read at location 1, unsigned (half word) 
    address = 32'h0004; 
    B_H_W = 2'b10; 
    is_unsigned = 1; 
    
    #(2 * halfperiod) 
    
    // read at location 1, signed (halfword)  
    is_unsigned = 0; 
    
    #(2 * halfperiod) 
    
    // read at location 2 (word)
    address = 32'h0008;  
    B_H_W = 2'b11; 
    
    #100
    
    $finish; 
    
end 

endmodule
