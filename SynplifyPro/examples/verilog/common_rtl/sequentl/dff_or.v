module dff_or(q, a, b, clk);
output q;
input a, b, clk;
reg q;

always @(posedge clk)
begin
	q = a | b;
end

endmodule
