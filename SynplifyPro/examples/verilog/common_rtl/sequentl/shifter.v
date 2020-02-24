// Shift Register

module shifter(din, clk, clr, dout);
input din, clk, clr;
output [7:0] dout;

reg [7:0] dout;

always @(posedge clk)
begin
	if (clr) 	// clear condition
		dout	= 8'b0;
	else	begin
		// left shift 1 bit 
		dout 	= dout << 1;
		// put new data bit in end
		dout[0] = din;
	end
end

endmodule
