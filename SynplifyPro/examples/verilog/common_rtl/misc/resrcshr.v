// Without resource sharing you
// get an 8-bit adder and a 8-bit subtractor feeding a mux
module add_sub1(result, a, b, add_sub);
output [7:0] result;
input [7:0] a, b;
input add_sub;
reg [7:0] result;

always @(a or b or add_sub)
begin 
	if (add_sub)
		result = a + b;
	else
		result = a - b;
end

endmodule

// With manual resource sharing you 
// get less logic:
// 8 inverters feeding a mux feeding an 8-bit adder
module add_sub2(result, a, b, add_sub);
output [7:0] result;
input [7:0] a, b;
input add_sub;
reg [7:0] result;

always @(a or b or add_sub)
begin: label
	// If you label your always block, you can have local
	// declarations. I declared temp.
	reg [7:0] temp;
	if (add_sub)
		temp = b;
	else
		temp = ~b;
	result = a + temp + !add_sub;
end

endmodule

