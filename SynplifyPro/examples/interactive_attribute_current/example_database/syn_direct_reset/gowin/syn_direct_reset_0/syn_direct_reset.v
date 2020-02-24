// Interactive attribute example for syn_direct_reset
// This example has seperate AND logic and one of input is directly applied as dedicated reset input to flipflop by syn_direct_reset attribute. 

`timescale 1 ns/ 100 ps

module direct_reset_example (
		clk, 
		input1,
		input2,
		input3,
		data_in,
		data_out
);

//----------------------------
// Input Ports
//----------------------------
input clk;
input input1;
input input2;
input input3;
input [1:0] data_in;

//----------------------------
// Output Ports
//----------------------------
output reg [1:0] data_out;

always @ (posedge clk)
    if (input1 == 1'b1 || input2 == 1'b1 || input3 == 1'b1)
        data_out = 2'b00;
    else
        data_out = data_in;
   
endmodule