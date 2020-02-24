`include "top_define.vh"
`include "static_macro_define.vh"
`include "uart_master_defines.vh"

module `module_name
 (
   I_CLK,
   I_RESETN,
   I_TX_EN,
   I_WADDR,
   I_WDATA,   
   I_RX_EN,  
   I_RADDR,
   O_RDATA,
   SIN, 
   RxRDYn, 
   SOUT, 
   TxRDYn, 
   DDIS, 
   INTR,    
   DCDn,
   CTSn,
   DSRn,
   RIn,
   DTRn,
   RTSn    
 );
 //User SRAM interface
 input                       I_CLK;
 input                       I_RESETN;
 input                       I_TX_EN;
 input  [2:0]                I_WADDR;
 input  [7:0]                I_WDATA;   
 input                       I_RX_EN;  
 input  [2:0]                I_RADDR;
 output [7:0]                O_RDATA; 

 // Processor interface
 output                      DDIS; // Driver disable
 output                      INTR; // Interrupt

 // Receiver interface
 input                       SIN; // Receiver serial input
 output                      RxRDYn; // Receiver ready

 // Transmitter interface
 output                      SOUT; // Transmitter serial output
 output                      TxRDYn; // Transmitter ready

 // Modem interface
 input                       DCDn; // Data Carrier Detect
 input                       CTSn; // Clear To Send
 input                       DSRn; // Data Set Ready
 input                       RIn; // Ring Indicator
 output                      DTRn; // Data Terminal Ready
 output                      RTSn; // Request To Send/

 `getname(uart_master,`module_name)
 (
  .I_CLK(I_CLK),
  .I_RESETN(I_RESETN),
  .I_TX_EN(I_TX_EN),
  .I_WADDR(I_WADDR),
  .I_WDATA(I_WDATA),   
  .I_RX_EN(I_RX_EN),  
  .I_RADDR(I_RADDR),
  .O_RDATA(O_RDATA),

   // Processor interface
  .DDIS(DDIS),     // Driver disable
  .INTR(INTR),     // Interrupt

   // Receiver interface
  .SIN(SIN),       // Receiver serial input
  .RxRDYn(RxRDYn), // Receiver ready

   // Transmitter interface
  .SOUT(SOUT),     // Transmitter serial output
  .TxRDYn(TxRDYn), // Transmitter ready

   // Modem interface
  .DCDn(DCDn),     // Data Carrier Detect
  .CTSn(CTSn),     // Clear To Send
  .DSRn(DSRn),     // Data Set Ready
  .RIn(RIn),       // Ring Indicator
  .DTRn(DTRn),     // Data Terminal Ready
  .RTSn(RTSn)      // Request To Send
 );

endmodule
