library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is 
generic ( iw : integer := 9;
		  ow : integer := 19
);
port(
in1, in2, in3, in4 : in std_logic_vector(iw downto 0);
clk : in std_logic;
rst : in std_logic;
out1 : out std_logic_vector(ow downto 0));
end test;

architecture beh of test is 

signal add1,add2 : std_logic_vector(iw downto 0);

begin

process(clk,rst)
begin
	if rst = '1' then
   	out1 <= (others => '0');
	elsif clk'event and clk='1' then
		out1 <= add1 * add2;
	end if;
end process;

add1 <= in1 + in2;
add2 <= in3 + in4;


end beh;
