module bitand(out, a, b);
output [3:0] out;
input [3:0] a, b;
/* this wire declaration is not required, 
because out is an output in the port list */

wire [3:0] out;
assign out = a & b;

endmodule

