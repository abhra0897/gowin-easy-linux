//
// This file contains modules used for XMR processing
// Specific to Synopsys. 
// Copyright (c) 2010, Synopsys, Inc. All rights reserved
//
//

/* connect to a signal you want to export example : in1*/
module syn_hyper_source(in1) /* synthesis syn_black_box syn_noprune=1 */;
  parameter w = 1;
  parameter tag = "tag_name"; /* global name of hyper_source */
  input [w-1:0] in1;
endmodule

/* use to access hyper_source and drive a local signal or port example :out1 */
module syn_hyper_connect(out1) /* synthesis syn_black_box syn_noprune=1 */;
  parameter w = 1; /* width must match source */
  parameter tag = "tag_name"; /* global name or instance path to hyper_source */
  parameter dflt = 5;
  parameter mustconnect = 1'b1;
  output [w-1:0] out1  /* synthesis syn_tristate=1 */;
endmodule

/* This module is for internal use of the tool. Behavior is undefined, if this module is instantiated in RTL. */
module syn_hyper_source_internal(in1) /* synthesis syn_black_box syn_noprune=1 */;
  parameter w = 1;
  input [w-1:0] in1;
endmodule

/* This module is for internal use of the tool. Behavior is undefined, if this module is instantiated in RTL. */
module syn_hyper_connect_internal(out1) /* synthesis syn_black_box syn_noprune=1 mustconnect="1'b1" dflt=5*/;
  parameter w = 1; /* width must match source */
  output [w-1:0] out1  /* synthesis syn_tristate=1 */;
endmodule
