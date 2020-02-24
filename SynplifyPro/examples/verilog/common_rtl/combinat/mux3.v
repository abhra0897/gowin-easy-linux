// Multiplexor example 3

module mux3(out, a, b, sel);
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
	if (sel) begin
		out = a; 
	end else begin
		out = b;
	end
end

endmodule
