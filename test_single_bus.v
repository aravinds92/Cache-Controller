`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:07:00 12/07/2015
// Design Name:   single_bus1
// Module Name:   X:/xilinx551/cache_controller/test_single_bus.v
// Project Name:  cache_controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: single_bus1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_single_bus;

	// Inputs
	reg clk;
	reg rst;
	reg read_op;
	reg [7:0] in_address;
	reg [7:0] in_data;
	reg start;
	

	// Outputs
	wire [7:0] out_data;
	wire finish_flag;

	// Instantiate the Unit Under Test (UUT)
	single_bus1 uut (
		.clk(clk), 
		.rst(rst), 
		.read_op(read_op), 
		.in_address(in_address), 
		.in_data(in_data), 
		.out_data(out_data), 
		.finish_flag(finish_flag),
		.start(start)
	);
always #5 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		read_op =1;
		in_address = 8'd1;
		
		#10
		rst =0;
		read_op =1;
		start =1 ;
		in_address = 8'd1;
		#10
		start = 0;
		#60
		start = 1;
		read_op = 1;
		in_address =8'd3;
		#10
		start = 0;
		
		#60
		start=1;
		read_op = 1;
		in_address =8'd1;
		#10
		start=0;
		#60
		read_op = 1;
		in_address =8'd5;
		
		
		#60
		start =1;
		read_op = 0;
		in_address = 8'd5;
		in_data =8'd11;
		#20
		//start =0;
		
		#100
		start = 1;
		read_op = 1;
		in_address =8'd5;
		
		#10 
		start =0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

