-- ALU
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity alu is 
	port ( a, b : in std_logic_vector(7 downto 0);
	       opcode: in std_logic_vector(1 downto 0);
               clk: in std_logic;
	       result: out std_logic_vector(7 downto 0) );
end alu;

architecture behave of alu is
   constant plus: std_logic_vector(1 downto 0) :=  b"00";
   constant minus: std_logic_vector(1 downto 0) := b"01";
   constant equal: std_logic_vector(1 downto 0) := b"10";
   constant not_equal: std_logic_vector(1 downto 0) := b"11";
begin

process (opcode)
begin
      case opcode is
        when plus =>    result <= a + b; -- add
        when minus => result <= a - b;  -- subtract
        when equal =>  -- equal
            if (a = b) then
                  result <= X"01";
            else
                  result <= X"00";
            end if;
        when not_equal =>  -- not equal
            if (a /= b) then
                  result <= X"01";
            else
                  result <= X"00";
            end if;
     end case;
   end process;
end behave;
