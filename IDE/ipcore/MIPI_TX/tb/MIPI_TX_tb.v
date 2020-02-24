// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2019 Shandong Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] MIPI_TX_tb.v
//   \ \  / /\ \  / /    [Description ] TOP Verilog file for the DPHY TX testbench design
//    \ \/ /  \ \/ /     [Timestamp   ] Tue Oct 28 10:00:00 2019
//     \  /    \  /      [version     ] 1.0
//      \/      \/
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Ver: | Author |Mod. Date |Changes Made:
// V1.0 | Zhiwei |02/07/19  |Initial version
// V1.1 | Zhiwei |28/10/19  |Add 16bit TX Data 
// ===========Oooo==========================================Oooo========

`include "dphy_define.v"

`timescale 1ns / 1ps

module DPHY_TX_tb();
/////////////////////////////////////////////////////////////

`ifdef DPHY_MIPI_IO
     `ifdef MIPI_LANE3
          parameter lane_width = 4;   
     `elsif MIPI_LANE2
          parameter lane_width = 3;
     `elsif MIPI_LANE1
          parameter lane_width = 2;
     `elsif MIPI_LANE0
          parameter lane_width = 1;
     `endif
`else
     `ifdef HS_DATA3
          parameter lane_width = 4;   
     `elsif HS_DATA2
          parameter lane_width = 3;
     `elsif HS_DATA1
          parameter lane_width = 2;
     `elsif HS_DATA0
          parameter lane_width = 1;
     `endif
`endif
   parameter                    word_width     = 8;
/////////////////////////////////////////////////////////////
   GSR GSR(.GSRI(1'b1));
   //PUR PUR_INST(.PUR(1'b1));
   parameter num_frames        = 1  ;
   parameter htotal            = 2200/lane_width ;
   parameter hactive           = 1920/lane_width ;
   parameter htotal_8bit       = (word_width*htotal) /8 ;
   parameter hactive_8bit      = (word_width*hactive)/8 ;
//   parameter vtotal            = 1125;
//   parameter vactive           = 1080;
   parameter vtotal            = 112;
   parameter vactive           = 100;


   reg                      rstn           ;
   reg                      clk            ;
   reg                      clkx2          ;
   reg                      clkx4          ;
   reg                      clkx8          ;
   reg                      clkx16         ;
   reg  hactive_flag;
   wire [1:0] LPCLK, LP3, LP2, LP1, LP0;

   wire HS_CLK_TX_P,HS_CLK_TX_N;
   wire HS_DATA3_TX_P,HS_DATA3_TX_N;
   wire HS_DATA2_TX_P,HS_DATA2_TX_N;
   wire HS_DATA1_TX_P,HS_DATA1_TX_N;
   wire HS_DATA0_TX_P,HS_DATA0_TX_N;
   wire sclk_tx ;

`ifdef GEN_MIPI_TX_16   
   reg  [63:0] data_in;
   reg  [15:0] data0, data1, data2, data3;
   reg  [15:0] dout, dout1;
   reg  [15:0] data_cntr;
`endif

`ifdef GEN_MIPI_TX_8   
   reg  [31:0] data_in;
   reg  [7:0]  data0, data1, data2, data3;
   reg  [7:0]  dout, dout1;
   reg  [7:0]  data_cntr;
`endif



`ifdef GEN_MIPI_TX_8 
   initial
   begin
      rstn         = 1'b0;
      clk          = 1'b0;
      clkx2        = 1'b0;
      clkx4        = 1'b0;
      clkx8        = 1'b0;
      clkx16       = 1'b0;
      data_in      = 'b0; 
      data_cntr    = 'b0;
      hactive_flag = 'b0;
      #1200 
      rstn         = 1'b1;
      #1200;
      repeat (num_frames)
      begin
        //Active region
        repeat (vactive)
        begin
          //Packet Header
          @(negedge clkx2) hactive_flag = 1;
          @(negedge clkx2) data_in = 'h1D1D1D1D;   // Leader Sequence = 00011101,
          @(negedge clkx2) data_in = 'hB8600654;   // Data ID = {VC = 0, Device Type = 0x2A = RAW8},// ECC=1D
          //line data 1,2,3,...
          repeat(hactive_8bit)
               @(negedge clkx2) begin data_in = {data0, data1, data2, data3}; end
          //Packet Footer
          @(negedge clkx2) data_in = 'hCABACABA;   //checksum = 0xCABA
          @(negedge clkx2) data_in = 'hCABACABA;   //checksum = 0xCABA
          @(negedge clkx2) hactive_flag = 0; 
          //Blanking
           repeat(htotal_8bit-hactive_8bit-3-2)    //blanking = total - active - PH - PF
              @(negedge clkx2) data_in = 0;
        end
        //vertical blanking
        repeat (vtotal-vactive-1-1)
        begin  //blanking = total - active - FS - FE
          repeat(htotal_8bit)
            @(negedge clkx2) data_in = 'h00000000;
        end
      end
      $finish;
   end
`endif 

`ifdef GEN_MIPI_TX_16
   initial
   begin
      rstn         = 1'b0;
      clk          = 1'b0;
      clkx2        = 1'b0;
      clkx4        = 1'b0;
      clkx8        = 1'b0;
      clkx16       = 1'b0;
      data_in      = 'b0; 
      data_cntr    = 'b0;
      hactive_flag = 'b0;
      #1200 
      rstn         = 1'b1;
      #1200;
      repeat (num_frames)
      begin
        //Active region
        repeat (vactive)
        begin
          //Packet Header
          @(negedge clkx2)  hactive_flag = 1;
          @(negedge clkx2)  data_in = 'h001D_001D_001D_001D;   // Leader Sequence = 00011101,
          @(negedge clkx2)  data_in = 'h00B8_0060_0006_0054;   // Data ID = {VC = 0, Device Type = 0x2A = RAW8},// ECC=1D
          //line data 1,2,3,...
          repeat(hactive_8bit)
               @(negedge clkx2) begin data_in = {data0, data1, data2, data3}; end
          //Packet Footer
          @(negedge clkx2) data_in = 'h00CA_00BA_00CA_00BA;    //checksum = 0xCABA
          @(negedge clkx2) data_in = 'h00CA_00BA_00CA_00BA;    //checksum = 0xCABA
          @(negedge clkx2) hactive_flag = 0;
          //Blanking
           repeat(htotal_8bit-hactive_8bit-3-2) //blanking = total - active - PH - PF
              @(negedge clkx2) data_in = 0;
        end
        //vertical blanking
        repeat (vtotal-vactive-1-1)
        begin  //blanking = total - active - FS - FE
          repeat(htotal_8bit)
            @(negedge clkx2) data_in = 'h0000_0000_0000_0000;
        end
      end
      $finish;
   end

`endif

   parameter periode_16    = 1 ;
   parameter periode_8     = 2 ;
   parameter periode_4     = 4 ;
   parameter periode_2     = 8 ;
   parameter periode_1     = 16;

   always clk    = #periode_1  ~clk;
   always clkx2  = #periode_2  ~clkx2;
   always clkx4  = #periode_4  ~clkx4;
   always clkx8  = #periode_8  ~clkx8;
   always clkx16 = #periode_16 ~clkx16;

   always @(posedge clkx2 or negedge rstn) 
   begin
     if(~hactive_flag)   
     begin
       data0 <= 'b0;
       data1 <= 'b0;
       data2 <= 'b0;
       data3 <= 'b0;
       data_cntr <= 'b0;
     end
     else  
     begin
       data0     <= data_cntr;
       data1     <= data_cntr;
       data2     <= data_cntr;
       data3     <= data_cntr;
       data_cntr <= data_cntr+1;
     end
   end


`ifdef GEN_MIPI_TX_8  
   always @(posedge clkx2 or negedge rstn) 
   begin
     if(~rstn) 
     begin
       dout  <= 'b0;
       dout1 <= 'b0;
     end
     else
     begin
       dout   <= {data_in[0], data_in[1], data_in[2], data_in[3], data_in[4], data_in[5], data_in[6], data_in[7]};
       dout1  <= dout;
     end
   end
`endif

`ifdef GEN_MIPI_TX_16  
   always @(posedge clkx2 or negedge rstn) 
   begin
     if(~rstn) 
     begin
       dout  <= 'b0;
       dout1 <= 'b0;
     end
     else
     begin
       dout   <= {data_in[0], data_in[1], data_in[2], data_in[3], data_in[4], data_in[5], data_in[6], data_in[7] ,
                  data_in[8], data_in[9], data_in[10], data_in[11], data_in[12], data_in[13], data_in[14], data_in[15]};
       dout1  <= dout;
     end
   end
`endif
 



`ifdef DPHY_MIPI_IO

    DPHY_TX_TOP u_DPHY_TX_TOP(
          .reset_n        (rstn)           ,
          .MIPI_CLK_P     (HS_CLK_TX_P)    ,
          .MIPI_CLK_N     (HS_CLK_TX_N)    ,
     `ifdef INTERNAL_PLL
          .clk_byte       (clkx2)          ,
     `else
          .clk_bit        (CLKOP)          ,
          .clk_bit_90     (CLKOS)          ,
     `endif
          .lp_clk_out     (2'b00)          , 
     `ifdef MIPI_LANE3
          .MIPI_LANE3_P   (HS_DATA3_TX_P)  ,   
          .MIPI_LANE3_N   (HS_DATA3_TX_N)  ,   
          .data_in3       (dout1)          , 
          .lp_data3_out   (2'b00)          ,      
     `endif
     `ifdef MIPI_LANE2
          .MIPI_LANE2_P   (HS_DATA2_TX_P)  ,   
          .MIPI_LANE2_N   (HS_DATA2_TX_N)  ,   
          .data_in2       (dout1)          ,   
          .lp_data2_out   (2'b00)          ,  
     `endif
     `ifdef MIPI_LANE1
          .MIPI_LANE1_P   (HS_DATA1_TX_P)  ,   
          .MIPI_LANE1_N   (HS_DATA1_TX_N)  ,   
          .data_in1       (dout1)          ,  
          .lp_data1_out   (2'b00)          ,   
     `endif
     `ifdef MIPI_LANE0
          .MIPI_LANE0_P   (HS_DATA0_TX_P)  ,   
          .MIPI_LANE0_N   (HS_DATA0_TX_N)  ,   
          .data_in0       (dout1)          ,  
          .lp_data0_out   (2'b00)          ,   
     `endif

          .hs_clk_en      (hactive_flag)   ,
          .hs_data_en     (hactive_flag)   ,    
          .sclk           (sclk_tx)
      );

`else
    DPHY_TX_TOP u_DPHY_TX_TOP(
          .reset_n      (rstn)           ,
          .HS_CLK_P     (HS_CLK_TX_P)    ,
          .HS_CLK_N     (HS_CLK_TX_N)    ,
     `ifdef INTERNAL_PLL
          .clk_byte     (clkx2)          ,
     `else
          .clk_bit      (CLKOP)          ,
          .clk_bit_90   (CLKOS)          ,
     `endif
     `ifdef HS_DATA3
          .HS_DATA3_P   (HS_DATA3_TX_P)  ,
          .HS_DATA3_N   (HS_DATA3_TX_N)  ,
          .data_in3     (dout1)          ,
     `endif
     `ifdef HS_DATA2
          .HS_DATA2_P   (HS_DATA2_TX_P)  ,
          .HS_DATA2_N   (HS_DATA2_TX_N)  ,
          .data_in2     (dout1)          ,
     `endif
     `ifdef HS_DATA1
          .HS_DATA1_P   (HS_DATA1_TX_P)  ,
          .HS_DATA1_N   (HS_DATA1_TX_N)  ,
          .data_in1     (dout1)          ,
     `endif
     `ifdef HS_DATA0
          .HS_DATA0_P   (HS_DATA0_TX_P)  ,
          .HS_DATA0_N   (HS_DATA0_TX_N)  ,
          .data_in0     (dout1)          ,
     `endif
     `ifdef LP_CLK
          .LP_CLK       (LPCLK)          ,
          .lp_clk_out   (2'b00)          ,
          .lp_clk_in    ()               ,
          .lp_clk_dir   (1'b1)           ,
     `endif
     `ifdef LP_DATA3
          .LP_DATA3     (LP3)            ,
          .lp_data3_out (2'b00)          ,
          .lp_data3_in  ()               ,
          .lp_data3_dir (1'b1)           ,
     `endif
     `ifdef LP_DATA2
          .LP_DATA2     (LP2)            ,
          .lp_data2_out (2'b00)          ,
          .lp_data2_in  ()               ,
          .lp_data2_dir (1'b1)           ,
     `endif
     `ifdef LP_DATA1
          .LP_DATA1     (LP1)            ,
          .lp_data1_out (2'b00)          ,
          .lp_data1_in  ()               ,
          .lp_data1_dir (1'b1)           ,
     `endif
     `ifdef LP_DATA0
          .LP_DATA0     (LP0)            ,
          .lp_data0_out (2'b00)          ,
          .lp_data0_in  ()               ,
          .lp_data0_dir (1'b1)           ,
     `endif
          .hs_clk_en    (hactive_flag)   ,
          .hs_data_en   (hactive_flag)   ,    
          .sclk         (sclk_tx)
      );

`endif



endmodule
