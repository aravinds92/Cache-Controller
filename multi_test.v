`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:13:52 12/11/2015
// Design Name:   multiplebus
// Module Name:   X:/xilinx551/cache_controller/multi_test.v
// Project Name:  cache_controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: multiplebus
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module multi_test;

	// Inputs
	reg clk;
	reg rst;
	reg write_op1;
	reg write_op2;
	reg [7:0] in_address1;
	reg [7:0] in_address2;
	reg [7:0] in_data1;
	reg [7:0] in_data2;
	reg start1;
	reg start2;

	// Outputs
	wire [7:0] out_data1;
	wire [7:0] out_data2;
	wire finish_flag1;
	wire finish_flag2;
	wire read_busy; 
	wire write_busy;

	// Instantiate the Unit Under Test (UUT)
	multiplebus uut (
		.clk(clk), 
		.rst(rst), 
		.write_op1(write_op1), 
		.write_op2(write_op2), 
		.in_address1(in_address1), 
		.in_address2(in_address2), 
		.in_data1(in_data1), 
		.in_data2(in_data2), 
		.start1(start1), 
		.start2(start2), 
		.out_data1(out_data1), 
		.out_data2(out_data2), 
		.finish_flag1(finish_flag1), 
		.finish_flag2(finish_flag2),
		.read_busy(read_busy),
		.write_busy(write_busy)
	);
always #1 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		write_op1 = 0;
		write_op2 = 0;
		in_address1 = 0;
		in_address2 = 0;
		in_data1 = 0;
		in_data2 = 0;
		start1 = 0;
		start2 = 0;
		#10
		rst=0;
		#20
		start1=1;
		in_address1 = 8'd5;
		in_address2 = 8'd6;
		write_op1 = 0;
		#2
		start1=0;
		start2=0;
		#20
		start2=1;
		in_address1 = 8'd5;
		in_address2 = 8'd6;
		write_op2 = 0;
		#2
		start1=0;
		start2=0;
		#20
		start1=1;
		in_address1 = 8'd5;
		in_data1 = 8'd1;
		in_address2 = 8'd6;
		write_op1 = 1;
		#2
		start1=0;
		start2=0;
	   #20
		start2=1;
		in_address1 = 8'd5;
		in_data2 = 8'd1;
		in_address2 = 8'd5;
		write_op2 = 1;
		#2
		start1=0;
		start2=0;
		#20
		start1=1;
		start2=1;
		in_address1 = 8'd5;
		in_data2 = 8'd2;
		in_address2 = 8'd5;
		write_op2 = 1;
		write_op1 = 0;
		#2
		start1=0;
		start2=0;
		#20
		start1=1;
		start2=1;
		in_address1 = 8'd5;
		in_data1 = 8'd2;
		in_address2 = 8'd5;
		write_op2 = 0;
		write_op1 = 1;
		#2
		start1=0;
		start2=0;
		/*#10
		start1=1;
		in_address1 = 8'd5;
		#2
		start1=0;*/
		/*#10
		start2=1;
		in_address1 = 8'd5;
		#2
		start2=0;*/
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

