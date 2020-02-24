-- 8 bit up-counter with load, count 
-- enable, and asynchronous high reset

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
    port (d : in std_logic_vector (7 downto 0);
              ld, ce, clk, rst : in std_logic;
              q : out std_logic_vector (7 downto 0));
end counter;

architecture behave of counter is
    signal count : std_logic_vector (7 downto 0);
begin
    process (clk, rst)
    begin
        if rst = '1' then
            count <= "00000000";
        elsif rising_edge(clk) then
            if ld = '1' then
                count <= d;
            elsif ce = '1' then
                count <= count + 1;
            end if;
        end if;
    end process;
    q <= count;
end behave;
