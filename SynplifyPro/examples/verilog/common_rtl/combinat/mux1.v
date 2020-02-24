// Multiplexor example 1

module mux1(out, a, b, sel);
output out;
input a, b, sel;

assign out = sel ? a : b;

endmodule
