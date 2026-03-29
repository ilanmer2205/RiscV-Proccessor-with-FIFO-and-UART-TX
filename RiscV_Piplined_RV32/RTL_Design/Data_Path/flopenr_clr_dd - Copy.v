/*
 * Module: flopenr_clr_dd
 * Description: Pipeline Register (F/D Stage) with Asynchronous Reset, 
 * Active-LOW Synchronous Enable (stallD), and 
 * Active-HIGH Synchronous Clear (FlushD).
 */
module flopenr_clr_dd (
    // Inputs (Control & Clock)
    input wire clk,             // 1. Clock
    input wire reset,           // 2. Asynchronous Reset (Active High)
    input wire stallD,          // 3. Clock Enable (Active LOW load/stall)
    input wire FlushD,          // 4. Synchronous Clear/Flush (Active HIGH NOP)

    // Data Signals (F -> D)
    // Instruction
    input wire [31:0] InstrF,   // 5. Instruction (Fetch) - F input
    output reg [31:0] InstrD,   // 6. Instruction (Decode) - D output

    // PC (Program Counter)
    input wire [31:0] PCF,      // 7. Program Counter (Fetch) - F input
    output reg [31:0] PCD,      // 8. Program Counter (Decode) - D output

    // PC Plus 4
    input wire [31:0] PCPlus4F, // 9. PC + 4 (Fetch) - F input
    output reg [31:0] PCPlus4D  // 10. PC + 4 (Decode) - D output
);

    // --- Register Logic ---
    // Note: Data signals (Instructions, PCs) are typically 32 bits wide.

    always @(posedge clk or posedge reset) begin
        if (reset | FlushD) begin
            // Asynchronous Reset: Clear all outputs
            InstrD      <= 32'h00000000; // NOP instruction (common default)
            PCD         <= 32'h00000000;
            PCPlus4D    <= 32'h00000000;
        end else if (!stallD) begin
            // Synchronous Load (Active LOW Enable): Load new data
            // When stallD is LOW, the pipeline moves forward.
            InstrD      <= InstrF;
            PCD         <= PCF;
            PCPlus4D    <= PCPlus4F;
        end
        // If (reset is low) AND (FlushD is low) AND (stallD is HIGH), 
        // the register holds its current value (STALL).
    end

endmodule