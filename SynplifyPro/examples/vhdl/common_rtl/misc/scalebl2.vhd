-- We show 3 methods of creating scaleable designs. For 
-- creating adders, we suggest using the add operator
-- as shown in file: scalebl1.vhd (rather than using the
-- random logic shown here.

library ieee;
use ieee.std_logic_1164.all;
entity adder is
    generic(num_bits : integer := 4);   -- default adder size is 4 bits
    port (a    : in std_logic_vector(num_bits downto 1);
          b    : in std_logic_vector(num_bits downto 1);
          cin  : in std_logic;
          sum  : out std_logic_vector(num_bits downto 1);
          cout : out std_logic);
end adder;

architecture behave of adder is
begin
   
process(a, b, cin)
	variable vsum : std_logic_vector(num_bits downto 1);
	variable carry : std_logic;
begin
	carry := cin;
	for i in 1 to num_bits loop
	    vsum(i) := (a(i) xor b(i)) xor carry;
	    carry := (a(i) and b(i)) or (carry and (a(i) or b(i)));
	end loop;
	sum <= vsum;
	cout <= carry;
end process;

end behave;

-- Scale the adder by overriding the generic
library ieee;
use ieee.std_logic_1164.all;
entity adder16 is
         port (a    : in std_logic_vector(8 downto 1);
          b    : in std_logic_vector(8 downto 1);
          cin  : in std_logic;
          sum  : out std_logic_vector(8 downto 1);
          cout : out std_logic);
end adder16;

architecture behave of adder16 is

component adder 
    generic(num_bits : integer := 4);   -- default adder size is 4 bits
    port (a    : in std_logic_vector ;--(num_bits downto 1);
          b    : in std_logic_vector ;--(num_bits downto 1);
          cin  : in std_logic;
          sum  : out std_logic_vector;--(num_bits downto 1);
          cout : out std_logic);
end component;

begin

my_adder : adder 
	generic map (8) -- use an 8 bit adder
	port map(a, b, cin, sum, cout);

end behave;




