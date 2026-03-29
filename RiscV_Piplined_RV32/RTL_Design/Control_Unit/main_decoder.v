//
module main_decoder (
	input [6:0] op,
	output reg [1:0] ResultSrc,
	output reg MemWrite,
	output reg Branch, ALUSrc,
	output reg RegWrite, Jump,
	output reg [2:0] ImmSrc,
	output reg [1:0] ALUOp,
	output reg AOperand,
	output reg ForwardValMux,
	output reg Instruction_on);


	always@ * begin
	   ForwardValMux = 1'b0;
	   Instruction_on = 1'b1;
        case(op)
            7'b0000011: begin //I Type - load (100010010000)
                RegWrite = 1'b1;
                ImmSrc = 3'b000;
                ALUSrc = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b01;
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b0;
                AOperand = 1'b0;
            end
            7'b0100011: begin //S Type - store (000111000000)
                RegWrite = 1'b0;
                ImmSrc = 3'b001;
                ALUSrc = 1'b1;
                MemWrite = 1'b1;
                ResultSrc = 2'b00; //don't care
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b0;
                AOperand = 1'b0;
            end
            7'b0110011: begin //R-Type
                RegWrite = 1'b1;
                ImmSrc = 3'b000; //don't care
                ALUSrc = 1'b0; 
                MemWrite = 1'b0;
                ResultSrc = 2'b00;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
                AOperand = 1'b0;
            end
            7'b1100011: begin //beq
                RegWrite = 1'b0;
                ImmSrc = 3'b010;
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                ResultSrc = 2'b00; //don't care
                Branch = 1'b1;
                ALUOp = 2'b01;
                Jump = 1'b0;
                AOperand = 1'b0;
            end
            7'b0010011: begin //I Type ALU - (Like R Type with one imm operand)
                RegWrite = 1'b1;
                ImmSrc = 3'b000;
                ALUSrc = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b00; //don't care
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
                AOperand = 1'b0;
            end
            7'b1101111: begin //J Type - jal
                RegWrite = 1'b1;
                ImmSrc = 3'b011;
                ALUSrc = 1'b0; //don't care
                MemWrite = 1'b0;
                ResultSrc = 2'b10; //don't care
                Branch = 1'b0;
                ALUOp = 2'b00; //don't care 
                Jump = 1'b1;
                AOperand = 1'b0;
            end
            7'b0110111: begin // U Type - lui (used for creating large constants: lui -> addi lower bits)
                RegWrite = 1'b1;
                ImmSrc = 3'b100;
                ALUSrc = 1'b0; //don't care
                MemWrite = 1'b0; 
                ResultSrc = 2'b11;
                Branch = 1'b0;
                ALUOp = 2'b00; // don't care
                Jump = 1'b0;
                AOperand = 1'b0;
                ForwardValMux = 1'b1;
            end          
            7'b0010111: begin // U Type - auipc (used if function is far away: auipc ->jalr)
                RegWrite = 1'b1;
                ImmSrc = 3'b100;
                ALUSrc = 1'b1; 
                MemWrite = 1'b0;
                ResultSrc = 2'b00; 
                Branch = 1'b0;
                ALUOp = 2'b00; 
                Jump = 1'b0;    
                AOperand = 1'b1;
            end  
            default: begin
                RegWrite = 1'b0;
                ImmSrc = 3'b000;
                ALUSrc = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b0;
                AOperand = 1'b0;
                ForwardValMux = 1'b0;
                Instruction_on = 1'b0;
            end    
        endcase
        
    end
endmodule