module latchor1(q, a, b, clk);
output q;
input a, b, clk;

assign q = clk ? (a | b) : q;

endmodule
