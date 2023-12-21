`timescale 1ns / 1ps

// RISC-V PRIVELIGE LEVELS: 
// 00 -> USER 
// 01 -> SUPERVISOR
// 11 -> MACHINE 
// TODO: dedicated hardware to track what thread at what priv level?

// TODO: misa register to describe what ISA extensions are supported  

module CSR_File(
    input wire logic SwapCSR, // Control Signal 
    input wire logic CLK, 
    input wire logic [11:0] CSR_Index, 
    
    input wire logic [31:0] SR1_Value, 
    input wire logic [4:0] Immediate, 
    input wire logic [2:0] CSRType, // Control Signal 
    
    output     logic [31:0] Temporary,
    output     logic        RegFileSwapCSR   // Control Signal we send to Register File 
    );

    // diff segments of this CSR are associated with 
    // unpriveliged, supervisors, and machine level 
    reg [31:0] ControlStatusRegisters [4095:0];  // 4096-entry, 32-bit per entry
    
    initial begin 
        // hardcoded CSR values here 
    end 
    
    always_ff @ (posedge CLK) begin 
        if (SwapCSR == 1'b1) begin 
            // 1. get the t value that we send out to the register file 
            Temporary = ControlStatusRegisters[CSR_Index]; 
            
            // 2. and then update csr value based on t / register value / immediate value  
            case (CSRType) 
                3'b000: ControlStatusRegisters[CSR_Index] = SR1_Value; // CSRRW  
                3'b001: ControlStatusRegisters[CSR_Index] = (Temporary | SR1_Value); // CSRRS
                3'b010: ControlStatusRegisters[CSR_Index] = (Temporary & ~(SR1_Value)); // CSRRC 
                3'b011: ControlStatusRegisters[CSR_Index] = {27'd0, Immediate}; // CSRRWI
                3'b100: ControlStatusRegisters[CSR_Index] = (Temporary | {27'd0, Immediate}); // CSRRSI
                3'b101: ControlStatusRegisters[CSR_Index] = (Temporary & ~{27'd0, Immediate}); // CSRRCI
                3'b110: ; // unused  
                3'b111: ; // unused 
            endcase 
            
            // 3. (in register file) write "Temporary" to desired destination register 
            RegFileSwapCSR <= 1'b1; 
        end else begin 
            RegFileSwapCSR <= 1'b0; 
        end 
    end 
    
endmodule