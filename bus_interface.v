`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:39 11/26/2015 
// Design Name: 
// Module Name:    bus_interface 
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
module bus_interface(clk, rst, cache_addr, bus_addr, start);
inout [7:0] cache_addr, bus_addr;
input clk, rst;
reg [15:0] cnt;
reg [7:0] bus_data_in, bus_data_out;
reg bus_read_en, bus_write_en;
reg [7:0] cache_data_in, cache_data_out;
reg cache_read_en, cache_write_en;
reg bus_empty, cache_empty;

//module queue(clk, rst, in_data, out_data, read_en, write_en);
queue bus_queue(clk, rst, bus_data_in, bus_data_out, bus_read_en, bus_write_en, bus_empty);
queue cache_queue(clk, rst, cache_data_in, cache_data_out, cache_read_en, cache_write_en, cache_empty);

always@(posedge clk)
begin
    if(rst)
    cnt=0;
    else
    cnt=cnt+1;
end



always@(posedge clk)                    //Working on Bus queue
begin
    if(cnt%2 == 0)                      //Read at even clk
    begin
        cache_read_en = 0;
        if(bus_addr != 8'bzzzzzzzz)
        begin
            bus_write_en = 1;
            bus_data_in = bus_addr;
        end
    end
    else if(cnt%2 == 1)                     //Write at odd clk
    begin
        bus_write_en = 0;
        if(cache_empty ==0)
        begin
            cache_read_en = 1;
            bus_addr = cache_data_out;
        end
        else
            bus_addr = 8'bzzzzzzzz; 
    end
end 

always@(posedge clk)                      //Working on cache queue
begin
    if(cnt%2 == 0)                        //Read at even clk
    begin
        bus_read_en = 0;
        if(cache_addr != 8'bzzzzzzzz)
        begin
            cache_write_en = 1;
            cache_data_in = cache_addr;
        end
    end
    else if(cnt%2 == 1)                   //Write at odd clk 
    begin
        cache_write_en = 0;
        if(bus_empty == 0)
        begin
            bus_read_en = 1;
            cache_addr = bus_data_out;
        end
        else
            cache_addr = 8'bzzzzzzzz;
    end 
end 

endmodule
