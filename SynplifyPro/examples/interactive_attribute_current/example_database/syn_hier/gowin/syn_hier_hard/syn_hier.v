//Interactive attribute example for syn_hier attribute
module top(
 clk1,en1, data1, 
 q1, q2,q3
 );

input clk1, en1;
input data1;
output q1, q2,q3;

wire cwire, rwire ,dwire;
wire clk_gt;

assign clk_gt = en1 & clk1;

// Register module 

myreg U_reg (
 .datain(data1),
 .rst(1'b1),
 .clk(clk_gt),
 .en(1'b0),
 .dout(rwire),
 .cout(cwire),
 .eout(dwire)
 );

assign q1 = rwire;
assign q2 = cwire;
assign q3 = dwire & en1;

endmodule


module myreg (
 datain,
 rst,
 clk,
 en,
 dout,
 cout,eout
 ) ;

input clk, rst, datain, en;
output dout;
output cout;
output eout;
 reg dreg;

 assign cout = en & datain;

 always @(posedge clk or posedge rst)
  begin
   if (rst)
    dreg <= 'b0;
   else
    dreg <= datain;
  end

assign dout = dreg;
assign eout =datain & clk;
endmodule