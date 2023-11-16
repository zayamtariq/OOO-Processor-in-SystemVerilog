`timescale 1ns / 1ps

module DisplayModule_480p(
    input wire pixel_clock,  
    input wire pixel_reset, 
    output     [9:0] sx, // horizontal screen position 
    output     [9:0] sy, // vertical screen position
    output     hsync, // horizontal sync
    output     vsync, // vertical sync 
    output     de     // data enable (?) 
    );
    
    // horizontal timings
    parameter HA_END = 639;           // end of active pixels
    parameter HS_STA = HA_END + 16;   // sync starts after front porch
    parameter HS_END = HS_STA + 96;   // sync ends
    parameter LINE   = 799;           // last pixel on line (after back porch)

    // vertical timings
    parameter VA_END = 479;           // end of active pixels
    parameter VS_STA = VA_END + 10;   // sync starts after front porch
    parameter VS_END = VS_STA + 2;    // sync ends
    parameter SCREEN = 524;           // last line on screen (after back porch)
    
    always @(*) begin 
        hsync = ~(sx >= HS_STA && sx < HS_END);  // invert: negative polarity -> 0 when in sync region after front porch 
        vsync = ~(sy >= VS_STA && sy < VS_END);  // invert: negative polarity -> 0 when in sync region after front porch
        
        de = (sx <= HA_END && sy <= VA_END); // data enable goes high when we're in the active pixel region
    end 
    
    // then, on every clock edge, calculate new pixel location (horizontal and vertical screen)
    always_ff @ (posedge pixel_clock) begin 
        if (sx == LINE) begin  // last pixel on line?
            sx <= 0;
            sy <= (sy == SCREEN) ? 0 : sy + 1;  // last line on screen?
        end else begin
            sx <= sx + 1;
        end
        if (pixel_reset) begin 
            sx <= 0; 
            sy <= 0; 
        end 
    end 
    
endmodule
