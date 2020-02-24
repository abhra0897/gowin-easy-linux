--
-- Primitive library for post synthesis simulation
--
library ieee;
use ieee.std_logic_1164.all;
entity prim_counter is
	generic (w : integer := 8);
	port (
		q : out std_logic_vector(w - 1 downto 0);
		cout : out std_logic;
		d : in std_logic_vector(w - 1 downto 0);
		cin : in std_logic;
		clk : in std_logic;
		rst : in std_logic;
		load : in std_logic;
		en : in std_logic;
		updn : in std_logic
	);
end prim_counter;

architecture beh of prim_counter is
	signal nextq : std_logic_vector(w - 1 downto 0);
	signal qreg : std_logic_vector(w - 1 downto 0);
begin
	nxt: process (qreg, cin, updn)
		variable i : integer;
		variable nextc, c : std_logic;
	begin
		nextc := cin;
		for i in 0 to w - 1 loop
			c := nextc;
			nextq(i) <= c xor (not updn) xor qreg(i);
			nextc := (c and (not updn)) or 
				 (c and qreg(i)) or
				 ((not updn) and qreg(i));
		end loop;
		cout <= nextc;
	end process;

	ff : process (clk, rst)
	begin
		if rst = '1' then
			qreg <= (others => '0');
		elsif rising_edge(clk) then
			if load = '1' then
				qreg <= d;
			elsif en = '1' then
				qreg <= nextq;
			end if;
		end if;
	end process ff;
	q <= qreg;
end beh;

library ieee;
use ieee.std_logic_1164.all;
entity prim_dff is
	port (q : out std_logic;
	      d : in std_logic;
	      clk : in std_logic;
	      r : in std_logic := '0';
	      s : in std_logic := '0');
end prim_dff;

architecture beh of prim_dff is
begin
	ff : process (clk, r, s)
	begin
		if r = '1' then
			q <= '0';
		elsif s = '1' then
			q <= '1';
		elsif rising_edge(clk) then
			q <= d;
		end if;
	end process ff;
end beh;

library ieee;
use ieee.std_logic_1164.all;
entity prim_latch is
	port (q : out std_logic;
	      d : in std_logic;
	      clk : in std_logic;
	      r : in std_logic := '0';
	      s : in std_logic := '0');
end prim_latch;

architecture beh of prim_latch is
begin
	q <= '0' when r = '1' else
	     '1' when s = '1' else
	     d when clk = '1';
end beh;

library ieee;
use ieee.std_logic_1164.all;
package components is
	component prim_counter
		generic (w : integer);
		port (
			q : out std_logic_vector(w - 1 downto 0);
			cout : out std_logic;
			d : in std_logic_vector(w - 1 downto 0);
			cin : in std_logic;
			clk : in std_logic;
			rst : in std_logic;
			load : in std_logic;
			en : in std_logic;
			updn : in std_logic
		);
	end component;
	component prim_dff
		port (q : out std_logic;
		      d : in std_logic;
		      clk : in std_logic;
		      r : in std_logic := '0';
		      s : in std_logic := '0');
	end component;
	component prim_latch
		port (q : out std_logic;
		      d : in std_logic;
		      clk : in std_logic;
		      r : in std_logic := '0';
		      s : in std_logic := '0');
	end component;
end components;
