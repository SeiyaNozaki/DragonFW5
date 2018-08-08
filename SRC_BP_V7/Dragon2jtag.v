`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:06 05/10/2018 
// Design Name: 
// Module Name:    Dragon2jtag 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Dragon2jtag(
    input [7:0] data_in,
    input rst_fifo,
    input clk_in,
    input write_enable_fifo,
    output full_fifo,
    output empty_fifo,
    output [9:0] rd_data_count,
    output [9:0] wr_data_count,
    output error_out,
    output eof_out,
    output tms,
    output tdi,
    output tck,
    input tdo
    );


FIFO_player U0(
	.data_in (data_in[7:0]),
	.rst_fifo (rst_fifo),
	.clk_in (clk_in),
	.write_enable_fifo (write_enable_fifo),
	.full_fifo (full_fifo),
	.empty_fifo (empty_fifo),
	.rd_data_count (rd_data_count[9:0]),
	.wr_data_count (wr_data_count[9:0]),
	.error_out (error_out),
	.eof_out (eof_out),
	.tms (tms),
	.tck (tck),
	.tdi (tdi),
	.tdo (tdo)
	);

endmodule
