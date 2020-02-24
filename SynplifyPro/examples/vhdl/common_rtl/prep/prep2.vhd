-- PREP Benchmark 2, Timer/Counter
-- PREP2 contains 8 bit registers, a mux, counter and comparator

-- Copyright (c) 1994-1996 Synplicity, Inc.
-- You may distribute freely, as long as this header remains attached.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity prep2 is 
    port(
          clk, rst, sel, ldcomp, ldpre : in std_logic;
          data1, data2   : in std_logic_vector (7 downto 0);
          data0   : out std_logic_vector (7 downto 0) 
    );
end prep2;

architecture behave of prep2 is

    signal equal: std_logic;
    signal mux_output: std_logic_vector (7 downto 0);
    signal lowreg_output: std_logic_vector (7 downto 0);
    signal highreg_output: std_logic_vector (7 downto 0);
    signal data0_i: std_logic_vector (7 downto 0);

begin

     equal <= '1' when data0_i = lowreg_output else
                 '0';

     mux_output <= highreg_output when sel = '0' else
                      data1 when sel = '1' else
                      (others => 'X');

    registers: process  (rst, clk)
    begin
        if  rst = '1' then
            highreg_output <= (others => '0');
            lowreg_output <= (others => '0');
        elsif  rising_edge(clk) then
            if  ldpre = '1' then
                highreg_output <= data2;
            end if;
            if  ldcomp = '1' then
                lowreg_output <= data2;
            end if;
        end if;
    end process registers;

    counter: process  (rst, clk)
    begin
        if  rst = '1' then
            data0_i <= (others => '0');
        elsif rising_edge(clk) then
            if  equal = '1' then
                data0_i <= mux_output;
            elsif  equal = '0' then
                data0_i <= data0_i + "00000001";
            end if;
        end if;
    end process counter;
    data0 <= data0_i;
end behave;
