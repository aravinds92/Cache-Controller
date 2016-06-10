`timescale 1ns / 1ps

module single_bus1(clk, rst, write_op, in_address, in_data, out_data, finish_flag, start );

input write_op, rst, clk, start;
input [7:0] in_address, in_data;

output reg [7:0] out_data;
output reg finish_flag;
reg read_enable;
wire readfinish_flag, writefinish_flag;
reg [7:0] mem_address, mem_data;
wire [7:0] mem_data_out;
reg write_enable;



always@(posedge clk)
begin
		if(rst)
		begin
			out_data =0;
			finish_flag =0;
		end
		if(readfinish_flag)
			begin
				finish_flag=1;
				out_data = mem_data_out;
				read_enable =0;
			end
		else	
		
		if(writefinish_flag)
		begin
			finish_flag = 1 ;
			write_enable =0;
		end
		
		else	
		if(start)
		begin	
			if(!write_op)
			begin
					finish_flag=0;
					mem_address = in_address;
					read_enable =1;				
			end
			
			else if(write_op)
			begin
					finish_flag=0;
					write_enable = 1;
					mem_address = in_address;
					mem_data = in_data;
																
			end
		end	
		else
			finish_flag =0;
end

//Main_memory256(out_data, MM_clk, read_select, write_select, write_data, write_enable, rst, readfinish_flag, read_enable);
Main_memory256 jkjk(mem_data_out, clk, mem_address, mem_address, mem_data, write_enable, rst, readfinish_flag, writefinish_flag, read_enable);


endmodule 