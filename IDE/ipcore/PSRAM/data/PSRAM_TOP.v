`timescale 1ps/1ps
`include "psram_define.v"
`include "psram_local_define.v"

module `module_name_psram
(
                 clk,
                 memory_clk,
                 pll_lock,
                 rst_n,
                 //psram IO
                 O_psram_ck,
                 O_psram_ck_n,
                 IO_psram_dq,
                 IO_psram_rwds,
                 O_psram_cs_n,
                 O_psram_reset_n,
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
`include "psram_param.v"
`include "psram_local_param.v"

    input  clk;
    input  rst_n;
    input  memory_clk;
    input  pll_lock;
    input  [ADDR_WIDTH-1:0] addr;
    output [CS_WIDTH-1:0]   O_psram_ck;
    output [CS_WIDTH-1:0]   O_psram_ck_n;
    output [CS_WIDTH-1:0]   O_psram_cs_n;
    output [CS_WIDTH-1:0]   O_psram_reset_n;
    inout  [DQ_WIDTH-1:0]   IO_psram_dq;
    inout  [CS_WIDTH-1:0]   IO_psram_rwds;
    input  [CS_WIDTH*MASK_WIDTH-1:0] data_mask;
    input  [4*DQ_WIDTH-1:0] wr_data;
    output [4*DQ_WIDTH-1:0] rd_data;
    output rd_data_valid/* synthesis syn_keep=1 */;
    input  cmd;
    input  cmd_en;
    output init_calib;
    output clk_out;


    `getname(psram_top,`module_name_psram) u_psram_top (
    .clk (clk),
    .rst_n (rst_n),
    .memory_clk (memory_clk),
    .pll_lock(pll_lock),
    .O_psram_ck(O_psram_ck),
    .O_psram_ck_n(O_psram_ck_n),
    .IO_psram_dq(IO_psram_dq),
    .IO_psram_rwds(IO_psram_rwds),
    .O_psram_cs_n(O_psram_cs_n),
    .O_psram_reset_n(O_psram_reset_n),
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
