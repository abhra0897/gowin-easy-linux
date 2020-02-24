-- We show 3 methods of creating scaleable designs. For 
-- creating adders, we suggest using this method
-- shown here in file: scalebl1.vhd (using the + operator)

library ieee;
use ieee.std_logic_1164.all;
-- the std_logic_unsigned package is required to
-- define the overloading for the "+" operator
use ieee.std_logic_unsigned.all;
entity addn is
-- Note that a, b, and result are not constrained!
-- In VHDL, they automatically size to whatever is passed to them
port(result : out std_logic_vector;
     cout : out std_logic;
     a, b : in std_logic_vector;
     cin : in std_logic);
end addn;

architecture stretch of addn is
	signal tmp : std_logic_vector (a'length downto 0);
begin
   -- Note: this next line works because "+" sizes to
   -- the largest operand (also, you just need to pad one argument)
	tmp <=  ('0' & a) + b + cin;
	result <= tmp(a'length - 1 downto 0);
	cout <= tmp(a'length);
  -- the next two lines are good for simulation
	assert result'length = a'length;
	assert result'length = b'length;
end stretch;

library ieee;
use ieee.std_logic_1164.all;
entity addntest is
-- here is where you size a, b, and result
 port (result : out std_logic_vector (7 downto 0);
	  cout : out std_logic;
	  a, b : in std_logic_vector (7 downto 0);
	  cin : in std_logic);
end addntest;

architecture top of addntest is
	component addn 
	 port (result : std_logic_vector;
	  cout : std_logic;
	  a, b : std_logic_vector;
	  cin : std_logic);
	 end component;
begin
	test : addn port map (result => result, cout => cout, 
			     a => a, b => b, cin=> cin);
end;

