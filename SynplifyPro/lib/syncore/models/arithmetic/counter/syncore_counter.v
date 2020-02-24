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
// --- IP Description : Generic SynCoreCounter Module
// -----------------------------------------------------------------------------

module SynCoreCounter 
          #(	parameter COUNT_WIDTH = 48,
            	parameter STEP = 1, 
			parameter	RESET_TYPE 	= 0,
			parameter MODE = "Dynamic",  			// Used for dynamic up-down counting (  "Up" -> Up count, "Down" -> Down count, 
											//"Dynamic" -> counts up or down depending on PortUp_nDown(if '1', up count or '0' down count))
			parameter LOAD = 1,				// Determines the // 0 -> No Load
												//1 -> Load to Constant LOAD_VALUE
												//2 -> Load to the variable PortLoadValue
			parameter LOAD_VALUE = 1000			//Detrmines the load value to which counter gets loaded when PortCE is active.
)(

	PortClk,
	PortRST,
	PortUp_nDown,
	PortCE,
	PortLoad,
	PortLoadValue,

	PortCount);

input PortClk,PortRST,PortUp_nDown,PortLoad;
input PortCE;
input [COUNT_WIDTH-1:0] PortLoadValue;
reg [COUNT_WIDTH-1:0] PortCount_Asynch,PortCount_Synch;
output  [COUNT_WIDTH-1:0] PortCount;
reg [COUNT_WIDTH-1:0] countInternal;
wire [COUNT_WIDTH-1:0] LoadValueInternal;
assign LoadValueInternal = (LOAD==1)?LOAD_VALUE:PortLoadValue;

// SYNCHRONOUS
always@(posedge PortClk) begin
	if(PortRST)
  		PortCount_Synch <= 0;
	else begin
       	if(PortCE)
			PortCount_Synch <= countInternal;
  	end
end

//ASYNCHRONOUS

always@(posedge PortClk or posedge PortRST) begin
	if(PortRST)
  		PortCount_Asynch <= 0;
	else begin
       	if(PortCE)
			PortCount_Asynch <= countInternal;
  	end
end

assign PortCount = 	RESET_TYPE ? PortCount_Asynch : PortCount_Synch;

always@(*) begin
	if(LOAD>0) begin
    	if(PortLoad)
        	countInternal <= LoadValueInternal;
		else begin
	    	if(MODE==="Up")
            	countInternal <= PortCount + STEP;
            else if(MODE==="Down")
            	countInternal <= PortCount - STEP;
            else if(MODE==="Dynamic")begin
            	if(PortUp_nDown)
                	countInternal <= PortCount + STEP;
                else
                	countInternal <= PortCount - STEP;
            end
		end
	end
	else begin
    	if(MODE==="Up")
            	countInternal <= PortCount + STEP;
            else if(MODE==="Down")
            	countInternal <= PortCount - STEP;
            else if(MODE==="Dynamic")	begin
            	if(PortUp_nDown)
                	countInternal <= PortCount + STEP;
                else
                	countInternal <= PortCount - STEP;
            end
	end
end
endmodule


