library ieee;
use ieee.std_logic_1164.all;

entity dff_or is 
        port (a, b, clk: in std_logic;
                 q: out std_logic);
end dff_or;

architecture sensitivity_list of dff_or is
begin

process (clk) -- clock name is in sensitivity list
begin
    if rising_edge(clk) then
        q <= a or b;
    end if;
end process;

end sensitivity_list ;

architecture wait_statement of dff_or is
begin

process  -- note the absence of a sensitivity list.
begin
--  the process waits here until the condition becomes true
    wait until rising_edge(clk);
    q <= a or b;
end process;

end wait_statement ;






