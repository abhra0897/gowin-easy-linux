`timescale 1 ns / 1 ps
`include "top_defines.v"

module `MODULE_NAME	(
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
				input		[`SDRAM_ADDR_COLUMN_WIDTH-1:0]	I_sdrc_data_len,
				input		[`SDRAM_DQM_WIDTH-1:0]			I_sdrc_dqm,
				input		[`SDRAM_DATA_WIDTH-1:0]	 		I_sdrc_data, 
				output	    [`SDRAM_DATA_WIDTH-1:0]	 		O_sdrc_data,
				output	    O_sdrc_init_done,
				output	    O_sdrc_busy_n, 	
				output	    O_sdrc_rd_valid,
				output	    O_sdrc_wrd_ack
				);

`getname(top,`MODULE_NAME) sdrc_top_inst(
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
					.IO_sdram_dq(IO_sdram_dq),
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
