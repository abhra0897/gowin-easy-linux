library ieee;
use ieee.std_logic_1164.all;
entity encoder is 
	port ( a, b, c, d, e, f, g, h     : in std_logic;
	      out0, out1, out2       : out std_logic);
end encoder;

architecture behave of encoder is
   signal outvec  :std_logic_vector(2 downto 0);
begin
      outvec(2 downto 0) <= "111" when h = '1' else
                            "110" when g = '1' else
                            "101" when f = '1' else
                            "100" when e = '1' else
                            "011" when d = '1' else
                            "010" when c = '1' else
                            "001" when b = '1' else
                            "000" when a = '1' else
                            "000";
      out0 <= outvec(0);
      out1 <= outvec(1);
      out2 <= outvec(2);

end behave;
