
//Interactive attribute example for syn_romstyle attribute

module test (input clock,
			 input [4:0] addr,
			 output reg [7:0] dataout);
			 

reg [4:0] addr_reg;


always @(posedge clock) 
begin
	addr_reg<=addr;
	 case (addr_reg)
	  5'b00000: dataout <= 8'b10000011;
	  5'b00001: dataout <= 8'b00000101;
	  5'b00010: dataout <= 8'b00001001;
	  5'b00011: dataout <= 8'b00001101;
	  5'b00100: dataout <= 8'b00010001;
	  5'b00101: dataout <= 8'b00011001;
	  5'b00110: dataout <= 8'b00100001;
	  5'b00111: dataout <= 8'b10110100;
	  5'b01000: dataout <= 8'b11000000;
	  5'b01000: dataout <= 8'b00011011;
	  5'b01001: dataout <= 8'b10110001;
	  5'b01010: dataout <= 8'b00110101;
	  5'b01011: dataout <= 8'b01110010;
	  5'b01100: dataout <= 8'b11100011;
	  5'b01101: dataout <= 8'b00111111;
	  5'b01110: dataout <= 8'b01010101;
	  5'b01111: dataout <= 8'b00110100;
	  5'b10000: dataout <= 8'b10110000;
	  5'b10000: dataout <= 8'b11111011;
	  5'b10001: dataout <= 8'b00010001;
	  5'b10010: dataout <= 8'b10110011;
	  5'b10011: dataout <= 8'b00101011;
	  5'b10100: dataout <= 8'b11101110;
	  5'b10101: dataout <= 8'b01110111;
	  5'b10110: dataout <= 8'b01110101;
	  5'b10111: dataout <= 8'b01000011;
	  5'b11000: dataout <= 8'b01011100;
	  5'b11000: dataout <= 8'b11101011;
	  5'b11001: dataout <= 8'b00010100;
	  5'b11010: dataout <= 8'b00110011;
	  5'b11011: dataout <= 8'b00100101;
	  5'b11100: dataout <= 8'b01001110;
	  5'b11101: dataout <= 8'b01110100;
	  5'b11110: dataout <= 8'b11100101;
	  5'b11111: dataout <= 8'b01111110;
	  default: dataout <= 8'b00000000;
 	endcase
end
endmodule