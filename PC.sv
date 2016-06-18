`ifndef _PC
`define _PC

`include "def.vh"
`timescale 1ns / 1ps

module PC(
	input wire clk,
	input wire rst, halt,
	input wire [`WORD_SIZE - 1 : 0] in,
	output reg [`WORD_SIZE - 1 : 0] out = 32'h0,
    output reg [31 : 0] cycles_counter = 32'd0
    );
    
	always_ff @(posedge clk) begin
		if(halt == 1'b0) cycles_counter = cycles_counter + 32'd1;
	end

	always_ff @(posedge clk) begin
		if(rst == 1'b1) begin
			out <= 32'h0; 
		end
		else if (halt == 1'b1) begin
			out <= out;
		end 
		else begin
			out <= in;
		end
	end
endmodule

`endif