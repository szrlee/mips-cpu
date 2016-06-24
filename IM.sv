`ifndef _IM
`define _IM

`include "def.vh"
`timescale 1ns / 1ps

module IM(
	input wire [31 : 0] pc_if,
	output wire [31 : 0] instruction_if
	);
	wire [7 : 0] num;
	reg [31 : 0] data [255 : 0];
	initial begin
		$readmemh("pipeline_test.txt", data, 0, 255);
	end
	
	assign num = pc_if[7 : 0];
	assign instruction_if = data[num];
endmodule

`endif