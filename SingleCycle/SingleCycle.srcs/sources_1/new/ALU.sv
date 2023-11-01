`timescale 1ns / 1ps

module ALU(
    input wire logic [2:0] ALUCode, 
    input wire logic [1:0] SHFCode, // if shf is NOT 00, then this IS a shf unit
    input wire logic [31:0] SrcA, 
    input wire logic [31:0] SrcB, 
    output logic [31:0] ALU_Result 
    );
    
    // TODO: How do we account for signed/unsigned? 
    
    always_comb begin 
        case(SHFCode)  
        2'b00: begin // alu 
            case(ALUCode)
            3'b000: ALU_Result = SrcA + SrcB; // add SrcA + SrcB 
            3'b001: ALU_Result = SrcA - SrcB; // subtract SrcA - SrcB 
            3'b010: ALU_Result = SrcA & SrcB; // do SrcA & SrcB 
            3'b011: ALU_Result = SrcA ^ SrcB; // do SrcA ^ SrcB 
            3'b100: ALU_Result = SrcA | SrcB; // do SrcA | SrcB
            3'b101: ALU_Result = (SrcA < SrcB) ? 32'd1 : 32'd0; // SLT instructions 
            3'b110: ; // n/a (future use?) 
            3'b111: ; // n/a (future use?) 
            endcase
        end 
        2'b01: ;// shift left 
        2'b10: ;// shift right logical 
        2'b11: ;// shift right arithmetic 
        endcase
    end 
    
endmodule
