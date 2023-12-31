`timescale 1ns / 1ps

// two entries in register aliasing table: 
// a bit to represent if pointing to ROB or architectural register file
// a pointer to latest ROB entry (if pointing to ROB) 
// tentative: 128 entry [7 bit indexing] ROB 

// output: address of where SR1 and SR2 are currently located (ROB or ARF, and which entry?)
// and also to allocate the DR in the ROB (create a new address for it if possible, set ROB_or_ARF to 1, etc.) 

// address outputs sent through an arbiter to determine if going to LD/ST queue or Issue Queue 

module RegisterAliasingTable(

    /* inputs */
    input wire logic CLK, 
    input wire logic [4:0] SR1_Bits, 
    input wire logic [4:0] SR2_Bits, 
    input wire logic [4:0] DR_Bits,
    // input control signals below 
    input wire logic imm_or_reg, // 1 for immediate, 0 for reg 
    input wire logic ST_or_DR,   // 1 for store instruction, 0 for dest. reg writeback
    // input control signals above
    input wire logic [6:0] Issue_Ptr, 
    input wire logic [6:0] Commit_Ptr, 
    
    /* outputs */ 
    output logic [6:0] SR1_Address, 
    output logic [6:0] SR2_Address, 
    output logic [6:0] DR_Address, 
    // output control signals below 
    output logic Issue_Plus_One, // control signal to send to the ROB 
    output logic Read_Reg1,
    output logic Read_Reg2 // control signals to send to the queue 
    );
    
    logic ROB_or_ARF [31:0]; // 1 for ROB, 0 for ARF (32 entries for this) 
    logic [6:0] ROB_Address [31:0]; // xFFFFFFFF if no entry to ROB (32 entries in RAT, 7 bit wide addressing for 128 entry ROB) 
    
    always_ff @ (posedge CLK) begin 
        // simple reading logic: 
        SR1_Address <= (ROB_or_ARF[SR1_Bits]) ? ROB_Address[SR1_Bits] : 7'd0;
        SR2_Address <= (imm_or_reg) ? 7'd0 : 
                       (ROB_or_ARF[SR2_Bits]) ? ROB_Address[SR2_Bits] : 7'd0; // if not in ROB, populate with xFFFFFFFF so we can ignore dat ish
        Read_Reg1 <= ~(ROB_or_ARF[SR1_Bits]); 
        Read_Reg2 <= ~(ROB_or_ARF[SR2_Bits]); 
        // write logic 
        // issue ptr at start is always pointing to an open entry 
        if (ST_or_DR == 1'b0) begin // if writing to a destination register 
            ROB_Address[DR_Bits] <= Issue_Ptr; 
            ROB_or_ARF[DR_Bits] <= 1; 
            DR_Address <= Issue_Ptr; // TODO: should DR_Address always be sent out, even for stores? (so we know which ROB address to send branch address to?) 
        end 
        // stores are somewhat isolated
        // the only "dependency" we need to worry about ^ is making sure all loads and stores are in order 
        Issue_Plus_One <= 1; // this will always happen 
    end 
    
    always @ (Commit_Ptr) begin 
        // we can find the address in the ROB_Address table 
        // and we can do some logic to get back to necessary architectural state 
    end 
    
endmodule
