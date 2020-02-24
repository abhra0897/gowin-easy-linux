// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2018 Shandong Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] DPHY_RX_TOP.v
//   \ \  / /\ \  / /    [Description ] TOP Verilog file for the DPHY RX TOP design
//    \ \/ /  \ \/ /     [Timestamp   ] Tue Dec 04 15:30:00 2018
//     \  /    \  /      [version     ] 2.0
//      \/      \/
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Ver: | Author |Mod. Date |Changes Made:
// V2.0 | XXXXXX |04/12/18  |Initial version
// ===========Oooo==========================================Oooo========

`include "dphy_define.v"

`ifndef DPHY_MIPI_IO // Generate DPHY without MIPI IO


 `ifdef GEN_MIPI_RX_8     //Generate MIPI 1:8 Mode
module `module_name_rx(
          input        reset_n          ,   //Resets the Design
          input        HS_CLK_P         ,   //HS (High Speed) Clock
          input        HS_CLK_N         ,   //HS (High Speed) Clock

     `ifdef CROSS_FIFO
          input        clk_byte         ,   //Byte Clock Input
     `endif
          output       clk_byte_out     ,   //Byte Clock
     `ifdef HS_DATA3
          input        HS_DATA3_P       ,   //HS (High Speed) Data Lane 3
          input        HS_DATA3_N       ,   //HS (High Speed) Data Lane 3
          output [7:0] data_out3        ,   //HS (High Speed) Byte Data, Lane 3
       `ifdef BEFORE_LANE_3
	        output [7:0] data_bf_lane3    ,
       `endif
     `endif
     `ifdef HS_DATA2
          input        HS_DATA2_P       ,   //HS (High Speed) Data Lane 2
          input        HS_DATA2_N       ,   //HS (High Speed) Data Lane 2
          output [7:0] data_out2        ,   //HS (High Speed) Byte Data, Lane 2
       `ifdef BEFORE_LANE_2
	        output [7:0] data_bf_lane2    ,
       `endif
     `endif
     `ifdef HS_DATA1
          input        HS_DATA1_P       ,   //HS (High Speed) Data Lane 1
          input        HS_DATA1_N       ,   //HS (High Speed) Data Lane 1
          output [7:0] data_out1        ,   //HS (High Speed) Byte Data, Lane 1
       `ifdef BEFORE_LANE_1
	        output [7:0] data_bf_lane1    ,
       `endif
     `endif
     `ifdef HS_DATA0
          input        HS_DATA0_P       ,   //HS (High Speed) Data Lane 0
          input        HS_DATA0_N       ,   //HS (High Speed) Data Lane 0
          output [7:0] data_out0        ,   //HS (High Speed) Byte Data, Lane 0
       `ifdef BEFORE_LANE_0
	        output [7:0] data_bf_lane0    ,
       `endif
     `endif
     `ifdef LP_CLK
          inout  [1:0] LP_CLK           ,   //LP (Low Power) External Interface Signals for Clock Lane
          output [1:0] lp_clk_out       ,   //LP (Low Power) Data Receiving Signals for Clock Lane
          input  [1:0] lp_clk_in        ,   //LP (Low Power) Data Transmitting Signals for Clock Lane
          input        lp_clk_dir       ,   //LP (Low Power) Data Receive/Transmit Control for Clock Lane
     `endif
     `ifdef LP_DATA3
          inout  [1:0] LP_DATA3         ,   //LP (Low Power) External Interface Signals for Data Lane 3
          output [1:0] lp_data3_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 3
          input  [1:0] lp_data3_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 3
          input        lp_data3_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 3
     `endif
     `ifdef LP_DATA2
          inout  [1:0] LP_DATA2         ,   //LP (Low Power) External Interface Signals for Data Lane 2
          output [1:0] lp_data2_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 2
          input  [1:0] lp_data2_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 2
          input        lp_data2_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 2
     `endif
     `ifdef LP_DATA1
          inout  [1:0] LP_DATA1         ,   //LP (Low Power) External Interface Signals for Data Lane 1
          output [1:0] lp_data1_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 1
          input  [1:0] lp_data1_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 1
          input        lp_data1_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 1
     `endif
     `ifdef LP_DATA0
          inout  [1:0] LP_DATA0         ,   //LP (Low Power) External Interface Signals for Data Lane 0
          output [1:0] lp_data0_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 0
          input  [1:0] lp_data0_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 0
          input        lp_data0_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 0
     `endif
          input  hs_en                  ,   //HS (High Speed) Enable
          input  term_en                ,   //Termination Enable
          output ready                      //Alignment Synchronization Status
      );

 `getname(DPHY_RX,`module_name_rx) DPHY_RX_INST(
                .reset_n        (reset_n)       ,  
                .HS_CLK_P       (HS_CLK_P)      ,  
                .HS_CLK_N       (HS_CLK_N)      ,  

     `ifdef CROSS_FIFO
                .clk_byte       (clk_byte)      ,  
     `endif
                .clk_byte_out   (clk_byte_out)  ,  
     `ifdef HS_DATA3
                .HS_DATA3_P     (HS_DATA3_P)    ,  
                .HS_DATA3_N     (HS_DATA3_N)    ,  
                .data_out3      (data_out3)     ,  
     `endif
     `ifdef HS_DATA2
                .HS_DATA2_P     (HS_DATA2_P)    ,  
                .HS_DATA2_N     (HS_DATA2_N)    ,  
                .data_out2      (data_out2)     ,  
     `endif
     `ifdef HS_DATA1
                .HS_DATA1_P     (HS_DATA1_P)    ,  
                .HS_DATA1_N     (HS_DATA1_N)    ,  
                .data_out1      (data_out1)     ,  
     `endif
     `ifdef HS_DATA0
                .HS_DATA0_P     (HS_DATA0_P)    ,  
                .HS_DATA0_N     (HS_DATA0_N)    ,  
                .data_out0      (data_out0)     ,  
     `endif
     `ifdef LP_CLK
                .LP_CLK         (LP_CLK)        ,  
                .lp_clk_out     (lp_clk_out)    ,  
                .lp_clk_in      (lp_clk_in)     ,  
                .lp_clk_dir     (lp_clk_dir)    ,  
     `endif
     `ifdef LP_DATA3
                .LP_DATA3       (LP_DATA3)      ,  
                .lp_data3_out   (lp_data3_out)  ,  
                .lp_data3_in    (lp_data3_in)   ,  
                .lp_data3_dir   (lp_data3_dir)  ,  
     `endif
     `ifdef LP_DATA2
                .LP_DATA2       (LP_DATA2)      ,  
                .lp_data2_out   (lp_data2_out)  ,  
                .lp_data2_in    (lp_data2_in)   ,  
                .lp_data2_dir   (lp_data2_dir)  ,  
     `endif
     `ifdef LP_DATA1
                .LP_DATA1       (LP_DATA1)      ,  
                .lp_data1_out   (lp_data1_out)  ,  
                .lp_data1_in    (lp_data1_in)   ,  
                .lp_data1_dir   (lp_data1_dir)  ,  
     `endif
     `ifdef LP_DATA0
                .LP_DATA0       (LP_DATA0)      ,  
                .lp_data0_out   (lp_data0_out)  ,  
                .lp_data0_in    (lp_data0_in)   ,  
                .lp_data0_dir   (lp_data0_dir)  ,  
     `endif
     `ifdef HS_DATA3
        `ifdef BEFORE_LANE_3
	            .data_bf_lane3  (data_bf_lane3   ),
        `endif
     `endif
     `ifdef HS_DATA2
        `ifdef BEFORE_LANE_2
	           .data_bf_lane2  (data_bf_lane2    ),
        `endif
     `endif
     `ifdef HS_DATA1
        `ifdef BEFORE_LANE_1
	           .data_bf_lane1  (data_bf_lane1    ),
        `endif
     `endif
     `ifdef HS_DATA0
        `ifdef BEFORE_LANE_0
	          .data_bf_lane0  (data_bf_lane0     ),
        `endif
     `endif
                .hs_en          (hs_en)         ,  
                .term_en        (term_en)       , 
                .ready          (ready)                              
      );

  
endmodule

 `endif


 `ifdef GEN_MIPI_RX_16     //Generate MIPI RX 1:16 Mode

module `module_name_rx(
          input        reset_n          ,   //Resets the Design
          input        HS_CLK_P         ,   //HS (High Speed) Clock
          input        HS_CLK_N         ,   //HS (High Speed) Clock

     `ifdef CROSS_FIFO
          input        clk_byte         ,   //Byte Clock Input
     `endif
          output       clk_byte_out     ,   //Byte Clock
     `ifdef HS_DATA3
          input        HS_DATA3_P       ,   //HS (High Speed) Data Lane 3
          input        HS_DATA3_N       ,   //HS (High Speed) Data Lane 3
          output [15:0] data_out3       ,   //HS (High Speed) Byte Data, Lane 3
       `ifdef BEFORE_LANE_3
	        output [15:0] data_bf_lane3   ,
       `endif
     `endif
     `ifdef HS_DATA2
          input        HS_DATA2_P       ,   //HS (High Speed) Data Lane 2
          input        HS_DATA2_N       ,   //HS (High Speed) Data Lane 2
          output [15:0] data_out2       ,   //HS (High Speed) Byte Data, Lane 2
       `ifdef BEFORE_LANE_2
	        output [15:0] data_bf_lane2   ,
       `endif
     `endif
     `ifdef HS_DATA1
          input        HS_DATA1_P       ,   //HS (High Speed) Data Lane 1
          input        HS_DATA1_N       ,   //HS (High Speed) Data Lane 1
          output [15:0] data_out1       ,   //HS (High Speed) Byte Data, Lane 1
       `ifdef BEFORE_LANE_1
	        output [15:0] data_bf_lane1   ,
       `endif
     `endif
     `ifdef HS_DATA0
          input        HS_DATA0_P       ,   //HS (High Speed) Data Lane 0
          input        HS_DATA0_N       ,   //HS (High Speed) Data Lane 0
          output [15:0] data_out0       ,   //HS (High Speed) Byte Data, Lane 0
       `ifdef BEFORE_LANE_0
	        output [15:0] data_bf_lane0   ,
       `endif
     `endif
     `ifdef LP_CLK
          inout  [1:0] LP_CLK           ,   //LP (Low Power) External Interface Signals for Clock Lane
          output [1:0] lp_clk_out       ,   //LP (Low Power) Data Receiving Signals for Clock Lane
          input  [1:0] lp_clk_in        ,   //LP (Low Power) Data Transmitting Signals for Clock Lane
          input        lp_clk_dir       ,   //LP (Low Power) Data Receive/Transmit Control for Clock Lane
     `endif
     `ifdef LP_DATA3
          inout  [1:0] LP_DATA3         ,   //LP (Low Power) External Interface Signals for Data Lane 3
          output [1:0] lp_data3_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 3
          input  [1:0] lp_data3_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 3
          input        lp_data3_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 3
     `endif
     `ifdef LP_DATA2
          inout  [1:0] LP_DATA2         ,   //LP (Low Power) External Interface Signals for Data Lane 2
          output [1:0] lp_data2_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 2
          input  [1:0] lp_data2_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 2
          input        lp_data2_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 2
     `endif
     `ifdef LP_DATA1
          inout  [1:0] LP_DATA1         ,   //LP (Low Power) External Interface Signals for Data Lane 1
          output [1:0] lp_data1_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 1
          input  [1:0] lp_data1_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 1
          input        lp_data1_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 1
     `endif
     `ifdef LP_DATA0
          inout  [1:0] LP_DATA0         ,   //LP (Low Power) External Interface Signals for Data Lane 0
          output [1:0] lp_data0_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 0
          input  [1:0] lp_data0_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 0
          input        lp_data0_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 0
     `endif

          input  hs_en                  ,   //HS (High Speed) Enable
          input  term_en                ,   //Termination Enable
          output ready                      //Alignment Synchronization Status
      );

 `getname(DPHY_RX,`module_name_rx) DPHY_RX_INST(
                .reset_n        (reset_n)       ,  
                .HS_CLK_P       (HS_CLK_P)      ,  
                .HS_CLK_N       (HS_CLK_N)      ,  

     `ifdef CROSS_FIFO
                .clk_byte       (clk_byte)      ,  
     `endif
                .clk_byte_out   (clk_byte_out)  ,  
     `ifdef HS_DATA3
                .HS_DATA3_P     (HS_DATA3_P)    ,  
                .HS_DATA3_N     (HS_DATA3_N)    ,  
                .data_out3      (data_out3)     ,  
     `endif
     `ifdef HS_DATA2
                .HS_DATA2_P     (HS_DATA2_P)    ,  
                .HS_DATA2_N     (HS_DATA2_N)    ,  
                .data_out2      (data_out2)     ,  
     `endif
     `ifdef HS_DATA1
                .HS_DATA1_P     (HS_DATA1_P)    ,  
                .HS_DATA1_N     (HS_DATA1_N)    ,  
                .data_out1      (data_out1)     ,  
     `endif
     `ifdef HS_DATA0
                .HS_DATA0_P     (HS_DATA0_P)    ,  
                .HS_DATA0_N     (HS_DATA0_N)    ,  
                .data_out0      (data_out0)     ,  
     `endif
     `ifdef LP_CLK
                .LP_CLK         (LP_CLK)        ,  
                .lp_clk_out     (lp_clk_out)    ,  
                .lp_clk_in      (lp_clk_in)     ,  
                .lp_clk_dir     (lp_clk_dir)    ,  
     `endif
     `ifdef LP_DATA3
                .LP_DATA3       (LP_DATA3)      ,  
                .lp_data3_out   (lp_data3_out)  ,  
                .lp_data3_in    (lp_data3_in)   ,  
                .lp_data3_dir   (lp_data3_dir)  ,  
     `endif
     `ifdef LP_DATA2
                .LP_DATA2       (LP_DATA2)      ,  
                .lp_data2_out   (lp_data2_out)  ,  
                .lp_data2_in    (lp_data2_in)   ,  
                .lp_data2_dir   (lp_data2_dir)  ,  
     `endif
     `ifdef LP_DATA1
                .LP_DATA1       (LP_DATA1)      ,  
                .lp_data1_out   (lp_data1_out)  ,  
                .lp_data1_in    (lp_data1_in)   ,  
                .lp_data1_dir   (lp_data1_dir)  ,  
     `endif
     `ifdef LP_DATA0
                .LP_DATA0       (LP_DATA0)      ,  
                .lp_data0_out   (lp_data0_out)  ,  
                .lp_data0_in    (lp_data0_in)   ,  
                .lp_data0_dir   (lp_data0_dir)  ,  
     `endif
     `ifdef HS_DATA3
        `ifdef BEFORE_LANE_3
	            .data_bf_lane3  (data_bf_lane3   ),
        `endif
     `endif
     `ifdef HS_DATA2
        `ifdef BEFORE_LANE_2
	           .data_bf_lane2  (data_bf_lane2    ),
        `endif
     `endif
     `ifdef HS_DATA1
        `ifdef BEFORE_LANE_1
	           .data_bf_lane1  (data_bf_lane1    ),
        `endif
     `endif
     `ifdef HS_DATA0
        `ifdef BEFORE_LANE_0
	          .data_bf_lane0  (data_bf_lane0     ),
        `endif
     `endif
                .hs_en          (hs_en)         ,  
                .term_en        (term_en)       , 
                .ready          (ready)                              
      );

  
endmodule

 `endif


`endif  // Generate DPHY without MIPI IO


/////////////////////////////////////////////////////////////////////////////


`ifdef DPHY_MIPI_IO // Generate DPHY with MIPI IO

 `ifdef GEN_MIPI_RX_8     //Generate MIPI 1:8 Mode

module `module_name_rx(
          input         reset_n          ,   //Resets the Design
          inout         MIPI_CLK_P       ,   //HS (High Speed) Clock
          inout         MIPI_CLK_N       ,   //HS (High Speed) Clock

     `ifdef CROSS_FIFO
          input         clk_byte         ,   //Byte Clock Input
     `endif
          output        clk_byte_out     ,   //Byte Clock
          output [1:0]  lp_clk_out       ,   //LP (Low Power) Data Receiving Signals for Clock Lane
          input  [1:0]  lp_clk_in        ,   //LP (Low Power) Data Transmitting Signals for Clock Lane
          input         lp_clk_dir       ,   //LP (Low Power) Data Receive/Transmit Control for Clock Lane
     `ifdef MIPI_LANE3
          inout         MIPI_LANE3_P     ,   //HS (High Speed) Data Lane 3
          inout         MIPI_LANE3_N     ,   //HS (High Speed) Data Lane 3
          output [7:0]  data_out3        ,   //HS (High Speed) Byte Data, Lane 3
          output [1:0]  lp_data3_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 3
          input  [1:0]  lp_data3_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 3
          input         lp_data3_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 3
      `ifdef BEFORE_LANE_3
	        output [7:0]  data_bf_lane3    ,
       `endif
     `endif
     `ifdef MIPI_LANE2
          inout         MIPI_LANE2_P     ,   //HS (High Speed) Data Lane 2
          inout         MIPI_LANE2_N     ,   //HS (High Speed) Data Lane 2
          output [7:0]  data_out2        ,   //HS (High Speed) Byte Data, Lane 
          output [1:0]  lp_data2_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 2
          input  [1:0]  lp_data2_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 2
          input         lp_data2_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 2
       `ifdef BEFORE_LANE_2
	        output [7:0]  data_bf_lane2    ,
       `endif
     `endif
     `ifdef MIPI_LANE1
          inout         MIPI_LANE1_P     ,   //HS (High Speed) Data Lane 1
          inout         MIPI_LANE1_N     ,   //HS (High Speed) Data Lane 1
          output [7:0]  data_out1        ,   //HS (High Speed) Byte Data, Lane 1
          output [1:0]  lp_data1_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 1
          input  [1:0]  lp_data1_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 1
          input         lp_data1_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 1
       `ifdef BEFORE_LANE_1
	        output [7:0]  data_bf_lane1    ,
       `endif
     `endif
     `ifdef MIPI_LANE0
          inout         MIPI_LANE0_P     ,   //HS (High Speed) Data Lane 0
          inout         MIPI_LANE0_N     ,   //HS (High Speed) Data Lane 0
          output [7:0]  data_out0        ,   //HS (High Speed) Byte Data, Lane 0
          output [1:0]  lp_data0_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 0
          input  [1:0]  lp_data0_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 0
          input         lp_data0_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 0
       `ifdef BEFORE_LANE_0
          output [7:0]  data_bf_lane0    ,
       `endif
     `endif
          input  hs_en                   ,   //HS (High Speed) Enable
          input  term_en                 ,
          output ready                      //Alignment Synchronization Status
      );
// `sub_module  DPHY_RX_INST(

//`define getname(tmodule_name) \DPHY\_RX/tmodule_name 
 `getname(DPHY_RX,`module_name_rx) DPHY_RX_INST(
                .reset_n        (reset_n)       ,  
                .MIPI_CLK_P     (MIPI_CLK_P)    ,  
                .MIPI_CLK_N     (MIPI_CLK_N)    ,  

     `ifdef CROSS_FIFO
                .clk_byte       (clk_byte)      ,  
     `endif
                .clk_byte_out   (clk_byte_out)  ,  
                .lp_clk_out     (lp_clk_out)    ,
                .lp_clk_in      (lp_clk_in)     ,   
                .lp_clk_dir     (lp_clk_dir)    ,
     `ifdef MIPI_LANE3
                .MIPI_LANE3_P   (MIPI_LANE3_P)  ,  
                .MIPI_LANE3_N   (MIPI_LANE3_N)  ,  
                .data_out3      (data_out3)     , 
                .lp_data3_out   (lp_data3_out)  , 
                .lp_data3_in    (lp_data3_in)   ,   
                .lp_data3_dir   (lp_data3_dir)  ,  
     `endif
     `ifdef MIPI_LANE2
                .MIPI_LANE2_P   (MIPI_LANE2_P)  ,  
                .MIPI_LANE2_N   (MIPI_LANE2_N)  ,  
                .data_out2      (data_out2)     ,  
                .lp_data2_out   (lp_data2_out)  , 
                .lp_data2_in    (lp_data2_in)   ,   
                .lp_data2_dir   (lp_data2_dir)  , 
     `endif
     `ifdef MIPI_LANE1
                .MIPI_LANE1_P   (MIPI_LANE1_P)  ,  
                .MIPI_LANE1_N   (MIPI_LANE1_N)  ,  
                .data_out1      (data_out1)     ,  
                .lp_data1_out   (lp_data1_out)  , 
                .lp_data1_in    (lp_data1_in)   ,   
                .lp_data1_dir   (lp_data1_dir)  ,  
     `endif
     `ifdef MIPI_LANE0
                .MIPI_LANE0_P   (MIPI_LANE0_P)  ,  
                .MIPI_LANE0_N   (MIPI_LANE0_N)  ,  
                .data_out0      (data_out0)     ,  
                .lp_data0_out   (lp_data0_out)  , 
                .lp_data0_in    (lp_data0_in)   ,   
                .lp_data0_dir   (lp_data0_dir)  , 
     `endif
     `ifdef MIPI_LANE3
        `ifdef BEFORE_LANE_3
	            .data_bf_lane3    (data_bf_lane3) ,
        `endif
     `endif
     `ifdef MIPI_LANE2
        `ifdef BEFORE_LANE_2
	           .data_bf_lane2     (data_bf_lane2) ,
        `endif
     `endif
     `ifdef MIPI_LANE1
        `ifdef BEFORE_LANE_1
	           .data_bf_lane1     (data_bf_lane1) ,
        `endif
     `endif
     `ifdef MIPI_LANE0
        `ifdef BEFORE_LANE_0
	          .data_bf_lane0      (data_bf_lane0) ,
        `endif
     `endif
                .hs_en          (hs_en)         , 
                .term_en        (term_en)       ,  
                .ready          (ready)                              
      );

  
endmodule

 `endif


 `ifdef GEN_MIPI_RX_16     //Generate MIPI RX 1:16 Mode

module `module_name_rx(
          input         reset_n          ,   //Resets the Design
          inout         MIPI_CLK_P       ,   //HS (High Speed) Clock
          inout         MIPI_CLK_N       ,   //HS (High Speed) Clock

     `ifdef CROSS_FIFO
          input         clk_byte         ,   //Byte Clock Input
     `endif 
          output        clk_byte_out     ,   //Byte Clock
          output [1:0]  lp_clk_out       ,   //LP (Low Power) Data Receiving Signals for Clock Lane
          input  [1:0]  lp_clk_in        ,   //LP (Low Power) Data Transmitting Signals for Clock Lane
          input         lp_clk_dir       ,   //LP (Low Power) Data Receive/Transmit Control for Clock Lane
     `ifdef MIPI_LANE3
          inout         MIPI_LANE3_P     ,   //HS (High Speed) Data Lane 3
          inout         MIPI_LANE3_N     ,   //HS (High Speed) Data Lane 3
          output [15:0] data_out3        ,   //HS (High Speed) Byte Data, Lane 3
          output [1:0]  lp_data3_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 3
          input  [1:0]  lp_data3_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 3
          input         lp_data3_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 3
      `ifdef BEFORE_LANE_3
	        output [15:0] data_bf_lane3    ,
       `endif
     `endif
     `ifdef MIPI_LANE2
          inout         MIPI_LANE2_P     ,   //HS (High Speed) Data Lane 2
          inout         MIPI_LANE2_N     ,   //HS (High Speed) Data Lane 2
          output [15:0] data_out2        ,   //HS (High Speed) Byte Data, Lane 
          output [1:0]  lp_data2_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 2
          input  [1:0]  lp_data2_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 2
          input         lp_data2_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 2
       `ifdef BEFORE_LANE_2
	        output [15:0] data_bf_lane2    ,
       `endif
     `endif
     `ifdef MIPI_LANE1
          inout         MIPI_LANE1_P     ,   //HS (High Speed) Data Lane 1
          inout         MIPI_LANE1_N     ,   //HS (High Speed) Data Lane 1
          output [15:0] data_out1        ,   //HS (High Speed) Byte Data, Lane 1
          output [1:0]  lp_data1_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 1
          input  [1:0]  lp_data1_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 1
          input         lp_data1_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 1
       `ifdef BEFORE_LANE_1
	        output [15:0] data_bf_lane1    ,
       `endif
     `endif
     `ifdef MIPI_LANE0
          inout         MIPI_LANE0_P     ,   //HS (High Speed) Data Lane 0
          inout         MIPI_LANE0_N     ,   //HS (High Speed) Data Lane 0
          output [15:0] data_out0        ,   //HS (High Speed) Byte Data, Lane 0
          output [1:0]  lp_data0_out     ,   //LP (Low Power) Data Receiving Signals for Data Lane 0
          input  [1:0]  lp_data0_in      ,   //LP (Low Power) Data Transmitting Signals for Data Lane 0
          input         lp_data0_dir     ,   //LP (Low Power) Data Receive/Transmit Control for Data Lane 0
       `ifdef BEFORE_LANE_0
          output [15:0] data_bf_lane0    ,
       `endif
     `endif
          input  hs_en                   ,   //HS (High Speed) Enable
          input  term_en                 ,
          output ready                      //Alignment Synchronization Status
      );

 `getname(DPHY_RX,`module_name_rx) DPHY_RX_INST(
                .reset_n        (reset_n)       ,  
                .MIPI_CLK_P     (MIPI_CLK_P)    ,  
                .MIPI_CLK_N     (MIPI_CLK_N)    ,  

     `ifdef CROSS_FIFO
                .clk_byte       (clk_byte)      ,  
     `endif
                .clk_byte_out   (clk_byte_out)  ,  
                .lp_clk_out     (lp_clk_out)    ,
                .lp_clk_in      (lp_clk_in)     ,   
                .lp_clk_dir     (lp_clk_dir)    ,
     `ifdef MIPI_LANE3
                .MIPI_LANE3_P   (MIPI_LANE3_P)  ,  
                .MIPI_LANE3_N   (MIPI_LANE3_N)  ,  
                .data_out3      (data_out3)     , 
                .lp_data3_out   (lp_data3_out)  , 
                .lp_data3_in    (lp_data3_in)   ,   
                .lp_data3_dir   (lp_data3_dir)  ,  
     `endif
     `ifdef MIPI_LANE2
                .MIPI_LANE2_P   (MIPI_LANE2_P)  ,  
                .MIPI_LANE2_N   (MIPI_LANE2_N)  ,  
                .data_out2      (data_out2)     ,  
                .lp_data2_out   (lp_data2_out)  ,
                .lp_data2_in    (lp_data2_in)   ,   
                .lp_data2_dir   (lp_data2_dir)  ,  
     `endif
     `ifdef MIPI_LANE1
                .MIPI_LANE1_P   (MIPI_LANE1_P)  ,  
                .MIPI_LANE1_N   (MIPI_LANE1_N)  ,  
                .data_out1      (data_out1)     ,  
                .lp_data1_out   (lp_data1_out)  ,
                .lp_data1_in    (lp_data1_in)   ,   
                .lp_data1_dir   (lp_data1_dir)  ,   
     `endif
     `ifdef MIPI_LANE0
                .MIPI_LANE0_P   (MIPI_LANE0_P)  ,  
                .MIPI_LANE0_N   (MIPI_LANE0_N)  ,  
                .data_out0      (data_out0)     ,  
                .lp_data0_out   (lp_data0_out)  ,
                .lp_data0_in    (lp_data0_in)   ,   
                .lp_data0_dir   (lp_data0_dir)  ,  
     `endif
     `ifdef MIPI_LANE3
        `ifdef BEFORE_LANE_3
	            .data_bf_lane3    (data_bf_lane3) ,
        `endif
     `endif
     `ifdef MIPI_LANE2
        `ifdef BEFORE_LANE_2
	           .data_bf_lane2     (data_bf_lane2) ,
        `endif
     `endif
     `ifdef MIPI_LANE1
        `ifdef BEFORE_LANE_1
	           .data_bf_lane1     (data_bf_lane1) ,
        `endif
     `endif
     `ifdef MIPI_LANE0
        `ifdef BEFORE_LANE_0
	          .data_bf_lane0      (data_bf_lane0) ,
        `endif
     `endif
                .hs_en          (hs_en)         ,  
                .term_en        (term_en)       , 
                .ready          (ready)                              
      );

  
endmodule

 `endif


`endif // Generate DPHY with MIPI IO
