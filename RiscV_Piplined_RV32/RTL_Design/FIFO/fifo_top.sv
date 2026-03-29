`timescale 1ns / 1ps

module fifo_top #(
    parameter FIFO_DEPTH = 32
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        wr_en,
    input  logic        rd_en,
    input  logic [31:0] data_in,

    output logic [31:0] data_out,
    output logic        empty,
    output logic        full,
    output logic        am_full
);

    // --- Internal Interconnects ---
    // Pointers from Controller -> RAM
    // The width is calculated dynamically based on FIFO_DEPTH
    logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr_int;
    logic [$clog2(FIFO_DEPTH)-1:0] rd_ptr_int;

    // --- Module Instantiations ---

    // 1. FIFO Controller
    // Manages pointers and status flags (empty/full)
    fifo_controller #(
        .FIFO_DEPTH(FIFO_DEPTH)
    ) u_fifo_controller (
        .clk     (clk),
        .rst_n   (rst_n),
        .wr_en   (wr_en),
        .rd_en   (rd_en),
        .wr_ptr  (wr_ptr_int),   // Output to RAM
        .rd_ptr  (rd_ptr_int),   // Output to RAM
        .empty   (empty),        // Output to Top
        .full    (full),         // Output to Top
        .am_full (am_full)       // Output to Top
    );

    // 2. FIFO RAM
    // Stores the actual data
    // to match the connection width here.
    fifo_ram #(
        .FIFO_DEPTH(FIFO_DEPTH)
    ) u_fifo_ram (
        .clk     (clk),
        .rst_n   (rst_n),
        .wr_en   (wr_en),        // Write enable shared with controller
        .wr_ptr  (wr_ptr_int),   // Input from controller
        .rd_ptr  (rd_ptr_int),   // Input from controller
        .data_in (data_in),
        .data_out(data_out)
    );

endmodule