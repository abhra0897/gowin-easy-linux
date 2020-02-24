-- 8 bit shift register with shift right, shift left, load and
-- synchronous reset.

library ieee;
use ieee.std_logic_1164.all;

entity shifter is
    port (data : in std_logic_vector (7 downto 0);
             shift_left, shift_right, clk, reset : in std_logic;
             mode : in std_logic_vector (1 downto 0);
             qout : buffer std_logic_vector (7 downto 0) );
end shifter;

architecture behave of shifter is
    signal enable: std_logic;
begin

    process
    begin
        wait until (rising_edge(clk) );
        if (reset = '1') then
            qout <= "00000000";
        else
            case mode is
                when "01"   =>
                    qout <= shift_right & qout(7 downto 1); -- shift right
                when "10"   =>
                    qout <= qout(6 downto 0) & shift_left; -- shift left
                when "11"   =>
                    qout <= data; -- parallel load
                when others => null; -- null means do nothing
          end case;
        end if;
    end process;

end behave;
