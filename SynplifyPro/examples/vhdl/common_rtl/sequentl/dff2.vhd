library ieee;
use ieee.std_logic_1164.all;

entity dff2 is 
    port (data, clk, reset, set : in std_logic;
             qrs: out std_logic);
end dff2;

architecture sync_set_reset of dff2 is
begin
setreset: process (clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            qrs <= '0';
        elsif set = '1' then
            qrs <= '1';
        else
            qrs <= data;
        end if;
    end if;
end process setreset;
end sync_set_reset;






