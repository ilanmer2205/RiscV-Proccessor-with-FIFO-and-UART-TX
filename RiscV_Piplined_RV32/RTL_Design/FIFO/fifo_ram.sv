module fifo_ram #(FIFO_DEPTH = 32, FIFO_WIDTH=32)
	(
	input logic clk,
	input logic rst_n,
	input logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr,
	input logic [$clog2(FIFO_DEPTH)-1:0] rd_ptr,
	input logic wr_en,
	input logic [31:0] data_in,

	output logic [31:0] data_out
	);

	logic [FIFO_DEPTH-1:0] fifo_mem [FIFO_WIDTH-1:0];
	integer i;
	always_ff @(posedge clk) begin
		if(rst_n) begin
			for(i=0; i<FIFO_DEPTH-1; i=i+1) begin
				fifo_mem[i]<= 0;
			end
		end
		else if(wr_en) begin
			fifo_mem[wr_ptr] <= data_in;
		end
	end

	assign data_out = fifo_mem[rd_ptr];

endmodule : fifo_ram