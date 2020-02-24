-- PREP Benchmark 1, Data Path
-- PREP1 contains a 4-to-1 mux, 8 bit register and 8 bit shift register

-- Copyright (c) 1994-1996 Synplicity, Inc.
-- You may distribute freely, as long as this header remains attached.

library ieee;
use ieee.std_logic_1164.all;

entity prep1 is 
    port(
            clk, rst, s_l : in std_logic;
            s : in std_logic_vector (1 downto 0);
            d0, d1, d2, d3 : in std_logic_vector (7 downto 0);
            q : out std_logic_vector (7 downto 0) 
    );
end prep1;

architecture behave of prep1 is

    signal q_i, y, q_reg: std_logic_vector (7 downto 0);

begin
    mux: process (s, d0, d1, d2, d3)
    begin 
        case s is
            when "00" => 
                y <= d0;
            when "01" => 
                y <= d1;
            when "10" => 
                y <= d2;
            when "11" => 
                y <= d3;
            when others =>
                y <= (others => 'X');
        end case;
    end process mux;
    -- register the mux output
  reg1: process (rst, clk)
    begin
        if  rst = '1' then
            q_reg <= (others => '0');
            q_i <= (others => '0');
        elsif  rising_edge(clk) then
            if  s_l = '1' then
                q_i(0) <= q_i(7);
            loop1:  for i in 6 downto 0 loop
                    q_i(i + 1) <= q_i(i);
                end loop loop1;
                q_reg <= y;
            else
                q_i <= q_reg;
                q_reg <= y;
            end if;
        end if;
    end process reg1;
    q <= q_i;
end behave;
