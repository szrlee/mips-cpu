`ifndef _RegWrData
`define _RegWrData

`include "def.vh"
`timescale 1ns / 1ps

module RegWrData(
	input wire [1 : 0] Jump,
	input wire MemtoReg,
	input wire [31 : 0] pc_in, alu_in, mem_in,
	output reg [31 : 0] write_data
    );
	
	wire [2 : 0] op = {Jump, MemtoReg};
	// other situation is 0
	// Jump 10 is jal
	always_comb begin
		case (op)
			4'b100: begin 
				// jal GPR[31] <- pc + 1
				write_data = pc_in + 1;
			end
			4'b000: begin 
				write_data = alu_in;
			end
			4'b001: begin
				write_data = mem_in;
			end
			default : begin
			    write_data = mem_in;
			end
		endcase
	end
endmodule

`endif