//Interactive attribute example for syn_dspstyle attribute

module dsp_style (clk,A,B,PC,P);

input clk;
input [7:0] A,B,PC;
output reg [16:0] P;

reg [7:0]a_d,b_d;
reg [16:0] m;


always @(posedge clk) begin
    
    a_d <= A;
    b_d <= B;
    m   <= a_d * b_d;
    P   <= m + PC;
    
  end
  
  endmodule