-- PREP Benchmark 6, Sixteen Bit Accumulator
-- PREP6 contains a sixteen bit accumulator

-- Copyright (c) 1994-1996 Synplicity, Inc.
-- You may distribute freely, as long as this header remains attached.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity prep6 is 
    port(
          clk, rst : in std_logic;
          d : in std_logic_vector (15 downto 0);
          q : out std_logic_vector (15 downto 0) 
    );
end prep6;

architecture behave of prep6 is

    signal q_i: std_logic_vector (15 downto 0);

begin
    -- register the adder output
    accum: process (rst, clk)
    begin
        if  rst = '1' then
            q_i <= (others => '0');
        elsif  rising_edge(clk) then
            q_i <= q_i + d;
        end if;
    end process accum;
    q <= q_i;
end behave;
