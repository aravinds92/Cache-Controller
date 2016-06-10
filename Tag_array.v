`timescale 1ns / 1ns

module Tag_array( out_data, TA_clk, read_select, write_select, write_data, write_enable, rst, finish, read_enable);

input TA_clk;
input [5:0] write_data;
input [2:0] write_select;
input	[2:0] read_select;
input write_enable;
input rst;
input read_enable;

output reg [5:0] out_data;
output reg finish;

reg [5:0] data_memory [0:7];				//Memory capacity is 8 of 6bits length, 5 address bits and 1 valid bit.
integer i;		
		
		// reading out data from cache
		always @ (posedge TA_clk)
				begin	
					if(rst)
					begin
						out_data=0;
						finish=0;
					end	
					else	if(finish == 1)
						finish = 0;
					else if(read_enable)
						begin
							finish = 1;
							out_data = data_memory [read_select];
						end
				end
		
		
		// writing new data into the cache
		always @ (posedge TA_clk)
				begin
					if(rst)
						for (i = 0; i < 8; i = i + 1) 
						begin 
							data_memory[i] = 6'd0;
						end  
						
					else
					
					if(write_enable)
						begin
							data_memory [write_select] = write_data;
						end
				 end
		
endmodule
