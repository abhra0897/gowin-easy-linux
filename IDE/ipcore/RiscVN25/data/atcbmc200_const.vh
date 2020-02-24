`ifndef ATCBMC200_CONST_VH
`define ATCBMC200_CONST_VH


`define ATCBMC200_AHB_MST0

`define ATCBMC200_AHB_SLV0
`ifdef ATCBMC200_ADDR_WIDTH_24
	`define ATCBMC200_AHB_SLV0_SIZE  4'h3
`else
	`define ATCBMC200_AHB_SLV0_SIZE  4'h1
`endif


`ifdef ATCBMC200_ADDR_WIDTH_24
  `define ATCBMC200_ADDR_MSB       23
  `define ATCBMC200_BASEINADDR_LSB 10
  `define ATCBMC200_BASE_MSB       13
`else
  `define ATCBMC200_ADDR_MSB       31
  `define ATCBMC200_BASEINADDR_LSB 20
  `define ATCBMC200_BASE_MSB       11
`endif


`define HTRANS_IDLE     2'b00
`define HTRANS_BUSY     2'b01
`define HTRANS_NONSEQ   2'b10
`define HTRANS_SEQ      2'b11

`define HRESP_OK       2'b00
`define HRESP_ERROR    2'b01
`define HRESP_RETRY    2'b10
`define HRESP_SPLIT    2'b11

`define ATCBMC200_PRODUCT_ID	32'h00002023


`endif


