`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:30:21 11/26/2015 
// Design Name: 
// Module Name:    queue 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module queue(clk, rst, in_data, out_data, read_en, write_en, empty);
input clk, rst, read_en, write_en;
input [7:0] in_data;
output reg [7:0] out_data;
output reg empty;
reg [7:0] data_memory [0:15];				//Memory capacity is 8
reg [4:0] read_addr, write_addr;
integer i;
always@(posedge clk)
begin
	if(rst)
	begin
		read_addr=0;
		write_addr=0;
		out_data=0;
		empty = 1;
		for(i=0; i<16; i=i+1)
		begin
			data_memory[i] = 0;
		end	
	end
	
		if(read_en)
		begin
			out_data = 	data_memory[read_addr];
			read_addr = read_addr + 1;
			empty = 0;
		end
	
	else if(write_en == 1)
		begin
			data_memory[write_addr] = in_data;
			write_addr=write_addr+1;
		end	
		
	if(read_addr == 16)
		begin
			read_addr = 0;
			empty = 1;
		end
	if(write_addr == 16)
		write_addr = 0;
end

endmodule
