// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2019 Shandong Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] DPHY_RX_tb.v
//   \ \  / /\ \  / /    [Description ] Verilog file for the DPHY RX testbench design
//    \ \/ /  \ \/ /     [Timestamp   ] Tue July 2 15:30:00 2015
//     \  /    \  /      [version     ] 1.0
//      \/      \/       
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Ver: | Author |Mod. Date |Changes Made:
// V1.0 | Zhiwei |02/07/19  |Initial version
// ===========Oooo==========================================Oooo========

`include "dphy_define.v"

`timescale 1ns / 1ps

module DPHY_RX_tb();     
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
   
   wire [7:0] byte_D3, byte_D2, byte_D1, byte_D0;
   wire [1:0] LP_CLK, LP3, LP2, LP1, LP0;
   wire HS_CLK_RX_P, HS_CLK_RX_N   ;
   wire HS_DATA3_RX_P, HS_DATA3_RX_N ;
   wire HS_DATA2_RX_P, HS_DATA2_RX_N ;
   wire HS_DATA1_RX_P, HS_DATA1_RX_N ;
   wire HS_DATA0_RX_P, HS_DATA0_RX_N ;
   wire clk_byte_out;
   reg   dout, dout1, dout2, dout3;

`ifdef GEN_MIPI_RX_16   
   reg  [63:0] data_in;
   reg  [15:0] data0, data1, data2, data3;
   reg  [15:0] data_cntr;
   wire [15:0] data_out3, data_out2, data_out1, data_out0;
`endif

`ifdef GEN_MIPI_RX_8   
   reg  [31:0] data_in;
   reg  [7:0]  data0, data1, data2, data3;
   reg  [7:0]  data_cntr;
   wire [7:0]  data_out3, data_out2, data_out1, data_out0;
`endif


`ifdef GEN_MIPI_RX_8 
   initial begin                       
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
          @(negedge clkx2) data_in = 'hB8600654;   // Data ID = {VC = 0, Device Type = 0x2A = RAW8}, ECC=1D
          //line data 1,2,3,...
          repeat(hactive_8bit)
            @(negedge clkx2) begin data_in = {data0, data1, data2, data3}; end  
          //Packet Footer
          @(negedge clkx2) data_in = 'hCABACABA;   //checksum = 0xCABA 
          @(negedge clkx2) data_in = 'hCABACABA;   //checksum = 0xCABA   
          @(negedge clkx2) hactive_flag = 0;  
          //Blanking
          repeat(htotal_8bit-hactive_8bit-3-2)     //blanking = total - active - PH - PF
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


`ifdef GEN_MIPI_RX_16 
   initial begin                       
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
          @(negedge clk)  hactive_flag = 1;
          @(negedge clk)  data_in = 'h001D_001D_001D_001D;   // Leader Sequence = 00011101,
          @(negedge clk)  data_in = 'h00B8_0060_0006_0054;   // Data ID = {VC = 0, Device Type = 0x2A = RAW8}, ECC=1D
          //line data 1,2,3,...
          repeat(hactive_8bit)
            @(negedge clk) begin data_in = {data0, data1, data2, data3}; end  
          //Packet Footer
          @(negedge clk) data_in = 'h00CA_00BA_00CA_00BA;    //checksum = 0xCABA 
          @(negedge clk) data_in = 'h00CA_00BA_00CA_00BA;    //checksum = 0xCABA 
          @(negedge clk) hactive_flag = 0;     
          //Blanking
          repeat(htotal_8bit-hactive_8bit-3-2)               //blanking = total - active - PH - PF
            @(negedge clk) data_in = 0;     
        end
        //vertical blanking 
        repeat (vtotal-vactive-1-1)
        begin                                                //blanking = total - active - FS - FE     
          repeat(htotal_8bit)
          @(negedge clk) data_in = 'h0000_0000_0000_0000;
        end
      end
    $finish;
   end

`endif

/////////////////////////////////////////////////////////////
   
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
       data0 <= 0;
       data1 <= 0; 
       data2 <= 0;
       data3 <= 0; 
       data_cntr <= 0;
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
           
`ifdef GEN_MIPI_RX_8              
   integer i;
   always @(posedge clkx16 or negedge rstn) 
   begin
     if(~rstn)
          i <= 7;
     else if (i>0)
          i <= i-1;
     else
          i <=7;
   end

   always @(posedge clkx16 or negedge rstn)
   begin
     if(~rstn) 
     begin
       dout  <= 0;
       dout1 <= 0;
       dout2 <= 0;
       dout3 <= 0;
     end   
     else
     begin
       dout  <= data_in[i];   
       dout1 <= data_in[i+8];  
       dout2 <= data_in[i+16];
       dout3 <= data_in[i+24];
     end
   end
  
`endif

`ifdef GEN_MIPI_RX_16   
   integer i;
   always @(posedge clkx16 or negedge rstn) 
   begin
     if(~rstn)
          i <= 15;
     else if (i>0)
          i <= i-1;
     else
          i <=15;
   end 

   always @(posedge clkx16 or negedge rstn)
   begin
     if(~rstn) 
     begin
       dout  <= 0;
       dout1 <= 0;
       dout2 <= 0;
       dout3 <= 0;
     end   
     else
     begin
       dout  <= data_in[i];   
       dout1 <= data_in[i+16];  
       dout2 <= data_in[i+32];
       dout3 <= data_in[i+48];
     end
   end

`endif

//////////////////////////////////////////////////////////////

   assign HS_CLK_RX_P   =  clkx8;
   assign HS_CLK_RX_N   = !clkx8;
   assign HS_DATA3_RX_P =  dout3;
   assign HS_DATA3_RX_N = !dout3;
   assign HS_DATA2_RX_P =  dout2;
   assign HS_DATA2_RX_N = !dout2;
   assign HS_DATA1_RX_P =  dout1;
   assign HS_DATA1_RX_N = !dout1;
   assign HS_DATA0_RX_P =  dout ;
   assign HS_DATA0_RX_N = !dout ;


`ifdef DPHY_MIPI_IO

    DPHY_RX_TOP u_DPHY_RX_TOP(
                .reset_n        (rstn)          ,  
                .MIPI_CLK_P     (HS_CLK_RX_P)   ,  
                .MIPI_CLK_N     (HS_CLK_RX_N)   ,  

     `ifdef CROSS_FIFO
                .clk_byte       (clk_byte)      ,  
     `endif
                .clk_byte_out   (clk_byte_out)  ,  
                .lp_clk_out     ()    ,
                .lp_clk_in      (2'b11)     ,   
                .lp_clk_dir     (1'b0)    ,
     `ifdef MIPI_LANE3
                .MIPI_LANE3_P   (HS_DATA3_RX_P) ,  
                .MIPI_LANE3_N   (HS_DATA3_RX_N) ,  
                .data_out3      (data_out3)     , 
                .lp_data3_out   ()  , 
                .lp_data3_in    (2'b11)   ,   
                .lp_data3_dir   (1'b0)  ,  
     `endif
     `ifdef MIPI_LANE2
                .MIPI_LANE2_P   (HS_DATA2_RX_P) ,  
                .MIPI_LANE2_N   (HS_DATA2_RX_N) ,  
                .data_out2      (data_out2)     ,  
                .lp_data2_out   ()  ,
                .lp_data2_in    (2'b11)   ,   
                .lp_data2_dir   (1'b0)  ,  
     `endif
     `ifdef MIPI_LANE1
                .MIPI_LANE1_P   (HS_DATA1_RX_P) ,  
                .MIPI_LANE1_N   (HS_DATA1_RX_N) ,  
                .data_out1      (data_out1)     ,  
                .lp_data1_out   ()  ,
                .lp_data1_in    (2'b11)   ,   
                .lp_data1_dir   (1'b0)  ,   
     `endif
     `ifdef MIPI_LANE0
                .MIPI_LANE0_P   (HS_DATA0_RX_P) ,  
                .MIPI_LANE0_N   (HS_DATA0_RX_N) ,  
                .data_out0      (data_out0)     ,  
                .lp_data0_out   ()  ,
                .lp_data0_in    (2'b11)   ,   
                .lp_data0_dir   (1'b0)  ,  
     `endif
                .hs_en          (hactive_flag)  ,
                .term_en        (1'b1 )         ,              
                .ready          (ready)                              
      );

`else

    DPHY_RX_TOP u_DPHY_RX_TOP(
                .reset_n        (rstn)          ,  
                .HS_CLK_P       (HS_CLK_RX_P)   ,  
                .HS_CLK_N       (HS_CLK_RX_N)   ,  

     `ifdef CROSS_FIFO
                .clk_byte       (clk_byte)      ,  
     `endif
                .clk_byte_out   (clk_byte_out)  ,  
     `ifdef HS_DATA3
                .HS_DATA3_P     (HS_DATA3_RX_P) ,  
                .HS_DATA3_N     (HS_DATA3_RX_N) ,  
                .data_out3      (data_out3)     ,  
     `endif
     `ifdef HS_DATA2
                .HS_DATA2_P     (HS_DATA2_RX_P) ,  
                .HS_DATA2_N     (HS_DATA2_RX_N) ,  
                .data_out2      (data_out2)     ,  
     `endif
     `ifdef HS_DATA1
                .HS_DATA1_P     (HS_DATA1_RX_P) ,  
                .HS_DATA1_N     (HS_DATA1_RX_N) ,  
                .data_out1      (data_out1)     ,  
     `endif
     `ifdef HS_DATA0
                .HS_DATA0_P     (HS_DATA0_RX_P) ,  
                .HS_DATA0_N     (HS_DATA0_RX_N) ,  
                .data_out0      (data_out0)     ,  
     `endif
     `ifdef LP_CLK
                .LP_CLK         (LP_CLK)        ,  
                .lp_clk_out     ()              ,  
                .lp_clk_in      (2'b11)         ,  
                .lp_clk_dir     (1'b0)          ,  
     `endif
     `ifdef LP_DATA3
                .LP_DATA3       (LP3)           ,  
                .lp_data3_out   ()              ,   
                .lp_data3_in    (2'b11)         ,  
                .lp_data3_dir   (1'b0)          ,  
     `endif
     `ifdef LP_DATA2
                .LP_DATA2       (LP2)           ,  
                .lp_data2_out   ()              ,  
                .lp_data2_in    (2'b11)         ,  
                .lp_data2_dir   (1'b0)          ,  
     `endif
     `ifdef LP_DATA1
                .LP_DATA1       (LP1)           ,  
                .lp_data1_out   ()              ,  
                .lp_data1_in    (2'b11)         ,  
                .lp_data1_dir   (1'b0)          ,  
     `endif
     `ifdef LP_DATA0
                .LP_DATA0       (LP0)           ,  
                .lp_data0_out   ()              ,  
                .lp_data0_in    (2'b11)         ,  
                .lp_data0_dir   (1'b0)          ,  
     `endif

                .hs_en          (hactive_flag)  ,
                .term_en        (1'b1   )       , 
                .ready          (ready)                              
      );

`endif


    
                
endmodule                                  
