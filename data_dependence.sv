`ifndef _data_dependence
`define _data_dependence
`timescale 1ns / 1ps

module data_dependence(
	input wire clk,
	input wire [4 : 0] regfile_read_num1_syscall_id, regfile_read_num2_syscall_id, regfile_write_num_id_ex, regfile_write_num_ex_mem, 
	input wire [1 : 0] Jump_id,
	output reg nop_lock_id = 1'b0
    );
	reg nop_lock_id_temp = 1'b0;
	always_comb begin
		if(Jump_id == 2'b00 || Jump_id == 2'b01) begin
			// jump 00 is non-j non-jal 
			// jump 01 is jr
			if((regfile_read_num1_syscall_id == regfile_write_num_id_ex) && regfile_write_num_id_ex != 1'b0) nop_lock_id_temp = 1'b1;
			else if((regfile_read_num1_syscall_id == regfile_write_num_ex_mem) && regfile_write_num_ex_mem != 1'b0) nop_lock_id_temp = 1'b1;
			else if((regfile_read_num2_syscall_id == regfile_write_num_id_ex) && regfile_write_num_id_ex != 1'b0) nop_lock_id_temp = 1'b1;
			else if((regfile_read_num2_syscall_id == regfile_write_num_ex_mem) && regfile_write_num_ex_mem != 1'b0) nop_lock_id_temp = 1'b1;
			else nop_lock_id_temp = 1'b0;
		end
		else nop_lock_id_temp = 1'b0;
	end
	always_ff @(negedge clk) begin
		nop_lock_id <= nop_lock_id_temp;
	end
endmodule

`endif
