`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:20:42 12/07/2015
// Design Name:   cc_singlebus
// Module Name:   X:/xilinx551/cache_controller/cc1_test.v
// Project Name:  cache_controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cc_singlebus
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cc1_test;

	// Inputs
	reg CC_clk;
	reg rst;
	reg [7:0] address;
	reg [7:0] write_data;
	reg start;
	reg read_operation;
	reg [7:0] out_data_Mem;
	reg finish;
	reg flag_snoop;
	reg snoop_address;

	// Outputs
	wire [7:0] read_data;
	wire hit;
	wire bus_access;
	wire cache_busy;
	wire write_opn_to_bus;
	wire [7:0] read_select_Mem;
	wire [7:0] write_select_Mem;
	wire [7:0] write_data_Mem;

	// Instantiate the Unit Under Test (UUT)
	cc_singlebus uut (
		.CC_clk(CC_clk), 
		.rst(rst), 
		.address(address), 
		.read_data(read_data), 
		.write_data(write_data), 
		.start(start), 
		.read_operation(read_operation), 
		.hit(hit), 
		.bus_access(bus_access), 
		.cache_busy(cache_busy), 
		.write_opn_to_bus(write_opn_to_bus), 
		.out_data_Mem(out_data_Mem), 
		.read_select_Mem(read_select_Mem), 
		.write_select_Mem(write_select_Mem), 
		.write_data_Mem(write_data_Mem), 
		.finish(finish), 
		.flag_snoop(flag_snoop), 
		.snoop_address(snoop_address)
	);

	initial begin
		// Initialize Inputs
		CC_clk = 0;
		rst = 0;
		address = 0;
		write_data = 0;
		start = 0;
		read_operation = 0;
		out_data_Mem = 0;
		finish = 0;
		flag_snoop = 0;
		snoop_address = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

