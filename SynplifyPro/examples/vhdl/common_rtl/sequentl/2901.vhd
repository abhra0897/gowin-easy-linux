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
-- Synplicity change history
-- std_logic -> std_ulogic
-- put parens to bind 3 input adds.
--------------------------------------------------------------------------------
--use work.TYPES.all;
--use work.MVL4_functions.all;    -- some MVL4 functions
--use work.synthesis_types.all;   -- some data types ( hints for synthesis)
library ieee;
use ieee.std_logic_1164.all;
package SYNTHESIS_TYPES is

subtype clock is std_logic;
subtype memword is std_logic_vector(3 downto 0);
--type Memory is array (integer range <>) of std_logic_vector(3 downto 0);

end SYNTHESIS_TYPES;
----use work.MVL4_functions.all;  -- some MVL4 functions
--use work.types.all;  -- some std_logic functions
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.synthesis_types.all; -- some data types ( hints for synthesis)

entity a2901 is 
        port (  
                I : in std_logic_vector(8 downto 0);
                Aadd, Badd : in integer range 0 to 15; 
                D :  in std_logic_vector(3 downto 0);
                Y : out std_logic_vector(3 downto 0);
                RAM0, RAM3, Q0, Q3 : inout std_ulogic;  
                CLK : in clock;  
                C0 : in std_ulogic;  
                OEbar : in std_ulogic;
                C4, Gbar, Pbar, OVR, F3, F30 : out std_ulogic
               );
end a2901;

architecture a2901 of a2901 is 
        shared variable RAM_DATA: std_logic_vector(3 downto 0);
--- Memory models till 2D arrays are fully supported.
        signal MEMARR0,MEMARR1,MEMARR2,MEMARR3:      memword;
        signal MEMARR4,MEMARR5,MEMARR6,MEMARR7:      memword;
        signal MEMARR8,MEMARR9,MEMARR10,MEMARR11:    memword;
        signal MEMARR12,MEMARR13,MEMARR14,MEMARR15:  memword;
        signal RAM0_i, RAM3_i, Q0_i, Q3_i : std_ulogic;  
        signal Y_i : std_logic_vector(3 downto 0);
        impure function RAM
                (signal addr :in integer range 15 downto 0)
                   RETURN memword is
        variable data: memword;
        begin   
                case addr is
                        when 0  =>
                                data := MEMARR0;
                        when 1 =>
                                data := MEMARR1;
                        when 2 =>
                                data := MEMARR2;
                        when 3 =>
                                data := MEMARR3;
                        when 4 =>
                                data := MEMARR4;
                        when 5 =>
                                data := MEMARR5;
                        when 6 =>
                                data := MEMARR6;
                        when 7 =>
                                data := MEMARR7;
                        when 8 =>
                                data := MEMARR8;
                        when 9 =>               
                                data := MEMARR9;
                        when 10 =>
                                data := MEMARR10;
                        when 11 =>
                                data := MEMARR11;
                        when 12 => 
                                data := MEMARR12;
                        when 13 =>      
                                data := MEMARR13;
                        when 14 =>
                                data := MEMARR14;
                        when 15 =>      
                                data := MEMARR15;
                        when others =>
                                data := "XXXX";
                end case;
                return data;
        end ram;
begin

        process

                variable A, B : std_logic_vector(3 downto 0); 
--              variable RAM : Memory(15 downto 0); 
                variable Q : std_logic_vector(3 downto 0); 
      variable RE, S : std_logic_vector(3 downto 0);
                variable F : std_logic_vector(3 downto 0); 
                variable dout : std_logic_vector(3 downto 0); 
      variable R_ext,S_ext,result : std_logic_vector(4 downto 0);
      variable temp_p, temp_g : std_logic_vector(3 downto 0) ; 
                
        begin

      wait until ( (clk = '0') and (not clk'stable) );

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
                        result := (R_ext + S_ext) + ("0000" & C0);
           when "001" =>
                        R_ext := '0' & not(RE);
                        S_ext := '0' & S;                  
                        result := (R_ext + S_ext) + ("0000" & C0);
           when "010" =>
                        R_ext := '0' & RE;
                        S_ext := '0' & not(S);
                        result := (R_ext + S_ext) + ("0000" & C0);
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
        end case;


-- EVALUATE OTHER ALU OUTPUTS.

--  FROM EXTENDED OUTPUT "result" ( 5 BITS), WE OBTAIN THE NORMAL ALU OUTPUT,
--  "F" (4 BITS) BY LEAVING OUT THE MSB ( WHICH CORRESPONDS TO CARRY-OUT
--  "C4"). 

--  TO FACILITATE COMPUTATION OF CARRY LOOKAHEAD TERMS "Pbar" AND "Gbar", WE
--  COMPUTE INTERMEDIATE TERMS "temp_p" AND "temp_g".

        C4 <= result(4) ;                                            
        OVR <= not (R_ext(3) xor S_ext(3)) and
                              (R_ext(3) xor result(3)) ;
        F := result(3 downto 0) ;
        temp_p := R_ext(3 downto 0) or S_ext(3 downto 0);
        temp_g := R_ext(3 downto 0) and S_ext(3 downto 0);
        Pbar <= not( temp_p(0) and temp_p(1) and temp_p(2) and temp_p(3) ) ;
        Gbar <= not(  temp_g(3) or 
                     ( temp_p(3) and temp_g(2) ) or 
                     (temp_p(3) and temp_p(2) and temp_g(1) ) or
                     (temp_p(3) and temp_p(2) and temp_p(1) and temp_g(0) ) 
                   );
        F3 <= result(3) ;
        F30 <= not( result(3) or result(2) or result(1) or result(0) ) ;


-- GENERATE INTERMEDIATE OUTPUT "dout" AND BIDIRECTIONAL SHIFTER SIGNALS.

-- WRITE TO DESTINATION(S) WITH/WITHOUT SHIFTING. RAM DESTINATIONS ARE 
-- ADDRESSED BY "Badd".

        case I(8 downto 6) is 
           when "000" =>
                        dout := F;           -- INTERMEDIATE OUTPUT
                        Q := F;              -- WRITE TO DESTINATION
           when "001" =>
                        dout := F;
           when "010" =>
                        dout := A;
			--RAM(Badd) := F;
			RAM_DATA := F;
           when "011" =>
                        dout := F;
			--RAM(Badd) := F;
			RAM_DATA := F;
           when "100" =>
                        dout := F;
			--RAM(Badd) := RAM3 & F(3 downto 1);
			RAM_DATA := RAM3 & F(3 downto 1);
			Q := Q3 & Q(3 downto 1);
			RAM0_i <= F(0) ;       -- SHIFTER SIGNALS
			Q0_i <= Q(0) ;
           when "101" => 
                        dout := F;
			--RAM(Badd) := RAM3 & F(3 downto 1);
			RAM_DATA := RAM3 & F(3 downto 1);
			RAM0_i <= F(0) ;
           when "110" => 
                        dout := F;
			--RAM(Badd) := F(2 downto 0) & RAM0;
			RAM_DATA := F(2 downto 0) & RAM0;
			Q := Q(2 downto 0) & Q0;
			RAM3_i <= F(3) ;
			Q3_i <= Q(3) ;
           when "111" => 
                        dout := F;
			--RAM(Badd) := F(2 downto 0) & RAM0;
			RAM_DATA := F(2 downto 0) & RAM0;
			RAM3_i <= F(3) ;
           when others =>
			null;
        end case;
        if i(8 downto 7) /= "00" then
                case Badd is
                        when 0  =>
                                 MEMARR0<=RAM_DATA;
                        when 1 =>
                                 MEMARR1<=RAM_DATA;
                        when 2 =>
                                 MEMARR2<=RAM_DATA;
                        when 3 =>
                                 MEMARR3<=RAM_DATA;
                        when 4 =>
                                 MEMARR4<=RAM_DATA;
                        when 5 =>
                                 MEMARR5<=RAM_DATA;
                        when 6 =>
                                 MEMARR6<=RAM_DATA;
                        when 7 =>
                                 MEMARR7<=RAM_DATA;
                        when 8 =>
                                 MEMARR8<=RAM_DATA;
                        when 9 =>               
                                 MEMARR9<=RAM_DATA;
                        when 10 =>
                                 MEMARR10<=RAM_DATA;
                        when 11 =>
                                 MEMARR11<=RAM_DATA;
                        when 12 => 
                                MEMARR12<=RAM_DATA;
                        when 13 =>      
                                 MEMARR13<=RAM_DATA;
                        when 14 =>
                                MEMARR14<=RAM_DATA;
                        when 15 =>      
                                MEMARR15<=RAM_DATA;
                        when others =>
                                NULL ;
                end case;
   end if;

-- GENERATE DATA OUTPUT "Y" FROM INTERMEDIATE OUTPUT "dout".
   Y_i <= dout;
  end process;
  Y  <= Y_i when OEbar = '0' else "ZZZZ";
  Q0 <= Q0_i when i(8 downto 6) = "100" else 'Z';
  Q3 <= Q3_i when i(8 downto 6) = "110" else 'Z';
  RAM3 <= RAM3_i when i(8 downto 7) = "11" else 'Z';
  RAM0 <= RAM0_i when i(8 downto 7) = "10" else 'Z';
end a2901;







