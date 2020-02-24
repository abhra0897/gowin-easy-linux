// ===========Oooo==========================================Oooo================================
// =        Copyright (C) 2014-2019 ShanDong Gowin Semiconductor Technology Co.,Ltd.   
// =                                 All rights reserved.                         
// =============================================================================================
//           
//  __      __      __  
//  \ \    /  \    / /   [IP name     ] Gowin AHB Bus Arbiter
//   \ \  / /\ \  / /    [Authors     ] Gowin Semiconductor Technology Co.,Ltd.
//    \ \/ /  \ \/ /     [Description ] TOP Verilog file for Gowin AHB Bus Arbiter design
//     \  /    \  /      [Version     ] 1.0
//      \/      \/       
//---------------------------------------------------------------------------------------------  
// Code Revision History :
//---------------------------------------------------------------------------------------------
// Ver :  |  Author  |  Mod. Date  |  Changes Made
// 1.0    |  Emb     |  11/18/2019 |  Initial version
// ===========Oooo==========================================Oooo================================

`timescale 1ns/1ps
`resetall

`include "ahb_arb_defs.v"
`include "gowin_ahb_arbiter_name.v"

module `module_name_ahb_arbiter (
  // AHB Bus Clock
    input                    HCLK,            // Clock
  // AHB Bus Reset
    input                    HRESETn,         // Reset
  // AHB Arbiter Master 0
  `ifdef GOWIN_MAHB0_SUPPORT
    input                    MHSELS0,         // Slave Select
    input   [31:0]           MHADDRS0,        // Address bus
    input   [1:0]            MHTRANSS0,       // Transfer type
    input                    MHWRITES0,       // Transfer direction
    input   [2:0]            MHSIZES0,        // Transfer size
    input   [2:0]            MHBURSTS0,       // Burst type
    input   [3:0]            MHPROTS0,        // Protection control
    input   [3:0]            MHMASTERS0,      // Master select    
    input   [DATA_WIDTH-1:0] MHWDATAS0,       // Write data
    input                    MHMASTLOCKS0,    // Locked Sequence
    input                    MHREADYS0,       // Transfer done
    output  [DATA_WIDTH-1:0] MHRDATAS0,       // Read data bus
    output                   MHREADYOUTS0,    // HREADY feedback
    output  [1:0]            MHRESPS0,        // Transfer response
  `endif
  // AHB Arbiter Master 1 
  `ifdef GOWIN_MAHB1_SUPPORT
    input                   MHSELS1,          // Slave Select
    input  [31:0]           MHADDRS1,         // Address bus
    input  [1:0]            MHTRANSS1,        // Transfer type
    input                   MHWRITES1,        // Transfer direction
    input  [2:0]            MHSIZES1,         // Transfer size
    input  [2:0]            MHBURSTS1,        // Burst type
    input  [3:0]            MHPROTS1,         // Protection control
    input  [3:0]            MHMASTERS1,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS1,        // Write data
    input                   MHMASTLOCKS1,     // Locked Sequence
    input                   MHREADYS1,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS1,        // Read data bus
    output                  MHREADYOUTS1,     // HREADY feedback
    output [1:0]            MHRESPS1,         // Transfer response
  `endif  
    // AHB Arbiter Master 2
  `ifdef GOWIN_MAHB2_SUPPORT    
    input                   MHSELS2,          // Slave Select
    input  [31:0]           MHADDRS2,         // Address bus
    input  [1:0]            MHTRANSS2,        // Transfer type
    input                   MHWRITES2,        // Transfer direction
    input  [2:0]            MHSIZES2,         // Transfer size
    input  [2:0]            MHBURSTS2,        // Burst type
    input  [3:0]            MHPROTS2,         // Protection control
    input  [3:0]            MHMASTERS2,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS2,        // Write data
    input                   MHMASTLOCKS2,     // Locked Sequence
    input                   MHREADYS2,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS2,        // Read data bus
    output                  MHREADYOUTS2,     // HREADY feedback
    output [1:0]            MHRESPS2,         // Transfer response
  `endif
    // AHB Arbiter Master 3
  `ifdef GOWIN_MAHB3_SUPPORT
    input                   MHSELS3,          // Slave Select
    input  [31:0]           MHADDRS3,         // Address bus
    input  [1:0]            MHTRANSS3,        // Transfer type
    input                   MHWRITES3,        // Transfer direction
    input  [2:0]            MHSIZES3,         // Transfer size
    input  [2:0]            MHBURSTS3,        // Burst type
    input  [3:0]            MHPROTS3,         // Protection control
    input  [3:0]            MHMASTERS3,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS3,        // Write data
    input                   MHMASTLOCKS3,     // Locked Sequence
    input                   MHREADYS3,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS3,        // Read data bus
    output                  MHREADYOUTS3,     // HREADY feedback
    output [1:0]            MHRESPS3,         // Transfer response
  `endif
    // AHB Arbiter Master 4
  `ifdef GOWIN_MAHB4_SUPPORT
    input                   MHSELS4,          // Slave Select
    input  [31:0]           MHADDRS4,         // Address bus
    input  [1:0]            MHTRANSS4,        // Transfer type
    input                   MHWRITES4,        // Transfer direction
    input  [2:0]            MHSIZES4,         // Transfer size
    input  [2:0]            MHBURSTS4,        // Burst type
    input  [3:0]            MHPROTS4,         // Protection control
    input  [3:0]            MHMASTERS4,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS4,        // Write data
    input                   MHMASTLOCKS4,     // Locked Sequence
    input                   MHREADYS4,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS4,        // Read data bus
    output                  MHREADYOUTS4,     // HREADY feedback
    output [1:0]            MHRESPS4,         // Transfer response
  `endif  
    // AHB Arbiter Master 5
  `ifdef GOWIN_MAHB5_SUPPORT
    input                   MHSELS5,          // Slave Select
    input  [31:0]           MHADDRS5,         // Address bus
    input  [1:0]            MHTRANSS5,        // Transfer type
    input                   MHWRITES5,        // Transfer direction
    input  [2:0]            MHSIZES5,         // Transfer size
    input  [2:0]            MHBURSTS5,        // Burst type
    input  [3:0]            MHPROTS5,         // Protection control
    input  [3:0]            MHMASTERS5,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS5,        // Write data
    input                   MHMASTLOCKS5,     // Locked Sequence
    input                   MHREADYS5,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS5,        // Read data bus
    output                  MHREADYOUTS5,     // HREADY feedback
    output [1:0]            MHRESPS5,         // Transfer response
  `endif
    // AHB Arbiter Master 6
  `ifdef GOWIN_MAHB6_SUPPORT
    input                   MHSELS6,          // Slave Select
    input  [31:0]           MHADDRS6,         // Address bus
    input  [1:0]            MHTRANSS6,        // Transfer type
    input                   MHWRITES6,        // Transfer direction
    input  [2:0]            MHSIZES6,         // Transfer size
    input  [2:0]            MHBURSTS6,        // Burst type
    input  [3:0]            MHPROTS6,         // Protection control
    input  [3:0]            MHMASTERS6,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS6,        // Write data
    input                   MHMASTLOCKS6,     // Locked Sequence
    input                   MHREADYS6,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS6,        // Read data bus
    output                  MHREADYOUTS6,     // HREADY feedback
    output [1:0]            MHRESPS6,         // Transfer response
  `endif
    // AHB Arbiter Master 7
  `ifdef GOWIN_MAHB7_SUPPORT
    input                   MHSELS7,          // Slave Select
    input  [31:0]           MHADDRS7,         // Address bus
    input  [1:0]            MHTRANSS7,        // Transfer type
    input                   MHWRITES7,        // Transfer direction
    input  [2:0]            MHSIZES7,         // Transfer size
    input  [2:0]            MHBURSTS7,        // Burst type
    input  [3:0]            MHPROTS7,         // Protection control
    input  [3:0]            MHMASTERS7,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS7,        // Write data
    input                   MHMASTLOCKS7,     // Locked Sequence
    input                   MHREADYS7,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS7,        // Read data bus
    output                  MHREADYOUTS7,     // HREADY feedback
    output [1:0]            MHRESPS7,         // Transfer response
  `endif  
    // AHB Arbiter Master 8
  `ifdef GOWIN_MAHB8_SUPPORT
    input                   MHSELS8,          // Slave Select
    input  [31:0]           MHADDRS8,         // Address bus
    input  [1:0]            MHTRANSS8,        // Transfer type
    input                   MHWRITES8,        // Transfer direction
    input  [2:0]            MHSIZES8,         // Transfer size
    input  [2:0]            MHBURSTS8,        // Burst type
    input  [3:0]            MHPROTS8,         // Protection control
    input  [3:0]            MHMASTERS8,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS8,        // Write data
    input                   MHMASTLOCKS8,     // Locked Sequence
    input                   MHREADYS8,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS8,        // Read data bus
    output                  MHREADYOUTS8,     // HREADY feedback
    output [1:0]            MHRESPS8,         // Transfer response
  `endif  
    // AHB Arbiter Master 9
  `ifdef GOWIN_MAHB9_SUPPORT
    input                   MHSELS9,          // Slave Select
    input  [31:0]           MHADDRS9,         // Address bus
    input  [1:0]            MHTRANSS9,        // Transfer type
    input                   MHWRITES9,        // Transfer direction
    input  [2:0]            MHSIZES9,         // Transfer size
    input  [2:0]            MHBURSTS9,        // Burst type
    input  [3:0]            MHPROTS9,         // Protection control
    input  [3:0]            MHMASTERS9,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS9,        // Write data
    input                   MHMASTLOCKS9,     // Locked Sequence
    input                   MHREADYS9,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS9,        // Read data bus
    output                  MHREADYOUTS9,     // HREADY feedback
    output [1:0]            MHRESPS9,         // Transfer response
  `endif
    // AHB Arbiter Master 10
  `ifdef GOWIN_MAHB10_SUPPORT
    input                   MHSELS10,          // Slave Select
    input  [31:0]           MHADDRS10,         // Address bus
    input  [1:0]            MHTRANSS10,        // Transfer type
    input                   MHWRITES10,        // Transfer direction
    input  [2:0]            MHSIZES10,         // Transfer size
    input  [2:0]            MHBURSTS10,        // Burst type
    input  [3:0]            MHPROTS10,         // Protection control
    input  [3:0]            MHMASTERS10,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS10,        // Write data
    input                   MHMASTLOCKS10,     // Locked Sequence
    input                   MHREADYS10,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS10,        // Read data bus
    output                  MHREADYOUTS10,     // HREADY feedback
    output [1:0]            MHRESPS10,         // Transfer response
  `endif
    // AHB Arbiter Master 11
  `ifdef GOWIN_MAHB11_SUPPORT
    input                   MHSELS11,          // Slave Select
    input  [31:0]           MHADDRS11,         // Address bus
    input  [1:0]            MHTRANSS11,        // Transfer type
    input                   MHWRITES11,        // Transfer direction
    input  [2:0]            MHSIZES11,         // Transfer size
    input  [2:0]            MHBURSTS11,        // Burst type
    input  [3:0]            MHPROTS11,         // Protection control
    input  [3:0]            MHMASTERS11,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS11,        // Write data
    input                   MHMASTLOCKS11,     // Locked Sequence
    input                   MHREADYS11,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS11,        // Read data bus
    output                  MHREADYOUTS11,     // HREADY feedback
    output [1:0]            MHRESPS11,         // Transfer response
  `endif
    // AHB Arbiter Master 12
  `ifdef GOWIN_MAHB12_SUPPORT
    input                   MHSELS12,          // Slave Select
    input  [31:0]           MHADDRS12,         // Address bus
    input  [1:0]            MHTRANSS12,        // Transfer type
    input                   MHWRITES12,        // Transfer direction
    input  [2:0]            MHSIZES12,         // Transfer size
    input  [2:0]            MHBURSTS12,        // Burst type
    input  [3:0]            MHPROTS12,         // Protection control
    input  [3:0]            MHMASTERS12,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS12,        // Write data
    input                   MHMASTLOCKS12,     // Locked Sequence
    input                   MHREADYS12,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS12,        // Read data bus
    output                  MHREADYOUTS12,     // HREADY feedback
    output [1:0]            MHRESPS12,         // Transfer response
  `endif
    // AHB Arbiter Master 13
  `ifdef GOWIN_MAHB13_SUPPORT
    input                   MHSELS13,          // Slave Select
    input  [31:0]           MHADDRS13,         // Address bus
    input  [1:0]            MHTRANSS13,        // Transfer type
    input                   MHWRITES13,        // Transfer direction
    input  [2:0]            MHSIZES13,         // Transfer size
    input  [2:0]            MHBURSTS13,        // Burst type
    input  [3:0]            MHPROTS13,         // Protection control
    input  [3:0]            MHMASTERS13,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS13,        // Write data
    input                   MHMASTLOCKS13,     // Locked Sequence
    input                   MHREADYS13,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS13,        // Read data bus
    output                  MHREADYOUTS13,     // HREADY feedback
    output [1:0]            MHRESPS13,         // Transfer response
  `endif
    // AHB Arbiter Master 14
  `ifdef GOWIN_MAHB14_SUPPORT
    input                   MHSELS14,          // Slave Select
    input  [31:0]           MHADDRS14,         // Address bus
    input  [1:0]            MHTRANSS14,        // Transfer type
    input                   MHWRITES14,        // Transfer direction
    input  [2:0]            MHSIZES14,         // Transfer size
    input  [2:0]            MHBURSTS14,        // Burst type
    input  [3:0]            MHPROTS14,         // Protection control
    input  [3:0]            MHMASTERS14,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS14,        // Write data
    input                   MHMASTLOCKS14,     // Locked Sequence
    input                   MHREADYS14,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS14,        // Read data bus
    output                  MHREADYOUTS14,     // HREADY feedback
    output [1:0]            MHRESPS14,         // Transfer response
  `endif
    // AHB Arbiter Master 15
  `ifdef GOWIN_MAHB15_SUPPORT
    input                   MHSELS15,          // Slave Select
    input  [31:0]           MHADDRS15,         // Address bus
    input  [1:0]            MHTRANSS15,        // Transfer type
    input                   MHWRITES15,        // Transfer direction
    input  [2:0]            MHSIZES15,         // Transfer size
    input  [2:0]            MHBURSTS15,        // Burst type
    input  [3:0]            MHPROTS15,         // Protection control
    input  [3:0]            MHMASTERS15,       // Master select    
    input  [DATA_WIDTH-1:0] MHWDATAS15,        // Write data
    input                   MHMASTLOCKS15,     // Locked Sequence
    input                   MHREADYS15,        // Transfer done
    output [DATA_WIDTH-1:0] MHRDATAS15,        // Read data bus
    output                  MHREADYOUTS15,     // HREADY feedback
    output [1:0]            MHRESPS15,         // Transfer response
  `endif
    // AHB Arbiter Slave
    input  [DATA_WIDTH-1:0] SHRDATAM0,         // Read data bus
    input                   SHREADYOUTM0,      // HREADY feedback
    input  [1:0]            SHRESPM0,          // Transfer response
    output                  SHSELM0,           // Select
    output [31:0]           SHADDRM0,          // Address bus
    output [1:0]            SHTRANSM0,         // Transfer type
    output                  SHWRITEM0,         // Transfer direction
    output [2:0]            SHSIZEM0,          // Transfer size
    output [2:0]            SHBURSTM0,         // Burst type
    output [3:0]            SHPROTM0,          // Protection control
    output [3:0]            SHMASTERM0,        // Master select
    output [DATA_WIDTH-1:0] SHWDATAM0,         // Write data
    output                  SHMASTLOCKM0,      // Locked Sqeuence
    output                  SHREADYMUXM0       // Transfer done
);

//------------------- Top Instantiate----------------------//
BusMatrix16 u_busmatrix16(
    // Common AHB signals    
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    // System Address Remap control
    .REMAP(4'b0000),
    // AHB Arbiter Master 0
  `ifdef GOWIN_MAHB0_SUPPORT
    .HSELS0(MHSELS0),
    .HADDRS0(MHADDRS0),
    .HTRANSS0(MHTRANSS0),
    .HWRITES0(MHWRITES0),
    .HSIZES0(MHSIZES0),
    .HBURSTS0(MHBURSTS0),
    .HPROTS0(MHPROTS0),
    .HMASTERS0(MHMASTERS0),
    .HWDATAS0(MHWDATAS0),
    .HMASTLOCKS0(MHMASTLOCKS0),
    .HREADYS0(MHREADYS0),
  `else
    .HSELS0(1'b0),
    .HADDRS0(32'h0),
    .HTRANSS0(2'b00),
    .HWRITES0(1'b0),
    .HSIZES0(3'b000),
    .HBURSTS0(3'b000),
    .HPROTS0(4'b0000),
    .HMASTERS0(4'b0000),
    .HWDATAS0(32'h0),
    .HMASTLOCKS0(1'b0),
    .HREADYS0(1'b0),
  `endif    
    // AHB Arbiter Master 1
  `ifdef GOWIN_MAHB1_SUPPORT
    .HSELS1(MHSELS1),
    .HADDRS1(MHADDRS1),
    .HTRANSS1(MHTRANSS1),
    .HWRITES1(MHWRITES1),
    .HSIZES1(MHSIZES1),
    .HBURSTS1(MHBURSTS1),
    .HPROTS1(MHPROTS1),
    .HMASTERS1(MHMASTERS1),
    .HWDATAS1(MHWDATAS1),
    .HMASTLOCKS1(MHMASTLOCKS1),
    .HREADYS1(MHREADYS1),
  `else
    .HSELS1(1'b0),
    .HADDRS1(32'h0),
    .HTRANSS1(2'b00),
    .HWRITES1(1'b0),
    .HSIZES1(3'b000),
    .HBURSTS1(3'b000),
    .HPROTS1(4'b0000),
    .HMASTERS1(4'b0000),
    .HWDATAS1(32'h0),
    .HMASTLOCKS1(1'b0),
    .HREADYS1(1'b0),
  `endif    
    // AHB Arbiter Master 2
  `ifdef GOWIN_MAHB2_SUPPORT
    .HSELS2(MHSELS2),
    .HADDRS2(MHADDRS2),
    .HTRANSS2(MHTRANSS2),
    .HWRITES2(MHWRITES2),
    .HSIZES2(MHSIZES2),
    .HBURSTS2(MHBURSTS2),
    .HPROTS2(MHPROTS2),
    .HMASTERS2(MHMASTERS2),
    .HWDATAS2(MHWDATAS2),
    .HMASTLOCKS2(MHMASTLOCKS2),
    .HREADYS2(MHREADYS2),
  `else
    .HSELS2(1'b0),
    .HADDRS2(32'h0),
    .HTRANSS2(2'b00),
    .HWRITES2(1'b0),
    .HSIZES2(3'b000),
    .HBURSTS2(3'b000),
    .HPROTS2(4'b0000),
    .HMASTERS2(4'b0000),
    .HWDATAS2(32'h0),
    .HMASTLOCKS2(1'b0),
    .HREADYS2(1'b0),
  `endif    
    // AHB Arbiter Master 3
  `ifdef GOWIN_MAHB3_SUPPORT
    .HSELS3(MHSELS3),
    .HADDRS3(MHADDRS3),
    .HTRANSS3(MHTRANSS3),
    .HWRITES3(MHWRITES3),
    .HSIZES3(MHSIZES3),
    .HBURSTS3(MHBURSTS3),
    .HPROTS3(MHPROTS3),
    .HMASTERS3(MHMASTERS3),
    .HWDATAS3(MHWDATAS3),
    .HMASTLOCKS3(MHMASTLOCKS3),
    .HREADYS3(MHREADYS3),
  `else
    .HSELS3(1'b0),
    .HADDRS3(32'h0),
    .HTRANSS3(2'b00),
    .HWRITES3(1'b0),
    .HSIZES3(3'b000),
    .HBURSTS3(3'b000),
    .HPROTS3(4'b0000),
    .HMASTERS3(4'b0000),
    .HWDATAS3(32'h0),
    .HMASTLOCKS3(1'b0),
    .HREADYS3(1'b0),
  `endif    
    // AHB Arbiter Master 4
  `ifdef GOWIN_MAHB4_SUPPORT
    .HSELS4(MHSELS4),
    .HADDRS4(MHADDRS4),
    .HTRANSS4(MHTRANSS4),
    .HWRITES4(MHWRITES4),
    .HSIZES4(MHSIZES4),
    .HBURSTS4(MHBURSTS4),
    .HPROTS4(MHPROTS4),
    .HMASTERS4(MHMASTERS4),
    .HWDATAS4(MHWDATAS4),
    .HMASTLOCKS4(MHMASTLOCKS4),
    .HREADYS4(MHREADYS4),
  `else
    .HSELS4(1'b0),
    .HADDRS4(32'h0),
    .HTRANSS4(2'b00),
    .HWRITES4(1'b0),
    .HSIZES4(3'b000),
    .HBURSTS4(3'b000),
    .HPROTS4(4'b0000),
    .HMASTERS4(4'b0000),
    .HWDATAS4(32'h0),
    .HMASTLOCKS4(1'b0),
    .HREADYS4(1'b0),
  `endif    
    // AHB Arbiter Master 5
  `ifdef GOWIN_MAHB5_SUPPORT
    .HSELS5(MHSELS5),
    .HADDRS5(MHADDRS5),
    .HTRANSS5(MHTRANSS5),
    .HWRITES5(MHWRITES5),
    .HSIZES5(MHSIZES5),
    .HBURSTS5(MHBURSTS5),
    .HPROTS5(MHPROTS5),
    .HMASTERS5(MHMASTERS5),
    .HWDATAS5(MHWDATAS5),
    .HMASTLOCKS5(MHMASTLOCKS5),
    .HREADYS5(MHREADYS5),
  `else
    .HSELS5(1'b0),
    .HADDRS5(32'h0),
    .HTRANSS5(2'b00),
    .HWRITES5(1'b0),
    .HSIZES5(3'b000),
    .HBURSTS5(3'b000),
    .HPROTS5(4'b0000),
    .HMASTERS5(4'b0000),
    .HWDATAS5(32'h0),
    .HMASTLOCKS5(1'b0),
    .HREADYS5(1'b0),
  `endif
    // AHB Arbiter Master 6
  `ifdef GOWIN_MAHB6_SUPPORT
    .HSELS6(MHSELS6),
    .HADDRS6(MHADDRS6),
    .HTRANSS6(MHTRANSS6),
    .HWRITES6(MHWRITES6),
    .HSIZES6(MHSIZES6),
    .HBURSTS6(MHBURSTS6),
    .HPROTS6(MHPROTS6),
    .HMASTERS6(MHMASTERS6),
    .HWDATAS6(MHWDATAS6),
    .HMASTLOCKS6(MHMASTLOCKS6),
    .HREADYS6(MHREADYS6),
  `else
    .HSELS6(1'b0),
    .HADDRS6(32'h0),
    .HTRANSS6(2'b00),
    .HWRITES6(1'b0),
    .HSIZES6(3'b000),
    .HBURSTS6(3'b000),
    .HPROTS6(4'b0000),
    .HMASTERS6(4'b0000),
    .HWDATAS6(32'h0),
    .HMASTLOCKS6(1'b0),
    .HREADYS6(1'b0),
  `endif    
    // AHB Arbiter Master 7
  `ifdef GOWIN_MAHB7_SUPPORT
    .HSELS7(MHSELS7),
    .HADDRS7(MHADDRS7),
    .HTRANSS7(MHTRANSS7),
    .HWRITES7(MHWRITES7),
    .HSIZES7(MHSIZES7),
    .HBURSTS7(MHBURSTS7),
    .HPROTS7(MHPROTS7),
    .HMASTERS7(MHMASTERS7),
    .HWDATAS7(MHWDATAS7),
    .HMASTLOCKS7(MHMASTLOCKS7),
    .HREADYS7(MHREADYS7),
  `else
    .HSELS7(1'b0),
    .HADDRS7(32'h0),
    .HTRANSS7(2'b00),
    .HWRITES7(1'b0),
    .HSIZES7(3'b000),
    .HBURSTS7(3'b000),
    .HPROTS7(4'b0000),
    .HMASTERS7(4'b0000),
    .HWDATAS7(32'h0),
    .HMASTLOCKS7(1'b0),
    .HREADYS7(1'b0),
  `endif    
    // AHB Arbiter Master 8
  `ifdef GOWIN_MAHB8_SUPPORT
    .HSELS8(MHSELS8),
    .HADDRS8(MHADDRS8),
    .HTRANSS8(MHTRANSS8),
    .HWRITES8(MHWRITES8),
    .HSIZES8(MHSIZES8),
    .HBURSTS8(MHBURSTS8),
    .HPROTS8(MHPROTS8),
    .HMASTERS8(MHMASTERS8),
    .HWDATAS8(MHWDATAS8),
    .HMASTLOCKS8(MHMASTLOCKS8),
    .HREADYS8(MHREADYS8),
  `else
    .HSELS8(1'b0),
    .HADDRS8(32'h0),
    .HTRANSS8(2'b00),
    .HWRITES8(1'b0),
    .HSIZES8(3'b000),
    .HBURSTS8(3'b000),
    .HPROTS8(4'b0000),
    .HMASTERS8(4'b0000),
    .HWDATAS8(32'h0),
    .HMASTLOCKS8(1'b0),
    .HREADYS8(1'b0),
  `endif     
    // AHB Arbiter Master 9
  `ifdef GOWIN_MAHB9_SUPPORT
    .HSELS9(MHSELS9),
    .HADDRS9(MHADDRS9),
    .HTRANSS9(MHTRANSS9),
    .HWRITES9(MHWRITES9),
    .HSIZES9(MHSIZES9),
    .HBURSTS9(MHBURSTS9),
    .HPROTS9(MHPROTS9),
    .HMASTERS9(MHMASTERS9),
    .HWDATAS9(MHWDATAS9),
    .HMASTLOCKS9(MHMASTLOCKS9),
    .HREADYS9(MHREADYS9),
  `else
    .HSELS9(1'b0),
    .HADDRS9(32'h0),
    .HTRANSS9(2'b00),
    .HWRITES9(1'b0),
    .HSIZES9(3'b000),
    .HBURSTS9(3'b000),
    .HPROTS9(4'b0000),
    .HMASTERS9(4'b0000),
    .HWDATAS9(32'h0),
    .HMASTLOCKS9(1'b0),
    .HREADYS9(1'b0),
  `endif    
    // AHB Arbiter Master 10
  `ifdef GOWIN_MAHB10_SUPPORT
    .HSELS10(MHSELS10),
    .HADDRS10(MHADDRS10),
    .HTRANSS10(MHTRANSS10),
    .HWRITES10(MHWRITES10),
    .HSIZES10(MHSIZES10),
    .HBURSTS10(MHBURSTS10),
    .HPROTS10(MHPROTS10),
    .HMASTERS10(MHMASTERS10),
    .HWDATAS10(MHWDATAS10),
    .HMASTLOCKS10(MHMASTLOCKS10),
    .HREADYS10(MHREADYS10),
  `else
    .HSELS10(1'b0),
    .HADDRS10(32'h0),
    .HTRANSS10(2'b00),
    .HWRITES10(1'b0),
    .HSIZES10(3'b000),
    .HBURSTS10(3'b000),
    .HPROTS10(4'b0000),
    .HMASTERS10(4'b0000),
    .HWDATAS10(32'h0),
    .HMASTLOCKS10(1'b0),
    .HREADYS10(1'b0),
  `endif    
    // AHB Arbiter Master 11
  `ifdef GOWIN_MAHB11_SUPPORT 
    .HSELS11(MHSELS11),
    .HADDRS11(MHADDRS11),
    .HTRANSS11(MHTRANSS11),
    .HWRITES11(MHWRITES11),
    .HSIZES11(MHSIZES11),
    .HBURSTS11(MHBURSTS11),
    .HPROTS11(MHPROTS11),
    .HMASTERS11(MHMASTERS11),
    .HWDATAS11(MHWDATAS11),
    .HMASTLOCKS11(MHMASTLOCKS11),
    .HREADYS11(MHREADYS11),
  `else
    .HSELS11(1'b0),
    .HADDRS11(32'h0),
    .HTRANSS11(2'b00),
    .HWRITES11(1'b0),
    .HSIZES11(3'b000),
    .HBURSTS11(3'b000),
    .HPROTS11(4'b0000),
    .HMASTERS11(4'b0000),
    .HWDATAS11(32'h0),
    .HMASTLOCKS11(1'b0),
    .HREADYS11(1'b0),
  `endif
    // AHB Arbiter Master 12
  `ifdef GOWIN_MAHB12_SUPPORT
    .HSELS12(MHSELS12),
    .HADDRS12(MHADDRS12),
    .HTRANSS12(MHTRANSS12),
    .HWRITES12(MHWRITES12),
    .HSIZES12(MHSIZES12),
    .HBURSTS12(MHBURSTS12),
    .HPROTS12(MHPROTS12),
    .HMASTERS12(MHMASTERS12),
    .HWDATAS12(MHWDATAS12),
    .HMASTLOCKS12(MHMASTLOCKS12),
    .HREADYS12(MHREADYS12),
  `else
    .HSELS12(1'b0),
    .HADDRS12(32'h0),
    .HTRANSS12(2'b00),
    .HWRITES12(1'b0),
    .HSIZES12(3'b000),
    .HBURSTS12(3'b000),
    .HPROTS12(4'b0000),
    .HMASTERS12(4'b0000),
    .HWDATAS12(32'h0),
    .HMASTLOCKS12(1'b0),
    .HREADYS12(1'b0),
  `endif    
    // AHB Arbiter Master 13
  `ifdef GOWIN_MAHB13_SUPPORT
    .HSELS13(MHSELS13),
    .HADDRS13(MHADDRS13),
    .HTRANSS13(MHTRANSS13),
    .HWRITES13(MHWRITES13),
    .HSIZES13(MHSIZES13),
    .HBURSTS13(MHBURSTS13),
    .HPROTS13(MHPROTS13),
    .HMASTERS13(MHMASTERS13),
    .HWDATAS13(MHWDATAS13),
    .HMASTLOCKS13(MHMASTLOCKS13),
    .HREADYS13(MHREADYS13),
  `else
    .HSELS13(1'b0),
    .HADDRS13(32'h0),
    .HTRANSS13(2'b00),
    .HWRITES13(1'b0),
    .HSIZES13(3'b000),
    .HBURSTS13(3'b000),
    .HPROTS13(4'b0000),
    .HMASTERS13(4'b0000),
    .HWDATAS13(32'h0),
    .HMASTLOCKS13(1'b0),
    .HREADYS13(1'b0),
  `endif    
    // AHB Arbiter Master 14
  `ifdef GOWIN_MAHB14_SUPPORT 
    .HSELS14(MHSELS14),
    .HADDRS14(MHADDRS14),
    .HTRANSS14(MHTRANSS14),
    .HWRITES14(MHWRITES14),
    .HSIZES14(MHSIZES14),
    .HBURSTS14(MHBURSTS14),
    .HPROTS14(MHPROTS14),
    .HMASTERS14(MHMASTERS14),
    .HWDATAS14(MHWDATAS14),
    .HMASTLOCKS14(MHMASTLOCKS14),
    .HREADYS14(MHREADYS14),
  `else
    .HSELS14(1'b0),
    .HADDRS14(32'h0),
    .HTRANSS14(2'b00),
    .HWRITES14(1'b0),
    .HSIZES14(3'b000),
    .HBURSTS14(3'b000),
    .HPROTS14(4'b0000),
    .HMASTERS14(4'b0000),
    .HWDATAS14(32'h0),
    .HMASTLOCKS14(1'b0),
    .HREADYS14(1'b0),
  `endif     
    // AHB Arbiter Master 15
  `ifdef GOWIN_MAHB15_SUPPORT  
    .HSELS15(MHSELS15),
    .HADDRS15(MHADDRS15),
    .HTRANSS15(MHTRANSS15),
    .HWRITES15(MHWRITES15),
    .HSIZES15(MHSIZES15),
    .HBURSTS15(MHBURSTS15),
    .HPROTS15(MHPROTS15),
    .HMASTERS15(MHMASTERS15),
    .HWDATAS15(MHWDATAS15),
    .HMASTLOCKS15(MHMASTLOCKS15),
    .HREADYS15(MHREADYS15),
  `else
    .HSELS15(1'b0),
    .HADDRS15(32'h0),
    .HTRANSS15(2'b00),
    .HWRITES15(1'b0),
    .HSIZES15(3'b000),
    .HBURSTS15(3'b000),
    .HPROTS15(4'b0000),
    .HMASTERS15(4'b0000),
    .HWDATAS15(32'h0),
    .HMASTLOCKS15(1'b0),
    .HREADYS15(1'b0),
  `endif
    
  `ifdef GOWIN_MAHB0_SUPPORT
    .HRDATAS0(MHRDATAS0),
    .HREADYOUTS0(MHREADYOUTS0),
    .HRESPS0(MHRESPS0),
  `else
    .HRDATAS0(),
    .HREADYOUTS0(),
    .HRESPS0(),
  `endif

  `ifdef GOWIN_MAHB1_SUPPORT
    .HRDATAS1(MHRDATAS1),
    .HREADYOUTS1(MHREADYOUTS1),
    .HRESPS1(MHRESPS1),
  `else
    .HRDATAS1(),
    .HREADYOUTS1(),
    .HRESPS1(),
  `endif

  `ifdef GOWIN_MAHB2_SUPPORT
    .HRDATAS2(MHRDATAS2),
    .HREADYOUTS2(MHREADYOUTS2),
    .HRESPS2(MHRESPS2),
  `else
    .HRDATAS2(),
    .HREADYOUTS2(),
    .HRESPS2(),
  `endif

  `ifdef GOWIN_MAHB3_SUPPORT
    .HRDATAS3(MHRDATAS3),
    .HREADYOUTS3(MHREADYOUTS3),
    .HRESPS3(MHRESPS3),
  `else
    .HRDATAS3(),
    .HREADYOUTS3(),
    .HRESPS3(),
  `endif

  `ifdef GOWIN_MAHB4_SUPPORT
    .HRDATAS4(MHRDATAS4),
    .HREADYOUTS4(MHREADYOUTS4),
    .HRESPS4(MHRESPS4),
  `else
    .HRDATAS4(),
    .HREADYOUTS4(),
    .HRESPS4(),
  `endif

  `ifdef GOWIN_MAHB5_SUPPORT
    .HRDATAS5(MHRDATAS5),
    .HREADYOUTS5(MHREADYOUTS5),
    .HRESPS5(MHRESPS5),
  `else
    .HRDATAS5(),
    .HREADYOUTS5(),
    .HRESPS5(),
  `endif

  `ifdef GOWIN_MAHB6_SUPPORT
    .HRDATAS6(MHRDATAS6),
    .HREADYOUTS6(MHREADYOUTS6),
    .HRESPS6(MHRESPS6),
  `else
    .HRDATAS6(),
    .HREADYOUTS6(),
    .HRESPS6(),
  `endif

  `ifdef GOWIN_MAHB7_SUPPORT
    .HRDATAS7(MHRDATAS7),
    .HREADYOUTS7(MHREADYOUTS7),
    .HRESPS7(MHRESPS7),
  `else
    .HRDATAS7(),
    .HREADYOUTS7(),
    .HRESPS7(),
  `endif

  `ifdef GOWIN_MAHB8_SUPPORT
    .HRDATAS8(MHRDATAS8),
    .HREADYOUTS8(MHREADYOUTS8),
    .HRESPS8(MHRESPS8),
  `else
    .HRDATAS8(),
    .HREADYOUTS8(),
    .HRESPS8(),
  `endif

  `ifdef GOWIN_MAHB9_SUPPORT
    .HRDATAS9(MHRDATAS9),
    .HREADYOUTS9(MHREADYOUTS9),
    .HRESPS9(MHRESPS9),
  `else
    .HRDATAS9(),
    .HREADYOUTS9(),
    .HRESPS9(),
  `endif

  `ifdef GOWIN_MAHB10_SUPPORT
    .HRDATAS10(MHRDATAS10),
    .HREADYOUTS10(MHREADYOUTS10),
    .HRESPS10(MHRESPS10),
  `else
    .HRDATAS10(),
    .HREADYOUTS10(),
    .HRESPS10(),
  `endif

  `ifdef GOWIN_MAHB11_SUPPORT
    .HRDATAS11(MHRDATAS11),
    .HREADYOUTS11(MHREADYOUTS11),
    .HRESPS11(MHRESPS11),
  `else
    .HRDATAS11(),
    .HREADYOUTS11(),
    .HRESPS11(),
  `endif

  `ifdef GOWIN_MAHB12_SUPPORT
    .HRDATAS12(MHRDATAS12),
    .HREADYOUTS12(MHREADYOUTS12),
    .HRESPS12(MHRESPS12),
  `else
    .HRDATAS12(),
    .HREADYOUTS12(),
    .HRESPS12(),
  `endif

  `ifdef GOWIN_MAHB13_SUPPORT
    .HRDATAS13(MHRDATAS13),
    .HREADYOUTS13(MHREADYOUTS13),
    .HRESPS13(MHRESPS13),
  `else
    .HRDATAS13(),
    .HREADYOUTS13(),
    .HRESPS13(),
  `endif

  `ifdef GOWIN_MAHB14_SUPPORT
    .HRDATAS14(MHRDATAS14),
    .HREADYOUTS14(MHREADYOUTS14),
    .HRESPS14(MHRESPS14),
  `else
    .HRDATAS14(),
    .HREADYOUTS14(),
    .HRESPS14(),
  `endif

  `ifdef GOWIN_MAHB15_SUPPORT
    .HRDATAS15(MHRDATAS15),
    .HREADYOUTS15(MHREADYOUTS15),
    .HRESPS15(MHRESPS15),
  `else
    .HRDATAS15(), 
    .HREADYOUTS15(),
    .HRESPS15(),
  `endif
    .HRDATAM0(SHRDATAM0),
    .HREADYOUTM0(SHREADYOUTM0),
    .HRESPM0(SHRESPM0),

    //AHB Arbiter Slave
    .HSELM0(SHSELM0),
    .HADDRM0(SHADDRM0),
    .HTRANSM0(SHTRANSM0),
    .HWRITEM0(SHWRITEM0),
    .HSIZEM0(SHSIZEM0),
    .HBURSTM0(SHBURSTM0),
    .HPROTM0(SHPROTM0),
    .HMASTERM0(SHMASTERM0),
    .HWDATAM0(SHWDATAM0),
    .HMASTLOCKM0(SHMASTLOCKM0),
    .HREADYMUXM0(SHREADYMUXM0)
);

endmodule
