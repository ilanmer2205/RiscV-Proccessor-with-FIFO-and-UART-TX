

module forward_unit
	(
	input [4:0] Rs1E, Rs2E, 
	input [4:0] RdM, RdW,
	input RegWriteM, RegWriteW,

	output reg [1:0] ForwardAE, ForwardBE	
	);

    always @(*) begin 
        if (((Rs1E == RdM) & RegWriteM) & (Rs1E != 0)) 
            ForwardAE = 2'b10;
        else if (((Rs1E == RdW) & RegWriteW) & (Rs1E != 0))
            ForwardAE = 2'b01;
        else ForwardAE = 2'b00;
    end

    always @(*) begin 
        if (((Rs2E == RdM) & RegWriteM) & (Rs1E != 0)) 
            ForwardBE = 2'b10;
        else if (((Rs2E == RdW) & RegWriteW) & (Rs1E != 0))
            ForwardBE = 2'b01;
        else ForwardBE = 2'b00;
    end

//There is a priority to which stage we forward. 
//We forward the closest stage because it has the relevent data. And even if Rs1E ==RdM == RDW, the Data in Rdw now is irrelevent because the cycle before we also did forwarding and calculated the data that is now in the Execute stage
endmodule