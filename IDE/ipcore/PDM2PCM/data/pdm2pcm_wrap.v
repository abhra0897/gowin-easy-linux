`include "define.v"
`include "parameter.v"
`include "static_macro_define.v"
module `MODULE_NAME(
	input clk, 
	input rstn, 
	input ce,
	input in_pdm_valid,
	input [NUM_CHN-1:0] in_pdm_data,
	output out_pdm_sclk,
	output out_pcm_valid,
	output out_pcm_sync,
	output signed [DATA_WIDTH-1:0] out_pcm_data
	);

`getname(pdm2pcm,`MODULE_NAME) #(
		.DIV_N(DIV_N),
        .TAP_SIZES(TAP_SIZES),
		.R(R),
		.M(M),
		.N(N),
		.NUM_CHN(NUM_CHN),
		.EDGE_MODE(EDGE_MODE),
		.DATA_WIDTH(DATA_WIDTH)
	)pdm2pcm(
		.clk(clk), 
		.rstn(rstn),
		.ce(ce),
	
		.out_pdm_sclk(out_pdm_sclk),
		.in_pdm_valid(in_pdm_valid),
		.in_pdm_data(in_pdm_data),
	
		.out_pcm_valid(out_pcm_valid),
		.out_pcm_sync(out_pcm_sync),
		.out_pcm_data(out_pcm_data)
	);
endmodule