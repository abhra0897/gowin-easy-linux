`ifndef ATCGPIO100_CONST_VH
`define ATCGPIO100_CONST_VH
`include "ae250_config.vh"
`include "ae250_const.vh"

`define ATCGPIO100_PRODUCT_ID        32'h02031001

`ifdef ATCGPIO100_PULL_SUPPORT
	`define _ATCGPIO100_PULL_EXIST		1'b1
`else
	`define _ATCGPIO100_PULL_EXIST		1'b0
`endif
`ifdef ATCGPIO100_INTR_SUPPORT
	`define _ATCGPIO100_INTR_EXIST		1'b1
`else
	`define _ATCGPIO100_INTR_EXIST		1'b0
`endif
`ifdef ATCGPIO100_DEBOUNCE_SUPPORT
	`define _ATCGPIO100_DEBOUNCE_EXIST	1'b1
`else
	`define _ATCGPIO100_DEBOUNCE_EXIST	1'b0
`endif

`endif

