/* PREP3 contains a small state machine

Copyright (c) 1994 Synplicity, Inc.
You may distribute freely, as long as this header remains attached. */

module prep3(CLK, RST, IN, OUT);
input CLK, RST;
input [7:0] IN;
output [7:0] OUT;

reg [7:0] OUT;
reg [7:0] current_state; // holds the current state

parameter // these parameters represent state names
	   start = 8'h01,
	   sa = 8'h02,
	   sb = 8'h04,
	   sc = 8'h08,
	   sd = 8'h10,
	   se = 8'h20,
	   sf = 8'h40,
	   sg = 8'h80;

always @ (posedge CLK or posedge RST)
begin
	if (RST) begin
		current_state = start;
		OUT = 8'b0;
	end else begin
		case (current_state) 
		start: if (IN == 8'h3c) begin
				current_state = sa;
				OUT = 8'h82;
			end else begin
				OUT = 8'h00;
				current_state = start;
			end
		sa: if (IN == 8'h2a) begin
				current_state = sc;
				OUT = 8'h40;
			end else if (IN == 8'h1f) begin
				current_state = sb;
				OUT = 8'h20;
			end else begin
				current_state = sa;
				OUT = 8'h04;
			end
		sb: if (IN == 8'haa) begin
				current_state = se;
				OUT = 8'h11;
			end else begin
				current_state = sf;
				OUT = 8'h30;
			end
		sc: begin
			current_state = sd;
			OUT = 8'h08;
			end
		sd: begin
			current_state = sg;
			OUT = 8'h80;
			end
		se: begin
			current_state = start;
			OUT = 8'h40;
			end
		sf: begin
			current_state = sg;
			OUT = 8'h02;
			end
		sg: begin
			current_state = start;
			OUT = 8'h01;
			end
		default: begin
		/* set current_state to 'bx (don't care) to tell Synplify-Lite that all used
		states have been already been specified */
			current_state = 'bx;
			OUT = 'bx;
			end
		endcase
	end
end
endmodule
