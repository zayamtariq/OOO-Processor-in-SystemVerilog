`timescale 1ns / 1ps

module Top(
    input CLK
    );
    
    // CONTROL SIGNALS: 
    wire logic [2:0] ALUCode, PC_Select, Immediate_Calc; 
    wire logic [1:0] SHFCode, B_H_W; 
    wire logic Imm_or_Reg, Write_Reg, Write_Mem_Enable, LD_or_ALU, JAL, Unsigned_ALU, DataMem_isUnsigned; 
    
    // intermittent wires 
    wire logic [31:0] NextPC, PC_to_IMem, PC_PLUS_FOUR, PC_PLUS_OFFSET, Instruction_to_Decode, Immediate_Offset_Value, SrcA_to_ALU, Reg2_to_Mux, SrcB_to_ALU, ALUResult_to_DataMemory, Data_from_DataMemory, WriteBack_Data, Data_to_DestinationRegister;
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
                    .DataMem_isUnsigned(DataMem_isUnsigned)); 
    
    TwoInputMux PCMux(.A(PC_PLUS_FOUR), .B(PC_PLUS_OFFSET), .CS(ActualPC_CS), .C(NextPC)); 
    
    Adder PC_Plus_Four(.input_one(PC_to_IMem), .input_two(32'd4), .adder_output(PC_PLUS_FOUR)); 
    Adder PC_Plus_Offset(.input_one(PC_to_IMem), .input_two(Immediate_Offset_Value), .adder_output(PC_PLUS_OFFSET)); 
    
    PC program_counter(.CLK(CLK), .NextPC(NextPC), .PC_Value(PC_to_IMem)); 
    
    TwoInputMux JAL_or_WB(.A(PC_PLUS_FOUR), .B(WriteBack_Data), .CS(JAL), .C(Data_to_DestinationRegister)); 
    
    InstructionMemory i_mem(.PC_Address(PC_to_IMem), .Instruction(Instruction_to_Decode)); 
    
    ImmediateOffsetLogic imm_logic_block(.instruction(Instruction_to_Decode), 
                                         .Immediate_Calc(Immediate_Calc), 
                                         .Immediate_Offset(Immediate_Offset_Value)); 
    
    RegisterFile regfile(.CLK(CLK), 
                         .write_register(Write_Register), 
                         .Register1(Instruction_to_Decode[19:15]),
                         .Register2(Instruction_to_Decode[24:20]), 
                         .DestinationRegister(Instruction_to_Decode[11:7]), 
                         .write_register_data(Write_Reg), 
                         .Reg1_SrcA(SrcA_to_ALU), 
                         .Reg2_SrcB(Reg2_to_Mux)); 
                         
    ALU alu_and_shf(.ALUCode(ALUCode), 
                    .SHFCode(SHFCode), 
                    .SrcA(SrcA_to_ALU), 
                    .SrcB(SrcB_to_ALU), 
                    .Unsigned_ALU(Unsigned_ALU), 
                    .ALU_Result(ALUResult_to_DataMemory));                      
    
    BranchLogicBlock branch_logic_block(.R1_Value(SrcA_to_ALU), 
                                        .R2_Value(Reg2_to_Mux), 
                                        .PC_Select(PC_Select), 
                                        .PCMux_CS(ActualPC_CS)); 
    
    DataMemory d_mem(.CLK(CLK),
                     .address(ALUResult_to_DataMemory), 
                     .write_data(Reg2_to_Mux), 
                     .memory_write_enable(Write_Mem_Enable), 
                     .B_H_W(B_H_W), 
                     .is_unsigned(DataMem_isUnsigned),
                     .read_data(Data_from_DataMemory)); 
    
    TwoInputMux LD_or_ALU_Mux(.A(ALUResult_to_DataMemory), .B(Data_from_DataMemory), .CS(LD_or_ALU), .C(WriteBack_Data)); 
    
    Imm_or_Reg_Mux imm_reg_mux(.Imm_or_Reg(Imm_or_Reg),
                               .Reg2(Reg2_to_Mux),
                               .Immediate(Immediate_Offset_Value), 
                               .SrcB(SrcB_to_ALU)); 
    
endmodule
