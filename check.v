`timescale 1ns / 1ps

module check(a,b);
input a;
output reg b;
always @(a)
begin
b <= a; 
end
endmodule
