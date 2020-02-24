library ieee;
use ieee.std_logic_1164.all;

entity parity is
  generic ( bus_size : integer := 8 );
	port ( input_bus : in std_logic_vector (bus_size-1 downto 0);
  even_numbits, odd_numbits : out std_logic ) ;
end parity ; 

architecture behave of parity is

begin

process (input_bus) 
    variable temp: std_logic;
begin
    temp := '0';
    for i in input_bus'low to input_bus'high loop
        temp := temp xor input_bus(i) ;
    end loop ;
    odd_numbits <= temp ;
    even_numbits <= not temp;
end process;

end behave;


