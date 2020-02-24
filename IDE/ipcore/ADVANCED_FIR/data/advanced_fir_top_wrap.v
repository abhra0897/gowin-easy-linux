`include "define.vh"
`include "parameter.vh"
module `module_name (
	input 							clk, 				// system clock
	input 							rstn,				// reset
	input							ce,
	
	output							input_ready,
	input							inpvalid,
`ifdef NOT_1_CHN	
    input                           ibstart,
`endif
	input signed [DIN_WIDTH-1:0]	din,				// input data
	
	input							coeffwe,
	input							coeffset,
	input signed [COEFF_WIDTH-1:0]	coeffin,
	
	output							outvalid,
`ifdef NOT_1_CHN
    output                          obstart,
`endif
	output signed [DOUT_WIDTH-1:0]	dout				// output data
);


	advanced_fir_top #(
        .IP_name(IP_name),
		.TAP_SIZES(TAP_SIZES),
		.NUM_MUL(NUM_MUL),
		.NUM_CHN(NUM_CHN),
		.DIN_WIDTH(DIN_WIDTH),
		.COEFF_WIDTH(COEFF_WIDTH),
		.DOUT_WIDTH(DOUT_WIDTH)
	)advanced_fir_top(
		.clk(clk), 
		.rstn(rstn),
		.ce(ce),
		
		.coeffwe(coeffwe),
		.coeffin(coeffin),
		.coeffset(coeffset),
	
		.inpvalid(inpvalid),
`ifdef NOT_1_CHN
		.ibstart(ibstart),
`endif
		.din(din),
	
		.input_ready(input_ready),
		
		.outvalid(outvalid),
`ifdef NOT_1_CHN
		.obstart(obstart),
`endif
		.dout(dout)
	);
    


endmodule
