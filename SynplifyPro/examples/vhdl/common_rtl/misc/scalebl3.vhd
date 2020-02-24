-- We show 3 methods of creating scaleable designs. For 
-- creating adders, we suggest using the add operator
-- as shown in file: scalebl1.vhd (rather than using the
-- random logic shown here.
library ieee;
use ieee.std_logic_1164.all;
entity adder is
    port (a, b, cin : in std_logic;
              sum, cout : out std_logic);
end adder;

architecture behave of adder is
begin
    sum <= (a xor b) xor cin;
    cout <= (a and b) or (cin and a) or (cin and b);
end behave;
Instantiating the one bit adder many times with a generate
library ieee;
use ieee.std_logic_1164.all;

entity addern is
    generic(n : integer := 8);
    port (a, b : in std_logic_vector(n downto 1);
             cin : in std_logic;
             sum : out std_logic_vector(n downto 1);
             cout : out std_logic);
end addern;

architecture structural of addern is
-- The component declaration goes here. 
-- This allows you to instantiate the adder.
component adder
    port (a, b, cin : in std_logic;
             sum, cout : out std_logic);
end component;

    signal carry : std_logic_vector(0 to n);
begin

    -- Instantiate a single-bit adder n times
    -- You don't need to declare the index 'i",
    -- Indices are implicitly declared for all loops.
    gen: for i in 1 to n generate
    add_onebit: adder port map(
                         a => a(i),
                         b => b(i),
                         cin => carry(i - 1),
                         sum => sum(i),
                         cout => carry(i));
           end generate;
    carry(0) <= cin;
    cout <= carry(n);

end structural;

