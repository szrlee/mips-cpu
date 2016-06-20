`ifndef _ex_mem
`define _ex_mem

`timescale 1ns / 1ps


module ex_mem(
	input wire clk,
	input wire [31 : 0] pc_id_ex,
	input wire [31 : 0] instruction_id_ex,
	input wire RegWrite_id_ex,
	input wire RegDst_id_ex,
	input wire MemRead_id_ex,
	input wire MemWrite_id_ex,
	input wire MemtoReg_id_ex,
	input wire [31 : 0] alu_out_ex,
	input wire [31 : 0] regfile_read_data2_id_ex,
	input wire [4 : 0] rt_id_ex, rd_id_ex,
	input wire [1 : 0] Jump_id_ex,
	input wire halt_ex,
	output reg [31 : 0] pc_ex_mem,
	output reg [31 : 0] instruction_ex_mem,
	output reg RegWrite_ex_mem,
	output reg RegDst_ex_mem,
	output reg MemRead_ex_mem,
	output reg MemWrite_ex_mem,
	output reg MemtoReg_ex_mem,
	output reg [1 : 0] Jump_ex_mem,
	output reg [31 : 0] alu_out_ex_mem,
	output reg [31 : 0] ram_write_data_ex_mem,
	output reg [4 : 0] rt_ex_mem, rd_ex_mem,
	output reg halt_ex_mem
    );
	
	always_ff @(posedge clk) begin 
		pc_ex_mem <= pc_id_ex;
		instruction_ex_mem <= instruction_id_ex;
		RegDst_ex_mem <= RegDst_id_ex;
		MemRead_ex_mem <= MemRead_id_ex;
		MemWrite_ex_mem <= MemWrite_id_ex;
		MemtoReg_ex_mem <= MemtoReg_id_ex;
		alu_out_ex_mem <= alu_out_ex;
		ram_write_data_ex_mem <= regfile_read_data2_id_ex;
		rt_ex_mem <= rt_id_ex;
		rd_ex_mem <= rd_id_ex;
		Jump_ex_mem <= Jump_id_ex;
		RegWrite_ex_mem <= RegWrite_id_ex;
		halt_ex_mem <= halt_ex;
	end

endmodule

`endif