library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test is 
generic (	iw : integer := 9;
			ow : integer := 19
);
port(
in1, in2 : in std_logic_vector(iw downto 0);
clk : in std_logic;
rst : in std_logic;
out1 : out std_logic_vector(ow downto 0));
end test;

architecture beh of test is 

signal mult : std_logic_vector(ow downto 0);
--signal accum : std_logic_vector(19 downto 0);
signal out1_reg : std_logic_vector(ow downto 0);

begin

process(clk,rst)
begin
	if rst = '1' then
   	out1_reg <= (others => '0');
	elsif clk'event and clk='1' then
		out1_reg <= mult + out1_reg;
	end if;
end process;


		mult <= in1 * in2;

out1 <= out1_reg;


end beh;
