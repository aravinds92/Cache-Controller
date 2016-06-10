`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:17:22 11/22/2015
// Design Name:   cache_controller
// Module Name:   X:/xilinx551/cache_controller/CC_test.v
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

module CC_test_1;

	// Inputs
	reg start;
	reg CC_clk;
	reg read_en;
	reg [7:0] address;
	reg [2:0] write_select;
	reg [7:0] write_data_L1;
	reg [5:0] write_data_TA;
	reg write_enable_L1;
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
		.read_en(read_en), 
		.address(address), 
		.write_select(write_select), 
		.write_data_L1(write_data_L1), 
		.write_data_TA(write_data_TA), 
		.write_enable_L1(write_enable_L1),
		.rst(rst)
	);
always #1 CC_clk=~CC_clk;
	initial begin
		// Initialize Inputs
		start = 0;
		rst=1;
		CC_clk = 0;
		read_en = 0;
		address = 0;
		write_select = 0;
		write_data_L1 = 0;
		write_data_TA = 0;
		write_enable_L1 = 0;
		#10
		rst=0;
		#10
		write_enable_L1=1'd1;
		write_data_L1=8'd2;
		write_data_TA=6'd45;
		write_select=3'd0;
		#10
		write_data_TA=6'd36;
		write_select=3'd1;
		#10
		write_data_TA=6'd37;
		write_select=3'd2;
		#10
		write_data_TA=6'd40;
		write_select=3'd3;
		#10
		write_data_TA=6'd33;
		write_select=3'd4;
		#10
		write_data_TA=6'd45;
		write_select=3'd5;
		#10
		write_data_TA=6'd53;
		write_select=3'd6;
		#10
		write_data_TA=6'd50;
		write_select=3'd7;
		#10
		start=1;
		write_enable_L1=0;
		read_en = 1;
		address = 8'd104;
		#10
		address = 8'd45;
		#10
		read_en = 0;
		address = 8'd104;
		#10
		address = 8'd45;
		

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

