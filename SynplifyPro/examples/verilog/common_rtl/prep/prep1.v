// PREP Benchmark #1, Data Path

/* PREP1 contains a 4-to-1 mux, 8 bit register and 8 bit shift register

Copyright (c) 1994 Synplicity, Inc.
You may distribute freely, as long as this header remains attached. */

module prep1(Q, CLK, RST, S_L, S1, S0, d0, d1, d2, d3);
output [7:0] Q;
input CLK, RST, S_L;
input S1, S0;
input [7:0] d0, d1, d2, d3;

reg [7:0] Y, q_reg, Q;  // q_reg is output from 8-bit register


always @(S1 or S0 or d0 or d1 or d2 or d3)
begin
	case ({S1, S0})		// 4-to-1 mux
		2'b00: Y = d0;
		2'b01: Y = d1;
		2'b10: Y = d2;
		2'b11: Y = d3;
	endcase
end

always @(posedge CLK or posedge RST)
begin
	 if (RST) begin
   		q_reg = 0; 	// reset register
   		Q = 0; 		// reset shift register
	end else if (S_L) begin
   		Q[7:0] = {Q[6:0],Q[7]}; // shift register
   		q_reg = Y;
	end else begin
   		Q = q_reg; 	// load from register
   		q_reg = Y; 	// load from mux
	end
end
endmodule
