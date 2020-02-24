-- PREP Benchmark 5, Arithmetic Circuit
-- PREP5 contains a multiplier and accumulator

-- Copyright (c) 1994-1996 Synplicity, Inc.
-- You may distribute freely, as long as this header remains attached.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity prep5 is 
    port(
          clk, rst, mac : in std_logic;
          a, b : in std_logic_vector (3 downto 0);
          q : out std_logic_vector (7 downto 0) 
    );
end prep5;

architecture behave of prep5 is

    signal q_i, adder_output, multiply_output: std_logic_vector (7 downto 0);

begin
    multiply_output <= a * b;
    adder_output  <= (multiply_output + q_i) when mac = '1' 
                     else multiply_output;

    -- register the adder output
    registers: process (rst, clk)
    begin
        if  rst = '1' then
            q_i <= (others => '0');
        elsif  rising_edge(clk) then
            q_i <= adder_output;
        end if;
    end process registers;
    q <= q_i;
end behave;
