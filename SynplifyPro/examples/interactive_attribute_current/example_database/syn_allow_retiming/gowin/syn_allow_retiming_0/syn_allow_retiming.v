
// Interactive attribute example for syn_allow_retiming attribute
 
module ret (
		clk,
		in1,
		in2,
		out1
);

parameter size = 8;

//-----------------------------
//  Input Ports
//-----------------------------
input [size-1:0] in1;
input [size-1:0] in2;
input 			 clk;

//-----------------------------
//  Output Ports
//-----------------------------
output out1;

//-----------------------------
// Signal Declarations : Reg
//----------------------------- 
reg out1;
reg [size-1:0] a1, a2;
reg a6;

always @( posedge clk )
begin
   a1 <= in1;
   a2 <= in2; 
end

wire [size-1:0] int1 = a1 ^ a2;
wire [size-1:0] int2 = a1 & a2;

wire a3 = & int1 ;
wire a4 = ^ int2 ;
wire a5 = a3 | a4 ;

always @( posedge clk )
begin
	a6 		<= a5;
   	out1 	<= a6;
end
    
endmodule