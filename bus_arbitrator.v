`timescale 1ns / 1ps

module bus_arbitrator (clk, rst, read_address_1, read_address_2, read_data_1, read_data_2, write_address_1, write_address_2, 
							  write_data_1, write_data_2, finish1, finish2, cache_write_1, cache_write_2, flag_to_1, flag_to_2, 
							  bus_busy, bus_access_1, bus_access_2, address_to_1, address_to_2);

input clk, rst;
input [7:0] read_address_1, read_address_2, write_address_1, write_address_2;
input [7:0] write_data_1, write_data_2;
input bus_access_1, bus_access_2;
input cache_write_1, cache_write_2;


output reg [7:0] read_data_1, read_data_2;
output reg finish1, finish2;
reg finish1_p, finish2_p;

output reg flag_to_1, flag_to_2;
output reg bus_busy;
output reg [7:0] address_to_1, address_to_2;

reg [3:0] state;
reg [7:0] mem_read_address, mem_write_address, mem_write_data;
reg mem_we;
reg p1,p2,p3,p4;
wire [7:0] mem_read_data;

localparam RR=0, RW=1, WR=2, WW=3, RN=4, WN=5, NR=6, NW=7, NN=8;
localparam priority_1 = 1, priority_2 = 0;


// read operation block

always@(posedge clk)
begin
	
	if(rst)
	begin
		bus_busy = 0;
		state = NN;
	end
	
	else
	begin
			
			if((bus_access_1 && bus_access_2) && (!cache_write_1 && !cache_write_2))
			begin
				bus_busy = 1;
				state = RR;
			end
			
			if((bus_access_1 && bus_access_2) && (!cache_write_1 && cache_write_2))
			begin
				bus_busy = 0;
				state = RW;
			end
			
			if((bus_access_1 && bus_access_2) && (cache_write_1 && !cache_write_2))
			begin
				bus_busy = 0;
				state = WR;
			end
			
			if((bus_access_1 && bus_access_2) && (cache_write_1 && cache_write_2))
			begin
				bus_busy = 1;
				state = WW;
			end
			
			if((bus_access_1 && !bus_access_2) && (cache_write_1))
			begin
				bus_busy = 0;
				state = WN;
			end
			
			if((bus_access_1 && !bus_access_2) && (!cache_write_1))
			begin
				bus_busy = 0;
				state = RN;
			end
			
			if((!bus_access_1 && bus_access_2) && (cache_write_2))
			begin 
				bus_busy = 0;
				state = NW;
			end
			
			if((!bus_access_1 && bus_access_2) && (!cache_write_2))
			begin
				bus_busy = 0;
				state = NR;
			end
			
			if((!bus_access_1 && !bus_access_2))
			begin
				bus_busy = 0;
				state = NN;
			end	
	end
end	
	
always@(posedge clk)
begin	
		if(rst)
		begin
			finish1_p = 0;
			finish2_p = 0;
			mem_read_address = 0;
			mem_write_address = 0;
			mem_write_data = 0;
			read_data_1 = 0;
			read_data_2 = 0;
			mem_we = 0;
			flag_to_1 = 0;
			flag_to_2 = 0;
		end
		case(state)
			
				RN : begin
						mem_read_address = read_address_1;
						read_data_1 = mem_read_data;
						finish1_p = ~finish1_p;
						mem_we = 0;
						flag_to_1 = 0;
						flag_to_2 = 0;
					  end
				NR : begin
						mem_read_address = read_address_2;
						read_data_2 = mem_read_data;
						//finish1 = 0;
						finish2_p = ~finish2_p;
						mem_we = 0;
						flag_to_1 = 0;
						flag_to_2 = 0;
					  end	  
				WN : begin
						mem_write_address = write_address_1;
						mem_write_data = write_data_1;
						mem_we = 1;
						finish1_p = ~finish1_p;
						//finish2 = 0;
						flag_to_1 = 0;
						flag_to_2 = 1;
						address_to_2 = write_address_1;
					  end		
				NW : begin
						mem_write_address = write_address_2;
						mem_write_data = write_data_2;
						mem_we = 1;
						//finish1 = 0;
						finish2_p = ~finish2_p;
						flag_to_1 = 1;
						flag_to_2 = 0;
						address_to_1 = write_address_2;
					  end	
				RW : begin
						if(mem_write_address == mem_read_address)
						begin
							mem_write_address = write_address_2;
							mem_write_data = write_data_2;
							mem_we = 1;
							read_data_1 = write_data_2;
							finish1_p = ~finish1_p;
							finish2_p = ~finish2_p;
							flag_to_1 = 0;
							flag_to_2 = 0;
						end
						else
						begin
							mem_write_address = write_address_2;
							mem_write_data = write_data_2;
							mem_we = 1;
							mem_read_address = read_address_1;
							read_data_1 = mem_read_data;
							finish1_p = ~finish1_p;
							finish2_p = ~finish2_p;
							flag_to_1 = 1;
							flag_to_2 = 0;
							address_to_1 = write_address_2;
						end
					  end
				WR : begin
						if(mem_write_address == mem_read_address)
						begin
							mem_write_address = write_address_1;
							mem_write_data = write_data_1;
							mem_we = 1;
							mem_read_address = read_address_2;
							read_data_2 = mem_read_data;
							finish1_p = ~finish1_p;
							finish2_p = ~finish2_p;
							flag_to_1 = 0;
							flag_to_2 = 0;
						end
						else
						begin
							mem_write_address = write_address_1;
							mem_write_data = write_data_1;
							mem_we = 1;
							mem_read_address = read_address_2;
							read_data_2 = mem_read_data;
							finish1_p = ~finish1_p;
							finish2_p = ~finish2_p;
							flag_to_1 = 0;
							flag_to_2 = 1;
							address_to_2 = write_address_1;
						end	
					  end
				NN : begin
						flag_to_1 = 0;
						flag_to_2 = 0;
						address_to_1 = 0;
						address_to_2 = 0;
					  end
				RR : begin														//Check if cache controller deasserts bus_access signal before the beginning of next cycle
							if(priority_1 > priority_2)
							begin
								mem_read_address = read_address_1;
								read_data_1 = mem_read_data;
								finish1_p = ~finish1_p;
								flag_to_1 = 0;
								flag_to_2 = 0;
							end
							else
							begin
								mem_read_address = read_address_2;
								read_data_2 = mem_read_data;
								finish2_p = ~finish2_p;
								flag_to_1 = 0;
								flag_to_2 = 0;
							end	
					  end
				WW : begin
								if(priority_1 > priority_2)					//Check if cache controller deasserts bus_access signal before the beginning of next cycle
								begin
									mem_write_address = write_address_1;
									mem_write_data = write_data_1;
									mem_we = 1;
									finish1_p = ~finish1_p;
									flag_to_1 = 0;
									flag_to_2 = 1;
									address_to_2 = write_address_1;
								end
								else
								begin
									mem_write_address = write_address_2;
									mem_write_data = write_data_2;
									mem_we = 1;
									finish2_p = ~finish2_p;
									flag_to_1 = 1;
									flag_to_2 = 0;
									address_to_1 = write_address_2;
								end
						 end
				endcase
end	

always@(clk)
begin
	if(rst)
	begin
		finish1=0;
		p1<=0;
		p2<=0;
	end
	else
	begin
		p1<=finish1_p;
		p2<=p1;
		finish1 = p1 & ~p2;
	end
end

always@(clk)
begin
	if(rst)
	begin
		finish2=0;
		p3<=0;
		p4<=0;
	end
	else
	begin
		p3<=finish2_p;
		p4<=p3;
		finish2 = p3 & ~p4;
	end
end	
		
		

Main_memory256 M1(mem_read_data, clk, mem_read_address, mem_write_address, mem_write_data, mem_we, rst);
	
endmodule	
