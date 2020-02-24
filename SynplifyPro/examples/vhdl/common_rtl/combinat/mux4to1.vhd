-- a 4 to 1 mux

library ieee;
use ieee.std_logic_1164.all;
entity mux is
	port (output_signal:             out std_logic;
	      in1, in2, in3, in4:  in std_logic;
         sel:              in std_logic_vector( 1 downto 0)
         );
end mux;

architecture behave of mux  is
begin
   process (in1, in2, in3, in4, sel)
   begin
      case sel is
         when "00" =>
               output_signal <= in1;
         when "01" =>
               output_signal <= in2;
         when "10" =>
               output_signal <= in3;
         when "11" =>
               output_signal <= in4;
         when others =>
               output_signal <= 'X';
      end case;
   end process;
end behave;
