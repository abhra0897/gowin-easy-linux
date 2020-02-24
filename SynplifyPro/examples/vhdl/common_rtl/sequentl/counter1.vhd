-- 8 bit up-counter with synchronous reset

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
entity counter is 
    port (clk, reset: in bit;
             count: buffer integer range 0 to 255);
end counter;

architecture behave of counter is
begin
    p1: process
    begin
        wait until clk'event and clk = '1';
        -- if synchronous reset comes along or max count
        if (reset = '1' or count = 255) then
            count <= 0;
        else
            count <= count + 1;
        end if;
    end process p1;
end behave;
