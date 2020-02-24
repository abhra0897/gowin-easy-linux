`include "define.v"
`include "static_macro_define.v"
module `module_name(
    dividend,
    divisor,
    start,
    clk,
    quotient_out,
    complete
);

`include "parameter.v"

input [N-1:0] dividend, divisor;
input start;
input clk;
output [N-1:0] quotient_out;
output complete;

`getname(qdiv,`module_name) u_fra_div
    (.dividend       (dividend),
     .divisor        (divisor),
     .start          (start),
     .clk            (clk),
     .quotient_out   (quotient_out),
     .complete       (complete)
    );
defparam u_fra_div .N = N;
defparam u_fra_div .Q = Q;
endmodule
