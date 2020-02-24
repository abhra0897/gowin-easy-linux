// Eight bit counter example 2

module counter2(out, cout, data, load, cin, clk);
output [7:0] out;
output cout;
input [7:0] data;
input load, cin, clk;

reg [7:0] out;
reg cout;
reg [7:0] preout;

// create the 8-bit register
always @(posedge clk) 
begin 
	out = preout;
end

// calculate the next state of the counter and the carry out
// note that we don't want load to affect cout, for performance
// reasons
always @(out or data or load or cin) 
begin
	{cout, preout} = out + cin;
	if (load) preout = data;
end

endmodule

