module Branch_Control(

	input BranchE, JumpE,
	input Zero,
	input [2:0] func3E,

	output PCSrcE

	);

	reg en_branch;

	always @(*) begin
		en_branch = 1'b0; // Default
		case(func3E)
			3'b000: en_branch = (Zero == 1) ? 1'b1 : 1'b0; //beq
			3'b001: en_branch = (Zero == 0) ? 1'b1 : 1'b0; // bne
			3'b100: en_branch = (Zero == 0) ? 1'b1 : 1'b0; // blt    
			3'b101: en_branch = (Zero == 1) ? 1'b1 : 1'b0; // bge
			3'b110: en_branch = (Zero == 0) ? 1'b1 : 1'b0; // bltu
			3'b111: en_branch = (Zero == 1) ? 1'b1 : 1'b0; // bgeu
			////// In cases 4-7 the Zero represents the ALUResult after slt/sltu
		endcase

	end


	assign PCSrcE = (BranchE & en_branch) | (JumpE);


endmodule