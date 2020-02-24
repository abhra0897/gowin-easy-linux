library ieee;
use ieee.std_logic_1164.all;

entity dff1 is 
    port (data, clk, reset, set : in std_logic;
             qrs: out std_logic);
end dff1;

architecture async_set_reset of dff1 is
begin
    setreset: process (clk, reset, set)
    begin
            if reset = '1' then
                qrs <= '0';
            elsif set = '1' then
                qrs <= '1';
            elsif rising_edge(clk) then
                qrs <= data;
            end if;
    end process setreset;
end async_set_reset;
