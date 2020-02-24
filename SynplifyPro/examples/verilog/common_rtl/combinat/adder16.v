`include "adder.v"

module adder16(cout, sum, a, b, cin);
output cout;
/* We are also using a parameter at this level of hierarchy */
parameter my_size = 16;	// I want a 16 bit adder
output [my_size - 1: 0] sum;
input [my_size - 1: 0] a, b;
input cin;

/* my_size overwrites size inside instance my_adder of adder */
adder #(my_size) my_adder (cout, sum, a, b, cin);

endmodule










