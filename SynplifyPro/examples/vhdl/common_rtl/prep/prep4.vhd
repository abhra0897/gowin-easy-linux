-- PREP Benchmark 4, Large State Machine
-- PREP4 contains a large state machine

-- Copyright (c) 1994-1996 Synplicity, Inc.
-- You may distribute freely, as long as this header remains attached.

library ieee;
use ieee.std_logic_1164.all;

entity prep4 is 
    port(
          clk, rst: in std_logic;
          i : in std_logic_vector (7 downto 0);
          o : out std_logic_vector (7 downto 0) 
   );
end prep4;

architecture behave of prep4 is

    type state is (
                   xstate, st0, st1, st2, st3, st4, st5, st6, st7, st8,
                   st9, st10, st11, st12, st13, st14, st15
                  );
    signal machine : state;
    signal o_i : std_logic_vector (7 downto 0);

begin
    
 state_machine: process (rst, clk)
    begin
        if  rst = '1' then
            machine  <= st0;
        elsif  rising_edge(clk) then
            case machine is
                when st0 =>
                    if i = "00000000" then
                        machine <= st0;
                     elsif i = "00000001" or i = "00000010" or i ="00000011" then
                        machine <= st1;
                     elsif i > "00000011" and i <= "00011111" then
                        machine <= st2;
                     elsif i > "00011111" and i <= "00111111" then
                        machine <= st3;
                    else
                        machine <= st4;
                    end if;
                when st1 =>
                    if i(1 downto 0) = "11" then
                        machine <= st0;
                     else
                        machine <= st3;
                    end if;
                when st2 =>
                    machine <= st3;
                when st3 =>
                    machine <= st5;
                when st4 =>
                    if  i(0) = '1' or i(2) = '1' or i(4) = '1' then
                        machine <= st5;
                    else
                        machine <= st6;
                    end if;
                when st5 =>
                    if i(0) = '0' then
                        machine <= st5;
                    else
                        machine <= st7;
                    end if;
                when st6 =>
                    case i(7 downto 6) is
                        when "00" =>
                            machine <= st6;
                        when "01" =>
                            machine <= st8;
                        when "10" =>
                            machine <= st9;
                        when "11" =>
                            machine <= st1;
                        when others =>
                            machine <= xstate;
                    end case;
                when st7 => 
                    case i(7 downto 6) is
                        when "00" =>
                            machine <= st3;
                        when "11" =>
                            machine <= st4;
                        when others =>
                            machine <= st7;
                    end case;
                when st8 => 
                    if  (i(4) xor i(5)) = '1' then
                        machine <= st11; 
                    elsif i(7) = '1' then
                        machine <= st1;
                    else
                        machine <= st8;
                    end if;
                when st9 => 
                    if i(0) = '1' then
                        machine <= st11; 
                     else
                        machine <= st9;
                    end if;
                when st10 => 
                    machine <= st1; 
                when st11 => 
                    if  i = "01000000" then
                        machine <= st15; 
                    else 
                        machine <= st8;
                    end if;
                when st12 => 
                    if  i = "11111111" then
                        machine <= st0; 
                    else 
                        machine <= st12;
                    end if;
                when st13 => 
                    if  (i(5) xor i(3) xor i(1)) = '1'  then
                        machine <= st12; 
                    else
                        machine <= st14;
                    end if;
                when st14 => 
                    if  i = "00000000" then
                        machine <= st14; 
                    elsif  i > "00000000" and i <= X"3f" then 
                        machine <= st12;
                    else
                        machine <= st10;
                    end if;
                when st15 => 
                    if i(7) = '1' then
                        case i(1 downto 0) is    
                            when "00" =>
                                machine <= st14;
                            when "01" =>
                                machine <= st10;
                            when "10" =>
                                machine <= st13;
                            when "11" =>
                                machine <= st0;
                            when others =>
                                machine <= xstate;
                        end case;
                    else 
                        machine <= st15; 
                    end if;
                when others =>
                    machine <= xstate;
            end case;
        end if;
    end process state_machine;

    
 outputs: process (machine)
    begin
        case machine is
            when st0 =>
                o_i <= "00000000";
            when st1 =>
                o_i <= "00000110";
            when st2 =>
                o_i <= "00011000";
            when st3 =>
                o_i <= "01100000";
            when st4 =>
                o_i <= "1XXXXXX0";
            when st5 =>
                o_i <= "X1XXXX0X";
            when st6 =>
                o_i <= "00011111";
            when st7 =>
                o_i <= "00111111";
            when st8 =>
                o_i <= "01111111";
            when st9 =>
                o_i <= "11111111";
            when st10 =>
                o_i <= "X1X1X1X1";
            when st11 =>
                o_i <= "1X1X1X1X";
            when st12 =>
                o_i <= "11111101";
            when st13 =>
                o_i <= "11110111";
            when st14 =>
                o_i <= "11011111";
            when st15 =>
                o_i <= "01111111";
            when xstate =>
                o_i <= (others => 'X');
        end case;
    end process outputs;
    o <= o_i;
end behave;
