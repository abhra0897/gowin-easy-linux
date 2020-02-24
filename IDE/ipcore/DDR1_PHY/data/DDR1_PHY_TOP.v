`timescale 1ps/1ps
`include "ddr_name.v"
//`include "gwmc_param.v"
//`include "gwmc_local_param.v"
module `module_name_ddr(
                    input   clk,          //from pcb 
                    input   rst_n,

                    // CMD channel
                    input   [nCK_PER_CLK-1:0] mc_cs_n,     
                    input   [nCK_PER_CLK-1:0] mc_ras_n,
                    input   [nCK_PER_CLK-1:0] mc_cas_n,
                    input   [nCK_PER_CLK-1:0] mc_we_n,
                    input   [nCK_PER_CLK*ROW_WIDTH-1:0] mc_address,
                    input   [nCK_PER_CLK*BANK_WIDTH-1:0] mc_bank,
                    input   mc_reset_n,
                    input   [nCK_PER_CLK-1:0] mc_cke,
                    input   mc_cmd_wren,

                    // Data channel
                    input   mc_wrdata_en,
                    input   [2*nCK_PER_CLK*DQ_WIDTH-1:0] mc_wrdata,
                    input   [2*nCK_PER_CLK*DM_WIDTH-1:0] mc_wrdata_mask,
                    output  phy_rd_data_valid,

                    //output  dll_lock,
                    output  [2*nCK_PER_CLK*DQ_WIDTH-1:0] phy_rd_data,
                    output  ddr_init_complete,
  
                    // DDR interface signal
                    output  [ROW_WIDTH-1:0] O_ddr_addr,
                    output  [BANK_WIDTH-1:0] O_ddr_ba,
                    output  O_ddr_cs_n,
                    output  O_ddr_ras_n,
                    output  O_ddr_cas_n,
                    output  O_ddr_we_n,
                    output  O_ddr_clk,
                    output  O_ddr_clk_n,
                    output  O_ddr_cke,
                    output  [DM_WIDTH-1:0]  O_ddr_dqm,
                    inout   [DQ_WIDTH-1:0]  IO_ddr_dq,
                    inout   [DQS_WIDTH-1:0] IO_ddr_dqs,
                    output  clk_x1,            // to Memory Controller
                    output  ddr_rst
                    );

`getname(gw_phy,`module_name_ddr)  u_gw_phy_top
(
  .clk               (clk),                   
  .rst_n             (rst_n),                 
  .mc_cs_n           (mc_cs_n),               
  .mc_ras_n          (mc_ras_n),              
  .mc_cas_n          (mc_cas_n),              
  .mc_we_n           (mc_we_n),               
  .mc_address        (mc_address),            
  .mc_bank           (mc_bank),               
  .mc_reset_n        (mc_reset_n),            
  .mc_cke            (mc_cke),                
  .mc_cmd_wren       (mc_cmd_wren),           
  .mc_wrdata_en      (mc_wrdata_en),          
  .mc_wrdata         (mc_wrdata),             
  .mc_wrdata_mask    (mc_wrdata_mask),        
  .ddr_init_complete (ddr_init_complete),  
  .phy_rd_data_valid (phy_rd_data_valid),     
  .phy_rd_data       (phy_rd_data),           
  .O_ddr_addr        (O_ddr_addr),         
  .O_ddr_ba          (O_ddr_ba),         
  .O_ddr_cs_n        (O_ddr_cs_n),           
  .O_ddr_ras_n       (O_ddr_ras_n),          
  .O_ddr_cas_n       (O_ddr_cas_n),          
  .O_ddr_we_n        (O_ddr_we_n),           
  .O_ddr_clk         (O_ddr_clk),           
  .O_ddr_clk_n       (O_ddr_clk_n),         
  .O_ddr_cke         (O_ddr_cke),          
  .O_ddr_dqm         (O_ddr_dqm),
  .IO_ddr_dq         (IO_ddr_dq),           
  .IO_ddr_dqs        (IO_ddr_dqs),            
  .clk_x1            (clk_x1),
  .ddr_rst           (ddr_rst)
);

endmodule

