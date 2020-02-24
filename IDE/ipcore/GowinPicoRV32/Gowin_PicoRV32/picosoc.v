
`timescale 1 ns / 1 ns

`include "pico_define.vh"

module Gowin_PicoRV32_Top  #(
   parameter  WBSPI_SLAVE_NUM  = 1		//  maximum value = 8 for current design
)(
`ifdef BOOT_FROM_FLASH
    output spimem_csb,
	output spimem_clk,
    inout  spimem_io0,  //MOSI
    inout  spimem_io1,  //MISO
    inout  spimem_io2,  //WPN
    inout  spimem_io3,  //HOLDN
`endif
	
`ifdef ENABLE_SIMPLE_UART
	output ser_tx,
	input  ser_rx,
`endif

`ifdef ENABLE_WB_UART
    output wbuart_tx,
    input  wbuart_rx,
 `endif
   
`ifdef ENABLE_WB_I2C
    inout  wbi2c_sda,
    inout  wbi2c_scl,
`endif

`ifdef ENABLE_WB_SPI_MASTER
    input  wbspi_master_miso,
    output wbspi_master_mosi,
    output [WBSPI_SLAVE_NUM-1 : 0] wbspi_master_ssn,
    output wbspi_master_sclk,
`endif

`ifdef ENABLE_WB_SPI_SLAVE
    output wbspi_slave_miso,
    input  wbspi_slave_mosi,
    input  wbspi_slave_ssn,
    input  wbspi_slave_sclk,
`endif

// external wishbone slave interface
`ifdef ENABLE_OPEN_WB_INTERFACE
    output          slv_ext_stb_o,
    output          slv_ext_we_o,
    output          slv_ext_cyc_o,
    input           slv_ext_ack_i,
    output   [31:0] slv_ext_adr_o,
    output   [31:0] slv_ext_wdata_o,
    input    [31:0] slv_ext_rdata_i,
    output    [3:0] slv_ext_sel_o,
    input   [31:20] irq_in,
`endif

    input           clk_in,
    input           resetn_in
);  

    parameter         [31:0]  DATA_MEM_BASE     = 32'h 0000_0000;
    parameter         [31:0]  INSTR_MEM_BASE    = 32'h 0100_0000;
    parameter         [31:0]  INNER_PERIPH_BASE = 32'h 0200_0000;
    parameter         [31:0]  EXT_MEM_BASE      = 32'h 0300_0000;
    parameter         [31:0]  WISHBONE_BASE     = 32'h 1000_0000;
	parameter         [31:0]  PROGADDR_RESET    = 32'h 0100_0000;

`ifdef BOOT_FROM_FLASH
	parameter         [31:0]  ADDR_IRQ_OFFSET   = 32'h 0000_0090;
`else
    parameter         [31:0]  ADDR_IRQ_OFFSET   = 32'h 0000_0010;
`endif
    parameter         [31:0]  PROGADDR_IRQ      = PROGADDR_RESET + ADDR_IRQ_OFFSET;

    parameter integer MEM_WORDS = (256 * `D_MEM_K_BYTE);
	parameter [31:0]  STACKADDR = (4 * MEM_WORDS);       // end of memory, (4*MEM_WORDS)

    wire        clk;
    wire        resetn;
    wire        trap;

	reg  [31:0] irq;
    wire [31:0] irq_mask_o;

    wire        mem_valid;
    wire        mem_instr;
    reg         mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    reg  [31:0] mem_rdata;
	
	wire        smem_ready;
    wire [31:0] smem_rdata;
	wire        smem_valid;
	wire [3:0]  smem_wstrb;
	wire [31:0] smem_addr;
	wire [31:0] smem_wdata;

    wire        spimem_cfgreg_sel;
    wire [31:0] spimem_cfgreg_do;
    wire [31:0] spimem_addr;
    wire        spimem_valid;
    wire        spimem_ready;
    wire [31:0] spimem_rdata;
    wire [31:0] spimem_wdata;

    wire        wbmem_valid;   //input to wb
    wire [31:0] wbmem_addr;    //input to wb
    wire [31:0] wbmem_wdata;   //input to wb
    wire [ 3:0] wbmem_wstrb;   //input to wb
    wire        wbmem_ready;   //output from wb
    wire [31:0] wbmem_rdata;   //output from wb
	 
    reg         ram_ready;
    wire [31:0] ram_rdata;

	wire        simpleuart_reg_div_sel;
	wire [31:0] simpleuart_reg_div_do;	
	wire        simpleuart_reg_dat_sel;
	wire [31:0] simpleuart_reg_dat_do;
	wire        simpleuart_reg_dat_wait;    

    wire [31:0] wbm_adr_o;
    wire [31:0] wbm_dat_o;
    wire [31:0] wbm_dat_i;
    wire        wbm_we_o;
    wire  [3:0] wbm_sel_o;
    wire        wbm_stb_o;
    wire        wbm_ack_i;
    wire        wbm_cyc_o;

    wire        slv_ext_stb_o_wire;
    wire        slv_ext_we_o_wire;
    wire        slv_ext_cyc_o_wire;
    wire        slv_ext_ack_i_wire;
    wire [31:0] slv_ext_adr_o_wire;
    wire [31:0] slv_ext_wdata_o_wire;
    wire [31:0] slv_ext_rdata_i_wire;
    wire  [3:0] slv_ext_sel_o_wire;

    wire [31:0] wbspi_master_adr_i;
    wire [31:0] wbspi_master_dat_i;
    wire [31:0] wbspi_master_dat_o;
    wire        wbspi_master_we_i;
    wire        wbspi_master_cyc_i;
    wire        wbspi_master_stb_i;
    wire        wbspi_master_ack_o;
    wire        wbspi_master_int_o;

    wire [31:0] wbspi_slave_adr_i;
    wire [31:0] wbspi_slave_dat_i;
    wire [31:0] wbspi_slave_dat_o;
    wire        wbspi_slave_we_i;
    wire        wbspi_slave_cyc_i;
    wire        wbspi_slave_stb_i;
    wire        wbspi_slave_ack_o;
    wire        wbspi_slave_int_o;

    wire        wbuart_cyc_i;
    wire        wbuart_stb_i;
    wire        wbuart_we_i;
    wire [31:0] wbuart_adr_i;
    wire [31:0] wbuart_dat_i;
    wire        wbuart_ack_o;
    wire        wbuart_stall_o;
    wire [31:0] wbuart_dat_o;

    wire [31:0] wbi2c_adr_i;
    wire [31:0] wbi2c_dat_i;
    wire [31:0] wbi2c_dat_o;
    wire        wbi2c_we_i;
    wire        wbi2c_stb_i;
    wire        wbi2c_cyc_i;
    wire        wbi2c_ack_o;
    wire        wbi2c_inta_o;

    assign clk = clk_in;


/**********************interrupt input*******************************/

	always @* begin
        irq = 0;
        irq[3] = wbi2c_inta_o;
        irq[4] = wbspi_master_int_o;
        irq[5] = wbspi_slave_int_o;

`ifdef ENABLE_OPEN_WB_INTERFACE
		irq[31:20] = irq_in[31:20];
`endif
	end
 
/**********************power on reset*********************************/
    reg [15:0] rstdly = 0;
    wire resetn_auto;
    always @(negedge clk)
    begin
        if(!resetn_in)
            rstdly <= 0;
        else
            rstdly <= {rstdly[14:0],1'b1};

    end
    assign resetn_auto = rstdly[15];
    assign resetn = resetn_in & resetn_auto;
/*********************************************************************/

	assign smem_valid = mem_valid && (mem_addr[31:24] == 'h01);
	assign smem_wstrb = mem_wstrb;
	assign smem_addr  = mem_addr - INSTR_MEM_BASE;
	assign smem_wdata = mem_wdata;

    assign wbmem_valid = mem_valid && (mem_addr[31:28] > 'h0);
    assign wbmem_wstrb = mem_wstrb;
    assign wbmem_addr  = mem_addr;
    assign wbmem_wdata = mem_wdata;

`ifdef BOOT_FROM_FLASH
    assign spimem_valid = mem_valid && (mem_addr[31:24] == 'h03);
    assign spimem_addr  = mem_addr - EXT_MEM_BASE;
    assign spimem_wdata = mem_wdata;
`else
    assign spimem_valid = 0;
    assign spimem_addr  = 32'h0;
    assign spimem_wdata = 32'h0;
`endif


	assign mem_ready = (smem_valid && smem_ready) || 
                                        ram_ready ||
                                      wbmem_ready ||
                                     spimem_ready ||
                                spimem_cfgreg_sel ||
                           simpleuart_reg_div_sel ||
                       (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait);

	assign mem_rdata = (smem_valid && smem_ready) ? smem_rdata : 
                                        ram_ready ? ram_rdata :
                                      wbmem_ready ? wbmem_rdata :
                                     spimem_ready ? spimem_rdata :
                                spimem_cfgreg_sel ? spimem_cfgreg_do : 
                           simpleuart_reg_div_sel ? simpleuart_reg_div_do :
                           simpleuart_reg_dat_sel ? simpleuart_reg_dat_do : 
                                spimem_cfgreg_sel ? spimem_cfgreg_do :
                                                    32'h 0000_0000;
 
    reg  [31:0] irq_reg_0, irq_reg_1, irq_reg_2;
    wire [31:0] irq_to_core;
    always @(posedge clk or negedge resetn)
    begin
        if (!resetn)
        begin
            irq_reg_0 <= 'h0;
            irq_reg_1 <= 'h0;
            irq_reg_2 <= 'h0;
        end 
        else begin
            irq_reg_0 <= irq & (~irq_mask_o);
            irq_reg_1 <= irq_reg_0;
            irq_reg_2 <= irq_reg_1;
        end
    end   
    assign irq_to_core = irq_reg_1 & (~irq_reg_2);

	picorv32 #(
		.STACKADDR        (STACKADDR),
		.PROGADDR_RESET   (PROGADDR_RESET),
		.PROGADDR_IRQ     (PROGADDR_IRQ)
		) core (
		.clk         (clk        ),
		.resetn      (resetn     ),
		.trap        (           ),
        .irq_mask_o  (irq_mask_o ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  ),
        .pcpi_valid  (           ),
	    .pcpi_insn   (           ),
	    .pcpi_rs1    (           ),
	    .pcpi_rs2    (           ),
	    .pcpi_wr     (1'b1       ),
	    .pcpi_rd     (32'b0      ),
	    .pcpi_wait   (1'b0       ),
	    .pcpi_ready  (1'b0       ),
		.irq         (irq_to_core),
        .eoi         (           ),
	    .trace_valid (           ),
	    .trace_data  (           )
	);

    picosoc_inst_mem  
    #(.K_BYTES(`I_MEM_K_BYTE)) 
    smem (
        .clk         (clk         ),
        .mem_valid   (smem_valid  ), 
        .mem_ready   (smem_ready  ), 
        .mem_addr    (smem_addr   ), 
        .mem_wdata   (smem_wdata  ),  
        .mem_wstrb   ((smem_valid && !smem_ready && mem_addr[31:24] == 'h01) ? smem_wstrb : 4'b0 ), 
        .mem_rdata   (smem_rdata  )
    );

	always @(posedge clk)
    begin
		ram_ready <= mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS;
    end
	picosoc_data_mem 
    #(.K_BYTES(`D_MEM_K_BYTE)) 
    memory (
		.clk(clk),
		.wen((mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS) ? mem_wstrb : 4'b0),
		.addr(mem_addr[23:2]),
		.wdata(mem_wdata),
		.rdata(ram_rdata)
    );

`ifdef BOOT_FROM_FLASH
    assign spimem_cfgreg_sel = mem_valid && (mem_addr == 32'h 0200_0000);
    spimemio spimemio_interface (
        .clk       (clk),
        .resetn    (resetn),
        .valid     (spimem_valid),
        .ready     (spimem_ready),
        .addr      (spimem_addr),
        .rdata     (spimem_rdata),

        .flash_csb (spimem_csb),
        .flash_clk (spimem_clk),
        .flash_io0 (spimem_io0),
        .flash_io1 (spimem_io1),
        .flash_io2 (spimem_io2),
        .flash_io3 (spimem_io3),

        .cfgreg_we (spimem_cfgreg_sel ? mem_wstrb : 4'b0000),
        .cfgreg_di (mem_wdata),
        .cfgreg_do (spimem_cfgreg_do)
    );
`else
    assign spimem_cfgreg_sel = 0;
    assign spimem_ready = 0;
`endif

    assign simpleuart_reg_div_sel = mem_valid && (mem_addr == 32'h 0200_0004);
    assign simpleuart_reg_dat_sel = mem_valid && (mem_addr == 32'h 0200_0008);
`ifdef ENABLE_SIMPLE_UART
	simpleuart simpleuart (
		.clk         (clk         ),
		.resetn      (resetn      ),

		.ser_tx      (ser_tx      ),
		.ser_rx      (ser_rx      ),

		.reg_div_we  (simpleuart_reg_div_sel ? mem_wstrb : 4'b 0000),
		.reg_div_di  (mem_wdata),
		.reg_div_do  (simpleuart_reg_div_do),

		.reg_dat_we  (simpleuart_reg_dat_sel ? mem_wstrb[0] : 1'b0),
		.reg_dat_re  (simpleuart_reg_dat_sel && !mem_wstrb),
		.reg_dat_di  (mem_wdata),
		.reg_dat_do  (simpleuart_reg_dat_do),
		.reg_dat_wait(simpleuart_reg_dat_wait)
	);
`else
    assign simpleuart_reg_dat_do = 32'hffffffff;
    assign simpleuart_reg_div_do = 32'h0;
    assign simpleuart_reg_dat_wait = 0;
`endif

    wishbone_bus wb (
        .wb_rst_i    (~resetn),
        .wb_clk_i    (clk),
    
        //Wishbone interfaces
        .wbm_adr_o   (wbm_adr_o),
        .wbm_dat_o   (wbm_dat_o),
        .wbm_dat_i   (wbm_dat_i),
        .wbm_we_o    (wbm_we_o),
        .wbm_sel_o   (wbm_sel_o),
        .wbm_stb_o   (wbm_stb_o),
        .wbm_ack_i   (wbm_ack_i),
        .wbm_cyc_o   (wbm_cyc_o),
 
        //Pico interfaces
        .mem_valid   (wbmem_valid),
        .mem_addr    (wbmem_addr),
        .mem_wdata   (wbmem_wdata),
        .mem_wstrb   ((wbmem_valid && !wbmem_ready && mem_addr[31:28] > 'h0) ? wbmem_wstrb : 4'b0),
        .mem_ready   (wbmem_ready),
        .mem_rdata   (wbmem_rdata)
    );

    wisbhone_intercon wb_intercon (
//  slave 0. address space (0x10000000 - 0x10000fff)
        .slv0_stb_o     (wbspi_master_stb_i),
        .slv0_we_o      (wbspi_master_we_i),
        .slv0_cyc_o     (wbspi_master_cyc_i),
        .slv0_ack_i     (wbspi_master_ack_o),
        .slv0_adr_o     (wbspi_master_adr_i),
        .slv0_wdata_o   (wbspi_master_dat_i),
        .slv0_rdata_i   (wbspi_master_dat_o),

//  slave 1. address space (0x10001000 - 0x10001fff)
        .slv1_stb_o     (wbspi_slave_stb_i),
        .slv1_we_o      (wbspi_slave_we_i),
        .slv1_cyc_o     (wbspi_slave_cyc_i),
        .slv1_ack_i     (wbspi_slave_ack_o),
        .slv1_adr_o     (wbspi_slave_adr_i),
        .slv1_wdata_o   (wbspi_slave_dat_i),
        .slv1_rdata_i   (wbspi_slave_dat_o),

//  slave 2. address space (0x10002000 - 0x10002fff)
        .slv2_stb_o     (wbuart_stb_i),
        .slv2_we_o      (wbuart_we_i),
        .slv2_cyc_o     (wbuart_cyc_i),
        .slv2_ack_i     (wbuart_ack_o),
        .slv2_adr_o     (wbuart_adr_i),
        .slv2_wdata_o   (wbuart_dat_i),
        .slv2_rdata_i   (wbuart_dat_o),

//  slave 3. address space (0x10003000 - 0x10003fff)
        .slv3_stb_o     (wbi2c_stb_i),
        .slv3_we_o      (wbi2c_we_i),
        .slv3_cyc_o     (wbi2c_cyc_i),
        .slv3_ack_i     (wbi2c_ack_o),
        .slv3_adr_o     (wbi2c_adr_i),
        .slv3_wdata_o   (wbi2c_dat_i),
        .slv3_rdata_i   (wbi2c_dat_o),

//  slave ext. address space (0x2000_0000 - )
        .slv_ext_stb_o   (slv_ext_stb_o_wire),
        .slv_ext_we_o    (slv_ext_we_o_wire),
        .slv_ext_cyc_o   (slv_ext_cyc_o_wire),
        .slv_ext_ack_i   (slv_ext_ack_i_wire),
        .slv_ext_adr_o   (slv_ext_adr_o_wire),
        .slv_ext_wdata_o (slv_ext_wdata_o_wire),
        .slv_ext_rdata_i (slv_ext_rdata_i_wire),
        .slv_ext_sel_o   (slv_ext_sel_o_wire),

//  global wishbone signals
        .glob_stb_i     (wbm_stb_o),
        .glob_we_i      (wbm_we_o),
        .glob_cyc_i     (wbm_cyc_o),
        .glob_ack_o     (wbm_ack_i),
        .glob_adr_i     (wbm_adr_o),
        .glob_wdata_i   (wbm_dat_o),
        .glob_rdata_o   (wbm_dat_i),
        .glob_sel_i     (wbm_sel_o)
    );

`ifdef ENABLE_OPEN_WB_INTERFACE
    assign slv_ext_stb_o = slv_ext_stb_o_wire;
    assign slv_ext_we_o = slv_ext_we_o_wire;
    assign slv_ext_cyc_o = slv_ext_cyc_o_wire;
    assign slv_ext_ack_i_wire = slv_ext_ack_i;
    assign slv_ext_adr_o = slv_ext_adr_o_wire;
    assign slv_ext_wdata_o = slv_ext_wdata_o_wire;
    assign slv_ext_rdata_i_wire = slv_ext_rdata_i;
    assign slv_ext_sel_o = slv_ext_sel_o_wire;
`else
    assign slv_ext_ack_i_wire = 1'b0;
    assign slv_ext_rdata_i_wire = 32'b0;
`endif


`ifdef ENABLE_WB_I2C
assign wbi2c_dat_o[31:8] = 24'b0;
i2c_master_top wbi2c_ins (
    .wb_clk_i   (clk), 
    .wb_rst_i   (~resetn), 
    .arst_i     (resetn), 
    .wb_adr_i   (wbi2c_adr_i[2:0]), //[2:0]
    .wb_dat_i   (wbi2c_dat_i[7:0]), //[7:0]
    .wb_dat_o   (wbi2c_dat_o[7:0]), //[7:0]
    .wb_we_i    (wbi2c_we_i),  
    .wb_stb_i   (wbi2c_stb_i), 
    .wb_cyc_i   (wbi2c_cyc_i), 
    .wb_ack_o   (wbi2c_ack_o), 
    .wb_inta_o  (wbi2c_inta_o),
    .scl        (wbi2c_scl),
    .sda        (wbi2c_sda)
);
`else
    assign wbi2c_ack_o = 1'b0;
    assign wbi2c_inta_o = 1'b0;
    assign wbi2c_dat_o = 32'b0;
`endif


`ifdef ENABLE_WB_UART
wbuart wbuart_ins (
    .i_clk             (clk), 
    .i_rst             (~resetn),
    .i_wb_cyc          (wbuart_cyc_i), 
    .i_wb_stb          (wbuart_stb_i), 
    .i_wb_we           (wbuart_we_i), 
    .i_wb_addr         (wbuart_adr_i), 
    .i_wb_data         (wbuart_dat_i),
	.o_wb_ack          (wbuart_ack_o), 
    .o_wb_stall        (wbuart_stall_o), 
    .o_wb_data         (wbuart_dat_o),
    .i_uart_rx         (wbuart_rx), 
    .o_uart_tx         (wbuart_tx), 
    .o_uart_rx_int     (), 
    .o_uart_tx_int     (),
    .o_uart_rxfifo_int (), 
    .o_uart_txfifo_int ()
);
`else
    assign wbuart_ack_o = 1'b0;
    assign wbuart_stall_o = 1'b0;
    assign wbuart_dat_o = 32'b0;
`endif


`ifdef ENABLE_WB_SPI_MASTER
wbspi 
#(
    .SHIFT_DIRECTION (`WBSPI_MASTER_SHIFT_DIRECTION),
    .CLOCK_PHASE     (`WBSPI_MASTER_CLOCK_PHASE),
    .CLOCK_POLARITY  (`WBSPI_MASTER_CLOCK_POLARITY),
    .CLOCK_SEL       (`WBSPI_MASTER_CLOCK_SEL),		
    .MASTER          (1),
    .SLAVE_NUMBER    (`WBSPI_MASTER_SLAVE_NUMBER),		
    .DATA_LENGTH     (`WBSPI_MASTER_DATA_LENGTH),		
    .DELAY_TIME      (`WBSPI_MASTER_DELAY_TIME),
    .CLKCNT_WIDTH    (`WBSPI_MASTER_CLKCNT_WIDTH),
    .INTERVAL_LENGTH (`WBSPI_MASTER_INTERVAL_LENGTH)
) wbspi_master (
   //slave port
   .SPI_ADR_I     (wbspi_master_adr_i),    //8 bit width - changed from 32 bits
   .SPI_DAT_I     (wbspi_master_dat_i),    //8 bit width - changed from 32 bits
   .SPI_WE_I      (wbspi_master_we_i),
   .SPI_CYC_I     (wbspi_master_cyc_i),
   .SPI_STB_I     (wbspi_master_stb_i),
   .SPI_SEL_I     ('b0),
   .SPI_CTI_I     ('b0),
   .SPI_BTE_I     ('b0),
   .SPI_LOCK_I    ('b0),
   .SPI_DAT_O     (wbspi_master_dat_o),    //8 bit width - changed from 32 bits
   .SPI_ACK_O     (wbspi_master_ack_o),
   .SPI_INT_O     (wbspi_master_int_o),
   .SPI_ERR_O     (),
   .SPI_RTY_O     (),
   //spi interface
   .MISO_MASTER   (wbspi_master_miso),
   .MOSI_MASTER   (wbspi_master_mosi),
   .SS_N_MASTER   (wbspi_master_ssn),
   .SCLK_MASTER   (wbspi_master_sclk),
   .MISO_SLAVE    (),
   .MOSI_SLAVE    ('b0),
   .SS_N_SLAVE    ('b0),
   .SCLK_SLAVE    ('b0),
   //system clock and reset
   .CLK_I         (clk),
   .RST_I         (~resetn)
   );
`else
    assign wbspi_master_dat_o = 32'b0;
    assign wbspi_master_ack_o = 1'b0;
    assign wbspi_master_int_o = 1'b0;
`endif

`ifdef ENABLE_WB_SPI_SLAVE
wbspi 
#(
    .SHIFT_DIRECTION (`WBSPI_SLAVE_SHIFT_DIRECTION),
    .CLOCK_PHASE     (`WBSPI_SLAVE_CLOCK_PHASE),
    .CLOCK_POLARITY  (`WBSPI_SLAVE_CLOCK_POLARITY),
    .CLOCK_SEL       (`WBSPI_SLAVE_CLOCK_SEL),		
    .MASTER          (0),
    .SLAVE_NUMBER    (1),		
    .DATA_LENGTH     (`WBSPI_SLAVE_DATA_LENGTH),		
    .DELAY_TIME      (`WBSPI_SLAVE_DELAY_TIME),
    .CLKCNT_WIDTH    (`WBSPI_SLAVE_CLKCNT_WIDTH),
    .INTERVAL_LENGTH (`WBSPI_SLAVE_INTERVAL_LENGTH)
) wbspi_slave (
   //slave port
   .SPI_ADR_I     (wbspi_slave_adr_i),    //8 bit width - changed from 32 bits
   .SPI_DAT_I     (wbspi_slave_dat_i),    //8 bit width - changed from 32 bits
   .SPI_WE_I      (wbspi_slave_we_i),
   .SPI_CYC_I     (wbspi_slave_cyc_i),
   .SPI_STB_I     (wbspi_slave_stb_i),
   .SPI_SEL_I     ('b0),
   .SPI_CTI_I     ('b0),
   .SPI_BTE_I     ('b0),
   .SPI_LOCK_I    ('b0),
   .SPI_DAT_O     (wbspi_slave_dat_o),    //8 bit width - changed from 32 bits
   .SPI_ACK_O     (wbspi_slave_ack_o),
   .SPI_INT_O     (wbspi_slave_int_o),
   .SPI_ERR_O     (),
   .SPI_RTY_O     (),
   //spi interface
   .MISO_MASTER   ('b0),
   .MOSI_MASTER   (),
   .SS_N_MASTER   (),
   .SCLK_MASTER   (),
   .MISO_SLAVE    (wbspi_slave_miso),
   .MOSI_SLAVE    (wbspi_slave_mosi),
   .SS_N_SLAVE    (wbspi_slave_ssn),
   .SCLK_SLAVE    (wbspi_slave_sclk),
   //system clock and reset
   .CLK_I         (clk),
   .RST_I         (~resetn)
   );
`else
    assign wbspi_slave_dat_o = 32'b0;
    assign wbspi_slave_ack_o = 1'b0;
    assign wbspi_slave_int_o = 1'b0;
`endif

endmodule



