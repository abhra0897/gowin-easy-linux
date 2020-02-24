// PREP Benchmark 7, Sixteen Bit Counter

/* PREP7 contains a sixteen bit counter

Copyright (c) 1994 Synplicity, Inc.
You may distribute freely, as long as this header remains attached. */


module prep7(Q, CLK, RST, LD, CE, D);
output [15:0] Q;
input CLK, RST, LD, CE;
input [15:0] D;
reg [15:0] Q;

always @ (posedge RST or posedge CLK)
begin
	if (RST)	// reset logic
		Q = 0;
	else if (LD)	// load
		Q = D;
	else if (CE) 	// if count enable, count
		Q = Q + 1;
end

endmodule

