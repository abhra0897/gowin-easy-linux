library ieee;
use ieee.std_logic_1164.all;
entity latchor2 is
	port (a, b, clk : in std_logic ;
	q: out std_logic );
end latchor2;

architecture behave of latchor2 is
begin

-- Synplify issues a warning message:
-- "Latch generated from process for 
-- signal q, probably caused by a missing
-- assignment in an if or case statement"
-- We get a level sensitive latch, with
-- "a or b" at the input.

process (clk, a, b)
begin
	if clk = '1' then
		q <= a or b;
	end if;
end process ;

end behave;

