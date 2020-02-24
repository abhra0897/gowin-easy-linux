
module muxnew1(out, a, b, c, d, select);
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
	endcase
end
endmodule

/* Notice that you are not telling Synplify-Lite what
 to do if the select bus has all zeros. 
If the select bus is being driven from outside 
the current module, the current module has no 
information about the legal values of select, 
and the implicit default is for Synplify-Lite 
to preserve the value of out when all bits of 
select are zero. Preserving the value of out 
requires Synplify-Lite to add extraneous latches 
if out is not assigned elsewhere through every 
path of the always block. A warning message is 
issued to inform you of this: "Latch generated 
from always block for signal out, probably 
missing assignment in branch of if or case". 

To instruct Synplify-Lite not to preserve the 
value of out when all bits of select are zero, 
it is easiest to use a default in the casez 
with an assignment of 'bx. This default assignment 
takes place every pass through the casez statement 
where the select bus does not match one of the explicitly 
given values. Also, use of the default allows you to 
stay within the Verilog language, and avoid using a 
synthesis directive (this works because a 'bx in an
assignment is treated as a don't care).

See also: muxnew2.v, muxnew3.v, and muxnew4.v */
