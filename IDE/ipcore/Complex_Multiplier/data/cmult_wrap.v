`include "define.v"
`include "static_macro_define.v"
module `module_name(
    ce,
    clk,
    reset,
    real1,
    real2,
    imag1,
    imag2,
    realo,
    imago
);

`include "parameter.v"

input  signed[N-1:0]real1, imag1, real2, imag2;
input  ce;
input  clk;
input  reset;

parameter mul = (N <= 9)?9:((N <= 18)?18:36);

output signed[mul+mul:0]realo, imago;
`getname(cmp_core,`module_name) u_complex_mult
    (.ce    (ce),
     .clk   (clk),
     .reset (reset),
     .real1 (real1),
     .real2 (real2),
     .imag1 (imag1),
     .imag2 (imag2),
     .realo (realo),
     .imago (imago)
    );
    defparam u_complex_mult.N = N;
    defparam u_complex_mult.INR = INR;
    defparam u_complex_mult.OUTR = OUTR;
    defparam u_complex_mult.PIPER = PIPER;
    defparam u_complex_mult.input_signed = input_signed;
    defparam u_complex_mult.RESET_MODE = RESET_MODE;
endmodule
