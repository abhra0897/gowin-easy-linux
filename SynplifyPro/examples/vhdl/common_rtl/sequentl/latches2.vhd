-- Synplicity recommends you do not create level
-- sensitive latches as shown in this next example,
-- due to the ease of making user errors with this
-- approach.  If you create latches within a process,
-- Synplify will alert you with a warning message.

library ieee;
use ieee.std_logic_1164.all;

entity latch is
    port (data, clk: in std_logic;
              q: out std_logic);
end latch;

architecture behave of latch is
begin
    process (clk, data)
    begin
        if (clk = '1')then
             q <= data;
        end if;
    end process;
end behave;


