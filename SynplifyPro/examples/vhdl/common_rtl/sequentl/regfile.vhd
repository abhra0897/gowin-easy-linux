-- A 16X8 register file
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity regfile is
    port (q : out std_logic_vector (7 downto 0);
             d : in std_logic_vector (7 downto 0);
             addr : in std_logic_vector (3 downto 0);
             we, clk : in std_logic);
end regfile;

architecture behave of regfile is
    type rf_type is array (natural range <>) of std_logic_vector (7 downto 0);
    signal rf : rf_type (15 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                rf(conv_integer(addr)) <= d;
            end if;
        end if;
    end process;
q <= rf(conv_integer(addr));
end behave;
