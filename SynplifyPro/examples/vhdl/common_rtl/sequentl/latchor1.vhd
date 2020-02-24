library ieee;
use ieee.std_logic_1164.all;

entity latchor1 is 
    port (a, b, clk : in std_logic;
-- q has mode buffer so it can be read inside architecture
          q: buffer std_logic );
end latchor1;

architecture behave of latchor1 is
begin
     q  <=  a or b when clk = '1' else q;
end behave;




