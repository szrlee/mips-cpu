`ifndef _CPU
`define _CPU
`timescale 1ns / 1ps

`include "def.vh"
`include "ALU.sv"
`include "ALUCtrl.sv"
`include "CtrlUnit.sv"
`include "IM.sv"
`include "RegDst.sv"
`include "RegWrData.sv"
`include "PC.sv"
`include "PCSrc.sv"
`include "DM.sv"
`include "RF.sv"
`include "Ext.sv"
`include "ALUSrc.sv"

module CPU(
	input wire clk,
	input wire stop,
	output reg [31 : 0] display_7segs,
	output wire [14 : 0] display_led
);
	reg rst = 1'b1;
	reg [31 : 0] display_syscall;
 	wire ExtOp, RegDst, RegWrite, MemRead, MemWrite, MemtoReg, JalSrc, SyscallSrc, halt;
	wire Equal; 
	wire [1 : 0] Branch, Jump, AluSrc;
	wire [5 : 0] opcode, funct;
	wire [2 : 0] AluOp;
	wire [4 : 0] rs, rt, rd, shamt, regfile_write_num, rs_syscall, rt_syscall;
	wire [31 : 0] pc_out, read, cycles_counter;
	wire [3 : 0] alu_control_op_out;
	wire [31 : 0] pc_src_out, ext_immidiate, alu_out, mem_out, regfile_write_data;
    wire [31 : 0] regfile_read_data1, regfile_read_data2, alu_src_out1, alu_src_out2;
    wire [15 : 0 ] immediate;
    wire [25 : 0 ] j_address;
    assign display_led = {cycles_counter[6 : 0], pc_out[7 : 0]};
	assign rs_syscall = SyscallSrc == 1'b1 ? 5'd2 : rs;
	assign rt_syscall = SyscallSrc == 1'b1 ? 5'd4 : rt; 
	assign halt = stop == 1'b1 ? 1'b1 : (SyscallSrc == 1'b1 ? (regfile_read_data1 == 32'd10 ? 1'b1 : 1'b0) : 1'b0);
    assign display_7segs = stop == 1'b1 ? cycles_counter : display_syscall;
    
  	always_ff @(posedge clk) begin 
		rst <= 1'b0;
		if(SyscallSrc == 1'b1) begin
			if(regfile_read_data1 == 32'd10) display_syscall <= display_syscall;
			else display_syscall <= regfile_read_data2;
		end
		else display_syscall <= display_syscall;	
  	end
  	

	PC PC_MOD(
		.clk (clk),
		.rst (rst),
		.halt(halt),
		.in  (pc_src_out),
		.out (pc_out),
		.cycles_counter (cycles_counter)
		);
	// PCSrc PCSRC_MOD(Branch, Jump, Equal, pc_out, ext_immidiate, j_address, regfile_read_data1, pc_src_out);
	PCSrc PCSRC_MOD(
		.Branch   (Branch),
		.Jump     (Jump),
		.Equal    (Equal),
		.in_pc    (pc_out),
		.in_branch(ext_immidiate),
		.in_j     (j_address),
		.in_jr    (regfile_read_data1),
		.out      (pc_src_out)
		);

	// Ext EXT(immediate, ONEBIT_true, ext_immidiate);
	Ext EXT_MOD(
		.in  (immediate),
		.ExtOp (ExtOp),
		.out (ext_immidiate)
		);

	// RegDst REGDST_MOD(JalSrc, RegDst, rt, rd,, regfile_write_num);
	RegDst REGDST_MOD(
		.Jump      (Jump),
		.RegDst    (RegDst),
		.rt_num    (rt),
		.rd_num    (rd),
		.write_num (regfile_write_num)
		);
		
	// RegWrData REGWRDATA_MOD(JalSrc, RegDst, rt, rd,, regfile_write_num);
        RegWrData REGWRDATA_MOD(
            .Jump      (Jump),
            .MemtoReg  (MemtoReg),
            .pc_in     (pc_out),
            .alu_in    (alu_out),
            .mem_in    (mem_out),
            .write_data(regfile_write_data)
            );
		
	// CtrlUnit CTRLUNIT_MOD(opcode, funct, RegDst, RegWrite, MemRead, MemWrite, MemtoReg, AluSrc, JalSrc, AluOp, Branch, Jump, SyscallSrc);
	CtrlUnit CTRLUNIT_MOD(
		.opcode    (opcode),
		.funct     (funct),
		.ExtOp     (ExtOp),
		.RegDst    (RegDst),
		.RegWrite  (RegWrite),
		.MemRead   (MemRead),
		.MemWrite  (MemWrite),
		.MemtoReg  (MemtoReg),
		.AluSrc    (AluSrc),
		.JalSrc    (JalSrc),
		.AluOp     (AluOp),
		.Branch    (Branch),
		.Jump      (Jump),
		.SyscallSrc(SyscallSrc)
		);
	// RF RF_MOD(clk, rs_syscall, rt_syscall, regfile_write_num, RegWrite, regfile_write_data, regfile_read_data1, regfile_read_data2);
	RF RF_MOD(
		.clk       (clk),
		.read_num1 (rs_syscall),
		.read_num2 (rt_syscall),
		.write_num (regfile_write_num),
		.write_en  (RegWrite),
		.write_data(regfile_write_data),
		.read_data1(regfile_read_data1),
		.read_data2(regfile_read_data2)
		);

	// ALU ALU_MOD(alu_control_op_out, regfile_read_data1, alu_src_out, alu_out, of, cf, Equal);
	ALU ALU_MOD(
		.op   (alu_control_op_out),
		.in1  (alu_src_out1),
	 	.in2  (alu_src_out2),
	 	.out  (alu_out),
	 	.equal(Equal)
	 	);
	// ALUCtrl ALUCTRL_MOD(AluOp, funct, alu_control_op_out);
	ALUCtrl ALUCTRL_MOD(
		.AluOp(AluOp),
		.funct(funct),
	 	.out  (alu_control_op_out)
	 	);
	// IM IM_MOD(pc_out, opcode, rs, rt, rd, shamt, funct, immediate, j_address, read);
	IM IM_MOD(
		.pc       (pc_out),
		.opcode   (opcode),
		.rs       (rs),
		.rt       (rt),
		.rd       (rd),
		.shamt    (shamt),
		.funct    (funct),
		.immediate(immediate),
		.address  (j_address),
		.read     (read)
		);
		
	// ALUSrc ALUSRC_MOD(AluSrc, regfile_read_data1, regfile_read_data2, ext_immidiate, shamt, alu_src_out1, alu_src_out2);
	ALUSrc ALUSRC_MOD(
		.AluSrc            (AluSrc),
		.regfile_read_data1(regfile_read_data1),
		.regfile_read_data2(regfile_read_data2),
		.ext_immidiate     (ext_immidiate),
		.shamt             (shamt),
		.alu_src_out1      (alu_src_out1),
		.alu_src_out2      (alu_src_out2)
		);
	// DM DM_MOD(alu_out, regfile_read_data2, MemRead, MemWrite, clk, mem_out);
	DM DM_MOD(
		.addr_in   (alu_out),
		.write_data(regfile_read_data2),
		.MemRead   (MemRead),
		.MemWrite  (MemWrite),
		.clk       (clk),
		.out       (mem_out)
		);

endmodule

`endif