-- 4 bit up-counter with load and asynchronous low reset

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counter is
    port (clk, reset, load: in std_logic;
             data: in std_logic_vector (7 downto 0);
             count: out std_logic_vector (7 downto 0) );
end counter;

architecture behave of counter is
    signal count_i : std_logic_vector (7 downto 0);
begin
    process (clk, reset) 
    begin
       if (reset = '0') then
            count_i <= "00000000";
       elsif rising_edge(clk) then
          if load = '1' then
               count_i <= data;
          else
               count_i <= count_i + '1';
          end if;
       end if;
    end process;
    count <= count_i;
end behave;
