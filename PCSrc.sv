`ifndef _PCSrc
`define _PCSrc

`include "def.vh"
`timescale 1ns / 1ps

module PCSrc(
	input wire [1 : 0] Branch, Jump,
	input wire Equal,
	input wire [31 : 0] in_pc, in_branch,
	input wire [25 : 0] in_j,
	input wire [31 : 0] in_jr,
	output reg [31 : 0] out
    );
	//in_j is used for j and jal
	wire [2 : 0] op;
	wire [31 : 0] j, jr, jal;
	reg [31 : 0] temp_pc;
	assign op = {Branch, Equal};
	assign j = {in_pc[31 : 26], in_j};
	assign jr = in_jr;
	always_comb begin
		case(Jump)
			2'b11: out = j; // j
			2'b10: out = j; // jal
			2'b01: out = jr; // jr
			default: begin 
				case (op)
					3'b000: out = in_pc + 1; // normal and not equal
					3'b001: out = in_pc + 1; // notmal and equal
					3'b011: out = in_pc + in_branch + 1; // beq equal can branch
					3'b010: out = in_pc + 1; // beq can not branch because of not equal
					3'b100: out = in_pc + in_branch + 1; // bne not equal can branch
					3'b101: out = in_pc + 1; //bne cannot branch because of equal
					default : out = 32'bz; // avoid not define op

				endcase
			end
		endcase
	end
endmodule

`endif