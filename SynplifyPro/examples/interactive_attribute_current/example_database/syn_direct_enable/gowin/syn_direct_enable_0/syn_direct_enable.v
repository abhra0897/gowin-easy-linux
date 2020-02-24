
//Interactive attribute example for syn_direct_enable attribute
`timescale 1 ns/ 100 ps

module dff2(q1, d1, clk, e1, e2, e3);

parameter size=5;

input [size-1:0] d1;
input clk;

input e1,e2;
input e3 ; 

output reg [size-1:0] q1;

always @(posedge clk)
  if (e1&e2&e3) 
      q1 = d1;
          
endmodule