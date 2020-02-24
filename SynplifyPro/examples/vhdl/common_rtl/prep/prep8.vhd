-- PREP Benchmark 8, Sixteen Bit Pre-Scaled Counter
-- PREP8 contains a sixteen bit pre-scaled counter.
-- The implementation is the same as in PREP7.

-- Copyright (c) 1994-1996 Synplicity, Inc.
-- You may distribute freely, as long as this header remains attached.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity prep8 is 
    port( 
          clk, rst, ld, ce : in std_logic;
          d : in std_logic_vector (15 downto 0);
          q : out std_logic_vector (15 downto 0) 
       );
end prep8;

architecture behave of prep8 is

    signal q_i: std_logic_vector (15 downto 0);

begin
    
 -- register the adder output
    accum: process (rst, clk)
    begin
        if  rst = '1' then
            q_i <= (others => '1');
        elsif  rising_edge(clk) then
            if ld = '1' then
                q_i <= d;
            elsif  ce = '1' then 
                q_i <= q_i + '1';
            end if;
        end if;
    end process accum;
    q <= q_i;
end behave;
