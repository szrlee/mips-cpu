`ifndef _RF
`define _RF

`timescale 1ns / 1ps
`include "def.vh"

//32 bit register file
module RF(
	input wire clk,
	input wire [4 : 0] read_num1, read_num2,
	input wire [4 : 0] write_num,
	input wire write_en,
	input wire [31 : 0] write_data,
	output wire [31 : 0] read_data1, read_data2
    );
	
	reg [31 : 0] regs [31 : 0];

    assign read_data1 = (read_num1 == 5'd0) ? 32'd0 : regs[read_num1];
    assign read_data2 = (read_num2 == 5'd0) ? 32'd0 : regs[read_num2];
    
	always_ff @(negedge clk) begin
		if(write_en == 1'b1) begin
			regs[write_num] <= write_data;
		end
	end
endmodule

`endif