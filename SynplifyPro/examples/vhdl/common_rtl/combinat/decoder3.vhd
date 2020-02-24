-- A simple 3to8 decoder 
library ieee;
use ieee.std_logic_1164.all;
entity decoder is
	port ( inp:  in std_logic_vector(2 downto 0);
               outp: out std_logic_vector(7 downto 0));
end decoder;
architecture behave of decoder is
   begin
outp(0) <= '1' when inp = "000" else '0';
outp(1) <= '1' when inp = "001" else '0';
outp(2) <= '1' when inp = "010" else '0';
outp(3) <= '1' when inp = "011" else '0';
outp(4) <= '1' when inp = "100" else '0';
outp(5) <= '1' when inp = "101" else '0';
outp(6) <= '1' when inp = "110" else '0';
outp(7) <= '1' when inp = "111" else '0';
end behave;
