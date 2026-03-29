
module flopr_clr_cexe (
    // Inputs (Control & Clock)
    input wire clk,         // 1. Clock
    input wire reset,       // 2. Synchronous Reset (Active High)
    input wire FlushE,      

    // Data Signals (D -> E)
    // RegWrite
    input wire RegWriteD,   // 4. Register Write Enable (Decode) - D input
    output reg RegWriteE,   // 5. Register Write Enable (Execute) - E output

    // ResultSrc
    input wire [1:0] ResultSrcD,  // 6. Result Source Select (Decode) - D input
    output reg [1:0] ResultSrcE,  // 7. Result Source Select (Execute) - E output

    // MemWrite
    input wire MemWriteD,   // 8. Memory Write Enable (Decode) - D input
    output reg MemWriteE,   // 9. Memory Write Enable (Execute) - E output

    // Jump
    input wire JumpD,       // 10. Jump Enable (Decode) - D input
    output reg JumpE,       // 11. Jump Enable (Execute) - E output

    // Branch
    input wire BranchD,     // 12. Branch Enable (Decode) - D input
    output reg BranchE,     // 13. Branch Enable (Execute) - E output

    // ALUControl 
    input wire [3:0] ALUControlD, // 14. ALU Function Code (Decode) - D input
    output reg [3:0] ALUControlE, // 15. ALU Function Code (Execute) - E output

    // ALUSrc
    input wire ALUSrcD,     // 16. ALU Source Select (Decode) - D input
    output reg ALUSrcE,      // 17. ALU Source Select (Execute) - E output
    
    input AOperandD,
    output reg AOperandE,
    
    input ForwardValMuxD,
    output reg ForwardValMuxE,
    
    input En_fifoD,
    output reg En_fifoE
);

    // --- Register Logic (Functionality remains the same) ---
    always @(posedge clk) begin
        if (reset | FlushE) begin
            // Asynchronous Reset: Clear all control signals (NOP state)
            RegWriteE   <= 1'b0;
            ResultSrcE  <= 2'b00;
            MemWriteE   <= 1'b0;
            JumpE       <= 1'b0;
            BranchE     <= 1'b0;
            ALUControlE <= 3'b000;
            ALUSrcE     <= 1'b0;
            AOperandE   <= 1'b0;
            ForwardValMuxE <= 1'b0;
            En_fifoE    <= 1'b0;
            
        end else begin
            RegWriteE   <= RegWriteD;
            ResultSrcE  <= ResultSrcD;
            MemWriteE   <= MemWriteD;
            JumpE       <= JumpD;
            BranchE     <= BranchD;
            ALUControlE <= ALUControlD;
            ALUSrcE     <= ALUSrcD;
            AOperandE   <= AOperandD;
            ForwardValMuxE <= ForwardValMuxD;
            En_fifoE    <= En_fifoD;
        end
    end

endmodule
