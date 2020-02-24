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
// --- IP Description : This Module generates Synchronous Symmetric FIFO. 
// ---                  By default, FIFO memory will be mapped to Block-RAMs  
// ---                  for Xilinx and Altera Devices
// -----------------------------------------------------------------------------



//For Asynchronous RST disable the following line and enable the next line
`define RST_CONDITION 
//`define RST_CONDITION or posedge rst




module syncore_sfifo(
		Clock,
		Din,
		Write_enable,			
		Full,					
		Almost_full,			
		Write_ack,				
		Overflow,				
		Data_cnt,
		Prog_full,				
		Prog_full_thresh,		
		Prog_full_thresh_assert,
		Prog_full_thresh_negate,
		Dout,					
		Read_enable,			
		Empty,					
		Almost_empty,			
		Read_ack,				
		Underflow,				
		Prog_empty,				
		Prog_empty_thresh,		
		Prog_empty_thresh_assert,
		Prog_empty_thresh_negate,
		Reset					
		
		) ;

parameter 	WIDTH 		       = 8;
parameter	DEPTH		       = 32; 
/////////
	`define _synp_dep DEPTH
	`define C0 0+(`_synp_dep>1)+(`_synp_dep>2)+(`_synp_dep>4)+(`_synp_dep>8)+(`_synp_dep>16)+(`_synp_dep>32)+(`_synp_dep>64)                  
	`define C1 +(`_synp_dep>128)+(`_synp_dep>256)+(`_synp_dep>512)+(`_synp_dep>1028)+(`_synp_dep>2046)+(`_synp_dep>4096)              
	`define C2 +(`_synp_dep>8192)+(`_synp_dep>16384)+(`_synp_dep>32768)+(`_synp_dep>65536)+(`_synp_dep>131072)                
	`define C3 +(`_synp_dep>1<<18)+(`_synp_dep>1<<19)+(`_synp_dep>1<<20)+(`_synp_dep>1<<21)+(`_synp_dep>1<<22)                
	`define C4 +(`_synp_dep>1<<23)+(`_synp_dep>1<<24)+(`_synp_dep>1<<25)+(`_synp_dep>1<<26)+(`_synp_dep>1<<27)                
	`define C5 +(`_synp_dep>1<<28)+(`_synp_dep>1<<29)+(`_synp_dep>1<<30)                           
	`define C2BITS `C0 `C1 `C2 `C3 `C4 `C5

////////////////
parameter	FULL_FLAG_SENSE          = 1;
parameter	AFULL_FLAG_SENSE         = 1;
parameter	WACK_FLAG_SENSE          = 1;
parameter	OVERFLOW_FLAG_SENSE      = 1;
parameter	PFULL_FLAG_SENSE         = 1;
parameter	EMPTY_FLAG_SENSE         = 1;
parameter	AEMPTY_FLAG_SENSE        = 1;
parameter	RACK_FLAG_SENSE          = 1;
parameter	UNDERFLW_FLAG_SENSE      = 1;
parameter	PEMPTY_FLAG_SENSE        = 1;
parameter	PGM_FULL_TYPE            = 1;
parameter   PGM_FULL_THRESH          = 14;
parameter	PGM_FULL_ATHRESH         = 14;
parameter	PGM_FULL_NTHRESH         = 3;
parameter	PGM_EMPTY_TYPE           = 1;
parameter   PGM_EMPTY_THRESH         = 3;
parameter	PGM_EMPTY_ATHRESH        = 3;
parameter	PGM_EMPTY_NTHRESH        = 3;
parameter   PGM_FLAG_LATENCY         = 0;


parameter	ADDR_WIDTH	             = `C2BITS;
parameter	CNT_WIDTH                = ADDR_WIDTH +1;

parameter	DATA_CNT_WIDTH	         = ADDR_WIDTH;


input                   Clock;
input 	[WIDTH-1:0]		Din;
input 					Write_enable;
output 					Full;
output 					Almost_full;
output 					Write_ack;
output 					Overflow;
output [CNT_WIDTH-1:0] Data_cnt;
output 					Prog_full;
input 	[CNT_WIDTH-1:0]	Prog_full_thresh;
input 	[CNT_WIDTH-1:0]	Prog_full_thresh_assert;
input 	[CNT_WIDTH-1:0]	Prog_full_thresh_negate;
output 	[WIDTH-1:0]		Dout;
input 					Read_enable;
output 					Empty;
output 					Almost_empty;
output 					Read_ack;
output 					Underflow;
output 					Prog_empty;
input 	[CNT_WIDTH-1:0]	Prog_empty_thresh;
input 	[CNT_WIDTH-1:0]	Prog_empty_thresh_assert;
input 	[CNT_WIDTH-1:0]	Prog_empty_thresh_negate;
input                   Reset;


wire [ADDR_WIDTH-1:0] wr_pointer;
wire [ADDR_WIDTH-1:0] rd_pointer;
wire [CNT_WIDTH-1:0] data_cnt;

assign Data_cnt = data_cnt[CNT_WIDTH-1:((CNT_WIDTH-1)-DATA_CNT_WIDTH)];
assign sys_rst  = Reset;
               
//Memory Instantiation
Sync_tdp_memory 
#(              .WIDTH(WIDTH), 
                .DEPTH(DEPTH),
                .ADDR_WIDTH(ADDR_WIDTH)
                )	
   fifo_mem_inst(
                .wr_clk(Clock),
                .din(Din),
                .wr_en(valid_write),
                .wr_addr(wr_pointer),
                .rd_clk(Clock),
                .dout(Dout),
                .rd_addr(rd_pointer),
                .rd_en(valid_read),
                .rst(sys_rst)
                );	


Sync_inc	
#(              .ADDR_WIDTH(ADDR_WIDTH)
                )	
   Sync_wr_pointer_inst (
                .clk(Clock),
                .rst(sys_rst),
                .inc_en(valid_write),
                .count(wr_pointer)
                );

Sync_inc	
#(              .ADDR_WIDTH(ADDR_WIDTH)
                )	
   Sync_rd_pointer_inst (
                .clk(Clock),
                .rst(sys_rst),
                .inc_en(valid_read),
                .count(rd_pointer)
                );


Sync_data_cnt 
#(              .CNT_WIDTH(CNT_WIDTH)
                ) 
   Sync_data_counter_inst( 
                .clk(Clock),
                .rst(sys_rst),
                .valid_write(valid_write),
                .valid_read(valid_read),
                .data_cnt(data_cnt)
                );

Sync_wr_ctrl	
#(              .CNT_WIDTH(CNT_WIDTH),
	            .DEPTH(DEPTH),
	            .FULL_FLAG_SENSE(FULL_FLAG_SENSE)
	            )	
		
	Sync_wr_ctrl_inst (
			    .clk(Clock),
			    .rst(sys_rst),
			    .write_enable(Write_enable),
			    .valid_write(valid_write),
			    .full(Full),
			    .data_cnt(data_cnt),
			    .read_enable(Read_enable),
                .valid_read(valid_read)
	            );


Sync_wr_status_flag  
#(              .CNT_WIDTH(CNT_WIDTH),
                .DEPTH(DEPTH),
                .AFULL_FLAG_SENSE(AFULL_FLAG_SENSE),
                .WACK_FLAG_SENSE(WACK_FLAG_SENSE),
                .PGM_FULL_TYPE(PGM_FULL_TYPE),
                .PGM_FULL_THRESH(PGM_FULL_THRESH),
                .PGM_FULL_ATHRESH(PGM_FULL_ATHRESH),
                .PGM_FULL_NTHRESH(PGM_FULL_NTHRESH),
                .OVERFLOW_FLAG_SENSE(OVERFLOW_FLAG_SENSE),
                .PFULL_FLAG_SENSE(PFULL_FLAG_SENSE),
                .PGM_FLAG_LATENCY(PGM_FLAG_LATENCY)
                )                   
   Sync_wr_status_flag_inst(
                .clk(Clock),
                .rst(sys_rst),
                .write_enable(Write_enable),
                .valid_write(valid_write),
                .Almost_full(Almost_full),
                .Write_ack(Write_ack),
                .Overflow(Overflow),
                .Prog_full(Prog_full),
                .Prog_full_thresh(Prog_full_thresh),
                .Prog_full_thresh_assert(Prog_full_thresh_assert),
                .Prog_full_thresh_negate(Prog_full_thresh_negate),
                .data_cnt(data_cnt),
                .valid_read(valid_read)
                 );


Sync_rd_ctrl	
#(              .CNT_WIDTH(CNT_WIDTH),
                .EMPTY_FLAG_SENSE(EMPTY_FLAG_SENSE)
                )	
   Sync_rd_ctrl_inst (
                .clk(Clock),
                .rst(sys_rst),
                .valid_write(valid_write),
                .data_cnt(data_cnt),
                .read_enable(Read_enable),
                .valid_read(valid_read),
                .empty(Empty)
                );

Sync_rd_status_flag 
#(              .CNT_WIDTH(CNT_WIDTH),
                .AEMPTY_FLAG_SENSE(AEMPTY_FLAG_SENSE),
                .RACK_FLAG_SENSE(RACK_FLAG_SENSE),
                .UNDERFLW_FLAG_SENSE(UNDERFLW_FLAG_SENSE),
                .PEMPTY_FLAG_SENSE(PEMPTY_FLAG_SENSE),
                .PGM_EMPTY_TYPE(PGM_EMPTY_TYPE),
                .PGM_EMPTY_THRESH(PGM_EMPTY_THRESH),
                .PGM_EMPTY_ATHRESH(PGM_EMPTY_ATHRESH),
                .PGM_EMPTY_NTHRESH(PGM_EMPTY_NTHRESH),
                .PGM_FLAG_LATENCY(PGM_FLAG_LATENCY)
                ) 
   Sync_rd_status_flag_inst(
                .clk(Clock),
                .rst(sys_rst),
                .valid_write(valid_write),
                .data_cnt(data_cnt),
                .read_enable(Read_enable),
                .Almost_empty(Almost_empty),
                .Read_ack(Read_ack),
                .Underflow(Underflow),
                .Prog_empty(Prog_empty),
                .Prog_empty_thresh(Prog_empty_thresh),
                .Prog_empty_thresh_assert(Prog_empty_thresh_assert),
                .Prog_empty_thresh_negate(Prog_empty_thresh_negate),
                .valid_read(valid_read)                                            
                 );


endmodule


/* Module data counter */
module Sync_data_cnt (
        clk,
		rst,
		valid_write,
		valid_read,
		data_cnt
		);

parameter CNT_WIDTH = 5;

input					clk;
input					rst;
input					valid_write;
input					valid_read;
output	[CNT_WIDTH-1:0]	data_cnt;

reg	[CNT_WIDTH-1:0] data_cnt;

assign  inc 		 = valid_write && !valid_read;
assign  dec 		 = valid_read && !valid_write;
	
always@(posedge clk `RST_CONDITION)
	if(rst)
		data_cnt	<= 'd0;
	else if(inc)
		data_cnt	<= data_cnt + 1;
	else if(dec)
		data_cnt	<= data_cnt - 1;

endmodule /* Module data counter */


/* Incrementor */
module Sync_inc	(
        clk,
		rst,
		inc_en,
		count
		);


parameter ADDR_WIDTH = 5;

input 			clk;
input				rst;
input 			inc_en;
output [ADDR_WIDTH-1:0] count;

reg [ADDR_WIDTH-1:0]	count;

always@(posedge clk `RST_CONDITION) begin
  	if(rst)
	  count	<= 'd0;
   	else if(inc_en) 
	  count	<= count + 1;
end

endmodule /* Incrementor */


/* Synchronous Read Control */
module Sync_rd_ctrl(
			clk,
			rst,
            valid_write,
			data_cnt,
			read_enable,
			valid_read,
			empty
			);

parameter   CNT_WIDTH           = 5;
parameter   EMPTY_FLAG_SENSE    = 1;

input 				clk;
input 				rst;
input               valid_write;
input	[CNT_WIDTH-1:0]  data_cnt;
input 				read_enable;
output 				valid_read;
output 				empty;

reg empty;

assign  valid_read   = !(empty == EMPTY_FLAG_SENSE) && read_enable;
assign  incCnt 		 = valid_write && !valid_read;
assign  decCnt 		 = valid_read && !valid_write;


always@(posedge clk `RST_CONDITION) begin
	if(rst)
		empty	<= EMPTY_FLAG_SENSE;
	else if((data_cnt == 'd0 && !incCnt) || (data_cnt == 'd1 && decCnt))
       	empty <= EMPTY_FLAG_SENSE;
   	else
       	empty <= !(EMPTY_FLAG_SENSE);
	end
endmodule  /* Synchronous Read Control */


/* Read Status Flag */
module Sync_rd_status_flag (	
			clk,
			rst,
            valid_write,
			data_cnt,
			read_enable,
            Almost_empty,
            Read_ack,
            Underflow,
            Prog_empty,
            Prog_empty_thresh,
            Prog_empty_thresh_assert,
            Prog_empty_thresh_negate,
            valid_read
            );

parameter           CNT_WIDTH           = 5;
parameter           AEMPTY_FLAG_SENSE   = 1;
parameter	        RACK_FLAG_SENSE     = 1;
parameter	        UNDERFLW_FLAG_SENSE = 1;
parameter	        PEMPTY_FLAG_SENSE   = 1;
parameter           PGM_EMPTY_TYPE      = 1;
parameter           PGM_EMPTY_THRESH    = 3;
parameter	        PGM_EMPTY_ATHRESH   = 3;
parameter	        PGM_EMPTY_NTHRESH   = 3;
parameter	        PGM_FLAG_LATENCY    = 1;

input                   clk;
input                   rst;
input                   valid_write;
input  [CNT_WIDTH-1:0]  data_cnt;
input                   read_enable;
input                   valid_read;
output                  Almost_empty;
output                  Read_ack;
output                  Underflow;
output                  Prog_empty;
input [CNT_WIDTH-1:0]  Prog_empty_thresh;
input [CNT_WIDTH-1:0]  Prog_empty_thresh_assert;
input [CNT_WIDTH-1:0]  Prog_empty_thresh_negate;


  	assign  incCnt 		 = valid_write && !valid_read;
  	assign  decCnt 		 = valid_read && !valid_write;

//Almost Empty Generation
    reg Almost_empty;
 	always@(posedge clk `RST_CONDITION) begin
		if(rst)
			Almost_empty	<= AEMPTY_FLAG_SENSE;
		else if((data_cnt == 0))
		    Almost_empty <= AEMPTY_FLAG_SENSE;
		else if((data_cnt == 'd1 && !incCnt) || (data_cnt == 'd2 && decCnt))
          	Almost_empty <= AEMPTY_FLAG_SENSE;
        	else
          	Almost_empty <= !(AEMPTY_FLAG_SENSE);
	end
//Read acknowledge Generation
    reg Read_ack;
    always@(posedge clk `RST_CONDITION) begin
        if(rst)
            Read_ack    <= !(RACK_FLAG_SENSE);
        else
            Read_ack    <= valid_read ? RACK_FLAG_SENSE : !(RACK_FLAG_SENSE);
    end
//UnderFlow Generation
    reg Underflow;
    always@(posedge clk `RST_CONDITION) begin
        if(rst)
            Underflow    <= !(UNDERFLW_FLAG_SENSE);
        else
            Underflow    <= (!valid_read & read_enable) ? UNDERFLW_FLAG_SENSE : !(UNDERFLW_FLAG_SENSE);
    end
//Programmable Empty Generation
    reg Prog_empty;
    reg [CNT_WIDTH-1:0] Prog_empty_thresh_assert_reg ;
    reg [CNT_WIDTH-1:0] Prog_empty_thresh_negate_reg;

    wire [CNT_WIDTH-1:0] Prog_empty_thresh;
    wire [CNT_WIDTH-1:0] Prog_empty_thresh_assert;    
    wire [CNT_WIDTH-1:0] Prog_empty_thresh_negate;    
    
generate 
	if (PGM_EMPTY_TYPE == 1)
		always@(rst,clk) begin
			Prog_empty_thresh_assert_reg    <= PGM_EMPTY_THRESH;
            Prog_empty_thresh_negate_reg    <= PGM_EMPTY_THRESH ;
		end
	else if(PGM_EMPTY_TYPE == 2) 
		always@(rst,clk) begin
			Prog_empty_thresh_assert_reg    <= PGM_EMPTY_ATHRESH;
	        Prog_empty_thresh_negate_reg    <= PGM_EMPTY_NTHRESH;
		end
	else
		always@(posedge clk `RST_CONDITION) begin
	        if(rst) begin
	            if (PGM_EMPTY_TYPE == 3) begin
	                Prog_empty_thresh_assert_reg    <= Prog_empty_thresh;
	                Prog_empty_thresh_negate_reg    <= Prog_empty_thresh;
	            end
	            else if (PGM_EMPTY_TYPE == 4) begin
	                Prog_empty_thresh_assert_reg    <= Prog_empty_thresh_assert;
	                Prog_empty_thresh_negate_reg    <= Prog_empty_thresh_negate;
	            end
	        end
	        else begin
	            Prog_empty_thresh_assert_reg <= Prog_empty_thresh_assert_reg;
	            Prog_empty_thresh_negate_reg <= Prog_empty_thresh_negate_reg;
	        end
		end
endgenerate

generate
begin
 if(PGM_FLAG_LATENCY == 0) begin
	always@(posedge clk `RST_CONDITION) begin
		if(rst) begin
			 Prog_empty	<= PEMPTY_FLAG_SENSE;
                end
		else if(data_cnt < Prog_empty_thresh_assert_reg) begin
          	              Prog_empty <= PEMPTY_FLAG_SENSE;
                end
                else if((data_cnt == (Prog_empty_thresh_assert_reg+1))& decCnt) begin
          	              Prog_empty <= PEMPTY_FLAG_SENSE;
                end
                else if((data_cnt == Prog_empty_thresh_negate_reg) & incCnt) begin
          	              Prog_empty <= !(PEMPTY_FLAG_SENSE);
                end
                else if(data_cnt > Prog_empty_thresh_negate_reg) begin
          	              Prog_empty <= !(PEMPTY_FLAG_SENSE);
                end
	end
  end
  else begin
	always@(posedge clk `RST_CONDITION) begin
		if(rst) begin
			 Prog_empty	<= PEMPTY_FLAG_SENSE;
                end
		else if(data_cnt <= Prog_empty_thresh_assert_reg) begin
          	              Prog_empty <= PEMPTY_FLAG_SENSE;
                end
                else if(data_cnt > Prog_empty_thresh_negate_reg) begin
          	              Prog_empty <= !(PEMPTY_FLAG_SENSE);
                end
	end
  end
end
endgenerate
endmodule /* Read Status Flag */


/*True Dual Port Memory*/
module Sync_tdp_memory(
		wr_clk, 
		din,	
		wr_en,	
		wr_addr,
		rd_clk, 
		dout,   
		rd_addr,
		rd_en,  
		rst	
		);

//Parameters

parameter   WIDTH      = 8;
parameter   DEPTH      = 16;
parameter   ADDR_WIDTH = 5;
			

input 			wr_clk;
input [WIDTH-1:0]		din;
input 			wr_en;
input [ADDR_WIDTH-1:0] wr_addr;
input 			rd_clk;
output [WIDTH-1:0]	dout;
input 			rd_en;
input [ADDR_WIDTH-1:0] rd_addr;
input 		rst;


	reg [WIDTH-1:0] mem [DEPTH-1:0] /*synthesis syn_ramstyle = "no_rw_check,block_ram"*/;


//Write Process
	always@(posedge wr_clk) begin
		if(wr_en)
			mem[wr_addr]	<= din;
	end

//Read Process
	reg [WIDTH-1:0] dout;
	always@(posedge rd_clk `RST_CONDITION) begin
		if(rst)
			dout	<= 'd0;
		else if(rd_en)
			dout	<= mem[rd_addr];
	end
	
endmodule /*True Dual Port Memory*/



/* Write COntoller */
module Sync_wr_ctrl(
			clk,
			rst,
			write_enable,
			valid_write,
			full,
			data_cnt,
			read_enable,
            valid_read
			);

parameter   CNT_WIDTH                   = 5;
parameter   DEPTH                       = 16;
parameter   FULL_FLAG_SENSE             = 1;

input 				clk;
input 				rst;
input				write_enable;
output 				valid_write;
output 				full;
input	[CNT_WIDTH-1:0]  data_cnt;
input 				read_enable;
input               valid_read;

	reg full;

  	assign  valid_write 		 = (!(full == FULL_FLAG_SENSE) || read_enable) && write_enable;
  	assign  incCnt 		 = valid_write && !valid_read;
  	assign  decCnt 		 = valid_read && !valid_write;

	always@(posedge clk `RST_CONDITION) begin
		if(rst) 
			full	<= !FULL_FLAG_SENSE;
		else if((data_cnt == DEPTH && !decCnt) || (data_cnt == DEPTH-1 && incCnt))
          	 full <= FULL_FLAG_SENSE;
        	else
          	 full <= !(FULL_FLAG_SENSE);
	end

endmodule /*Write Controller*/


/*Write Status Flag*/
module Sync_wr_status_flag (	
            clk,
			rst,
			write_enable,
			valid_write,
            Almost_full,
            Write_ack,
            Overflow,
            Prog_full,
            Prog_full_thresh,
            Prog_full_thresh_assert,
            Prog_full_thresh_negate,
			data_cnt,
            valid_read
            );

parameter           CNT_WIDTH                   = 5;
parameter           DEPTH                       = 16;
parameter	        AFULL_FLAG_SENSE            = 1;
parameter	        WACK_FLAG_SENSE             = 1;
parameter           PGM_FULL_TYPE               = 1;
parameter           PGM_FULL_THRESH             = 14;
parameter	        PGM_FULL_ATHRESH            = 14;
parameter	        PGM_FULL_NTHRESH            = 3;
parameter	        OVERFLOW_FLAG_SENSE         = 1;
parameter	        PFULL_FLAG_SENSE            = 1;
parameter	        PGM_FLAG_LATENCY            = 1;
          
input 				      clk;
input 				      rst;
input				      write_enable;
input 				      valid_write;
output                    Almost_full;
output                    Write_ack;
output                    Overflow;
output                    Prog_full;
input   [CNT_WIDTH-1:0]   Prog_full_thresh;
input   [CNT_WIDTH-1:0]   Prog_full_thresh_assert;
input   [CNT_WIDTH-1:0]   Prog_full_thresh_negate;
input	[CNT_WIDTH-1:0]   data_cnt;
input                     valid_read;



    assign  incCnt 		 = valid_write && !valid_read;
  	assign  decCnt 		 = valid_read && !valid_write;
//Almost Full Generation
    reg Almost_full;
	always@(posedge clk `RST_CONDITION) begin
		if(rst) 
			 Almost_full	<= !(AFULL_FLAG_SENSE);
		else if((data_cnt == DEPTH))
		 Almost_full <= AFULL_FLAG_SENSE;
		else if((data_cnt == DEPTH-1 && !decCnt) || (data_cnt == DEPTH-2 && incCnt))
          	 Almost_full <= AFULL_FLAG_SENSE;
        	else
          	 Almost_full <= !(AFULL_FLAG_SENSE);
	end

//Write acknowledge Generation
    reg Write_ack;
    always@(posedge clk `RST_CONDITION) begin
        if(rst)
            Write_ack   <= !(WACK_FLAG_SENSE);
        else
            Write_ack   <= valid_write ? WACK_FLAG_SENSE : !(WACK_FLAG_SENSE);
    end

//Overflow Generation
    reg Overflow;
    always@(posedge clk `RST_CONDITION) begin
        if(rst)
            Overflow   <= !(OVERFLOW_FLAG_SENSE);
        else
            Overflow   <= (!valid_write & write_enable) ? OVERFLOW_FLAG_SENSE : !(OVERFLOW_FLAG_SENSE);
    end

//Programmable Full generation
    reg Prog_full;
    reg [CNT_WIDTH-1:0] Prog_full_thresh_assert_reg ;
    reg [CNT_WIDTH-1:0] Prog_full_thresh_negate_reg;
    
    wire [CNT_WIDTH-1:0] Prog_full_thresh;
    wire [CNT_WIDTH-1:0] Prog_full_thresh_assert;    
    wire [CNT_WIDTH-1:0] Prog_full_thresh_negate; 
    
generate 
	if (PGM_FULL_TYPE == 1)
    	always@(clk,rst)begin
			Prog_full_thresh_assert_reg    <= PGM_FULL_THRESH;
            Prog_full_thresh_negate_reg    <= PGM_FULL_THRESH;
		end
	else if (PGM_FULL_TYPE == 2)
		always@(clk,rst)begin
			Prog_full_thresh_assert_reg    <= PGM_FULL_ATHRESH;
            Prog_full_thresh_negate_reg    <= PGM_FULL_NTHRESH;
		end
	else
	    always@(posedge clk `RST_CONDITION) begin
	        if(rst) begin
	            if (PGM_FULL_TYPE == 3) begin
	                Prog_full_thresh_assert_reg    <= Prog_full_thresh;
	                Prog_full_thresh_negate_reg    <= Prog_full_thresh;
	            end
	            else if (PGM_FULL_TYPE == 4) begin
	                Prog_full_thresh_assert_reg    <= Prog_full_thresh_assert;
	                Prog_full_thresh_negate_reg    <= Prog_full_thresh_negate;
	            end
	
	        end
	        else begin
	            Prog_full_thresh_assert_reg <= Prog_full_thresh_assert_reg;
	            Prog_full_thresh_negate_reg <= Prog_full_thresh_negate_reg;
	        end
	    end
endgenerate

generate
begin
 if(PGM_FLAG_LATENCY == 0) begin
	always@(posedge clk `RST_CONDITION) begin
		if(rst) begin
			 Prog_full	<= !(PFULL_FLAG_SENSE);
                end
                else if((data_cnt == (Prog_full_thresh_assert_reg-1)) & incCnt) begin
                         Prog_full <= PFULL_FLAG_SENSE;
                end
                else if((data_cnt == Prog_full_thresh_negate_reg) & decCnt) begin
          	              Prog_full <= !(PFULL_FLAG_SENSE);
                end
		else if(data_cnt > Prog_full_thresh_assert_reg) begin
          	              Prog_full <= PFULL_FLAG_SENSE;
                end                
                else if(data_cnt < Prog_full_thresh_negate_reg) begin
          	              Prog_full <= !(PFULL_FLAG_SENSE);
                end
	end
  end
  else begin
	always@(posedge clk `RST_CONDITION) begin
		if(rst) begin
			 Prog_full	<= (PFULL_FLAG_SENSE);
                end
		else if(data_cnt >= Prog_full_thresh_assert_reg) begin
          	              Prog_full <= PFULL_FLAG_SENSE;
                end
                else if(data_cnt < Prog_full_thresh_negate_reg) begin
          	              Prog_full <= !(PFULL_FLAG_SENSE);
                end
	end
  end
end
endgenerate
endmodule /*Write Status Flag*/



