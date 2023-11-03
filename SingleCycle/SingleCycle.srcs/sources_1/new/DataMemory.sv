`timescale 1ns / 1ps

module DataMemory(
    input CLK, 
    input wire logic [31:0] address, 
    input wire logic [31:0] write_data, 
    input wire logic memory_write_enable,
    input wire logic [1:0] B_H_W, 
    input wire logic is_unsigned, 
    output logic [31:0] read_data  
    );
    
    logic [31:0] data_memory [(2**32)-1:0]; // 1024 entry, 32-bit memory
    
    // writing needs a clock 
    always_ff @ (posedge CLK) begin 
        if (memory_write_enable) begin // timing error possible here? 
            // we can write if we've made it here!
            case (B_H_W) 
            2'b00:; // we don't care about this for stores! 
            2'b01: data_memory[address >> 2] <= write_data[7:0]; // byte  
            2'b10: data_memory[address >> 1] <= write_data[15:0]; // halfword 
            2'b11: data_memory[address] <= write_data; // full word  
            endcase
        end 
    end 
    
    // reading is combinational 
    always_comb begin 
        case (B_H_W) 
            2'b00: read_data = data_memory[address]; // we can't abstract this away like in stores!
            2'b01: begin // lb or lbu
                if (is_unsigned) read_data = {24'd0, data_memory[address][7:0]}; // zero extend if unsigned 
                else read_data = {{24{data_memory[address][7]}}, data_memory[address][7:0]}; // sign extend if signed 
            end // signed or unsigned?
            2'b10: begin // lh or lhu 
                if (is_unsigned) read_data = {16'd0, data_memory[address][15:0]}; // zero extend if unsigned 
                else read_data = {{16{data_memory[address][15]}}, data_memory[address][15:0]}; // sign extend if signed 
            end // signed or unsigned? 
            2'b11: read_data = data_memory[address]; // lw 
        endcase
    end 
    
endmodule
