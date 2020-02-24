library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
entity encoder is
    port ( a, b, c, d, e, f, g, h : in std_logic;
              out2, out1, out0 : out std_logic);
end encoder;

architecture behave of encoder is
begin
 process (a, b, c, d, e, f, g, h)
       variable inputs : std_logic_vector (7 downto 0);     
       variable i : integer ;
   begin
      inputs := (h, g, f, e, d, c, b, a);
      i := 7;
      while i >= 0 and inputs(i) /= '1' loop
         i  := i - 1;
      end loop;
      if ( i < 0) then
          i := 0;
      end if;
     -- The second argument in conv_std_logic_vector is
     --   the width of the result.
     (out2, out1, out0) <= conv_std_logic_vector (i, 3);
  end process;
end behave;
