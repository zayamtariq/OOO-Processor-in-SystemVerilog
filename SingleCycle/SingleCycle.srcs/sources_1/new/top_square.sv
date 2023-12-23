`timescale 1ns / 1ps

module top_vga(
    input wire logic clock,     // 100 mhz hardware clock 
    input wire logic reset,     // reset signal sent in through a button 
    input wire logic [7:0] ScanCode, // byte we received back TODO: need to get rid of this eventually, keyboard will not communicate directly with vga
    output     logic vga_hsync, 
    output     logic vga_vsync, // just allows us to sync up our display with vga cable, make sure on same page
    output     logic [3:0] VGA_Red, 
    output     logic [3:0] VGA_Blue, 
    output     logic [3:0] VGA_Green // all vga color signals are 4-bit DACs
    );
    
    // get the right clock frequency for vga 
    logic output_pulse; 
    Clock_252 clk_div(.CLK(clock), .clock_pulse(output_pulse)); 
    
    // drive to the display module and get appropriate desired signals 
    logic [9:0] sx, sy; 
    logic hsync, vsync, de, pixel_reset; 
    
    DisplayModule_480p dmod480(.pixel_clock(output_pulse), 
                                .pixel_reset(reset), 
                                .sx(sx), 
                                .sy(sy), 
                                .hsync(hsync), 
                                .vsync(vsync), 
                                .de(de)); 
    
    logic [7:0] byte_to_read; // reading from VGA memory
    
    VGA_Memory vga_mem(.x_coordinate(sx), 
                       .y_coordinate(sy), 
                       .CLK(output_pulse), 
                       .WriteVGA(), // TODO: CPU needs to provide this signal eventually 
                       .byte_to_write(), // TODO: CPU needs to provide this signal eventually 
                       .byte_to_read(byte_to_read)); 
    
    // paint colour: white inside square, blue outside
    logic [3:0] paint_r, paint_g, paint_b;
    always_comb begin
        if (ScanCode == 8'h75) begin 
            paint_r = 4'h7;
            paint_g = 4'h7;
            paint_b = 4'h7;
        end 
        else if (ScanCode == 8'h72) begin // from VGA memory
            paint_r = {byte_to_read[7], byte_to_read[7:5]};
            paint_g = {byte_to_read[1], byte_to_read[1], byte_to_read[1:0]}; 
            paint_b = {byte_to_read[4], byte_to_read[4:2]};
        end else begin 
            paint_r = 4'hF; 
            paint_g = 4'hF; 
            paint_b = 4'hF; 
        end
        // notice: #FFF if inside square (white), #137 if outside square (blue), which checks out
    end

    // display colour: paint colour but black in blanking interval
    logic [3:0] display_r, display_g, display_b;
    always_comb begin
        display_r = (de) ? paint_r : 4'h0;
        display_g = (de) ? paint_g : 4'h0;
        display_b = (de) ? paint_b : 4'h0;
        // this block just asks: are we in the active pixel region?
    end

    // VGA Pmod output
    always_ff @(posedge output_pulse) begin 
        vga_hsync <= hsync;
        vga_vsync <= vsync;
        VGA_Red <= display_r;
        VGA_Green <= display_g;
        VGA_Blue <= display_b;
        // update vga for every single pixel we write 
    end
    
endmodule
