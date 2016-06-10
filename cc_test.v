`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:43:25 11/22/2015
// Design Name:   cache_controller
// Module Name:   X:/xilinx551/cache_controller/cc_test.v
// Project Name:  cache_controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cache_controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cc_test;

	// Inputs
	reg start;
	reg CC_clk;
	reg read_operation;
	reg [7:0] address;
	reg [7:0] write_data;
	reg rst;

	// Outputs
	wire [7:0] read_data;
	wire hit;
	wire miss;

	// Instantiate the Unit Under Test (UUT)
	cache_controller uut (
		.read_data(read_data), 
		.hit(hit), 
		.miss(miss), 
		.start(start), 
		.CC_clk(CC_clk), 
		.read_operation(read_operation), 
		.address(address), 
		.write_data(write_data), 
		.rst(rst)
	);
	always #1 CC_clk=~CC_clk;
	initial begin
		// Initialize Inputs
		start = 0;
		CC_clk = 0;
		read_operation = 0;
		address = 0;
		write_data = 8'd1;
		rst = 1;
		#10
		rst=0;
		start=1;
		read_operation=0;
		#10
		read_operation=0;
		address=8'd0;
		write_data=8'd5;
		#10
		address=8'd0;
		write_data=8'd15;
		#10
		address=8'd1;
		write_data=8'd15;
		#10
		address=8'd0;
		read_operation = 1;
		#10
		address = 8'd15;
		/*write_data=8'd15;
		#10
		address=8'd3;
		write_data=8'd15;
		#10
		address=8'd4;
		write_data=8'd15;
		#10
		address=8'd5;
		write_data=8'd15;
		#10
		address=8'd6;
		write_data=8'd15;
		#10
		address=8'd7;
		write_data=8'd15;
		#10
		address=8'd8;
		write_data=8'd15;
		#10
		address=8'd0;
		write_data=8'd20;*/
		
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

