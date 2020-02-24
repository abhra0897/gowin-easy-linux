library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity addern is
        port ( a,b:       in std_logic_vector;
                  result:     out std_logic_vector);
end addern;
architecture behave of addern is
begin
        result <= a + b;
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity adders is
        generic(msb_operand:    integer := 15;
                       msb_sum: integer:=15);
        port(b: in std_logic_vector(msb_operand downto 0);
                 result: out std_logic_vector(msb_sum downto 0));
end adders;
architecture behave of adders is
        component addern
                port ( a,b: in std_logic_vector;
                       result: out std_logic_vector);
        end component;  
        signal a: std_logic_vector(msb_sum /2 downto 0);
        signal  twoa: std_logic_vector(msb_operand downto 0);
        begin   
        twoa <= a&a;
        I1:addern
                port map ( a => twoa, b=>b,result=>result);
        little:addern
                port map ( a=>b(msb_operand downto msb_operand/2 +1),
			   b=>b(msb_operand/2 downto 0),
                           result => a);
end behave;
