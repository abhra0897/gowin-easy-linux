//Interactive attribute example for syn_replicate attribute
module norep (Reset, Clk, Drive, OK, ADPad, IPad, ADOut);
input Reset, Clk, Drive, OK;
input [31:0] ADOut;
inout [31:0] ADPad;
output [31:0] IPad;
reg [31:0] IPad;
reg DriveA ;
assign ADPad = DriveA ? ADOut : 32'b0;
always @(posedge Clk or negedge Reset)
 if (!Reset)
  begin
   DriveA <= 0;
   IPad <= 0;
  end
 else
  begin
   DriveA <= Drive & OK;
   IPad <= ADPad;
  end
endmodule