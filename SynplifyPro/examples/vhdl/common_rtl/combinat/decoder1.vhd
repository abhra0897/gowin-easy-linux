-- A very short and clean manner of describing
-- a decoder
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity decoder is
	port (inp: in std_logic_vector(2 downto 0);
         outp: out bit_vector(7 downto 0));
end decoder;
architecture behave of decoder is
begin
   outp <=  "00000001" sll CONV_INTEGER(inp);
end behave;


