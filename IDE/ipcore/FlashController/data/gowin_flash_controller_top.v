// ===========Oooo==========================================Oooo================================
// =        Copyright (C) 2014-2020 ShanDong Gowin Semiconductor Technology Co.,Ltd.   
// =                                 All rights reserved.                         
// =============================================================================================
//           
//  __      __      __  
//  \ \    /  \    / /   [IP name     ] Gowin Flash Controller
//   \ \  / /\ \  / /    [Authors     ] Gowin Semiconductor Technology Co.,Ltd.
//    \ \/ /  \ \/ /     [Description ] TOP Verilog file for Gowin Flash Controller design
//     \  /    \  /      [Version     ] 1.4
//      \/      \/       
//---------------------------------------------------------------------------------------------  
// Code Revision History :
//---------------------------------------------------------------------------------------------
// Ver :  |  Author  |  Mod. Date  |  Changes Made
// 1.0    |  Emb     |  08/30/2019 |  Initial version
// 1.1    |  Emb     |  10/24/2019 |  Support FLASH64K/608K
// 1.2    |  Emb     |  11/04/2019 |  Support GW1NRF-4B
// 1.3    |  Emb     |  11/12/2019 |  Fixed known issues of FLASH96K
// 1.4    |  Emb     |  01/01/2020 |  Support AHB bus interface and FLASH64K
// ===========Oooo==========================================Oooo================================

`include "config.v"
`include "gowin_flash_controller_name.v"

module `module_name_flash
(
	//FLASH96K
	`ifdef FLASH_SIZE_96K
		//Register Interface
		`ifdef REG_IF
                input   wire        clk_i,//50MHZ
                input   wire        nrst_i,
                input   wire        r_en_i,
                input   wire        clear_page_enable_i,
                input   wire        prog_enable_i,
                input   wire        write_page_enable_i,
                input   wire        erase_en_i,
                input   wire        pre_prog_i,

                input   wire [ 8:0] wyaddr_i,
                input   wire [ 5:0] wxaddr_i,
                input   wire [ 5:0] page_address,
                input   wire [31:0] wdata_i,
                output  wire [31:0] rdata_o,
                output  wire        done_flag_o
		`endif
	`endif
	
	//FLASH256K
	`ifdef FLASH_SIZE_256K
		//Wishbone Interface
		`ifdef WISHBONE_IF
                input   wire            wb_clk_i,//master clock input
                input   wire            wb_rst_i,//synchronous active high reset

                input   wire  [4:0]     wb_addr_i,//lower address bits
                input   wire  [31:0]    wb_data_i,//data bus input
                output  wire  [31:0]    wb_data_o,//data bus output
                input   wire            wb_we_i, //write enable input
                input   wire            wb_stb_i,//stobe/core select signal
                input   wire            wb_cyc_i,//valid bus cycle input
                output  wire            wb_ack_o//bus cycle acknowledge output
		`endif
		//Register Interface
		`ifdef REG_IF
				input   wire  [31:0] 	wdata_i,//write data into flash
				input	wire  [5:0]  	wyaddr_i,//write y direction address
				input	wire  [6:0] 	wxaddr_i,//write x direction address
				input	wire	   		erase_en_i,//enable erase, 1:enable
				output	wire	   		done_flag_o,//erase completely flag
				input	wire	   		start_flag_i,//start erase flag
				input	wire 			clk_i,//input clock
				input	wire			nrst_i,//input reset
				output	wire  [31:0]    rdata_o,//read data from flash
				input	wire	   		wr_en_i//write/read enable, 1:write,0:read
		`endif
		//AHB Interface
        `ifdef AHB_IF
                output	wire	[31:0]	AHB_HRDATA,//read data bus
	            output	wire			AHB_HREADY,//slave ready
	            output	wire	[ 1:0]	AHB_HRESP,//slave response
	            input	wire	[ 1:0]  AHB_HTRANS,//transfer type
				input	wire	[ 2:0]	AHB_HSIZE,//transfer size
				input	wire			AHB_HWRITE,//transfer direction
				input	wire	[31:0]	AHB_HADDR,//address bus
				input	wire	[31:0]  AHB_HWDATA,//write data bus
				input	wire			AHB_HSEL,//select slave
				input	wire			AHB_HCLK,//system clock //50MHz
				input	wire			AHB_HRESETn//system reset
        `endif
	`endif

	//FLASH608K
	`ifdef FLASH_SIZE_608K
		//Wishbone Interface
		`ifdef WISHBONE_IF
                input   wire            wb_clk_i,//master clock input
                input   wire            wb_rst_i,//synchronous active high reset

                input   wire  [4:0]     wb_addr_i,//lower address bits
                input   wire  [31:0]    wb_data_i,//data bus input
                output  wire  [31:0]    wb_data_o,//data bus output
                input   wire            wb_we_i, //write enable input
                input   wire            wb_stb_i,//stobe/core select signal
                input   wire            wb_cyc_i,//valid bus cycle input
                output  wire            wb_ack_o//bus cycle acknowledge output
		`endif
		//Register Interface
		`ifdef REG_IF
				input   wire  [31:0] 	wdata_i,//write data into flash
				input	wire  [5:0]  	wyaddr_i,//write y direction address
				input	wire  [8:0] 	wxaddr_i,//write x direction address
				input	wire	   		erase_en_i,//enable erase, 1:enable
				output	wire	   		done_flag_o,//erase completely flag
				input	wire	   		start_flag_i,//start erase flag
				input	wire 			clk_i,//input clock
				input	wire			nrst_i,//input reset
				output	wire  [31:0]    rdata_o,//read data from flash
				input	wire	   		wr_en_i//write/read enable, 1:write,0:read
		`endif
		//AHB Interface
        `ifdef AHB_IF
                output	wire	[31:0]	AHB_HRDATA,//read data bus
	            output	wire			AHB_HREADY,//slave ready
	            output	wire	[ 1:0]	AHB_HRESP,//slave response
	            input	wire	[ 1:0]  AHB_HTRANS,//transfer type
				input	wire	[ 2:0]	AHB_HSIZE,//transfer size
				input	wire			AHB_HWRITE,//transfer direction
				input	wire	[31:0]	AHB_HADDR,//address bus
				input	wire	[31:0]  AHB_HWDATA,//write data bus
				input	wire			AHB_HSEL,//select slave
				input	wire			AHB_HCLK,//system clock //50MHZ
				input	wire			AHB_HRESETn//system reset
        `endif
	`endif

	//FLASH64KZ
	`ifdef FLASH_SIZE_64K
		//Register Interface
		`ifdef REG_IF
				input   wire  [31:0] 	wdata_i,//write data into flash
				input	wire  [5:0]  	wyaddr_i,//write y direction address
				input	wire  [4:0] 	wxaddr_i,//write x direction address
				input	wire	   		erase_en_i,//enable erase, 1:enable
				output	wire	   		done_flag_o,//erase completely flag
				input	wire	   		start_flag_i,//start erase flag
				input	wire 			clk_i,//input clock
				input	wire			nrst_i,//input reset
				output	wire  [31:0]    rdata_o,//read data from flash
				input	wire	   		wr_en_i//write/read enable, 1:write,0:read
		`endif
	`endif

	//FLASH64K
	`ifdef FLASH_SIZE_64KZ
		//Register Interface
		`ifdef REG_IF
				input   wire  [31:0] 	wdata_i,//write data into flash
				input	wire  [5:0]  	wyaddr_i,//write y direction address
				input	wire  [4:0] 	wxaddr_i,//write x direction address
				input	wire	   		erase_en_i,//enable erase, 1:enable
				output	wire	   		done_flag_o,//erase completely flag
				input	wire	   		start_flag_i,//start erase flag
				input	wire 			clk_i,//input clock
				input	wire			nrst_i,//input reset
				output	wire  [31:0]    rdata_o,//read data from flash
				input	wire	   		wr_en_i,//write/read enable, 1:write,0:read
                input   wire            sleep_i//dynamic sleep
		`endif
	`endif
);

//FLASH96K
`ifdef FLASH_SIZE_96K
	//Register Interface
	`ifdef REG_IF
		GW_USER_FLASH_96K u_GW_USER_FLASH_96K
		(
    		.clk            (clk_i),//50MHZ
    		.rst_n          (nrst_i),
    		.read           (r_en_i),
    		.clear_page     (clear_page_enable_i),
    		.prog           (prog_enable_i),
    		.write_page     (write_page_enable_i),
    		.erase          (erase_en_i),
    		.pre_prog       (pre_prog_i),

    		.row_address    (wyaddr_i),
    		.colu_address   (wxaddr_i),
    		.page_address   (page_address),
    		.data_in        (wdata_i),
    		.data_out       (rdata_o),
    		.done           (done_flag_o)
		);
	`endif
`endif

//FLASH256K
`ifdef FLASH_SIZE_256K
	//Wishbone Interface
	`ifdef WISHBONE_IF
		Wishbone_Master_Top_256K u_Wishbone_Master_Top_256K
		(
        	.wb_clk_i(wb_clk_i),// master clock input
        	.wb_rst_i(wb_rst_i),// synchronous active high reset
		
        	.wb_adr_i(wb_addr_i),// lower address bits
        	.wb_dat_i(wb_data_i),// data bus input
        	.wb_dat_o(wb_data_o),// data bus output
        	.wb_we_i(wb_we_i), // write enable input
        	.wb_stb_i(wb_stb_i),// stobe/core select signal
        	.wb_cyc_i(wb_cyc_i),// valid bus cycle input
        	.wb_ack_o(wb_ack_o)// bus cycle acknowledge output
		);
	`endif
	//Register Interface
	`ifdef REG_IF
		Flash_Ctroller_256K u_Flash_Ctroller_256K
		(
			.clk            (clk_i      ),
			.nreset         (nrst_i     ), 
			.wdata_i        (wdata_i    ),
			.w_r_signal     (wr_en_i    ),
			.wxaddr_i       (wxaddr_i   ),
			.wyaddr_i       (wyaddr_i   ),
			.Done_signal    (done_flag_o),
			.Start_signal   (start_flag_i),
			.rdata_o        (rdata_o    ),
			.erase_i        (erase_en_i )
		);
	`endif
	//AHB Interface
    `ifdef AHB_IF
        AHB_Master_Top_256K u_AHB_Master_Top_256K
		(
			.AHB_HRDATA     (AHB_HRDATA),
			.AHB_HREADY     (AHB_HREADY),
			.AHB_HRESP      (AHB_HRESP ),
			.AHB_HTRANS     (AHB_HTRANS),
			.AHB_HSIZE      (AHB_HSIZE ),
			.AHB_HWRITE     (AHB_HWRITE),
			.AHB_HADDR      (AHB_HADDR ),
			.AHB_HWDATA     (AHB_HWDATA),
			.AHB_HSEL       (AHB_HSEL  ),
			.AHB_HCLK       (AHB_HCLK  ),
			.AHB_HRESETn    (AHB_HRESETn)
         );
    `endif
`endif

//FLASH608K
`ifdef FLASH_SIZE_608K
	//Wishbone Interface
	`ifdef WISHBONE_IF
		Wishbone_Master_Top_608K u_Wishbone_Master_Top_608K
		(
        	.wb_clk_i(wb_clk_i),// master clock input
        	.wb_rst_i(wb_rst_i),// synchronous active high reset
		
        	.wb_adr_i(wb_addr_i),// lower address bits
        	.wb_dat_i(wb_data_i),// data bus input
        	.wb_dat_o(wb_data_o),// data bus output
        	.wb_we_i(wb_we_i), // write enable input
        	.wb_stb_i(wb_stb_i),// stobe/core select signal
        	.wb_cyc_i(wb_cyc_i),// valid bus cycle input
        	.wb_ack_o(wb_ack_o)// bus cycle acknowledge output
		);
	`endif
	//Register Interface
	`ifdef REG_IF
		Flash_Ctroller_608K u_Flash_Ctroller_608K
		(
			.clk(clk_i),
			.nreset(nrst_i), 
			.wdata_i(wdata_i),
			.w_r_signal(wr_en_i),
			.wxaddr_i(wxaddr_i),
			.wyaddr_i(wyaddr_i),
			.Done_signal(done_flag_o),
			.Start_signal(start_flag_i),
			.rdata_o(rdata_o),
			.erase_i(erase_en_i)
		);
	`endif
	//AHB Interface
    `ifdef AHB_IF
        AHB_Master_Top_608K u_AHB_Master_Top_608K
		(
			.AHB_HRDATA     (AHB_HRDATA),
			.AHB_HREADY     (AHB_HREADY),
			.AHB_HRESP      (AHB_HRESP ),
			.AHB_HTRANS     (AHB_HTRANS),
			.AHB_HSIZE      (AHB_HSIZE ),
			.AHB_HWRITE     (AHB_HWRITE),
			.AHB_HADDR      (AHB_HADDR ),
			.AHB_HWDATA     (AHB_HWDATA),
			.AHB_HSEL       (AHB_HSEL  ),
			.AHB_HCLK       (AHB_HCLK  ),
			.AHB_HRESETn    (AHB_HRESETn)
         );
    `endif
`endif

//FLASH64KZ
`ifdef FLASH_SIZE_64K
	//Resgister Interface
	`ifdef REG_IF
		Flash_Ctroller_64K u_Flash_Ctroller_64K
		(
			.clk(clk_i),
			.nreset(nrst_i), 
			.wdata_i(wdata_i),
			.w_r_signal(wr_en_i),
			.wxaddr_i(wxaddr_i),
			.wyaddr_i(wyaddr_i),
			.Done_signal(done_flag_o),
			.Start_signal(start_flag_i),
			.rdata_o(rdata_o),
			.erase_i(erase_en_i)
		);
	`endif
`endif

//FLASH64K
`ifdef FLASH_SIZE_64KZ
	//Resgister Interface
	`ifdef REG_IF
		Flash_Ctroller_64KZ u_Flash_Ctroller_64KZ
		(
			.clk(clk_i),
			.nreset(nrst_i), 
			.wdata_i(wdata_i),
			.w_r_signal(wr_en_i),
			.wxaddr_i(wxaddr_i),
			.wyaddr_i(wyaddr_i),
			.Done_signal(done_flag_o),
			.Start_signal(start_flag_i),
			.rdata_o(rdata_o),
			.erase_i(erase_en_i),
            .sleep_i(sleep_i)
		);
	`endif
`endif

endmodule
