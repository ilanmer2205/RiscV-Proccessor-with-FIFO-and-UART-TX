
module extend(
    input [31:7] Instr, //input from Instruction Memory
    input [2:0] ImmSrc, //input from control
    output [31:0] ImmExt
    );
    
    
    assign ImmExt = (ImmSrc==3'b000) ? {{20{Instr[31]}}, Instr[31:20]}: // I type
                    (ImmSrc==3'b001) ? {{20{Instr[31]}}, Instr[31:25], Instr[11:7]}: // S type
                    (ImmSrc==3'b010) ? {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0}: // B type
                    (ImmSrc==3'b011) ? {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0}: // J type
                    (ImmSrc==3'b100) ? {Instr[31:12], 12'b0}:  // U type            
                    32'h0;
endmodule

//For B Type and J Type we add '0' at ImmExt[0], because we dont need to address individual bits, but rather bytes.
//Doing that allows us to use one more bit to access wider range of addresses 
//For this design we can add '0' at ImmExt[0] as well (which is done in MIPS), but RiscV processor is designed to support 16-bit compressed instructions (C extension).