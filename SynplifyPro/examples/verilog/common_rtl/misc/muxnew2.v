/* To instruct Synplify-Lite not to preserve the value 
of out when all bits of select are zero, it is easiest 
to use a default in the casez with an assignment of 'bx. 
This default assignment takes place every pass through 
the casez statement where the select bus does not match 
one of the explicitly given values. Also, use of the default 
allows you to stay within the Verilog language, and avoid 
using a synthesis directive (this works because a 'bx in an a
ssignment is treated as a don't care): */

module muxnew2(out, a, b, c, d, select);
output out;
input a, b, c, d;
input [3:0] select;
reg out;

always @(select or a or b or c or d)
begin
	casez (select)
		4'b???1: out = a;
		4'b??1?: out = b;
		4'b?1??: out = c;
		4'b1???: out = d;
		default: out = 'bx;
	endcase
end

endmodule

/* See also: muxnew1.v, muxnew3.v and muxnew4.v */
