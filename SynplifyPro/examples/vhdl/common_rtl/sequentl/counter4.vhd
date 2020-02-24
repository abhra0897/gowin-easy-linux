-- 4 bit down-counter with load

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
port (data_in : in std_logic_vector (3 downto 0);
         clk, load, down : in std_logic;
         max_val : in std_logic_vector (3 downto 0);
         count : out std_logic_vector (3 downto 0);
         zero : out std_logic);
end counter;

architecture behave of counter is
    signal cnt : std_logic_vector (3 downto 0);
begin
    process
    begin
        wait until rising_edge(clk);
        if (load = '1') then
             cnt <= data_in;
        elsif (down = '1') then
            if (cnt = "0000") then
                cnt <= max_val;
            else
                cnt <= cnt - "0001";
            end if;
        else
             cnt <= cnt;
        end if;
        if (cnt = "0000") then
             zero <= '1';
        else
            zero <= '0';
        end if;
    end process;

    count <= cnt;

end behave;
