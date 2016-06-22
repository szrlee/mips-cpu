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
					3'b000: begin 
						pc_bj = 1'b0; // normal and not equal
						out = 32'bz;
					end
					3'b001: begin 
						pc_bj = 1'b0; // notmal and equal
						out = 32'bz;
					end
					3'b011: begin 
						out = in_pc + in_branch + 1; // beq equal can branch
						pc_bj = 1'b1;
					end
					3'b010: begin 
						pc_bj = 1'b0; // beq can not branch because of not equal
						out = 32'bz;
					end
					3'b100: begin 
						out = in_pc + in_branch + 1; // bne not equal can branch
						pc_bj = 1'b1;
					end
					3'b101: begin 
						pc_bj = 1'b0; //bne cannot branch because of equal
						out = 32'bz;
					end
					default : begin 
						pc_bj = 1'b0;
						out = 32'bz;
					end
				endcase
			end
		endcase
	end
endmodule

`endif