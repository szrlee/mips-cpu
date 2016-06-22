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
`include "Debug_DM.sv"
`include "if_id.sv"
`include "ID.sv"
`include "id_ex.sv"
`include "ex_mem.sv"
`include "mem_wb.sv"
`include "data_dependence.sv"
`include "bypass.sv"


module CPU(
	input wire clk,
	input wire stop,
	input wire Debug_DM,
	input wire [9 : 0] switch_in,
	output wire [31 : 0] display_7segs,
	output wire [14 : 0] display_led
	//output wire display_clk_cpu
);
	reg rst = 1'b1;
	reg [31 : 0] display_syscall;
	wire [31 : 0] display_DM, cycles_counter;
	// pc signal
	wire [31 : 0] pc_if, pc_if_id, pc_id_ex, pc_ex_mem, pc_mem_wb;

	// instruction and decode signal
	wire [31 : 0] instruction_if, instruction_if_id, instruction_id_ex, instruction_ex_mem, instruction_mem_wb;
	wire [5 : 0] opcode_id;
	wire [5 : 0] funct_id, funct_id_ex;
	wire [4 : 0] rs_id;
	wire [4 : 0] rt_id;
	wire [4 : 0] rd_id;
	wire [4 : 0] shamt_id, shamt_id_ex;
	wire [15 : 0] immediate_id;
	wire [25 : 0] address_id, address_id_ex;
	
	// control signal
	wire [1 : 0] Branch_id, Branch_id_ex;
	wire [1 : 0] Jump_id, Jump_id_ex, Jump_ex_mem, Jump_mem_wb;
	wire [1 : 0] AluSrc_id, AluSrc_id_ex;
	wire [2 : 0] AluOp_id, AluOp_id_ex;
	wire ExtOp_id, ExtOp_id_ex;
	wire RegDst_id, RegDst_id_ex, RegDst_ex_mem, RegDst_mem_wb;
	wire RegWrite_id, RegWrite_id_ex, RegWrite_ex_mem, RegWrite_mem_wb;
	wire MemRead_id, MemRead_id_ex, MemRead_ex_mem;
	wire MemWrite_id, MemWrite_id_ex, MemWrite_ex_mem;
	wire MemtoReg_id, MemtoReg_id_ex, MemtoReg_ex_mem, MemtoReg_mem_wb;
	wire JalSrc_id, JalSrc_id_ex;
	wire SyscallSrc_id, SyscallSrc_id_ex;

	// sign extention
	wire [31 : 0] ext_immediate_id, ext_immediate_id_ex;

 	wire DM_MemRead, DM_MemWrite;
	wire Debug_DM_en;
    wire [31 : 0] addr_in;
	// regfile
	reg [4 : 0] regfile_read_num1_syscall_id = 1'b0;
	reg [4 : 0] regfile_read_num2_syscall_id = 1'b0;
	wire [4 : 0] regfile_read_num1_syscall_id_ex;
	wire [4 : 0] regfile_read_num2_syscall_id_ex;
	reg [4 : 0] regfile_write_num_id;
	wire [4 : 0] regfile_write_num_id_ex, regfile_write_num_ex_mem, regfile_write_num_mem_wb;
	wire [31 : 0] regfile_write_data_wb;
	wire [31 : 0] regfile_read_data1_id, regfile_read_data1_id_ex;
	wire [31 : 0] regfile_read_data2_id, regfile_read_data2_id_ex;

	// alu_src
	wire [31 : 0] alu_src_out1_ex;
	wire [31 : 0] alu_src_out2_ex;
	// alu ctrl
	wire [3 : 0] alu_control_out_ex;
	// alu
	wire alu_equal_ex;
	wire [31 : 0] alu_out_ex, alu_out_ex_mem, alu_out_mem_wb;
	// pc src
	wire [31 : 0] pc_src_out_ex;
	wire pc_src_bj_ex;
	wire halt_ex, halt_ex_mem, halt_mem_wb;
	// ram
	wire [31 : 0] ram_write_data_ex_mem;
	wire [31 : 0] ram_read_data_mem, ram_read_data_mem_wb;
	// data denpendence
	wire nop_lock_id;
	// bypass
	wire [31 : 0] bypass_data1_ex, bypass_data2_ex;
	
	always_comb begin
		if(SyscallSrc_id == 1'b1) begin
			regfile_read_num1_syscall_id = 5'd2;
		end
		else begin
			regfile_read_num1_syscall_id = rs_id;
		end
	end
	always_comb begin
		if(SyscallSrc_id == 1'b1) begin
			regfile_read_num2_syscall_id = 5'd4;
		end
		else begin
			regfile_read_num2_syscall_id = rt_id;
		end
	end

	// EX syscall's execution
	assign halt_ex = SyscallSrc_id_ex == 1'b1 ? (bypass_data1_ex == 32'd10 ? 1'b1 : 1'b0) : 1'b0;
	always_ff @(posedge clk) begin 
		rst <= 1'b0;
		if(SyscallSrc_id_ex == 1'b1) begin
			if(bypass_data1_ex == 32'd10) display_syscall <= display_syscall;
			else display_syscall <= bypass_data2_ex;
		end
		else display_syscall <= display_syscall;	
  	end
	
//	assign halt = stop == 1'b1 ? 1'b1 : (SyscallSrc == 1'b1 ? (regfile_read_data1 == 32'd10 ? 1'b1 : 1'b0) : 1'b0);
	assign display_7segs = stop == 1'b1 ? (Debug_DM_en == 1'b1 ? display_DM : cycles_counter) : display_syscall;
//  assign display_clk_cpu = halt == 1'b1 ? (Debug_DM_en == 1'b1 ? 1'b1 : 1'b0) : clk;
    assign Debug_DM_en = stop & Debug_DM;
    assign display_DM = ram_read_data_mem;

  	// EX display cycles & pc
  	assign display_led = {Debug_DM_en, cycles_counter[5 : 0], pc_if[7 : 0]};

/*   	// judge which is wrote
  	always_comb begin
  		if(Jump_id == 2'b10) regfile_write_num_id = 5'd31;
  		else if(RegDst_id == 1'b1) regfile_write_num_id = rd_id;
  		else if(RegDst_id == 1'b0) regfile_write_num_id = rt_id;
  		else regfile_write_num_id = 5'dz;
  	end */
	
	// IF
	PC PC_MOD(
		.clk	(clk),
		.rst 	(rst),
		.halt	(halt_ex),
		.pc_src_in		(pc_src_out_ex),
		.out	(pc_if),
		.pc_bj 	(pc_src_bj_ex),
		.pc_if_id   (pc_if_id),
		.nop_lock_id(nop_lock_id),
		.cycles_counter (cycles_counter)
	);

	// PCSrc PCSRC_MOD(Branch, Jump, Equal, pc_out, ext_immidiate, address, regfile_read_data1, pc_src_out);
	PCSrc PCSRC_MOD(
		.Branch   (Branch_id_ex),
		.Jump     (Jump_id_ex),
		.Equal    (alu_equal_ex),
		.in_pc    (pc_id_ex),
		.in_branch(ext_immediate_id_ex),
		.in_j     (address_id_ex),
		.in_jr    (regfile_read_data1_id_ex),
		.out      (pc_src_out_ex),
		.pc_bj    (pc_src_bj_ex)
	);
	
	// IM IF
	IM IM_MOD(
		.pc_if    		(pc_if),
		.instruction_if	(instruction_if)
	);
	
	// IF -> ID
	if_id IF_ID_MOD(
		.clk				(clk),
		.instruction_if		(instruction_if),
		.pc_if				(pc_if),
		.instruction_if_id	(instruction_if_id),
		.pc_if_id			(pc_if_id),
		.nop_lock_id      	(nop_lock_id),
		.pc_bj         		(pc_src_bj_ex)
	);	

	ID ID_MOD(
		.instruction_if_id(instruction_if_id),
		.opcode           (opcode_id),
		.rs               (rs_id),
		.rt               (rt_id),
		.rd               (rd_id),
		.shamt            (shamt_id),
		.funct            (funct_id),
		.immediate        (immediate_id),
		.address          (address_id)
	);
	

	// EX -> MEM
	ex_mem EX_MEM_MOD(
		.clk                     (clk),
		.pc_id_ex                (pc_id_ex),
		.instruction_id_ex       (instruction_id_ex),
		.RegWrite_id_ex          (RegWrite_id_ex),
		.MemRead_id_ex           (MemRead_id_ex),
		.MemWrite_id_ex          (MemWrite_id_ex),
		.MemtoReg_id_ex          (MemtoReg_id_ex),
		.alu_out_ex              (alu_out_ex),
		.regfile_read_data2_id_ex(bypass_data2_ex),
		.Jump_id_ex              (Jump_id_ex),
		.pc_ex_mem               (pc_ex_mem),
		.instruction_ex_mem      (instruction_ex_mem),
		.RegWrite_ex_mem         (RegWrite_ex_mem),
		.RegDst_ex_mem           (RegDst_ex_mem),
		.MemRead_ex_mem          (MemRead_ex_mem),
		.MemWrite_ex_mem         (MemWrite_ex_mem),
		.MemtoReg_ex_mem         (MemtoReg_ex_mem),
		.Jump_ex_mem             (Jump_ex_mem),
		.alu_out_ex_mem          (alu_out_ex_mem),
		.ram_write_data_ex_mem   (ram_write_data_ex_mem),
		.halt_ex                 (halt_ex),
		.halt_ex_mem             (halt_ex_mem),
		.regfile_write_num_id_ex (regfile_write_num_id_ex),
		.regfile_write_num_ex_mem(regfile_write_num_ex_mem)
	);
  	
	// Ext EXT(immediate, ONEBIT_true, ext_immidiate);
	Ext EXT_MOD(
		.in  (immediate_id),
		.ExtOp (ExtOp_id),
		.out (ext_immediate_id)
	);
	
	data_dependence DATA_DEPENDENCE_MOD(
		.regfile_read_num1_syscall_id(regfile_read_num1_syscall_id),
		.regfile_read_num2_syscall_id(regfile_read_num2_syscall_id),
		.regfile_write_num_id_ex     (regfile_write_num_id_ex),
		.regfile_write_num_ex_mem    (regfile_write_num_ex_mem),
		.nop_lock_id                 (nop_lock_id),
		.clk                         (clk),
		.MemRead_id_ex               (MemRead_id_ex),
		.RegWrite_id_ex              (RegWrite_id_ex)
		);

	// ID -> EX
	id_ex ID_EX_MOD(
		.clk                (clk),
		.pc_if_id           (pc_if_id),
		.funct_id           (funct_id),
		.shamt_id           (shamt_id),
		.ext_immediate_id   (ext_immediate_id),
		.address_id         (address_id),
		.Branch_id          (Branch_id),
		.Jump_id            (Jump_id),
		.AluSrc_id          (AluSrc_id),
		.AluOp_id           (AluOp_id),
		.RegWrite_id        (RegWrite_id),
		.MemRead_id         (MemRead_id),
		.MemWrite_id        (MemWrite_id),
		.MemtoReg_id        (MemtoReg_id),
		.SyscallSrc_id      (SyscallSrc_id),
		.read_data1_id      (regfile_read_data1_id),
		.read_data2_id      (regfile_read_data2_id),
		.pc_id_ex           (pc_id_ex),
		.funct_id_ex        (funct_id_ex),
		.shamt_id_ex        (shamt_id_ex),
		.ext_immediate_id_ex(ext_immediate_id_ex),
		.address_id_ex      (address_id_ex),
		.Branch_id_ex       (Branch_id_ex),
		.Jump_id_ex         (Jump_id_ex),
		.AluSrc_id_ex       (AluSrc_id_ex),
		.AluOp_id_ex        (AluOp_id_ex),
		.RegWrite_id_ex     (RegWrite_id_ex),
		.MemRead_id_ex      (MemRead_id_ex),
		.MemWrite_id_ex     (MemWrite_id_ex),
		.MemtoReg_id_ex     (MemtoReg_id_ex),
		.SyscallSrc_id_ex   (SyscallSrc_id_ex),
		.read_data1_id_ex   (regfile_read_data1_id_ex),
		.read_data2_id_ex   (regfile_read_data2_id_ex),
		.instruction_if_id  (instruction_if_id),
		.instruction_id_ex  (instruction_id_ex),
		.halt_ex            (halt_ex),
		.regfile_write_num_id(regfile_write_num_id),
		.regfile_write_num_id_ex(regfile_write_num_id_ex),
		.nop_lock_id         (nop_lock_id),
		.pc_bj               (pc_src_bj_ex),
		.regfile_read_num1_syscall_id(regfile_read_num1_syscall_id),
		.regfile_read_num2_syscall_id(regfile_read_num2_syscall_id),
		.regfile_read_num1_syscall_id_ex(regfile_read_num1_syscall_id_ex),
		.regfile_read_num2_syscall_id_ex(regfile_read_num2_syscall_id_ex)
	);

	bypass BYPASS_MOD(
		.regfile_write_num_ex_mem       (regfile_write_num_ex_mem),
		.regfile_write_num_mem_wb       (regfile_write_num_mem_wb),
		.regfile_read_num1_syscall_id_ex(regfile_read_num1_syscall_id_ex),
		.regfile_read_num2_syscall_id_ex(regfile_read_num2_syscall_id_ex),
		.RegWrite_ex_mem                (RegWrite_ex_mem),
		.RegWrite_mem_wb                (RegWrite_mem_wb),
		.clk                            (clk),
		.regfile_write_data_wb          (regfile_write_data_wb),
		.alu_out_ex_mem                 (alu_out_ex_mem),
		.regfile_read_data1_id_ex       (regfile_read_data1_id_ex),
		.regfile_read_data2_id_ex       (regfile_read_data2_id_ex),
		.bypass_data1_ex                (bypass_data1_ex),
		.bypass_data2_ex                (bypass_data2_ex)
	);
	
	// RegDst REGDST_MOD(JalSrc, RegDst, rt, rd,, regfile_write_num);
	RegDst REGDST_MOD(
		.Jump      (Jump_id),
		.RegDst    (RegDst_id),
		.rt_num    (rt_id),
		.rd_num    (rd_id),
		.write_num (regfile_write_num_id)
	);
		
	// RegWrData REGWRDATA_MOD(JalSrc, RegDst, rt, rd,, regfile_write_num);
	RegWrData REGWRDATA_MOD(
    	.Jump      (Jump_mem_wb),
		.MemtoReg  (MemtoReg_mem_wb),
		.pc_in     (pc_mem_wb),
		.alu_in    (alu_out_mem_wb),
		.mem_in    (ram_read_data_mem_wb),
		.write_data(regfile_write_data_wb)
	);
		
	// CtrlUnit CTRLUNIT_MOD(opcode, funct, RegDst, RegWrite, MemRead, MemWrite, MemtoReg, AluSrc, JalSrc, AluOp, Branch, Jump, SyscallSrc);
	CtrlUnit CTRLUNIT_MOD(
		.opcode    (opcode_id),
		.funct     (funct_id),
		.ExtOp     (ExtOp_id),
		.RegDst    (RegDst_id),
		.RegWrite  (RegWrite_id),
		.MemRead   (MemRead_id),
		.MemWrite  (MemWrite_id),
		.MemtoReg  (MemtoReg_id),
		.AluSrc    (AluSrc_id),
		.JalSrc    (JalSrc_id),
		.AluOp     (AluOp_id),
		.Branch    (Branch_id),
		.Jump      (Jump_id),
		.SyscallSrc(SyscallSrc_id)
	);

	// RF RF_MOD(clk, rs_syscall, rt_syscall, regfile_write_num, RegWrite, regfile_write_data, regfile_read_data1, regfile_read_data2);
	RF RF_MOD(
		.clk       (clk),
		.read_num1 (regfile_read_num1_syscall_id),
		.read_num2 (regfile_read_num2_syscall_id),
		.write_num (regfile_write_num_mem_wb),
		.write_en  (RegWrite_mem_wb),
		.write_data(regfile_write_data_wb),
		.read_data1(regfile_read_data1_id),
		.read_data2(regfile_read_data2_id)
	);

	// ALU ALU_MOD(alu_control_op_out, regfile_read_data1, alu_src_out, alu_out, of, cf, Equal);
	ALU ALU_MOD(
		.op   (alu_control_out_ex),
		.in1  (alu_src_out1_ex),
		.in2  (alu_src_out2_ex),
		.out  (alu_out_ex),
		.equal(alu_equal_ex)
 	);

	// ALUCtrl ALUCTRL_MOD(AluOp, funct, alu_control_op_out);
	ALUCtrl ALUCTRL_MOD(
		.AluOp	(AluOp_id_ex),
		.funct	(funct_id_ex),
		.out  	(alu_control_out_ex)
	 );

	// ALUSrc ALUSRC_MOD(AluSrc, regfile_read_data1, regfile_read_data2, ext_immidiate, shamt, alu_src_out1, alu_src_out2);
	ALUSrc ALUSRC_MOD(
		.AluSrc            (AluSrc_id_ex),
		.regfile_read_data1(bypass_data1_ex),
		.regfile_read_data2(bypass_data2_ex),
		.ext_immidiate     (ext_immediate_id_ex),
		.shamt             (shamt_id_ex),
		.alu_src_out1      (alu_src_out1_ex),
		.alu_src_out2      (alu_src_out2_ex)
	);
	// DM DM_MOD(alu_out--Debug_DM-->addr_in, regfile_read_data2, MemRead, MemWrite, clk, ram_read_data_mem);
	DM DM_MOD(
		.addr_in   (addr_in),
		.write_data(ram_write_data_ex_mem),
		.MemRead   (DM_MemRead),
		.MemWrite  (DM_MemWrite),
		.clk       (clk),
		.out       (ram_read_data_mem)
	);


  	Debug_DM DEBUG_DM_MOD(
        .alu_out  (alu_out_ex_mem),
        .MemRead  (MemRead_ex_mem),
        .MemWrite (MemWrite_ex_mem),
        .Debug_DM_en (Debug_DM_en),
        .switch_in (switch_in),
        .addr_in   (addr_in),
        .DM_MemRead   (DM_MemRead),
        .DM_MemWrite  (DM_MemWrite)
	);


	// MEM -> WB
	mem_wb MEM_WB_MOD(
		.clk                 (clk),
		.pc_ex_mem           (pc_ex_mem),
		.instruction_ex_mem  (instruction_ex_mem),
		.MemtoReg_ex_mem     (MemtoReg_ex_mem),
		.Jump_ex_mem         (Jump_ex_mem),
		.alu_out_ex_mem      (alu_out_ex_mem),
		.ram_read_data_mem   (ram_read_data_mem),
		.RegWrite_ex_mem     (RegWrite_ex_mem),
		.pc_mem_wb           (pc_mem_wb),
		.instruction_mem_wb  (instruction_mem_wb),
		.MemtoReg_mem_wb     (MemtoReg_mem_wb),
		.Jump_mem_wb         (Jump_mem_wb),
		.alu_out_mem_wb      (alu_out_mem_wb),
		.ram_read_data_mem_wb(ram_read_data_mem_wb),
		.RegWrite_mem_wb     (RegWrite_mem_wb),
		.halt_ex_mem         (halt_ex_mem),
		.halt_mem_wb         (halt_mem_wb),
		.regfile_write_num_ex_mem(regfile_write_num_ex_mem),
		.regfile_write_num_mem_wb(regfile_write_num_mem_wb)
	);
		
endmodule

`endif