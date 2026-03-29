module fifo_controller #(FIFO_DEPTH = 32) 
	(
	input logic clk, 
	input logic rst_n,
	input logic wr_en,
	input logic rd_en,

	output logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr,
	output logic [$clog2(FIFO_DEPTH)-1:0] rd_ptr,
	output logic empty,
	output logic full,
	output logic am_full
	);

	logic last_was_read;

    // Define a variable to hold the number of items. 
    // It must be 1 bit wider than pointers to hold the value 'FIFO_DEPTH' (e.g. 32).
    logic [$clog2(FIFO_DEPTH):0] fill_level;
    
    // Intermediate signal for pointer difference to ensure correct 5-bit wrap-around math
    logic [$clog2(FIFO_DEPTH)-1:0] ptr_diff;

	///if either rd_en or wr_en so increment the appropriate ptr.
	always_ff @(posedge clk) begin 
		if(rst_n) begin
			 rd_ptr <= 0;
			 wr_ptr <= 0;
		end
		else begin 
			if (rd_en) begin
				rd_ptr <= rd_ptr + 1'b1;
			end
			if (wr_en) begin
				 wr_ptr<= wr_ptr + 1'b1;
			end
		end
	end

	/// logic for last_was read
	/// Give priority to read operation over write operation
	always_ff @(posedge clk) begin 
		if(rst_n) begin
			last_was_read <= 1'b1;
		end
		else begin 
			if (rd_en) begin
				last_was_read <= 1'b1;
			end
			else if (wr_en) begin
				 last_was_read <= 1'b0;
			end
		end
	end

    // 1. Calculate raw pointer difference using pointer width (e.g. 5 bits).
    //    This forces correct modulo arithmetic (wrap-around).
    assign ptr_diff = wr_ptr - rd_ptr;

    // 2. Calculate true fill level (extended width e.g. 6 bits).
    //    If full, manual override to FIFO_DEPTH. Otherwise use ptr_diff.
    always_comb begin
        if (full) begin
            fill_level = FIFO_DEPTH;
        end else begin
            fill_level = ptr_diff; // Zero-extends automatically
        end
    end

	assign empty = (rd_ptr == wr_ptr) && last_was_read;

	assign full = (rd_ptr == wr_ptr) && !last_was_read;

	// High whenever we have 4 or fewer slots available (Occupancy >= 28)
	// We choose 4 because when we stall we have to save data from the writeback stage down to the excecute stage, totalling in 3 stages + 1 for safety
    assign am_full = (fill_level >= (FIFO_DEPTH - 4));

endmodule : fifo_controller