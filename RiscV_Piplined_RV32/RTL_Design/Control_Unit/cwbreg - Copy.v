/*
 * Module: flopr_cwb
 * Description: Pipeline Register (M/W Stage) with Synchronous Reset.
 * Passes control signals from the Memory stage (M) to the Write-Back stage (W).
 */
module flopr_cwb (
    // Inputs (Control & Clock)
    input wire clk,         // 1. Clock
    input wire reset,       // 2. Synchronous Reset (Active High)

    // Data Signals (M -> W)
    // RegWrite
    input wire RegWriteM,   // 3. Register Write Enable (Memory) - M input
    output reg RegWriteW,   // 4. Register Write Enable (Write-Back) - W output

    // ResultSrc
    input wire [1:0] ResultSrcM,  // 5. Result Source Select (Memory) - M input
    output reg [1:0] ResultSrcW,   // 6. Result Source Select (Write-Back) - W output
    
    input En_fifoM,
    output reg En_fifoW
);

    // --- Register Logic ---
    // The reset is now synchronous, meaning it only takes effect on the positive clock edge.
    
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous Reset: Clear all control signals (NOP state)
            // This occurs only on the positive edge of the clock.
            RegWriteW   <= 1'b0;
            ResultSrcW  <= 2'b00;
        end else begin
            // Synchronous Load: Capture the data from the M stage
            RegWriteW   <= RegWriteM;
            ResultSrcW  <= ResultSrcM;
            En_fifoW     <= En_fifoM;
        end
    end

endmodule
