/*
 * Module: flopr_cmem
 * Description: Pipeline Register (E/M Stage) with Asynchronous Reset.
 * Passes control signals from the Execute stage (E) to the Memory stage (M).
 */
module flopr_cmem (
    // Inputs (Control & Clock)
    input wire clk,         // 1. Clock
    input wire reset,       // 2. Synchronous Reset (Active High)

    // Data Signals (E -> M)
    // RegWrite
    input wire RegWriteE,   // 3. Register Write Enable (Execute) - E input
    output reg RegWriteM,   // 4. Register Write Enable (Memory) - M output

    // ResultSrc
    input wire [1:0] ResultSrcE,  // 5. Result Source Select (Execute) - E input
    output reg [1:0] ResultSrcM,  // 6. Result Source Select (Memory) - M output

    // MemWrite
    input wire MemWriteE,   // 7. Memory Write Enable (Execute) - E input
    output reg MemWriteM,    // 8. Memory Write Enable (Memory) - M output
    
    input ForwardValMuxE,
    output reg ForwardValMuxM,
    
    input En_fifoE,
    output reg En_fifoM
);

    // --- Register Logic ---
    // This is a basic D-flop with an asynchronous reset.
    // Since no enable signal was specified (like FlushE in the previous example), 
    // the register simply loads the new data on every positive clock edge, 
    // unless the reset is active.
    
    always @(posedge clk) begin
        if (reset) begin
            RegWriteM   <= 1'b0;
            ResultSrcM  <= 2'b00;
            MemWriteM   <= 1'b0;
            ForwardValMuxM <= 1'b0;
            En_fifoM     <= 1'b0;
        end else begin
            // Synchronous Load: Capture the data from the E stage
            RegWriteM   <= RegWriteE;
            ResultSrcM  <= ResultSrcE;
            MemWriteM   <= MemWriteE;
            ForwardValMuxM <= ForwardValMuxE;
            En_fifoM     <= En_fifoE;
        end
    end

endmodule