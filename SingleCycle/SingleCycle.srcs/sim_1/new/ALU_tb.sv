`timescale 1ns / 1ps

module ALU_tb();

// i want this model to send an instruction to the control store
// and have this control store to do the appropriate thing to the two operands 

// alu output 
logic [31:0] alu_result;

// alu inputs 
logic [31:0] SrcA, SrcB; 
  
// control store input: instruction 
logic [6:0] opcode;
logic [2:0] funct3; 
logic [6:0] funct7;  // THESE WILL BE WIRES IN FINAL DESIGN (for the sake of testing, logic) 

wire logic [2:0] ALUCode; 
wire logic [1:0] SHFCode; 
wire logic Unsigned_ALU; 

ControlStore cs(.opcode(opcode), 
                .funct3(funct3), 
                .funct7(funct7),
                .ALUCode(ALUCode), 
                .SHFCode(SHFCode), 
                .Unsigned_ALU(Unsigned_ALU)); 
                
                
ALU alu_test(.ALUCode(ALUCode), 
             .SHFCode(SHFCode), 
             .Unsigned_ALU(Unsigned_ALU), 
             .SrcA(SrcA), 
             .SrcB(SrcB), 
             .ALU_Result(alu_result));                 

initial begin  

    SrcB = 32'h80000000; // one signed value 
    SrcA = 32'h00000003; // one unsigned value 
    
        
    // ADD 
    
    opcode = 7'b0110011; 
    funct3 = 3'b000; 
    funct7 = 7'b0000000; 
    
        
    #100 
    
    // SUB 
    
    opcode = 7'b0110011; 
    funct3 = 3'b000; 
    funct7 = 7'b0100000; 
    
        #100 
    
    // AND 
    
    opcode = 7'b0110011; 
    funct3 = 3'b111; 
    funct7 = 7'b0000000; 
    
    #100 
    
    // XOR 
    
    opcode = 7'b0110011; 
    funct3 = 3'b100; 
    funct7 = 7'b0000000; 
    
    #100 
    
    // OR  
    
    opcode = 7'b0110011; 
    funct3 = 3'b110; 
    funct7 = 7'b0000000; 
    
    #100 
    
    // SRA  
    
    opcode = 7'b0110011; 
    funct3 = 3'b101; 
    funct7 = 7'b0100000; 
    
    #100 
    
    // SRL 
    
    opcode = 7'b0110011; 
    funct3 = 3'b101; 
    funct7 = 7'b0000000; 
    
    #100 
    
    // SLL 
    
    opcode = 7'b0110011; 
    funct3 = 3'b001; 
    funct7 = 7'b0000000; 
    
    #100 
    
    // SLT 
     
    opcode = 7'b0110011; 
    funct3 = 3'b010; 
    
    #100 
    
    // SLT unsigned 
    
    opcode = 7'b0110011; 
    funct3 = 3'b011; 
    
    #100 
    
    $finish;  
    
    
end 


endmodule
