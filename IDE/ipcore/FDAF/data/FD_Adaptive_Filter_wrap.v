`include "define.v"
`include "static_macro_define.v"
module `module_name(
    clk,
    rst,
    start,
//input
    ad,
    xn,
    dn,
//output
    ld_ad,
    en,
    yn,
    ipd,
    busy,
    done
);

localparam data_width    =   18          ;
localparam n_log         =   5           ;
localparam n             =   2**n_log    ;//filter length
localparam n2            =   2*n         ;//block length
`include "parameter.v"
localparam len_log       =   $clog2(length);
localparam fra_wd        =   15          ;
localparam block_num     =   length/n;

input                                   clk,rst,start;
input   signed      [data_width-1       : 0]    xn;
input   signed      [data_width-1       : 0]    dn;
input               [len_log-1          : 0]    ad;

output  signed      [data_width-1       : 0]    en;
output  signed      [data_width-1       : 0]    yn;
output              ipd,busy;
output              [len_log-1          : 0]    ld_ad;
output                                  done;

`getname(FD_Adaptive_Filter_Top,`module_name) u_FD_Adaptive_Filter_Top
    (
    .clk(clk),
    .rst(rst),
    .start(start),
    .xn(xn),
    .dn(dn),
    .ld_ad(ld_ad),
    .en(en),
    .yn(yn),
    .ipd(ipd),
    .busy(busy),
    .ad(ad),
    .done(done)
    );
defparam u_FD_Adaptive_Filter_Top.data_width = data_width;
defparam u_FD_Adaptive_Filter_Top.n_log = n_log;
defparam u_FD_Adaptive_Filter_Top.n = n;
defparam u_FD_Adaptive_Filter_Top.n2 = n2;
defparam u_FD_Adaptive_Filter_Top.length = length;
defparam u_FD_Adaptive_Filter_Top.len_log=len_log;
defparam u_FD_Adaptive_Filter_Top.fra_wd=fra_wd;

endmodule
