// Parity Generator

module parity(even_numbits, odd_numbits, input_bus);
output even_numbits, odd_numbits;
input [7:0] input_bus;

assign odd_numbits = ^ input_bus;
assign even_numbits = ~odd_numbits;

endmodule
