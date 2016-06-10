`timescale 1ns / 1ns

module cc_singlebus (CC_clk, rst, address, read_data, write_data, start, read_operation, hit, cache_busy, 
								 write_opn_to_bus, out_data_Mem, read_select_Mem, write_select_Mem, write_data_Mem, finish, bus_access, finish_out, flag_snoop, snoop_address);

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
input  [7:0] snoop_address;
input  flag_snoop;


reg [7:0] store_address  [0:7];
output reg [7:0] read_data;
output reg bus_access;
output hit;
output reg cache_busy;
output reg write_opn_to_bus;
output reg [7:0] read_select_Mem, write_select_Mem, write_data_Mem;
output reg finish_out;
reg h,s,r;
reg [7:0] write_data_L1;
reg [5:0] write_data_TA; 
reg snoop_finish, snoop_flag;
reg write_mem_enable_L1;
reg write_mem_enable_TA;
reg TA_read_enable;
reg flag, flag1, flag2;
reg hit;
wire TA_finish;
reg [7:0] local_address;
wire miss;
wire [7:0] out_data_L1;
wire [5:0] out_data_TA;
reg [2:0] L1_write_address, L1_read_address, TA_write_address, TA_read_address;
wire [7:0] temp_address;
reg [3:0] cnt;
reg entry_flag, x;

//to get the corresponding output from the L1 cache and the tag array for the given address

L1_cache L1 ( out_data_L1 , CC_clk, L1_read_address , L1_write_address , write_data_L1 , write_mem_enable_L1, rst);

Tag_array TA( out_data_TA , CC_clk, TA_read_address , TA_write_address , write_data_TA , write_mem_enable_TA, rst, TA_finish, TA_read_enable);


assign temp_address = 	store_address[cnt-1];		
always@(posedge CC_clk)
begin
	if(rst)
	begin
		r=0;
		cnt=0;
	end
	//temp_address =	store_address[cnt];
	if(flag_snoop)
	begin
		store_address[cnt] = snoop_address;
		r=1;
		cnt = cnt + 1;
	end
	if(snoop_finish)
		cnt = cnt - 1;
	if(cnt == 0)
		r=0;
		
end			
		
// using the hit or miss and also the read or write operation, perform the corresponding action.

always@(posedge CC_clk)
begin
	if(rst)
	begin
		entry_flag = 0;
		hit=0;
		write_mem_enable_L1=0;
		write_mem_enable_TA=0;
		local_address = 0;
		flag = 0;
		flag1=0;
		h=0;
		flag2=0;
		cache_busy=0;
		read_data = 0;
		finish_out = 0;
		s=0;
		TA_read_enable = 0;
		snoop_flag=0;
		snoop_finish=0;
		x=0;
	end
	else
	begin
		if(snoop_finish)
		begin
			snoop_finish = 0;
			entry_flag = 0;
		end
		
		if(x == 1)
		begin
			entry_flag = 1;
			x = 0;
		end	
		
		if(!cache_busy && r)
		begin
			x = 1;
			cache_busy = 1;
		end	
		
		if(entry_flag  && r)
		begin		
			if(write_mem_enable_TA)
			begin
				write_mem_enable_TA = 0;	
				snoop_finish = 1;
				cache_busy = 0;
			end
			else
			if(snoop_flag)
			begin
				if(TA_finish)
				begin
					snoop_flag = 0;
					TA_read_enable = 0;
					if((out_data_TA[4:0] == temp_address[7:3]) && out_data_TA[5]==1)
					begin
						write_mem_enable_TA =1;				
						TA_write_address = temp_address[2:0];
						write_data_TA[5] = 0; 
					end
				end
			end
			else
			begin
				snoop_flag=1;
				TA_read_address = temp_address[2:0];
				TA_read_enable = 1;
			end
		end	
		else
		begin
			if(hit==1)
			hit = 0;
			else
			if(start)																				// To figure out if there is a hit or miss
			begin
				TA_read_address = address[2:0];
				TA_read_enable = 1;
				cache_busy = 1;
			end
			else	
			if(TA_finish)
			begin
				TA_read_enable = 0;
				flag1=0;
				flag2=0;
				s=1;
				if((out_data_TA[4:0] == address[7:3]) && out_data_TA[5]==1)
					begin
						hit=1;
						h=1;
					end
				else
					begin
						hit=0;
						h=0;
					end		
			end
					if(finish_out == 1)
						finish_out = 0;
					
					if((s || flag || flag1 || flag2) && !rst)
								begin
									if(read_operation == 0) 
										begin
										if(flag)
											begin
												if(finish)
													begin
														s=0;
														finish_out = 1;
														flag=0;
														cache_busy=0;
													end
												else
													bus_access=0;
											end		
										else
											begin
												write_select_Mem = address;
												write_data_Mem = write_data;
												bus_access = 1;
												write_opn_to_bus = 1;
												flag=1;
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
									end
								
								else if(read_operation == 1)
											begin
											if(h)
												begin
															if(flag2)
															begin
																read_data = out_data_L1;
																write_mem_enable_L1=0;
																write_mem_enable_TA=0;
																flag1=0;
																flag2=0;
																cache_busy=0;
																h=0;
																finish_out = 1;
																s=0;
															end	
															else
															if(flag1)
															begin
																flag2=1;
																flag1=0;
															end	
															else
															begin			
																L1_read_address = address[2:0];
																flag1=1;
															end	
														end
											else
												begin
													if(flag) 
													begin
														if(finish)
														begin	
															s=0;
															finish_out = 1;
															flag = 0;
															cache_busy = 0;
															read_data = out_data_Mem;
															TA_write_address = local_address[2:0];
															L1_write_address = local_address[2:0];
															write_mem_enable_L1=1;
															write_mem_enable_TA=1;
															write_data_L1 = out_data_Mem;
															write_data_TA[4:0] = local_address[7:3];
															write_data_TA[5] = 1;
														end
														else
															bus_access = 0;
													end
													else
													begin
														write_select_Mem = address;
														flag = 1;
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
end	

	
assign miss = ~hit;

endmodule
