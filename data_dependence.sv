`ifndef _data_dependence
`define _data_dependence
`timescale 1ns / 1ps

module data_dependence(
	input wire clk,
	input wire MemRead_id_ex, RegWrite_id_ex,
	input wire [4 : 0] regfile_read_num1_syscall_id, regfile_read_num2_syscall_id, regfile_write_num_id_ex, regfile_write_num_ex_mem, 
	output reg nop_lock_id = 1'b0
    );
	reg nop_lock_id_temp = 1'b0;
	reg [31 : 0] nop_counter = 32'd0;

	always_comb begin
		if((MemRead_id_ex == 1'b1) && (RegWrite_id_ex == 1'b1)) begin
			if((regfile_read_num1_syscall_id == regfile_write_num_id_ex) && (regfile_write_num_id_ex != 0)) begin
				nop_lock_id_temp = 1'b1;
			end
			else if((regfile_read_num2_syscall_id == regfile_write_num_id_ex) && (regfile_write_num_id_ex != 0)) begin
				nop_lock_id_temp = 1'b1;
			end			
			else nop_lock_id_temp = 1'b0;
		end
		else nop_lock_id_temp = 1'b0;
	end
	always_ff @(negedge clk) begin
		nop_lock_id <= nop_lock_id_temp;
		if(nop_lock_id_temp == 1'b1) begin
			nop_counter = nop_counter + 1;
		end
	end
endmodule

`endif
