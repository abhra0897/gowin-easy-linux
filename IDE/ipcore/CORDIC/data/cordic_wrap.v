`include "define.v"
`include "static_macro_define.v"
module `module_name(
  input wire clk,
  input wire rst,
`ifdef ITERATE
  input wire init,
`endif
  input wire signed [`XY_BITS:0]    x_i,
  input wire signed [`XY_BITS:0]    y_i,
  input wire signed [`THETA_BITS:0] theta_i,
  
  output wire signed [`XY_BITS:0]    x_o,
  output wire signed [`XY_BITS:0]    y_o,
  output wire signed [`THETA_BITS:0] theta_o

);

`getname(cordic_core,`module_name) u_cordic
    (.clk(clk),
     .rst(rst),
`ifdef ITERATE
     .init(init),
`endif
     .x_i(x_i),
     .y_i(y_i),
     .theta_i(theta_i),
     .x_o(x_o),
     .y_o(y_o),
     .theta_o(theta_o));
 endmodule
