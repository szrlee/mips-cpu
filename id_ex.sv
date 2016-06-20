`ifndef _id_ex
`define _id_ex
`timescale 1ns / 1ps

module id_ex(
	input wire clk,
	input wire [31 : 0] pc_if_id,
	input wire [5 : 0] funct_id,
	input wire [4 : 0] shamt_id,
	input wire [31 : 0] ext_immediate_id,
	input wire [25 : 0] address_id,
	input wire [1 : 0] Branch_id,
	input wire [1 : 0] Jump_id,
	input wire [1 : 0] AluSrc_id,
	input wire [2 : 0] AluOp_id,
	input wire RegDst_id,
	input wire RegWrite_id,
	input wire MemRead_id,
	input wire MemWrite_id,
	input wire MemtoReg_id,
	input wire SyscallSrc_id,
	input wire [31 : 0] read_data1_id,
	input wire [31 : 0] read_data2_id,
	input wire [31 : 0] instruction_if_id,
	input wire [4 : 0] rt_id, rd_id,
	input wire halt_ex,
	output reg [31 : 0] pc_id_ex,
	output reg [5 : 0] funct_id_ex,
	output reg [4 : 0] shamt_id_ex,
	output reg [31 : 0] ext_immediate_id_ex,
	output reg [25 : 0] address_id_ex,
	output reg [1 : 0] Branch_id_ex,
	output reg [1 : 0] Jump_id_ex,
	output reg [1 : 0] AluSrc_id_ex,
	output reg [2 : 0] AluOp_id_ex,
	output reg RegDst_id_ex,
	output reg RegWrite_id_ex,
	output reg MemRead_id_ex,
	output reg MemWrite_id_ex,
	output reg MemtoReg_id_ex,
	output reg SyscallSrc_id_ex = 0,
	output reg [31 : 0] read_data1_id_ex = 0,
	output reg [31 : 0] read_data2_id_ex = 0,
	output reg [31 : 0] instruction_id_ex,
	output reg [4 : 0] rt_id_ex, rd_id_ex
    );
	
	always_ff @(posedge clk) begin
		pc_id_ex <= pc_if_id;
		instruction_id_ex <= instruction_if_id;
		funct_id_ex <= funct_id;
		shamt_id_ex <= shamt_id;
		ext_immediate_id_ex <= ext_immediate_id;
		address_id_ex <= address_id;
		Branch_id_ex <= Branch_id;
		Jump_id_ex <= Jump_id;
		AluSrc_id_ex <= AluSrc_id;
		AluOp_id_ex <= AluOp_id;
		RegDst_id_ex <= RegDst_id;
		RegWrite_id_ex <= RegWrite_id;
		MemRead_id_ex <= MemRead_id;
		MemWrite_id_ex <= MemWrite_id;
		MemtoReg_id_ex <= MemtoReg_id;
		read_data2_id_ex <= read_data2_id;
		rt_id_ex <= rt_id;
		rd_id_ex <= rd_id;
		if(halt_ex == 1'b1) begin
			SyscallSrc_id_ex <= 1'b1;
			read_data1_id_ex <= 32'd10;
		end
		else begin 
			SyscallSrc_id_ex <= SyscallSrc_id;
			read_data1_id_ex <= read_data1_id;
		end
	end

endmodule

`endif
