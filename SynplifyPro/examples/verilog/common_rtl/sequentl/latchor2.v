module latchor2(q, a, b, clk);
output q;
input a, b, clk;
reg q;

always @(clk or a or b)
begin
	if (clk)
		q = a | b;
end

endmodule
