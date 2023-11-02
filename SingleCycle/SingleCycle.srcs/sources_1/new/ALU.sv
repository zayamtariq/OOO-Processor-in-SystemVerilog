`timescale 1ns / 1ps

module ALU(
    input wire logic [2:0] ALUCode, 
    input wire logic [1:0] SHFCode, // if shf is NOT 00, then this IS a shf unit
    input wire logic [31:0] SrcA, 
    input wire logic [31:0] SrcB,
    input wire logic Unsigned_ALU,  // control signal here too
    output logic [31:0] ALU_Result 
    );
    
    // TODO: How do we account for signed/unsigned? 
    // we only need to account for them in SLT instructions (as far as ALU is concerned) 
    
    always_comb begin 
        case(SHFCode)  
        2'b00: begin // alu 
            case(ALUCode)
            3'b000: ALU_Result = SrcA + SrcB; // add SrcA + SrcB 
            3'b001: ALU_Result = SrcA - SrcB; // subtract SrcA - SrcB 
            3'b010: ALU_Result = SrcA & SrcB; // do SrcA & SrcB 
            3'b011: ALU_Result = SrcA ^ SrcB; // do SrcA ^ SrcB 
            3'b100: ALU_Result = SrcA | SrcB; // do SrcA | SrcB
            3'b101: 
            begin
                // both are treated as unsigned numbers 
                if (Unsigned_ALU) ALU_Result = (SrcA < SrcB) ? 32'd1 : 32'd0; // SLT instructions
                else begin 
                    // BOTH are treated as signed numbers 
                    // ALU_Result =  
                    if (SrcA[31] == SrcB[31]) begin 
                        ALU_Result = (SrcA[30:0] < SrcB[30:0]) ? 32'd1 : 32'd0;  
                    end else begin 
                        ALU_Result = (SrcB[31] == 1'b1) ? 32'd0 : 32'd1; 
                    end 
                end 
            end 
            3'b110: ; // n/a (future use?) 
            3'b111: ; // n/a (future use?) 
            endcase
        end 
        2'b01: ALU_Result = SrcA << SrcB[4:0];// shift left 
        2'b10: ALU_Result = SrcA >> SrcB[4:0];// shift right logical 
        2'b11: ALU_Result = SrcA >>> SrcB[4:0];// shift right arithmetic 
        endcase
    end 
    
endmodule
