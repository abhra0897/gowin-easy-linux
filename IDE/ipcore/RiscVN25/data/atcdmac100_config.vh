`ifndef ATCDMAC100_CONFIG_VH
`define ATCDMAC100_CONFIG_VH
`include "ae250_config.vh"
`include "ae250_const.vh"

//-------------------------------------------------
// DMAC Address Width
//-------------------------------------------------
//`define ATCDMAC100_ADDR_WIDTH_24


//-------------------------------------------------
// DMAC Channel Number
//-------------------------------------------------
// Available value: 1~8
`define ATCDMAC100_CH_NUM_8

//-------------------------------------------------
// DMAC FIFO DEPTH
//-------------------------------------------------
//`define ATCDMAC100_FIFO_DEPTH_4
//`define ATCDMAC100_FIFO_DEPTH_8
//`define ATCDMAC100_FIFO_DEPTH_16
//`define ATCDMAC100_FIFO_DEPTH_32

//-------------------------------------------------
// DMAC Request/Acknowledge Handshake
//-------------------------------------------------
`ifdef AE250_DMA_EXTREQ_SUPPORT 
	`define ATCDMAC100_REQ_ACK_NUM	(6'd9 + `AE250_DMA_EXTREQ_NUM)
`else //~AE250_DMA_EXTREQ_SUPPORT 
	`define ATCDMAC100_REQ_ACK_NUM	6'd9
`endif //AE250_DMA_EXTREQ_SUPPORT 

//`define ATCDMAC100_REQ_SYNC_SUPPORT

//-------------------------------------------------
// DMAC Chain Transfer Support
//-------------------------------------------------
//`define ATCDMAC100_CHAIN_TRANSFER_SUPPORT

`endif // ATCDMAC100_CONFIG_VH

