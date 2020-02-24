library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity addern is
        generic (num_bits : integer := 8) ;
        port ( a,b:      in std_logic_vector (num_bits -1 downto 0);
               result:     out std_logic_vector(num_bits -1 downto 0) );

end addern;
architecture behave of addern is
begin
        result <= a + b;
end;


