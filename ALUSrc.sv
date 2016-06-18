`ifndef _ALUSrc
`define _ALUSrc

`include "def.vh"
`timescale 1ns / 1ps

module ALUSrc(
	input wire [1 : 0] AluSrc,
	input wire [`WORD_SIZE - 1 : 0] regfile_read_data1, regfile_read_data2, ext_immidiate,
	input wire [4 : 0] shamt,
	output reg [`WORD_SIZE - 1 : 0] alu_src_out1, alu_src_out2
    );
	always_comb begin
		case (AluSrc)
			2'b00: begin
				// r
				alu_src_out1 = regfile_read_data1;
				alu_src_out2 = regfile_read_data2;
			end
			2'b01: begin
				// i
				alu_src_out1 = regfile_read_data1;
				alu_src_out2 = ext_immidiate;
			end
			2'b11: begin
				// shift
				alu_src_out1 = regfile_read_data2;
				alu_src_out2 = {26'h0, shamt};
			end
			default : begin
				alu_src_out1 = 32'bz;
				alu_src_out2 = 32'bz;
			end
		endcase
	end
endmodule

`endif