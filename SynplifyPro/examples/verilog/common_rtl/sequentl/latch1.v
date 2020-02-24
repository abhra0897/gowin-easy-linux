// Level sensitive latch example 1

module latch1(q, data, clk);
output q;
input data, clk;

	assign q = clk ? data : q;

endmodule
