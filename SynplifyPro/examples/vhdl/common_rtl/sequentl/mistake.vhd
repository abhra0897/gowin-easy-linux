-- Demonstrates latch warning 
-- caused by missed assignment in case "two"
-- This warning message will help you find a functional
-- error even before simulation!
library ieee;
use ieee.std_logic_1164.all;
entity mistake is
   port (inp:        in  std_logic_vector(1 downto 0);
         outp:       out std_logic_vector(3 downto 0);
         even,odd:   out std_logic);
end mistake;
architecture behave of mistake is
   constant zero:  std_logic_vector(1 downto 0):= "00";
   constant one:   std_logic_vector(1 downto 0):= "01";
   constant two:   std_logic_vector(1 downto 0):= "10";
   constant three: std_logic_vector(1 downto 0):= "11";
   begin
   process (inp) begin
      case inp is
         when zero =>
               outp <= "0001";
               even <= '1';
               odd <= '0';
         when one =>
               outp <= "0010";
               even <= '0';
               odd <= '1';
         when two =>
               outp <= "0100";
               even <= '1';
--             odd <= '0'; Notice that "odd" is not assigned
         when three =>
               outp <= "1000";
               even <= '0';
               odd <= '1';
      end case;
   end process;
end behave;








