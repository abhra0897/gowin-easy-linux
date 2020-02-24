//Interactive attribute example for syn_probe attribute
module alu(out1, opcode, clk, a, b);
output [7:0] out1;
input [2:0] opcode;
input [7:0] a, b;
input clk;
reg [7:0] alu_tmp;

reg [7:0] out1;
// Other code
always @(opcode or a or b)
begin
 case (opcode)
  3'b000:alu_tmp <= a&b;
  3'b001:alu_tmp <= a|b;
  3'b010:alu_tmp <= a^b;
  3'b011:alu_tmp <= a&~b;
  default:alu_tmp <= a|~b;
 endcase
end
always @(posedge clk)
out1 <= alu_tmp;
endmodule