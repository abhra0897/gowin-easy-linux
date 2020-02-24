/* Parallel_case can be used with case statements 
to get a mux structure rather than a priority encoder
structure. The case statement 
is defined to execute the first (and only the first) statement 
who's tag matches the select value. 

If the select bus is being driven from outside the current 
module, the current module has no information about the 
legal values of select, and a chain of disabling logic 
must be created so that a match on a statement's tag disables 
all following statements. Since we know that the only legal 
values of select are 4'b1000, 4'b0100, 4'b0010, and 4'b0001, 
then only one of the tags can be matched at a time and tag 
matching logic can be parallel and independent instead of 
chained. To instruct Synplify-Lite to create this parallel 
structure, use the parallel_case directive as follows: */

module muxnew4(out, a, b, c, d, select);
output out;
input a, b, c, d;
input [3:0] select;
reg out;

always @(select or a or b or c or d)
begin
	casez (select) // synthesis parallel_case
		4'b???1: out = a;
		4'b??1?: out = b;
		4'b?1??: out = c;
		4'b1???: out = d;
		default: out = 'bx;
	endcase
end

/* If the select bus is decoded within the same module as 
the case statement, Synplify-Lite automatically determine 
parallelism of the tag matches, and the parallel case 
directive is unnecessary. */
endmodule

/* See also: muxnew1.v, muxnew2.v, and muxnew3.v */
