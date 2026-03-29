
module bytewrite_tdp_ram_nc
#(
//---------------------------------------------------------------
parameter NUM_COL = 4,
parameter COL_WIDTH = 8,
parameter ADDR_WIDTH = 6, // Addr Width in bits : 2**ADDR_WIDTH = RAM Depth
parameter DATA_WIDTH = NUM_COL*COL_WIDTH // Data Width in bits
//---------------------------------------------------------------
) (
input clkA,
input enA,
input [NUM_COL-1:0] weA,
input [ADDR_WIDTH-1:0] addrA,
input [DATA_WIDTH-1:0] dinA,
output [DATA_WIDTH-1:0] doutA
);

wire [5:0] addr = {addrA[5:2] , 2'b00};
// Core Memory
reg [DATA_WIDTH-1:0] ram_block [(2**ADDR_WIDTH)-1:0];


	integer i;

    initial begin
        for (i = 0; i < (1 << ADDR_WIDTH); i = i + 1)
            ram_block[i] = {DATA_WIDTH{1'b0}};
    end

    
	always @ (posedge clkA) begin
		if(enA) begin
			for(i=0; i<NUM_COL; i=i+1) begin
				if(weA[i]) begin
					ram_block[addr][i*COL_WIDTH +: COL_WIDTH] <= dinA[i*COL_WIDTH +: COL_WIDTH];
				end
			end
		end
	end


assign doutA = ram_block[addr];

endmodule 


// //memory should have changed if weA has changed
// property mask_check;
// 		@(posedge clk) disable iff(reset) 
// 			!($stable(weA)) |-> #1 !($stable(ram_block[$past(addr)]));	
// endproperty	
// mask_check0: assert property(mask_check);

// //
// //check if the new data that loaded into the memory outputs it correctly
// property check_word_write;
// 		@(posedge clk) disable iff(reset) 
// 			!($stable(weA) #1 $stable(ram_block)) |-> #1 (ram_block[$past(addr)] == doutA); 	
// endproperty	
// check_word_write0: assert property(check_word_write);

// initial begin
// 	for(i=0; i<NUM_COL; i=i+1) begin

// 	end

// end
// ////check if the new data that loaded into the memory is the right input
// property check_word_write;
// 		@(posedge clk) disable iff(reset) 
// 			!($stable(weA) #1 $stable(ram_block)) |-> #1 (ram_block[$past(addr)] == $past(dinA); 	
// endproperty	
// check_word_write0: assert property(check_word_write);









