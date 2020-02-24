// PREP Benchmark 9, Memory Map

/* PREP9 contains a memory mapper.

Copyright (c) 1994 Synplicity, Inc.
You may distribute freely, as long as this header remains attached. */


module prep9(H, G, F, E, D, C, B, A, BE, CLK, RST, AS, AL, AH);
output H, G, F, E, D, C, B, A, BE;
input CLK, RST, AS;
input [7:0] AL, AH;
reg BE;
reg [7:0] Q;

wire [15:0]  addr = {AH, AL};  // combine AH and AL into one address bus
assign {H, G, F, E, D, C, B, A} = Q; // split Q bus into individual output bits

always @(posedge CLK or posedge RST)
begin
	if (RST) begin
		Q = 0;
		BE = 0;
	end else if (!AS) begin
		Q = 0;  // BE remains unchanged
	end else begin  // rising CLK edge
		Q = 0;
		BE = 0;
		if (addr <= 16'he2aa) 
			BE = 1;
		else if (addr == 16'he2ab)
			Q[7] = 1;
		else if (addr <= 16'he2af)
			Q[6] = 1;
		else if (addr <= 16'he2bf)
			Q[5] = 1;
		else if (addr <= 16'he2ff)
			Q[4] = 1;
		else if (addr <= 16'he3ff)
			Q[3] = 1;
		else if (addr <= 16'he7ff)
			Q[2] = 1;
		else if (addr <= 16'hefff)
			Q[1] = 1;
		else Q[0] = 1; // addr <= 16'hffff
	end
end
	
endmodule
