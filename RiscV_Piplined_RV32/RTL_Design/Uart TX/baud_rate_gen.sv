`timescale 1ns / 1ps


module baud_rate_gen #(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUDE_RATE = 57_600
    )(
    input  logic clk,        // System Clock (100MHz)
    input  logic rst_n,      // Active Low Reset
    output logic tick        // Single cycle enable pulse
);

    // 100MHz / 57600bps = 1736.11 -> 1736 counts (int)
    // We count 0 to 1735
    localparam int DIVISOR = CLK_FREQ/BAUDE_RATE;
    
    // Log2(1736) is ~10.7, so 11 bits is enough. 
    logic [$clog2(DIVISOR)-1:0] counter; 

    always_ff @(posedge clk) begin
        if (rst_n) begin
            counter <= '0;
            tick    <= 1'b0;
        end else begin
                if (counter == DIVISOR - 1) begin
                    counter <= '0;
                    tick    <= 1'b1;
                end else begin
                    counter <= counter + 1'b1;
                    tick    <= 1'b0;
                end
        end
    end

endmodule