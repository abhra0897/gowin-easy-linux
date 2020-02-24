library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity add_sub is
	port (result : out std_logic_vector (7 downto 0) ;
	a, b : in std_logic_vector (7 downto 0) ;
	add_sub : in std_logic ) ;
end add_sub ;
 
-- Without resource sharing you
-- get an 8-bit adder and a 8-bit subtractor feeding a mux
architecture no_resource_sharing of add_sub is
begin

process (a,  b, add_sub)
begin 
	if add_sub = '1' then
		result <= a + b;
	else
		result <= a - b;
	end if;
end process;

end no_resource_sharing;

-- With manual resource sharing you 
-- get less logic:
-- 8 inverters feeding a mux feeding an 8-bit adder
architecture manual_resource_sharing of add_sub is
begin

process (a,  b, add_sub)
	variable temp: std_logic_vector (7 downto 0);
begin 
	if add_sub = '1' then
		temp := b;
	else
        temp := not b;
	end if;
	result <= a + temp + not add_sub;
end process;

end manual_resource_sharing;


