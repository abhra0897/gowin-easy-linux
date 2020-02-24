`ifndef ATCDMAC100_CONST_VH
`define ATCDMAC100_CONST_VH

`include "ae250_config.vh"
`include "ae250_const.vh"

`define ATCDMAC100_PRODUCT_ID	32'h01021013

`ifdef ATCDMAC100_ADDR_WIDTH_24
	`define ATCDMAC100_ADDR_WIDTH	24
`else
	`define ATCDMAC100_ADDR_WIDTH	32
`endif

`ifdef ATCDMAC100_CHAIN_TRANSFER_SUPPORT
	`define ATCDMAC100_CHAIN_TRANSFER_EXIST		1'b1
`else
	`define ATCDMAC100_CHAIN_TRANSFER_EXIST		1'b0
`endif

`ifdef ATCDMAC100_REQ_SYNC_SUPPORT
	`define ATCDMAC100_REQ_SYNC_EXIST		1'b1
`else
	`define ATCDMAC100_REQ_SYNC_EXIST		1'b0
`endif

`ifdef ATCDMAC100_FIFO_DEPTH_4
	`define ATCDMAC100_FIFO_DEPTH 		6'd4
	`define ATCDMAC100_FIFO_POINTER_WIDTH	3
	`define ATCDMAC100_FIFO_BYTE		4'h4
`else
	`ifdef ATCDMAC100_FIFO_DEPTH_8
		`define ATCDMAC100_FIFO_DEPTH 		6'd8
		`define ATCDMAC100_FIFO_POINTER_WIDTH	4
		`define ATCDMAC100_FIFO_BYTE		4'h5
	`else
		`ifdef ATCDMAC100_FIFO_DEPTH_16
			`define ATCDMAC100_FIFO_DEPTH 		6'd16
			`define ATCDMAC100_FIFO_POINTER_WIDTH	5
			`define ATCDMAC100_FIFO_BYTE		4'h6
		`else
			`ifdef ATCDMAC100_FIFO_DEPTH_32
				`define ATCDMAC100_FIFO_DEPTH 		6'd32
				`define ATCDMAC100_FIFO_POINTER_WIDTH	6
				`define ATCDMAC100_FIFO_BYTE		4'h7
			`endif
		`endif
	`endif
`endif

`ifdef ATCDMAC100_CH_NUM_1
	`define ATCDMAC100_CH_NUM       4'h1
	`define DMAC_CONFIG_CH0
`else
	`ifdef ATCDMAC100_CH_NUM_2
		`define ATCDMAC100_CH_NUM       4'h2
		`define DMAC_CONFIG_CH0
		`define DMAC_CONFIG_CH1
	`else
		`ifdef ATCDMAC100_CH_NUM_3
			`define ATCDMAC100_CH_NUM       4'h3
			`define DMAC_CONFIG_CH0
			`define DMAC_CONFIG_CH1
			`define DMAC_CONFIG_CH2
		`else
			`ifdef ATCDMAC100_CH_NUM_4
				`define ATCDMAC100_CH_NUM       4'h4
				`define DMAC_CONFIG_CH0
				`define DMAC_CONFIG_CH1
				`define DMAC_CONFIG_CH2
				`define DMAC_CONFIG_CH3
			`else
				`ifdef ATCDMAC100_CH_NUM_5
					`define ATCDMAC100_CH_NUM       4'h5
					`define DMAC_CONFIG_CH0
					`define DMAC_CONFIG_CH1
					`define DMAC_CONFIG_CH2
					`define DMAC_CONFIG_CH3
					`define DMAC_CONFIG_CH4
				`else
					`ifdef ATCDMAC100_CH_NUM_6
						`define ATCDMAC100_CH_NUM       4'h6
						`define DMAC_CONFIG_CH0
						`define DMAC_CONFIG_CH1
						`define DMAC_CONFIG_CH2
						`define DMAC_CONFIG_CH3
						`define DMAC_CONFIG_CH4
						`define DMAC_CONFIG_CH5
					`else
						`ifdef ATCDMAC100_CH_NUM_7
							`define ATCDMAC100_CH_NUM       4'h7
							`define DMAC_CONFIG_CH0
							`define DMAC_CONFIG_CH1
							`define DMAC_CONFIG_CH2
							`define DMAC_CONFIG_CH3
							`define DMAC_CONFIG_CH4
							`define DMAC_CONFIG_CH5
							`define DMAC_CONFIG_CH6
						`else
							`ifdef ATCDMAC100_CH_NUM_8
								`define ATCDMAC100_CH_NUM       4'h8
								`define DMAC_CONFIG_CH0
								`define DMAC_CONFIG_CH1
								`define DMAC_CONFIG_CH2
								`define DMAC_CONFIG_CH3
								`define DMAC_CONFIG_CH4
								`define DMAC_CONFIG_CH5
								`define DMAC_CONFIG_CH6
								`define DMAC_CONFIG_CH7
							`endif
						`endif
					`endif
				`endif
			`endif
		`endif
	`endif
`endif

`endif
