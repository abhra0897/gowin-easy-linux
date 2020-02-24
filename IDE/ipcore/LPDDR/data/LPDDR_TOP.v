// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2017 Jinan Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] DDR_TOP.v
//   \ \  / /\ \  / /    [Description ] TOP Verilog file for the DDR TOP design
//    \ \/ /  \ \/ /     [Timestamp   ] Tue Aug 17 15:30:00 2017
//     \  /    \  /      [version     ] 1.0
//      \/      \/
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Ver: | Author |Mod. Date |Changes Made:
// V1.0 | Horace |17/08/17  |Initial version
// ===========Oooo==========================================Oooo========

  `timescale 1ps/1ps
  `include "ddr_name.v"
  `include "DDR_define.v"
  module `module_name_ddr (
    // user interface
    clk,
    rst_n,
    wr_data_en,
    wr_data,
    wr_data_end,
    wr_data_mask,
    cmd_en,
    cmd,
    addr,
    sr_req,
    ref_req,
    burst,
    ddr_rst,
    sr_ack,
    ref_ack,
    wr_data_rdy,
    init_calib_complete,
    cmd_ready,
    rd_data_valid,
    rd_data_end,
    rd_data,
    clk_out,
    `ifdef ECC
    ecc_err,
    `endif
    // mem interface
    O_ddr_addr,
    O_ddr_ba,
    O_ddr_cs_n,
    O_ddr_ras_n,
    O_ddr_cas_n,
    O_ddr_we_n,
    O_ddr_clk,
    O_ddr_clk_n,
    O_ddr_cke,
    O_ddr_dqm,
    IO_ddr_dq,
    IO_ddr_dqs
    );

  `include "gwmc_param.v"
  `include "gwmc_local_param.v"

    // user interface
    input                          wr_data_en;
    input [APP_MASK_WIDTH-1:0]     wr_data_mask;
    input                          wr_data_end;
    input [APP_DATA_WIDTH-1:0]     wr_data;
    input                          cmd_en;
    input [2:0]                    cmd;
    input [ADDR_WIDTH-1:0]         addr;
    output                         sr_ack;
    output                         ref_ack;
    output                         wr_data_rdy;
    output                         init_calib_complete; 
    output                         cmd_ready;
    output                         rd_data_valid; 
    output                         rd_data_end;
    output [APP_DATA_WIDTH-1:0]    rd_data;
    `ifdef ECC
    output [APP_DATA_WIDTH/32-1:0] ecc_err;
    `endif
    input                          sr_req;
    input                          ref_req;
    input                          burst;
    input                          clk;
    output                         clk_out;
    input                          rst_n;
    output                         ddr_rst;
    output [ROW_WIDTH-1:0]         O_ddr_addr;
    output [BANK_WIDTH-1:0]        O_ddr_ba;
    output                         O_ddr_cs_n;
    output                         O_ddr_ras_n;
    output                         O_ddr_cas_n;
    output                         O_ddr_we_n;
    output                         O_ddr_clk;
    output                         O_ddr_clk_n;
    output                         O_ddr_cke;
    output [DM_WIDTH-1:0]          O_ddr_dqm;
    inout  [DQ_WIDTH-1:0]          IO_ddr_dq;
    inout  [DQS_WIDTH-1:0]         IO_ddr_dqs;


  

//////////////////////////////////////////////////////////////////
`getname(gw_phy_mc,`module_name_ddr) u_gw_phy_mc_top(
    .clk                     (clk),
    .wr_data_en              (wr_data_en),
    .wr_data_mask            (wr_data_mask),
    .wr_data_end             (wr_data_end),
    .wr_data                 (wr_data),
    .cmd_en                  (cmd_en),
    .cmd                     (cmd),
    .addr                    (addr),
    .sr_ack                  (sr_ack),
    .ref_ack                 (ref_ack),
    .wr_data_rdy             (wr_data_rdy),
    .init_calib_complete     (init_calib_complete),
    .cmd_ready               (cmd_ready),
    .rd_data_valid           (rd_data_valid),
    .rd_data_end             (rd_data_end),
    .rd_data                 (rd_data),
    `ifdef ECC
    .ecc_err                 (ecc_err),
    `endif
    .sr_req                  (sr_req),
    .ref_req                 (ref_req),
    .clk_out                 (clk_out),
    .rst_n                   (rst_n),
    .ddr_rst                 (ddr_rst),
    .burst                   (burst),
    .O_ddr_addr              (O_ddr_addr),
    .O_ddr_ba                (O_ddr_ba), 
    .O_ddr_cs_n              (O_ddr_cs_n),
    .O_ddr_ras_n             (O_ddr_ras_n),
    .O_ddr_cas_n             (O_ddr_cas_n),
    .O_ddr_we_n              (O_ddr_we_n),
    .O_ddr_clk               (O_ddr_clk),
    .O_ddr_clk_n             (O_ddr_clk_n),
    .O_ddr_cke               (O_ddr_cke),
    .O_ddr_dqm               (O_ddr_dqm),
    .IO_ddr_dq               (IO_ddr_dq),
    .IO_ddr_dqs              (IO_ddr_dqs)
    );
endmodule


