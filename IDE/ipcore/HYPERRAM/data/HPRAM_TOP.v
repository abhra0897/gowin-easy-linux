`timescale 1ps/1ps
`include "hpram_define.v"
`include "hpram_local_define.v"

module `module_name_hpram
(
                 clk,
                 memory_clk,
                 pll_lock,
                 rst_n,
                 //psram IO
                 O_hpram_ck,
                 O_hpram_ck_n,
                 IO_hpram_dq,
                 IO_hpram_rwds,
                 O_hpram_cs_n,
                 O_hpram_reset_n,
                 //user IO
                 wr_data,
                 rd_data,
                 rd_data_valid,
                 addr,
                 cmd,
                 cmd_en,
                 init_calib,
                 clk_out,
                 data_mask
                 );
`include "hpram_param.v"
`include "hpram_local_param.v"

    input  clk;
    input  rst_n;
    input  memory_clk;
    input  pll_lock;
    input  [ADDR_WIDTH-1:0] addr;
    output [CS_WIDTH-1:0]   O_hpram_ck;
    output [CS_WIDTH-1:0]   O_hpram_ck_n;
    output [CS_WIDTH-1:0]   O_hpram_cs_n;
    output [CS_WIDTH-1:0]   O_hpram_reset_n;
    inout  [DQ_WIDTH-1:0]   IO_hpram_dq;
    inout  [CS_WIDTH-1:0]   IO_hpram_rwds;
    input  [CS_WIDTH*MASK_WIDTH-1:0] data_mask;
    input  [4*DQ_WIDTH-1:0] wr_data;
    output [4*DQ_WIDTH-1:0] rd_data;
    output rd_data_valid/* synthesis syn_keep=1 */;
    input  cmd;
    input  cmd_en;
    output init_calib;
    output clk_out;


    `getname(hpram_top,`module_name_hpram) u_hpram_top (
    .clk (clk),
    .rst_n (rst_n),
    .memory_clk (memory_clk),
    .pll_lock(pll_lock),
    .O_hpram_ck(O_hpram_ck),
    .O_hpram_ck_n(O_hpram_ck_n),
    .IO_hpram_dq(IO_hpram_dq),
    .IO_hpram_rwds(IO_hpram_rwds),
    .O_hpram_cs_n(O_hpram_cs_n),
    .O_hpram_reset_n(O_hpram_reset_n),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .rd_data_valid(rd_data_valid),
    .addr(addr),
    .cmd(cmd),
    .cmd_en(cmd_en),
    .init_calib(init_calib),
    .clk_out(clk_out),
    .data_mask(data_mask)
    );

endmodule
