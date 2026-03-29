/*
 * Module: flopr_clr_de
 * Description: Pipeline Register (D/E Stage) for DATA signals, 
 * with Asynchronous Reset and Synchronous Enable/Flush.
 */
module flopr_clr_de (
    // Inputs (Control & Clock)
    input wire clk,             // 1. Clock
    input wire reset,           // 2. Asynchronous Reset (Active High)
    input wire FlushE,          // 3. Synchronous Clock Enable (Active High load)

    // Data Signals (D -> E)
    // Read Data 1 (32 bits assumed)
    input wire [31:0] RD1D,     // 4. Register Data 1 (Decode) - D input
    output reg [31:0] RD1E,     // 5. Register Data 1 (Execute) - E output

    // Read Data 2 (32 bits assumed)
    input wire [31:0] RD2D,     // 6. Register Data 2 (Decode) - D input
    output reg [31:0] RD2E,     // 7. Register Data 2 (Execute) - E output

    // PC (32 bits assumed)
    input wire [31:0] PCD,      // 8. Program Counter (Decode) - D input
    output reg [31:0] PCE,      // 9. Program Counter (Execute) - E output

    // Register Source 1 Index (5 bits assumed for RISC-V/MIPS)
    input wire [4:0] Rs1D,      // 10. Source Register 1 Index (Decode) - D input
    output reg [4:0] Rs1E,      // 11. Source Register 1 Index (Execute) - E output

    // Register Source 2 Index (5 bits assumed)
    input wire [4:0] Rs2D,      // 12. Source Register 2 Index (Decode) - D input
    output reg [4:0] Rs2E,      // 13. Source Register 2 Index (Execute) - E output

    // Register Destination Index (5 bits assumed)
    input wire [4:0] RdD,       // 14. Destination Register Index (Decode) - D input
    output reg [4:0] RdE,       // 15. Destination Register Index (Execute) - E output

    // Immediate Extension (32 bits assumed)
    input wire [31:0] ImmExtD,  // 16. Immediate Extended Value (Decode) - D input
    output reg [31:0] ImmExtE,  // 17. Immediate Extended Value (Execute) - E output

    // PC Plus 4 (32 bits assumed)
    input wire [31:0] PCPlus4D, // 18. PC + 4 (Decode) - D input
    output reg [31:0] PCPlus4E,  // 19. PC + 4 (Execute) - E output
    
    input wire [2:0] Func3D,
    output reg [2:0] Func3E
);

    // --- Register Logic ---
    // This uses an Asynchronous Reset and a Synchronous Clock Enable/Load (FlushE).
    
    always @(posedge clk) begin
        if (reset | FlushE) begin
            RD1E        <= 32'h0;
            RD2E        <= 32'h0;
            PCE         <= 32'h0;
            Rs1E        <= 5'h0;
            Rs2E        <= 5'h0;
            RdE         <= 5'h0;
            ImmExtE     <= 32'h0;
            Func3E      <= 3'h0;
        end else begin
            RD1E        <= RD1D;
            RD2E        <= RD2D;
            PCE         <= PCD;
            Rs1E        <= Rs1D;
            Rs2E        <= Rs2D;
            RdE         <= RdD;
            ImmExtE     <= ImmExtD;
            PCPlus4E    <= PCPlus4D;
            Func3E      <= Func3D;
        end
        // If (reset is low) AND (FlushE is low), the register holds its current value (stalls).
    end

endmodule