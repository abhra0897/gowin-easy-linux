// Example of a hierarchical design
// ------------------------------------------------------
// First define the lower level modules: mux, reg8, & rotate
// ------------------------------------------------------

module mux(out, a, b, sel); // mux
output [7:0] out;
input [7:0] a, b;
input sel;

assign out = sel ? a : b;
endmodule

module reg8(q, data, clk, rst); // eight bit register
output [7:0] q;
input [7:0] data;
input clk, rst;
reg [7:0] q;

always @(posedge clk or posedge rst)
begin
	if (rst)
		q = 0;
	else
		q = data;
end
endmodule

module rotate(q, data, clk, r_l, rst); // rotates bits or loads
output [7:0] q;
input [7:0] data;
input clk, r_l, rst;
reg [7:0] q;

// when r_l is high, it rotates; if low, it loads data
always @(posedge clk or posedge rst)
begin
	if (rst)
		q = 8'b0;
	else if (r_l)
		q = {q[6:0], q[7]};
	else
		q = data;
end
endmodule

// ----------------------------------
// Top level design, example #1. The port connections are listed in order:
// ----------------------------------

module top1(q, a, b, sel, r_l, clk, rst);
output [7:0] q;
input [7:0] a, b;
input sel, r_l, clk, rst;
wire [7:0] mux_out, reg_out;

mux mux_1 (mux_out, a, b, sel);
reg8 reg8_1 (reg_out, mux_out, clk, rst);
rotate rotate_1 (q, reg_out, clk, r_l, rst);

endmodule

// ----------------------------------
// Top level design, example #2. The port connections are listed by name:
// ----------------------------------


module top2(q, a, b, sel, r_l, clk, rst);
output [7:0] q;
input [7:0] a, b;
input sel, r_l, clk, rst;
wire [7:0] mux_out, reg_out;

mux mux_1 (.out(mux_out), .a(a), .b(b), .sel(sel));
// notice that port connections listed by name can be in any order
reg8 reg8_1 (.clk(clk), .data(mux_out), .q(reg_out), .rst(rst));
// can mix port connections "in order" (below)  with port connections "by name" (above)
rotate rotate_1 (q, reg_out, clk, r_l, rst);

endmodule


