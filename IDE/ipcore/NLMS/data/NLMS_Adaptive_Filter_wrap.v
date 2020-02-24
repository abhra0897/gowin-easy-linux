`include "static_macro_define.v"
`include "define.v"
module `module_name(
    clk,
    ini,
    rst_n,
    wr_en,
    i_data,
    i_desire,
    o_err,
    out_sig,
    input_rdy
    );
`include "param.v"
input clk;
input rst_n;
input ini;
input wr_en;
input [idata_width - 1 : 0] i_data;
input [idata_width - 1 : 0] i_desire;
output [idata_width - 1 : 0] o_err;
output out_sig;
output input_rdy;

wire clk;
wire rst_n;
wire ini;
wire wr_en;
wire [idata_width - 1 : 0] i_data;
wire [idata_width - 1 : 0] i_desire;
wire [idata_width - 1 : 0] o_err;
wire out_sig;
wire input_rdy;

`getname(NLMS_top,`module_name) NLMS_Adaptive_Filter(
    .clk(clk),
    .ini(ini),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .i_data(i_data),
    .i_desire(i_desire),
    .o_err(o_err),
    .out_sig(out_sig),
    .input_rdy(input_rdy)
    );
endmodule
