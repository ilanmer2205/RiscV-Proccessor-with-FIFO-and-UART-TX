module data_path(
    input clk, reset,
    input StallF, StallD, 
    input FlushD, FlushE,
    input [1:0] ForwardAE, ForwardBE,
    input RegWriteW,
    input [2:0] ImmSrcD,
    input PCSrcE,
    input ALUSrcE,
    input [3:0] ALUControlE,
    input [1:0] ResultSrcW,    
    input [31:0] ReadDataM,
    input [31:0] InstrF,
    input AOperandE,
    input ForwardValMuxM,
    
    output Zero,
    output [31:0] PCF,
    output [31:0] ALUResultM, WriteDataM,
    output [4:0] Rs1D, Rs2D,
    output [4:0] Rs1E, Rs2E, 
    output [4:0] RdE, RdM, RdW,
    output [31:0] InstrD,
    output [2:0] Func3M, Func3E,
    output [31:0] ResultW
    );
    

    wire [31:0] PCD, PCE;
    wire [31:0] PCF_Next;
    wire [31:0] PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
    wire [31:0] PCTargetE;
    wire [31:0] ImmExtD, ImmExtE, ImmExtM, ImmExtW;
    wire [31:0] SrcAE, SrcBE;
    wire [31:0] WriteDataE;
    wire [31:0] RD1D, RD1E, RD2D, RD2E;
    wire [4:0] RdD;
    wire [31:0] ALUResultE, ALUResultW;
    wire [31:0] ReadDataW;
    wire [4:0] A1;
    wire [4:0] A2;
    wire [31:0] A;
    wire [2:0] Func3D;
    wire [31:0] ForwardValM;
    
    assign A1 = InstrD[19:15];
    assign A2 = InstrD[24:20]; 

    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD = InstrD[11:7]; 
    assign Func3D = InstrD[14:12];
    
    // Fetch Cycle
    mux2 #(32) pcmux(PCPlus4F, PCTargetE, PCSrcE, PCF_Next);
    flopenr #(32) pcreg(clk, reset, StallF, PCF_Next, PCF);
    adder pcadd4(PCF, 32'd4, PCPlus4F);

    //Decode Cycle
    register_file rf(clk, reset, A1, A2, RdW, ResultW, RegWriteW, 
     RD1D, RD2D);
    extend ext(InstrD[31:7], ImmSrcD, ImmExtD);
    
    // Execute Cycle
    mux2 #(32) AOperandmux (RD1E, PCE, AOperandE, A);
    mux3 #(32) fwdmuxA (A, ResultW, ForwardValM, ForwardAE, SrcAE);
    mux3 #(32) fwdmuxB (RD2E, ResultW, ForwardValM, ForwardBE, WriteDataE);
    mux2 #(32) srcbmux(WriteDataE, ImmExtE, ALUSrcE, SrcBE);
    alu alu(SrcAE, SrcBE, ALUControlE, Zero, ALUResultE);
    adder pcaddbranch(PCE, ImmExtE, PCTargetE);
    
    // Memory Cycle
    mux2 #(32) forwardvalmux (ALUResultM, ImmExtM, ForwardValMuxM, ForwardValM);
    
    //Write Back Cycle
    mux4 #(32) resultmux(ALUResultW, ReadDataW, PCPlus4W, ImmExtW, ResultSrcW, ResultW);
    
    
    //Fetch cycle reg
        //I stick to the block diagram, and include it as pcreg
    //Decode cycle reg
    flopenr_clr_dd dcycreg(clk, reset, StallD, FlushD ,InstrF, InstrD, PCF, PCD, PCPlus4F, PCPlus4D); 
    //Execute cycle reg
    flopr_clr_de ecycreg(clk, reset, FlushE ,RD1D, RD1E, RD2D, RD2E, PCD, PCE, Rs1D, Rs1E, Rs2D, Rs2E, RdD, RdE,
         ImmExtD, ImmExtE, PCPlus4D, PCPlus4E, Func3D, Func3E);
    //Memory cycle reg
    flopr_dm mcycreg (clk, reset, ALUResultE, ALUResultM, WriteDataE, WriteDataM, RdE, RdM, PCPlus4E, PCPlus4M, ImmExtE, ImmExtM,
         Func3E, Func3M);
    //Write Back cycle reg
    flopr_dw wcycreg (clk, reset, ALUResultM, ALUResultW, ReadDataM, ReadDataW, RdM, RdW,PCPlus4M, PCPlus4W, ImmExtM, ImmExtW);
endmodule