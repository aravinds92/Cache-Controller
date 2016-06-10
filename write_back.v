`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:22:58 12/17/2015 
// Design Name: 
// Module Name:    write_back 
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
module write_back(clk, rst, address, read_data, write_data, start, read_operation, hit, bus_access,  cache_busy, 
								 write_opn_to_bus, out_data_Mem, read_select_Mem, write_select_Mem, write_data_Mem, finish, finish_out, mem_address, mem_data);

input clk, rst, start, finish, read_operation;
input [7:0] address, write_data, out_data_Mem;

output [7:0] mem_address, mem_data;
output reg cache_busy, write_opn_to_bus, hit, bus_access, finish_out;
output reg [7:0] read_data, read_select_Mem, write_select_Mem, write_data_Mem;

//Connections
wire [7:0] out_data_L1;
wire [6:0] out_data_TA;
wire TA_finish;
reg [7:0] write_data_L1;
reg [6:0] write_data_TA;
reg [2:0] L1_read_address, TA_read_address, L1_write_address, TA_write_address;
reg write_mem_enable_L1, write_mem_enable_TA, TA_read_enable;
reg [7:0] write_buffer [0:7];
reg [7:0] write_address_buffer [0:7];
reg [2:0] cnt;
//Usage
reg flag, dirty, x, y;
								 
L1_cache L1 ( out_data_L1 , clk, L1_read_address , L1_write_address , write_data_L1 , write_mem_enable_L1, rst);
//module Tag_array( out_data, TA_clk, read_select, write_select, write_data, write_enable, rst, finish, read_enable);
Tag_array TA( out_data_TA , clk, TA_read_address , TA_write_address , write_data_TA , write_mem_enable_TA, rst, TA_finish, TA_read_enable);

always@(posedge clk)
begin
	if(rst)
	begin	
		cache_busy = 0;
		write_opn_to_bus = 0;
		hit = 0;
		bus_access = 0;
		read_data = 0;
		read_select_Mem = 0;
		write_select_Mem = 0;
		write_data_Mem = 0;
		L1_read_address = 0;
		TA_read_address = 0;
		L1_write_address = 0;
		TA_write_address = 0;
		write_data_L1 = 0;
		write_data_TA = 0;
		write_mem_enable_L1 = 0;
		write_mem_enable_TA = 0;
		TA_read_enable = 0;
		flag = 0;
		dirty = 0;
		x=0;
		y=0;
		finish_out = 0;
		cnt = 0;
	end
	else
	begin
		if(hit == 1)
			hit = 0;
		if(TA_finish)
		begin
			flag = 1;
			TA_read_enable = 0;
			if((out_data_TA[4:0] == address[7:3]) && out_data_TA[5] == 1)
				hit = 1;
			else
				hit = 0;
			if(out_data_TA[6] == 1)
				dirty = 1;
			else
				dirty = 0;
		end
		if(start)
		begin
			cache_busy=1;
			TA_read_address = address[2:0];
			TA_read_enable = 1;
		end
		if(finish_out)
			finish_out = 0;
		if(flag)
		begin
			if(read_operation)
			begin
				if(hit == 1)
				begin
					if(y)
					begin
						read_data = out_data_L1;
						x=0;
						y=0;
						finish_out = 1;
						flag = 0;
					end
					else
					if(x)
						y=1;
					else
					begin
						L1_read_address = address[2:0];
						x=1;
					end
				end
				else
				begin
					if(finish)
					begin
						if(dirty)
						begin
							write_buffer[cnt] = out_data_L1;
							write_address_buffer[cnt] = address;
							cnt = cnt + 1;
						end
						flag = 0;
						finish_out = 1;
						cache_busy = 0;
						read_data = out_data_Mem;
						TA_write_address = address[2:0];	
						L1_write_address = address[2:0];
						write_mem_enable_L1=1;
						write_mem_enable_TA=1;
						write_data_L1 = out_data_Mem;
						write_data_TA[4:0] = address[7:3];
						write_data_TA[6:5] = 2'b01;
					end
					else 
					begin
						L1_read_address = address[2:0];
						mem_address = address;
						bus_access = 1;
						write_opn_to_bus = 0;
					end
				end
			end
			else
			if(!read_operation)
			begin
				if(hit && dirty)
				begin
					if(y)
					begin
						finish_out = 1;
						write_buffer[cnt] = out_data_L1;
						write_address_buffer[cnt] = address;
						cnt = cnt + 1;
						x=0;
						y=0;
						TA_write_address = address[2:0];	
						L1_write_address = address[2:0];
						write_mem_enable_L1=1;
						write_mem_enable_TA=1;
						write_data_L1 = write_data;
						write_data_TA[4:0] = address[7:3];
						write_data_TA[6:5] = 2'b01;
					end
					else if(x)
						y=1;
					else
					begin
						L1_read_address = address[2:0];
						x=1;	
					end
				end	
				else if(hit && !dirty)
				begin
					finish_out = 1;
					write_mem_enable_L1=1;
					write_mem_enable_TA=1;
					write_data_L1 = write_data;
					write_data_TA[4:0] = address[7:3];
					write_data_TA[6:5] = 2'b11;
				end
					else if(!hit)
					begin
						
						if(finish)
							finish_out = 1;
							
						if(y)
						begin
							write_buffer[cnt] = out_data_L1;
							write_address_buffer[cnt] = address;
							cnt = cnt + 1;
							L1_write_address = address[2:0];
							write_mem_enable_L1=1;
							TA_write_address = address[2:0];	
							write_mem_enable_TA=1;
							write_data_L1 = write_data;
							write_data_TA[4:0] = address[7:3];
							write_data_TA[6:5] = 2'b01;
							mem_address = address;
							write_opn_to_bus = 1;
							bus_access = 1;
						end
						
						else if(x)
							y=1;	
							
						else if(dirty)
						begin
							L1_read_address = address[2:0];
							x = 1;
						end
						
						if(!dirty)
						begin
							mem_address = address;
							write_opn_to_bus = 1;
							bus_access = 1;
						end	
					end
			end
		end
		else
		begin
			write_mem_enable_L1=0;
			write_mem_enable_TA=0;
			bus_access = 0;
		end	
	end	
end	
endmodule
