`ifndef _Debug_DM
`define _Debug_DM
`timescale 1ns / 1ps

module Debug_DM(
    input wire [31 : 0] alu_out,
    input wire MemRead,
    input wire MemWrite,
    input wire Debug_DM_en,
    input wire [9 : 0] switch_in,
    output reg [31 : 0] addr_in,
    output reg DM_MemRead,
    output reg DM_MemWrite
    );
    
    always_comb begin
        if (Debug_DM_en == 1'b1) begin
            DM_MemRead <= 1'b1;
            DM_MemWrite <= 1'b0;
            addr_in <= {22'd0 ,switch_in};
        end
        else begin
            DM_MemRead <= MemRead;
            DM_MemWrite <= MemWrite;
            addr_in <= alu_out;
        end
    end
    
endmodule

`endif