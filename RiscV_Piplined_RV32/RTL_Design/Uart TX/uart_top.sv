`timescale 1ns / 1ps

module top_tx #(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUDE_RATE = 57_600
)(
    input  logic         clk,
    input  logic         rst_n,
    // input logic baude_tick,  <-- REMOVED: Generated internally now
    input  logic         empty,       // FIFO/Buffer empty flag
    input  logic [31:0]  result_msg,  // 128-bit image message

    output logic         tx,          // Serial output
    output logic [7:0]   tx_cnt_out,  // Debug/Counter output
    output logic         tx_msg_ready // Handler busy status
);

    // --- Internal Interconnects ---
    logic       tx_start_int;
    logic [7:0] tx_data_int;
    logic       tx_ready_int;
    logic       internal_baud_tick; // Wire connecting Generator -> Transmitter
    logic       tx_done;
    // --- Module Instantiations ---

    // 0. NEW: Internal Baud Rate Generator
    baud_rate_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUDE_RATE(BAUDE_RATE)
    ) u_baud_gen (
        .clk    (clk),
        .rst_n  (rst_n),
        .tick   (internal_baud_tick) // Connects to the UART TX below 
    );

    // 1. Transaction Handler
    tx_handler u_tx_handler (
        .clk        (clk),
        .rst_n      (rst_n),
        .result_msg (result_msg),
        .empty      (empty),
        .tx_done     (tx_done),
        .tx_ready   (tx_ready_int),   
        .tx_start   (tx_start_int),  
        .tx_data    (tx_data_int),   
        .tx_cnt_out (tx_cnt_out),    
        .tx_msg_ready(tx_msg_ready)
        
    );

    // 2. UART Transmitter
    uart_tx u_uart_tx (
        .clk        (clk),
        .rst_n      (rst_n),
        .baude_tick (internal_baud_tick), // Connected to internal wire 
        .tx_start   (tx_start_int), 
        .data_in    (tx_data_int),  
        .tx_ready   (tx_ready_int),  
        .tx         (tx),
        .tx_done    (tx_done)             
    );

endmodule