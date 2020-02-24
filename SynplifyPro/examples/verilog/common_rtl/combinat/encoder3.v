// Priority encoder example 3

module encoder3(none_on, out2, out1, out0, h, g, f, e, d, c, b, a);
input h, g, f, e, d, c, b, a;
output out2, out1, out0;
output none_on;

reg [3:0] outvec;

assign {none_on, out2, out1, out0} = outvec;

always @(a or b or c or d or e or f or g or h)
begin
	if (h) outvec = 4'b0111;
	else if (g) outvec = 4'b0110;
	else if (f) outvec = 4'b0101;
	else if (e) outvec = 4'b0100;
	else if (d) outvec = 4'b0011;
	else if (c) outvec = 4'b0010;
	else if (b) outvec = 4'b0001;
	else if (a) outvec = 4'b0000;
	else outvec = 4'b1000;
end

endmodule
