`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:37:19 12/07/2015 
// Design Name: 
// Module Name:    top_single 
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
module top_single(clk, rst, address, start, write_data, read_operation, cache_busy, read_data );

input clk, rst, start;
input [7:0] address;
input [7:0] write_data;
input read_operation;

output cache_busy;
output [7:0] read_data;

//module single_bus1(clk, rst, read_op, in_address, in_data, out_data, finish_flag, start );

//module cc_singlebus (CC_clk, rst, address, read_data, write_data, start, read_operation, hit, cache_busy, 
								 //write_opn_to_bus, out_data_Mem, read_select_Mem, write_select_Mem, write_data_Mem, finish, bus_access);

wire write_opn_to_bus;
wire [7:0] read_select_Mem, write_data_Mem, out_data_Mem;
wire finish, bus_access;


cc_singlebus cc420(clk, rst, address, read_data, write_data, start, read_operation, hit, cache_busy, 
								 write_opn_to_bus, out_data_Mem, read_select_Mem, write_select_Mem, write_data_Mem, finish, bus_access);
								 
single_bus1 sb520(clk, rst, write_opn_to_bus, read_select_Mem, write_data_Mem, out_data_Mem, finish, bus_access );

								 
endmodule
