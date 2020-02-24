// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2018 Shandong Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] DPHY_TX_TOP.v
//   \ \  / /\ \  / /    [Description ] TOP Verilog file for the DPHY TX TOP design
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


 `ifdef GEN_MIPI_TX_8     //Generate MIPI TX 1:8 Mode

module `module_name_tx(
          input         reset_n          ,      //Resets the Design, active low

          output        HS_CLK_P         ,      //HS (High Speed) Clock
          output        HS_CLK_N         ,      //HS (High Speed) Clock
     `ifdef INTERNAL_PLL
          input         clk_byte         ,      //Byte Clock
     `else
          input         clk_bit          ,      //HS Clock
          input         clk_bit_90       ,      //HS Clock + 90 deg phase shift
     `endif
     `ifdef HS_DATA3
          output        HS_DATA3_P       ,      //HS (High Speed) Data Lane 3
          output        HS_DATA3_N       ,      //HS (High Speed) Data Lane 3
          input [7:0]   data_in3         ,      //HS (High Speed) Byte Data, Lane 3
     `endif
     `ifdef HS_DATA2
          output        HS_DATA2_P       ,      //HS (High Speed) Data Lane 2
          output        HS_DATA2_N       ,      //HS (High Speed) Data Lane 2
          input [7:0]   data_in2         ,      //HS (High Speed) Byte Data, Lane 2
     `endif
     `ifdef HS_DATA1
          output        HS_DATA1_P       ,      //HS (High Speed) Data Lane 1
          output        HS_DATA1_N       ,      //HS (High Speed) Data Lane 1
          input [7:0]   data_in1         ,      //HS (High Speed) Byte Data, Lane 1
     `endif
     `ifdef HS_DATA0
          output        HS_DATA0_P       ,      //HS (High Speed) Data Lane 0
          output        HS_DATA0_N       ,      //HS (High Speed) Data Lane 0
          input [7:0]   data_in0         ,      //HS (High Speed) Byte Data, Lane 0
     `endif
     `ifdef LP_CLK
          inout   [1:0] LP_CLK           ,      //LP (Low Power) External Interface Signals for Clock Lane
          input   [1:0] lp_clk_out       ,      //LP (Low Power) Data Receiving Signals for Clock Lane
          output  [1:0] lp_clk_in        ,      //LP (Low Power) Data Transmitting Signals for Clock Lane
          input         lp_clk_dir       ,      //LP (Low Power) Data Receive/Transmit Control for Clock Lane
     `endif
     `ifdef LP_DATA3
          inout   [1:0] LP_DATA3         ,      //LP (Low Power) External Interface Signals for Data Lane 3
          input   [1:0] lp_data3_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 3
          output  [1:0] lp_data3_in      ,      //LP (Low Power) Data Transmitting Signals for Data Lane 3
          input         lp_data3_dir     ,      //LP (Low Power) Data Receive/Transmit Control for Data Lane 3
     `endif
     `ifdef LP_DATA2
          inout   [1:0] LP_DATA2         ,      //LP (Low Power) External Interface Signals for Data Lane 2
          input   [1:0] lp_data2_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 2
          output  [1:0] lp_data2_in      ,      //LP (Low Power) Data Transmitting Signals for Data Lane 2
          input         lp_data2_dir     ,      //LP (Low Power) Data Receive/Transmit Control for Data Lane 2
     `endif
     `ifdef LP_DATA1
          inout   [1:0] LP_DATA1         ,      //LP (Low Power) External Interface Signals for Data Lane 1
          input   [1:0] lp_data1_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 1
          output  [1:0] lp_data1_in      ,      //LP (Low Power) Data Transmitting Signals for Data Lane 1
          input         lp_data1_dir     ,      //LP (Low Power) Data Receive/Transmit Control for Data Lane 1
     `endif
     `ifdef LP_DATA0
          inout   [1:0] LP_DATA0         ,      //LP (Low Power) External Interface Signals for Data Lane 0
          input   [1:0] lp_data0_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 0
          output  [1:0] lp_data0_in      ,      //LP (Low Power) Data Transmitting Signals for Data Lane 0
          input         lp_data0_dir     ,      //LP (Low Power) Data Receive/Transmit Control for Data Lane 0
     `endif
          input         hs_clk_en        ,      //HS (High Speed) Clock Enable
          input         hs_data_en       ,      //HS (High Speed) Data Enable
          output        sclk
          );

`getname(DPHY_TX,`module_name_tx) DPHY_TX_INST(
                .reset_n        (reset_n)       ,   

                .HS_CLK_P       (HS_CLK_P)      ,   
                .HS_CLK_N       (HS_CLK_N)      ,   
     `ifdef INTERNAL_PLL
                .clk_byte       (clk_byte)      ,   
     `else
                .clk_bit        (clk_bit)       ,   
                .clk_bit_90     (clk_bit_90)    ,   
     `endif
     `ifdef HS_DATA3
                .HS_DATA3_P     (HS_DATA3_P)    ,   
                .HS_DATA3_N     (HS_DATA3_N)    ,   
                .data_in3       (data_in3)      ,   
     `endif
     `ifdef HS_DATA2
                .HS_DATA2_P     (HS_DATA2_P)    ,   
                .HS_DATA2_N     (HS_DATA2_N)    ,   
                .data_in2       (data_in2)      ,   
     `endif
     `ifdef HS_DATA1
                .HS_DATA1_P     (HS_DATA1_P)    ,   
                .HS_DATA1_N     (HS_DATA1_N)    ,   
                .data_in1       (data_in1)      ,   
     `endif
     `ifdef HS_DATA0
                .HS_DATA0_P     (HS_DATA0_P)    ,   
                .HS_DATA0_N     (HS_DATA0_N)    ,   
                .data_in0       (data_in0)      ,   
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
                .hs_clk_en      (hs_clk_en)     ,      
                .hs_data_en     (hs_data_en)    ,
                .sclk           (sclk)
          );

endmodule

  `endif


 `ifdef GEN_MIPI_TX_16     //Generate MIPI TX 1:16 Mode

module `module_name_tx(
          input         reset_n          ,      //Resets the Design, active low

          output        HS_CLK_P         ,      //HS (High Speed) Clock
          output        HS_CLK_N         ,      //HS (High Speed) Clock
     `ifdef INTERNAL_PLL
          input         clk_byte         ,      //Byte Clock
     `else
          input         clk_bit          ,      //HS Clock
          input         clk_bit_90       ,      //HS Clock + 90 deg phase shift
     `endif
     `ifdef HS_DATA3
          output        HS_DATA3_P       ,      //HS (High Speed) Data Lane 3
          output        HS_DATA3_N       ,      //HS (High Speed) Data Lane 3
          input [15:0]   data_in3         ,      //HS (High Speed) Byte Data, Lane 3
     `endif
     `ifdef HS_DATA2
          output        HS_DATA2_P       ,      //HS (High Speed) Data Lane 2
          output        HS_DATA2_N       ,      //HS (High Speed) Data Lane 2
          input [15:0]   data_in2         ,      //HS (High Speed) Byte Data, Lane 2
     `endif
     `ifdef HS_DATA1
          output        HS_DATA1_P       ,      //HS (High Speed) Data Lane 1
          output        HS_DATA1_N       ,      //HS (High Speed) Data Lane 1
          input [15:0]   data_in1         ,      //HS (High Speed) Byte Data, Lane 1
     `endif
     `ifdef HS_DATA0
          output        HS_DATA0_P       ,      //HS (High Speed) Data Lane 0
          output        HS_DATA0_N       ,      //HS (High Speed) Data Lane 0
          input [15:0]   data_in0         ,      //HS (High Speed) Byte Data, Lane 0
     `endif
     `ifdef LP_CLK
          inout   [1:0] LP_CLK           ,      //LP (Low Power) External Interface Signals for Clock Lane
          input   [1:0] lp_clk_out       ,      //LP (Low Power) Data Receiving Signals for Clock Lane
          output  [1:0] lp_clk_in        ,      //LP (Low Power) Data Transmitting Signals for Clock Lane
          input         lp_clk_dir       ,      //LP (Low Power) Data Receive/Transmit Control for Clock Lane
     `endif
     `ifdef LP_DATA3
          inout   [1:0] LP_DATA3         ,      //LP (Low Power) External Interface Signals for Data Lane 3
          input   [1:0] lp_data3_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 3
          output  [1:0] lp_data3_in      ,      //LP (Low Power) Data Transmitting Signals for Data Lane 3
          input         lp_data3_dir     ,      //LP (Low Power) Data Receive/Transmit Control for Data Lane 3
     `endif
     `ifdef LP_DATA2
          inout   [1:0] LP_DATA2         ,      //LP (Low Power) External Interface Signals for Data Lane 2
          input   [1:0] lp_data2_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 2
          output  [1:0] lp_data2_in      ,      //LP (Low Power) Data Transmitting Signals for Data Lane 2
          input         lp_data2_dir     ,      //LP (Low Power) Data Receive/Transmit Control for Data Lane 2
     `endif
     `ifdef LP_DATA1
          inout   [1:0] LP_DATA1         ,      //LP (Low Power) External Interface Signals for Data Lane 1
          input   [1:0] lp_data1_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 1
          output  [1:0] lp_data1_in      ,      //LP (Low Power) Data Transmitting Signals for Data Lane 1
          input         lp_data1_dir     ,      //LP (Low Power) Data Receive/Transmit Control for Data Lane 1
     `endif
     `ifdef LP_DATA0
          inout   [1:0] LP_DATA0         ,      //LP (Low Power) External Interface Signals for Data Lane 0
          input   [1:0] lp_data0_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 0
          output  [1:0] lp_data0_in      ,      //LP (Low Power) Data Transmitting Signals for Data Lane 0
          input         lp_data0_dir     ,      //LP (Low Power) Data Receive/Transmit Control for Data Lane 0
     `endif
          input         hs_clk_en        ,      //HS (High Speed) Clock Enable
          input         hs_data_en       ,      //HS (High Speed) Data Enable
          output        sclk
          );

`getname(DPHY_TX,`module_name_tx) DPHY_TX_INST(
                .reset_n        (reset_n)       ,   

                .HS_CLK_P       (HS_CLK_P)      ,   
                .HS_CLK_N       (HS_CLK_N)      ,   
     `ifdef INTERNAL_PLL
                .clk_byte       (clk_byte)      ,   
     `else
                .clk_bit        (clk_bit)       ,   
                .clk_bit_90     (clk_bit_90)    ,   
     `endif
     `ifdef HS_DATA3
                .HS_DATA3_P     (HS_DATA3_P)    ,   
                .HS_DATA3_N     (HS_DATA3_N)    ,   
                .data_in3       (data_in3)      ,   
     `endif
     `ifdef HS_DATA2
                .HS_DATA2_P     (HS_DATA2_P)    ,   
                .HS_DATA2_N     (HS_DATA2_N)    ,   
                .data_in2       (data_in2)      ,   
     `endif
     `ifdef HS_DATA1
                .HS_DATA1_P     (HS_DATA1_P)    ,   
                .HS_DATA1_N     (HS_DATA1_N)    ,   
                .data_in1       (data_in1)      ,   
     `endif
     `ifdef HS_DATA0
                .HS_DATA0_P     (HS_DATA0_P)    ,   
                .HS_DATA0_N     (HS_DATA0_N)    ,   
                .data_in0       (data_in0)      ,   
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
                .hs_clk_en      (hs_clk_en)     ,      
                .hs_data_en     (hs_data_en)    ,
                .sclk           (sclk)
          );

endmodule

  `endif


`endif  // Generate DPHY without MIPI IO


////////////////////////////////////////////////////////////////////////


`ifdef DPHY_MIPI_IO // Generate DPHY with MIPI IO


 `ifdef GEN_MIPI_TX_8     //Generate MIPI TX 1:8 Mode

module `module_name_tx(
          input         reset_n          ,      //Resets the Design, active low

          output        MIPI_CLK_P       ,      //HS (High Speed) Clock
          output        MIPI_CLK_N       ,      //HS (High Speed) Clock
     `ifdef INTERNAL_PLL
          input         clk_byte         ,      //Byte Clock
     `else
          input         clk_bit          ,      //HS Clock
          input         clk_bit_90       ,      //HS Clock + 90 deg phase shift
     `endif
          input  [1:0]  lp_clk_out       ,      //LP (Low Power) Data Receiving Signals for Clock Lane
     `ifdef MIPI_LANE3
          output        MIPI_LANE3_P     ,      //HS (High Speed) Data Lane 3
          output        MIPI_LANE3_N     ,      //HS (High Speed) Data Lane 3
          input  [7:0]  data_in3         ,      //HS (High Speed) Byte Data, Lane 3
          input  [1:0]  lp_data3_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 3
     `endif
     `ifdef MIPI_LANE2
          output        MIPI_LANE2_P     ,      //HS (High Speed) Data Lane 2
          output        MIPI_LANE2_N     ,      //HS (High Speed) Data Lane 2
          input  [7:0]  data_in2         ,      //HS (High Speed) Byte Data, Lane 2
          input  [1:0]  lp_data2_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 2

     `endif
     `ifdef MIPI_LANE1
          output        MIPI_LANE1_P     ,      //HS (High Speed) Data Lane 1
          output        MIPI_LANE1_N     ,      //HS (High Speed) Data Lane 1
          input  [7:0]  data_in1         ,      //HS (High Speed) Byte Data, Lane 1
          input  [1:0]  lp_data1_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 1

     `endif
     `ifdef MIPI_LANE0
          output        MIPI_LANE0_P     ,      //HS (High Speed) Data Lane 0
          output        MIPI_LANE0_N     ,      //HS (High Speed) Data Lane 0
          input  [7:0]  data_in0         ,      //HS (High Speed) Byte Data, Lane 0
          input  [1:0]  lp_data0_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 0
     `endif
          input         hs_clk_en        ,      //HS (High Speed) Clock Enable
          input         hs_data_en       ,      //HS (High Speed) Data Enable
          output        sclk
          );

`getname(DPHY_TX,`module_name_tx) DPHY_TX_INST(
                .reset_n        (reset_n)       ,   

                .MIPI_CLK_P     (MIPI_CLK_P)      ,   
                .MIPI_CLK_N     (MIPI_CLK_N)      ,   
     `ifdef INTERNAL_PLL
                .clk_byte       (clk_byte)      ,   
     `else
                .clk_bit        (clk_bit)       ,   
                .clk_bit_90     (clk_bit_90)    ,   
     `endif
                .lp_clk_out     (lp_clk_out)    , 
     `ifdef MIPI_LANE3
                .MIPI_LANE3_P   (MIPI_LANE3_P)  ,   
                .MIPI_LANE3_N   (MIPI_LANE3_N)  ,   
                .data_in3       (data_in3)      , 
                .lp_data3_out   (lp_data3_out)  ,    
     `endif
     `ifdef MIPI_LANE2
                .MIPI_LANE2_P   (MIPI_LANE2_P)  ,   
                .MIPI_LANE2_N   (MIPI_LANE2_N)  ,   
                .data_in2       (data_in2)      ,   
                .lp_data2_out   (lp_data2_out)  ,  
     `endif
     `ifdef MIPI_LANE1
                .MIPI_LANE1_P   (MIPI_LANE1_P)  ,   
                .MIPI_LANE1_N   (MIPI_LANE1_N)  ,   
                .data_in1       (data_in1)      ,  
                .lp_data1_out   (lp_data1_out)  ,   
     `endif
     `ifdef MIPI_LANE0
                .MIPI_LANE0_P   (MIPI_LANE0_P)  ,   
                .MIPI_LANE0_N   (MIPI_LANE0_N)  ,   
                .data_in0       (data_in0)      ,  
                .lp_data0_out   (lp_data0_out)  ,   
     `endif
                .hs_clk_en      (hs_clk_en)     ,      
                .hs_data_en     (hs_data_en)    ,
                .sclk           (sclk)       
          );

endmodule


  `endif

 `ifdef GEN_MIPI_TX_16     //Generate MIPI TX 1:16 Mode

module `module_name_tx(
          input         reset_n          ,      //Resets the Design, active low

          output        MIPI_CLK_P         ,      //HS (High Speed) Clock
          output        MIPI_CLK_N         ,      //HS (High Speed) Clock
     `ifdef INTERNAL_PLL
          input         clk_byte         ,      //Byte Clock
     `else
          input         clk_bit          ,      //HS Clock
          input         clk_bit_90       ,      //HS Clock + 90 deg phase shift
     `endif
          input  [1:0]  lp_clk_out       ,      //LP (Low Power) Data Receiving Signals for Clock Lane
     `ifdef MIPI_LANE3
          output        MIPI_LANE3_P     ,      //HS (High Speed) Data Lane 3
          output        MIPI_LANE3_N     ,      //HS (High Speed) Data Lane 3
          input  [15:0] data_in3         ,      //HS (High Speed) Byte Data, Lane 3
          input  [1:0]  lp_data3_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 3
     `endif
     `ifdef MIPI_LANE2
          output        MIPI_LANE2_P     ,      //HS (High Speed) Data Lane 2
          output        MIPI_LANE2_N     ,      //HS (High Speed) Data Lane 2
          input  [15:0] data_in2         ,      //HS (High Speed) Byte Data, Lane 2
          input  [1:0]  lp_data2_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 2

     `endif
     `ifdef MIPI_LANE1
          output        MIPI_LANE1_P     ,      //HS (High Speed) Data Lane 1
          output        MIPI_LANE1_N     ,      //HS (High Speed) Data Lane 1
          input  [15:0] data_in1         ,      //HS (High Speed) Byte Data, Lane 1
          input  [1:0]  lp_data1_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 1

     `endif
     `ifdef MIPI_LANE0
          output        MIPI_LANE0_P     ,      //HS (High Speed) Data Lane 0
          output        MIPI_LANE0_N     ,      //HS (High Speed) Data Lane 0
          input  [15:0] data_in0         ,      //HS (High Speed) Byte Data, Lane 0
          input  [1:0]  lp_data0_out     ,      //LP (Low Power) Data Receiving Signals for Data Lane 0
     `endif
          input         hs_clk_en        ,      //HS (High Speed) Clock Enable
          input         hs_data_en       ,      //HS (High Speed) Data Enable
          output        sclk
          );

`getname(DPHY_TX,`module_name_tx) DPHY_TX_INST(
                .reset_n        (reset_n)       ,   

                .MIPI_CLK_P     (MIPI_CLK_P)      ,   
                .MIPI_CLK_N     (MIPI_CLK_N)      ,   
     `ifdef INTERNAL_PLL
                .clk_byte       (clk_byte)      ,   
     `else
                .clk_bit        (clk_bit)       ,   
                .clk_bit_90     (clk_bit_90)    ,   
     `endif
                .lp_clk_out     (lp_clk_out)    , 
     `ifdef MIPI_LANE3
                .MIPI_LANE3_P   (MIPI_LANE3_P)  ,   
                .MIPI_LANE3_N   (MIPI_LANE3_N)  ,   
                .data_in3       (data_in3)      , 
                .lp_data3_out   (lp_data3_out)  ,    
     `endif
     `ifdef MIPI_LANE2
                .MIPI_LANE2_P   (MIPI_LANE2_P)  ,   
                .MIPI_LANE2_N   (MIPI_LANE2_N)  ,   
                .data_in2       (data_in2)      ,   
                .lp_data2_out   (lp_data2_out)  ,  
     `endif
     `ifdef MIPI_LANE1
                .MIPI_LANE1_P   (MIPI_LANE1_P)  ,   
                .MIPI_LANE1_N   (MIPI_LANE1_N)  ,   
                .data_in1       (data_in1)      ,  
                .lp_data1_out   (lp_data1_out)  ,   
     `endif
     `ifdef MIPI_LANE0
                .MIPI_LANE0_P   (MIPI_LANE0_P)  ,   
                .MIPI_LANE0_N   (MIPI_LANE0_N)  ,   
                .data_in0       (data_in0)      ,  
                .lp_data0_out   (lp_data0_out)  ,   
     `endif
                .hs_clk_en      (hs_clk_en)     ,      
                .hs_data_en     (hs_data_en)    ,
                .sclk           (sclk)
          );

endmodule

  `endif


`endif // Generate DPHY with MIPI IO
