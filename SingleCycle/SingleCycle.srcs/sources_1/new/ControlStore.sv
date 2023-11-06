`timescale 1ns / 1ps

module ControlStore(
    input wire logic [6:0] opcode, 
    input wire logic [2:0] funct3, 
    input wire logic [6:0] funct7,  
    output logic [2:0] ALUCode, 
    output logic [1:0] SHFCode, 
    output logic Imm_or_Reg, 
    output logic [2:0] PC_Select, 
    output logic [2:0] Immediate_Calc, 
    output logic Write_Reg, 
    output logic Write_Mem_Enable, 
    output logic [1:0] B_H_W, 
    output logic LD_or_ALU, 
    output logic JAL,  
    output logic Unsigned_ALU // <--- NEED TO FIGURE THIS OUT EVENTUALLY! (nicer way to do this?)
    // need an unsigned CS signal for Data Memory 
    );
    
    assign ALUCode = (opcode == 7'b0110011 && funct3 == 3'b000 && funct7 == 7'b0100000) ? 3'b001 : // sub
                     ((opcode == 7'b0110011 || opcode == 7'b0010011) && funct3 == 3'b000) ? 3'b000 : // add
                     ((opcode == 7'b0110011 || opcode == 7'b0010011) && funct3 == 3'b111) ? 3'b010 : // and
                     ((opcode == 7'b0110011 || opcode == 7'b0010011) && funct3 == 3'b100) ? 3'b011 : // xor 
                     ((opcode == 7'b0110011 || opcode == 7'b0010011) && funct3 == 3'b110) ? 3'b100 : // or 
                     ((opcode == 7'b0110011 || opcode == 7'b0010011) && (funct3 == 3'b010 || funct3 == 3'b011)) ? 3'b101 : 3'b000; // set less than / don't care  
    
    assign SHFCode = (funct3 == 3'b001) ? 2'b01 : 
                     (funct3 == 3'b101 && (funct7 == 7'b0000000 || funct7 == 7'b0000001)) ? 2'b10 : 
                     (funct3 == 3'b101 && (funct7 == 7'b0100000 || funct7 == 7'b0100001)) ? 2'b11 : 2'b00; 
    
    // immediate/offset happens during imm instructions OR when load/store instruction needs offset 
    assign Imm_or_Reg = (opcode[5] == 1'b0 || (opcode == 7'b0100011)) ? 1 : 0; 
    
    assign PC_Select = (opcode == 7'b1101111 || opcode == 7'b1100111) ? 3'b001 : // jal/jalr
                       (opcode == 7'b1100011 && funct3 == 3'b000)     ? 3'b010 : // beq 
                       (opcode == 7'b1100011 && funct3 == 3'b001)     ? 3'b011 : // bne 
                       (opcode == 7'b1100011 && funct3 == 3'b100)     ? 3'b100 : // blt 
                       (opcode == 7'b1100011 && funct3 == 3'b101)     ? 3'b101 : // bge 
                       (opcode == 7'b1100011 && funct3 == 3'b110)     ? 3'b110 : // bltu 
                       (opcode == 7'b1100011 && funct3 == 3'b111)     ? 3'b111 : 3'b000; // bgeu, don't care 
                       
    assign Immediate_Calc = (opcode == 7'b0010011 && (funct3 == 3'b101 || funct3 == 3'b001)) ? 3'b001 :                     
                            (opcode == 7'b0100011) ? 3'b010 : 
                            (opcode == 7'b1101111 || opcode == 7'b1100111) ? 3'b100 : 
                            (opcode == 7'b1100011) ? 3'b011 : 3'b000;
                            
    assign Write_Reg = (opcode == 7'b0010011 || opcode == 7'b0110011 || opcode == 7'b0000011) ? 1 : 0; 
    
    assign Write_Mem_Enable = (opcode == 7'b0100011) ? 1 : 0;
    
    assign B_H_W = (funct3 == 3'b000) ? 2'b01 : 
                   (funct3 == 3'b001) ? 2'b10 : 
                   (funct3 == 3'b010) ? 2'b11 : 2'b00; 
                   
    assign LD_or_ALU = (opcode == 7'b0000011) ? 1 : 0; 
    
    assign JAL = (opcode == 7'b1101111 || opcode == 7'b1100111) ? 1 : 0; 
    
    assign Unsigned_ALU = (funct3 == 3'b011 && (opcode == 7'b0010011 || opcode == 7'b0110011)) ? 1 : 0; 
                     
endmodule
