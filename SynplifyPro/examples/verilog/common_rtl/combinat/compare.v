// Comparator
module compare(equal, a, b);
parameter size = 1;
output equal;
input [size-1:0] a, b; // declare inputs

assign equal =  a == b;

endmodule
