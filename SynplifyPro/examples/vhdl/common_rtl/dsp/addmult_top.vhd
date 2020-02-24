library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_top is 
generic (	iw : integer := 9;
			ow : integer := 19
);
port(
in1_top, in2_top : in std_logic_vector(iw downto 0);
clk : in std_logic;
rst_top : in std_logic;
out1_top : out std_logic_vector(ow downto 0)
);
end test_top;

architecture rtl of test_top is
component test 
generic (	iw : integer := 9;
			ow : integer := 19
);
port(
in1, in2, in3, in4 : in std_logic_vector(iw downto 0);
clk : in std_logic;
rst : in std_logic;
out1 : out std_logic_vector(ow downto 0));
end component;

begin

u1 : test generic map ( iw => iw,
						ow => ow)
			port map ( 	in1 => in1_top,
						in2 => in2_top,
						in3 => in1_top,
						in4 => in2_top,
						rst => rst_top,
						clk => clk,
						out1 => out1_top
						);



end rtl;

