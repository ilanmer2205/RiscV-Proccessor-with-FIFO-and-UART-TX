
module alu_decoder (
 input [2:0] funct3,
 input [1:0] funct7b5,
 input [1:0] ALUOp,
 output reg [3:0] ALUControl);

	always@ * begin
        case(ALUOp)
            2'b00: //I Type load, S Type (calculate base address + offset)
                ALUControl= 4'b0000; // add (lw,sw)
            2'b01: // B Type
                case(funct3)
                    3'b000: ALUControl =  4'b0001; // beq 
                    3'b001: ALUControl = 4'b0001; // bne
                    3'b100: ALUControl = 4'b1000; // blt
                    3'b101: ALUControl = 4'b1000; // bge
                    3'b110: ALUControl= 4'b1001; // bltu
                    3'b111: ALUControl= 4'b1001; // bgeu
                    default: ALUControl= 4'b0000;
                endcase                  
            2'b10: // R Type, I Type ALU (both under 2'b10 because they require the same operations, difference is that one use a reg as the operand and the other use the imm)
                case(funct3)
                    3'b000: ALUControl = (funct7b5 == 2'b11) ? 4'b0001 /* sub*/ : 4'b0000; // add 
                    3'b001: ALUControl = 4'b0101; //sll
                    3'b010: ALUControl= 4'b1000; //slt
                    3'b011: ALUControl= 4'b1001; //sltu  
                    3'b100: ALUControl = 4'b0100; //xor 
                    3'b101: ALUControl = (funct7b5 == 2'b11) ? 4'b0111 /* sra*/ : 4'b0110; // srl                  
                    3'b110: ALUControl= 4'b0011; //or
                    3'b111: ALUControl= 4'b0010; //and
                    default: ALUControl= 4'b0000;
                endcase
            default: ALUControl= 4'b0000;
        endcase   
	end

endmodule





//module alu_decoder (
// input [2:0] funct3,
// input [1:0] funct7b5,
// input [1:0] ALUOp,
// output reg [2:0] ALUControl);

//	always@ * begin
//        case(ALUOp)
//            2'b00:
//                ALUControl= 3'b000; // add (lw,sw)
//            2'b01:
//                ALUControl= 3'b001; // sub (beq) 
//            default: 
//                case(funct3)
//                    3'b000:
//                        if(funct7b5 == 2'b11)
//                            ALUControl= 3'b001; //sub
//                        else // {funct7, op[5]} == 2'b00 | 2'b01 | 2'b10 )
//                            ALUControl= 3'b000; // add
//                    3'b010:
//                        ALUControl= 3'b101; //slt
//                    3'b110:
//                        ALUControl= 3'b011; //or
//                    3'b111:
//                        ALUControl= 3'b010; //and
//                    default: 
//                        ALUControl= 3'b000;
//                endcase
////            default:
////                ALUControl= 3'b000;
//        endcase   
//	end

//endmodule