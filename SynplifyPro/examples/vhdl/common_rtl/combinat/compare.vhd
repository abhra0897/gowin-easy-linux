-- Comparator
library ieee;
use ieee.std_logic_1164.all;
entity compare	 is 
	port ( a, b : in std_logic_vector (7 downto 0);  
			   equal: out std_logic);
end compare;

architecture behave of compare is
begin

equal <= '1' when a = b else
                 '0';

end behave ;

