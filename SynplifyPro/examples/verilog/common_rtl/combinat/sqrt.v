`timescale 100ps/100ps
//
// Compute an integer square root of an input
// bus of width 2n with a result bus size of n
//
module sqrtb(z, a);
parameter asize = 8;
output [(asize/2)-1:0] z;
input [asize-1:0] a;
reg [(asize/2)-1:0] z;

always @(a) begin :lbl
	integer i;
	// r is remainder, tt is delta for adding one bit
	// v is current sqrt value
	reg [asize-1:0] v, r, tt;

	v = 0;
	r = a;
	for(i = asize/2 - 1; i >= 0; i = i - 1) begin
		tt = (v << (i + 1)) | (1 << (i + i));
		if(tt <= r) begin
			v = v | (1 << i);
			r = r - tt;
		end
	end
	z = v;
end

endmodule
