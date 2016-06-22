`ifndef _mem_wb
`define _mem_wb

`timescale 1ns / 1ps

module mem_wb(
	input wire clk,
	input wire [31 : 0] pc_ex_mem,
	input wire [31 : 0] instruction_ex_mem,
	input wire MemtoReg_ex_mem,
	input wire [1 : 0] Jump_ex_mem,
	input wire [31 : 0] alu_out_ex_mem,
	input wire [31 : 0] ram_read_data_mem,
	input wire RegWrite_ex_mem,
	input wire halt_ex_mem,
	input wire [4 : 0] regfile_write_num_ex_mem,
	output reg [31 : 0] pc_mem_wb = 0,
	output reg [31 : 0] instruction_mem_wb = 0,
	output reg MemtoReg_mem_wb = 0,
	output reg [1 : 0] Jump_mem_wb = 0,
	output reg [31 : 0] alu_out_mem_wb = 0,
	output reg [31 : 0] ram_read_data_mem_wb = 0,
	output reg RegWrite_mem_wb = 0,
	output reg halt_mem_wb = 0,
	output reg [4 : 0] regfile_write_num_mem_wb = 0
    );
	
	always_ff @(posedge clk) begin
		pc_mem_wb <= pc_ex_mem;
		instruction_mem_wb <= instruction_ex_mem;
		MemtoReg_mem_wb <= MemtoReg_ex_mem;
		Jump_mem_wb <= Jump_ex_mem;
		alu_out_mem_wb <= alu_out_ex_mem;
		ram_read_data_mem_wb <= ram_read_data_mem;
		RegWrite_mem_wb <= RegWrite_ex_mem;
		halt_mem_wb <= halt_ex_mem;
		regfile_write_num_mem_wb <= regfile_write_num_ex_mem;
	end
endmodule

`endif