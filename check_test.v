`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:09:08 12/07/2015
// Design Name:   check
// Module Name:   X:/xilinx551/cache_controller/check_test.v
// Project Name:  cache_controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: check
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module check_test;

	// Inputs
	reg a;
	wire b;

	// Instantiate the Unit Under Test (UUT)
	check uut (
		.a(a), 
		.b(b)
	);

always #5 a = ~ a;
	initial begin
		// Initialize Inputs
		a = 0;
		

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

