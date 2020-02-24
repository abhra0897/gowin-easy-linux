`include	"global.inc"

module ae250soc (

`ifdef AE250_SPI1_SUPPORT
	inout	X_spi1_clk,
	inout	X_spi1_csn,
	inout	X_spi1_miso,
	inout	X_spi1_mosi,
   `ifdef ATCSPI200_QUADSPI_SUPPORT
	inout	X_spi1_holdn,
	inout	X_spi1_wpn,
   `endif
`endif

`ifdef AE250_SPI2_SUPPORT
	inout	X_spi2_clk,
	inout	X_spi2_csn,
	inout	X_spi2_miso,
	inout	X_spi2_mosi,
	`ifdef ATCSPI200_QUADSPI_SUPPORT
	inout	X_spi2_holdn,
	inout	X_spi2_wpn,
   	`endif
`endif

`ifdef AE250_UART1_SUPPORT
	inout	X_uart1_ctsn,
	inout	X_uart1_dcdn,
	inout	X_uart1_dsrn,
	inout	X_uart1_dtrn,
	inout	X_uart1_out1n,
	inout	X_uart1_out2n,
	inout	X_uart1_rin,
	inout	X_uart1_rtsn,
	inout	X_uart1_rxd,
	inout	X_uart1_txd,
`endif

`ifdef AE250_UART2_SUPPORT
	inout	X_uart2_ctsn,
	inout	X_uart2_dcdn,
	inout	X_uart2_dsrn,
	inout	X_uart2_dtrn,
	inout	X_uart2_out1n,
	inout	X_uart2_out2n,
	inout	X_uart2_rin,
	inout	X_uart2_rtsn,
	inout	X_uart2_rxd,
	inout	X_uart2_txd,
`endif

`ifdef AE250_I2C_SUPPORT
	inout	X_i2c_scl,
	inout	X_i2c_sda,
`endif

`ifdef AE250_GPIO_SUPPORT
	inout	[`ATCGPIO100_GPIO_NUM -1:0] X_gpio,
`endif

`ifdef AE250_PIT_SUPPORT
		output	X_pwm_ch0,
	`ifdef ATCPIT100_CH1_SUPPORT
		output	X_pwm_ch1,
	`endif
	`ifdef ATCPIT100_CH2_SUPPORT
		output	X_pwm_ch2,
	`endif
	`ifdef ATCPIT100_CH3_SUPPORT
		output	X_pwm_ch3,
	`endif
`endif

	input	X_aopd_por_b,
	input	X_por_b,
	input	X_hw_rstn,
	input	X_wakeup_in,
	output	X_mpd_pwr_off,
	output	X_rtc_wakeup,

	input	X_oschin,
	output	X_oschio,

	input	X_osclin,
	output	X_osclio,

	inout	X_tms,
	inout	X_tck,
	inout	X_tdi,
	inout	X_tdo,
	inout	X_trst,

	input	X_om
);
wire locX_om;
assign locX_om = 0;

ae250_chip iChip(

`ifdef AE250_SPI1_SUPPORT
	.X_spi1_clk			(X_spi1_clk),
	.X_spi1_csn			(X_spi1_csn),
	.X_spi1_miso		(X_spi1_miso),
	.X_spi1_mosi		(X_spi1_mosi),
   `ifdef ATCSPI200_QUADSPI_SUPPORT
	.X_spi1_holdn		(X_spi1_holdn),
	.X_spi1_wpn			(X_spi1_wpn),
   `endif
`endif

`ifdef AE250_SPI2_SUPPORT
	.X_spi2_clk			(X_spi2_clk),
	.X_spi2_csn			(X_spi2_csn),
	.X_spi2_miso		(X_spi2_miso),
	.X_spi2_mosi		(X_spi2_mosi),
	`ifdef ATCSPI200_QUADSPI_SUPPORT
	.X_spi2_holdn		(X_spi2_holdn),
	.X_spi2_wpn			(X_spi2_wpn),
   	`endif
`endif

`ifdef AE250_UART1_SUPPORT
	.X_uart1_ctsn			(X_uart1_ctsn),
	.X_uart1_dcdn			(X_uart1_dcdn),
	.X_uart1_dsrn			(X_uart1_dsrn),
	.X_uart1_dtrn			(X_uart1_dtrn),
	.X_uart1_out1n			(X_uart1_out1n),
	.X_uart1_out2n			(X_uart1_out2n),
	.X_uart1_rin			(X_uart1_rin),
	.X_uart1_rtsn			(X_uart1_rtsn),
	.X_uart1_rxd			(X_uart1_rxd),
	.X_uart1_txd			(X_uart1_txd),
`endif

`ifdef AE250_UART2_SUPPORT
	.X_uart2_ctsn			(X_uart2_ctsn),
	.X_uart2_dcdn			(X_uart2_dcdn),
	.X_uart2_dsrn			(X_uart2_dsrn),
	.X_uart2_dtrn			(X_uart2_dtrn),
	.X_uart2_out1n			(X_uart2_out1n),
	.X_uart2_out2n			(X_uart2_out2n),
	.X_uart2_rin			(X_uart2_rin),
	.X_uart2_rtsn			(X_uart2_rtsn),
	.X_uart2_rxd			(X_uart2_rxd),
	.X_uart2_txd			(X_uart2_txd),
`endif

`ifdef AE250_I2C_SUPPORT
	.X_i2c_scl			(X_i2c_scl),
	.X_i2c_sda			(X_i2c_sda),
`endif

`ifdef AE250_GPIO_SUPPORT
	.X_gpio			(X_gpio),
`endif

`ifdef AE250_PIT_SUPPORT
		.X_pwm_ch0			(X_pwm_ch0),
	`ifdef ATCPIT100_CH1_SUPPORT
		.X_pwm_ch1			(X_pwm_ch1),
	`endif
	`ifdef ATCPIT100_CH2_SUPPORT
		.X_pwm_ch2			(X_pwm_ch2),
	`endif
	`ifdef ATCPIT100_CH3_SUPPORT
		.X_pwm_ch3			(X_pwm_ch3),
	`endif
`endif

	.X_aopd_por_b		(X_aopd_por_b),
	.X_por_b			(X_por_b),
	.X_hw_rstn			(X_hw_rstn),
	.X_wakeup_in		(X_wakeup_in),
	.X_mpd_pwr_off		(X_mpd_pwr_off),
	.X_rtc_wakeup		(X_rtc_wakeup),

	.X_oschin			(X_oschin),
	.X_oschio			(X_oschio),

	.X_osclin			(X_osclin),
	.X_osclio			(X_osclio),

	.X_tms			(X_tms),
	.X_tck			(X_tck),
	.X_tdi			(X_tdi),
	.X_tdo			(X_tdo),
	.X_trst			(X_trst),
	.X_om			(locX_om)
);



endmodule
