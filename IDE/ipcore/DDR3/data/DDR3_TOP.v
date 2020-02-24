`timescale 1ps/1ps
`include "ddr3_name.v"
`include "DDR3_define.v"
//`include "gwmc_local_param.v"

module `module_name_ddr
(
    // user interface
    clk,
    rst_n,
    app_burst_number,
    cmd_ready,
    cmd,
    cmd_en,
    addr,
    wr_data_rdy,
    wr_data,
    wr_data_en,
    wr_data_end,
    wr_data_mask,
    rd_data,
    rd_data_valid,
    rd_data_end,
    sr_req,
    ref_req,
    sr_ack,
    ref_ack,
    init_calib_complete,
    clk_out,
    ddr_rst,
    `ifdef ECC
    ecc_err,
    `endif
    burst,
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
    O_ddr_odt,
    O_ddr_reset_n,
    O_ddr_dqm,
    IO_ddr_dq,
    IO_ddr_dqs,
    IO_ddr_dqs_n
    );

  `include "gwmc_param.v"
  `include "gwmc_local_param.v"

    // user interface
    input [5:0]                    app_burst_number;
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
    output                         ddr_rst;
    input                          rst_n;
    output [ROW_WIDTH-1:0]         O_ddr_addr;
    output [BANK_WIDTH-1:0]        O_ddr_ba;
    output                         O_ddr_cs_n;
    output                         O_ddr_ras_n;
    output                         O_ddr_cas_n;
    output                         O_ddr_we_n;
    output                         O_ddr_clk;
    output                         O_ddr_clk_n;
    output                         O_ddr_cke;
    output                         O_ddr_odt;
    output                         O_ddr_reset_n;
    output [DM_WIDTH-1:0]          O_ddr_dqm;
    inout  [DQ_WIDTH-1:0]          IO_ddr_dq;
    inout  [DQS_WIDTH-1:0]         IO_ddr_dqs;
    inout  [DQS_WIDTH-1:0]         IO_ddr_dqs_n; 
//////////////////////////////////////////////////////////////////

if(nCK_PER_CLK == 4) begin
    `getname(gw3_phy_mc,`module_name_ddr) gw3mc_top(
    .clk                     (clk),
    .rst_n                   (rst_n),
    .app_burst_number        (app_burst_number),
    .cmd_ready               (cmd_ready),
    .cmd                     (cmd),
    .cmd_en                  (cmd_en),
    .addr                    (addr),
    .wr_data_rdy             (wr_data_rdy),
    .wr_data                 (wr_data),
    .wr_data_en              (wr_data_en),
    .wr_data_end             (wr_data_end),
    .wr_data_mask            (wr_data_mask),
    .rd_data                 (rd_data),
    .rd_data_valid           (rd_data_valid),
    .rd_data_end             (rd_data_end),
    .sr_req                  (sr_req),
    .ref_req                 (ref_req),
    .sr_act                  (sr_ack),
    .ref_ack                 (ref_ack),
    .init_calib_complete     (init_calib_complete),
    `ifdef ECC
    .ecc_err                 (ecc_err),
    `endif
    .clk_out                 (clk_out),
    .burst                   (burst),
    .ddr_rst                 (ddr_rst),
    .O_ddr_addr              (O_ddr_addr),
    .O_ddr_ba                (O_ddr_ba),
    .O_ddr_cs_n              (O_ddr_cs_n),
    .O_ddr_ras_n             (O_ddr_ras_n),
    .O_ddr_cas_n             (O_ddr_cas_n),
    .O_ddr_we_n              (O_ddr_we_n),
    .O_ddr_clk               (O_ddr_clk),
    .O_ddr_clk_n             (O_ddr_clk_n),
    .O_ddr_cke               (O_ddr_cke),
    .O_ddr_odt               (O_ddr_odt),
    .O_ddr_reset_n           (O_ddr_reset_n),
    .O_ddr_dqm               (O_ddr_dqm),
    .IO_ddr_dq               (IO_ddr_dq),
    .IO_ddr_dqs              (IO_ddr_dqs),
    .IO_ddr_dqs_n            (IO_ddr_dqs_n)
    );
end
else begin
    `getname(gw3_phy_mc,`module_name_ddr) gw3mc_top(
    .clk                     (clk),
    .rst_n                   (rst_n),
  //  .app_burst_number        (app_burst_number),
    .cmd_ready               (cmd_ready),
    .cmd                     (cmd),
    .cmd_en                  (cmd_en),
    .addr                    (addr),
    .wr_data_rdy             (wr_data_rdy),
    .wr_data                 (wr_data),
    .wr_data_en              (wr_data_en),
    .wr_data_end             (wr_data_end),
    .wr_data_mask            (wr_data_mask),
    .rd_data                 (rd_data),
    .rd_data_valid           (rd_data_valid),
    .rd_data_end             (rd_data_end),
    .sr_req                  (sr_req),
    .ref_req                 (ref_req),
    .sr_act                  (sr_ack),
    .ref_ack                 (ref_ack),
    .init_calib_complete     (init_calib_complete),
    `ifdef ECC
    .ecc_err                 (ecc_err),
    `endif
    .clk_out                 (clk_out),
    .burst                   (burst),
    .ddr_rst                 (ddr_rst),
    .O_ddr_addr              (O_ddr_addr),
    .O_ddr_ba                (O_ddr_ba),
    .O_ddr_cs_n              (O_ddr_cs_n),
    .O_ddr_ras_n             (O_ddr_ras_n),
    .O_ddr_cas_n             (O_ddr_cas_n),
    .O_ddr_we_n              (O_ddr_we_n),
    .O_ddr_clk               (O_ddr_clk),
    .O_ddr_clk_n             (O_ddr_clk_n),
    .O_ddr_cke               (O_ddr_cke),
    .O_ddr_odt               (O_ddr_odt),
    .O_ddr_reset_n           (O_ddr_reset_n),
    .O_ddr_dqm               (O_ddr_dqm),
    .IO_ddr_dq               (IO_ddr_dq),
    .IO_ddr_dqs              (IO_ddr_dqs),
    .IO_ddr_dqs_n            (IO_ddr_dqs_n)
    );
end


endmodule





