// Level sensitive latch example 2, with set and reset

module latch2(q, data, clk, set, reset);
output q;
input data, clk, set, reset;

assign q = reset ? 0 : (set ? 1 : (clk ? data : q) );

endmodule
