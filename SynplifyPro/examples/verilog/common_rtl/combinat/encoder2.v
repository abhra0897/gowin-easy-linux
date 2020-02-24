// Priority encoder example 2

module encoder2(none_on, out2, out1, out0, h, g, f, e, d, c, b, a);
input h, g, f, e, d, c, b, a;
output none_on, out2, out1, out0;

wire [3:0] outvec;

assign outvec = h ? 4'b0111: g ? 4'b0110: 
		f ? 4'b0101: e ? 4'b0100: 
		d ? 4'b0011: c ? 4'b0010: 
		b ? 4'b0001: a ? 4'b0000: 
		4'b1000;

assign none_on = outvec[3];
assign out2 = outvec[2]; 
assign out1 = outvec[1]; 
assign out0 = outvec[0];

endmodule
