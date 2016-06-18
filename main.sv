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
    output wire display_clk_cpu,
	output reg [6 : 0] display_data,
    output reg [7 : 0] display_en,
    output reg [14 : 0] LED//display_pc
    );
    wire clk_led, clk_cpu;
    wire [31 : 0] display_7segs;
    
    assign display_clk_cpu = stop == 1'b1 ? 1'b0 : clk_cpu;
    CPU CPU_MOD(
        .clk            (clk_cpu),
        .stop           (stop),
        .display_7segs  (display_7segs),
        .display_led    (LED)
        );
    Clk CLK_MOD(
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