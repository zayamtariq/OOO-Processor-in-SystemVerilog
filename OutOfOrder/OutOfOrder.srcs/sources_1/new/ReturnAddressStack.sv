`timescale 1ns / 1ps

/*
features: 
    - driven by clock, synchronous pushes and pops 
    - can not push and pop at the same time (read one at a time or write one at a time, not both) 
    - basic LIFO hardware 
*/ 

module ReturnAddressStack(
    input wire logic [31:0] PotentialFetchAddress, 
    input wire logic CLK, 
    input wire logic PUSH, 
    input wire logic POP, // the return address stack is a LIFO --> these signals are provided from the BTB probably
    output logic [31:0] return_address  
    );
    
    reg [31:0] stack [15:0]; // initialize LIFO to have 16 return addresses (each return address is 32 bit wide) 
    logic [3:0] LIFO_Top = 0; // points to top of LIFO  
    
    initial return_address = 32'd0; // not sure if necessary 
    
    // want to push 
    always_ff @ (posedge CLK) begin 
        if (PUSH == 1'd1 && POP == 1'd1) /* something terribly wrong has happened */ ;  
        else if (PUSH == 1'd1) begin 
            if (LIFO_Top == 4'd15) LIFO_Top = 4'd0; 
            else LIFO_Top = LIFO_Top + 1; 
            stack[LIFO_Top] = PotentialFetchAddress; 
        end 
        else if (POP == 1'd1) begin 
            return_address = stack[LIFO_Top]; 
            if (LIFO_Top == 4'd0) LIFO_Top = 4'd15; 
            else LIFO_Top = LIFO_Top - 1; 
        end 
    end 
    
endmodule
