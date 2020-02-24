
module tstbench;
// instantiate top level design here
`ifdef synthesis
`else
	always #100 clk = ~clk;
	initial
	begin    
		clk = 1;   
		// put rest of stimulus here
	end
`endif
endmodule
