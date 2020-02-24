//-----------------------------------------------------------------------------
// Copyright (C) 2001-2015 Synopsys, Inc.
// This IP and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this IP is 
// subject to the terms and conditions of a written license agreement 
// between you, or your company, and Synopsys, Inc.
//-----------------------------------------------------------------------------
// Title      : CAPIMs for UMRBus
// Project    : UMRBus
//-----------------------------------------------------------------------------
// Includes   
// For user RTL	: capim       : standard  CAPIM
//	      	: capim_ui    : CAPIM with user ports only, easier to use
//	   	: capim_wp    : CAPIM with runtime changeable address and type
//	        : capim_wp_ui : user port only verison of CAPIM with runtime changeable address and type
//-----------------------------------------------------------------------------
// File       : umr_capim.v
//-----------------------------------------------------------------------------
//         $Id: //chipit/chipit/main/dev/tools/xactors/modules/capim/umr_capim.v#2 $
//     $Author: slasch $
//   $DateTime: 2012/02/01 05:23:29 $
//-----------------------------------------------------------------------------

`timescale 1ps / 1ps

module capim (
              clk,
              reset,
              umr_in_dat,
              umr_in_en,
              umr_in_valid,
              umr_out_dat,
              umr_out_en,
              umr_out_valid,
              wr,
              dout,
              rd,
              din,
              intr,
              inta,
              inttype)
  /* synthesis .syn_hypernoprune=1 .syn_builtin_du="weak"  .syn_builtin_allow_modgen=1 syn_noprune=1 syn_hier="fixed" rbp_donotdisssolve=1 .certify_slp_dont_write_view=1 haps_ip_type="umr_capim" */;

   parameter UMR_CAPIM_ADDRESS        = 0;    /* valid range 1 to 63 */
   parameter UMR_CAPIM_TYPE           = 0;    /* Valid user range 0x8000 to 0XFFFF; reserved 0x0001 to 07FFF */
`ifdef SYSTEM_UMR_DATA_BITWIDTH
   parameter UMR_DATA_BITWIDTH        = `SYSTEM_UMR_DATA_BITWIDTH;
`else
   parameter UMR_DATA_BITWIDTH        = 8;    /* 8 bit for HASPS-60/70/80 ; 32 for direct UMR */
`endif
   parameter UMR_CAPIM_COMMENT_STRING = "NA"; /* Allow user to specify the use of capim */
`ifdef SYSTEM_UMR_BUS_TYPE
   parameter UMR_BUS_TYPE             = `SYSTEM_UMR_BUS_TYPE;
`else
   parameter UMR_BUS_TYPE             = 0;    /* 0 - system UMR, 1 - direct UMR */
`endif

   input 	    clk; 
   input 	    reset; 
   input [UMR_DATA_BITWIDTH - 1:0] umr_in_dat; 
   input 			   umr_in_en; 
   input 			   umr_in_valid; 
   output [UMR_DATA_BITWIDTH - 1:0] umr_out_dat; 
   wire [UMR_DATA_BITWIDTH - 1:0]   umr_out_dat;
   output 			    umr_out_en; 
   wire 			    umr_out_en;
   output 			    umr_out_valid; 
   wire 			    umr_out_valid;
   output 			    wr; 
   reg 				    wr;
   output [31:0] 		    dout; 
   reg [31:0] 			    dout;
   output 			    rd; 
   reg 				    rd;
   input [31:0] 		    din; 
   input 			    intr; 
   output 			    inta; 
   wire 			    inta;
   input [15:0] 		    inttype; 
   reg [31:0] 			    inreg_data        /* synthesis syn_srlstyle="registers" */; 
   reg [(32 / UMR_DATA_BITWIDTH - 1):0] inreg_en      /* synthesis syn_srlstyle="registers" */;
   reg [(32 / UMR_DATA_BITWIDTH - 1):0] inreg_valid   /* synthesis syn_srlstyle="registers" */; 
   wire 				valid; 
   reg [31:0] 				outreg_data   /* synthesis syn_srlstyle="registers" */ ; 
   reg [31:0] 				outreg_din; 
   wire [31:0] 				scan_data; 
   wire [31:0] 				int_data; 
   wire [31:0] 				data; 
   wire [6:0] 				add_data; 
   reg 					outreg_en     /* synthesis syn_srlstyle="registers" */ ; 
   reg 					outreg_valid  /* synthesis syn_srlstyle="registers" */ ; 
   reg 					outreg_snl; 
   wire 				rd_int; 
   wire 				wr_int; 
   reg 					frmdata; 
   wire 				frmdataval; 
   reg 					scanintsel; 
   wire 				scanintrd; 
   reg [1:0] 				int_aktiv; 
   reg [5:0] 				capim_aktiv; 
   wire 				datval; 
   reg [4:0] 				datvalcnt; 
   reg [6:0] 				wordcnt; 
   wire 				wordval; 
   reg [31:0] 				out_data     /* synthesis syn_srlstyle="registers" */ ; 
   reg 					out_en       /* synthesis syn_srlstyle="registers" */ ; 
   reg 					out_valid    /* synthesis syn_srlstyle="registers" */ ; 
   reg 					out_snl; 
   reg 					rd_valid; 
   wire [31:32 - UMR_DATA_BITWIDTH] 	outreg_data_zero = 0;
   
   generate
      if (UMR_DATA_BITWIDTH != 32)
         always @(posedge clk or posedge reset)
            begin : p_inreg_lt32
               if (reset == 1'b1)
                  begin
         	     inreg_data <= {32{1'b0}} ; 
         	     inreg_en <= {(32 / UMR_DATA_BITWIDTH - 1)-(0)+1{1'b0}} ; 
         	     inreg_valid <= {(32 / UMR_DATA_BITWIDTH - 1)-(0)+1{1'b0}} ; 
         	  end
               else
         	  begin
         	     inreg_data[31:32 - UMR_DATA_BITWIDTH] <= umr_in_dat ; 
         	     inreg_en[32 / UMR_DATA_BITWIDTH - 1] <= umr_in_en ; 
         	     inreg_valid[32 / UMR_DATA_BITWIDTH - 1] <= umr_in_valid ; 
       		     case (UMR_DATA_BITWIDTH)
                        1:  inreg_data[31 - 1:0]  <= inreg_data[31:1];
         		2:  inreg_data[31 - 2:0]  <= inreg_data[31:2];
         		4:  inreg_data[31 - 4:0]  <= inreg_data[31:4];
         		8:  inreg_data[31 - 8:0]  <= inreg_data[31:8];
         		16: inreg_data[31 - 16:0] <= inreg_data[31:16];
                       default:;
         	     endcase
         	     inreg_en[(32 / UMR_DATA_BITWIDTH - 2):0] <= inreg_en[(32 / UMR_DATA_BITWIDTH - 1):1] ; 
         	     inreg_valid[(32 / UMR_DATA_BITWIDTH - 2):0] <= inreg_valid[(32 / UMR_DATA_BITWIDTH - 1):1] ; 
       	          end 
            end
      else
         always @(posedge clk or posedge reset)
            begin : p_inreg_32
               if (reset == 1'b1)
                  begin
         	     inreg_data <= {32{1'b0}} ; 
         	     inreg_en <= {(32 / UMR_DATA_BITWIDTH - 1)-(0)+1{1'b0}} ; 
         	     inreg_valid <= {(32 / UMR_DATA_BITWIDTH - 1)-(0)+1{1'b0}} ; 
         	  end
               else
         	  begin
         	     inreg_data[31:32 - UMR_DATA_BITWIDTH] <= umr_in_dat ; 
         	     inreg_en[32 / UMR_DATA_BITWIDTH - 1] <= umr_in_en ; 
         	     inreg_valid[32 / UMR_DATA_BITWIDTH - 1] <= umr_in_valid ; 
       	          end 
            end
   endgenerate
   assign valid = ((inreg_valid[(32 / UMR_DATA_BITWIDTH - 1)]) == 1'b1) ? 1'b1 : 1'b0 ;
   always @(posedge clk or posedge reset)
      begin : p_outreg
	 if (reset == 1'b1)
	    begin
	       outreg_data <= {32{1'b0}} ; 
	       outreg_en <= 1'b0 ; 
	       outreg_valid <= 1'b0 ; 
	    end
	 else
	    begin
	       outreg_data <= outreg_din ; 
	       outreg_en <= inreg_en[0] ; 
	       outreg_valid <= inreg_valid[0] ; 
	    end 
      end 
   // data sources
   assign add_data = inreg_data[6:0] + 1 ;
   assign scan_data[31:16] = UMR_CAPIM_TYPE;
   assign scan_data[15:7] = inreg_data[15:7] ;
   assign scan_data[6:0] = add_data ;
   assign int_data[31:16] = inttype ;
   assign int_data[15:7] = inreg_data[15:7] ;
   assign int_data[6:0] = add_data ;
   assign data[31:1] = inreg_data[31:1] ;
   assign data[0] = ((int_aktiv[1]) == 1'b0 & intr == 1'b1 & (inreg_en[0]) == 1'b0) ? 1'b1 : inreg_data[0] ;
   always @(capim_aktiv or data or int_aktiv or int_data or scan_data or wordval)
      begin : p_datasrc
	 if ((capim_aktiv[3]) == 1'b1 & wordval == 1'b1 & (int_aktiv[0]) == 1'b1)
	    begin
	       // int
	       outreg_din = int_data ; 
	    end
	 else if ((capim_aktiv[4]) == 1'b1 & wordval == 1'b1)
	    begin
	       // scan
	       outreg_din = scan_data ; 
	    end
	 else
	    begin
	       outreg_din = data ; 
	    end 
      end 
   always @(capim_aktiv or datval or frmdataval or inreg_en or int_aktiv or 
	    scanintrd)
      begin : p_outreg_snl
	 if ((capim_aktiv[2]) == 1'b1 & datval == 1'b0 & frmdataval == 1'b1 & (inreg_en[0]) == 1'b1)
	    begin
	       // read
	       outreg_snl = 1'b1 ; 
	    end
	 else if ((capim_aktiv[3]) == 1'b1 & datval == 1'b0 & scanintrd == 1'b1 & (int_aktiv[0]) == 1'b1 & (inreg_en[0]) == 1'b1)
	    begin
	       // int
	       outreg_snl = 1'b1 ; 
	    end
	 else if ((capim_aktiv[4]) == 1'b1 & datval == 1'b0 & scanintrd == 1'b1 & (inreg_en[0]) == 1'b1)
	    begin
	       // scan
	       outreg_snl = 1'b1 ; 
	    end
	 else
	    begin
	       outreg_snl = 1'b0 ; 
	    end 
      end 
   always @(posedge clk or posedge reset)
      begin : P_out
	 if (reset == 1'b1)
	    begin
	       out_data <= {32{1'b0}} ; 
	       out_en <= 1'b0 ; 
	       out_valid <= 1'b0 ; 
	       out_snl <= 1'b0 ; 
	    end
	 else
	    begin
	       if (out_snl == 1'b0)
		  begin
		     if (rd_valid == 1'b1)
			begin
			   out_data <= din ; 
			end
		     else
			begin
			   out_data <= outreg_data ; 
			end 
		  end
	       else
		  begin
		     if (UMR_DATA_BITWIDTH < 32)
			begin
			   // out_data[31 - UMR_DATA_BITWIDTH:0] <= out_data[31:UMR_DATA_BITWIDTH] ;
			   case (UMR_DATA_BITWIDTH)
			     1: out_data[31 - 1:0] <= out_data[31:1] ;
			     2: out_data[31 - 2:0] <= out_data[31:2] ;
			     4: out_data[31 - 4:0] <= out_data[31:4] ;
			     8: out_data[31 - 8:0] <= out_data[31:8] ;
			     16: out_data[31 - 16:0] <= out_data[31:16] ;
                             default:;
			   endcase
			end 
		  end 
	       out_en <= outreg_en ; 
	       out_valid <= outreg_valid ; 
	       out_snl <= outreg_snl ; 
	    end 
      end 
   assign umr_out_dat = out_data[UMR_DATA_BITWIDTH - 1:0] ;
   assign umr_out_en = out_en ;
   assign umr_out_valid = out_valid ;
   always @(posedge clk or posedge reset)
      begin : p_aktivate
	 if (reset == 1'b1)
	    begin
	       capim_aktiv <= 6'b000001 ; // wait for operation
	    end
	 else
	    begin
	       if ((inreg_en[0]) == 1'b1 & (capim_aktiv[0]) == 1'b1 & valid == 1'b1)
		  begin
		     if (inreg_data[13:8] == UMR_CAPIM_ADDRESS)
			begin
			   if (inreg_data[7:4] == 4'b0001)
			      begin
				 capim_aktiv <= 6'b000010 ; // write frame operation
			      end
			   else if (inreg_data[7:4] == 4'b0010)
			      begin
				 capim_aktiv <= 6'b000100 ; // read frame operation
			      end
			   else
			      begin
				 capim_aktiv <= 6'b100000 ; // idle
			      end 
			end
		     else if (inreg_data[13:8] == 6'b000000)
			begin
			   if (inreg_data[7:4] == 4'b0110)
			      begin
				 capim_aktiv <= 6'b010000 ; // scan frame operation
			      end
			   else if (inreg_data[7:4] == 4'b1010)
			      begin
				 capim_aktiv <= 6'b001000 ; // int frame operation
			      end
			   else
			      begin
				 capim_aktiv <= 6'b100000 ; // idle
			      end 
			end
		     else
			begin
			   capim_aktiv <= 6'b100000 ; // idle
			end 
		  end
	       else if ((inreg_en[0]) == 1'b0)
		  begin
		     capim_aktiv <= 6'b000001 ; // wait for operation
		  end 
	    end 
      end 
   always @(posedge clk or posedge reset)
      begin : p_interrupt
	 if (reset == 1'b1)
	    begin
	       int_aktiv <= {2{1'b0}} ; 
	    end
	 else
	    begin
	       if (int_aktiv == 2'b00 & intr == 1'b1 & scanintrd == 1'b0)
		  begin
		     int_aktiv <= 2'b01 ; 
		  end
	       else if (int_aktiv == 2'b01 & (capim_aktiv[3]) == 1'b1 & scanintrd == 1'b1)
		  begin
		     int_aktiv <= 2'b11 ; 
		  end
	       else if (int_aktiv == 2'b11 & scanintrd == 1'b0)
		  begin
		     int_aktiv <= 2'b10 ; 
		  end
	       else if (int_aktiv == 2'b10 & intr == 1'b0)
		  begin
		     int_aktiv <= 2'b00 ; 
		  end 
	    end 
      end 
   assign inta = (int_aktiv == 2'b10) ? 1'b1 : 1'b0 ;
   always @(posedge clk or posedge reset)
      begin : p_datvalid
	 if (reset == 1'b1)
	    begin
	       datvalcnt <= 0 ; 
	    end
	 else
	    begin
	       if ((capim_aktiv[0]) == 1'b1 | datval == 1'b1)
		  begin
		     datvalcnt <= 0 ; 
		  end
	       else if (valid == 1'b1)
		  begin
		     datvalcnt <= datvalcnt + 1 ; 
		  end 
	    end 
      end 
   assign datval = (datvalcnt == (32 / UMR_DATA_BITWIDTH - 1) & (inreg_valid[0]) == 1'b1) ? 1'b1 : 1'b0 ;
   always @(posedge clk or posedge reset)
      begin : p_frmdata
	 if (reset == 1'b1)
	    begin
	       frmdata <= 1'b0 ; 
	    end
	 else
	    begin
	       if ((capim_aktiv[0]) == 1'b1)
		  begin
		     frmdata <= 1'b0 ; 
		  end
	       else if (frmdataval == 1'b1)
		  begin
		     frmdata <= 1'b1 ; 
		  end 
	    end 
      end 
   assign frmdataval = (datvalcnt == (32 / UMR_DATA_BITWIDTH - 1) | frmdata == 1'b1) ? 1'b1 : 1'b0 ;
   // write data
   always @(posedge clk or posedge reset)
      begin : P_write_data
	 if (reset == 1'b1)
	    begin
	       dout <= {32{1'b0}} ; 
	       wr <= 1'b0 ; 
	    end
	 else
	    begin
	       if (wr_int == 1'b1)
		  begin
		     dout <= inreg_data ; 
		  end 
	       wr <= wr_int ; 
	    end 
      end 
   assign wr_int = ((capim_aktiv[1]) == 1'b1 & datval == 1'b1 & (inreg_en[0]) == 1'b1) ? 1'b1 : 1'b0 ;
   // read data
   always @(posedge clk or posedge reset)
      begin : P_read_data
	 if (reset == 1'b1)
	    begin
	       rd <= 1'b0 ; 
	       rd_valid <= 1'b0 ; 
	    end
	 else
	    begin
	       rd <= rd_int ; 
	       rd_valid <= capim_aktiv[2] & rd_int ; 
	    end 
      end 
   assign rd_int = ((capim_aktiv[2]) == 1'b1 & datval == 1'b1 & (inreg_en[0]) == 1'b1) ? 1'b1 : 1'b0 ;
   always @(posedge clk or posedge reset)
      begin : p_wordcnt
	 if (reset == 1'b1)
	    begin
	       wordcnt <= 0 ; 
	    end
	 else
	    begin
	       if ((capim_aktiv[0]) == 1'b1)
		  begin
		     wordcnt <= 0 ; 
		  end
	       else if (datval == 1'b1 & ((capim_aktiv[3]) == 1'b1 | (capim_aktiv[4]) == 1'b1))
		  begin
		     wordcnt <= wordcnt + 1 ; 
		  end 
	    end 
      end 
   always @(posedge clk or posedge reset)
      begin : p_scanintsel
	 if (reset == 1'b1)
	    begin
	       scanintsel <= 1'b0 ; 
	    end
	 else
	    begin
	       if ((capim_aktiv[0]) == 1'b1 | scanintrd == 1'b0)
		  begin
		     scanintsel <= 1'b0 ; 
		  end
	       else if (wordval == 1'b1)
		  begin
		     scanintsel <= 1'b1 ; 
		  end 
	    end 
      end 
   assign scanintrd = (wordval == 1'b1 | (scanintsel == 1'b1 & datval == 1'b0)) ? 1'b1 : 1'b0 ;
   assign wordval = (wordcnt == UMR_CAPIM_ADDRESS & datval == 1'b1) ? 1'b1 : 1'b0 ;
endmodule


//-----------------------------------------------------------------------------
//  XMR (hyper connect) to get access to UMR clock and reset
//-----------------------------------------------------------------------------
module umr_clk_reset(umr_clk_out, umr_reset_out)
  /* synthesis .syn_hypernoprune=1 .syn_builtin_allow_modgen=1 syn_noprune=1 rbp_donotdisssolve=1 */;
   
   output 	    	umr_clk_out;   // Use this as umr_clock source if needed for outisde logic
   output               umr_reset_out; // Use this as umr_clock source if needed for outisde logic

`ifdef UMR_SIM
   reg                  clk;
   reg                  reset;
   initial clk  = 1'b0;
   initial begin
      reset   = 1'b0;
      fork
         #50000    reset = 1'b1;
         #100000   reset = 1'b0;
      join
   end
   always #5000 clk   = ~clk;

   assign umr_clk_out   = clk;
   assign umr_reset_out = reset;
   
`else // !`ifdef UMR_SIM
   // use hyper connects to connect to umr clock & reset,
   syn_hyper_connect hstdm_umr_clk(umr_clk_out);
   defparam hstdm_umr_clk.tag = "umr_clk";
   defparam hstdm_umr_clk.mustconnect = 1;
   
   syn_hyper_connect hstdm_umr_reset(umr_reset_out);
   defparam hstdm_umr_reset.tag = "umr_reset";
   defparam hstdm_umr_reset.mustconnect = 1;
   defparam hstdm_umr_reset.dflt= 0;
`endif // !`ifdef UMR_SIM
endmodule 

//-----------------------------------------------------------------------------
// Description: CAPIM with user ports only. umr_clk and umr_reset are outputs
//              and can be used to drive local CAPIM interface logic.
//-----------------------------------------------------------------------------
module capim_ui (
                 umr_clk,
                 umr_reset,
                 wr,
                 dout,
                 rd,
                 din,
                 intr,
                 inta,
                 inttype)
/* synthesis .syn_hypernoprune=1 .syn_builtin_du="weak"  .syn_builtin_allow_modgen=1 syn_noprune=1 rbp_donotdisssolve=1 haps_ip_type="umr_capim"*/;
   
   parameter UMR_CAPIM_ADDRESS        = 0;    /* valid range 1 to 63 */
   parameter UMR_CAPIM_TYPE           = 0;    /* Valid user range 0x8000 to 0XFFFF; reserved 0x0001 to 07FFF */
`ifdef SYSTEM_UMR_DATA_BITWIDTH
   parameter UMR_DATA_BITWIDTH        = `SYSTEM_UMR_DATA_BITWIDTH;
`else
   parameter UMR_DATA_BITWIDTH        = 8;    /* 8 bit for HASPS-60/70/80 ; 32 for direct UMR */
`endif
   parameter UMR_CAPIM_COMMENT_STRING = "NA"; /* Allow user to specify the use of capim */
   parameter UMR_USE_LOCATION_ID      = 0;
`ifdef SYSTEM_UMR_BUS_TYPE
   parameter UMR_BUS_TYPE             = `SYSTEM_UMR_BUS_TYPE;
`else
   parameter UMR_BUS_TYPE             = 0;    /* 0 - system UMR, 1 - direct UMR */
`endif

   /* ports */
   output  	    umr_clk; 
   output 	    umr_reset; 
   output           wr; 
   output [31:0]    dout; 
   output           rd; 
   input [31:0]     din; 
   input            intr; 
   output           inta; 
   wire             inta;
   input [15:0]     inttype;
   
   /* internal UMRBus signals which will be driven by XMRs */
   wire [UMR_DATA_BITWIDTH - 1:0] umr_in_dat; 
   wire                           umr_in_en; 
   wire                           umr_in_valid; 
   wire [UMR_DATA_BITWIDTH - 1:0] umr_out_dat;
   wire                           umr_out_en;
   wire                           umr_out_valid;

   /* capim address and type */
   wire [5:0]                     umr_capim_address;
   wire [15:0]                    umr_capim_type;

   /* capim type is fixed */
   assign umr_capim_type = UMR_CAPIM_TYPE;

   /* capim address is variable depending on UMR_USE_LOCATION_ID */
   generate
  `ifdef UMR_SIM
      if (0)
  `else
   `ifdef UMR_USE_LOCATION_ID
      if (1)
   `else
      if (UMR_USE_LOCATION_ID == 1)
   `endif
  `endif
        begin
           wire [2:0]  fpga_loc_id;
           syn_hyper_connect #(.tag("haps_fpga_location_id"), .w(3)) hyper_fpga_loc_id(fpga_loc_id) /* synthesis .hyper_connect_after_level=50 */;
           
  `ifdef UMR_CHAIN_LIMIT4
           /* lower 3 bits are user defined */
           assign umr_capim_address[2:0] = UMR_CAPIM_ADDRESS;
           /* upper 2 bits depend on fpga location */
           assign umr_capim_address[4:3] = fpga_loc_id[1:0];
  `else   
           /* lower 2 bits are user defined */
           assign umr_capim_address[1:0] = UMR_CAPIM_ADDRESS;
           /* upper 3 bits depend on fpga location */
           assign umr_capim_address[4:2] = fpga_loc_id;
  `endif // !`ifdef UMR_CHAIN_LIMIT4
           
           /* bit5 is reserved for tool inserted CAPIMs (HSTDM, ...) */
           assign umr_capim_address[5]   = 1'b0;

           /* the CAPIM itself */
           capim_wp #(
                      .UMR_DATA_BITWIDTH(UMR_DATA_BITWIDTH),
                      .UMR_CAPIM_COMMENT_STRING(UMR_CAPIM_COMMENT_STRING),
                      .UMR_BUS_TYPE(UMR_BUS_TYPE)
                      )
           I_Capim(
                   .clk(umr_clk),
                   .reset(umr_reset),
                   .umr_capim_address(umr_capim_address),
                   .umr_capim_type(umr_capim_type),
                   .umr_in_dat(umr_in_dat),
                   .umr_in_en(umr_in_en),
                   .umr_in_valid(umr_in_valid),
                   .umr_out_dat(umr_out_dat),
                   .umr_out_en(umr_out_en),
                   .umr_out_valid(umr_out_valid),
                   .wr(wr),
                   .dout(dout),
                   .rd(rd),
                   .din(din),
                   .intr(intr),
                   .inta(inta),
                   .inttype(inttype)
                   );
           
        end // if (UMR_USE_LOCATION_ID == 1)
      else
        begin
           /* the CAPIM itself */
           capim #(
                   .UMR_CAPIM_ADDRESS(UMR_CAPIM_ADDRESS),
                   .UMR_CAPIM_TYPE(UMR_CAPIM_TYPE),
                   .UMR_DATA_BITWIDTH(UMR_DATA_BITWIDTH),
                   .UMR_CAPIM_COMMENT_STRING(UMR_CAPIM_COMMENT_STRING),
                   .UMR_BUS_TYPE(UMR_BUS_TYPE)
                   )
           I_Capim(
                   .clk(umr_clk),
                   .reset(umr_reset),
                   .umr_in_dat(umr_in_dat),
                   .umr_in_en(umr_in_en),
                   .umr_in_valid(umr_in_valid),
                   .umr_out_dat(umr_out_dat),
                   .umr_out_en(umr_out_en),
                   .umr_out_valid(umr_out_valid),
                   .wr(wr),
                   .dout(dout),
                   .rd(rd),
                   .din(din),
                   .intr(intr),
                   .inta(inta),
                   .inttype(inttype)
                   );
           
        end // else: !if(UMR_USE_LOCATION_ID == 1)
   endgenerate
      
`ifndef UMR_SIM
 `ifdef UMR_UMRPCIE
   syn_hyper_connect #(.tag("hyper_umr_clk"),   .w(1)) hyper_umr_clk(umr_clk);
   syn_hyper_connect #(.tag("hyper_umr_reset"), .w(1)) hyper_umr_reset(umr_reset);
 `else
   assign umr_in_dat   = umr_out_dat;
   assign umr_in_en    = umr_out_en;
   assign umr_in_valid = umr_out_valid;
   syn_hyper_connect #(.tag("umr_clk"),   .w(1)) hyper_umr_clk(umr_clk);
   syn_hyper_connect #(.tag("umr_reset"), .w(1)) hyper_umr_reset(umr_reset);
 `endif
`endif
   
   
endmodule // capim_ui


//-----------------------------------------------------------------------------
// Description: CAPIM with runtime changeable address and type.
//              The UMR_CAPIM_ADDRESS and UMR_CAPIM_TYPE parameters are
//              unused but necessary for Certify operation.
//-----------------------------------------------------------------------------
module capim_wp (
                 clk,
                 reset,
                 umr_capim_address,
                 umr_capim_type,
                 umr_in_dat,
                 umr_in_en,
                 umr_in_valid,
                 umr_out_dat,
                 umr_out_en,
                 umr_out_valid,
                 wr,
                 dout,
                 rd,
                 din,
                 intr,
                 inta,
                 inttype
                 )
  /* synthesis .syn_hypernoprune=1 .syn_builtin_du="weak"  .syn_builtin_allow_modgen=1 syn_noprune=1 syn_hier="fixed" rbp_donotdisssolve=1 .certify_slp_dont_write_view=1 haps_ip_type="umr_capim" */;

`ifdef SYSTEM_UMR_DATA_BITWIDTH
   parameter UMR_DATA_BITWIDTH        = `SYSTEM_UMR_DATA_BITWIDTH;
`else
   parameter UMR_DATA_BITWIDTH        = 8;    /* 8 bit for HASPS-60/70/80 ; 32 for direct UMR */
`endif
   parameter UMR_CAPIM_COMMENT_STRING = "NA"; /* Allow user to specify the use of capim */
`ifdef SYSTEM_UMR_BUS_TYPE
   parameter UMR_BUS_TYPE             = `SYSTEM_UMR_BUS_TYPE;
`else
   parameter UMR_BUS_TYPE             = 0;    /* 0 - system UMR, 1 - direct UMR */
`endif

   input 	    clk;
   input 	    reset;
   input [5:0]      umr_capim_address;           /* valid range 1 to 63 */
   input [15:0]     umr_capim_type;              /* Valid user range 0x8000 to 0XFFFF; reserved 0x0001 to 07FFF */
   input [UMR_DATA_BITWIDTH - 1:0] umr_in_dat; 
   input 			   umr_in_en; 
   input 			   umr_in_valid; 
   output [UMR_DATA_BITWIDTH - 1:0] umr_out_dat; 
   wire [UMR_DATA_BITWIDTH - 1:0]   umr_out_dat;
   output 			    umr_out_en; 
   wire 			    umr_out_en;
   output 			    umr_out_valid; 
   wire 			    umr_out_valid;
   output 			    wr; 
   reg 				    wr;
   output [31:0] 		    dout; 
   reg [31:0] 			    dout;
   output 			    rd; 
   reg 				    rd;
   input [31:0] 		    din; 
   input 			    intr; 
   output 			    inta; 
   wire 			    inta;
   input [15:0] 		    inttype; 
   reg [31:0] 			    inreg_data        /* synthesis syn_srlstyle="registers" */; 
   reg [(32 / UMR_DATA_BITWIDTH - 1):0] inreg_en      /* synthesis syn_srlstyle="registers" */;
   reg [(32 / UMR_DATA_BITWIDTH - 1):0] inreg_valid   /* synthesis syn_srlstyle="registers" */; 
   wire 				valid; 
   reg [31:0] 				outreg_data   /* synthesis syn_srlstyle="registers" */ ; 
   reg [31:0] 				outreg_din; 
   wire [31:0] 				scan_data; 
   wire [31:0] 				int_data; 
   wire [31:0] 				data; 
   wire [6:0] 				add_data; 
   reg 					outreg_en     /* synthesis syn_srlstyle="registers" */ ; 
   reg 					outreg_valid  /* synthesis syn_srlstyle="registers" */ ; 
   reg 					outreg_snl; 
   wire 				rd_int; 
   wire 				wr_int; 
   reg 					frmdata; 
   wire 				frmdataval; 
   reg 					scanintsel; 
   wire 				scanintrd; 
   reg [1:0] 				int_aktiv; 
   reg [5:0] 				capim_aktiv; 
   wire 				datval; 
   reg [4:0] 				datvalcnt; 
   reg [6:0] 				wordcnt; 
   wire 				wordval; 
   reg [31:0] 				out_data     /* synthesis syn_srlstyle="registers" */ ; 
   reg 					out_en       /* synthesis syn_srlstyle="registers" */ ; 
   reg 					out_valid    /* synthesis syn_srlstyle="registers" */ ; 
   reg 					out_snl; 
   reg 					rd_valid; 
   wire [31:32 - UMR_DATA_BITWIDTH] 	outreg_data_zero = 0;
   
   generate
      if (UMR_DATA_BITWIDTH != 32)
         always @(posedge clk or posedge reset)
            begin : p_inreg_lt32
               if (reset == 1'b1)
                  begin
         	     inreg_data <= {32{1'b0}} ; 
         	     inreg_en <= {(32 / UMR_DATA_BITWIDTH - 1)-(0)+1{1'b0}} ; 
         	     inreg_valid <= {(32 / UMR_DATA_BITWIDTH - 1)-(0)+1{1'b0}} ; 
         	  end
               else
         	  begin
         	     inreg_data[31:32 - UMR_DATA_BITWIDTH] <= umr_in_dat ; 
         	     inreg_en[32 / UMR_DATA_BITWIDTH - 1] <= umr_in_en ; 
         	     inreg_valid[32 / UMR_DATA_BITWIDTH - 1] <= umr_in_valid ; 
       		     case (UMR_DATA_BITWIDTH)
                        1:  inreg_data[31 - 1:0]  <= inreg_data[31:1];
         		2:  inreg_data[31 - 2:0]  <= inreg_data[31:2];
         		4:  inreg_data[31 - 4:0]  <= inreg_data[31:4];
         		8:  inreg_data[31 - 8:0]  <= inreg_data[31:8];
         		16: inreg_data[31 - 16:0] <= inreg_data[31:16];
                       default:;
         	     endcase
         	     inreg_en[(32 / UMR_DATA_BITWIDTH - 2):0] <= inreg_en[(32 / UMR_DATA_BITWIDTH - 1):1] ; 
         	     inreg_valid[(32 / UMR_DATA_BITWIDTH - 2):0] <= inreg_valid[(32 / UMR_DATA_BITWIDTH - 1):1] ; 
       	          end 
            end
      else
         always @(posedge clk or posedge reset)
            begin : p_inreg_32
               if (reset == 1'b1)
                  begin
         	     inreg_data <= {32{1'b0}} ; 
         	     inreg_en <= {(32 / UMR_DATA_BITWIDTH - 1)-(0)+1{1'b0}} ; 
         	     inreg_valid <= {(32 / UMR_DATA_BITWIDTH - 1)-(0)+1{1'b0}} ; 
         	  end
               else
         	  begin
         	     inreg_data[31:32 - UMR_DATA_BITWIDTH] <= umr_in_dat ; 
         	     inreg_en[32 / UMR_DATA_BITWIDTH - 1] <= umr_in_en ; 
         	     inreg_valid[32 / UMR_DATA_BITWIDTH - 1] <= umr_in_valid ; 
       	          end 
            end
   endgenerate
   assign valid = ((inreg_valid[(32 / UMR_DATA_BITWIDTH - 1)]) == 1'b1) ? 1'b1 : 1'b0 ;
   always @(posedge clk or posedge reset)
      begin : p_outreg
	 if (reset == 1'b1)
	    begin
	       outreg_data <= {32{1'b0}} ; 
	       outreg_en <= 1'b0 ; 
	       outreg_valid <= 1'b0 ; 
	    end
	 else
	    begin
	       outreg_data <= outreg_din ; 
	       outreg_en <= inreg_en[0] ; 
	       outreg_valid <= inreg_valid[0] ; 
	    end 
      end 
   // data sources
   assign add_data = inreg_data[6:0] + 1 ;
   assign scan_data[31:16] = umr_capim_type[15:0] ;
   assign scan_data[15:7] = inreg_data[15:7] ;
   assign scan_data[6:0] = add_data ;
   assign int_data[31:16] = inttype ;
   assign int_data[15:7] = inreg_data[15:7] ;
   assign int_data[6:0] = add_data ;
   assign data[31:1] = inreg_data[31:1] ;
   assign data[0] = ((int_aktiv[1]) == 1'b0 & intr == 1'b1 & (inreg_en[0]) == 1'b0) ? 1'b1 : inreg_data[0] ;
   always @(capim_aktiv or data or int_aktiv or int_data or scan_data or wordval)
      begin : p_datasrc
	 if ((capim_aktiv[3]) == 1'b1 & wordval == 1'b1 & (int_aktiv[0]) == 1'b1)
	    begin
	       // int
	       outreg_din = int_data ; 
	    end
	 else if ((capim_aktiv[4]) == 1'b1 & wordval == 1'b1)
	    begin
	       // scan
	       outreg_din = scan_data ; 
	    end
	 else
	    begin
	       outreg_din = data ; 
	    end 
      end 
   always @(capim_aktiv or datval or frmdataval or inreg_en or int_aktiv or 
	    scanintrd)
      begin : p_outreg_snl
	 if ((capim_aktiv[2]) == 1'b1 & datval == 1'b0 & frmdataval == 1'b1 & (inreg_en[0]) == 1'b1)
	    begin
	       // read
	       outreg_snl = 1'b1 ; 
	    end
	 else if ((capim_aktiv[3]) == 1'b1 & datval == 1'b0 & scanintrd == 1'b1 & (int_aktiv[0]) == 1'b1 & (inreg_en[0]) == 1'b1)
	    begin
	       // int
	       outreg_snl = 1'b1 ; 
	    end
	 else if ((capim_aktiv[4]) == 1'b1 & datval == 1'b0 & scanintrd == 1'b1 & (inreg_en[0]) == 1'b1)
	    begin
	       // scan
	       outreg_snl = 1'b1 ; 
	    end
	 else
	    begin
	       outreg_snl = 1'b0 ; 
	    end 
      end 
   always @(posedge clk or posedge reset)
      begin : P_out
	 if (reset == 1'b1)
	    begin
	       out_data <= {32{1'b0}} ; 
	       out_en <= 1'b0 ; 
	       out_valid <= 1'b0 ; 
	       out_snl <= 1'b0 ; 
	    end
	 else
	    begin
	       if (out_snl == 1'b0)
		  begin
		     if (rd_valid == 1'b1)
			begin
			   out_data <= din ; 
			end
		     else
			begin
			   out_data <= outreg_data ; 
			end 
		  end
	       else
		  begin
		     if (UMR_DATA_BITWIDTH < 32)
			begin
			   // out_data[31 - UMR_DATA_BITWIDTH:0] <= out_data[31:UMR_DATA_BITWIDTH] ;
			   case (UMR_DATA_BITWIDTH)
			     1: out_data[31 - 1:0] <= out_data[31:1] ;
			     2: out_data[31 - 2:0] <= out_data[31:2] ;
			     4: out_data[31 - 4:0] <= out_data[31:4] ;
			     8: out_data[31 - 8:0] <= out_data[31:8] ;
			     16: out_data[31 - 16:0] <= out_data[31:16] ;
                             default:;
			   endcase
			end 
		  end 
	       out_en <= outreg_en ; 
	       out_valid <= outreg_valid ; 
	       out_snl <= outreg_snl ; 
	    end 
      end 
   assign umr_out_dat = out_data[UMR_DATA_BITWIDTH - 1:0] ;
   assign umr_out_en = out_en ;
   assign umr_out_valid = out_valid ;
   always @(posedge clk or posedge reset)
      begin : p_aktivate
	 if (reset == 1'b1)
	    begin
	       capim_aktiv <= 6'b000001 ; // wait for operation
	    end
	 else
	    begin
	       if ((inreg_en[0]) == 1'b1 & (capim_aktiv[0]) == 1'b1 & valid == 1'b1)
		  begin
		     if (inreg_data[13:8] == umr_capim_address[5:0])
			begin
			   if (inreg_data[7:4] == 4'b0001)
			      begin
				 capim_aktiv <= 6'b000010 ; // write frame operation
			      end
			   else if (inreg_data[7:4] == 4'b0010)
			      begin
				 capim_aktiv <= 6'b000100 ; // read frame operation
			      end
			   else
			      begin
				 capim_aktiv <= 6'b100000 ; // idle
			      end 
			end
		     else if (inreg_data[13:8] == 6'b000000)
			begin
			   if (inreg_data[7:4] == 4'b0110)
			      begin
				 capim_aktiv <= 6'b010000 ; // scan frame operation
			      end
			   else if (inreg_data[7:4] == 4'b1010)
			      begin
				 capim_aktiv <= 6'b001000 ; // int frame operation
			      end
			   else
			      begin
				 capim_aktiv <= 6'b100000 ; // idle
			      end 
			end
		     else
			begin
			   capim_aktiv <= 6'b100000 ; // idle
			end 
		  end
	       else if ((inreg_en[0]) == 1'b0)
		  begin
		     capim_aktiv <= 6'b000001 ; // wait for operation
		  end 
	    end 
      end 
   always @(posedge clk or posedge reset)
      begin : p_interrupt
	 if (reset == 1'b1)
	    begin
	       int_aktiv <= {2{1'b0}} ; 
	    end
	 else
	    begin
	       if (int_aktiv == 2'b00 & intr == 1'b1 & scanintrd == 1'b0)
		  begin
		     int_aktiv <= 2'b01 ; 
		  end
	       else if (int_aktiv == 2'b01 & (capim_aktiv[3]) == 1'b1 & scanintrd == 1'b1)
		  begin
		     int_aktiv <= 2'b11 ; 
		  end
	       else if (int_aktiv == 2'b11 & scanintrd == 1'b0)
		  begin
		     int_aktiv <= 2'b10 ; 
		  end
	       else if (int_aktiv == 2'b10 & intr == 1'b0)
		  begin
		     int_aktiv <= 2'b00 ; 
		  end 
	    end 
      end 
   assign inta = (int_aktiv == 2'b10) ? 1'b1 : 1'b0 ;
   always @(posedge clk or posedge reset)
      begin : p_datvalid
	 if (reset == 1'b1)
	    begin
	       datvalcnt <= 0 ; 
	    end
	 else
	    begin
	       if ((capim_aktiv[0]) == 1'b1 | datval == 1'b1)
		  begin
		     datvalcnt <= 0 ; 
		  end
	       else if (valid == 1'b1)
		  begin
		     datvalcnt <= datvalcnt + 1 ; 
		  end 
	    end 
      end 
   assign datval = (datvalcnt == (32 / UMR_DATA_BITWIDTH - 1) & (inreg_valid[0]) == 1'b1) ? 1'b1 : 1'b0 ;
   always @(posedge clk or posedge reset)
      begin : p_frmdata
	 if (reset == 1'b1)
	    begin
	       frmdata <= 1'b0 ; 
	    end
	 else
	    begin
	       if ((capim_aktiv[0]) == 1'b1)
		  begin
		     frmdata <= 1'b0 ; 
		  end
	       else if (frmdataval == 1'b1)
		  begin
		     frmdata <= 1'b1 ; 
		  end 
	    end 
      end 
   assign frmdataval = (datvalcnt == (32 / UMR_DATA_BITWIDTH - 1) | frmdata == 1'b1) ? 1'b1 : 1'b0 ;
   // write data
   always @(posedge clk or posedge reset)
      begin : P_write_data
	 if (reset == 1'b1)
	    begin
	       dout <= {32{1'b0}} ; 
	       wr <= 1'b0 ; 
	    end
	 else
	    begin
	       if (wr_int == 1'b1)
		  begin
		     dout <= inreg_data ; 
		  end 
	       wr <= wr_int ; 
	    end 
      end 
   assign wr_int = ((capim_aktiv[1]) == 1'b1 & datval == 1'b1 & (inreg_en[0]) == 1'b1) ? 1'b1 : 1'b0 ;
   // read data
   always @(posedge clk or posedge reset)
      begin : P_read_data
	 if (reset == 1'b1)
	    begin
	       rd <= 1'b0 ; 
	       rd_valid <= 1'b0 ; 
	    end
	 else
	    begin
	       rd <= rd_int ; 
	       rd_valid <= capim_aktiv[2] & rd_int ; 
	    end 
      end 
   assign rd_int = ((capim_aktiv[2]) == 1'b1 & datval == 1'b1 & (inreg_en[0]) == 1'b1) ? 1'b1 : 1'b0 ;
   always @(posedge clk or posedge reset)
      begin : p_wordcnt
	 if (reset == 1'b1)
	    begin
	       wordcnt <= 0 ; 
	    end
	 else
	    begin
	       if ((capim_aktiv[0]) == 1'b1)
		  begin
		     wordcnt <= 0 ; 
		  end
	       else if (datval == 1'b1 & ((capim_aktiv[3]) == 1'b1 | (capim_aktiv[4]) == 1'b1))
		  begin
		     wordcnt <= wordcnt + 1 ; 
		  end 
	    end 
      end 
   always @(posedge clk or posedge reset)
      begin : p_scanintsel
	 if (reset == 1'b1)
	    begin
	       scanintsel <= 1'b0 ; 
	    end
	 else
	    begin
	       if ((capim_aktiv[0]) == 1'b1 | scanintrd == 1'b0)
		  begin
		     scanintsel <= 1'b0 ; 
		  end
	       else if (wordval == 1'b1)
		  begin
		     scanintsel <= 1'b1 ; 
		  end 
	    end 
      end 
   assign scanintrd = (wordval == 1'b1 | (scanintsel == 1'b1 & datval == 1'b0)) ? 1'b1 : 1'b0 ;
   assign wordval = (wordcnt == umr_capim_address[5:0] & datval == 1'b1) ? 1'b1 : 1'b0 ;
endmodule


//-----------------------------------------------------------------------------
// Description: CAPIM with runtime changeable address and type and user ports
//              only. umr_clk and umr_reset are outputs and can be used to
//              drive local CAPIM interface logic.
//              The UMR_CAPIM_ADDRESS and UMR_CAPIM_TYPE parameters are
//              unused but necessary for Certify operation.
//-----------------------------------------------------------------------------
module capim_wp_ui (
                    umr_clk,
                    umr_reset,
                    umr_capim_address,
                    umr_capim_type,
                    wr,
                    dout,
                    rd,
                    din,
                    intr,
                    inta,
                    inttype)
  /* synthesis .syn_hypernoprune=1 .syn_builtin_du="weak"  .syn_builtin_allow_modgen=1 syn_noprune=1 rbp_donotdisssolve=1 haps_ip_type="umr_capim" */;

`ifdef SYSTEM_UMR_DATA_BITWIDTH
   parameter UMR_DATA_BITWIDTH        = `SYSTEM_UMR_DATA_BITWIDTH;
`else
   parameter UMR_DATA_BITWIDTH        = 8;    /* 8 bit for HASPS-60/70/80 ; 32 for direct UMR */
`endif
   parameter UMR_CAPIM_COMMENT_STRING = "NA"; /* Allow user to specify the use of capim */
`ifdef SYSTEM_UMR_BUS_TYPE
   parameter UMR_BUS_TYPE             = `SYSTEM_UMR_BUS_TYPE;
`else
   parameter UMR_BUS_TYPE             = 0;    /* 0 - system UMR, 1 - direct UMR */
`endif

   /* ports */
   output  	    umr_clk; 
   output 	    umr_reset;
   input [5:0]      umr_capim_address;          /* valid range 1 to 63 */
   input [15:0]     umr_capim_type;             /* Valid user range 0x8000 to 0XFFFF; reserved 0x0001 to 07FFF */
   output           wr; 
   output [31:0]    dout; 
   output           rd; 
   input [31:0]     din; 
   input            intr; 
   output           inta; 
   wire             inta;
   input [15:0]     inttype;
   
   /* internal UMRBus signals which will be driven by XMRs */
   wire [UMR_DATA_BITWIDTH - 1:0] umr_in_dat; 
   wire                           umr_in_en; 
   wire                           umr_in_valid; 
   wire [UMR_DATA_BITWIDTH - 1:0] umr_out_dat;
   wire                           umr_out_en;
   wire                           umr_out_valid;

`ifndef UMR_SIM
 `ifdef UMR_UMRPCIE
   syn_hyper_connect #(.tag("hyper_umr_clk"),   .w(1)) hyper_umr_clk(umr_clk);
   syn_hyper_connect #(.tag("hyper_umr_reset"), .w(1)) hyper_umr_reset(umr_reset);
 `else
   assign umr_in_dat   = umr_out_dat;
   assign umr_in_en    = umr_out_en;
   assign umr_in_valid = umr_out_valid;
   syn_hyper_connect #(.tag("umr_clk"),   .w(1)) hyper_umr_clk(umr_clk);
   syn_hyper_connect #(.tag("umr_reset"), .w(1)) hyper_umr_reset(umr_reset);
 `endif
`endif
   
   /* the CAPIM itself */
   capim_wp #(
              .UMR_DATA_BITWIDTH(UMR_DATA_BITWIDTH),
              .UMR_CAPIM_COMMENT_STRING(UMR_CAPIM_COMMENT_STRING),
              .UMR_BUS_TYPE(UMR_BUS_TYPE)
              )
   I_Capim(
           .clk(umr_clk),
           .reset(umr_reset),
           .umr_capim_type(umr_capim_type),
           .umr_capim_address(umr_capim_address),
           .umr_in_dat(umr_in_dat),
           .umr_in_en(umr_in_en),
           .umr_in_valid(umr_in_valid),
           .umr_out_dat(umr_out_dat),
           .umr_out_en(umr_out_en),
           .umr_out_valid(umr_out_valid),
           .wr(wr),
           .dout(dout),
           .rd(rd),
           .din(din),
           .intr(intr),
           .inta(inta),
           .inttype(inttype)
           );
   
endmodule // capim_wp_ui

