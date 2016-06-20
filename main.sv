`ifndef _main
`define _main

`timescale 1ns / 1ps
`include "def.vh"
`include "led.sv"
`include "Clk.sv"
`include "CPU.sv"

module main(
    input wire clk_board,
    input wire stop,
    input wire Debug_DM,
    input wire [9 : 0] switch_in,
    output wire clk_cpu,
	output reg [6 : 0] display_data,
    output reg [7 : 0] display_en,
    output reg [14 : 0] LED//display_pc
    );
    wire clk_led, clk_cpu;
    wire [31 : 0] display_7segs;
    
    CPU CPU_MOD(
        .clk            (clk_cpu),
        .stop           (stop),
        .Debug_DM       (Debug_DM),
        .switch_in      (switch_in),
        .display_7segs  (display_7segs),
        .display_led    (LED)
        //.display_clk_cpu(display_clk_cpu)
        );
    Clk CLK_MOD(
        .stop     (stop),
        .clk_board(clk_board),
        .clk_cpu  (clk_cpu),
        .clk_led  (clk_led)
        );	
      	
    led LED_MOD(
        .clk         (clk_led),
        .in_data     (display_7segs),
        .display_data(display_data),
        .display_en  (display_en)
        );

endmodule

`endif