`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:41:27 11/26/2015
// Design Name:   queue
// Module Name:   X:/My Documents/Xilinx Projects/cache_controller/cache_controller/queue_test.v
// Project Name:  cache_controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: queue
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module queue_test;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] in_data;
	reg read_en;
	reg write_en;

	// Outputs
	wire [7:0] out_data;
	wire empty;

	// Instantiate the Unit Under Test (UUT)
	queue uut (
		.clk(clk), 
		.rst(rst), 
		.in_data(in_data), 
		.out_data(out_data), 
		.read_en(read_en),
		.write_en(write_en),
		.empty(empty)
	);
always #1 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		in_data = 0;
		read_en = 0;
		write_en=0;
		#10
		rst=0;
		write_en=1;
		in_data=8'd7;
		#2
		in_data=8'd1;
		#10
		read_en=1;
		#10
		read_en=0;
		#10
		read_en=1;
		#22
		read_en=0;
		#2
		read_en=1;
		// Wait 100 ns for global reset to finish
		#200;
        
		// Add stimulus here

	end
      
endmodule

