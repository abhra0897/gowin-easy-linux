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
// --- IP Description : This IP can be configured with SynCORE wizard to generate
// ---                  Byte enable RAM's in true dual port (TDP) mode
// ---                  RAM infernce QoR of this IP is tested only for 
// ---                  Xilinx Devices
// -----------------------------------------------------------------------------



module syncore_be_ram_tdp #( parameter logic [15:0] DATA_WIDTH   = 'd8,
						 parameter logic [15:0] ADD_WIDTH    = 'd10,
						 parameter logic [15:0] WE_WIDTH     = 'd1,
						 
						 parameter logic [2:0]  READ_WRITE_A = 1,         //1 - Rd,Wr;  2 - Rd ;  3 - Wr
						 parameter logic [2:0]  READ_WRITE_B = 1,         //1 - Rd,Wr   2 - Rd ;  3 - Wr
						 parameter logic [0:0]  CONFIG_PORT  = 1,         //0 - signle , 1 dual
						 parameter logic [1:0]  RST_TYPE_A   = 0,         //0 - no reset , 1 - synchronous 
				         parameter logic [1:0]  RST_TYPE_B   = 0,
				         parameter logic [15:0] RST_RDDATA_A = 'd0,
						 parameter logic [15:0] RST_RDDATA_B = 'd0,
					     parameter logic [0:0] WEN_SENSE_A   = 1,
					     parameter logic [0:0] WEN_SENSE_B   = 1,
						 parameter logic [0:0] RADDR_LTNCY_A = 1, 
                         parameter logic [0:0] RADDR_LTNCY_B = 1,
                         parameter logic [0:0] RDATA_LTNCY_A = 1,
                         parameter logic [0:0] RDATA_LTNCY_B = 1
                         
                          )
                         (
                         
                          output logic [DATA_WIDTH-1:0] RdDataA,
                          output logic [DATA_WIDTH-1:0] RdDataB,
                          //Port A interface signals
                          input logic [DATA_WIDTH-1:0] WrDataB,
                          input logic [ADD_WIDTH - 1 : 0] AddrB,
                          input logic [WE_WIDTH-1:0] WenB,
                          //input logic [0:0] EnB,
                          input logic [0:0] ResetB,
                          input logic [0:0] ClkB,
                          //Port B interface signals
                          input logic [DATA_WIDTH-1:0] WrDataA,
                          input logic [ADD_WIDTH - 1 : 0] AddrA,
                          input logic [WE_WIDTH-1:0] WenA,
                          //input logic [0:0] EnA,
                          input logic [0:0] ResetA,
                          input logic [0:0] ClkA
                       
                          );
integer i = 0;

parameter WR_SIZE       = DATA_WIDTH/WE_WIDTH;      
                
logic [DATA_WIDTH-1:0] syncore_be_mem[0 : 2**ADD_WIDTH - 1]/*synthesis syn_ramstyle="no_rw_check"*/;

//local signal for Address 
logic [ADD_WIDTH - 1 : 0] AddrA_reg0;
logic [ADD_WIDTH - 1 : 0] AddrB_reg0;

logic [ADD_WIDTH - 1 : 0] AddrA_L;
logic [ADD_WIDTH - 1 : 0] AddrB_L;

//local signal for RdData logic
logic [DATA_WIDTH-1:0] RdDataA_reg0;
logic [DATA_WIDTH-1:0] RdDataB_reg0;

logic [DATA_WIDTH-1:0] RdDataA_L;
logic [DATA_WIDTH-1:0] RdDataB_L;

logic temp_WenA;
logic temp_WenB;


//Registering input address
always @ (posedge ClkA ) begin
  AddrA_reg0 <= AddrA;
end
always @ (posedge ClkB ) begin
  AddrB_reg0 <= AddrB;
end

assign AddrA_L = RADDR_LTNCY_A ? AddrA_reg0 : AddrA;
assign AddrB_L = RADDR_LTNCY_B ? AddrB_reg0 : AddrB;


//Dual Mode code for PortB interface
// 
generate begin

 if (CONFIG_PORT == 1 && READ_WRITE_A != 2 && READ_WRITE_B != 2) begin
   assign temp_WenA = WenA[0];
   always @ (posedge ClkA ) begin
       if (temp_WenA == WEN_SENSE_A) begin
        syncore_be_mem[AddrA] <= WrDataA;
       end  
   end
 end

end     
endgenerate

generate begin 
 if (CONFIG_PORT == 1 && READ_WRITE_A != 2 && READ_WRITE_B != 2) begin
   assign temp_WenB = WenB[0];
     always @ (posedge ClkB ) begin
       if (temp_WenB == WEN_SENSE_B) begin
        syncore_be_mem[AddrB] <= WrDataB;
       end  
   end
 end
 
end     
endgenerate
//

//Reset can be synchronous or no reset , controlling using generate
generate begin
 
 //Check if PortA is in Write Only Mode
 if (READ_WRITE_A  != 3) begin
   if (RST_TYPE_A == 0) begin
     always @ (posedge ClkA ) begin
       RdDataA_reg0 <= syncore_be_mem[AddrA_L];
     end
   end   
   else if (RST_TYPE_A == 1 ) begin
     always @ (posedge ClkA ) begin
       if (ResetA == 0)
         RdDataA_reg0 <= RST_RDDATA_A;
       else  
         RdDataA_reg0 <= syncore_be_mem[AddrA_L];
      end   
   end   
   else begin
     always @ (posedge ClkA ) begin
       RdDataA_reg0 <= syncore_be_mem[AddrA_L];
     end
   end  
  end

end   
endgenerate

generate begin
 
 if (READ_WRITE_A != 3) begin
   always @ ( * ) begin
    RdDataA_L <= syncore_be_mem[AddrA_L];
   end
   assign RdDataA   = RDATA_LTNCY_A ? RdDataA_reg0 : RdDataA_L;
 end

end
endgenerate


//

generate begin
  
 if (CONFIG_PORT == 1 && READ_WRITE_B != 3) begin
     if (RST_TYPE_B == 0) begin
       always @ (posedge ClkB ) begin
         RdDataB_reg0 <= syncore_be_mem[AddrB_L];
       end
     end   
     else if (RST_TYPE_B == 1 ) begin
       always @ (posedge ClkB ) begin
         if (ResetB == 0)
           RdDataB_reg0 <= RST_RDDATA_B;
         else 
           RdDataB_reg0 <= syncore_be_mem[AddrB_L]; 
       end
     end   
     else begin
       always @ (posedge ClkB ) begin
         RdDataB_reg0 <= syncore_be_mem[AddrB_L];
       end  
     end         
 end // config_port end

end  //end for generate begin
endgenerate

generate begin

 if (READ_WRITE_B != 3) begin
  //Read Data logic depending on RDATA_LTNCY_B parameter
   always @ ( * ) begin
    RdDataB_L <= syncore_be_mem[AddrB_L];
   end

   assign RdDataB   = RDATA_LTNCY_B ? RdDataB_reg0 : RdDataB_L;
  end

end
endgenerate

function integer clogb2 (input integer depth); begin
    depth=depth-1;  
    for(clogb2=0; depth>0; clogb2=clogb2+1)
      depth = depth >> 1;
    end
endfunction
                          
endmodule                         
						 
