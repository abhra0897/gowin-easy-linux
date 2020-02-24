-- Tri-state output driver

library ieee;
use ieee.std_logic_1164.all;

entity tristate1 is
	port ( input, enable : in std_logic;
output : out std_logic) ;
end tristate1 ; 

architecture single_driver of tristate1 is
begin

output <= input when enable = '1' else 'Z' ;

end single_driver ;


-- Multiple tri-state drivers on a bus

library ieee;
use ieee.std_logic_1164.all;

entity tristate2 is
	port ( input3, input2, input1, input0: in std_logic_vector (7 downto 0);
             enable : in std_logic_vector (3 downto 0);
             output : out std_logic_vector (7 downto 0) );
end tristate2 ; 

architecture multiple_drivers of tristate2 is
begin

output <= input3 when enable(3) = '1' else "ZZZZZZZZ" ;
output <= input2 when enable(2) = '1' else "ZZZZZZZZ" ;
output <= input1 when enable(1) = '1' else "ZZZZZZZZ" ;
output <= input0 when enable(0) = '1' else "ZZZZZZZZ" ;

end multiple_drivers;

-- Tri-state bi-directional driver example

library ieee;
use ieee.std_logic_1164.all;

entity bidir is
    port ( input_val, enable, other_sig : in std_logic;
              output_val : out std_logic;
              bidir_port : inout std_logic) ;
end bidir ; 

architecture tri_state of bidir is
begin

bidir_port <= input_val when enable = '1' else 'Z' ;
-- Here we are xor'ing the bidir port with another
-- signal "other_sig". A different operation could be
-- performed with an internal signal:
output_val <= bidir_port xor other_sig ;

end tri_state;




