`timescale 1ns / 1ps

module DataMemory(
    input CLK, 
    input wire logic [31:0] address, 
    input wire logic [31:0] write_data, 
    input wire logic memory_write_enable,
    input wire logic [1:0] B_H_W, 
    input wire logic is_unsigned, 
    output logic signed [31:0] read_data  
    );
    
    logic [31:0] data_memory [1023:0]; // 1024 entries (for now), 32-bit memory
    
    integer i; 
    
    // initialize all memory to 0 
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin 
            data_memory[i] = 32'd0; 
        end 
    end 
    
    // writing needs a clock 
    always_ff @ (posedge CLK) begin 
        if (memory_write_enable) begin // timing error possible here? 
            // we can write if we've made it here!
            case (B_H_W) 
            2'b00:; // we don't care about this for stores! 
            2'b01: begin 
            case (address[1:0]) // use last two bits to index into mem location 
                2'b00: data_memory[address >> 2][7:0] <= write_data[7:0]; // byte 
                2'b01: data_memory[address >> 2][15:8] <= write_data[7:0];
                2'b10: data_memory[address >> 2][23:16] <= write_data[7:0]; 
                2'b11: data_memory[address >> 2][31:24] <= write_data[7:0]; 
            endcase 
            end 
            2'b10: begin 
            case (address[1:0]) 
                2'b00: data_memory[address >> 2][15:0] <= write_data[15:0]; // halfword 
                2'b10: data_memory[address >> 2][31:16] <= write_data[15:0]; 
            endcase
            end 
            2'b11: data_memory[address >> 2] <= write_data; // full word  
            endcase
        end 
    end 
    
    // reading is combinational 
    always_comb begin 
        case (B_H_W) 
            2'b00: read_data = data_memory[address >> 2]; // we can't abstract this away like in stores!
            2'b01: begin // lb or lbu
                if (is_unsigned) read_data = {24'd0, data_memory[address >> 2][7:0]}; // zero extend if unsigned 
                else read_data = {{24{data_memory[address >> 2][7]}}, data_memory[address >> 2][7:0]}; // sign extend if signed (DOESN'T SIGN EXTEND???) 
            end // signed or unsigned?
            2'b10: begin // lh or lhu 
                if (is_unsigned) read_data = {16'd0, data_memory[address >> 2][15:0]}; // zero extend if unsigned 
                else read_data = {{16{data_memory[address >> 2][15]}}, data_memory[address >> 2][15:0]}; // sign extend if signed (DOESN'T SIGN EXTEND???) 
            end // signed or unsigned? 
            2'b11: read_data = data_memory[address >> 2]; // lw 
        endcase
    end 
    
endmodule
