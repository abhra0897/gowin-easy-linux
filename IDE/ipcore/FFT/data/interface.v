`include "defile.v"
`include "static_macro_define.v"

module `MODULE_NAME (
    idx,
    xk_re, xk_im,
    sod, ipd, eod, busy, soud, opd, eoud,
    xn_re, xn_im,
    start, clk, rst
`ifdef MODE_DYNAMIC_THROUGH_PORT
    ,ifft
`endif

`ifdef VARIABLE
    ,pset
    ,points
`endif 

`ifdef SCALING_DYNAMIC_THROUGH_PORT
    ,sfset
    ,sfact
`endif
`ifdef SCALING_DYNAMIC_THROUGH_PORT
    ,scal
`endif
);
    localparam IPD_DW = `INPUT_DATA_WIDTH ;
    localparam OPD_DW = `OUTPUT_DATA_WIDTH ;

`ifdef SCALING_NONE
    localparam FRC_DW = `FRC_DW ;
    localparam SYS_DW = IPD_DW + FRC_DW ;
`endif
`ifndef SCALING_NONE
    localparam SYS_DW = IPD_DW ;
`endif
    localparam POINTS_LOG = `POINTS_LOG ;
    localparam POINTS= 2 ** POINTS_LOG ;
    localparam TDF_DW= `TWIDDLE_FACTOR_WIDTH;

    output [POINTS_LOG -1:0] idx;
    output signed [OPD_DW -1:0] xk_re;
    output signed [OPD_DW -1:0] xk_im;
    output sod, ipd, eod, busy, soud, opd, eoud;
    input signed [IPD_DW -1:0] xn_re;
    input signed [IPD_DW -1:0] xn_im;
    input start;
    input clk;
    input rst;
`ifdef MODE_DYNAMIC_THROUGH_PORT
    input ifft;
`endif

`ifdef VARIABLE
    input pset;
    input [3:0] points;
`endif 

`ifdef SCALING_DYNAMIC_THROUGH_PORT
    input sfset;
    input [3:0] sfact;
`endif
`ifdef SCALING_DYNAMIC_THROUGH_PORT
    input unsigned [1:0] scal;
`endif

    `getname(fft_top,`MODULE_NAME) fft_top_inst(
    .idx(idx),
    .xk_re(xk_re),
    .xk_im(xk_im),
    .sod(sod),
    .ipd(ipd),
    .eod(eod),
    .busy(busy),
    .soud(soud),
    .opd(opd),
    .eoud(eoud),
    .xn_re(xn_re),
    .xn_im(xn_im),
    .start(start),
    .clk(clk),
    .rst(rst)
`ifdef MODE_DYNAMIC_THROUGH_PORT
    ,.ifft(ifft)
`endif

`ifdef VARIABLE
    ,.pset(pset)
    ,.points(points)
`endif 

`ifdef SCALING_DYNAMIC_THROUGH_PORT
    ,.sfset(sfset)
    ,.sfact(sfact)
`endif
`ifdef SCALING_DYNAMIC_THROUGH_PORT
    ,.scal(scal)
`endif
    );


endmodule
