module test (in1, in2,in3, in4, rst, out, clk);
parameter iw = 9;
parameter ow = iw*2 +1;

input [iw:0]in1, in2, in3, in4;
input rst, clk;
output [ow:0]out;

wire [iw:0]add1;
wire [iw:0]add2;
wire [ow:0]mult;
reg [ow:0]out_reg;


assign add1 = in1+in2;
assign add2 = in3+in4;
assign mult = add1 * add2;

always @(posedge clk or posedge rst)
if (rst)
out_reg <= 'b0;
else
out_reg <= mult;

assign out = out_reg;

endmodule