`timescale 1ns / 1ps

module Main_memory256(out_data, MM_clk, read_select, write_select, write_data, write_enable, rst, readfinish_flag, writefinish_flag, read_enable);

input MM_clk, rst;
input [7:0] write_data;
input [7:0] write_select;
input	[7:0] read_select;
input write_enable, read_enable;
output reg readfinish_flag, writefinish_flag;
output reg [7:0] out_data;
reg readfinish, writefinish, p1, p2, p3, p4;
integer i;

reg [7:0] data_memory [0: 255];		//Memory capacity is 256
		
		
		// reading out data from Main_memory
		always @ (posedge MM_clk)
				begin	
					if(rst)
					begin
						out_data=0;
						readfinish=0;
					end	
					else if(read_enable)
						begin
						out_data = data_memory [read_select];
						readfinish =1;
						end
					else 
						readfinish =0;
					end
		
		
		// writing new data into the Main_memory
		always @ (posedge MM_clk)
				begin
					if(rst)
						for (i = 0; i < 255; i = i + 1) 
						begin 
							data_memory[i] = 8'd15;
						end   
						
					else
					if(write_enable)
						begin
							data_memory [write_select] = write_data;
							writefinish =1;
						end
					else
						writefinish = 0;	
				 end

always@(posedge MM_clk)
begin
	
	if(rst)
	begin
		readfinish_flag<=0;
		p1<=0;
		p2<=0;
	end
	else if(readfinish==1)
	begin
		p1<=readfinish;
		p2<=p1;
		readfinish_flag <= p1 & ~p2;
	end
	if(p1==1 && p2==0)
	begin
		p1<=0;
		p2<=0;
	end	
end

always@(posedge MM_clk)
begin
	if(rst)
	begin
		writefinish_flag<=0;		//output
		p3<=0;						//register
		p4<=0;
	end
	else if(writefinish == 1)
	begin
		p3<=writefinish;			//from the write module in memory
		p4<=p3;	
		writefinish_flag <= p3 & ~p4;
	end
	if(p3==1 && p4 ==0)
	begin
		p3<=0;
		p4<=0;
	end
end
endmodule
