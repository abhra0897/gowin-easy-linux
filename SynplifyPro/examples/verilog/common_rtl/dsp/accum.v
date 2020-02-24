module test (in1, in2, rst, out, clk);
parameter iw = 9;
parameter ow = iw*2 +1;

input [iw:0]in1, in2;
input rst, clk;
output [ow:0]out;

wire [ow:0]temp_mult;
reg [ow:0]out_reg;


assign temp_mult = in1*in2;

always @(posedge clk or posedge rst)
if (rst)
out_reg <= 'b0;
else
out_reg <= out_reg + temp_mult;

assign out = out_reg;

endmodule
