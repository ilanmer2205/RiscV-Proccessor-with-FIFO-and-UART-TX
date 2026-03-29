`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2025 14:05:54
// Design Name: 
// Module Name: mux3
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


module mux3 #(parameter WIDTH = 8)
    (input [WIDTH-1:0] d0, d1, d2,
     input [1:0] s,
     output [WIDTH-1:0] y
);
 
 assign y = s[1] ? d2 : (s[0] ? d1 : d0);

endmodule
