-- Two instance version.
----------------------------------------------------------------------
-- prep benchmark circuit #2 - timer/counter (1 instance)
--
-- 8 bit registers, mux, counter and comparator
--
-- copyright (c) 1994 by synplicity, inc.
--
-- you may distribute freely, as long as this header remains attached.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity prep2_1 is 
	port( 	clk : in bit;
		rst : in bit;	
		sel : in bit;
		ldcomp : in bit;
		ldpre : in bit;
		data1,data2   : in std_logic_vector(7 downto 0);
		data0   : out std_logic_vector(7 downto 0)
	    );
end prep2_1;

architecture behave of prep2_1 is
	signal equal: bit;
	signal mux_output: std_logic_vector(7 downto 0);
	signal lowreg_output: std_logic_vector(7 downto 0);
	signal highreg_output: std_logic_vector(7 downto 0);
	signal data0_i: std_logic_vector(7 downto 0);
begin
	compare: process(data0_i, lowreg_output)
	begin 
		if data0_i = lowreg_output then
			equal <= '1';
		else 	
			equal <= '0';
		end if;
	end process compare;

	mux: process(sel, data1, highreg_output)
	begin 
		case sel is
			when '0' => 
				mux_output <= highreg_output;
			when '1' => 
				mux_output <= data1;
		
		end case;

	end process mux;

	registers: process (rst,clk)
	begin
		if ( rst = '1') then
			highreg_output <= "00000000";
			lowreg_output <= "00000000";
		elsif clk = '1' and clk'event then
			if ldpre = '1' then
				highreg_output <= data2;
			end if;
			if ldcomp = '1' then
				lowreg_output <= data2;
			end if;
		end if;
	end process registers;

	counter: process (rst,clk)
	begin
		if  rst = '1' then
			data0_i <= "00000000";
		elsif clk = '1' and clk'event then
			if equal = '1' then
				data0_i <= mux_output;
			elsif equal = '0' then
				data0_i  <= data0_i + "00000001";
			end if;
		end if;
	end process counter;
	data0 <= data0_i;
end behave;

library ieee;
use ieee.std_logic_1164.all;
entity prep2_2 is 
	port( 	CLK : in bit;
		RST : in bit;	
		SEL : in bit;
		LDCOMP : in bit;
		LDPRE : in bit;
		DATA1,DATA2   : in std_logic_vector(7 downto 0);
		DATA0   : out std_logic_vector(7 downto 0)
	    );
end prep2_2;

architecture behave of prep2_2 is
component prep2_1
	port( 	clk : in bit;
		rst : in bit;	
		sel : in bit;
		ldcomp : in bit;
		ldpre : in bit;
		data1,data2   : in std_logic_vector(7 downto 0);
		data0   : out std_logic_vector(7 downto 0)
	    );
end component;

signal data0_internal : std_logic_vector (7 downto 0);

begin

inst1: prep2_1 port map(
	clk => CLK, rst => RST,
	sel => SEL, ldcomp => LDCOMP, ldpre => LDPRE,
	data1 => DATA1, data2 => DATA2, data0 => data0_internal);
inst2: prep2_1 port map(
	clk => CLK, rst => RST,
	sel => SEL, ldcomp => LDCOMP, ldpre => LDPRE,
	data1 => data0_internal, data2 => DATA2, data0 => DATA0);
end behave;

