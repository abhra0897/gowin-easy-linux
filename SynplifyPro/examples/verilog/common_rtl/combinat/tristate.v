// Tri-state output driver example 1

module trist1(out, in, enable);
output out;
input in, enable;

assign out = enable ? in : 'bz;

endmodule



// Tri-state output driver example 2

module trist2(out, in, enable);
output out;
input in, enable;

bufif1(out, in, enable);

endmodule



// Tri-state bidirectional driver example

module bidir(tri_inout, out, in, en, b);
inout tri_inout;
output out;
input in, en, b;

assign tri_inout = en ? in : 'bz;
assign out = tri_inout  ^ b;

endmodule


