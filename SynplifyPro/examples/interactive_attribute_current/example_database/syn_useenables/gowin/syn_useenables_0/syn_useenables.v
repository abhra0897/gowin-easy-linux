
//Interactive attribute example for syn_useenables attribute

module useenables(d,clk,q,en);

input [1:0] d;
input en,clk;

output [1:0] q;
reg [1:0] q_reg,q;

always @(posedge clk)
  if (en)
	begin
        q_reg<=d;
	   q<=q_reg;   
	end  
endmodule