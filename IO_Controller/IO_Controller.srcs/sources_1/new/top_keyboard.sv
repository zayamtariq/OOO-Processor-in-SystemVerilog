`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc 
// Engineer: Arthur Brown
// 
// Create Date: 07/27/2016 02:04:01 PM
// Design Name: Basys3 Keyboard Demo
// Module Name: top
// Project Name: Keyboard
// Target Devices: Basys3
// Tool Versions: 2016.X
// Description: 
//     Receives input from USB-HID in the form of a PS/2, displays keyboard key presses and releases over USB-UART.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//     Known issue, when multiple buttons are pressed and one is released, the scan code of the one still held down is ometimes re-sent.
//////////////////////////////////////////////////////////////////////////////////


module top_keyboard(
    input wire logic clk,
    input wire logic PS2Data,
    input wire logic PS2Clk,
    output logic [7:0] ScanCode
);
    wire        tready;
    wire        ready;
    wire        tstart;
    reg         CLK50MHZ=0;
    reg  [15:0] keycodev=0;
    wire [15:0] keycode;
    reg  [ 2:0] bcount=0;
    wire        flag;
    reg         cn=0;
    
    always @(posedge(clk))begin
        CLK50MHZ<=~CLK50MHZ;
    end
    
    // gets data from the keybaord 
    PS2Receiver uut (
        .clk(CLK50MHZ),
        .kclk(PS2Clk),
        .kdata(PS2Data),
        .keycode(keycode), // scancode we get 
        .oflag(flag)
    );
    
    always@(keycode)
        if (keycode[7:0] == 8'hf0) begin
            cn <= 1'b0;
            bcount <= 3'd0; // no scan code to read 
        end else if (keycode[15:8] == 8'hf0) begin
            cn <= keycode != keycodev; // is our current scancode different than previous scancode
            bcount <= 3'd5; // how many bytes do we have 
        end else begin
            cn <= keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0;
            bcount <= 3'd2; // held down key but havent let up yet, 2 bytes to read 
        end
    
    always@(posedge clk)
        if (flag == 1'b1 && cn == 1'b1) ScanCode <= keycode[7:0]; // latch this value 
    
endmodule
