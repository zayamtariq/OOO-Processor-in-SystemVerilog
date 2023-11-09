`timescale 1ns / 1ps

// there are 32 entries in the register file 

module RegisterFile(
    input wire logic CLK, // not sure if clock is necessarily a wire (from the perspective of the reg file, it is) 
    input wire logic write_register, // cs signal 
    input wire logic [4:0] Register1, Register2, DestinationRegister, // 2 ^ 5 = 32 entries 
    input wire logic [31:0] write_register_data, 
    output logic [31:0] Reg1_SrcA, Reg2_SrcB  
    );
    
    reg [31:0] registers [31:0]; // 32 bit, 32-entry register file 
    
    // should initialize all regs that are hard coded (e.g. R0 always = 0)
    initial begin 
        registers[0] = 32'd0;         
    end 
    
    // we will just be constantly reading, reading doesn't rely on clock or any signal 
    always_comb begin 
        Reg1_SrcA = registers[Register1]; 
        Reg2_SrcB = registers[Register2];  
    end 
    
    // at every clock edge we're checking for write register signal 
    always_ff @ (posedge CLK) begin 
        if (write_register == 1'b1 && DestinationRegister != 5'd0) begin // we can't write to register 0 
            registers[DestinationRegister] <= write_register_data;  
        end  
    end 
    
endmodule
