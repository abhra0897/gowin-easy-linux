
// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2019 Shandong Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] ahb_to_ahb_apb_async.v
//   \ \  / /\ \  / /    [Authors     ] Chenglong 
//    \ \/ /  \ \/ /     [Description ] ahb_to_ahb_apb_async
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

module `module_name (
      // --------
      // AHB-Lite slave interface
       HCLKS,
       HRESETSn,

       HADDRS,
       HBURSTS,
       HMASTLOCKS,
       HPROTS,
       HREADYS,
       HSELAHBS,
       HSELAPBS,
       HSIZES,
       HTRANSS,
       HWDATAS,
       HWRITES,
       HMASTERS,

       HRDATAS,
       HREADYOUTS,
       HRESPS,

      // --------
      // AHB-Lite master interface
       HCLKM,
       HRESETMn,

       HADDRM,
       HBURSTM,
       HMASTLOCKM,
       HPROTM,
       HSIZEM,
       HTRANSM,
       HWDATAM,
       HWRITEM,
       HMASTERM,

       HRDATAM,
       HREADYM,
       HRESPM,

      // --------
      // APB4 master interface
      // part of HCLKM and HRESETMn domain
       PADDRM,
       PENABLEM,
       PPROTM,
       PSELM,
       PSTRBM,
       PWDATAM,
       PWRITEM,
       PMASTERM,

       PRDATAM,
       PREADYM,
       PSLVERRM,

      // --------
      // Clock gating control interface
      // part of HCLKM and HRESETMn domain
       HACTIVEM, // AHB-Lite system clock gating control
       PACTIVEM  // APB4 system clock gating control
   );

`include "parameter.vh"
      input  wire        HCLKS;
      input  wire        HRESETSn;

      input  wire [31:0] HADDRS;
      input  wire [ 2:0] HBURSTS;
      input  wire        HMASTLOCKS;
      input  wire [ 3:0] HPROTS;
      input  wire        HREADYS;
      input  wire        HSELAHBS;
      input  wire        HSELAPBS;
      input  wire [ 2:0] HSIZES;
      input  wire [ 1:0] HTRANSS;
      input  wire [31:0] HWDATAS;
      input  wire        HWRITES;
      input  wire [MW-1:0] HMASTERS;

      output wire [31:0] HRDATAS;
      output wire        HREADYOUTS;
      output wire        HRESPS;

      // --------
      // AHB-Lite master interface
      input  wire        HCLKM;
      input  wire        HRESETMn;

      output wire [31:0] HADDRM;
      output wire  [2:0] HBURSTM;
      output wire        HMASTLOCKM;
      output wire [ 3:0] HPROTM;
      output wire [ 2:0] HSIZEM;
      output wire [ 1:0] HTRANSM;
      output wire [31:0] HWDATAM;
      output wire        HWRITEM;
      output wire [MW-1:0] HMASTERM;

      input  wire [31:0] HRDATAM;
      input  wire        HREADYM;
      input  wire        HRESPM;

      // --------
      // APB4 master interface
      // part of HCLKM and HRESETMn domain
      output wire [31:0] PADDRM;
      output wire        PENABLEM;
      output wire [ 2:0] PPROTM;
      output wire        PSELM;
      output wire [ 3:0] PSTRBM;
      output wire [31:0] PWDATAM;
      output wire        PWRITEM;
      output wire [MW-1:0] PMASTERM;

      input  wire [31:0] PRDATAM;
      input  wire        PREADYM;
      input  wire        PSLVERRM;

      // --------
      // Clock gating control interface
      // part of HCLKM and HRESETMn domain
      output wire        HACTIVEM; // AHB-Lite system clock gating control
      output wire        PACTIVEM;  //

`getname(ahb_to_ahb_apb_async,`module_name) u_ahb_to_ahb_apb_async(
      // --------
      // AHB-Lite slave interface
       .HCLKS           (HCLKS        ),
       .HRESETSn        (HRESETSn     ),

       .HADDRS          (HADDRS       ),
       .HBURSTS         (HBURSTS      ),
       .HMASTLOCKS      (HMASTLOCKS   ),
       .HPROTS          (HPROTS       ),
       .HREADYS         (HREADYS      ),
       .HSELAHBS        (HSELAHBS     ),
       .HSELAPBS        (HSELAPBS     ),
       .HSIZES          (HSIZES       ),
       .HTRANSS         (HTRANSS      ),
       .HWDATAS         (HWDATAS      ),
       .HWRITES         (HWRITES      ),
       .HMASTERS        (HMASTERS     ),

       .HRDATAS         (HRDATAS      ),
       .HREADYOUTS      (HREADYOUTS   ),
       .HRESPS          (HRESPS       ),

      // --------
      // AHB-Lite master interface
       .HCLKM           (HCLKM        ),
       .HRESETMn        (HRESETMn     ),

       .HADDRM          (HADDRM       ),
       .HBURSTM         (HBURSTM      ),
       .HMASTLOCKM      (HMASTLOCKM   ),
       .HPROTM          (HPROTM       ),
       .HSIZEM          (HSIZEM       ),
       .HTRANSM         (HTRANSM      ),
       .HWDATAM         (HWDATAM      ),
       .HWRITEM         (HWRITEM      ),
       .HMASTERM        (HMASTERM     ),

       .HRDATAM         (HRDATAM      ),
       .HREADYM         (HREADYM      ),
       .HRESPM          (HRESPM       ),

      // --------
      // APB4 master interface
      // part of HCLKM and HRESETMn domain
       .PADDRM          (PADDRM       ),
       .PENABLEM        (PENABLEM     ),
       .PPROTM          (PPROTM       ),
       .PSELM           (PSELM        ),
       .PSTRBM          (PSTRBM       ),
       .PWDATAM         (PWDATAM      ),
       .PWRITEM         (PWRITEM      ),
       .PMASTERM        (PMASTERM     ),

       .PRDATAM         (PRDATAM      ),
       .PREADYM         (PREADYM      ),
       .PSLVERRM        (PSLVERRM     ),

      // --------
      // Clock gating control interface
      // part of HCLKM and HRESETMn domain
       .HACTIVEM        (HACTIVEM     ), // AHB-Lite system clock gating control
       .PACTIVEM        (PACTIVEM     )  // APB4 system clock gating control
   );

defparam u_ahb_to_ahb_apb_async.MW = MW;
endmodule
