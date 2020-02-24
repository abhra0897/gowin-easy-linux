library ieee;
use ieee.std_logic_1164.all;
entity adder is
	port (a, b, cin        :std_logic;
	         sum, cout       :out std_logic);
end adder;

architecture behave of adder is
begin
   sum <= (a xor b) xor cin;
   cout  <= (a and b) or (a and cin) or (b and cin);
end behave;
