// Priority encoder example 1

module encoder1(none_on, out, in);
output none_on;
output [2:0] out;
input [7:0] in;
reg [2:0] out;
reg none_on;

always @(in)
begin: local
	integer i;
	out = 0;
	none_on = 1;
	/* returns the value of the highest bit number turned on */
	for (i = 0; i < 8; i = i +1) 
	begin
		if (in[i]) begin
			out = i;
			none_on = 0;
		end
	end
end

endmodule
