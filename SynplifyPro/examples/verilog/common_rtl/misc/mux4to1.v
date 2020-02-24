// Example where we create latches that are not wanted
// see the on-line help 
// under "Combinational Logic (Using Always Blocks)"

module mux4to1(out, a, b, c, d, sel);
output out;
input a, b, c, d;
input [1:0] sel;
reg out;

always @(sel or a or b or c or d)
begin
	case (sel)
	2'd0: out = a;
  	2'd1: out = b;
  	2'd3: out = d;
	endcase
end
endmodule


