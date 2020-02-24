library ieee;
use ieee.std_logic_1164.all;
entity decoder is
	port ( inp:  in std_logic_vector(2 downto 0);
               outp: out std_logic_vector(7 downto 0));
end decoder;
architecture behave of decoder is
   begin
   process (inp) begin
	case inp is 
		when "000"  => outp <= "00000001";
		when "001"  => outp <= "00000010";
		when "010"  => outp <= "00000100";
		when "011"  => outp <= "00001000";
		when "100"  => outp <= "00010000";
		when "101"  => outp <= "00100000";
		when "110"  => outp <= "01000000";
		when "111"  => outp <= "10000000";
		when others => outp <= "XXXXXXXX";
	end case;
   end process;
end behave;
