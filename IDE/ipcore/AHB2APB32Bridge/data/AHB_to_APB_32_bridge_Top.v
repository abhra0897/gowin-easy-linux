`include "config.vh"
`include "const.vh"

module `module_name(
      `ifdef SLV_1
      	  ps1_psel,
      	  ps1_prdata,
      	  ps1_pready,
      	  ps1_pslverr,
      `endif
      `ifdef SLV_2
      	  ps2_psel,
      	  ps2_prdata,
      	  ps2_pready,
      	  ps2_pslverr,
      `endif
      `ifdef SLV_3
      	  ps3_psel,
      	  ps3_prdata,
      	  ps3_pready,
      	  ps3_pslverr,
      `endif
      `ifdef SLV_4
      	  ps4_psel,
      	  ps4_prdata,
      	  ps4_pready,
      	  ps4_pslverr,
      `endif
      `ifdef SLV_5
      	  ps5_psel,
      	  ps5_prdata,
      	  ps5_pready,
      	  ps5_pslverr,
      `endif
      `ifdef SLV_6
      	  ps6_psel,
      	  ps6_prdata,
      	  ps6_pready,
      	  ps6_pslverr,
      `endif
      `ifdef SLV_7
      	  ps7_psel,
      	  ps7_prdata,
      	  ps7_pready,
      	  ps7_pslverr,
      `endif
      `ifdef SLV_8
      	  ps8_psel,
      	  ps8_prdata,
      	  ps8_pready,
      	  ps8_pslverr,
      `endif
      `ifdef SLV_9
      	  ps9_psel,
      	  ps9_prdata,
      	  ps9_pready,
      	  ps9_pslverr,
      `endif
      `ifdef SLV_10
      	  ps10_psel,
      	  ps10_prdata,
      	  ps10_pready,
      	  ps10_pslverr,
      `endif
      `ifdef SLV_11
      	  ps11_psel,
      	  ps11_prdata,
      	  ps11_pready,
      	  ps11_pslverr,
      `endif
      `ifdef SLV_12
      	  ps12_psel,
      	  ps12_prdata,
      	  ps12_pready,
      	  ps12_pslverr,
      `endif
      `ifdef SLV_13
      	  ps13_psel,
      	  ps13_prdata,
      	  ps13_pready,
      	  ps13_pslverr,
      `endif
      `ifdef SLV_14
      	  ps14_psel,
      	  ps14_prdata,
      	  ps14_pready,
      	  ps14_pslverr,
      `endif
      `ifdef SLV_15
      	  ps15_psel,
      	  ps15_prdata,
      	  ps15_pready,
      	  ps15_pslverr,
      `endif
      `ifdef SLV_16
      	  ps16_psel,
      	  ps16_prdata,
      	  ps16_pready,
      	  ps16_pslverr,
      `endif
      `ifdef SLV_17
      	  ps17_psel,
      	  ps17_prdata,
      	  ps17_pready,
      	  ps17_pslverr,
      `endif
      `ifdef SLV_18
      	  ps18_psel,
      	  ps18_prdata,
      	  ps18_pready,
      	  ps18_pslverr,
      `endif
      `ifdef SLV_19
      	  ps19_psel,
      	  ps19_prdata,
      	  ps19_pready,
      	  ps19_pslverr,
      `endif
      `ifdef SLV_20
      	  ps20_psel,
      	  ps20_prdata,
      	  ps20_pready,
      	  ps20_pslverr,
      `endif
      `ifdef SLV_21
      	  ps21_psel,
      	  ps21_prdata,
      	  ps21_pready,
      	  ps21_pslverr,
      `endif
      `ifdef SLV_22
      	  ps22_psel,
      	  ps22_prdata,
      	  ps22_pready,
      	  ps22_pslverr,
      `endif
      `ifdef SLV_23
      	  ps23_psel,
      	  ps23_prdata,
      	  ps23_pready,
      	  ps23_pslverr,
      `endif
      `ifdef SLV_24
      	  ps24_psel,
      	  ps24_prdata,
      	  ps24_pready,
      	  ps24_pslverr,
      `endif
      `ifdef SLV_25
      	  ps25_psel,
      	  ps25_prdata,
      	  ps25_pready,
      	  ps25_pslverr,
      `endif
      `ifdef SLV_26
      	  ps26_psel,
      	  ps26_prdata,
      	  ps26_pready,
      	  ps26_pslverr,
      `endif
      `ifdef SLV_27
      	  ps27_psel,
      	  ps27_prdata,
      	  ps27_pready,
      	  ps27_pslverr,
      `endif
      `ifdef SLV_28
      	  ps28_psel,
      	  ps28_prdata,
      	  ps28_pready,
      	  ps28_pslverr,
      `endif
      `ifdef SLV_29
      	  ps29_psel,
      	  ps29_prdata,
      	  ps29_pready,
      	  ps29_pslverr,
      `endif
      `ifdef SLV_30
      	  ps30_psel,
      	  ps30_prdata,
      	  ps30_pready,
      	  ps30_pslverr,
      `endif
      `ifdef SLV_31
      	  ps31_psel,
      	  ps31_prdata,
      	  ps31_pready,
      	  ps31_pslverr,
      `endif
      	  hclk,
      	  hresetn,
      	  hsel,
      	  hready_in,
      	  htrans,
      	  haddr,
      	  hsize,
      	  hprot,
      	  hwrite,
      	  hwdata,
      	  apb2ahb_clken,
      	  hrdata,
      	  hready,
      	  hresp,
      	  pclk,
      	  presetn,
      	  pprot,
      	  pstrb,
      	  paddr,
      	  penable,
      	  pwrite,
      	  pwdata
      );

      `ifdef SLV_1
      output			        ps1_psel;
      input [31:0]		    ps1_prdata;
      input			          ps1_pready;
      input			          ps1_pslverr;
      `endif
      `ifdef SLV_2
      output			        ps2_psel;
      input [31:0]		    ps2_prdata;
      input			          ps2_pready;
      input			          ps2_pslverr;
      `endif
      `ifdef SLV_3
      output			        ps3_psel;
      input [31:0]		    ps3_prdata;
      input			          ps3_pready;
      input			          ps3_pslverr;
      `endif
      `ifdef SLV_4
      output			        ps4_psel;
      input [31:0]		    ps4_prdata;
      input			          ps4_pready;
      input			          ps4_pslverr;
      `endif
      `ifdef SLV_5
      output			        ps5_psel;
      input [31:0]		    ps5_prdata;
      input			          ps5_pready;
      input			          ps5_pslverr;
      `endif
      `ifdef SLV_6
      output			        ps6_psel;
      input [31:0]		    ps6_prdata;
      input			          ps6_pready;
      input			          ps6_pslverr;
      `endif
      `ifdef SLV_7
      output			        ps7_psel;
      input [31:0]		    ps7_prdata;
      input			          ps7_pready;
      input			          ps7_pslverr;
      `endif
      `ifdef SLV_8
      output			        ps8_psel;
      input [31:0]		    ps8_prdata;
      input			          ps8_pready;
      input			          ps8_pslverr;
      `endif
      `ifdef SLV_9
      output			        ps9_psel;
      input [31:0]		    ps9_prdata;
      input			          ps9_pready;
      input			          ps9_pslverr;
      `endif
      `ifdef SLV_10
      output			        ps10_psel;
      input [31:0]		    ps10_prdata;
      input			          ps10_pready;
      input			          ps10_pslverr;
      `endif
      `ifdef SLV_11
      output			        ps11_psel;
      input [31:0]		    ps11_prdata;
      input			          ps11_pready;
      input			          ps11_pslverr;
      `endif
      `ifdef SLV_12
      output			        ps12_psel;
      input [31:0]		    ps12_prdata;
      input			          ps12_pready;
      input			          ps12_pslverr;
      `endif
      `ifdef SLV_13
      output			        ps13_psel;
      input [31:0]		    ps13_prdata;
      input			          ps13_pready;
      input			          ps13_pslverr;
      `endif
      `ifdef SLV_14
      output			        ps14_psel;
      input [31:0]		    ps14_prdata;
      input			          ps14_pready;
      input			          ps14_pslverr;
      `endif
      `ifdef SLV_15
      output			        ps15_psel;
      input [31:0]		    ps15_prdata;
      input			          ps15_pready;
      input			          ps15_pslverr;
      `endif
      `ifdef SLV_16
      output			        ps16_psel;
      input [31:0]		    ps16_prdata;
      input			          ps16_pready;
      input			          ps16_pslverr;
      `endif
      `ifdef SLV_17
      output			        ps17_psel;
      input [31:0]		    ps17_prdata;
      input			          ps17_pready;
      input			          ps17_pslverr;
      `endif
      `ifdef SLV_18
      output			        ps18_psel;
      input [31:0]		    ps18_prdata;
      input			          ps18_pready;
      input			          ps18_pslverr;
      `endif
      `ifdef SLV_19
      output			        ps19_psel;
      input [31:0]		    ps19_prdata;
      input			          ps19_pready;
      input			          ps19_pslverr;
      `endif
      `ifdef SLV_20
      output			        ps20_psel;
      input [31:0]		    ps20_prdata;
      input			          ps20_pready;
      input			          ps20_pslverr;
      `endif
      `ifdef SLV_21
      output			        ps21_psel;
      input [31:0]		    ps21_prdata;
      input			          ps21_pready;
      input			          ps21_pslverr;
      `endif
      `ifdef SLV_22
      output			        ps22_psel;
      input [31:0]		    ps22_prdata;
      input			          ps22_pready;
      input			          ps22_pslverr;
      `endif
      `ifdef SLV_23
      output			        ps23_psel;
      input [31:0]		    ps23_prdata;
      input			          ps23_pready;
      input			          ps23_pslverr;
      `endif
      `ifdef SLV_24
      output			        ps24_psel;
      input [31:0]		    ps24_prdata;
      input			          ps24_pready;
      input			          ps24_pslverr;
      `endif
      `ifdef SLV_25
      output			        ps25_psel;
      input [31:0]		    ps25_prdata;
      input			          ps25_pready;
      input			          ps25_pslverr;
      `endif
      `ifdef SLV_26
      output			        ps26_psel;
      input [31:0]		    ps26_prdata;
      input			          ps26_pready;
      input			          ps26_pslverr;
      `endif
      `ifdef SLV_27
      output			        ps27_psel;
      input [31:0]		    ps27_prdata;
      input			          ps27_pready;
      input			          ps27_pslverr;
      `endif
      `ifdef SLV_28
      output			        ps28_psel;
      input [31:0]		    ps28_prdata;
      input			          ps28_pready;
      input			          ps28_pslverr;
      `endif
      `ifdef SLV_29
      output			        ps29_psel;
      input [31:0]		    ps29_prdata;
      input			          ps29_pready;
      input			          ps29_pslverr;
      `endif
      `ifdef SLV_30
      output			        ps30_psel;
      input [31:0]		    ps30_prdata;
      input			          ps30_pready;
      input			          ps30_pslverr;
      `endif
      `ifdef SLV_31
      output			        ps31_psel;
      input [31:0]		    ps31_prdata;
      input			          ps31_pready;
      input			          ps31_pslverr;
      `endif
      
      input				        hclk;
      input				        hresetn;
      input				        hsel;
      input				        hready_in;
      input	[1:0]			    htrans;
      input	[`ADDR_MSB:0] haddr;
      input	[2:0]			    hsize;
      input	[3:0]		  	  hprot;
      input				        hwrite;
      input	[31:0]			  hwdata;
      input				        apb2ahb_clken;
      output	[31:0]			hrdata;
      output				      hready;
      output	[1:0]			  hresp;
      
      input				        pclk;
      input				        presetn;
      output[2:0]			    pprot;
      output[3:0]			    pstrb;
      output[`ADDR_MSB:0] paddr;
      output				      penable;
      output				      pwrite;
      output	[31:0]			pwdata;

  `getname(AHB_to_APB_32_bridge,`module_name) u_AHB_to_APB_32_bridge (
  `ifdef SLV_1
    .ps1_psel       ( ps1_psel      ),
    .ps1_prdata     ( ps1_prdata    ),
    .ps1_pready     ( ps1_pready    ),
    .ps1_pslverr    ( ps1_pslverr   ),
  `endif
  `ifdef SLV_2
    .ps2_psel       ( ps2_psel      ),
    .ps2_prdata     ( ps2_prdata    ),
    .ps2_pready     ( ps2_pready    ),
    .ps2_pslverr    ( ps2_pslverr   ),
  `endif
  `ifdef SLV_3
    .ps3_psel       ( ps3_psel      ),
    .ps3_prdata     ( ps3_prdata    ),
    .ps3_pready     ( ps3_pready    ),
    .ps3_pslverr    ( ps3_pslverr   ),
  `endif
  `ifdef SLV_4
    .ps4_psel       ( ps4_psel      ),
    .ps4_prdata     ( ps4_prdata    ),
    .ps4_pready     ( ps4_pready    ),
    .ps4_pslverr    ( ps4_pslverr   ),
  `endif
  `ifdef SLV_5
    .ps5_psel       ( ps5_psel      ),
    .ps5_prdata     ( ps5_prdata    ),
    .ps5_pready     ( ps5_pready    ),
    .ps5_pslverr    ( ps5_pslverr   ),
  `endif
  `ifdef SLV_6
    .ps6_psel       ( ps6_psel      ),
    .ps6_prdata     ( ps6_prdata    ),
    .ps6_pready     ( ps6_pready    ),
    .ps6_pslverr    ( ps6_pslverr   ),
  `endif
  `ifdef SLV_7
    .ps7_psel       ( ps7_psel      ),
    .ps7_prdata     ( ps7_prdata    ),
    .ps7_pready     ( ps7_pready    ),
    .ps7_pslverr    ( ps7_pslverr   ),
  `endif
  `ifdef SLV_8
    .ps8_psel       ( ps8_psel      ),
    .ps8_prdata     ( ps8_prdata    ),
    .ps8_pready     ( ps8_pready    ),
    .ps8_pslverr    ( ps8_pslverr   ),
  `endif
  `ifdef SLV_9
    .ps9_psel       ( ps9_psel      ),
    .ps9_prdata     ( ps9_prdata    ),
    .ps9_pready     ( ps9_pready    ),
    .ps9_pslverr    ( ps9_pslverr   ),
  `endif
  `ifdef SLV_10
    .ps10_psel      ( ps10_psel     ),
    .ps10_prdata    ( ps10_prdata   ),
    .ps10_pready    ( ps10_pready   ),
    .ps10_pslverr   ( ps10_pslverr  ),
  `endif
  `ifdef SLV_11
    .ps11_psel      ( ps11_psel     ),
    .ps11_prdata    ( ps11_prdata   ),
    .ps11_pready    ( ps11_pready   ),
    .ps11_pslverr   ( ps11_pslverr  ),
  `endif
  `ifdef SLV_12
    .ps12_psel      ( ps12_psel     ),
    .ps12_prdata    ( ps12_prdata   ),
    .ps12_pready    ( ps12_pready   ),
    .ps12_pslverr   ( ps12_pslverr  ),
  `endif
  `ifdef SLV_13
    .ps13_psel      ( ps13_psel     ),
    .ps13_prdata    ( ps13_prdata   ),
    .ps13_pready    ( ps13_pready   ),
    .ps13_pslverr   ( ps13_pslverr  ),
  `endif
  `ifdef SLV_14
    .ps14_psel      ( ps14_psel     ),
    .ps14_prdata    ( ps14_prdata   ),
    .ps14_pready    ( ps14_pready   ),
    .ps14_pslverr   ( ps14_pslverr  ),
  `endif
  `ifdef SLV_15
    .ps15_psel      ( ps15_psel     ),
    .ps15_prdata    ( ps15_prdata   ),
    .ps15_pready    ( ps15_pready   ),
    .ps15_pslverr   ( ps15_pslverr  ),
  `endif
  `ifdef SLV_16
    .ps16_psel      ( ps16_psel     ),
    .ps16_prdata    ( ps16_prdata   ),
    .ps16_pready    ( ps16_pready   ),
    .ps16_pslverr   ( ps16_pslverr  ),
  `endif
  `ifdef SLV_17
    .ps17_psel      ( ps17_psel     ),
    .ps17_prdata    ( ps17_prdata   ),
    .ps17_pready    ( ps17_pready   ),
    .ps17_pslverr   ( ps17_pslverr  ),
  `endif
  `ifdef SLV_18
    .ps18_psel      ( ps18_psel     ),
    .ps18_prdata    ( ps18_prdata   ),
    .ps18_pready    ( ps18_pready   ),
    .ps18_pslverr   ( ps18_pslverr  ),
  `endif
  `ifdef SLV_19
    .ps19_psel      ( ps19_psel     ),
    .ps19_prdata    ( ps19_prdata   ),
    .ps19_pready    ( ps19_pready   ),
    .ps19_pslverr   ( ps19_pslverr  ),
  `endif
  `ifdef SLV_20
    .ps20_psel      ( ps20_psel     ),
    .ps20_prdata    ( ps20_prdata   ),
    .ps20_pready    ( ps20_pready   ),
    .ps20_pslverr   ( ps20_pslverr  ),
  `endif
  `ifdef SLV_21
    .ps21_psel      ( ps21_psel     ),
    .ps21_prdata    ( ps21_prdata   ),
    .ps21_pready    ( ps21_pready   ),
    .ps21_pslverr   ( ps21_pslverr  ),
  `endif
  `ifdef SLV_22
    .ps22_psel      ( ps22_psel     ),
    .ps22_prdata    ( ps22_prdata   ),
    .ps22_pready    ( ps22_pready   ),
    .ps22_pslverr   ( ps22_pslverr  ),
  `endif
  `ifdef SLV_23
    .ps23_psel      ( ps23_psel     ),
    .ps23_prdata    ( ps23_prdata   ),
    .ps23_pready    ( ps23_pready   ),
    .ps23_pslverr   ( ps23_pslverr  ),
  `endif
  `ifdef SLV_24
    .ps24_psel      ( ps24_psel     ),
    .ps24_prdata    ( ps24_prdata   ),
    .ps24_pready    ( ps24_pready   ),
    .ps24_pslverr   ( ps24_pslverr  ),
  `endif
  `ifdef SLV_25
    .ps25_psel      ( ps25_psel     ),
    .ps25_prdata    ( ps25_prdata   ),
    .ps25_pready    ( ps25_pready   ),
    .ps25_pslverr   ( ps25_pslverr  ),
  `endif
  `ifdef SLV_26
    .ps26_psel      ( ps26_psel     ),
    .ps26_prdata    ( ps26_prdata   ),
    .ps26_pready    ( ps26_pready   ),
    .ps26_pslverr   ( ps26_pslverr  ),
  `endif
  `ifdef SLV_27
    .ps27_psel      ( ps27_psel     ),
    .ps27_prdata    ( ps27_prdata   ),
    .ps27_pready    ( ps27_pready   ),
    .ps27_pslverr   ( ps27_pslverr  ),
  `endif
  `ifdef SLV_28
    .ps28_psel      ( ps28_psel     ),
    .ps28_prdata    ( ps28_prdata   ),
    .ps28_pready    ( ps28_pready   ),
    .ps28_pslverr   ( ps28_pslverr  ),
  `endif
  `ifdef SLV_29
    .ps29_psel      ( ps29_psel     ),
    .ps29_prdata    ( ps29_prdata   ),
    .ps29_pready    ( ps29_pready   ),
    .ps29_pslverr   ( ps29_pslverr  ),
  `endif
  `ifdef SLV_30
    .ps30_psel      ( ps30_psel     ),
    .ps30_prdata    ( ps30_prdata   ),
    .ps30_pready    ( ps30_pready   ),
    .ps30_pslverr   ( ps30_pslverr  ),
  `endif
  `ifdef SLV_31
    .ps31_psel      ( ps31_psel     ),
    .ps31_prdata    ( ps31_prdata   ),
    .ps31_pready    ( ps31_pready   ),
    .ps31_pslverr   ( ps31_pslverr  ),
  `endif
    .hclk           ( hclk          ),
    .hresetn        ( hresetn       ),
    .hsel           ( hsel          ),
    .hready_in      ( hready_in     ),
    .htrans         ( htrans        ),
    .haddr          ( haddr         ),
    .hsize          ( hsize         ),
    .hprot          ( hprot         ),
    .hwrite         ( hwrite        ),
    .hwdata         ( hwdata        ),
    .apb2ahb_clken  ( apb2ahb_clken ),
    .hrdata         ( hrdata        ),
    .hready         ( hready        ),
    .hresp          ( hresp         ),
    .pclk           ( pclk          ),
    .presetn        ( presetn       ),
    .pprot          ( pprot         ),
    .pstrb          ( pstrb         ),
    .paddr          ( paddr         ),
    .penable        ( penable       ),
    .pwrite         ( pwrite        ),
    .pwdata         ( pwdata        )
  );

endmodule
