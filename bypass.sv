`ifndef _bypass
`define _bypass
`timescale 1ns / 1ps


module bypass(
	input clk,
	input wire RegWrite_ex_mem, RegWrite_mem_wb,
	input wire [4 : 0] regfile_write_num_ex_mem, regfile_write_num_mem_wb, regfile_read_num1_syscall_id_ex, regfile_read_num2_syscall_id_ex,
	input wire [31 : 0] regfile_write_data_wb, alu_out_ex_mem, regfile_read_data1_id_ex, regfile_read_data2_id_ex,
	output reg [31 : 0] bypass_data1_ex, bypass_data2_ex
    );
   	reg [31 : 0] bypass_data1_ex_temp;
   	reg [31 : 0] bypass_data2_ex_temp; 
	// reg [2 : 0] bypass_ex_temp = 3'b000;
	always_comb begin
		if((regfile_read_num1_syscall_id_ex == regfile_write_num_ex_mem) && (regfile_write_num_ex_mem != 0) && (RegWrite_ex_mem == 1'b1)) begin
			bypass_data1_ex_temp = alu_out_ex_mem;
		end
		else if((regfile_read_num1_syscall_id_ex == regfile_write_num_mem_wb) && (regfile_write_num_mem_wb != 0) && (RegWrite_mem_wb == 1'b1)) begin
			bypass_data1_ex_temp = regfile_write_data_wb;
		end
		else bypass_data1_ex_temp = regfile_read_data1_id_ex;
	end

	always_comb begin
		if((regfile_read_num2_syscall_id_ex == regfile_write_num_ex_mem) && (regfile_write_num_ex_mem != 0) && (RegWrite_ex_mem == 1'b1)) begin
			bypass_data2_ex_temp = alu_out_ex_mem;
		end
		else if((regfile_read_num2_syscall_id_ex == regfile_write_num_mem_wb) && (regfile_write_num_mem_wb != 0) && (RegWrite_mem_wb == 1'b1)) begin
			bypass_data2_ex_temp = regfile_write_data_wb;
		end
		else bypass_data2_ex_temp = regfile_read_data2_id_ex;
	end

	always_ff @(negedge clk) begin
		bypass_data1_ex <= bypass_data1_ex_temp;
		bypass_data2_ex <= bypass_data2_ex_temp;
	end
endmodule

`endif