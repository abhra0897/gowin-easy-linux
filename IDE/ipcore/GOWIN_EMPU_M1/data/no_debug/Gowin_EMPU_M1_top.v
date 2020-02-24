`resetall
`include "ahb_option_defs.v"

module Gowin_EMPU_M1_Top (
  LOCKUP,
  //GPIO
`ifdef GOWIN_GPIO_SUPPORT
  GPIO,
`endif
  //UART0
`ifdef GOWIN_UART0_SUPPORT
  UART0RXD,
  UART0TXD,
`endif
  //UART1
`ifdef GOWIN_UART1_SUPPORT
  UART1RXD,
  UART1TXD,
`endif
  //Timer0
`ifdef GOWIN_TIMER0_SUPPORT
  TIMER0EXTIN,
`endif
  //Timer1
`ifdef GOWIN_TIMER1_SUPPORT
  TIMER1EXTIN,
`endif
  //APB2 Extension
`ifdef GOWIN_APB2_SUPPORT
  APB2PADDR,     // APB Address
  APB2PENABLE,   // APB Enable
  APB2PWRITE,    // APB Write
  APB2PSTRB,     // APB Byte Strobe
  APB2PPROT,     // APB Prot
  APB2PWDATA,    // APB write data
  APB2PSEL,      // APB Select
  APB2PRDATA,    // Read data for each APB slave
  APB2PREADY,    // Ready for each APB slave
  APB2PSLVERR,   // Error state for each APB slave
  APB2PCLK,      // APB Clock
  APB2PRESET,    // APB Reset
`endif
  //AHB2 Extension
`ifdef GOWIN_AHB2_SUPPORT
  AHB2HRDATA,      // Data from slave to master
  AHB2HREADYOUT,   // Slave ready signal
  AHB2HRESP,       // Slave response signal  
  AHB2HTRANS,      // Transfer type
  AHB2HBURST,      // Burst type
  AHB2HPROT,       // Transfer protection bits
  AHB2HSIZE,       // Transfer size
  AHB2HWRITE,      // Transfer direction
  AHB2HMASTLOCK,   // Transfer is a locked transfer
  AHB2HREADYMUX,
  AHB2HMASTER,     // Transfer is a locked transfer
  AHB2HADDR,       // Transfer address
  AHB2HWDATA,      // Data from master to slave
  AHB2HSEL,        // AHB Select
  AHB2HCLK,        // AHB Clock
  AHB2HRESET,      // AHB Reset
`endif
  //RTC
`ifdef GOWIN_RTC_SUPPORT
  RTCSRCCLK, 
`endif
  //I2C
`ifdef GOWIN_I2C_SUPPORT
  SCL,
  SDA,
`endif
  //SPI
`ifdef GOWIN_SPI_SUPPORT
  MOSI,   // SPI output
  MISO,   // SPI input
  SCLK,   // SPI clock
  NSS,    // SPI Select
`endif
  //SD-Card
`ifdef GOWIN_SD_SUPPORT
  SD_SPICLK,
  SD_CLK,				
  SD_CS,
  SD_DATAIN,
  SD_DATAOUT,
  SD_CARD_INIT, //0:ok
  SD_CHECKIN,
  SD_CHECKOUT,
`endif
  //CAN
`ifdef GOWIN_CAN_SUPPORT
  CAN_RX,
  CAN_TX,
`endif
  //Ethernet
`ifdef GOWIN_INTERNET_SUPPORT
  //RGMII
  `ifdef RGMII_IF
    RGMII_TXC,
    RGMII_TX_CTL,
    RGMII_TXD,
    RGMII_RXC,  
    RGMII_RX_CTL,    
    RGMII_RXD,
    GTX_CLK,
  `endif
  //GMII
  `ifdef GMII_IF
    GMII_RX_CLK,
    GMII_RX_DV,
    GMII_RXD,
    GMII_RX_ER,
    GTX_CLK,
    GMII_GTX_CLK,         
    GMII_TXD,        
    GMII_TX_EN,          
    GMII_TX_ER,          
  `endif
  //MII
  `ifdef MII_IF
    MII_RX_CLK,       
    MII_RXD,      
    MII_RX_DV,        
    MII_RX_ER,        
    MII_TX_CLK,       
    MII_TXD,     
    MII_TX_EN,       
    MII_TX_ER,       
    MII_COL,
    MII_CRS,
  `endif
  MDC,
  MDIO,
`endif
  //SPI-Flash
`ifdef GOWIN_SPI_FLASH_SUPPORT
  FLASH_SPI_HOLDN,
  FLASH_SPI_CSN,
  FLASH_SPI_MISO,
  FLASH_SPI_MOSI,
  FLASH_SPI_WPN,
  FLASH_SPI_CLK,
`endif
  //DDR3 Memory
`ifdef GOWIN_DDR3_SUPPORT
  DDR_CLK_I,
  DDR_INIT_COMPLETE_O,
  DDR_ADDR_O,
  DDR_BA_O,
  DDR_CS_N_O,
  DDR_RAS_N_O,
  DDR_CAS_N_O,
  DDR_WE_N_O,
  DDR_CLK_O,
  DDR_CLK_N_O,
  DDR_CKE_O,
  DDR_ODT_O,
  DDR_RESET_N_O,
  DDR_DQM_O,
  DDR_DQ_IO,
  DDR_DQS_IO,
  DDR_DQS_N_IO,
`endif
  //PSRAM
`ifdef GOWIN_PSRAM_SUPPORT
  O_psram_ck,             //CS_WIDTH=2
  O_psram_ck_n,           //CS_WIDTH=2
  IO_psram_rwds,          //CS_WIDTH=2
  IO_psram_dq,            //DQ_WIDTH=16
  O_psram_reset_n,        //CS_WIDTH=2
  O_psram_cs_n,           //CS_WIDTH=2
  init_calib,             //Initialization done flag
  psram_ref_clk,          //Reference input clock, osc clock from board
  psram_memory_clk,       //Working clock of user input grain
`endif
  HCLK,			//System Clock
  hwRstn		//System Reset
); 

//------------------------------------------------------------------------------
// Port declaration
//------------------------------------------------------------------------------

  // Clocks and Reset
  input                 HCLK;       // System clock
  input                 hwRstn;     // System reset
  //RTC
`ifdef GOWIN_RTC_SUPPORT
  input                 RTCSRCCLK;
`endif
  // GPIO 
`ifdef GOWIN_GPIO_SUPPORT
  inout [15:0]          GPIO;
`endif
  // Misc status signals
  output                LOCKUP;        // Core is in lockup state
  //UART0
`ifdef GOWIN_UART0_SUPPORT
  input                 UART0RXD;
  output                UART0TXD;
`endif
  //UART1
`ifdef GOWIN_UART1_SUPPORT
  input                 UART1RXD;
  output                UART1TXD;
`endif
  //Timer0
`ifdef GOWIN_TIMER0_SUPPORT
  input                 TIMER0EXTIN;
`endif
  //Timer1
`ifdef GOWIN_TIMER1_SUPPORT
  input                 TIMER1EXTIN;        // Core is in Halt debug state
`endif
  //I2C
`ifdef GOWIN_I2C_SUPPORT
  inout wire SCL;
  inout wire SDA;
`endif
  //SPI
`ifdef GOWIN_SPI_SUPPORT
  output  wire        MOSI;   // SPI output
  input   wire        MISO;   // SPI input
  output  wire        SCLK;   // SPI clock
  output  wire        NSS;
`endif
  //SD-Card
`ifdef GOWIN_SD_SUPPORT
  input   SD_SPICLK;
  output  SD_CLK;				
  output  SD_CS;
  output  SD_DATAOUT;
  input   SD_DATAIN;
  output  SD_CARD_INIT; //0:ok
  input   SD_CHECKIN;
  output  SD_CHECKOUT;
`endif
  //CAN
`ifdef GOWIN_CAN_SUPPORT
  output wire CAN_TX;
  input  wire CAN_RX;
`endif
  //Ethernet
`ifdef GOWIN_INTERNET_SUPPORT
  //RGMII
  `ifdef RGMII_IF
    output       wire         RGMII_TXC;
    output       wire         RGMII_TX_CTL;
    output  wire [3:0]        RGMII_TXD;
    input        wire         RGMII_RXC;  
    input        wire         RGMII_RX_CTL;    
    input   wire [3:0]        RGMII_RXD;
    input        wire         GTX_CLK;
  `endif
  //GMII
  `ifdef GMII_IF
    input        wire         GMII_RX_CLK;
    input        wire         GMII_RX_DV;
    input        wire         [7:0] GMII_RXD;
    input        wire         GMII_RX_ER;
    input        wire         GTX_CLK;
    output       wire         GMII_GTX_CLK;         
    output       wire         [7:0] GMII_TXD;        
    output       wire         GMII_TX_EN;          
    output       wire         GMII_TX_ER;          
  `endif
  //MII
  `ifdef MII_IF
    input        wire         MII_RX_CLK;       
    input        wire         [3:0] MII_RXD;      
    input        wire         MII_RX_DV;        
    input        wire         MII_RX_ER;        
    input        wire         MII_TX_CLK;       
    output       wire         [3:0] MII_TXD;     
    output       wire         MII_TX_EN;       
    output       wire         MII_TX_ER;       
    input        wire         MII_COL;
    input        wire         MII_CRS;
  `endif
  output       wire         MDC;
  inout        wire         MDIO;
`endif
  //SPI-Flash
`ifdef GOWIN_SPI_FLASH_SUPPORT
  inout   wire FLASH_SPI_HOLDN;
  inout   wire  FLASH_SPI_CSN;
  inout   wire  FLASH_SPI_MISO;
  inout   wire  FLASH_SPI_MOSI;
  inout   wire  FLASH_SPI_WPN;
  inout   wire  FLASH_SPI_CLK;
`endif
  //DDR3
`ifdef GOWIN_DDR3_SUPPORT
  input  wire        DDR_CLK_I;
  output wire        DDR_INIT_COMPLETE_O;
  output wire [15:0] DDR_ADDR_O;
  output wire [2:0]  DDR_BA_O;
  output wire        DDR_CS_N_O;
  output wire        DDR_RAS_N_O;
  output wire        DDR_CAS_N_O;
  output wire        DDR_WE_N_O;
  output wire        DDR_CLK_O;
  output wire        DDR_CLK_N_O;
  output wire        DDR_CKE_O;
  output wire        DDR_ODT_O;
  output wire        DDR_RESET_N_O;
  output wire [1:0]  DDR_DQM_O;
  inout  wire [15:0] DDR_DQ_IO;
  inout  wire [1:0]  DDR_DQS_IO;
  inout  wire [1:0]  DDR_DQS_N_IO;
`endif
  //APB2 Extension
`ifdef GOWIN_APB2_SUPPORT
  output  [31:0]   APB2PADDR;     // APB Address
  output           APB2PENABLE;   // APB Enable
  output           APB2PWRITE;    // APB Write
  output  [3:0]    APB2PSTRB;     // APB Byte Strobe
  output  [2:0]    APB2PPROT;     // APB Prot
  output  [31:0]   APB2PWDATA;    // APB write data
  output           APB2PSEL;      // APB Select
  input   [31:0]   APB2PRDATA;    // Read data for each APB slave
  input            APB2PREADY;    // Ready for each APB slave
  input            APB2PSLVERR;   // Error state for each APB slave
  output           APB2PCLK;      // Clock
  output           APB2PRESET;    // Reset
`endif
  //AHB2 Extension
`ifdef GOWIN_AHB2_SUPPORT
  input  [31:0]        AHB2HRDATA;      // Data from slave to master
  input                AHB2HREADYOUT;   // Slave ready signal
  input  [1:0]         AHB2HRESP;       // Slave response signal  
  output [1:0]         AHB2HTRANS;      // Transfer type
  output [2:0]         AHB2HBURST;      // Burst type
  output [3:0]         AHB2HPROT;       // Transfer protection bits
  output [2:0]         AHB2HSIZE;       // Transfer size
  output               AHB2HWRITE;      // Transfer direction
  output               AHB2HMASTLOCK;   // Transfer is a locked transfer
  output               AHB2HREADYMUX;
  output [3:0]         AHB2HMASTER;     // Transfer is a locked transfer
  output [31:0]        AHB2HADDR;       // Transfer address
  output [31:0]        AHB2HWDATA;      // Data from master to slave
  output               AHB2HSEL;
  output               AHB2HCLK;
  output               AHB2HRESET;
`endif
  //PSRAM
`ifdef GOWIN_PSRAM_SUPPORT
  output  wire [2-1:0]   O_psram_ck;          //CS_WIDTH=2
  output  wire [2-1:0]   O_psram_ck_n;        //CS_WIDTH=2
  inout   wire [2-1:0]   IO_psram_rwds;       //CS_WIDTH=2
  inout   wire [16-1:0]  IO_psram_dq;         //DQ_WIDTH=16
  output  wire [2-1:0]   O_psram_reset_n;     //CS_WIDTH=2
  output  wire [2-1:0]   O_psram_cs_n;        //CS_WIDTH=2
  output  wire           init_calib;          //Initialization done flag
  input   wire           psram_ref_clk;       //Reference input clock, osc clock from board
  input   wire           psram_memory_clk;    //Working clock of user input grain
`endif

//------------------------------------------------------------------------------
// Wire declaration
//-------------------------------------------------------------------------
wire [1:0] HTRANS;
wire [2:0] HBURST;
wire [3:0] HPROT;
wire [2:0] HSIZE;
wire HWRITE;
wire HMASTLOCK;
wire [31:0] HADDR;
wire [31:0] HWDATA;
wire HRESP;
wire [31:0] HRDATA;
wire HREADY;
wire [31:0] IRQ;
wire NMI;
wire SYSRESETREQ;
wire wdog_reset_req;

wire PORESETn = hwRstn;

reg  [3:0] sysRstGen = 4'b0;
wire SYSRESETn  =   sysRstGen[3];

// SYSRESETn for CPU #0 - This is released after sys_reset_n is deasserted.
// You can also add addition reset control here.
always@(posedge HCLK)begin
    if(!hwRstn | SYSRESETREQ |wdog_reset_req)
        sysRstGen <= 4'b0;
    else
        sysRstGen <= {sysRstGen[2:0],1'b1};
end

//Instance Cortex-M1
CortexM1IntegrationWrapper M1_inst(   
    .LOCKUP(LOCKUP), 
    .SYSRESETREQ(SYSRESETREQ),
    .HTRANS(HTRANS), 
    .HBURST(HBURST), 
    .HPROT(HPROT), 
    .HSIZE(HSIZE), 
    .HWRITE(HWRITE), 
    .HMASTLOCK(HMASTLOCK), 
    .HADDR(HADDR), 
    .HWDATA(HWDATA), 
    .HCLK(HCLK), 
    .SYSRESETn(SYSRESETn), 
    .IRQ(IRQ), 
    .NMI(NMI),
    .HREADY(HREADY), 
    .HRESP(HRESP), 
    .HRDATA(HRDATA)
);

//Instance AHB-Lite
GowinCM1AhbExtWrapper u_GowinCM1AhbExtWrapper(
    .IRQ(IRQ),         // External interrupts
    .NMI(NMI),         // Non-maskable interrupt
`ifdef GOWIN_RTC_SUPPORT
    .RTCSRCCLK(RTCSRCCLK),
`endif
    .HCLK(HCLK),
    .HTRANS(HTRANS),
    .HBURST(HBURST),
    .HPROT(HPROT),
    .HSIZE(HSIZE),
    .HWRITE(HWRITE),
    .HMASTLOCK(HMASTLOCK),
    .HADDR(HADDR),
    .HWDATA(HWDATA),
    .HRESP(HRESP),
    .HRDATA(HRDATA),
    .HREADY(HREADY),
`ifdef GOWIN_AHB2_SUPPORT
    .AHB2HRDATA(AHB2HRDATA),      		// Data from slave to master
    .AHB2HREADYOUT(AHB2HREADYOUT),      // Slave ready signal
    .AHB2HRESP(AHB2HRESP),       		// Slave response signal  
    .AHB2HTRANS(AHB2HTRANS),      		// Transfer type
    .AHB2HBURST(AHB2HBURST),      		// Burst type
    .AHB2HPROT(AHB2HPROT),       		// Transfer protection bits
    .AHB2HSIZE(AHB2HSIZE),       		// Transfer size
    .AHB2HWRITE(AHB2HWRITE),      		// Transfer direction
    .AHB2HMASTLOCK(AHB2HMASTLOCK),   	// Transfer is a locked transfer
    .AH2BHMASTER(AHB2HMASTER),
    .AHB2HREADYMUX(AHB2HREADYMUX),
    .AHB2HADDR(AHB2HADDR),       		// Transfer address
    .AHB2HWDATA(AHB2HWDATA),      		// Data from master to slave
    .AHB2HSEL(AHB2HSEL),
`endif
`ifdef GOWIN_APB2_SUPPORT
    .APB2PADDR(      APB2PADDR     ),
    .APB2PENABLE(    APB2PENABLE   ),
    .APB2PWRITE(     APB2PWRITE    ),
    .APB2PSTRB(      APB2PSTRB     ),
    .APB2PPROT(      APB2PPROT     ),
    .APB2PWDATA(     APB2PWDATA    ),
    .APB2PSEL(       APB2PSEL      ),
    .APB2PRDATA(     APB2PRDATA    ),
    .APB2PREADY(     APB2PREADY    ),
    .APB2PSLVERR(    APB2PSLVERR   ),
`endif
`ifdef GOWIN_TIMER0_SUPPORT
    .TIMER0EXTIN          (TIMER0EXTIN),
`endif
`ifdef GOWIN_TIMER1_SUPPORT
    .TIMER1EXTIN          (TIMER1EXTIN),
`endif
`ifdef GOWIN_UART0_SUPPORT
    .UART0RXD             (UART0RXD),
    .UART0TXD             (UART0TXD),
`endif
`ifdef GOWIN_UART1_SUPPORT
    .UART1RXD             (UART1RXD),
    .UART1TXD             (UART1TXD),
`endif
`ifdef GOWIN_WDOG_SUPPORT
    .WDOGRESREQ           (wdog_reset_req),
`endif
`ifdef GOWIN_GPIO_SUPPORT
    .GPIO(GPIO),
`endif
`ifdef GOWIN_SD_SUPPORT
     .SD_spiclk(SD_SPICLK),
     .SD_clk(SD_CLK),				
     .SD_cs(SD_CS),
     .SD_datain(SD_DATAIN),
     .SD_dataout(SD_DATAOUT),
     .SD_card_init_led(SD_CARD_INIT), //0:ok
`endif
`ifdef GOWIN_I2C_SUPPORT
     .SCL(SCL),
     .SDA(SDA),
`endif
`ifdef GOWIN_SPI_SUPPORT
     .MOSI(MOSI),   // SPI output
     .MISO(MISO),   // SPI input
     .SCLK(SCLK),   // SPI clock
     .NSS(NSS),
`endif
`ifdef GOWIN_CAN_SUPPORT
     .CAN_RX(CAN_RX),
     .CAN_TX(CAN_TX),
`endif
`ifdef GOWIN_INTERNET_SUPPORT
  `ifdef RGMII_IF
     .RGMII_TXC(RGMII_TXC),
     .RGMII_TX_CTL(RGMII_TX_CTL),
     .RGMII_TXD(RGMII_TXD),
     .RGMII_RXC(RGMII_RXC),  
     .RGMII_RX_CTL(RGMII_RX_CTL),    
     .RGMII_RXD(RGMII_RXD),
	 .GTX_CLK(GTX_CLK),
  `endif
  `ifdef GMII_IF
     .GMII_RX_CLK(GMII_RX_CLK),
     .GMII_RX_DV(GMII_RX_DV),
     .GMII_RXD(GMII_RXD),
     .GMII_RX_ER(GMII_RX_ER),
     .GTX_CLK(GTX_CLK),
     .GMII_GTX_CLK(GMII_GTX_CLK),         
     .GMII_TXD(GMII_TXD),        
     .GMII_TX_EN(GMII_TX_EN),          
     .GMII_TX_ER(GMII_TX_ER),          
  `endif
  `ifdef MII_IF
     .MII_RX_CLK(MII_RX_CLK),       
     .MII_RXD(MII_RXD),      
     .MII_RX_DV(MII_RX_DV),        
     .MII_RX_ER(MII_RX_ER),        
     .MII_TX_CLK(MII_TX_CLK),       
     .MII_TXD(MII_TXD),     
     .MII_TX_EN(MII_TX_EN),       
     .MII_TX_ER(MII_TX_ER),       
     .MII_COL(MII_COL),
     .MII_CRS(MII_CRS),
  `endif
  .MDC(MDC),
  .MDIO(MDIO),
`endif
`ifdef GOWIN_SPI_FLASH_SUPPORT
     .FLASH_SPI_HOLDN(FLASH_SPI_HOLDN),
     .FLASH_SPI_CSN(FLASH_SPI_CSN),
     .FLASH_SPI_MISO(FLASH_SPI_MISO),
     .FLASH_SPI_MOSI(FLASH_SPI_MOSI),
     .FLASH_SPI_WPN(FLASH_SPI_WPN),
     .FLASH_SPI_CLK(FLASH_SPI_CLK),
`endif
`ifdef GOWIN_DDR3_SUPPORT
     .DDR_CLK(DDR_CLK_I)    ,
     .DDR_ADDR_O(DDR_ADDR_O),
     .DDR_BA_O(DDR_BA_O)  ,
     .DDR_CS_N_O(DDR_CS_N_O),
     .DDR_RAS_N_O(DDR_RAS_N_O),
     .DDR_CAS_N_O(DDR_CAS_N_O),
     .DDR_WE_N_O(DDR_WE_N_O),
     .DDR_CLK_O(DDR_CLK_O),
     .DDR_CLK_N_O(DDR_CLK_N_O),
     .DDR_CKE_O(DDR_CKE_O),
     .DDR_ODT_O(DDR_ODT_O),
     .DDR_RESET_N_O(DDR_RESET_N_O),
     .DDR_DQM_O(DDR_DQM_O),
     .DDR_DQ_IO(DDR_DQ_IO),
     .DDR_DQS_IO(DDR_DQS_IO),
     .DDR_DQS_N_IO(DDR_DQS_N_IO),
     .DDR_INIT_COMPLETE_O(DDR_INIT_COMPLETE_O),
`endif
`ifdef GOWIN_PSRAM_SUPPORT
    .led_init           (init_calib),
	.O_psram_ck         (O_psram_ck),
	.O_psram_ck_n       (O_psram_ck_n),
	.O_psram_cs_n       (O_psram_cs_n),
	.O_psram_reset_n    (O_psram_reset_n),    
	.IO_psram_dq        (IO_psram_dq),
	.IO_psram_rwds      (IO_psram_rwds),
    .psram_base_clk     (psram_ref_clk),
    .psram_memory_clk   (psram_memory_clk), 
`endif
     .SYSRESETn(SYSRESETn),
     .PORESETn(PORESETn)
);
`ifdef GOWIN_APB2_SUPPORT
  assign APB2PCLK = HCLK;
  assign APB2PRESET = SYSRESETn;
`endif
`ifdef GOWIN_AHB2_SUPPORT
  assign AHB2HCLK = HCLK;
  assign AHB2HRESET = SYSRESETn;
`endif
`ifdef GOWIN_SD_SUPPORT
  assign SD_CHECKOUT = SD_CHECKIN;
`endif

endmodule
