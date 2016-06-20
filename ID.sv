`ifndef _ID
`define _ID

`timescale 1ns / 1ps

module ID(
	input wire [31 : 0] instruction_if_id,
	output wire [5 : 0] opcode,
	output wire [4 : 0] rs,
	output wire [4 : 0] rt,
	output wire [4 : 0] rd,
	output wire [4 : 0] shamt,
	output wire [5 : 0] funct,
	output wire [15 : 0 ] immediate,
	output wire [25 : 0 ] address
    );
	
	assign opcode = instruction_if_id[31 : 26];
	assign rs = instruction_if_id[25 : 21];
	assign rt  = instruction_if_id[20 : 16];
	assign rd  = instruction_if_id[15 : 11];
	assign shamt  = instruction_if_id[10 : 6];
	assign funct = instruction_if_id[5 : 0];
	assign immediate = instruction_if_id[15 : 0];
	assign address = instruction_if_id[25 : 0];
endmodule

`endif