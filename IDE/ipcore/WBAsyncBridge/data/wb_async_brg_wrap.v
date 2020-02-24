`include "define.vh"
`include "static_macro_define.vh"
module `module_name(
    // master side
    wbm_clk,
    wbm_rst,
    wbm_adr_i,   // ADR_I() address
    wbm_dat_i,   // DAT_I() data in
    wbm_dat_o,   // DAT_O() data out
    wbm_we_i,    // WE_I write enable input
    wbm_sel_i,   // SEL_I() select input
    wbm_stb_i,   // STB_I strobe input
    wbm_ack_o,   // ACK_O acknowledge output
    wbm_err_o,   // ERR_O error output
    wbm_rty_o,   // RTY_O retry output
    wbm_cyc_i,   // CYC_I cycle input
    // slave side    
    wbs_clk,
    wbs_rst,
    wbs_adr_o,   // ADR_O() address
    wbs_dat_i,   // DAT_I() data in
    wbs_dat_o,   // DAT_O() data out
    wbs_we_o,    // WE_O write enable output
    wbs_sel_o,   // SEL_O() select output
    wbs_stb_o,   // STB_O strobe output
    wbs_ack_i,   // ACK_I acknowledge input
    wbs_err_i,   // ERR_I error input
    wbs_rty_i,   // RTY_I retry input
    wbs_cyc_o    // CYC_O cycle output
);
    `include "parameter.vh"
    localparam SELECT_WIDTH = DATA_WIDTH/8;     // width of word select bus (1, 2, 4, or 8)
    
    // master side
    input  wire                    wbm_clk;
    input  wire                    wbm_rst;
    input  wire [ADDR_WIDTH-1:0]   wbm_adr_i;   // ADR_I() address
    input  wire [DATA_WIDTH-1:0]   wbm_dat_i;   // DAT_I() data in
    output wire [DATA_WIDTH-1:0]   wbm_dat_o;   // DAT_O() data out
    input  wire                    wbm_we_i;    // WE_I write enable input
    input  wire [SELECT_WIDTH-1:0] wbm_sel_i;   // SEL_I() select input
    input  wire                    wbm_stb_i;   // STB_I strobe input
    output wire                    wbm_ack_o;   // ACK_O acknowledge output
    output wire                    wbm_err_o;   // ERR_O error output
    output wire                    wbm_rty_o;   // RTY_O retry output
    input  wire                    wbm_cyc_i;   // CYC_I cycle input
    // slave side
    input  wire                    wbs_clk;
    input  wire                    wbs_rst;
    output wire [ADDR_WIDTH-1:0]   wbs_adr_o;   // ADR_O() address
    input  wire [DATA_WIDTH-1:0]   wbs_dat_i;   // DAT_I() data in
    output wire [DATA_WIDTH-1:0]   wbs_dat_o;   // DAT_O() data out
    output wire                    wbs_we_o;    // WE_O write enable output
    output wire [SELECT_WIDTH-1:0] wbs_sel_o;   // SEL_O() select output
    output wire                    wbs_stb_o;   // STB_O strobe output
    input  wire                    wbs_ack_i;   // ACK_I acknowledge input
    input  wire                    wbs_err_i;   // ERR_I error input
    input  wire                    wbs_rty_i;   // RTY_I retry input
    output wire                    wbs_cyc_o;    // CYC_O cycle output
  `getname(wb_async_brg,`module_name)  wb_async_brg (
    .wbm_clk    ( wbm_clk),
    .wbm_rst    ( wbm_rst),
    .wbm_adr_i  ( wbm_adr_i),
    .wbm_dat_i  ( wbm_dat_i),
    .wbm_dat_o  ( wbm_dat_o),
    .wbm_we_i   ( wbm_we_i),
    .wbm_sel_i  ( wbm_sel_i),
    .wbm_stb_i  ( wbm_stb_i),
    .wbm_ack_o  ( wbm_ack_o),
    .wbm_err_o  ( wbm_err_o),
    .wbm_rty_o  ( wbm_rty_o),
    .wbm_cyc_i  ( wbm_cyc_i),
    .wbs_clk    ( wbs_clk),
    .wbs_rst    ( wbs_rst),
    .wbs_adr_o  ( wbs_adr_o),
    .wbs_dat_i  ( wbs_dat_i),
    .wbs_dat_o  ( wbs_dat_o),
    .wbs_we_o   ( wbs_we_o),
    .wbs_sel_o  ( wbs_sel_o),
    .wbs_stb_o  ( wbs_stb_o),
    .wbs_ack_i  ( wbs_ack_i),
    .wbs_err_i  ( wbs_err_i),
    .wbs_rty_i  ( wbs_rty_i),
    .wbs_cyc_o  ( wbs_cyc_o)
  );
    defparam wb_async_brg.DATA_WIDTH=DATA_WIDTH;
    defparam wb_async_brg.ADDR_WIDTH=ADDR_WIDTH;
endmodule
