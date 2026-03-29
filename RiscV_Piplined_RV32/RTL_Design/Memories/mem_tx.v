//FOR STORING. Put before the memory to let it know which part of the word to store in the memory
//can access only [7:0], [15:0], [31:0]
module mem_transmitter (
	input [31:0] store_data,
	input [1:0] Addr2Lsb,
	input [2:0] Func3,

	output reg [3:0] w_mask, //4 bits for each byte
	output reg [31:0] mem_wdata
	);

	wire mem_byte_access = (Func3[1:0] == 2'b00);
	wire mem_half_access = (Func3[1:0] == 2'b01);

	//create w_mask to choose the right location in the memory to store the word 
	always @(*) begin	
		if(mem_byte_access) 
			case (Addr2Lsb) //if we need to store a byte, choose which of the 4 bytes in the memory it will be stored to.
				2'b00: w_mask = 4'b0001; 
				2'b01: w_mask = 4'b0010;
				2'b10: w_mask = 4'b0100;
				2'b11: w_mask = 4'b1000;
			endcase	
		else
		if(mem_half_access)	//choose which half of the word to store 
			if(Addr2Lsb[1] == 0) w_mask = 4'b0011; 
			else 			     w_mask = 4'b1100;
		else w_mask = 4'b1111; //if niether is one so the whole word is required 	
	end	

	//create mem_wdata to save in the memory
	always @(*) begin
    if (mem_byte_access)
        mem_wdata = store_data << (8 * Addr2Lsb);
    else if (mem_half_access)
        mem_wdata = store_data << (16 * Addr2Lsb[1]);
    else
        mem_wdata = store_data;
end
endmodule



// //FOR STORING. Put before the memory to let it know which part of the word to store in the memory
// //can access only [7:0], [15:0], [31:0]
// module mem_transmitter (
// 	input [31:0] store_data,
// 	input [1:0] Addr2Lsb,
// 	input [2:0] func3,

// 	output reg [3:0] w_mask, //4 bits for each byte
// 	output reg [31:0] mem_wdata
// 	);

// 	wire mem_byte_access = (func3[1:0] == 2'b00);
// 	wire mem_half_access = (func3[1:0] == 2'b01);

// 	//create w_mask to choose the right location in the memory to store the word 
// 	always @(*) begin	
// 		if(mem_byte_access) 
// 			case (Addr2Lsb) //if we need to store a byte, choose which of the 4 bytes in the memory it will be stored to.
// 				2'b00: w_mask = 4'b0001; 
// 				2'b01: w_mask = 4'b0010;
// 				2'b10: w_mask = 4'b0100;
// 				2'b11: w_mask = 4'b1000;
// 			endcase	
// 		else
// 		if(mem_half_access)	//choose which half of the word to store 
// 			if(Addr2Lsb[1] == 0) w_mask = 4'b0011; 
// 			else 			     w_mask = 4'b1100;
// 		else w_mask = 4'b1111; //if niether is one so the whole word is required 	
// 	end	

// 	//create mem_wdata to save in the memory
// 	always @(*) begin
// 		case(Addr2Lsb) //where do we store the word in the memory.
// 			2'b00:	mem_wdata = store_data; //wether it is sb,sh,sw the w_mask will be according to the original order so no need to move them
// 			2'b01:	mem_wdata = {16'h0, store_data[7:0], 8'h0}; //bring byte to match the right mask
// 			2'b10:  mem_wdata = {store_data[15:0], 16'h0}; //now if we need to sb it's in the [x ,byte, 0, 0] and if we need to sh it's in [half, 0];   
// 			2'b11:	mem_wdata = {store_data[7:0], 24'h0};
// 		endcase
// 	end
// endmodule


