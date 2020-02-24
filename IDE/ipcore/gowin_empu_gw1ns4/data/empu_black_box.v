//EMCU,Enhanced MCU,used for 1ns-4
module EMCU (

  input            FCLK,                      // Free running clock
  input            PORESETN,                  // Power on reset
  input            SYSRESETN,                 // System reset
  input            RTCSRCCLK,                 // Used to generate RTC clock
  output  [15:0]   IOEXPOUTPUTO,              // 
  output  [15:0]   IOEXPOUTPUTENO,            // 
  input   [15:0]   IOEXPINPUTI,               // 
  output           UART0TXDO,                 // 
  output           UART1TXDO,                 // 
  output           UART0BAUDTICK,             //
  output           UART1BAUDTICK,             //
  input            UART0RXDI,                 // 
  input            UART1RXDI,                 //
  output           INTMONITOR,                //
  // ----------------------------------------------------------------------------
  // AHB2SRAM<0..3> Interfaces
  // ----------------------------------------------------------------------------
  output             MTXHRESETN,            // SRAM/Flash Chip reset
  output  [12:0]     SRAM0ADDR,             // SRAM address
  output  [3:0]      SRAM0WREN,             // SRAM Byte write enable
  output  [31:0]     SRAM0WDATA,            // SRAM Write data
  output             SRAM0CS,               // SRAM Chip select
  input   [31:0]     SRAM0RDATA,            // SRAM Read data bus
  // ----------------------------------------------------------------------------
  // AHB Target Expansion ports
  // ----------------------------------------------------------------------------
  //  amba.com/AMBA3/AHBLite/r2p0_0, TARGFLASH0, master
  output              TARGFLASH0HSEL,         // TARGFLASH0, HSELx,
  output  [28:0]      TARGFLASH0HADDR,        // TARGFLASH0, HADDR,
  output   [1:0]      TARGFLASH0HTRANS,       // TARGFLASH0, HTRANS,
  output   [2:0]      TARGFLASH0HSIZE,        // TARGFLASH0, HSIZE,
  output   [2:0]      TARGFLASH0HBURST,       // TARGFLASH0, HBURST,
  output              TARGFLASH0HREADYMUX,    // TARGFLASH0, HREADYOUT,
  input   [31:0]      TARGFLASH0HRDATA,       // TARGFLASH0, HRDATA,
  input    [2:0]      TARGFLASH0HRUSER,       // TARGFLASH0, HRUSER, Tie to 3'b0
  input               TARGFLASH0HRESP,        // TARGFLASH0, HRESP
  input               TARGFLASH0EXRESP,       // TARGFLASH0, EXRESP;  Tie to 1'b0
  input               TARGFLASH0HREADYOUT,    // TARGFLASH0, EXRESP
  //  amba.com/AMBA3/AHBLite/r2p0_0, TARGEXP0, master
  output              TARGEXP0HSEL,           // TARGEXP0, HSELx,
  output  [31:0]      TARGEXP0HADDR,          // TARGEXP0, HADDR,
  output   [1:0]      TARGEXP0HTRANS,         // TARGEXP0, HTRANS,
  output              TARGEXP0HWRITE,         // TARGEXP0, HWRITE,
  output   [2:0]      TARGEXP0HSIZE,          // TARGEXP0, HSIZE,
  output   [2:0]      TARGEXP0HBURST,         // TARGEXP0, HBURST,
  output   [3:0]      TARGEXP0HPROT,          // TARGEXP0, HPROT,
  output   [1:0]      TARGEXP0MEMATTR,
  output              TARGEXP0EXREQ,
  output   [3:0]      TARGEXP0HMASTER,
  output  [31:0]      TARGEXP0HWDATA,         // TARGEXP0, HWDATA,
  output              TARGEXP0HMASTLOCK,      // TARGEXP0, HMASTLOCK,
  output              TARGEXP0HREADYMUX,      // TARGEXP0, HREADYOUT,
  output              TARGEXP0HAUSER,         // TARGEXP0, HAUSER,
  output   [3:0]      TARGEXP0HWUSER,         // TARGEXP0, HWUSER,
  input   [31:0]      TARGEXP0HRDATA,         // TARGEXP0, HRDATA,
  input               TARGEXP0HREADYOUT,      // TARGEXP0, HREADY,
  input               TARGEXP0HRESP,          // TARGEXP0, HRESP,
  input               TARGEXP0EXRESP,
  input    [2:0]      TARGEXP0HRUSER,         // TARGEXP0, HRUSER,
  // ----------------------------------------------------------------------------
  // AHB Initiator Expansion ports
  // ----------------------------------------------------------------------------
  output  [31:0]      INITEXP0HRDATA,         // INITEXP0, HRDATA,
  output              INITEXP0HREADY,         // INITEXP0, HREADY,
  output              INITEXP0HRESP,          // INITEXP0, HRESP,
  output              INITEXP0EXRESP,
  output  [2:0]       INITEXP0HRUSER,         // INITEXP0, HRUSER,
  input               INITEXP0HSEL,           // INITEXP0, HSELx,
  input   [31:0]      INITEXP0HADDR,          // INITEXP0, HADDR,
  input    [1:0]      INITEXP0HTRANS,         // INITEXP0, HTRANS,
  input               INITEXP0HWRITE,         // INITEXP0, HWRITE,
  input    [2:0]      INITEXP0HSIZE,          // INITEXP0, HSIZE,
  input    [2:0]      INITEXP0HBURST,         // INITEXP0, HBURST,
  input    [3:0]      INITEXP0HPROT,          // INITEXP0, HPROT,
  input    [1:0]      INITEXP0MEMATTR,
  input               INITEXP0EXREQ,
  input    [3:0]      INITEXP0HMASTER,
  input   [31:0]      INITEXP0HWDATA,         // INITEXP0, HWDATA,
  input               INITEXP0HMASTLOCK,      // INITEXP0, HMASTLOCK,
  input               INITEXP0HAUSER,         // INITEXP0, HAUSER,
  input    [3:0]      INITEXP0HWUSER,         // INITEXP0, HWUSER,
  //  amba.com/AMBA4/APB4/r0p0_0, APBTARGEXP2, master
  output  [3:0]       APBTARGEXP2PSTRB,       // APBTARGEXP2, PSTRB,
  output  [2:0]       APBTARGEXP2PPROT,       // APBTARGEXP2, PPROT,
  output              APBTARGEXP2PSEL,        // APBTARGEXP2, PSELx,
  output              APBTARGEXP2PENABLE,     // APBTARGEXP2, PENABLE,
  output  [11:0]      APBTARGEXP2PADDR,       // APBTARGEXP2, PADDR,
  output              APBTARGEXP2PWRITE,      // APBTARGEXP2, PWRITE,
  output  [31:0]      APBTARGEXP2PWDATA,      // APBTARGEXP2, PWDATA,
  input    [31:0]     APBTARGEXP2PRDATA,      // APBTARGEXP2, PRDATA,
  input               APBTARGEXP2PREADY,      // APBTARGEXP2, PREADY,
  input               APBTARGEXP2PSLVERR,     // APBTARGEXP2, PSLVERR,
  // CPU Control, Status and Configuration
  // ----------------------------------------------------------------------------
  // CSS configuration inputs
  // ----------------------------------------------------------------------------
  input   [3:0]       MTXREMAP,               // Configration bits. MTXREMAP = 4'b1111
  // ----------------------------------------------------------------------------
  // Interrupts
  // ----------------------------------------------------------------------------
  //JTAG + SW Debug access clock reset
  // JTAG + SW Debug access functional signals
  output               DAPTDO,                // Debug TDO
  output               DAPJTAGNSW,            // JTAG or Serial-Wire selection JTAG mode(1) or SW mode(0)
  output               DAPNTDOEN,             // TDO output pad control signal
  input                DAPSWDITMS,            // Debug TMS
  input                DAPTDI,                // Debug TDI
  input                DAPNTRST,              // Test reset
  input                DAPSWCLKTCK,           // Test clock / SWCLK
  //TRACE Interface functional signals
  output  [3:0]        TPIUTRACEDATA,         // Output data. A system might not connect all the bits of
  output               TPIUTRACECLK,          // Output clock, used by the TPA to sample the other pins
  input   [4:0]        GPINT,                 // 5 more interrupts input 
  input                FLASHERR,              // Output clock, used by the TPA to sample the other pins
  input                FLASHINT               // Output clock, used by the TPA to sample the other pins

 );

endmodule

