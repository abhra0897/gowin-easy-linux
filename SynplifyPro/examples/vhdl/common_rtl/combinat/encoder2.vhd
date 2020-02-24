library ieee;
use ieee.std_logic_1164.all;

entity encoder is
	port ( in1     :in   std_logic_vector(7 downto 0);
	       out1    :out  std_logic_vector(2 downto 0));
end encoder;

architecture behave of encoder is
begin
      process (in1)
      begin
            if in1(7) = '1' then
                 out1 <= "111";
            elsif in1(6) = '1' then
                 out1 <= "110";
            elsif in1(5) = '1' then
                 out1 <= "101";
            elsif in1(4) = '1' then
                 out1 <= "100";
            elsif in1(3) = '1' then
                 out1 <= "011";
            elsif in1(2) = '1' then
                 out1 <= "010";
            elsif in1(1) = '1' then
                 out1 <= "001";
            elsif in1(0) = '1' then
                 out1 <= "000";
            else 
                 out1 <= "XXX";
	    end if;	
      end process;
end behave;

