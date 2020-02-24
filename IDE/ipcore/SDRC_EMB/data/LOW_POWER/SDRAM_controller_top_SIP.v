
`include "top_defines.v"


module `MODULE_NAME
				(
				//SDRAM
				output	O_sdram_clk,
				output	O_sdram_cke, 	
				output	O_sdram_cs_n, 	
				output	O_sdram_cas_n, 
				output	O_sdram_ras_n, 
				output	O_sdram_wen_n, 	
				output	[`SDRAM_DQM_WIDTH-1:0]	 O_sdram_dqm, 				
				output	[`SDRAM_ADDR_WIDTH-1:0]	 O_sdram_addr, 
				output	[`SDRAM_BANK_WIDTH-1:0]	 O_sdram_ba, 
				inout	[`SDRAM_DATA_WIDTH-1:0]	 IO_sdram_dq,
				// User Interface
				input		I_sdrc_rst_n, 	
				input		I_sdrc_clk, 
				input		I_sdram_clk, 
				input		I_sdrc_selfrefresh,
				input		I_sdrc_power_down,	
				input		I_sdrc_wr_n, 
				input		I_sdrc_rd_n, 
				input		[`USER_ADDR_WIDTH-1:0]	 		I_sdrc_addr,
				input		[`SDRAM_ADDR_COLUMN_WIDTH-2:0]	I_sdrc_data_len,
				input		[`SDRAM_DQM_WIDTH*2-1:0]			I_sdrc_dqm,
				output	reg    [`SDRAM_DATA_WIDTH*2-1:0]	    O_sdrc_data,   
				input		[`SDRAM_DATA_WIDTH*2-1:0]	    I_sdrc_data,  
				output	    O_sdrc_init_done,
				output	    O_sdrc_busy_n, 	
				output	    O_sdrc_rd_valid,
				output	    O_sdrc_wrd_ack
				);

  wire [`SDRAM_DATA_WIDTH-1:0]    IO_sdram_dq1;
  wire [`SDRAM_DATA_WIDTH-1:0]    IO_sdram_dq0;
  wire [`SDRAM_DATA_WIDTH-1:0]    O_sdram_dq_oen;
  assign IO_sdram_dq0 = IO_sdram_dq;
  generate
	genvar m ;
        for(m=0;m<=`SDRAM_DATA_WIDTH-1;m=m+1) 
		begin
            assign IO_sdram_dq[m]=(!O_sdram_dq_oen[m])?IO_sdram_dq1[m]:{1'bz};
        end
    endgenerate

`getname(top,`MODULE_NAME)	sdrc_top_inst(
				     //SDRAM used IO, not connect user design
					.O_sdram_clk(O_sdram_clk),
					.O_sdram_cke(O_sdram_cke), 	
					.O_sdram_cs_n(O_sdram_cs_n), 	
					.O_sdram_cas_n(O_sdram_cas_n), 
					.O_sdram_ras_n(O_sdram_ras_n), 
					.O_sdram_wen_n(O_sdram_wen_n), 	
					.O_sdram_dqm(O_sdram_dqm), 				
					.O_sdram_addr(O_sdram_addr), 
					.O_sdram_ba(O_sdram_ba),
                    .O_sdram_dq_oen(O_sdram_dq_oen),
                    .IO_sdram_dq1(IO_sdram_dq1), 
					.IO_sdram_dq0(IO_sdram_dq0),
				     //User IO, should connet user design
					.I_sdrc_rst_n(I_sdrc_rst_n), 	
					.I_sdrc_clk(I_sdrc_clk), 
					.I_sdram_clk(I_sdram_clk), 
					.I_sdrc_selfrefresh(I_sdrc_selfrefresh),
					.I_sdrc_power_down(I_sdrc_power_down),
					.I_sdrc_wr_n(I_sdrc_wr_n), 
				    .I_sdrc_rd_n(I_sdrc_rd_n), 
					.I_sdrc_addr(I_sdrc_addr),
					.I_sdrc_data_len(I_sdrc_data_len),
					.I_sdrc_dqm(I_sdrc_dqm),
					.I_sdrc_data(I_sdrc_data), 
					.O_sdrc_data(O_sdrc_data),  
					.O_sdrc_init_done(O_sdrc_init_done),
					.O_sdrc_busy_n(O_sdrc_busy_n), 	
					.O_sdrc_rd_valid(O_sdrc_rd_valid),
					.O_sdrc_wrd_ack(O_sdrc_wrd_ack)
 				);
endmodule
