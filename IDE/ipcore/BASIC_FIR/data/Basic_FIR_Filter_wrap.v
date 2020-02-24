`include "define.v"
`include "static_macro_define.v"
module `module_name(
    clk,
    rst_n,
    ini,
    wr_en_data,
    wr_en_coeffi,
    din_coeffi,
    din_data,
    dout,
    done,
    input_rdy
);
`include "param.v"
input clk;
input rst_n;
input ini;
input wr_en_data;
input wr_en_coeffi;
input signed [icoeffi_width-1 : 0] din_coeffi;
input signed [idata_width-1 : 0] din_data;
output signed [53 : 0] dout;
output done;
output input_rdy;

`getname(Basic_FIR_Filter_core,`module_name) Basic_FIR_Filter_cor(
    clk,
    rst_n,
    ini,
    wr_en_data,
    wr_en_coeffi,
    din_coeffi,
    din_data,
    dout,
    done,
    input_rdy
    );
endmodule
