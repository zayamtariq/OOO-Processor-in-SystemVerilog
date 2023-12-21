`timescale 1ns / 1ps

module WriteDRMux(
    input wire logic [31:0] PC_PLUS_FOUR, 
    input wire logic [31:0] WriteBackData,
    input wire logic [31:0] AUIPC, 
    input wire logic [31:0] LUI, 
    input wire logic [1:0]  WriteDRMux_CSignal, // cs
    output     logic [31:0] DestinationRegisterValue        
    );
    
    always_comb begin 
        case (WriteDRMux_CSignal)  
            2'b00: DestinationRegisterValue = WriteBackData; // general instructions
            2'b01: DestinationRegisterValue = PC_PLUS_FOUR; // JAL
            2'b10: DestinationRegisterValue = AUIPC; // AUIPC
            2'b11: DestinationRegisterValue = LUI; // LUI               
        endcase
    end 
    
endmodule
