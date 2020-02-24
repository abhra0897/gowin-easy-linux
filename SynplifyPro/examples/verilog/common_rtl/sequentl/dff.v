// Simple flip-flop example without set or reset

module dff(q, data, clk);
output q;
input data, clk;
reg q;

always @(posedge clk)
begin
	q = data;
end

endmodule
