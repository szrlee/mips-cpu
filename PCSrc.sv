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
	output reg [31 : 0] out,
	output reg pc_bj = 1'b0
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
			2'b11: begin
				out = j; // j
				pc_bj = 1'b1;
			end
			2'b10: begin
				out = j; // jal
				pc_bj = 1'b1;
			end
			2'b01: begin
				out = jr; // jr
				pc_bj = 1'b1;
			end
			default: begin 
				case (op)
					3'b000: pc_bj = 1'b0; // normal and not equal
					3'b001: pc_bj = 1'b0; // notmal and equal
					3'b011: begin
						pc_bj = 1'b1; // beq equal can branch
						out = in_pc + in_branch + 1;
					end
					3'b010: pc_bj = 1'b0; // beq can not branch because of not equal
					3'b100: begin
						pc_bj = 1'b1; // bne not equal can branch
						out = in_pc + in_branch + 1;
					end
					3'b101: pc_bj = 1'b0; //bne cannot branch because of equal
					default : pc_bj = 1'b0; // avoid not define op
				endcase
			end
		endcase
	end
endmodule

`endif