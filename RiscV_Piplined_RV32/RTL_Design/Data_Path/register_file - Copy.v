`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2025 14:05:54
// Design Name: 
// Module Name: register_file
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


module register_file
    #(REG_NUM=32)
    (
    input clk,
    input rst,
    input [4:0] A1, 
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    input WE3, //Write Enable: in load=1 in store=0
    output [31:0] RD1,
    output [31:0] RD2
    );
    
    reg [31:0] reg_mem [REG_NUM-1: 0];
    
    //NOTE: x0 is hard wired '0'
    assign RD1 = A1==0 ? 0 : reg_mem[A1];
    assign RD2 = A2==0 ? 0 : reg_mem[A2];
    

//  not allowed to write to x0
//  write in falling edge, to allow data read before next clk tick
    always@ (negedge clk) begin
        if (rst)
            for (integer i=0; i< REG_NUM; i= i+1) begin
                reg_mem[i] = 32'h0;
            end
         if(WE3 && (A3 !=0) )
            reg_mem[A3]<= WD3;           
    end
endmodule
