`timescale 1ns / 1ns

module cache_controller (CC_clk, rst, address, read_data, write_data, start, read_operation, hit,miss, bus_access, cache_busy, 
								 write_opn_to_bus, out_data_Mem, read_select_Mem, write_select_Mem, write_data_Mem, finish, flag_snoop, snoop_address);

input CC_clk;
input start;
input rst;
input finish;		//input from bus arbitrator

//input bus_busy;
input [7:0] address;
input read_operation;
input [7:0] write_data;
input [7:0] out_data_Mem;

//for snooping protocol
input [7:0] snoop_address;
input flag_snoop;

output reg [7:0] read_data;
output reg bus_access;
output hit,miss;
output reg cache_busy;
output reg write_opn_to_bus;
output reg [7:0] read_select_Mem, write_select_Mem, write_data_Mem;

reg [7:0] write_data_L1;
reg [5:0] write_data_TA; 
//reg [7:0] write_data_Mem;
reg write_mem_enable_L1;
reg write_mem_enable_TA;
//reg write_enable_Mem;
//reg [7:0] write_select_Mem;
//reg [7:0] read_select_Mem;
reg flag;
reg hit,miss;
reg [7:0] local_address;

//wire [7:0] out_data_Mem;
wire [7:0] out_data_L1;
wire [5:0] out_data_TA;
reg [2:0] L1_write_address, L1_read_address, TA_write_address, TA_read_address;
reg snoop_hit;

//to get the corresponding output from the L1 cache and the tag array for the given address

L1_cache L1 ( out_data_L1 , CC_clk, L1_read_address , L1_write_address , write_data_L1 , write_mem_enable_L1, rst);

Tag_array TA( out_data_TA , CC_clk, TA_read_address , TA_write_address , write_data_TA , write_mem_enable_TA, rst);


//Main_memory256 M1( out_data_Mem , CC_clk , read_select_Mem , write_select_Mem , write_data_Mem , write_enable_Mem, rst );



		
// using the hit or miss and also the read or write operation, perform the corresponding action.

always@(posedge CC_clk)
begin
	if(rst)
		hit=0;
	else	
	if(start)																				// To figure out if there is a hit or miss
		begin		
			TA_read_address = address[2:0];
		   if(out_data_TA[4:0] == address[7:3] && out_data_TA[5]==1)
				hit=1;
			
			else
				hit=0;
		end	
		
		
	if(rst)	
			begin
				write_mem_enable_L1=0;
				write_mem_enable_TA=0;
				local_address = 0;
				flag <= 0;
				cache_busy=0;
				read_data = 0;
			end	
					

			
	else if(flag_snoop)
				
			begin
				TA_read_address = snoop_address[2:0];
				if(out_data_TA[4:0] == snoop_address[7:3])
					begin
						cache_busy = 1;
						snoop_hit = 1;
						write_mem_enable_TA =1;				
						TA_write_address = snoop_address[2:0];
						write_data_TA[5] = 0; 
					end
			end
				
	else	if(!flag_snoop)
	begin
			snoop_hit = 0;
			
			
			if(start || flag)
				begin
					if(read_operation == 0) 
						begin
							//read_data = 8'd0; ( xxx incase of this)
							write_select_Mem = address;
							write_data_Mem = write_data;
							bus_access = 1;
							write_opn_to_bus = 1;
							cache_busy = 0; 	
							if(hit==1)
									begin
											L1_write_address = address[2:0];
											write_mem_enable_L1=1;
											write_data_L1 = write_data;	
									end
							
							else	if(hit==0)				
									begin
											L1_write_address = address[2:0];
											write_mem_enable_L1=1;
											write_data_L1 = write_data;
											write_mem_enable_TA=1;	
											TA_write_address = address[2:0];											
											write_data_TA[4:0] = address[7:3];
											write_data_TA[5] = 1;
									end
						end
						
						else if(read_operation == 1)
									begin
									if(hit==1)
												begin
													L1_read_address = address[2:0];
													read_data = out_data_L1;
													cache_busy = 0; 
													write_mem_enable_L1=0;
													write_mem_enable_TA=0;
												end
									else
											begin
												if(flag) 
												begin
													if(finish)
													begin	
														flag <= 0;
														cache_busy = 0;
														read_data = out_data_Mem;
														TA_write_address = local_address[2:0];
														L1_write_address = local_address[2:0];
														write_mem_enable_L1=1;
														write_mem_enable_TA=1;
														write_data_L1 = out_data_Mem;
														write_data_TA[4:0] = local_address[7:3];
														write_data_TA[5] = 1;
														bus_access = 0;
													end
												end
												else
												begin
														
														read_select_Mem = address;
														flag <= 1;
														cache_busy= 1;
														bus_access = 1;
														write_mem_enable_L1=0;
														write_mem_enable_TA=0;
														write_opn_to_bus = 0;
														local_address = address;
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




//assign read_data = (hit == 1 && read_operation == 1)  ? out_data_L1 : 8'd0;		
	
assign miss = ~hit;

endmodule
