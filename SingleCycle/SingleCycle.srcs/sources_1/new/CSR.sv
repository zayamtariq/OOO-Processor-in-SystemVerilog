`timescale 1ns / 1ps

// RISC-V PRIVELIGE LEVELS: 
// 00 -> USER 
// 01 -> SUPERVISOR
// 11 -> MACHINE 
// TODO: dedicated hardware to track what thread at what priv level?

// TODO: misa register to describe what ISA extensions are supported  

// for our purposes we don't need hypervisor level 

// TODO: hardcode TRAP values and register values necessary 

module CSR_File(
    input wire logic SwapCSR, 
    input wire logic [31:0] CSR_New, 
    output wire logic Temporary
    );

    // diff segments of this CSR are associated with 
    // unpriveliged, supervisors, hypervisor, and machine level 
    reg [31:0] ControlStatusRegisters [4095:0];  
    
endmodule

module CSRCompute(
    input wire logic [31:0] Temporary, 
    input wire logic [31:0] SR1_Value, 
    input wire logic [4:0] Immediate, 
    input wire logic [2:0] CSRType, 
    output     logic [31:0] CSR_New
    ); 
    
    always_comb begin 
        case (CSRType) 
            3'b000: CSR_New = SR1_Value; // CSRRW  
            3'b001: CSR_New = (Temporary | SR1_Value); // CSRRS
            3'b010: CSR_New = (Temporary & ~(SR1_Value)); // CSRRC 
            3'b011: CSR_New = {27'd0, Immediate}; // CSRRWI
            3'b100: CSR_New = (Temporary | {27'd0, Immediate}); // CSRRSI
            3'b101: CSR_New = (Temporary & ~{27'd0, Immediate}); // CSRRCI
            3'b110: ; // unused  
            3'b111: ; // unused 
        endcase
    end 
    
endmodule

module TemporaryRegister(
    input wire logic [31:0] CSR_to_Temp, 
    output logic [31:0] Temp_to_RegFile, 
    output logic [31:0] Temp_to_Compute
    ); 
    
    reg [31:0] TempRegister; 
    
    always_ff @ (CSR_to_Temp) begin 
        TempRegister <= CSR_to_Temp; 
    end
    
    assign Temp_to_RegFile = TempRegister; 
    assign Temp_to_Compute = TempRegister; 
    
endmodule 
