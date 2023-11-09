`timescale 1ns / 1ps

module Top(
    input CLK
    );
    
    // CONTROL SIGNALS: 
    wire logic [2:0] ALUCode, PC_Select, Immediate_Calc; 
    wire logic [1:0] SHFCode, B_H_W; 
    wire logic Imm_or_Reg, Write_Reg, Write_Mem_Enable, LD_or_ALU, JAL, Unsigned_ALU, DataMem_isUnsigned; 
    
    // intermittent wires 
    wire logic [31:0] NextPC, PC_to_IMem, PC_PLUS_FOUR, PC_PLUS_OFFSET, Instruction_to_Decode, Immediate_Offset_Value;
    
    ControlStore cs(.opcode(Instruction_to_Decode[6:0]), 
                    .funct3(Instruction_to_Decode[14:12]), 
                    .funct7(Instruction_to_Decode[31:25]),
                    .ALUCode(ALUCode), 
                    .SHFCode(SHFCode), 
                    .Imm_or_Reg(Imm_or_Reg), 
                    .PC_Select(PC_Select), 
                    .Immediate_Calc(Immediate_Calc), 
                    .Write_Reg(Write_Reg), 
                    .Write_Mem_Enable(Write_Mem_Enable),
                    .B_H_W(B_H_W), 
                    .LD_or_ALU(LD_or_ALU), 
                    .JAL(JAL), 
                    .Unsigned_ALU(Unsigned_ALU), 
                    .DataMem_isUnsigned(DataMem_isUnsigned)); 
    
    TwoInputMux PCMux(.A(PC_PLUS_FOUR), .B(PC_PLUS_OFFSET), .CS(), .C(NextPC)); 
    
    Adder PC_Plus_Four(.input_one(PC_to_IMem), .input_two(32'd4), .adder_output(PC_PLUS_FOUR)); 
    Adder PC_Plus_Offset(.input_one(PC_to_IMem), .input_two(), .adder_output(PC_PLUS_OFFSET)); 
    
    PC program_counter(.CLK(CLK), .NextPC(NextPC), .PC_Value(PC_to_IMem)); 
    
    TwoInputMux JAL_or_WB(.A(PC_PLUS_FOUR), .B(), .CS(), .C()); 
    
    InstructionMemory i_mem(.PC_Address(PC_to_IMem), .Instruction(Instruction_to_Decode)); 
    
    ImmediateOffsetLogic imm_logic_block(.instruction(Instruction_to_Decode), .Immediate_Calc(), .Immediate_Offset(Immediate_Offset_Value)); 
    
    RegisterFile regfile(.CLK(CLK), 
                         .write_register(), 
                         .Register1(),
                         .Register2(), 
                         .DestinationRegister(), 
                         .write_register_data(), 
                         .Reg1_SrcA(), 
                         .Reg2_SrcB()); 
                         
    ALU alu_and_shf(.ALUCode(), 
                    .SHFCode(), 
                    .SrcA(), 
                    .SrcB(), 
                    .Unsigned_ALU(), 
                    .ALU_Result());                      
    
    BranchLogicBlock branch_logic_block(); 
    
    DataMemory d_mem(); 
    
    Imm_or_Reg_Mux imm_reg_mux(); 
    
endmodule
