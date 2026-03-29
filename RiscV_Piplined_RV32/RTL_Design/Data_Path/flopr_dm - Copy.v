/*
 * Module: flopr_dm
 * Description: Pipeline Register (E/M Stage) for DATA signals, 
 * with Asynchronous Reset. Passes data from Execute (E) to Memory (M).
 */
module flopr_dm (
    // Inputs (Control & Clock)
    input wire clk,             // 1. Clock
    input wire reset,           // 2. Asynchronous Reset (Active High)

    // Data Signals (E -> M)
    // ALU Result (32 bits assumed)
    input wire [31:0] ALUResultE, // 3. ALU Result (Execute) - E input
    output reg [31:0] ALUResultM, // 4. ALU Result (Memory) - M output

    // Write Data (32 bits assumed)
    input wire [31:0] WriteDataE, // 5. Data to be written to memory (Execute) - E input
    output reg [31:0] WriteDataM, // 6. Data to be written to memory (Memory) - M output

    // Destination Register Index (5 bits assumed)
    input wire [4:0] RdE,        // 7. Destination Register Index (Execute) - E input
    output reg [4:0] RdM,        // 8. Destination Register Index (Memory) - M output

    // PC Plus 4 (32 bits assumed)
    input wire [31:0] PCPlus4E,   // 9. PC + 4 (Execute) - E input
    output reg [31:0] PCPlus4M,    // 10. PC + 4 (Memory) - M output
    
    input wire [31:0] ImmExtE,  
    output reg [31:0] ImmExtM, 

    input wire [2:0] Func3E,
    output reg [2:0] Func3M
);

    // --- Register Logic ---
    // This is a basic D-flop with an asynchronous reset.
    
    always @(posedge clk) begin
        if (reset) begin
            // Asynchronous Reset: Clear all data outputs
            ALUResultM  <= 32'h0;
            WriteDataM  <= 32'h0;
            RdM         <= 5'h0;
            PCPlus4M    <= 32'h0;
            ImmExtM     <= 32'h0;
            Func3M      <= 3'h0;
        end else begin
            // Synchronous Load: Capture the data from the E stage
            ALUResultM  <= ALUResultE;
            WriteDataM  <= WriteDataE;
            RdM         <= RdE;
            PCPlus4M    <= PCPlus4E;
            ImmExtM     <= ImmExtE;
            Func3M      <= Func3E;
        end
    end

endmodule