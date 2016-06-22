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
	input wire RegWrite_id,
	input wire MemRead_id,
	input wire MemWrite_id,
	input wire MemtoReg_id,
	input wire SyscallSrc_id,
	input wire [31 : 0] read_data1_id,
	input wire [31 : 0] read_data2_id,
	input wire [31 : 0] instruction_if_id,
	input wire halt_ex,
	input wire [4 : 0] regfile_write_num_id,
	input wire nop_lock_id,
	input wire pc_bj,
	output reg [31 : 0] pc_id_ex = 0,
	output reg [5 : 0] funct_id_ex = 0,
	output reg [4 : 0] shamt_id_ex = 0,
	output reg [31 : 0] ext_immediate_id_ex = 0,
	output reg [25 : 0] address_id_ex = 0,
	output reg [1 : 0] Branch_id_ex = 0,
	output reg [1 : 0] Jump_id_ex = 0,
	output reg [1 : 0] AluSrc_id_ex = 0,
	output reg [2 : 0] AluOp_id_ex = 0,
	output reg RegWrite_id_ex = 0,
	output reg MemRead_id_ex = 0,
	output reg MemWrite_id_ex = 0,
	output reg MemtoReg_id_ex = 0,
	output reg SyscallSrc_id_ex = 0,
	output reg [31 : 0] read_data1_id_ex = 0,
	output reg [31 : 0] read_data2_id_ex = 0,
	output reg [31 : 0] instruction_id_ex = 0,
	output reg [4 : 0] regfile_write_num_id_ex = 0
    );
	
	always_ff @(posedge clk) begin
		if(halt_ex == 1'b1) begin
			SyscallSrc_id_ex <= 1'b1;
			read_data1_id_ex <= 32'd10;
			pc_id_ex <= 0;
			instruction_id_ex <= 0;
			funct_id_ex <= 0;
			shamt_id_ex <= 0;
			ext_immediate_id_ex <= 0;
			address_id_ex <= 0;
			Branch_id_ex <= 0;
			Jump_id_ex <= 0;
			AluSrc_id_ex <= 0;
			AluOp_id_ex <= 0;
			RegWrite_id_ex <= 0;
			MemRead_id_ex <= 0;
			MemWrite_id_ex <= 0;
			MemtoReg_id_ex <= 0;
			read_data2_id_ex <= 0;
			regfile_write_num_id_ex <= 0;
		end
		else if(nop_lock_id == 1'b0 && pc_bj == 1'b0) begin
			SyscallSrc_id_ex <= SyscallSrc_id;
			read_data1_id_ex <= read_data1_id;
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
			RegWrite_id_ex <= RegWrite_id;
			MemRead_id_ex <= MemRead_id;
			MemWrite_id_ex <= MemWrite_id;
			MemtoReg_id_ex <= MemtoReg_id;
			read_data2_id_ex <= read_data2_id;
			regfile_write_num_id_ex <= regfile_write_num_id;
		end
		else begin
			// insert bubble
			SyscallSrc_id_ex <= 0;
			read_data1_id_ex <= 0;
			pc_id_ex <= 0;
			instruction_id_ex <= 0;
			funct_id_ex <= 0;
			shamt_id_ex <= 0;
			ext_immediate_id_ex <= 0;
			address_id_ex <= 0;
			Branch_id_ex <= 0;
			Jump_id_ex <= 0;
			AluSrc_id_ex <= 0;
			AluOp_id_ex <= 0;
			RegWrite_id_ex <= 0;
			MemRead_id_ex <= 0;
			MemWrite_id_ex <= 0;
			MemtoReg_id_ex <= 0;
			read_data2_id_ex <= 0;
			regfile_write_num_id_ex <= 0;
		end
	end

endmodule

`endif
