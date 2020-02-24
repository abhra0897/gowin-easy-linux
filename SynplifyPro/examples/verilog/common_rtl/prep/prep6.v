// PREP Benchmark 6, Sixteen Bit Accumulator

/* PREP6 contains a sixteen bit accumulator

Copyright (c) 1994 Synplicity, Inc.
You may distribute freely, as long as this header remains attached. */


module prep6(Q, CLK, RST, D);
output [15:0] Q;
input CLK, RST;
input [15:0] D;
reg [15:0] Q;

always  @(posedge CLK or posedge RST)
begin
	if (RST)	Q = 0;	 // reset logic
	else Q = Q + D; // accumulate
end

endmodule
