`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:07:12 12/02/2015 
// Design Name: 
// Module Name:    top 
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
module top(clk , rst, start, store1, store2, hit_1, hit_2, read_data_1, read_data_2, input_data_1, input_data_2);

input wire start;
input store1, store2;
input clk;
input rst;
input [7:0] input_data_1, input_data_2;
output hit_1, hit_2;
output read_data_1, read_data_2;

wire bus_busy;

// CPU1 wires 
wire cache_busy_1;
wire [7:0] address_1;
wire read_operation_1;
wire start_to_cache_1;
wire [7:0] input_data_1;
wire [7:0] write_data_1;
wire [7:0] read_data_1;
wire [7:0] read_select_Mem_1, write_select_Mem_1, write_data_Mem_1;
wire finish1;
wire cache_write_1;
wire bus_access_1;
wire [7:0] snoop_address_1;
wire [7:0] out_data_Mem_1;
wire flag_to_1;

//CPU2 wires
wire cache_busy_2;
wire [7:0] address_2;
wire read_operation_2;
wire start_to_cache_2;
wire [7:0] input_data_2;
wire [7:0] write_data_2;
wire [7:0] read_data_2;
wire [7:0] read_select_Mem_2, write_select_Mem_2, write_data_Mem_2;
wire finish2;
wire cache_write_2;
wire bus_access_2;
wire [7:0] snoop_address_2;
wire [7:0] out_data_Mem_2;
wire flag_to_2;



//CPU 1 and Cache Controller 1
//CPU_toy (start, clk, rst, bus_busy, cache_busy, address, data, read_operation, store, start_to_cache, input_data);

CPU_toy CPU1(start, clk, rst, bus_busy, cache_busy_1, address_1, write_data_1, read_operation_1, store1, start_to_cache_1, input_data_1);

/* module cache_controller (CC_clk, rst, address, read_data, write_data, start, read_operation, hit, bus_access, cache_busy, write_opn_to_bus, out_data_Mem, 
read_select_Mem, write_select_Mem, write_data_Mem, finish, snoop_address); */

cache_controller Controller1(clk, rst, address_1, read_data_1, write_data_1, start_to_cache_1, read_operation_1, hit_1,  bus_access_1, cache_busy_1, 
									  cache_write_1, out_data_Mem_1, read_select_Mem_1, write_select_Mem_1, write_data_Mem_1, finish1, flag_to_1, snoop_address_1);



//CPU 2 and Cache Controller 2
//CPU_toy (start, clk, rst, bus_busy, cache_busy, address, data, read_operation, store, start_to_cache, input_data);

CPU_toy CPU2(start, clk, rst, bus_busy, cache_busy_2, address_2, write_data_2, read_operation_2, store2, start_to_cache_2, input_data_2);

/* module cache_controller (CC_clk, rst, address, read_data, write_data, start, read_operation, hit, bus_access, cache_busy, write_opn_to_bus, out_data_Mem, 
read_select_Mem, write_select_Mem, write_data_Mem, finish, snoop_address); */

cache_controller Controller2(clk, rst, address_2, read_data_2, write_data_2, start_to_cache_2, read_operation_2, hit_2,  bus_access_2, cache_busy_2, 
									  cache_write_2, out_data_Mem_2, read_select_Mem_2, write_select_Mem_2, write_data_Mem_2, finish2, flag_to_2, snoop_address_2);



// Common bus arbitrator / memory Controller block for cpu1 and cpu2

/*module bus_arbitrator (clk, rst, read_address_1, read_address_2, read_data_1, read_data_2, write_address_1, write_address_2, 
							  write_data_1, write_data_2, finish1, finish2, cache_write_1, cache_write_2, flag_to_1, flag_to_2, 
							  cpu_busy, bus_access_1, bus_access_2, address_to_1, address_to_2);*/
							  
bus_arbitrator Bus1(clk, rst, read_select_Mem_1, read_select_Mem_2, out_data_Mem_1, out_data_Mem_2, write_select_Mem_1, write_select_Mem_2, 
							  write_data_Mem_1, write_data_Mem_2, finish1, finish2, cache_write_1, cache_write_2, flag_to_1, flag_to_2, 
							  bus_busy, bus_access_1, bus_access_2, snoop_address_1, snoop_address_2);
							  

endmodule
