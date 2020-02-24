-- PREP Benchmark 9, Memory Map
-- PREP9 contains a memory mapper.

-- Copyright (c) 1994-1996 Synplicity, Inc.
-- You may distribute freely, as long as this header remains attached.

library ieee;
use ieee.std_logic_1164.all;

entity prep9 is 
    port( clk, rst, as : in std_logic;
             al, ah : in std_logic_vector (7 downto 0);
             be : out std_logic;
             q : out std_logic_vector (7 downto 0) );
end prep9;

architecture behave of prep9 is
    signal q_i: std_logic_vector (7 downto 0);
    signal be_i: std_logic;
    signal addr: std_logic_vector (15 downto 0);
begin
    addr <= ah & al;
    memmap: process (rst, clk)
    begin
        if  rst = '1' then
            q_i <= (others => '0');
            be_i <= '0';
        elsif  rising_edge(clk) then
           if as = '0' then
                q_i <= (others => '0'); -- be remains unchanged.
            else 
                q_i <= (others => '0');
                be_i <= '0';
                if addr <= "1110001010101010" then -- e2aa
                    be_i <= '1';
                elsif addr = "1110001010101011" then -- e2ab
                    q_i(7) <= '1';
                elsif addr <= "1110001010101111" then --e2af
                    q_i(6) <= '1';
                elsif addr <= "1110001010111111" then -- e2bf
                    q_i(5) <= '1';
                elsif addr <= "1110001011111111" then -- e2ff
                    q_i(4) <= '1';
                elsif addr <= "1110001111111111" then -- e3ff
                    q_i(3) <= '1';
                elsif addr <= "1110011111111111" then -- e7ff
                    q_i(2) <= '1';
                elsif addr <= "1110111111111111" then -- efff
                    q_i(1) <= '1';
                else 
                    q_i(0) <= '1'; -- addr <= X"ffff"
               end if;
            end if;
        end if;
    end process memmap;
    q <= q_i;
    be <= be_i;
end behave;
