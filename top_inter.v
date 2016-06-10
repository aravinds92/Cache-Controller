`timescale 1ns / 1ps

module top_inter(clk ,rst, read_operation1, read_operation2, in_address1, in_address2, in_data1, in_data2, start1, start2, out_data1, out_data2, hit1, hit2 );

input clk, rst;
input read_operation1, read_operation2, start1, start2;
input [7:0] in_address1, in_address2;
input [7:0] in_data1, in_data2;

output wire [7:0] out_data1, out_data2;
output hit1,hit2;

wire write_op1, write_op2;
wire finish_flag1, finish_flag2;
wire [7:0] write_select_Mem1, write_select_Mem2, write_data_Mem1, write_data_Mem2;
wire bus_access1, bus_access2;
wire [7:0] out_data_Mem1, out_data_Mem2;
wire flag_to_1, flag_to_2;
wire [7:0] address_to_1, address_to_2;
wire finish_out_1, finish_out_2; 

//module multiplebus(clk, rst, write_op1, write_op2, in_address1, in_address2, in_data1, in_data2, start1, start2, out_data1, out_data2, finish_flag1, finish_flag2, 
//read_busy, write_busy, flag_to_1, flag_to_2, address_to_1, address_to_2); //start = bus_access

//module cc_singlebus (CC_clk, rst, address, read_data, write_data, start, read_operation, hit, cache_busy, 
								 //write_opn_to_bus, out_data_Mem, read_select_Mem, write_select_Mem, write_data_Mem, finish, bus_access, finish_out, flag_snoop, snoop_address);


multiplebus busmem1(clk, rst, write_op1, write_op2, write_select_Mem1, write_select_Mem2, write_data_Mem1, write_data_Mem2, bus_access1, bus_access2, out_data_Mem1,
             out_data_Mem2, finish_flag1, finish_flag2, read_busy, write_busy, flag_to_1, flag_to_2, address_to_1, address_to_2);

cc_singlebus cc1(clk, rst, in_address1, out_data1, in_data1, start1, read_operation1, hit1, cache_busy1, 
								 write_op1, out_data_Mem1, read_select_Mem, write_select_Mem1, write_data_Mem1, finish_flag1, bus_access1, finish_out_1, flag_to_1, address_to_1);

cc_singlebus cc2(clk, rst, in_address2, out_data2, in_data2, start2, read_operation2, hit2, cache_busy2, 
								 write_op2, out_data_Mem2, read_select_Mem, write_select_Mem2, write_data_Mem2, finish_flag2, bus_access2, finish_out_1, flag_to_2, address_to_2);


endmodule



























//module multiplebus(clk, rst, write_op1, write_op2, in_address1, in_address2, in_data1, in_data2, start1, start2, out_data1, out_data2, finish_flag1, finish_flag2, read_busy, write_busy); //start = bus_access
//module cc_singlebus (CC_clk, rst, address, read_data, write_data, start, read_operation, hit, cache_busy, 
//								 write_opn_to_bus, out_data_Mem, read_select_Mem, write_select_Mem, write_data_Mem, finish, bus_access);