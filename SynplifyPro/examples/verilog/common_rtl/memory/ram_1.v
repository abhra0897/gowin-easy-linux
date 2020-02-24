`timescale 1ns / 100ps
module RAM_test (DO, ADDR, DI, CLK, WE, RST);
output [3:0] DO;
input [4:0] ADDR;
input [3:0] DI;
input CLK, WE, RST;
reg [3:0] mem [31:0] /* synthesis syn_ramstyle = "block_ram" */;
reg [3:0] DO;

always @ (posedge CLK)
   if (RST == 1)
     DO <= 0;
   else
     DO <= mem[ADDR];
  
  
  always @(posedge CLK)
    if  (WE) mem[ADDR] = DI;

endmodule
