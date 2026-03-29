/*
 * Module: flopr_dw
 * Description: Pipeline Register (M/W Stage) for DATA signals, 
 * with Asynchronous Reset. Passes data from Memory (M) to Write-Back (W).
 */
module flopr_dw (
    // Inputs (Control & Clock)
    input wire clk,             // 1. Clock
    input wire reset,           // 2. Asynchronous Reset (Active High)

    // Data Signals (M -> W)
    // ALU Result (32 bits assumed)
    input wire [31:0] ALUResultM, // 3. ALU Result (Memory) - M input
    output reg [31:0] ALUResultW, // 4. ALU Result (Write-Back) - W output

    // Read Data (32 bits assumed)
    input wire [31:0] ReadDataM,  // 5. Data read from memory (Memory) - M input
    output reg [31:0] ReadDataW,  // 6. Data read from memory (Write-Back) - W output

    // Destination Register Index (5 bits assumed)
    input wire [4:0] RdM,          // 7. Destination Register Index (Memory) - M input
    output reg [4:0] RdW,          // 8. Destination Register Index (Write-Back) - W output

    // PC Plus 4 (32 bits assumed)
    input wire [31:0] PCPlus4M,   // 9. PC + 4 (Memory) - M input
    output reg [31:0] PCPlus4W,    // 10. PC + 4 (Write-Back) - W output

    input wire [31:0] ImmExtM,  
    output reg [31:0] ImmExtW
);

    // --- Register Logic ---
    // This is a basic D-flop with an asynchronous reset.
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Asynchronous Reset: Clear all data outputs
            ALUResultW  <= 32'h0;
            ReadDataW   <= 32'h0;
            RdW         <= 5'h0;
            PCPlus4W    <= 32'h0;
            ImmExtW     <= 32'h0;
        end else begin
            // Synchronous Load: Capture the data from the M stage
            ALUResultW  <= ALUResultM;
            ReadDataW   <= ReadDataM;
            RdW         <= RdM;
            PCPlus4W    <= PCPlus4M;
            ImmExtW     <= ImmExtM;
        end
    end

endmodule