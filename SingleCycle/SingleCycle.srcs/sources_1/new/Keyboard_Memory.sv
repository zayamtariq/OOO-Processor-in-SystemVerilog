`timescale 1ns / 1ps

// the data structure associated with keyboards is a FIFO 
// by using a FIFO we can buffer inputs 

module Keyboard_Memory(
    input wire logic [7:0] Scancode, 
    input wire logic       CLK, 
    input wire logic       Incoming_Scancode, // control signal TODO: who is providing this, though? 
    input wire logic       Scancode_Request,  // control signal TODO: who is providing this, though? 
    output     logic [7:0] Scancode_to_Read
    );  
    
    reg [7:0] Keyboard_FIFO [9:0]; // 10 entry FIFO  
    reg       Valid_Bits    [9:0]; // "1" - full, "0" - empty
    logic [3:0] FIFO_Pointer; // FIFO_Pointer points to element ready to pop
    logic [3:0] Append_Pointer; // Append_Pointer points to position where we want to add 
    
    initial begin 
        FIFO_Pointer = 4'd0; 
        Append_Pointer = 4'd0; 
        for (int i = 0; i < 10; i = i + 1) begin 
            Keyboard_FIFO[i] = 8'd0; 
            Valid_Bits[i] = 1'b0;  
        end 
    end 
     
    /*
    considerations:
    - what if fifo pointer is empty? 
    - things to do at edges of fifo 
    - 
    */ 
    
    // READING LOGIC: 
    // (combinational because reading is free!) 
    always_comb begin 
        if (Scancode_Request == 1'b1 && Valid_Bits[FIFO_Pointer] == 1'b1) begin 
            Scancode_to_Read <= Keyboard_FIFO[FIFO_Pointer];
            Valid_Bits[FIFO_Pointer] <= 0; 
            if (FIFO_Pointer == 4'd9) begin 
                // if the next entry is not empty, fifo_pointer goes there
                // else, it just stays there 
                if (Valid_Bits[0] == 1) begin 
                    FIFO_Pointer <= 4'd0; 
                end 
            end else begin 
                // if the next entry is not empty, fifo_pointer goes there
                // else, it just stays there 
                if (Valid_Bits[FIFO_Pointer + 1] == 1) begin 
                    FIFO_Pointer <= FIFO_Pointer + 1; 
                end
            end 
        end 
    end 
    
    always_ff @ (posedge CLK) begin 
        // will eat inputs if LIFO is full
        // WRITING LOGIC: 
        if (Incoming_Scancode == 1'b1 && Valid_Bits[Append_Pointer] == 1'b0) begin 
            Keyboard_FIFO[Append_Pointer] <= Scancode;
            if (Append_Pointer == 4'd9) begin 
                Append_Pointer <= 4'd0; 
            end else begin 
                Append_Pointer <= Append_Pointer + 1; 
            end 
            Valid_Bits[Append_Pointer] = 1'b1; // after appending, set entry to "full" 
        end 
    end 
    
endmodule
