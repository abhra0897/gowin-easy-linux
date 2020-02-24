--
-- Demonstration of implicit state machines in VHDL
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity implicit is
	port (z : out std_logic_vector(7 downto 0);
		  a, b, c : in std_logic_vector(7 downto 0);
		  rst : in std_logic;
		  clk : in std_logic);
end entity implicit;

architecture beh of implicit is
	signal sum : std_logic_vector(7 downto 0);
    -- Make sure resource sharing is turned on for this architecture
	-- regardless of global setting of sharing option.
	attribute syn_sharing : string;
	attribute syn_sharing of all : architecture is "on";
begin
	-- Sum a, b, c on three separate clock stages
    -- accumulate values between cycles.
    -- rst is a syncronous reset that resets the current
    -- accumulated value to 0.
	lbl: process
	begin
		if rst = '1' then
			sum <= (others => '0');
		end if;
		wait until rising_edge(clk);
		if rst /= '1' then
			sum <= sum + a;
			wait until rising_edge(clk);
			sum <= sum + b;
			if rst /= '1' then
				wait until rising_edge(clk);
				sum <= sum + c;
			end if;
		end if;
	end process;
	z <= sum;
	
end architecture beh;


