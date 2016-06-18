`ifndef _led
`define _led

`timescale 1ns / 1ps

module led(
	input wire clk,
	input wire [31 : 0] in_data,
	output reg [6 : 0] display_data,
	output reg [7 : 0] display_en
    );
      
      reg [3 : 0] data_single_num [7 : 0];
      reg [2 : 0] index = 0;
      always_ff @(posedge clk) begin
          index = index + 1;
      end
      always_comb begin
            data_single_num[7] = in_data[31 : 28];
            data_single_num[6] = in_data[27 : 24];
            data_single_num[5] = in_data[23 : 20];
            data_single_num[4] = in_data[19 : 16];
            data_single_num[3] = in_data[15 : 12];
            data_single_num[2] = in_data[11 :  8];
            data_single_num[1] = in_data[7  :  4];
            data_single_num[0] = in_data[3  :  0];
      end

	always_comb begin
		case (data_single_num[index])
            4'h0: display_data = 7'b0000001;
            4'h1: display_data = 7'b1001111;
            4'h2: display_data = 7'b0010010;
            4'h3: display_data = 7'b0000110;
            4'h4: display_data = 7'b1001100;
            4'h5: display_data = 7'b0100100;
            4'h6: display_data = 7'b0100000;
            4'h7: display_data = 7'b0001111;
            4'h8: display_data = 7'b0000000;
            4'h9: display_data = 7'b0001100;
            4'ha: display_data = 7'b0001000;
            4'hb: display_data = 7'b1100000;
            4'hc: display_data = 7'b1110010;
            4'hd: display_data = 7'b1000010;
            4'he: display_data = 7'b0110000;
            4'hf: display_data = 7'b0111000;
            default: display_data = 7'b1111111;

//		    4'h0: display_data = 8'b00000011;
//		    4'h1: display_data = 8'b10011111;
//          4'h2: display_data = 8'b00100101;
//          4'h3: display_data = 8'b00001101;
//          4'h4: display_data = 8'b10011001;
//          4'h5: display_data = 8'b01001001;
//          4'h6: display_data = 8'b01000001;
//          4'h7: display_data = 8'b00011011;
//          4'h8: display_data = 8'b00000001;
//          4'h9: display_data = 8'b00001001;
//          4'ha: display_data = 8'b00010001;
//          4'hb: display_data = 8'b11000001;
//          4'hc: display_data = 8'b11100101;
//          4'hd: display_data = 8'b10000101;
//          4'he: display_data = 8'b01100001;
//          4'hf: display_data = 8'b01110001;
//          default: display_data = 8'b11111111;
		endcase
	end

	always_comb begin 
		case (index)
		  3'h0: display_en = 8'b11111110;
		  3'h1: display_en = 8'b11111101;
		  3'h2: display_en = 8'b11111011;
		  3'h3: display_en = 8'b11110111;
		  3'h4: display_en = 8'b11101111;
		  3'h5: display_en = 8'b11011111;
		  3'h6: display_en = 8'b10111111;
		  3'h7: display_en = 8'b01111111;
		  default : display_en = 8'b11111111;
		endcase
	end

endmodule

`endif 