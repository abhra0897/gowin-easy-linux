// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2019 Shandong Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] AHB_To_AHB_Sync.v
//   \ \  / /\ \  / /    [Authors     ] Chenglong 
//    \ \/ /  \ \/ /     [Description ] ahb_to_ahb_sync
//     \  /    \  /      [Timestamp   ] XX/XX/2019
//      \/      \/
//
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Ver:     | Author    |Mod. Date      |Changes Made:
// V1.0     | Chenglong |12/09/2019     |Initial vision
// ===========Oooo==========================================Oooo========

`include "define.vh"
`include "static_macro_define.vh"

module `module_name
 (
  // --------------------------------------------------------------------------------
  // I/O declarations
  // --------------------------------------------------------------------------------
      HCLK,       // Clock
      HRESETn,    // Reset

  // AHB connection to master
      HSELS,
      HADDRS,
      HTRANSS,
      HSIZES,
      HWRITES,
      HREADYS,
      HPROTS,
      HMASTERS,
      HMASTLOCKS,
      HWDATAS,
      HBURSTS,

      HREADYOUTS,
      HRESPS,
      HRDATAS,

  // AHB connection to slave
      HADDRM,
      HTRANSM,
      HSIZEM,
      HWRITEM,
      HPROTM,
      HMASTERM,
      HMASTLOCKM,
      HWDATAM,
      HBURSTM,

      HREADYM,
      HRESPM,
      HRDATAM
);

`include "parameter.vh"
localparam       AW    = 32;  
localparam       DW    = 32; 
localparam       BURST = 0;
  input  wire          HCLK;       // Clock
  input  wire          HRESETn;    // Reset

  // AHB connection to master
  input  wire          HSELS;
  input  wire [AW-1:0] HADDRS;
  input  wire    [1:0] HTRANSS;
  input  wire    [2:0] HSIZES;
  input  wire          HWRITES;
  input  wire          HREADYS;
  input  wire    [3:0] HPROTS;
  input  wire [MW-1:0] HMASTERS;
  input  wire          HMASTLOCKS;
  input  wire [DW-1:0] HWDATAS;
  input  wire    [2:0] HBURSTS;

  output wire          HREADYOUTS;
  output wire          HRESPS;
  output wire [DW-1:0] HRDATAS;

  // AHB connection to slave
  output wire [AW-1:0] HADDRM;
  output wire   [1:0]  HTRANSM;
  output wire   [2:0]  HSIZEM;
  output wire          HWRITEM;
  output wire   [3:0]  HPROTM;
  output wire [MW-1:0] HMASTERM;
  output wire          HMASTLOCKM;
  output wire [DW-1:0] HWDATAM;
  output wire   [2:0]  HBURSTM;

  input  wire          HREADYM;
  input  wire          HRESPM;
  input  wire [DW-1:0] HRDATAM;



 `getname(ahb_to_ahb_sync,`module_name) u_ahb_to_ahb_sync
  (
            .HCLK             (HCLK         ),       // Clock
            .HRESETn          (HRESETn      ),    // Reset

  // AHB connection to master
            .HSELS            (HSELS        ),
            .HADDRS           (HADDRS       ),
            .HTRANSS          (HTRANSS      ),
            .HSIZES           (HSIZES       ),
            .HWRITES          (HWRITES      ),
            .HREADYS          (HREADYS      ),
            .HPROTS           (HPROTS       ),
            .HMASTERS         (HMASTERS     ),
            .HMASTLOCKS       (HMASTLOCKS   ),
            .HWDATAS          (HWDATAS      ),
            .HBURSTS          (HBURSTS      ),

            .HREADYOUTS       (HREADYOUTS   ),
            .HRESPS           (HRESPS       ),
            .HRDATAS          (HRDATAS      ),

  // AHB connection to slave
            .HADDRM           (HADDRM       ),
            .HTRANSM          (HTRANSM      ),
            .HSIZEM           (HSIZEM       ),
            .HWRITEM          (HWRITEM      ),
            .HPROTM           (HPROTM       ),
            .HMASTERM         (HMASTERM     ),
            .HMASTLOCKM       (HMASTLOCKM   ),
            .HWDATAM          (HWDATAM      ),
            .HBURSTM          (HBURSTM      ),

            .HREADYM          (HREADYM      ),
            .HRESPM           (HRESPM       ),
            .HRDATAM          (HRDATAM      )
);

defparam u_ahb_to_ahb_apb_async.MW = MW;

endmodule
