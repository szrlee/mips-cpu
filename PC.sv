`ifndef _PC
`define _PC

`include "def.vh"
`timescale 1ns / 1ps

module PC(
	input wire clk, rst, halt, pc_bj, nop_lock_id,
	input wire [31 : 0] pc_if_id,
	input wire [31 : 0] pc_src_in,
	output reg [31 : 0] out = 32'h0,
	output reg [31 : 0] cycles_counter = 32'h0
    );
    
	always_ff @(posedge clk) begin
		if(halt == 1'b0) cycles_counter = cycles_counter + 32'd1;
	end

	always_comb begin
		if(rst == 1'b1) out <= 32'h0; 
		else if(halt == 1'b1) out <= out;
		else if(pc_bj == 1'b1) out <= pc_src_in;
		else if(nop_lock_id == 1'b1) out <= out;
		else out <= pc_if_id + 1;
	end
endmodule

`endif