// Level sensitive latch example 3
// Synplify-Lite gives a warning message to inform
// you that a latch was generated from an always block.

module latch3(q, data, clk);
output q;
input data, clk;
reg q;

always @(clk or data)
begin
	if (clk)
		q = data;
end

endmodule

