/* You may use the full_case directive to achieve the 
same effect as the default case, and instruct Synplify-Lite 
not to preserve the value of out when all bits of sel are zero: */

module muxnew3(out, a, b, c, d, select);
output out;
input a, b, c, d;
input [3:0] select;
reg out;

always @(select or a or b or c or d)
begin
	casez (select) // synthesis full_case
		4'b???1: out = a;
		4'b??1?: out = b;
		4'b?1??: out = c;
		4'b1???: out = d;
	endcase 
end
endmodule

/* Note: If the select bus is decoded within the same 
module as the case statement, Synplify-Lite automatically 
determines that all legal values are specified, and the 
default case or full_case directive is unnecessary. */

/* See also: muxnew1.v, muxnew2.v and muxnew4.v */
