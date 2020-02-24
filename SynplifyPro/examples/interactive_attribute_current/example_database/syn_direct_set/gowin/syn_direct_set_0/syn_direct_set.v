// Interactive attribute example for syn_direct_set
// This example has seperate OR logic and one of input is directly applied as dedicated set input to flipflop by syn_direct_set attribute. 

`timescale 1 ns/ 100 ps

module direct_set_example (
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
        data_out = 2'b11;
    else
        data_out = data_in;

endmodule
