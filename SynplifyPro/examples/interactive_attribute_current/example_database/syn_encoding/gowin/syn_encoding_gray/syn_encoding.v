//Interactive attribute example for syn_encoding attribute
module fsm (clk, reset, x1, outp);
	input        clk, reset, x1;
	output       outp;
	reg          outp;
	reg    [1:0] state;
	parameter s1 = 2'b00; parameter s2 = 2'b01;
	parameter s3 = 2'b10; parameter s4 = 2'b11;
	always @(posedge clk or posedge reset)
	begin
	   if (reset)
	      state <= s1;
	   else begin
	      case (state)
		 s1: if (x1 == 1'b1)
			state <= s2;
		     else
			state <= s3;
		 s2: state <= s4;
		 s3: state <= s4;
		 s4: state <= s1;
	      endcase
	   end
	end
	always @(state) begin
	   case (state)
	      s1: outp = 1'b1;
	      s2: outp = 1'b1;
	      s3: outp = 1'b0;
	      s4: outp = 1'b0;
	   endcase
	end
        endmodule