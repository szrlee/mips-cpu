`ifndef _if_id
`define _if_id
`timescale 1ns / 1ps


module if_id(
	input wire clk,
	input wire [31 : 0] instruction_if, pc_if,
	output reg [31 : 0] instruction_if_id, pc_if_id
    );

	always_ff @(posedge clk) begin
		instruction_if_id <= instruction_if;
		pc_if_id <= pc_if;
	end
	

endmodule

`endif