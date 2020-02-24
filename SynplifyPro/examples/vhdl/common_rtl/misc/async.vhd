-- Asynchronous state machines (small ones)
-- Do not give these designs to a synthesis tool because the
-- optimizer will remove the gates you put in for hazard suppression.
--
-- Synplify-Lite correctly gives a "Found combinational loop"
-- error message for these designs to remind you that you should
-- not design asynchronous state machines with a synthesis tool
-- unless you explicitly instantiate technology primitives from
-- your target library. (They are not optimized out of the netlist).

library ieee;
use ieee.std_logic_1164.all;
entity async is
	-- output is a buffer mode so that it can be read
	port (output : buffer std_logic ;
	g, d : in std_logic ) ;
end async ;


architecture async1 of async is 
begin

output <= (((((g and d)  or (not g)) and output)or d) and output) ;

end async1;

architecture async2 of async is 
begin

process (g, d, output)
begin
	output <= (((((g and d) or (not g)) and output) or d) and output) ;
end process;

end async2;











