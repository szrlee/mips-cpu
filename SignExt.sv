`ifndef _Ext
`define _Ext
//sign extention module from 16 bit to 32 bit
`timescale 1ns / 1ps

module Ext(
	input wire [15 : 0] in,
	input wire ExtOp,
	output reg [31 : 0] out
    );
	always_comb begin
        case (ExtOp)
    	   1'b1: begin
    	       out[31 : 0] <= { {16{in[15]}}, in[15 : 0] };
    	   end
    	   1'b0: begin
    	       out[31 : 0] <= { {16'b0}, in[15 : 0] };
    	   end
	end
endmodule

`endif