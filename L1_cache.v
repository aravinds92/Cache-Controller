`timescale 1ns / 1ns

module L1_cache( out_data, cache_clk, read_select, write_select, write_data, write_enable, rst);

input cache_clk;
input [7:0] write_data;
input [2:0] write_select;
input	[2:0] read_select;
input write_enable;
input rst;

output reg [7:0] out_data;
 
reg [7:0] data_memory [0:7];				//Memory capacity is 8
		
integer i;

  
		// reading out data from cache
		always @ (posedge cache_clk)
				begin
					if(rst)
						out_data=0;
					else
						out_data = data_memory [read_select];
				end
		
		
		// writing new data into the cache
		always @ (posedge cache_clk)
				begin
					if(rst)
						for (i = 0; i < 8; i = i + 1) 
						begin 
							data_memory[i] = 8'd0;
						end   
						
					else
						if(write_enable)
						begin
							data_memory [write_select] = write_data;
						end
				 end
		
endmodule
