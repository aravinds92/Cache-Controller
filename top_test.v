`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:17:12 12/04/2015
// Design Name:   top
// Module Name:   X:/xilinx551/cache_controller/top_test.v
// Project Name:  cache_controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_test;

	// Inputs
	reg clk;
	reg rst;
	reg start;
	reg store1;
	reg store2;
	reg [7:0] input_data_1, input_data_2;

	// Outputs
	wire hit_1;
	wire hit_2;
	wire [7:0] read_data_1;
	wire [7:0] read_data_2;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.store1(store1), 
		.store2(store2), 
		.hit_1(hit_1), 
		.hit_2(hit_2), 
		.read_data_1(read_data_1), 
		.read_data_2(read_data_2),
		.input_data_1(input_data_1),
		.input_data_2(input_data_2)
	);
always #1 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		start = 0;
		store1 = 0;
		store2 = 0;
		#10
		rst = 0;
		store1=1;
		store1=1;
		start=0;
		input_data_1=8'd1;	//Operation
		input_data_2=8'd0;
		#2
		input_data_1=8'd1;
		input_data_2=8'd0;
		/*#2
		input_data_1=8'd0;
		input_data_2=8'd0;
		#2
		input_data_1=8'd0;
		input_data_2=8'd1;
		#2
		input_data_1=8'd1;
		input_data_2=8'd1;
		#2
		input_data_1=8'd1;
		input_data_2=8'd0;
		#2
		input_data_1=8'd1;
		input_data_2=8'd0;
		#2
		input_data_1=8'd0;
		input_data_2=8'd1;
		#2
		input_data_1=8'd0;
		input_data_2=8'd0;
		#2
		input_data_1=8'd1;
		input_data_2=8'd1;*/
		#2
		input_data_1=8'd12;	//Read address
		input_data_2=8'd5;
		#2
		input_data_1=8'd1;	
		input_data_2=8'd15;
		/*#2
		input_data_1=8'd8;	
		input_data_2=8'd50;
		#2
		input_data_1=8'd13;	
		input_data_2=8'd65;
		#2
		input_data_1=8'd59;	
		input_data_2=8'd69;
		#2
		input_data_1=8'd3;	
		input_data_2=8'd48;
		#2
		input_data_1=8'd33;	
		input_data_2=8'd72;
		#2
		input_data_1=8'd49;	
		input_data_2=8'd254;
		#2
		input_data_1=8'd67;	
		input_data_2=8'd32;
		#2
		input_data_1=8'd10;	
		input_data_2=8'd66;*/
		#2
		input_data_1=8'd23;	//Write address	
		input_data_2=8'd55;
		#2
		input_data_1=8'd79;	
		input_data_2=8'd234;
		/*#2
		input_data_1=8'd131;	
		input_data_2=8'd64;
		#2
		input_data_1=8'd240;	
		input_data_2=8'd230;
		#2
		input_data_1=8'd101;	
		input_data_2=8'd28;
		#2
		input_data_1=8'd57;	
		input_data_2=8'd54;
		#2
		input_data_1=8'd99;	
		input_data_2=8'd78;
		#2
		input_data_1=8'd42;	
		input_data_2=8'd155;
		#2
		input_data_1=8'd43;	
		input_data_2=8'd225;
		#2
		input_data_1=8'd95;	
		input_data_2=8'd103;*/
		#2
		input_data_1=8'd1;	//Write data
		input_data_2=8'd2;
		#2
		input_data_1=8'd3;	
		input_data_2=8'd4;
		/*#2
		input_data_1=8'd5;	
		input_data_2=8'd6;
		#2
		input_data_1=8'd7;	
		input_data_2=8'd8;
		#2
		input_data_1=8'd9;	
		input_data_2=8'd10;
		#2
		input_data_1=8'd11;	
		input_data_2=8'd12;
		#2
		input_data_1=8'd13;	
		input_data_2=8'd14;
		#2
		input_data_1=8'd15;	
		input_data_2=8'd16;
		#2
		input_data_1=8'd17;	
		input_data_2=8'd18;
		#2
		input_data_1=8'd19;	
		input_data_2=8'd20;*/
		#2
		start=1;
		store1=0;
		store1=0;
		

		

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

