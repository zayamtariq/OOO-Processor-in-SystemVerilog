`timescale 1ns / 1ps

module Top(
    input CLK, 
    output logic [31:0] DataWrittenBack
    );
    
    // CONTROL SIGNALS: 
    wire logic [2:0] ALUCode, PC_Select, Immediate_Calc; 
    wire logic [1:0] SHFCode, B_H_W, Mult_Instruction, InstructionType; 
    wire logic Imm_or_Reg, Write_Reg, Write_Mem_Enable, LD_or_ALU, JAL, Unsigned_ALU, DataMem_isUnsigned, Div_Instruction, Rem_Instruction; 
    
    // intermittent wires 
    wire logic [31:0] NextPC, PC_to_IMem, PC_PLUS_FOUR, PC_PLUS_OFFSET, Instruction_to_Decode, Immediate_Offset_Value, SrcA_to_EXE, Reg2_to_Mux, SrcB_to_EXE, ALUResult_to_ExeMux, MULResult_to_ExeMux, DIVResult_to_ExeMux, REMResult_to_ExeMux, EXEMUX_Result_to_DataMemory, Data_from_DataMemory, WriteBack_Data, Data_to_DestinationRegister;
    wire logic ActualPC_CS; 
    
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
                    .DataMem_isUnsigned(DataMem_isUnsigned),
                    .Mult_Instruction(Mult_Instruction), 
                    .Div_Instruction(Div_Instruction),
                    .Rem_Instruction(Rem_Instruction),
                    .InstructionType(InstructionType)); 
    
    PCMux PC_Mux(.plus_four(PC_PLUS_FOUR), .plus_offset(PC_PLUS_OFFSET), .pc_cs(ActualPC_CS), .next_pc(NextPC)); 
    
    Adder PC_Plus_Four(.input_one(PC_to_IMem), .input_two(32'd4), .adder_output(PC_PLUS_FOUR)); 
    Adder PC_Plus_Offset(.input_one(PC_to_IMem), .input_two(Immediate_Offset_Value), .adder_output(PC_PLUS_OFFSET)); 
    
    PC program_counter(.CLK(CLK), .NextPC(NextPC), .PC_Value(PC_to_IMem)); 
    
    TwoInputMux JAL_or_WB(.A(PC_PLUS_FOUR), .B(WriteBack_Data), .CS(JAL), .C(Data_to_DestinationRegister)); 
    
    InstructionMemory i_mem(.CLK(CLK), .PC_Address(PC_to_IMem), .Instruction(Instruction_to_Decode)); 
    
    ImmediateOffsetLogic imm_logic_block(.instruction(Instruction_to_Decode), 
                                         .Immediate_Calc(Immediate_Calc), 
                                         .Immediate_Offset(Immediate_Offset_Value)); 
    
    RegisterFile regfile(.CLK(CLK), 
                         .write_register(Write_Reg), 
                         .Register1(Instruction_to_Decode[19:15]),
                         .Register2(Instruction_to_Decode[24:20]), 
                         .DestinationRegister(Instruction_to_Decode[11:7]), 
                         .write_register_data(Data_to_DestinationRegister), 
                         .Reg1_SrcA(SrcA_to_EXE), 
                         .Reg2_SrcB(Reg2_to_Mux)); 
                         
    ALU alu_and_shf(.ALUCode(ALUCode), 
                    .SHFCode(SHFCode), 
                    .SrcA(SrcA_to_EXE), 
                    .SrcB(SrcB_to_EXE), 
                    .Unsigned_ALU(Unsigned_ALU), 
                    .ALU_Result(ALUResult_to_ExeMux));                      
    
    BranchLogicBlock branch_logic_block(.R1_Value(SrcA_to_EXE), 
                                        .R2_Value(Reg2_to_Mux), 
                                        .PC_Select(PC_Select), 
                                        .PCMux_CS(ActualPC_CS)); 
    
    Divider div(.SrcA(SrcA_to_EXE),
                .SrcB(SrcB_to_EXE),
                .Div_Instruction(Div_Instruction), 
                .Quotient(DIVResult_to_ExeMux)); 
    
    Multiplier mul(.SrcA(SrcA_to_EXE), 
                   .SrcB(SrcB_to_EXE),
                   .Mult_Instruction(Mult_Instruction),
                   .Product(MULResult_to_ExeMux)); 
    
    Remainder rem_calc(.SrcA(SrcA_to_EXE), 
                       .SrcB(SrcB_to_EXE), 
                       .Rem_Instruction(Rem_Instruction),
                       .Modulus(REMResult_to_ExeMux)); 
    
    Execution_Mux exe_mux(.InstructionType(InstructionType),
                          .ALU_Result(ALUResult_to_ExeMux), 
                          .MUL_Result(MULResult_to_ExeMux), 
                          .DIV_Result(DIVResult_to_ExeMux), 
                          .REM_Result(REMResult_to_ExeMux),
                          .EXE_Result(EXEMUX_Result_to_DataMemory)); 
    
    DataMemory d_mem(.CLK(CLK),
                     .address(EXEMUX_Result_to_DataMemory), 
                     .write_data(Reg2_to_Mux), 
                     .memory_write_enable(Write_Mem_Enable), 
                     .B_H_W(B_H_W), 
                     .is_unsigned(DataMem_isUnsigned),
                     .read_data(Data_from_DataMemory)); 
    
    TwoInputMux LD_or_ALU_Mux(.A(Data_from_DataMemory), .B(EXEMUX_Result_to_DataMemory), .CS(LD_or_ALU), .C(WriteBack_Data)); 
    
    Imm_or_Reg_Mux imm_reg_mux(.Imm_or_Reg(Imm_or_Reg),
                               .Reg2(Reg2_to_Mux),
                               .Immediate(Immediate_Offset_Value), 
                               .SrcB(SrcB_to_EXE)); 
    
    assign DataWrittenBack = Data_to_DestinationRegister; 
    
endmodule
    