-- Stretchable loadable, up/down/hold counter
-- with load and asynchronous high reset

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
    generic (width : integer := 4);
    port(clk, rst : in std_logic;
            up, down, load : in std_logic;
            data : in std_logic_vector (width - 1 downto 0);
            q : buffer std_logic_vector (width - 1 downto 0) );
end counter;

architecture behave of counter is
begin
    process (clk, rst)
        variable delta : std_logic_vector (width - 1 downto 0);
    begin
        if rst = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if (load = '1') then
                q <= data;
            elsif (up = '1' or down = '1') then
                if (up = '1') then
                    delta := (0 => '1', others => '0');
                else
                    delta := (others => '1');
                end if;
                q <= q + delta;
            end if;
        end if;
    end process;
end behave;
