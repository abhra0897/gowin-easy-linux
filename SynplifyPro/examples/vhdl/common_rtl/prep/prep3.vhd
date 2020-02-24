-- PREP Benchmark 3, Small State Machine
-- PREP3 contains a small state machine

-- Copyright (c) 1994-1996 Synplicity, Inc.
-- You may distribute freely, as long as this header remains attached.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity prep3 is 
    port(
          clk, rst: in std_logic;
          inn : in std_logic_vector (7 downto 0);
          outt : out std_logic_vector (7 downto 0) 
    );
end prep3;

architecture behave of prep3 is

    type state is (xstate, start, sa, sb, sc, sd, se, sf, sg);
    signal current_state: state;
    signal outt_i :std_logic_vector (7 downto 0);

begin

    machine: process  (rst, clk)
    begin
        if  rst = '1' then
            current_state <= start;
            outt_i <= (others => '0');
        elsif  rising_edge(clk) then
            case current_state is
                when start =>
                    if inn = "00111100" then -- X"3c"
                        current_state <= sa;
                        outt_i <= "10000010"; -- X"82"
                     else 
                        current_state <= start;
                        outt_i <= "00000000";
                    end if;
                when sa =>
                    if inn = "00101010" then --X"2a"
                        current_state <= sc;
                        outt_i <= "01000000"; --X"40"
                    elsif inn = "00011111" then  --X"1f"
                       current_state <= sb; 
                       outt_i <= "00100000";  --X"20"
                    else 
                        current_state <= sa;
                        outt_i <= "00000100"; --X"04"
                    end if;
                when sb =>
                    if inn = "10101010" then --X"aa"
                        current_state <= se;
                        outt_i <= "00010001"; --X"11"
                     else 
                        current_state <= sf;
                        outt_i <= "00110000"; --X"30"
                    end if;
                when sc =>
                    current_state <= sd;
                    outt_i <= "00001000"; --X"08"
                when sd =>
                    current_state <= sg;
                    outt_i <= "10000000"; --X"80"
                when se =>
                    current_state <= start;
                    outt_i <= "01000000"; --X"40"
                when sf =>
                    current_state <= sg;
                    outt_i <= "00000010";  --X"02"
                when sg => 
                    current_state <= start; 
                    outt_i <= "00000001"; --X"01"
                when others =>
                    current_state <= xstate;
                    outt_i <= (others => 'X'); -- force unknown
            end case;
         end if;
     end process machine;

    outt <= outt_i;
end behave;
