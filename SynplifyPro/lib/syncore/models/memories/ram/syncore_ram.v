// -----------------------------------------------------------------------------
// ---
// ---                 (C) COPYRIGHT 2001-2010 SYNOPSYS, INC.
// ---                           ALL RIGHTS RESERVED
// ---
// --- This software and the associated documentation are confidential and
// --- proprietary to Synopsys, Inc.  Your use or disclosure of this
// --- software is subject to the terms and conditions of a written
// --- license agreement between you, or your company, and Synopsys, Inc.
// ---
// --- The entire notice above must be reproduced on all authorized copies.
// ---
// --- RCS information:
// ---    $Author$
// ---    $DateTime$
// ---    $Revision$
// ---    $Id$
// ---
// --- IP Description : This Module infers Generic Dual Port RAMs for Xilinx,
//                      Altera, Actel Devices
// -----------------------------------------------------------------------------	


`define SYN_MULTI_PORT_RAM 1 

`ifdef SYN_MULTI_PORT_RAM 
   `define RAM_STYLE /* synthesis syn_ramstyle = "no_rw_check" */ 
 `else
   `define RAM_STYLE /* synthesis syn_ramstyle = "block_ram" */ 
 `endif
    


module Syncore_ram(
	 PortClk
	,PortReset
	,PortWriteEnable
	,PortReadEnable 
	,PortDataIn
	,PortAddr
	,PortDataOut   
	);


parameter	 DATAWIDTH = 8;
parameter	 ADDRWIDTH = 8; 
parameter	 MEMDEPTH = 2**(ADDRWIDTH);

parameter 	 SPRAM	= 1;
parameter 	 READ_MODE_A			= 1;
parameter	 READ_WRITE_A			= 1;
parameter	 ENABLE_WR_PORTA	 	= 1; 

parameter	 REGISTER_RD_ADDR_PORTA 	= 1; 

parameter	 REGISTER_OUTPUT_PORTA 		= 1; 
parameter	 ENABLE_OUTPUT_REG_PORTA 	= 1; 
parameter	 RESET_OUTPUT_REG_PORTA 	= 1; 


parameter 	 READ_MODE_B			= 1;
parameter	 READ_WRITE_B			= 1;
parameter	 ENABLE_WR_PORTB	 	= 1; 

parameter	 REGISTER_RD_ADDR_PORTB 	= 1; 

parameter	 REGISTER_OUTPUT_PORTB 		= 1; 
parameter	 ENABLE_OUTPUT_REG_PORTB 	= 1; 
parameter	 RESET_OUTPUT_REG_PORTB 	= 1; 


parameter 	 TWO				= 2;


input  [TWO -1:0]				PortClk; 
input  [TWO -1:0]				PortReset;
input  [TWO -1:0]				PortWriteEnable;
input  [TWO -1:0]				PortReadEnable;
input  [ADDRWIDTH*TWO-1:0] 		PortAddr;
input  [DATAWIDTH*TWO-1:0] 			PortDataIn; 
output [DATAWIDTH*TWO-1:0]	 		PortDataOut;




reg [DATAWIDTH*TWO-1:0] DataOutRegPort;
reg [ADDRWIDTH*TWO-1:0] AddrRegPort;



reg [DATAWIDTH*TWO-1:0] mem [MEMDEPTH-1:0] `RAM_STYLE;


wire [TWO -1:0] ResetOutputRegPort; 
wire [TWO -1:0] EnableOutputRegPort;


wire [ADDRWIDTH*TWO-1:0] MemAddrPort;


wire [TWO -1:0] 	 		NOCHANGE;
wire [TWO -1:0] 			WriteEnablePort;
wire [DATAWIDTH*TWO-1:0] 		StoreDout;


wire [TWO -1:0]  Prm_NOCHANGE			= {(READ_MODE_B == 3), (READ_MODE_A == 3)};
wire [TWO -1:0]	 Prm_WRITE_FIRST		= {(READ_MODE_B == 2), (READ_MODE_A == 2)};
wire [TWO -1:0]	 Prm_READ_FIRST			= {(READ_MODE_B == 1), (READ_MODE_A == 1)};

wire [TWO -1:0]  Prm_ENABLE_WR_PORT 		= {(ENABLE_WR_PORTB > 0), (ENABLE_WR_PORTA > 0)}; 

wire [TWO -1:0]	 Prm_REGISTER_RD_ADDR_PORT 	= {(REGISTER_RD_ADDR_PORTB > 0), (REGISTER_RD_ADDR_PORTA > 0)}; 
wire [TWO -1:0]	 Prm_REGISTER_OUTPUT_PORT 	= {(REGISTER_OUTPUT_PORTB > 0), (REGISTER_OUTPUT_PORTA > 0)}; 
wire [TWO -1:0]	 Prm_ENABLE_OUTPUT_REG_PORT 	= {(ENABLE_OUTPUT_REG_PORTB > 0), (ENABLE_OUTPUT_REG_PORTA > 0)}; 
wire [TWO -1:0]	 Prm_RESET_OUTPUT_REG_PORT  	= {(RESET_OUTPUT_REG_PORTB > 0), (RESET_OUTPUT_REG_PORTA > 0)}; 


parameter Rd_Iterations	 = 	SPRAM ? 1 : 
				((((READ_WRITE_A == 1) & (READ_WRITE_B == 1)) | 
				((READ_WRITE_A == 1) & (READ_WRITE_B == 2))   |
				((READ_WRITE_A == 2) & (READ_WRITE_B == 1)) ) ? 2 : 1);

parameter Wr_Iterations = 	SPRAM ? 1 : 
				((((READ_WRITE_A == 1) & (READ_WRITE_B == 1)) | 
			   	((READ_WRITE_A == 1) & (READ_WRITE_B == 3))   |
			   	((READ_WRITE_A == 3) & (READ_WRITE_B == 1)) ) ? 2 : 1);

parameter rd_inc 		=  SPRAM ? 0 : 
				  ((((READ_WRITE_A == 3) & (READ_WRITE_B == 1)) | 						
				  ((READ_WRITE_A == 3) & (READ_WRITE_B == 2)) ) ? 1 : 0);

parameter wr_inc 		=  SPRAM ? 0 : 
				   ((((READ_WRITE_A == 2) & (READ_WRITE_B == 1)) | 						
				   ((READ_WRITE_A == 2) & (READ_WRITE_B == 3)) ) ? 1 : 0);




// Start GENERATE Process
// This block reads from the memory.

generate 
begin : GenBlock1

genvar i ;

for (i=0 ; i < Rd_Iterations; i=i+1)
begin : RAM_READ


assign ResetOutputRegPort[(i+rd_inc)]  	=  (Prm_RESET_OUTPUT_REG_PORT[(i+rd_inc)] > 0) ? PortReset[(i+rd_inc)] : 1'b0 ; 
assign EnableOutputRegPort[(i+rd_inc)] 	=  (Prm_ENABLE_OUTPUT_REG_PORT[(i+rd_inc)] > 0) ? PortReadEnable[(i+rd_inc)] : 1'b1;

assign NOCHANGE[(i+rd_inc)]		 		= (Prm_NOCHANGE[(i+rd_inc)]) ? !WriteEnablePort[(i+rd_inc)] : 1'b1;

/*
 Indexed vector part selects
In the Verilog-1995 standard, variable bit selects of a vector are permitted, but part-selects must be constant.
Thus, it is illegal to use a variable to select a specific byte out of a word. The Verilog-2001 standard adds a new
syntax, called indexed part selects. With an indexed part select, a base expression, a width expression, and an offset
direction are provided, in the form of: 

[base_expr +: width_expr] //positive offset
[base_expr -: width_expr] //negative offset

The base expression can vary during simulation run-time.The width expression must be constant. The offset
direction indicates if the width expression is added to or subtracted from the base expression. For example,:

reg [63:0] word;
reg [3:0] byte_num; //a value from 0 to 7
wire [7:0] byteN = word[byte_num*8 +: 8];

In the preceding example, if byte_num has a value of 4,
then the value of word[39:32] is assigned to byteN. Bit 32
of the part select is derived from the base expression, and
bit 39 from the positive offset and width expression.

*/
assign MemAddrPort[(i+rd_inc)*ADDRWIDTH +: ADDRWIDTH]	=  (Prm_REGISTER_RD_ADDR_PORT[(i+rd_inc)] > 0) ? AddrRegPort[(i+rd_inc)*ADDRWIDTH +: ADDRWIDTH]
												   			: PortAddr[(i+rd_inc)*ADDRWIDTH +: ADDRWIDTH];
									   
assign StoreDout[(i+rd_inc)*DATAWIDTH +: DATAWIDTH] 	= (Prm_WRITE_FIRST[(i+rd_inc)]) ? ( WriteEnablePort[(i+rd_inc)] ? PortDataIn[(i+rd_inc)*DATAWIDTH +: DATAWIDTH] : mem[MemAddrPort[(i+rd_inc)*ADDRWIDTH +: ADDRWIDTH]])
															  	   :  mem[MemAddrPort[(i+rd_inc)*ADDRWIDTH +: ADDRWIDTH]];

assign PortDataOut[(i+rd_inc)*DATAWIDTH +: DATAWIDTH] 	=  (Prm_REGISTER_OUTPUT_PORT[(i+rd_inc)] > 0) ? DataOutRegPort[(i+rd_inc)*DATAWIDTH +: DATAWIDTH] 
															  : StoreDout[(i+rd_inc)*DATAWIDTH +: DATAWIDTH] ;


// Reading from memory through Port A

always @(posedge PortClk[(i+rd_inc)])
begin  
     AddrRegPort[(i+rd_inc)*ADDRWIDTH +: ADDRWIDTH] <= PortAddr[(i+rd_inc)*ADDRWIDTH +: ADDRWIDTH];	
end


always @(posedge PortClk[(i+rd_inc)])
begin
  if(ResetOutputRegPort[(i+rd_inc)])
    DataOutRegPort[(i+rd_inc)*DATAWIDTH +: DATAWIDTH] ='d0;
  else
    if (EnableOutputRegPort[(i+rd_inc)])
      if (NOCHANGE[(i+rd_inc)])
        DataOutRegPort[(i+rd_inc)*DATAWIDTH +: DATAWIDTH] = StoreDout[(i+rd_inc)*DATAWIDTH +: DATAWIDTH];	
end

end
end
endgenerate 



generate 
begin : GenBlock2

genvar j ;

for (j=0 ; j < Wr_Iterations; j=j+1)
begin : RAM_WRITE

assign WriteEnablePort[(j+wr_inc)]		=  (Prm_ENABLE_WR_PORT[(j+wr_inc)] > 0) ? PortWriteEnable[(j+wr_inc)] : 1'b1; 

always @(posedge PortClk[(j+wr_inc)])
begin
   if(WriteEnablePort[(j+wr_inc)]) 
     mem[PortAddr[(j+wr_inc)*ADDRWIDTH +: ADDRWIDTH]] <= PortDataIn[(j+wr_inc)*DATAWIDTH +: DATAWIDTH];		
end

end
end
endgenerate 


endmodule
