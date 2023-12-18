`timescale 1ns / 1ps

module InstructionMemory(
    input logic CLK, 
    input wire logic [31:0] PC_Address, 
    output logic [31:0] Instruction 
    );
    
    // instructions aren't read "halfway" 
    // need to 32-bit aligned 
    // but also PC increments by 4, not by 1
    // so we need to abstract away bottom 2 bits 
    // and only index based on the last 30 bits 
    // no aliasing can occur from this, realistically
    
    logic [31:0] instruction_mem [1023:0]; // 1024 entry, 32 bit addresses 
    
    initial begin 
        // $readmemb("Fibonacci.txt", instruction_mem); 
        
        /***** FIBONACCI CODE: *****/ 
        
        /*
        instruction_mem[0] = 32'b00000000000100010000000100010011; 
        instruction_mem[1] = 32'b00000000101000100000001000010011; 
        instruction_mem[2] = 32'b00000000000100101000001010010011; 
        instruction_mem[3] = 32'b00000000001000001000000110110011; 
        instruction_mem[4] = 32'b00000000001000000000000010110011; 
        instruction_mem[5] = 32'b00000000001100000000000100110011; 
        instruction_mem[6] = 32'b01000000010100100000001000110011; 
        instruction_mem[7] = 32'b11111100010000000001110011100011; 
        */
        
         /****** MUL/DIV/REM TEST ******/ 
        instruction_mem[0] = 32'b00000000010100001000000010010011; 
        instruction_mem[1] = 32'b00000000101000010000000100010011; 
        instruction_mem[2] = 32'b11111111111100011000000110010011; 
        instruction_mem[3] = 32'b11000000000000100000001000010011; 
        instruction_mem[4] = 32'b00000010010000011000001010110011; 
        instruction_mem[5] = 32'b00000010010000011001001100110011; 
        instruction_mem[6] = 32'b00000010010000001010001110110011; 
        instruction_mem[7] = 32'b00000010001100010011010000110011; 
        instruction_mem[8] = 32'b00000010000100010100010010110011; 
        instruction_mem[9] = 32'b00000010000100100101010100110011; 
        instruction_mem[10] = 32'b00000010000100010110010110110011; 
        instruction_mem[11] = 32'b00000010000100011111011000110011; 
         
     end 
    
    // shift 2 to ensure we stay aligned 
    always_ff @ (posedge CLK) begin 
        Instruction <= instruction_mem[PC_Address >> 2]; 
    end
    
    
endmodule
