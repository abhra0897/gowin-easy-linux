-- A simple 3to8 decoder that demonstrates
-- indexing  by a signal
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity decoder is
        port (inp:  in std_logic_vector(2 downto 0);
              outp: out std_logic_vector(7 downto 0));
end decoder;

architecture behave of decoder is
   begin
   process (inp) begin
      outp <= (others => '0');
      outp(CONV_INTEGER(inp)) <= '1';
   end process;
end behave;
