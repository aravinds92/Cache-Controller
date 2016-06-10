`timescale 1ns / 1ps
`include "Main_memory256.v"
module multiplebus(clk, rst, write_op1, write_op2, in_address1, in_address2, in_data1, in_data2, start1, start2, out_data1, out_data2, finish_flag1, finish_flag2, read_busy, write_busy, flag_to_1, flag_to_2, address_to_1, address_to_2); //start = bus_access

input write_op1, write_op2, rst, clk, start1, start2;
input [7:0] in_address1, in_address2, in_data1, in_data2;

output wire [7:0] out_data1, out_data2;
output wire finish_flag1, finish_flag2;
output reg flag_to_1, flag_to_2;
output reg [7:0] address_to_1, address_to_2;
output reg read_busy, write_busy;
wire readfinish_flag, writefinish_flag;
reg [7:0] mem_read_address, mem_write_address, mem_data;
wire [7:0] mem_data_out;
reg write_enable,read_c1, read_c2, write_c1, write_c2;
reg read_enable;
reg R1, R2, W1, W2;
reg [3:0] next_state;
reg state_flag;
reg [3:0] state;
localparam RR = 0, RW = 1, WR = 2, WW = 3, RN = 4, WN = 5, NR = 6, NW = 7, NN = 8, dummy=9;
parameter priority_1 = 1, priority_2 = 0;

always@(posedge clk)
begin
	if(rst)
	begin
	state = NN;
	end
	
	else if((state_flag == 1) && ((finish_flag1==1)||(finish_flag2==1)))
	begin
		state = dummy;
	end
	else if(state == dummy)
	begin
		state = next_state;
	end	
	else	
	begin
		if((start1==1) && (start2==1))
		begin
			if(write_op1==1 && write_op2==1)
				state = WW;
			else if(write_op1==1 && write_op2==0)
				state = WR;
			else if(write_op1==0 && write_op2==1)
				state = RW;
			else if(write_op1==0 && write_op2==0)		
				state = RR;
		end
		else if((start1 == 1) && (start2 == 0))
		begin
			if(write_op1 == 1)
				state = WN;
			else if(write_op1 == 0)
				state = RN;
		end
		else if((start1 == 0) && (start2 == 1))
		begin
			if(write_op2 == 1)
				state = NW;
			else if(write_op2 == 0)
				state = NR;
		end
		else if((start1 == 0) && (start2 == 0))
			state = NN;
	end
end

always@(posedge clk)
begin	
		if(rst)
		begin
			mem_read_address = 0;
			mem_write_address = 0;
			mem_data = 0;
			write_enable = 0;
			read_enable = 0;
			read_busy = 0;
			write_busy = 0;
			read_c1 = 0;
			read_c2 = 0;
			write_c1 = 0;
			write_c2 = 0;
			state_flag = 0;
			next_state = NN;
			flag_to_1 = 0;
			flag_to_2 = 0;
			address_to_1 = 0;
			address_to_2 = 0;
		end

		if(flag_to_2 == 1)
			flag_to_2 = 0;
		if(flag_to_1 == 1)
			flag_to_1 = 0;
		else	
		begin	
			case(state)								
					NN : 		begin
								/*read_busy = 0;
								write_busy = 0;*/
								end
								
					RN :		begin
								read_busy = 1;
								mem_read_address = in_address1;
								write_enable = 0;
								read_enable =1;
								read_c1 =1;
								state_flag=0;
								//out_data1 = mem_data_out;
								end
					
					NR :		begin
								read_busy = 1;
								mem_read_address = in_address2;
								write_enable =0;
								read_enable =1;
								read_c2 =1;
								state_flag=0;
								end
			
					WN :     begin
								write_busy = 1;
								mem_write_address = in_address1;
								mem_data = in_data1;
								write_enable = 1;
								read_enable = 0;
								write_c1 =1;
								state_flag = 0;
								flag_to_2 = 1;
								address_to_2 = in_address1;
								end
			
					NW :     begin
								write_busy = 1;
								mem_write_address = in_address2;
								mem_data = in_data2;
								write_enable = 1;
								read_enable = 0;
								write_c2 =1;
								state_flag = 0;
								flag_to_1 = 1;
								address_to_1 = in_address2;
								end	
					
					RW :		begin
								read_busy = 1;
								write_busy = 1;
								mem_read_address = in_address1;
								mem_write_address = in_address2;
								mem_data = in_data2;
								write_enable = 1;
								read_enable = 1;
								read_c1 =1;
								write_c2 =1;
								flag_to_1 = 1;
								address_to_1 = in_address2;
								end
					
					WR :		begin
								read_busy = 1;
								write_busy = 1;
								mem_read_address = in_address2;
								mem_write_address = in_address1;
								mem_data = in_data1;
								write_enable = 1;
								read_enable = 1;
								read_c2 =1;
								write_c1 =1;
								flag_to_2 = 1;
								address_to_2 = in_address1;
								end
								
					RR :		begin
								state_flag=1;
								if(priority_1 > priority_2)
								begin
									read_busy = 1;
									mem_read_address = in_address1;
									write_enable = 0;
									read_enable = 1;
									read_c1 =1;
									next_state = NR;
								end
								else if(priority_2 > priority_1)
								begin
									read_busy = 1;
									mem_read_address = in_address2;
									write_enable = 0;
									read_enable = 1;
									read_c2 =1;
									next_state = RN;
								end
								end

					WW :		begin
								state_flag=1;
								if(priority_1 > priority_2)
								begin
									write_busy = 1;
									mem_write_address = in_address1;
									mem_data = in_data1;
									write_enable = 1;
									read_enable = 0;
									write_c1 =1;
									next_state = NW;
									flag_to_2 = 1;
									address_to_2 = in_address1;
								end
								else if(priority_2 > priority_1)
								begin
									write_busy = 1;
									mem_write_address = in_address2;
									mem_data = in_data2;
									write_enable = 1;
									read_enable = 0;
									write_c2 =1;
									next_state = NW;
									flag_to_1 = 1;
									address_to_1 = in_address2;
								end
								end								
			endcase	
		end
			
			if(readfinish_flag)
			begin
				read_enable = 0;
				read_busy = 0;
				if(read_c1)
				begin
					read_c1 = 0;
				end
				if(read_c2)
				begin
					read_c2 = 0;
				end
		   end
		  
		  if(writefinish_flag)
			begin
				write_enable = 0;
				write_busy = 0;
				if(write_c1)
				begin
					write_c1 = 0;			
				end
				if(write_c2)
				begin
					write_c2 = 0;
				end
		   end	
end

assign finish_flag1 = rst? 0 : (read_c1 && readfinish_flag) ? 1 : (write_c1 && writefinish_flag) ? 1 : 0;

assign finish_flag2 = rst? 0 : (read_c2 && readfinish_flag) ? 1 : (write_c2 && writefinish_flag) ? 1 : 0;

assign out_data1 = rst? 0 : (read_c1 && readfinish_flag) ? mem_data_out : out_data1;

assign out_data2 = rst? 0 : (read_c2 && readfinish_flag) ? mem_data_out : out_data2;

Main_memory256 mem1(mem_data_out, clk, mem_read_address, mem_write_address, mem_data, write_enable, rst, readfinish_flag, writefinish_flag, read_enable);


endmodule 