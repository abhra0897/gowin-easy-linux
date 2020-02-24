module dff2(q, qb, d, clk, set, reset);
input d, clk, set, reset;
output q, qb;
reg q, qb;
always @(posedge clk)
begin
	if (reset) begin
		q = 0;
		qb = 1;
	end else if (set) begin
		q = 1;
		qb = 0;
	end else begin
		q = d;
		qb = ~d;
	end
end
endmodule
