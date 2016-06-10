`timescale 1ns / 1ps
module ff(clk, rst, in, out);
input clk, rst, in;
output reg out;
always@(posedge clk)
begin
	if(rst)
		out = 0;
	else
		out = in;
end

endmodule
