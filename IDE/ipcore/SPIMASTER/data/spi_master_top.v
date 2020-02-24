`include "top_define.vh"
`include "static_macro_define.vh"
`include "spi_master_defines.vh"

module `module_name (
  I_CLK,
  I_RESETN,
  I_TX_EN,
  I_WADDR,
  I_WDATA,  
  I_RX_EN,  
  I_RADDR,
  O_RDATA,  
  O_SPI_INT,
  MISO_MASTER,
  MOSI_MASTER,
  SS_N_MASTER,
  SCLK_MASTER,
  MISO_SLAVE,
  MOSI_SLAVE,
  SS_N_SLAVE,
  SCLK_SLAVE
);
 //User SRAM interface
  input                       I_CLK;
  input                       I_RESETN;
  input                       I_TX_EN;
  input  [2:0]                I_WADDR;
  input  [`DATA_LENGTH-1:0]   I_WDATA; 
  input                       I_RX_EN;  
  input  [2:0]                I_RADDR;
  output [`DATA_LENGTH-1:0]   O_RDATA;  
  output                      O_SPI_INT;
   
 //spi interface
  //spi master
  input                       MISO_MASTER;
  output                      MOSI_MASTER;
  output [`SLAVE_NUMBER-1:0]  SS_N_MASTER;
  output                      SCLK_MASTER;
  //spi slave
  output                      MISO_SLAVE;
  input                       MOSI_SLAVE;
  input                       SS_N_SLAVE;
  input                       SCLK_SLAVE;
  
`getname(spi_master,`module_name) u_spi_master (
  .I_CLK(I_CLK),
  .I_RESETN(I_RESETN),
  .I_TX_EN(I_TX_EN),
  .I_WADDR(I_WADDR),
  .I_WDATA(I_WDATA),
  .I_RX_EN(I_RX_EN),
  .I_RADDR(I_RADDR),
  .O_RDATA(O_RDATA),
  .O_SPI_INT(O_SPI_INT),
  .MISO_MASTER(MISO_MASTER),
  .MOSI_MASTER(MOSI_MASTER),
  .SS_N_MASTER(SS_N_MASTER),  
  .SCLK_MASTER(SCLK_MASTER),
  .MISO_SLAVE(MISO_SLAVE),
  .MOSI_SLAVE(MOSI_SLAVE),
  .SS_N_SLAVE(SS_N_SLAVE),
  .SCLK_SLAVE(SCLK_SLAVE)   
);

endmodule
