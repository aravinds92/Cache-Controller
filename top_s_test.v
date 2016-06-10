`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:51:19 12/07/2015
// Design Name:   top_single
// Module Name:   X:/xilinx551/cache_controller/top_s_test.v
// Project Name:  cache_controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_single
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_s_test;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] address;
	reg start;
	reg [7:0] write_data;
	reg read_operation;

	// Outputs
	wire cache_busy;
	wire [7:0] read_data;

	// Instantiate the Unit Under Test (UUT)
	top_single uut (
		.clk(clk), 
		.rst(rst), 
		.address(address), 
		.start(start), 
		.write_data(write_data), 
		.read_operation(read_operation), 
		.cache_busy(cache_busy), 
		.read_data(read_data)
	);
always #1 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		address = 0;
		start = 0;
		write_data = 0;
		read_operation = 0;
		#12
		rst=0;
		start=1;
		read_operation = 1;
		address = 8'd11;
		#2
		start=0;
		#14
		start=1;
		read_operation = 0;
		address = 8'd10;
		write_data = 8'd7;
		#2
		start=0;
		#10
		start=1;
		read_operation = 1;
		address = 8'd10;
		#2
		start=0;
		#8
		start=1;
		read_operation = 0;
		address = 8'd10;
		write_data = 8'd8;
		#2
		start=0;
		#10
		start=1;
		read_operation = 1;
		address = 8'd11;
		#2
		start=0;
		
		
	end
      
endmodule

