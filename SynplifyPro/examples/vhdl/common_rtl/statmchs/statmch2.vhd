--
--State machine that tries to guess the next data input value
--
library ieee;
use ieee.std_logic_1164.all;

entity guesser is
    port(clk, rst, data : in std_logic;
            guess : out std_logic);
end guesser;

architecture behave of guesser is
    type state_value is (sx, solid0, weak0, weak1, solid1);
    signal state : state_value;
begin

    -- Figure out next state
    process (clk, rst)
        variable next_state : state_value;
    begin
        if rst = '1' then
             next_state := solid0;
        elsif rising_edge(clk) then
             next_state := sx; -- catch missing assignments to next_state
             case state is
             when solid0 =>
                 if data = '1' then next_state := weak0;
                 else next_state := solid0;
                 end if;
             when weak0 =>
                 if data = '1' then next_state := weak1;
                 else next_state := solid0;
                 end if;
            when weak1 =>
                 if data = '1' then next_state := solid1;
                 else next_state := weak0;
                 end if;
            when solid1 =>
                 if data = '1' then next_state := solid1;
                 else next_state := weak1;
                 end if;
            when others =>
                 next_state := sx;
            end case;
       end if;
       state <= next_state;
   end process;

   -- Generate guess for next data based on state
    process (state)
    begin
        case state is
            when solid0|weak0 => guess <= '0';
            when solid1|weak1 => guess <= '1';
            when others => guess <= 'X';
        end case;
     end process;

end behave;
