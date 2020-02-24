--------------------------------------------------------------------------------
--
--   AM2901 Benchmark
--
-- Source: AMD data book
--
-- VHDL Benchmark author Indraneel Ghosh
--                       University Of California, Irvine, CA 92717
--
-- Developed on Jan 1, 1992
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes  Champaka Ramachandran  Sept19, 92      ZYCAD
--  Functionality     yes  Champaka Ramachandran  Sept19, 92      ZYCAD
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- obtained from the '92 High-Level Synthesis benchmarks
-- slight alterations made by Sari Coumeri
-- January 1994
--------------------------------------------------------------------------------
-- additional modifications to use IEEE 1164 packages
-- internal tristate drivers moved to output pads.
-- Synplicity, Inc. July 1995
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
package TYPES is
	subtype Word is std_logic_vector(3 downto 0);
	type Memory is array(integer RANGE <>) of Word;
	subtype clock is std_logic;
end package TYPES;
use work.TYPES.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity a2901 is 
	port (
		I : in std_logic_vector(8 downto 0);
		Aadd, Badd : in integer range 0 to 15; 
		D :  in std_logic_vector(3 downto 0);
		Y : out std_logic_vector(3 downto 0);
		RAM0, RAM3, Q0, Q3 : inout std_logic;  
		CLK : in clock;  
		C0 : in std_logic;  
		OEbar : in std_logic;
		C4, Gbar, Pbar, OVR, F3, F30 : out std_logic
               );
end a2901;

architecture a2901 of a2901 is 
	-- For pad based tristates
	signal	RAM0z,RAM3z,Q0z,Q3z:  std_logic;
	signal  RAM0e,RAM3e,Q0e,Q3e:  std_logic;
	signal  Yz:  std_logic_vector(3 downto 0);
begin

	process
		variable A, B : std_logic_vector(3 downto 0); 
		variable RAM : Memory(15 downto 0); 
		variable RAM_DATA : Word;
		variable RAM_EN : std_logic;
		variable Q : std_logic_vector(3 downto 0); 
		variable RE, S : std_logic_vector(3 downto 0);
		variable F : std_logic_vector(3 downto 0); 
		variable dout : std_logic_vector(3 downto 0); 
		variable R_ext,S_ext,result : std_logic_vector(4 downto 0);
		variable temp_p, temp_g : std_logic_vector(3 downto 0) ; 
	begin
		wait until rising_edge(clk);

		A := RAM(Aadd);  -- RAM OUTPUTS ( ADDRESSED BY Aadd AND Badd ) ARE 
		B := RAM(Badd);  --  MADE AVAILABLE TO ALU SOURCE SELECTOR

-- SELECT THE SOURCE OPERANDS FOR ALU. SELECTED OPERANDS ARE "RE" AND "S".

		case I(2 downto 0) is
			when "000" =>
				RE := A;
				S := Q;
			when "001" =>
				RE := A;
				S := B;
			when "010" =>
				RE := "0000";
				S := Q;
			when "011" => 
				RE := "0000";
				S := B;
			when "100" =>
				RE := "0000";
				S := A;
			when "101" =>
				RE := D;
				S := A;
			when "110" =>
				RE := D;
				S := Q;
			when "111" => 
				RE := D;
				S := "0000";
			when others =>
				RE := "XXXX";
				S := "XXXX";
		end case;

-- SELECT THE FUNCTION FOR ALU.

--   TO FACILITATE COMPUTATION OF CARRY-OUT "C4", WE EXTEND THE CHOSEN 
--   ALU OPERANDS "RE" AND "S" (4 BIT OPERANDS) BY 1 BIT IN THE MSB POSITION. 

--   THUS THE EXTENDED OPERANDS "R_EXT" AND "S_EXT" (5 BIT OPERANDS) ARE
--   FORMED AND ARE USED IN THE ALU OPERATION. THE EXTRA BIT IS SET TO '0' 
--   INITIALLY. THE ALU'S EXTENDED OUTPUT ( 5 BITS LONG) IS "result".

--   IN THE ADD/SUBTRACT OPERATIONS, THE CARRY-INPUT "C0" (1 BIT) IS EXTENDED
--   BY 4 BITS ( ALL '0') IN THE MORE SIGNIFICANT BITS TO MATCH ITS LENGTH TO
--   THAT OF "R_ext" AND "S_ext". THEN, THESE THREE OPERANDS ARE ADDED.

--   ADD/SUBTRACT OPERATIONS ARE DONE ON 2'S COMPLEMENT OPERANDS.

		case I(5 downto 3) is 
			when "000" =>
				R_ext := '0' & RE;
				S_ext := '0' & S;
				result := R_ext + S_ext + ("0000" & C0);
			when "001" =>
				R_ext := '0' & not(RE);
				S_ext := '0' & S;                  
				result := R_ext + S_ext + ("0000" & C0);
			when "010" =>
				R_ext := '0' & RE;
				S_ext := '0' & not(S);
				result := R_ext + S_ext + ("0000" & C0);
			when "011" =>            
				R_ext := '0' & RE;
				S_ext := '0' & S;
				result := R_ext or S_ext;
			when "100" => 
				R_ext := '0' & RE;
				S_ext := '0' & S;
				result := R_ext and S_ext;
			when "101" => 
				R_ext := '0' & RE;
				S_ext := '0' & S;
				result := not(R_ext) and S_ext;
			when "110" =>
				R_ext := '0' & RE;
				S_ext := '0' & S;
				result := R_ext xor S_ext;
			when "111" => 
				R_ext := '0' & RE;
				S_ext := '0' & S;
				result := not(R_ext xor S_ext);
			when others =>
				R_ext := (others => 'X');
				S_ext := (others => 'X');
				result := (others => 'X');
		end case;


-- EVALUATE OTHER ALU OUTPUTS.

--  FROM EXTENDED OUTPUT "result" ( 5 BITS), WE OBTAIN THE NORMAL ALU OUTPUT,
--  "F" (4 BITS) BY LEAVING OUT THE MSB ( WHICH CORRESPONDS TO CARRY-OUT
--  "C4"). 

--  TO FACILITATE COMPUTATION OF CARRY LOOKAHEAD TERMS "Pbar" AND "Gbar", WE
--  COMPUTE INTERMEDIATE TERMS "temp_p" AND "temp_g".

		C4 <= result(4) ;                                            
		OVR <= not (R_ext(3) xor S_ext(3)) and 
			(R_ext(3) xor result(3));
		F := result(3 downto 0) ;
		temp_p := R_ext(3 downto 0) or S_ext(3 downto 0);
		temp_g := R_ext(3 downto 0) and S_ext(3 downto 0);
		Pbar <= not( temp_p(0) and temp_p(1) and 
			temp_p(2) and temp_p(3));
		Gbar <= not(  temp_g(3) or 
			(temp_p(3) and temp_g(2) ) or 
			(temp_p(3) and temp_p(2) and temp_g(1) ) or
			(temp_p(3) and temp_p(2) and temp_p(1) and temp_g(0)));
		F3 <= result(3) ;
		F30 <= not( result(3) or result(2) or result(1) or result(0));


-- GENERATE INTERMEDIATE OUTPUT "dout" AND BIDIRECTIONAL SHIFTER SIGNALS.

-- WRITE TO DESTINATION(S) WITH/WITHOUT SHIFTING. RAM DESTINATIONS ARE 
-- ADDRESSED BY "Badd".
		Q0e <= '0';
		Q3e <= '0';
		RAM0e <= '0';
		RAM3e <= '0';
		RAM0z <= 'X';
		RAM3z <= 'X';
		RAM_DATA := (others => 'X');
		RAM_EN := '1';
		dout := (others => 'X');
		case I(8 downto 6) is 
			when "000" =>
				RAM_EN := '0';
				dout := F;           -- INTERMEDIATE OUTPUT
				Q := F;              -- WRITE TO DESTINATION
			when "001" =>
				RAM_EN := '0';
				dout := F;
			when "010" =>
				dout := A;
				RAM_DATA := F;
			when "011" =>
				dout := F;
				RAM_DATA := F;
			when "100" =>
				dout := F;
				RAM_DATA := RAM3 & F(3 downto 1);
				Q := Q3 & Q(3 downto 1);
				RAM0z <= F(0) ;       -- SHIFTER SIGNALS
				RAM0e <= '1';
				Q0z <= Q(0) ;
				Q0e <= '1';
			when "101" => 
				dout := F;
				RAM_DATA := RAM3 & F(3 downto 1);
				RAM0z <= F(0) ;
				RAM0e <= '1';
			when "110" => 
				dout := F;
				RAM_DATA := F(2 downto 0) & RAM0;
				Q := Q(2 downto 0) & Q0;
				RAM3z <= F(3) ;
				RAM3e <= '1';
				Q3z <= Q(3) ;
				Q3e <= '1';
			when "111" => 
				dout := F;
				RAM_DATA := F(2 downto 0) & RAM0;
				RAM3z <= F(3) ;
				RAM3e <= '1';
			when others =>
		end case;
		if(RAM_EN = '1') then
			RAM(Badd) := RAM_DATA;
		end if;
	end process;

	-- tristate drivers
	Y 	 <= Yz    when OEbar = '0' else "ZZZZ";
	RAM0 <= RAM0z when RAM0e = '1' else 'Z';
	RAM3 <= RAM3z when RAM3e = '1' else 'Z';
	Q0   <= Q0z   when Q0e   = '1' else 'Z';
	Q3   <= Q3z   when Q3e   = '1' else 'Z';

end a2901;






