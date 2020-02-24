`ifndef ATCSPI200_CONFIG_VH
`define ATCSPI200_CONFIG_VH
`include "ae250_config.vh"
`include "ae250_const.vh"
// --------------------------------------------------------------------------
// Define register port:
// 1. The register port can be one of AHB/APB
// 2. Default is APB
// --------------------------------------------------------------------------
//`define ATCSPI200_REG_AHB

// --------------------------------------------------------------------------
// Define memory access function:
// 1. AHB/EILM
// 2. Default is NA
// --------------------------------------------------------------------------
`define ATCSPI200_AHB_MEM_SUPPORT
//`define ATCSPI200_EILM_MEM_SUPPORT

// --------------------------------------------------------------------------
// Define Slave Mode support
// define ATCSPI200_SLAVE_SUPPORT to support SPI Slave Mode
// --------------------------------------------------------------------------
//`define ATCSPI200_SLAVE_SUPPORT

// --------------------------------------------------------------------------
// The macros below will effect the SPI interfaces of ATCSPI200
// define ATCSPI200_DUALSPI_SUPPORT to support dual SPI device.
// define ATCSPI200_QUADSPI_SUPPORT to support quad and dual SPI device
// --------------------------------------------------------------------------
//`define ATCSPI200_DUALSPI_SUPPORT
//`define ATCSPI200_QUADSPI_SUPPORT

// --------------------------------------------------------------------------
// Define the depth of TX and RX fifo
// The values must be one of 2, 4, 8, 16 words
// The TX and RX values can be different
// --------------------------------------------------------------------------
//`define ATCSPI200_TXFIFO_DEPTH_4W
//`define ATCSPI200_TXFIFO_DEPTH_8W
//`define ATCSPI200_RXFIFO_DEPTH_4W
//`define ATCSPI200_RXFIFO_DEPTH_8W

// --------------------------------------------------------------------------
// Define the bit number of haddr
// if ATCSPI200_ADDR_WIDTH_24 is defined, the haddr will be 24bits.
// if ATCSPI200_ADDR_WIDTH_24 is not defined, the haddr will be 32bits.
// --------------------------------------------------------------------------
//`define ATCSPI200_ADDR_WIDTH_24

// --------------------------------------------------------------------------
// Define ATCSPI200_DIRECT_IO_SUPPORT to support the SPI direct I/O control.
// This macro will cost some area
// --------------------------------------------------------------------------
//`define ATCSPI200_DIRECT_IO_SUPPORT

// ------------------------------------------------------------------------------
// Define register default values for MemRdCmd, CS2CLK, CSHT, and SCLKDIV fields
// ------------------------------------------------------------------------------
//`define ATCSPI200_MEM_RDCMD_DEFAULT	4'd0
//`define ATCSPI200_CS2CLK_DEFAULT	3'h0
//`define ATCSPI200_CSHT_DEFAULT		3'h2
//`define ATCSPI200_SCLKDIV_DEFAULT	8'h1

`endif // ATCSPI200_CONFIG_VH

