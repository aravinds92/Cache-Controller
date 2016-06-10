`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:11:12 12/16/2015
// Design Name:   top_inter
// Module Name:   X:/xilinx551/cache_controller/inter_test.v
// Project Name:  cache_controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_inter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module inter_test;

	// Inputs
	reg clk;
	reg rst;
	reg read_operation1, read_operation2;
	reg [7:0] in_address1;
	reg [7:0] in_address2;
	reg [7:0] in_data1;
	reg [7:0] in_data2;
	reg start1;
	reg start2;

	// Outputs
	wire [7:0] out_data1;
	wire [7:0] out_data2;
	wire hit1;
	wire hit2;
	// Instantiate the Unit Under Test (UUT)
	top_inter uut (
		.clk(clk), 
		.rst(rst), 
		.read_operation1(read_operation1), 
		.read_operation2(read_operation2), 
		.in_address1(in_address1), 
		.in_address2(in_address2), 
		.in_data1(in_data1), 
		.in_data2(in_data2), 
		.start1(start1), 
		.start2(start2), 
		.out_data1(out_data1), 
		.out_data2(out_data2), 
		.hit1(hit1), 
		.hit2(hit2)
	);
always #1 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		read_operation1=0;
		read_operation2=0;
		in_address1 = 0;
		in_address2 = 0;
		in_data1 = 0;
		in_data2 = 0;
		start1 = 0;
		start2 = 0;
		
		#9
		rst=0;
		
		
		#10												//Read miss
		rst=0;
		read_operation1 = 1;
		read_operation2 = 1;
		start1 = 1;
		start2 = 1;
		in_address1 = 1;
		in_address2 = 1;
		#2
		start1=0;
		start2=0;
		
		#20
		start1 = 1;
		start2 = 1;
		read_operation1 = 1;
		read_operation2 = 0;
		in_address1 = 4;
		in_address2 = 1;
		in_data2 = 99;
		#2
		start1 = 0;
		start2 = 0;
		
		#30
		start1 = 1;
		read_operation1 = 1;
		in_address1 = 1;
		#2
		start1 = 0;
		/*#20
		start1 = 1;
		read_operation1 = 1;
		in_address1 = 1;
		#2
		start1 = 0;*/
		/*#20
		start2 = 1;
		read_operation2 = 0;
		in_address2 = 1;
		in_data2 = 156;
		#2
		start2 = 0;	
		
		#40
		read_operation1 = 1;
		start1 = 1;
		in_address1 = 1;
		#2
		start1 = 0;*/
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

