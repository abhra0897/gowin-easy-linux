// 8 bit adder (not scaleable)

module adder_8(cout, sum, a, b, cin);
output cout;
output [7:0] sum;
input cin;
input [7:0] a, b;

assign {cout, sum} = a + b + cin;

endmodule


