library ieee;
use ieee.std_logic_1164.all;
entity mux is
	port (output_signal: out std_logic;
 	a, b, sel: in std_logic );
end mux;

architecture if_mux of mux is
begin
      process (sel, a, b)
         begin
         if sel = '1' then
            output_signal <= a;
         elsif sel = '0' then
            output_signal <= b;
         else
            output_signal <= 'X';
         end if;
      end process;
end if_mux;

architecture case_mux of mux is
begin
      process (sel, a, b)
         begin
         case sel is
            when '1' => output_signal <= a;
            when '0' => output_signal <= b;
            when others => output_signal <= 'X';
        end case;
      end process ;
end case_mux;

architecture with_select_when of mux is
begin
with sel select 
output_signal <= a when '1',
                 b when '0',
                'X' when others; 
end with_select_when ;


architecture when_else of mux is
begin
output_signal <= a when sel = '1' else
                 b when sel = '0' else
                'X';
end when_else ;


