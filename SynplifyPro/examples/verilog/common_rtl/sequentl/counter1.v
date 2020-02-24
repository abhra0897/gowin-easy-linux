// Eight bit counter example 1

module counter1(out, cout, data, load, cin, clk);
output [7:0] out;
output cout;
input [7:0] data;
input load, cin, clk;

reg [7:0] out;

always @(posedge clk) 
begin 
	if (load)
		out = data;
	else
		out = out + cin;
	
end

// all bits of out must be one and the 
// carry in must be on to generate a 
// carry out
assign cout = &out & cin;


endmodule
