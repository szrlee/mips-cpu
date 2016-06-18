`ifndef _RegDst
`define _RegDst

`include "def.vh"
`timescale 1ns / 1ps

module RegDst(
    input wire [1 : 0] Jump,
	input wire RegDst,
	input wire [4 : 0] rt_num, rd_num,
	output reg [4 : 0] write_num
    );
    
	always_comb begin
	   if(Jump == 2'b10) write_num = 5'd31;
	   else if(RegDst == 1'b1) write_num = rd_num;
	   else if(RegDst == 1'b0) write_num = rt_num;
	   else write_num = 5'dz;
	end
endmodule

`endif