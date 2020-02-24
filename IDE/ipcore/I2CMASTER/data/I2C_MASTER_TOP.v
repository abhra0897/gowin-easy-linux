`include "top_define.vh"
`include "static_macro_define.vh"

module `module_name (
   I_CLK,
   I_RESETN,
   I_TX_EN,
   I_WADDR,
   I_WDATA,   
   I_RX_EN,  
   I_RADDR,
   O_RDATA,   
   O_IIC_INT,
   SCL, 
   SDA  
);
  //Controller Interface 
  input              I_CLK;
  input              I_RESETN;
  input              I_TX_EN;
  input  [2:0]       I_WADDR;
  input  [7:0]       I_WDATA;   
  input              I_RX_EN;  
  input  [2:0]       I_RADDR;
  output [7:0]       O_RDATA; 
  output             O_IIC_INT;
  //i2c interface  
  inout              SDA;
  inout              SCL;
  
`getname(i2c_master,`module_name)  u_i2c_master ( 
  .I_CLK(I_CLK),
  .I_RESETN(I_RESETN),
  .I_TX_EN(I_TX_EN),
  .I_WADDR(I_WADDR),
  .I_WDATA(I_WDATA),   
  .I_RX_EN(I_RX_EN),  
  .I_RADDR(I_RADDR),
  .O_RDATA(O_RDATA),   
  .O_IIC_INT(O_IIC_INT),
  .SCL(SCL), 
  .SDA(SDA) 
);

endmodule

