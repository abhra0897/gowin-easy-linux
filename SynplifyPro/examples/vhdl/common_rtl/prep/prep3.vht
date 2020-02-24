-- Copyright (c) 1994-1996 Synplicity, Inc.
-- You may distribute freely as long as this header
-- remains attached.
-- --------------------------------------------------------------------
--
--   Title     :  Synplicity QA routines
--             :  
--   Developers:  Andrew Dauman
--   Purpose   :  This packages defines a set of routines for QA developers
--             :  to use in IO and error detection of VHDL test jigs.
--             : 
-- --------------------------------------------------------------------
--   modification history :
-- --------------------------------------------------------------------
--  version | mod. date:| 
--   v1.000 | 01/08/95  | 
-- --------------------------------------------------------------------
USE std.standard.all; 
USE std.textio.all; 
LIBRARY IEEE; 
USE ieee.std_logic_1164.all;

PACKAGE qatools IS
    type stdlogic_to_char_t is array(std_logic) of character;
        
    PROCEDURE qatestdone (numerrors: IN INTEGER);
    PROCEDURE qafail (expected,actual: IN std_logic; what:IN string);
    PROCEDURE qafail (expected,actual: IN std_logic_vector; what:IN string);
    FUNCTION to_string(inp : std_logic_vector) return string;
END qatools;

PACKAGE BODY qatools IS
    PROCEDURE qatestdone (numerrors: IN INTEGER) IS
      VARIABLE l: LINE;
    BEGIN
      IF (numerrors = 0) THEN
            WRITE(l,string'("End of Good Simulation!"));
      ELSE 
            WRITE(l,string'("Error: Simulation failed with "));
            WRITE(l,numerrors);
            WRITE(l,string'(" errors."));
      END IF;
      WRITELINE(OUTPUT,l);
    END qatestdone;


    constant to_char : stdlogic_to_char_t := (
                'U' => 'U',
                'X' => 'X',
                '0' => '0',
                '1' => '1',
                'Z' => 'Z',
                'W' => 'W',
                'L' => 'L',
                'H' => 'H',
                '-' => '-');

    --
    -- convert a std_logic_vector to a string
    --
    function to_string(inp : std_logic_vector)
        return string is
        alias vec : std_logic_vector(1 to inp'length) is inp;
        variable result : string(vec'range);
    begin
        for i in vec'range loop
            result(i) := to_char(vec(i));
        end loop;
        return result;
    end;

    PROCEDURE qafail (expected,actual: IN std_logic; what : IN string ) IS
    BEGIN
      assert false
         report "Failure for " & what & ",Expected: " & to_char(expected)
            & " Actual: " & to_char(actual)
         severity error;
    END qafail;

    PROCEDURE qafail 
           (expected,actual: IN std_logic_vector; 
             what:IN string) IS
    BEGIN
      assert false
         report "Failure for " & what & ",Expected: " & to_string(expected)
            & " Actual: " & to_string(actual)
         severity error;
    END qafail;

END qatools;
----------------------------------------------------------------------
-- Test Jig for:
-- PREP Benchmark Circuit #3 -Small State Machine circuit (1 instance)
--
-- Copyright (c) 1994-1996 Synplicity, Inc.
--
-- You may distribute freely, as long as this header remains attached.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.qatools.all;

ENTITY test_prep3 IS 

END test_prep3;

ARCHITECTURE behave of test_prep3 IS

 function bitwise_neq(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR)
  return BOOLEAN is
  variable result : BOOLEAN;
  begin
      result := FALSE;
        for i in L'range loop
       NEXT WHEN  L(i) = '-' or R(i) = '-' ; -- compare is a don't care
            if L(i) /= R(i) then
                result := TRUE;
            end if;
           end loop;

      return result;
  end;

 function "/="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) 
 return BOOLEAN is
        constant length: INTEGER := (L'length);
    begin
           return (bitwise_neq(  L , R ));
    end;

        SIGNAL RST,CLK: std_logic;
        SIGNAL INN: std_logic_vector(7 DOWNTO 0);
        SIGNAL OUTT: std_logic_vector(7 DOWNTO 0);

        CONSTANT numvecs: INTEGER := 21;
        TYPE cntlrom is array(0 to (numvecs - 1)) of std_logic; -- RST inputs
        TYPE datarom is array(0 to (numvecs - 1)) of std_logic_vector(7 DOWNTO 0); -- A,B inputs
        TYPE outrom is array(0 to (numvecs - 1)) of std_logic_vector(7 DOWNTO 0);  -- Q output

        SIGNAL numerrors: integer := 0;
        SIGNAL loopindex: integer := 0;

        COMPONENT prep3 
                PORT(   
                       CLK : IN std_logic;
                       RST : IN std_logic;      
                       INN   : IN std_logic_vector(7 DOWNTO 0);
                       OUTT   : OUT std_logic_vector(7 DOWNTO 0)
                );
        END COMPONENT;  
                                                                                                         -- index
        CONSTANT cntl: cntlrom := -- RST
        (
           '1', '1', '0', '0', '0', -- 0-4 
           '0', '0', '0', '0', '0', -- 5-9
           '0', '0', '0', '0', '0', -- 10-14     
           '0', '0', '0', '0', '0', -- 16-19
           '0'                      -- 20
        );
        CONSTANT invec: datarom := 
        (       
           "00000000", -- 0 I=0
           "00000000", -- 1 I=0 RESET
           "00111010", -- 2 I=0x3A
           "10100001", -- 3 I=0xA1 
           "00111100", -- 4 I=0x3C
           "10101011", -- 5 I=0xAB
           "00011111", -- 6 I=0x1F
           "10101010",  -- 7 I=0xAA
           "00010001",  -- 8 I=0x11
           "00111100",  -- 9 I=0x3C
           "00011111",  -- 10 I=0x1F
           "00010010",  -- 11 I=0x12
           "00110100",  -- 12 I=0x34
           "10001000",  -- 13 I=0x88
           "00111100",  -- 14 I=0x3C
           "00101010",  -- 15 I=0x2A
           "01010101",  -- 16 I=0x55
           "01100110",  -- 17 I=0x66
           "01110111",  -- 18 I=0x77
           "00111011",  -- 19 I=0x3B
           "00111100"   -- 20 I=0x3C
        );
        CONSTANT outvec: outrom := 
        (
           "UUUUUUUU", -- 0 OUT=0x00 UNKOWN
           "00000000", -- 1 OUT=0x00 RST
           "00000000", -- 2 OUT=0x00 START->START
           "00000000", -- 3 OUT=0x00 START->START
           "10000010", -- 4 OUT=0x82 START->SA
           "00000100", -- 5  OUT=0x04 SA->SA
           "00100000",  -- 6 OUT=0x20 SA->SB
           "00010001",  -- 7 OUT=0x11 SB->SE
           "01000000",  -- 8 OUT=0x40 SE->START
           "10000010",  -- 9 OUT=0x82 START->SA
           "00100000",  -- 10 OUT=0x20 SA->SB
           "00110000",  -- 11 OUT=0x30 SB->SF
           "00000010",  -- 12 OUT=0x02 SF->SG
           "00000001",  -- 13 OUT=0x01 SG->START
           "10000010",  -- 14 OUT=0x82 START->SA
           "01000000",  -- 15 OUT=0x40 SA->SC
           "00001000",  -- 16 OUT=0x08 SC->SD
           "10000000",  -- 17 OUT=0x80 SD->SG
           "00000001",  -- 18 OUT=0x01 SG->START
           "00000000",  -- 19 OUT=0x00 START->START
           "10000010"  -- 20 OUT=0x82 START->SA
        );
BEGIN
I1: prep3 port map (
                      CLK => CLK,
                      RST => RST,
                      INN => INN, 
                      OUTT => OUTT
          );
        toggleclk: PROCESS (CLK)
        BEGIN
                IF loopindex >= numvecs THEN
                        qatestdone(numerrors);
                ELSE
                        IF CLK = '1' OR CLK = '0' THEN
                                CLK <= NOT CLK AFTER 10 ns;
                        ELSE 
                                CLK <= '0' AFTER 10 ns;
                        END IF;
                END IF;
        END PROCESS toggleclk;

        testjig: PROCESS (CLK)
        BEGIN
                IF CLK = '0' THEN
                        IF OUTT /= outvec(loopindex) THEN
                                numerrors <= numerrors + 1;
                                -- display en error message
                        END IF;
                        loopindex <= loopindex + 1;
                        IF (loopindex + 1 < numvecs) THEN
                                RST <= cntl(loopindex + 1);
                                INN <= invec(loopindex + 1);
                        END IF;
                END IF;
        END PROCESS testjig;
END behave;

CONFIGURATION behave_test_prep3 OF test_prep3 IS
        FOR behave
                FOR I1: prep3 USE ENTITY work.prep3(behave);
                END FOR;
        END FOR;
END behave_test_prep3;

