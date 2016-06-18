`ifndef _ALU
`define _ALU

`include "def.vh"
`timescale 1ns / 1ps
// only for 32 bit
module ALU(
	input wire [3 : 0] op,
    input wire [31 : 0] in1, in2,
    output reg [31 : 0] out,
    output reg equal
	);

    always_comb begin
        if(in1 == in2) begin
            equal = 1'b1;
        end
        else begin 
            equal = 1'b0;
        end
    end

//`define ALU_SLL 4'd0
//`define ALU_SRA 4'd1
//`define ALU_SRL 4'd2
//`define ALU_MUL 4'd3
//`define ALU_DIV 4'd4
//`define ALU_ADD 4'd5
//`define ALU_SUB 4'd6
//`define ALU_AND 4'd7
//`define ALU_OR 4'd8
//`define ALU_XOR 4'd9
//`define ALU_NOR 4'd10
//`define ALU_CMP 4'd11
//`define ALU_CMPU 4'd12

    always_comb begin
        case (op)
        	`ALU_SLL: begin
        	   out = in1 << in2[4 : 0];
        	end
        	`ALU_SRA: begin
        		out = $signed(in1) >>> in2[4 : 0];
        	end
        	`ALU_SRL: begin
        		out = in1 >> in2[4 : 0];
        	end
        	`ALU_ADD: begin 
                out = in1 + in2;
        	end
        	`ALU_SUB: begin 
                out = in1 - in2;
        	end
        	`ALU_AND: begin
        		out = in1 & in2;
        	end
        	`ALU_OR: begin
        		out = in1 | in2;
        	end
        	`ALU_XOR: begin
        		out = in1 ^ in2;
        	end
        	`ALU_NOR: begin
        		out = ~(in1 | in2);
        	end
        	`ALU_CMP: begin
        		out = ($signed(in1) < $signed(in2)) ? 1 : 0;
        	end
        	`ALU_CMPU: begin
        		out = ($unsigned(in1) < $unsigned(in2)) ? 1 : 0;
        	end
            default: begin
            	out = 32'bz;
        	end
        endcase
    end

endmodule

`endif
