`timescale 1ns / 1ps

module PCMux(
    input wire logic [31:0] plus_four, plus_offset, // inputs 
    input wire logic pc_cs, // control signal  
    output logic [31:0] next_pc // output 
    );
    
    always_comb begin 
        if (pc_cs == 1'b0) next_pc = plus_four; // 0 is DON'T take the branch  
        else next_pc = plus_offset; 
    end 
    
endmodule
