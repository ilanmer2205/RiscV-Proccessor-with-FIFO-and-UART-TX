`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2025 14:17:03
// Design Name: 
// Module Name: flopenr_clr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module flopenr_clr #(parameter WIDTH = 8)
(input clk, reset, en, clr,
 input [WIDTH-1:0] d,
 output reg [WIDTH-1:0] q);
 
 always@ (posedge clk, posedge reset)
     if (reset | clr) q <= 0;
     else if (~en) q <= d;
 
endmodule

