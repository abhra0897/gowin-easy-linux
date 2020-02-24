`include "gowin_empu_name.v"
`include "config.v"
module `module_name_empu (

    input  wire          sys_clk,                      // Free running clock
    // --------------------------------------------------------------------
    // I/O Expansion
    // --------------------------------------------------------------------
`ifdef GOWIN_GPIO_SUPPORT
    inout  wire   [15:0] gpio,
`endif
    // --------------------------------------------------------------------
    // UART0,1
    // --------------------------------------------------------------------
`ifdef GOWIN_UART0_SUPPORT
    input  wire          uart0_rxd,               // Microcontroller UART receive data
    output wire          uart0_txd,               // UART receive data (uart0)
`endif
`ifdef GOWIN_UART1_SUPPORT
    input  wire          uart1_rxd,               // Microcontroller UART transmit data
    output wire          uart1_txd,               // UART transmit data (Uart1)
`endif
`ifdef GOWIN_UART_SUPPORT
    output wire        uart_txd,
    input  wire        uart_rxd,
`endif
`ifdef GOWIN_I2C_SUPPORT
    inout wire        scl,
    inout wire        sda,
`endif
`ifdef GOWIN_SPI_SUPPORT
    //spi
    output wire        mosi,   // SPI output
    input  wire        miso,   // SPI input
    output wire        sclk,   // SPI clock
    output wire        nss,
`endif
`ifdef GOWIN_ADC_SUPPORT
    input wire [7:0]   adc_channel,
    input wire         adc_vref,
`endif
        //apb Extension
`ifdef GOWIN_APB2_SUPPORT
    output wire           master_pclk,
    output wire           master_rst,
    output wire           master_penable,
    output wire  [7:0]    master_paddr,
    output wire           master_pwrite,
    output wire  [31:0]   master_pwdata,
    output wire  [3:0]    master_pstrb,
    output wire  [2:0]    master_pprot,
`endif
`ifdef GOWIN_APB2_M1_SUPPORT
    output wire           master_psel1,
    input  wire  [31:0]   master_prdata1,
    input  wire           master_pready1,
    input  wire           master_pslverr1,
`endif
`ifdef GOWIN_APB2_M2_SUPPORT
    output wire           master_psel2,
    input  wire  [31:0]   master_prdata2,
    input  wire           master_pready2,
    input  wire           master_pslverr2,
`endif
`ifdef GOWIN_APB2_M3_SUPPORT
    output wire           master_psel3,
    input  wire  [31:0]   master_prdata3,
    input  wire           master_pready3,
    input  wire           master_pslverr3,
`endif
`ifdef GOWIN_APB2_M4_SUPPORT
    output wire           master_psel4,
    input  wire  [31:0]   master_prdata4,
    input  wire           master_pready4,
    input  wire           master_pslverr4,
`endif
`ifdef GOWIN_APB2_M5_SUPPORT
    output wire           master_psel5,
    input  wire  [31:0]   master_prdata5,
    input  wire           master_pready5,
    input  wire           master_pslverr5,
`endif
`ifdef GOWIN_APB2_M6_SUPPORT
    output wire           master_psel6,
    input  wire  [31:0]   master_prdata6,
    input  wire           master_pready6,
    input  wire           master_pslverr6,
`endif
`ifdef GOWIN_APB2_M7_SUPPORT
    output wire           master_psel7,
    input  wire  [31:0]   master_prdata7,
    input  wire           master_pready7,
    input  wire           master_pslverr7,
`endif
`ifdef GOWIN_APB2_M8_SUPPORT
    output wire           master_psel8,
    input  wire  [31:0]   master_prdata8,
    input  wire           master_pready8,
    input  wire           master_pslverr8,
`endif
`ifdef GOWIN_APB2_M9_SUPPORT
    output wire           master_psel9,
    input  wire  [31:0]   master_prdata9,
    input  wire           master_pready9,
    input  wire           master_pslverr9,
`endif
`ifdef GOWIN_APB2_M10_SUPPORT
    output wire           master_psel10,
    input  wire  [31:0]   master_prdata10,
    input  wire           master_pready10,
    input  wire           master_pslverr10,
`endif
`ifdef GOWIN_APB2_M11_SUPPORT
    output wire           master_psel11,
    input  wire  [31:0]   master_prdata11,
    input  wire           master_pready11,
    input  wire           master_pslverr11,
`endif
`ifdef GOWIN_APB2_M12_SUPPORT
    output wire           master_psel12,
    input  wire  [31:0]   master_prdata12,
    input  wire           master_pready12,
    input  wire           master_pslverr12,
`endif
`ifdef GOWIN_AHB2_M_SUPPORT
    output wire          master_hclk,
    output wire          master_hrst,
    output wire          master_hsel,
    output wire [31:0]   master_haddr,
    output wire [1:0]    master_htrans,
    output wire          master_hwrite,
    output wire [2:0]    master_hsize,
    output wire [2:0]    master_hburst,
    output wire [3:0]    master_hprot,
    output wire [1:0]    master_memattr,
    output wire          master_exreq,
    output wire [3:0]    master_hmaster,
    output wire [31:0]   master_hwdata,
    output wire          master_hmastlock,
    output wire          master_hreadymux,
    output wire          master_hauser,
    output wire [3:0]    master_hwuser,
    input  wire [31:0]   master_hrdata,
    input  wire          master_hreadyout,
    input  wire          master_hresp,
    input  wire          master_exresp,
    input  wire [2:0]    master_hruser,
`endif
`ifdef GOWIN_AHB2_S_SUPPORT
    input wire          slave_hsel,
    input wire [31:0]   slave_haddr,
    input wire [1:0]    slave_htrans,
    input wire          slave_hwrite,
    input wire [2:0]    slave_hsize,
    input wire [2:0]    slave_hburst,
    input wire [3:0]    slave_hprot,
    input wire [1:0]    slave_memattr,
    input wire          slave_exreq,
    input wire [3:0]    slave_hmaster,
    input wire [31:0]   slave_hwdata,
    input wire          slave_hmastlock,
    input wire          slave_hauser,
    input wire [3:0]    slave_hwuser,
    output wire[31:0]   slave_hrdata,
    output wire         slave_hready,
    output wire         slave_hresp,
    output wire         slave_exresp,
    output wire[2:0]    slave_hruser,
`endif
    // ----------------------------------------------------------------------------
    //user Interrupt Extension
    //-----------------------------------------------------------------------------
`ifdef GOWIN_INT0_SUPPORT
    input wire         user_int_0,
`endif
`ifdef GOWIN_INT1_SUPPORT
    input wire         user_int_1,
`endif
    // ----------------------------------------------------------------------------
    // Trace
    // ----------------------------------------------------------------------------
    // Single Wire Viewer
`ifdef GOWIN_TPIU_SUPPORT
    output wire          trace_swo,          // SingleWire Viewer Data

    // TracePort Output
    output wire          trace_clk,          // TracePort clock reference
    output wire    [3:0] trace_data,         // TracePort Data
`endif
    input  wire          reset_n                // Power on reset
    );
    `getname(Gowin_EMPU,`module_name_empu) Gowin_EMPU_inst (
    .sys_clk(sys_clk),  
`ifdef GOWIN_GPIO_SUPPORT 
    .gpio(gpio),   
`endif
`ifdef GOWIN_UART0_SUPPORT
    .uart0_rxd(uart0_rxd), 
    .uart0_txd(uart0_txd), 
`endif
`ifdef GOWIN_UART1_SUPPORT
    .uart1_rxd(uart1_rxd),
    .uart1_txd(uart1_txd),
`endif
`ifdef GOWIN_SPI_SUPPORT
    .mosi(mosi),
    .miso(miso),
    .sclk(sclk),
    .nss(nss),
`endif
`ifdef GOWIN_UART_SUPPORT
    .uart_txd     (uart_txd),
    .uart_rxd     (uart_rxd),
`endif
`ifdef GOWIN_I2C_SUPPORT
    .scl             (scl),
    .sda             (sda),
`endif
`ifdef GOWIN_ADC_SUPPORT
    .adc_channel(adc_channel),
    .adc_vref(adc_vref),
`endif
`ifdef GOWIN_APB2_SUPPORT
    .master_pclk(master_pclk),
    .master_rst(master_rst),
    .master_penable(master_penable),
    .master_paddr(master_paddr),
    .master_pwrite(master_pwrite),
    .master_pwdata(master_pwdata),
    .master_pstrb(master_pstrb),
    .master_pprot(master_pprot),
`endif
`ifdef GOWIN_APB2_M1_SUPPORT
    .master_psel1(master_psel1),
    .master_prdata1(master_prdata1),
    .master_pready1(master_pready1),
    .master_pslverr1(master_pslverr1),
`endif
`ifdef GOWIN_APB2_M2_SUPPORT
    .master_psel2(master_psel2),
    .master_prdata2(master_prdata2),
    .master_pready2(master_pready2),
    .master_pslverr2(master_pslverr2),
`endif
`ifdef GOWIN_APB2_M3_SUPPORT
    .master_psel3(master_psel3),
    .master_prdata3(master_prdata3),
    .master_pready3(master_pready3),
    .master_pslverr3(master_pslverr3),
`endif
`ifdef GOWIN_APB2_M4_SUPPORT
    .master_psel4(master_psel4),
    .master_prdata4(master_prdata4),
    .master_pready4(master_pready4),
    .master_pslverr4(master_pslverr4),
`endif
`ifdef GOWIN_APB2_M5_SUPPORT
    .master_psel5(master_psel5),
    .master_prdata5(master_prdata5),
    .master_pready5(master_pready5),
    .master_pslverr5(master_pslverr5),
`endif
`ifdef GOWIN_APB2_M6_SUPPORT
    .master_psel6(master_psel6),
    .master_prdata6(master_prdata6),
    .master_pready6(master_pready6),
    .master_pslverr6(master_pslverr6),
`endif
`ifdef GOWIN_APB2_M7_SUPPORT
    .master_psel7(master_psel7),
    .master_prdata7(master_prdata7),
    .master_pready7(master_pready7),
    .master_pslverr7(master_pslverr7),
`endif
`ifdef GOWIN_APB2_M8_SUPPORT
    .master_psel8(master_psel8),
    .master_prdata8(master_prdata8),
    .master_pready8(master_pready8),
    .master_pslverr8(master_pslverr8),
`endif
`ifdef GOWIN_APB2_M9_SUPPORT
    .master_psel9(master_psel9),
    .master_prdata9(master_prdata9),
    .master_pready9(master_pready9),
    .master_pslverr9(master_pslverr9),
`endif
`ifdef GOWIN_APB2_M10_SUPPORT
    .master_psel10(master_psel10),
    .master_prdata10(master_prdata10),
    .master_pready10(master_pready10),
    .master_pslverr10(master_pslverr10),
`endif
`ifdef GOWIN_APB2_M11_SUPPORT
    .master_psel11(master_psel11),
    .master_prdata11(master_prdata11),
    .master_pready11(master_pready11),
    .master_pslverr11(master_pslverr11),
`endif
`ifdef GOWIN_APB2_M12_SUPPORT
    .master_psel12(master_psel12),
    .master_prdata12(master_prdata12),
    .master_pready12(master_pready12),
    .master_pslverr12(master_pslverr12),
`endif
`ifdef GOWIN_AHB2_M_SUPPORT
    .master_hclk(master_hclk),
    .master_hrst(master_hrst),
    .master_hsel(master_hsel),
    .master_haddr(master_haddr),
    .master_htrans(master_htrans),
    .master_hwrite(master_hwrite),
    .master_hsize(master_hsize),
    .master_hburst(master_hburst),
    .master_hprot(master_hprot),
    .master_memattr(master_memattr),
    .master_exreq(master_exreq),
    .master_hmaster(master_hmaster),
    .master_hwdata(master_hwdata),
    .master_hmastlock(master_hmastlock),
    .master_hreadymux(master_hreadymux),
    .master_hauser(master_hauser),
    .master_hwuser(master_hwuser),
    .master_hrdata(master_hrdata),
    .master_hreadyout(master_hreadyout),
    .master_hresp(master_hresp),
    .master_exresp(master_exresp),
    .master_hruser(master_hruser),
`endif
`ifdef GOWIN_AHB2_S_SUPPORT
    .slave_hsel(slave_hsel),
    .slave_haddr(slave_haddr),
    .slave_htrans(slave_htrans),
    .slave_hwrite(slave_hwrite),
    .slave_hsize(slave_hsize),
    .slave_hburst(slave_hburst),
    .slave_hprot(slave_hprot),
    .slave_memattr(slave_memattr),
    .slave_exreq(slave_exreq),
    .slave_hmaster(slave_hmaster),
    .slave_hwdata(slave_hwdata),
    .slave_hmastlock(slave_hmastlock),
    .slave_hauser(slave_hauser),
    .slave_hwuser(slave_hwuser),
    .slave_hrdata(slave_hrdata),
    .slave_hready(slave_hready),
    .slave_hresp(slave_hresp),
    .slave_exresp(slave_exresp),
    .slave_hruser(slave_hruser),
`endif
`ifdef GOWIN_INT0_SUPPORT
    .user_int_0(user_int_0),
`endif
`ifdef GOWIN_INT1_SUPPORT
    .user_int_1(user_int_1),
`endif
`ifdef GOWIN_TPIU_SUPPORT
    .trace_swo(trace_swo),
    .trace_clk(trace_clk),
    .trace_data(trace_data),
`endif
    .reset_n(reset_n)
    );
endmodule
 
