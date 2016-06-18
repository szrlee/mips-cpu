`ifndef _main
`define _main

`timescale 1ns / 1ps
`include "def.vh"
`include "led.sv"
`include "Clk.sv"
`include "CPU.sv"

module main(
    input wire clk_board,
    output wire clk_cpu,
	output reg [6 : 0] display_data,
    output reg [7 : 0] display_en,
    output reg [14 : 0] LED//display_pc
    );
    wire clk_led;
    wire [31 : 0] display_syscall;
    CPU CPU_MOD(
        .clk            (clk_cpu),
        .display_syscall(display_syscall),
        .display_pc     (LED)
        );
    Clk CLK_MOD(
        .clk_board(clk_board),
        .clk_cpu  (clk_cpu),
        .clk_led  (clk_led)
        );	
      	
    led LED_MOD(
        .clk         (clk_led),
        .in_data     (display_syscall),
        .display_data(display_data),
        .display_en  (display_en)
        );

endmodule

`endif