`ifndef _DM
`define _DM

`include "def.vh"
`timescale 1ns / 1ps

module DM(
	input wire [31 : 0] addr_in, write_data,
	input wire MemRead, MemWrite, clk,
	output reg [31 : 0] out 
    );
	reg [31 : 0] data [255 : 0];
    wire [31 : 0] addr; 
    assign addr = {2'b00, addr_in[31 : 2]};
	
	always_comb begin
		if(MemRead == 1'b1) out = data[addr];
		else out = 32'bz;
	end	
	
	always_ff @(negedge clk) begin
		if(MemWrite == 1'b1) begin
			data[addr] <= write_data;
		end
	end

endmodule

`endif