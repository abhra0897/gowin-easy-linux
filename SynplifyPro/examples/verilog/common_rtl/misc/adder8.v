`include "scaleabl.v"

// Scaling an adder by overriding the parameter value with defparam

module adder8(cout, sum, a, b, cin);
output cout;
output [7: 0] sum;
input [7: 0] a, b;
input cin;

adder my_adder (cout, sum, a, b, cin);
defparam my_adder.size = 8;

endmodule
