`timescale 1ns / 1ns

module CPU_toy (start, clk, rst, bus_busy, cache_busy, address, data, read_operation, store, start_to_cache, input_data);

input start, clk, rst, bus_busy, cache_busy;
input store;
input [7:0] input_data;
output reg [7:0] address, data;
output reg read_operation;
output reg start_to_cache;

reg operation [0:9];
reg [7:0] read_address [0:9];
reg [7:0] write_address [0:9];
reg [7:0] write_data [0:9];
reg [7:0] receive_cnt;
reg [7:0] transmit_cnt;



always@(posedge clk)
begin
	if(rst)
	begin
		data = 0;
		read_operation = 0;
		address = 0;
		receive_cnt = 0;
		transmit_cnt = 0;
		start_to_cache=0;
	end
	else
	if(!start && store)				//Start signal is sent by the data_receive module once it has sent all the data received from the CPU
	begin
		receive_cnt = receive_cnt + 1;
		if(receive_cnt<8'd3)
		begin
			operation[receive_cnt-1] = input_data[0];
		end
		else
		if(receive_cnt<8'd5)
		begin
			read_address[receive_cnt-3] = input_data;
		end
		else
		if(receive_cnt<8'd7)
		begin
			write_address[receive_cnt-5] = input_data;
		end
		else
		if(receive_cnt<8'd9)
		begin
			write_data[receive_cnt-7] = input_data;
		end
	end
	else
	if(start && !store)
	begin
	if(transmit_cnt<3)
	begin
		if(!bus_busy && !cache_busy)
		begin
			start_to_cache=1;
			transmit_cnt = transmit_cnt + 1;
			if(operation[transmit_cnt-1] == 1)
			begin
				address = read_address[transmit_cnt - 1];
				data = 0;
				read_operation = 1;
			end
			else
			begin
				start_to_cache=0;
				address = write_address[transmit_cnt - 1];
				data = write_data[transmit_cnt - 1];
				read_operation = 0;
			end
		end
		end
	end
end

endmodule
