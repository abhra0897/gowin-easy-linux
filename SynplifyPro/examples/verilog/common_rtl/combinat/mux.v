module mux(out, a, b, sel);
output out;
input a, b, sel;
reg out;

always @(a or b or sel)
begin
	if (sel)
		out = a;
	else
		out = b;
end

endmodule
