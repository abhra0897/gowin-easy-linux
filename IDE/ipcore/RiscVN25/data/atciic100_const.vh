`ifndef ATCIIC100_CONST_VH
`define ATCIIC100_CONST_VH
`include "ae250_config.vh"
`include "ae250_const.vh"
	`define ATCIIC100_PRODUCT_ID 32'h02021011
	`define ATCIIC100_DATA_WIDTH 8

	`ifdef ATCIIC100_FIFO_DEPTH_4
		`define ATCIIC100_INDEX_WIDTH	3
		`define ATCIIC100_FIFO_CONFIG	2'h1
	`else
		`ifdef ATCIIC100_FIFO_DEPTH_8
			`define ATCIIC100_INDEX_WIDTH		4
			`define ATCIIC100_FIFO_CONFIG		2'h2
		`else
			`ifdef ATCIIC100_FIFO_DEPTH_16
				`define ATCIIC100_INDEX_WIDTH		5
				`define ATCIIC100_FIFO_CONFIG		2'h3
			`else
				`define ATCIIC100_INDEX_WIDTH		2
				`define ATCIIC100_FIFO_CONFIG		2'h0
			`endif
		`endif
	`endif
`endif
