// Multiplexor example 2

module mux2(out, a, b, sel);
output out;
input a, b, sel;
reg out;

/* changes on a, b, and sel trigger the 
always block to execute */
always @(a or b or sel)
begin
	/* check the value of the sel input. 
	If sel is true, set out to a, otherwise
	set out to b. */
	case (sel)
		1'b1: out = a;
		1'b0: out = b;
		default: out = 'bx;
	endcase
end

endmodule
