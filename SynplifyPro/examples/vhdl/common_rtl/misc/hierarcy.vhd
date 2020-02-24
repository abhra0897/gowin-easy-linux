-- Example of a hierarchical design
------------------------------------------------------
-- First define the lower level modules: mux, reg8, & rotate
------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity muxhier is
	port (outvec: out std_logic_vector (7 downto 0);
	a_vec, b_vec: in std_logic_vector (7 downto 0);
	sel: in std_logic);
end muxhier;

architecture mux_design of muxhier is -- mux
begin 
with sel select
    outvec <= a_vec when '1',
              b_vec when '0',
              "XXXXXXXX" when others;
end mux_design;

library ieee;
use ieee.std_logic_1164.all;
entity reg8 is
	port (q: buffer std_logic_vector (7 downto 0);
	data: in std_logic_vector (7 downto 0);
	clk, rst: in std_logic);
end reg8;
architecture reg8_design of reg8 is -- eight bit register
begin 
process (clk, rst)
begin
    if rst = '1' then
        q <= X"00";
    elsif rising_edge(clk) then
        q <= data;
    end if;
end process;
end reg8_design;

library ieee;
use ieee.std_logic_1164.all;
entity rotate is
	port (q: buffer std_logic_vector (7 downto 0);
	data: in std_logic_vector (7 downto 0);
	clk, rst, r_l: in std_logic);
end rotate;
architecture rotate_design of rotate is 
-- rotates bits or loads
-- when r_l is high, it rotates; if low, it loads data
begin 
process (clk, rst)
begin
    if rst = '1' then
         q <= X"00";
    elsif rising_edge(clk) then
         if r_l = '1' then
              q <= q ( 6 downto 0 ) & q (7) ;
         else
              q <= data;
         end if;
    end if;
end process;

end rotate_design;

----------------------------------------
--      Top level
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity top_level is
	port (q:	 buffer std_logic_vector (7 downto 0);
	a, b: in std_logic_vector (7 downto 0);
	sel, r_l, clk, rst: in std_logic);
end top_level;

architecture structural of top_level is

component muxhier  -- component declaration for mux
	port (outvec: out std_logic_vector (7 downto 0);
	a_vec, b_vec: in std_logic_vector (7 downto 0);
	sel: in std_logic);
end component;

component reg8  -- component declaration for reg8
	port (q: buffer std_logic_vector (7 downto 0);
	data: in std_logic_vector (7 downto 0);
	clk, rst: in std_logic);
end component;

component rotate  -- component declaration for rotate
	port (q: buffer std_logic_vector (7 downto 0);
	data: in std_logic_vector (7 downto 0);
	clk, rst, r_l: in std_logic);
end component;

-- declare the internal signals here
signal mux_out, reg_out: std_logic_vector (7 downto 0);

begin  --  structural description begins

-- instantiate a mux, name it inst1, and wire it up
-- here we connect the mux  with positional port mapping (by position)
inst1:  muxhier port map (mux_out, a, b, sel);

-- instantiate a rotate, name it inst2, and wire it up
inst2: rotate port map (q, reg_out, clk, rst, r_l);

-- instantiate a reg8, name it inst3, and wire it up
-- reg8 is connected with named port mapping (by name)
-- the port connections can be given in any order
-- Note that the local signal names are on the right of the
-- '=>' mapping operators, and the signal names from the
-- component declaration are on the left.

inst3: reg8 
	port map (clk => clk, data => mux_out, 
	q => reg_out, rst => rst);

end structural;









