///FOR LOADING. Put module after the memory inputs
module mem_receiver(
	input [31:0] read_data,
	input [1:0] Addr2Lsb,
	input [2:0] Func3,
	output reg [31:0] load_word
	);

	wire [15:0] half_data;
	wire [7:0] byte_data;
	wire mem_byte_access, mem_half_access;
	wire load_sign;
    wire extent_type;
    
	assign mem_byte_access = (Func3[1:0] == 2'b00);
	assign mem_half_access = (Func3[1:0] == 2'b01);
	assign extent_type = Func3[2]; 

	//bit 1 responsible for half word addresing
	assign half_data = Addr2Lsb[1] ? read_data[31:16] : read_data[15:0];
	//bit 0 and 1 are responsible fot byte addresing; can use half_data as it already represent addr[1];
	assign byte_data = Addr2Lsb[0] ? half_data[15:8] : half_data[7:0];
	//check what type of extend is needed. if sign extend (ex. lb) than expression below, if zero extend (ex. lbu) then !Func3 will make it 0; 
	assign load_sign = !extent_type & (mem_byte_access ? byte_data[7] : half_data[15]);
	//load byte/half word/word and extend it accordingly
	always @(*) begin
		if(mem_byte_access)
			load_word = {{24{load_sign}}, byte_data};
		else if(mem_half_access)
			load_word = {{16{load_sign}}, half_data};
		else
			load_word = read_data;
	end
endmodule


