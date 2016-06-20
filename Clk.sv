`ifndef _Clk
`define _Clk
`timescale 1ns / 1ps
`include "def.vh"

module Clk(
	input wire stop,
	input wire clk_board,
	output reg clk_cpu = 1'b0,
	output reg clk_led = 1'b0
    );
	
	reg [31 : 0] i = 32'd0;
	always_ff @(posedge clk_board) begin
		if (stop == 1'b1) begin
			clk_cpu <= clk_cpu;
		end
		else begin
			i <= i + 32'd1;
			if(i == 32'd4999999) begin
				i <= 32'd0;
				clk_cpu <= ~clk_cpu;
			end
		end
	end

	reg [31 : 0] j = 32'd0;
	always_ff @(posedge clk_board) begin
		j <= j + 32'd1;
		if(j >= 32'd49999) begin
			j <= 32'd0;
			clk_led <= ~clk_led;
		end
	end
endmodule

`endif