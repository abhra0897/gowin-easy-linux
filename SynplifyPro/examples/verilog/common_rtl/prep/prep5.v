// PREP Benchmark 5, Arithmetic Circuit

/* PREP5 contains a multiplier and accumulator

Copyright (c) 1994 Synplicity, Inc.
You may distribute freely, as long as this header remains attached. */


module prep5(Q, CLK, MAC, RST, A, B);
output [7:0] Q;
input CLK, MAC, RST;
input [3:0] A, B;
reg [7:0] Q;

// multiplier
wire [7:0]  multiply_output = A * B;
// adder:
wire [7:0] adder_output = MAC ?   multiply_output + Q : multiply_output;

// register with asynchronous reset
always @(posedge CLK  or posedge RST)
begin
	if (RST)
		Q = 0;
	else
		Q = adder_output;
end
 
endmodule
