module hazard_control(
    input fifo_am_full,
    input [4:0] Rs1D, Rs1E,
    input [4:0] Rs2D, Rs2E,
    input [4:0] RdE, RdM, RdW,
    input PCSrcE,
    input RegWriteM, RegWriteW,
    input [1:0] ResultSrcE,
    
    output StallF, StallD,
    output FlushD, FlushE,
    output [1:0] ForwardAE, ForwardBE
    );

    
    forward_unit fwd (Rs1E, Rs2E, RdM, RdW, RegWriteM, RegWriteW, ForwardAE, ForwardBE);
     
    stall_flush st_fl (fifo_am_full, Rs1D, Rs2D, RdE, PCSrcE, ResultSrcE, StallF, StallD, FlushD, FlushE);
    
endmodule
