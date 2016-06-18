`ifndef _CtrlUnit
`define _CtrlUnit

`include "def.vh"
`timescale 1ns / 1ps

module CtrlUnit(
	input wire [5 : 0] opcode, funct,
	output wire ExtOp, RegDst, RegWrite, MemRead, MemWrite, MemtoReg, JalSrc,
	output wire [1 : 0] Branch, Jump, AluSrc,
	output wire SyscallSrc,
	output wire [2 : 0] AluOp
    );
	
	reg [16 : 0] all_ctrl;
	always_comb begin
		case (opcode)
			`CTRL_OPCODE_RTYPE: begin
				case (funct)                 //ExtOp|RegDs |RegWr  |AluOp|MemRe|MemWr|Memto|AluSr |Branch|Jump  |JalS |Sysc};	
					`FUNCT_ADD: all_ctrl =     {1'bx, 1'b1, 1'b1, 3'b000, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_ADDU: all_ctrl =    {1'bx, 1'b1, 1'b1, 3'b000, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_AND: all_ctrl =     {1'bx, 1'b1, 1'b1, 3'b110, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_SLL: all_ctrl =     {1'bx, 1'b1, 1'b1, 3'b100, 1'b0, 1'b0, 1'b0, 2'b11, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_SRA: all_ctrl =     {1'bx, 1'b1, 1'b1, 3'b100, 1'b0, 1'b0, 1'b0, 2'b11, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_SRL: all_ctrl =     {1'bx, 1'b1, 1'b1, 3'b100, 1'b0, 1'b0, 1'b0, 2'b11, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_SUB: all_ctrl =     {1'bx, 1'b1, 1'b1, 3'b010, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_OR: all_ctrl =      {1'bx, 1'b1, 1'b1, 3'b111, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_NOR: all_ctrl =     {1'bx, 1'b1, 1'b1, 3'b100, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_SLT: all_ctrl =     {1'bx, 1'b1, 1'b1, 3'b100, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_SLTU: all_ctrl =    {1'bx, 1'b1, 1'b1, 3'b100, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b0, 1'b0};
					`FUNCT_JR: all_ctrl =      {1'bx, 1'b0, 1'b0, 3'b000, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b01, 1'b0, 1'b0};
					`FUNCT_SYSCALL: all_ctrl = {1'bx, 1'b0, 1'b0, 3'b000, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b0, 1'b1};
					default : all_ctrl =        17'bz;
				endcase
			end	
                                              //ExtOp|RegDs |RegWr  |AluOp|MemRe|MemWr|Memto|AluSr |Branch|Jump  |JalS |Sysc};	
			`CTRL_OPCODE_ADDI: all_ctrl  =     {1'b1, 1'b0, 1'b1, 3'b000, 1'b0, 1'b0, 1'b0, 2'b01, 2'b00, 2'b00, 1'b0, 1'b0};
			`CTRL_OPCODE_ADDIU: all_ctrl =     {1'b1, 1'b0, 1'b1, 3'b000, 1'b0, 1'b0, 1'b0, 2'b01, 2'b00, 2'b00, 1'b0, 1'b0};
			`CTRL_OPCODE_ANDI: all_ctrl =      {1'b0, 1'b0, 1'b1, 3'b110, 1'b0, 1'b0, 1'b0, 2'b01, 2'b00, 2'b00, 1'b0, 1'b0};
			`CTRL_OPCODE_ORI: all_ctrl =       {1'b0, 1'b0, 1'b1, 3'b111, 1'b0, 1'b0, 1'b0, 2'b01, 2'b00, 2'b00, 1'b0, 1'b0};
			`CTRL_OPCODE_LW: all_ctrl =        {1'b1, 1'b0, 1'b1, 3'b000, 1'b1, 1'b0, 1'b1, 2'b01, 2'b00, 2'b00, 1'b0, 1'b0};
			`CTRL_OPCODE_SW: all_ctrl =        {1'b1, 1'b0, 1'b0, 3'b000, 1'b0, 1'b1, 1'b0, 2'b01, 2'b00, 2'b00, 1'b0, 1'b0};
			`CTRL_OPCODE_BEQ: all_ctrl =       {1'b1, 1'b0, 1'b0, 3'b000, 1'b0, 1'b0, 1'b0, 2'b00, 2'b01, 2'b00, 1'b0, 1'b0};
			`CTRL_OPCODE_BNE: all_ctrl =       {1'b1, 1'b0, 1'b0, 3'b000, 1'b0, 1'b0, 1'b0, 2'b00, 2'b10, 2'b00, 1'b0, 1'b0};
			`CTRL_OPCODE_SLTI: all_ctrl =      {1'b1, 1'b0, 1'b1, 3'b100, 1'b0, 1'b0, 1'b0, 2'b01, 2'b00, 2'b00, 1'b0, 1'b0};
			`CTRL_OPCODE_J: all_ctrl =         {1'bx, 1'b0, 1'b0, 3'b000, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b11, 1'b0, 1'b0};
			`CTRL_OPCODE_JAL: all_ctrl =       {1'bx, 1'b0, 1'b1, 3'b000, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b10, 1'b1, 1'b0};
			default : all_ctrl =                17'bz;
		endcase
	end

	//RegDst, RegWrite, AluOp, MemRead, MemWrite, MemtoReg, AluSrc, Branch, Jump, JalSrc, SyscallSrc};	
	assign ExtOp = all_ctrl[16];
	assign RegDst =   all_ctrl[15];
	assign RegWrite = all_ctrl[14];
	assign AluOp =    all_ctrl[13 : 11];
	assign MemRead =  all_ctrl[10];
	assign MemWrite = all_ctrl[9];
	assign MemtoReg = all_ctrl[8];
	assign AluSrc =   all_ctrl[7 : 6];
	assign Branch =   all_ctrl[5 : 4];
	assign Jump =     all_ctrl[3 : 2];
	assign JalSrc =   all_ctrl[1];
	assign SyscallSrc = all_ctrl[0];

endmodule

`endif