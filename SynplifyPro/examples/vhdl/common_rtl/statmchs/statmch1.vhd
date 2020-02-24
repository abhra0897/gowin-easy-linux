library ieee;
use ieee.std_logic_1164.all;

entity stmch1 is
    port(clk, in1, rst: in std_logic; out1: out std_logic);
end stmch1;

architecture behave of stmch1 is
    type state_values is (sx, s0, s1);
    signal state, next_state: state_values;
begin

 process (clk, rst)
 begin
        if rst = '1' then
	 state <= s0;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
 end process;

process (state, in1)
    begin
        -- set defaults for output and state
        out1 <= '0';
       next_state <= sx; -- catch missing assignments to next_state
        case state is
            when s0 =>
                if in1 = '0' then
                    out1 <='1';
                    next_state <= s1;
                else
                    out1 <= '0';
                    next_state <= s0;
                end if;
            when s1 =>
                if in1 = '0' then
                    out1 <='0';
                    next_state <= s0;
                else
                    out1 <= '1';
                    next_state <= s1;
                end if;
            when sx =>
                    next_state <= sx;
            end case;
        end process;
end behave;
