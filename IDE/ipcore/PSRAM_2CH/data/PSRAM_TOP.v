`timescale 1ps/1ps
`include "psram_define.v"
`include "psram_local_define.v"

module `module_name_psram (
               clk,
               rst_n,
               O_psram_ck,
               O_psram_ck_n,
               IO_psram_rwds,
               O_psram_reset_n,
               IO_psram_dq,
               O_psram_cs_n,
               init_calib0,
               init_calib1,
               clk_out,
               cmd0, 
               cmd1,
               cmd_en0,
               cmd_en1,
               addr0,
               addr1,
               wr_data0,
               wr_data1,
               rd_data0,
               rd_data1,
               rd_data_valid0,
               rd_data_valid1,
               data_mask0,
               data_mask1
               );

input                   clk;
input                   rst_n;
output                  clk_out;
output  [1:0]           O_psram_ck;
output  [1:0]           O_psram_ck_n;
inout   [1:0]           IO_psram_rwds;
inout   [15:0]          IO_psram_dq;
output  [1:0]           O_psram_reset_n;
output  [1:0]           O_psram_cs_n;
output                  init_calib0;
output                  init_calib1;
input   [31:0]          wr_data0/* synthesis syn_keep=1 */;
output  [31:0]          rd_data0/* synthesis syn_keep=1 */;
output                  rd_data_valid0/* synthesis syn_keep=1 */;
output                  rd_data_valid1/* synthesis syn_keep=1 */;
input   [31:0]          wr_data1/* synthesis syn_keep=1 */;
output  [31:0]          rd_data1/* synthesis syn_keep=1 */;
input                   cmd0;
input                   cmd_en0;
input   [20:0]          addr0;
input   [3:0]           data_mask0;
input                   cmd1;
input                   cmd_en1;
input   [20:0]          addr1;
input   [3:0]           data_mask1;


wire                    recalib;
wire                    recalib0;
wire                    recalib1;
wire    [7:0]           dll_step;
wire                    dll_lock;

wire                    clk_x1;
wire                    memory_clk;
wire                    pll_lock;

assign clk_out = clk_x1;


PLL u_PLL (
            .CLKIN    (clk),
            .CLKFB    (1'b0),
            .RESET    (~rst_n),
            .RESET_P  (1'b0),
            .RESET_I  (1'b0),
            .RESET_S  (1'b0),
            .FBDSEL   ({6{1'b0}}),
            .IDSEL    ({6{1'b0}}),
            .ODSEL    ({6{1'b0}}),
            .DUTYDA   ({4{1'b0}}),
            .PSDA     ({4{1'b0}}),
            .FDLY     (4'b0000),
            .CLKOUT   (memory_clk),
            .LOCK     (pll_lock),
            .CLKOUTP  (),
            .CLKOUTD  (),
            .CLKOUTD3 ()
        );
defparam u_PLL.FCLKIN = "50.0";
defparam u_PLL.DYN_IDIV_SEL= "false";
defparam u_PLL.IDIV_SEL = 4;    //9
defparam u_PLL.DYN_FBDIV_SEL= "false";
defparam u_PLL.FBDIV_SEL = 15;  //32
defparam u_PLL.PSDA_SEL= "0000";
defparam u_PLL.DYN_DA_EN = "false";
defparam u_PLL.DYN_ODIV_SEL = "false";
defparam u_PLL.DUTYDA_SEL= "1000";
defparam u_PLL.CLKOUT_FT_DIR = 1'b1;
defparam u_PLL.CLKOUTP_FT_DIR = 1'b1;
defparam u_PLL.CLKFB_SEL = "internal";
defparam u_PLL.ODIV_SEL = 4;
defparam u_PLL.CLKOUT_BYPASS = "false";
defparam u_PLL.CLKOUTP_BYPASS = "false";
defparam u_PLL.CLKOUTD_BYPASS = "false";
defparam u_PLL.DYN_SDIV_SEL = 2;
defparam u_PLL.CLKOUTD_SRC = "CLKOUT";
defparam u_PLL.CLKOUTD3_SRC = "CLKOUT";
defparam u_PLL.DEVICE = "GW1NR-9";

DLL #(
  .DLL_FORCE (0),
  .CODESCAL  ("101"), 
  .SCAL_EN   ("false"),
  .DIV_SEL   (1'b1)
) u_dll (
            .CLKIN      (clk_x2), 
            .STOP       (!pll_lock), 
            .RESET      (dll_rsti),
            .UPDNCNTL   (uddcntln), 
            .STEP       (dll_step), 
            .LOCK       (dll_lock)
        );


DHCEN u_dhcen_clk_x2p (
            .CLKIN      (memory_clk),
            .CE         (stop),
            .CLKOUT     (clk_x2)
         );

 CLKDIV clkdiv (
            .HCLKIN     (clk_x2),
            .RESETN     (!ddr_rsti),
            .CALIB      (1'b0),
            .CLKOUT     (clk_x1)
        );
defparam clkdiv.DIV_MODE="2";
defparam clkdiv.GSREN="false";

assign recalib  = recalib0 || recalib1;

`getname(psram_sync,`module_name_psram)  u_psram_sync (
            .start_clk   (clk),
            .rst         (!rst_n),
            .pll_lock    (pll_lock),
            .dll_lock    (dll_lock),
            .update      (1'b0),
            .pause       (pause), 
            .stop        (stop),
            .uddcntln    (uddcntln),
            .dll_rst     (dll_rsti),
            .ddr_rst     (ddr_rsti),
            .ready       (ready),
            .recalib     (recalib)
        );


`getname(psram_memory_interface,`module_name_psram) #(
  .qufan ("false"),
  .chafen("false")
) u_psram_top0  (
            .clk        (clk),
            .clk_x2     (clk_x2),
            .clk_x1     (clk_x1),
            .ready      (ready),
            .ddr_rsti   (ddr_rsti),
            .recalib    (recalib0),
            .dll_lock   (dll_lock),
            .dll_step   (dll_step),
            .rst_n      (rst_n),  
            .O_psram_ck (O_psram_ck[0]),
            .O_psram_ck_n(O_psram_ck_n[0]),
            .IO_psram_rwds(IO_psram_rwds[0]),
            .IO_psram_dq(IO_psram_dq[7:0]),
            .O_psram_reset_n(O_psram_reset_n[0]),
            .O_psram_cs_n(O_psram_cs_n[0]),
            .wr_data    (wr_data0),
            .rd_data    (rd_data0),
            .rd_data_valid(rd_data_valid0),
            .addr       (addr0),
            .cmd        (cmd0),
            .cmd_en     (cmd_en0),
            .data_mask  (data_mask0),
            .init_calib (init_calib0)
        );

`getname(psram_memory_interface,`module_name_psram)  #(
 .qufan("true"),
 .chafen("true")
 ) 
u_psram_top1 (
            .clk        (clk),                    
            .clk_x2     (clk_x2),
            .clk_x1     (clk_x1),
            .ready      (ready),
            .ddr_rsti   (ddr_rsti),
            .recalib    (recalib1),
            .dll_lock   (dll_lock),
            .dll_step   (dll_step),
            .rst_n      (rst_n),  
            .O_psram_ck (O_psram_ck[1]),
            .O_psram_ck_n(O_psram_ck_n[1]),
            .IO_psram_rwds(IO_psram_rwds[1]),
            .IO_psram_dq(IO_psram_dq[15:8]),
            .O_psram_reset_n(O_psram_reset_n[1]),
            .O_psram_cs_n(O_psram_cs_n[1]),
            .wr_data    (wr_data1),
            .rd_data    (rd_data1),
            .rd_data_valid(rd_data_valid1),
            .addr       (addr1),
            .cmd        (cmd1),
            .cmd_en     (cmd_en1),                     
            .data_mask  (data_mask1),
            .init_calib (init_calib1)
        );

endmodule



