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
    output logic JAL, // TODO: get rid of this for WriteDRMux signal 
    output logic Unsigned_ALU, // new signal 
    output logic DataMem_isUnsigned, // new signal 
    output logic [1:0] Mult_Instruction, // new signal 
    output logic Div_Instruction, // new signal
    output logic Rem_Instruction, // new signal 
    output logic [1:0] InstructionType, // new signal 
    output logic [2:0] CSRType, // new signal 
    output logic SwapCSR // new signal  
    // TODO: incorporate the writedrmux signal
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
    
    // TODO: EXTEND THIS for LUI/AUIPC                    
    assign Immediate_Calc = (opcode == 7'b0010011 && (funct3 == 3'b101 || funct3 == 3'b001)) ? 3'b001 :                     
                            (opcode == 7'b0100011) ? 3'b010 : 
                            (opcode == 7'b1101111 || opcode == 7'b1100111) ? 3'b100 : 
                            (opcode == 7'b1100011) ? 3'b011 : 3'b000;
                            
    assign Write_Reg = (opcode == 7'b0010011 || opcode == 7'b0110011 || opcode == 7'b0000011) ? 1 : 0; 
    
    assign Write_Mem_Enable = (opcode == 7'b0100011) ? 1 : 0;
    
    assign B_H_W = (funct3 == 3'b000) ? 2'b01 : 
                   (funct3 == 3'b001) ? 2'b10 : 
                   (funct3 == 3'b010) ? 2'b11 : 2'b00; 
                   
    assign LD_or_ALU = (opcode == 7'b0000011) ? 1 : 0; // 1 for load instructions, 0 for alu instructions 
    
    assign JAL = (opcode == 7'b1101111 || opcode == 7'b1100111) ? 1 : 0; 
    
    assign Unsigned_ALU = (funct3 == 3'b011 && (opcode == 7'b0010011 || opcode == 7'b0110011)) ? 1 : 0; 
    
    assign DataMem_isUnsigned = ((opcode == 7'b0000011) && (funct3 == 3'b100 || funct3 == 3'b101));
                     
    assign Mult_Instruction = (funct3 == 3'b000) ? 2'b00 : 
                              (funct3 == 3'b001) ? 2'b01 :  
                              (funct3 == 3'b010) ? 2'b10 : 
                              (funct3 == 3'b011) ? 2'b11 : 2'b00; 
    
    assign Div_Instruction = (funct3 == 3'b100) ? 1'b0 : 
                             (funct3 == 3'b101) ? 1'b1 : 1'b0; 
                             
    assign Rem_Instruction = (funct3 == 3'b110) ? 1'b0 : 
                             (funct3 == 3'b111) ? 1'b1 : 1'b0;                          
    
    assign InstructionType = (opcode == 7'b0110011 && (funct3 == 3'b110 || funct3 == 3'b111) && funct7 == 7'b0000001) ? 2'b11 : // REM 
                              (opcode == 7'b0110011 && (funct3 == 3'b100 || funct3 == 3'b101) && funct7 == 7'b0000001) ? 2'b10 : // DIV 
                              (opcode == 7'b0110011 && (funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b010 || funct3 == 3'b011) && funct7 == 7'b0000001) ? 2'b01 : // MUL 
                              2'b00; // ALU/SHF
    
    assign CSRType = (opcode != 7'b1110011) ? 3'b111 : // 111 means NO CSR INSTRUCTION
                     (funct3 == 3'b001) ? 3'b000 :     // CSRRW
                     (funct3 == 3'b010) ? 3'b001 :     // CSRRS 
                     (funct3 == 3'b011) ? 3'b010 :     // CSRRC 
                     (funct3 == 3'b101) ? 3'b011 :     // CSRRWI 
                     (funct3 == 3'b110) ? 3'b100 :     // CSRRSI 
                     (funct3 == 3'b111) ? 3'b101 : 3'b111; // CSRRCI / NO CSR INSTRUCTION 
    
    assign SwapCSR = (opcode == 7'b1110011) ? 1 : 0; 
                           
endmodule
