`timescale 1ns / 1ps

// a 640 x 480 display = 307,200 bytes total 
// each byte represents a single pixel 

// first 3 bits for red, second 3 bits for blue, last 2 bits for green 

module VGA_Memory(
    // coordinates that are being written to: 
    input wire logic [9:0] x_coordinate, 
    input wire logic [9:0] y_coordinate, // use these two to index into desired chunk
    input wire logic       CLK, 
    input wire logic       WriteVGA,     // Control Signal defined by CPU  
    input wire logic [7:0] byte_to_write, // defined by the user, the byte they'd like to have written at what location
    output     logic [7:0] byte_to_read
    );
    
    logic [7:0] VGA_MEM_CHUNK_1 [51999:0]; // 52000 bytes per chunk 
    logic [7:0] VGA_MEM_CHUNK_2 [51999:0]; 
    logic [7:0] VGA_MEM_CHUNK_3 [51999:0]; 
    logic [7:0] VGA_MEM_CHUNK_4 [51999:0]; 
    logic [7:0] VGA_MEM_CHUNK_5 [51999:0]; 
    logic [7:0] VGA_MEM_CHUNK_6 [51999:0]; 
    
    initial begin 
        for (int i = 0; i < 52000; i = i + 1) begin 
            VGA_MEM_CHUNK_1[i] = 8'hE0; 
        end 
        for (int i = 0; i < 52000; i = i + 1) begin 
            VGA_MEM_CHUNK_2[i] = 8'hE0; 
        end 
        for (int i = 0; i < 52000; i = i + 1) begin 
            VGA_MEM_CHUNK_3[i] = 8'hE0; 
        end 
        for (int i = 0; i < 52000; i = i + 1) begin 
            VGA_MEM_CHUNK_4[i] = 8'hE0; 
        end 
        for (int i = 0; i < 52000; i = i + 1) begin 
            VGA_MEM_CHUNK_5[i] = 8'hE0; 
        end 
        for (int i = 0; i < 52000; i = i + 1) begin 
            VGA_MEM_CHUNK_6[i] = 8'hE0; 
        end 
    end 
    
    // reading memory is free, doesn't cost us anything 
    always_comb begin 
            if (y_coordinate >= 0 || y_coordinate <= 79) begin 
                // chunk 1 
                byte_to_read = VGA_MEM_CHUNK_1[(y_coordinate * 640) + x_coordinate]; 
            end else if (y_coordinate >= 80 || y_coordinate <= 159) begin 
                // chunk 2
                byte_to_read = VGA_MEM_CHUNK_2[((y_coordinate - 80) * 640) + x_coordinate]; 
            end else if (y_coordinate >= 160 || y_coordinate <= 239) begin 
                // chunk 3
                byte_to_read = VGA_MEM_CHUNK_3[((y_coordinate - 160) * 640) + x_coordinate]; 
            end else if (y_coordinate >= 240 || y_coordinate <= 319) begin 
                // chunk 4 
                byte_to_read = VGA_MEM_CHUNK_4[((y_coordinate - 240) * 640) + x_coordinate]; 
            end else if (y_coordinate >= 320 || y_coordinate <= 399) begin 
                // chunk 5 
                byte_to_read = VGA_MEM_CHUNK_5[((y_coordinate - 320) * 640) + x_coordinate]; 
            end else if (y_coordinate >= 400 || y_coordinate <= 479) begin 
                // chunk 6 
                byte_to_read = VGA_MEM_CHUNK_6[((y_coordinate - 400) * 640) + x_coordinate]; 
            end         
    end 
    
    
    always_ff @ (posedge CLK) begin 
        if (WriteVGA == 1'b1) begin 
            if (y_coordinate >= 0 || y_coordinate <= 79) begin 
                // chunk 1 
                VGA_MEM_CHUNK_1[(y_coordinate * 640) + x_coordinate] <= byte_to_write; 
            end else if (y_coordinate >= 80 || y_coordinate <= 159) begin 
                // chunk 2
                VGA_MEM_CHUNK_2[((y_coordinate - 80) * 640) + x_coordinate] <= byte_to_write; 
            end else if (y_coordinate >= 160 || y_coordinate <= 239) begin 
                // chunk 3
                VGA_MEM_CHUNK_3[((y_coordinate - 160) * 640) + x_coordinate] <= byte_to_write; 
            end else if (y_coordinate >= 240 || y_coordinate <= 319) begin 
                // chunk 4 
                VGA_MEM_CHUNK_4[((y_coordinate - 240) * 640) + x_coordinate] <= byte_to_write; 
            end else if (y_coordinate >= 320 || y_coordinate <= 399) begin 
                // chunk 5 
                VGA_MEM_CHUNK_5[((y_coordinate - 320) * 640) + x_coordinate] <= byte_to_write; 
            end else if (y_coordinate >= 400 || y_coordinate <= 479) begin 
                // chunk 6 
                VGA_MEM_CHUNK_6[((y_coordinate - 400) * 640) + x_coordinate] <= byte_to_write; 
            end 
        end 
    end 
    
endmodule
