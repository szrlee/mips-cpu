`ifndef _ALUCtrl
`define _ALUCtrl

`include "def.vh"
`timescale 1ns / 1ps

module ALUCtrl(
	input wire [2 : 0] AluOp,
	input wire [5 : 0] funct,
	output reg [3 : 0] out
    );

	always_comb begin
		case (AluOp)
			`ALU_OP_ADD: out = `ALU_ADD;	
			`ALU_OP_SUB: out = `ALU_SUB;
			`ALU_OP_AND: out = `ALU_AND;
			`ALU_OP_OR: out = `ALU_OR;
			`ALU_OP_FUNCT: begin
				case (funct)
					`FUNCT_SLL: out = `ALU_SLL;
					`FUNCT_SRA: out = `ALU_SRA;
					`FUNCT_SRL: out = `ALU_SRL;
					`FUNCT_NOR: out = `ALU_NOR;
					`FUNCT_SLT: out = `ALU_CMP;
					`FUNCT_SLTU: out = `ALU_CMPU;
					default : out = 4'dz;
				endcase
			end
			default : out = 4'dz;
		endcase
	end
endmodule

`endif