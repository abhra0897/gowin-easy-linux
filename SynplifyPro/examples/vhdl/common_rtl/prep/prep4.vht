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
-- PREP Benchmark Circuit #4 -Large State Machine circuit (1 instance)
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
use work.qatools.all;

ENTITY test_prep4 IS 

END test_prep4;

ARCHITECTURE behave of test_prep4 IS

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
        SIGNAL I: std_logic_vector(7 DOWNTO 0);
        SIGNAL O: std_logic_vector(7 DOWNTO 0);
        SIGNAL numerrors: integer := 0;
        SIGNAL loopindex: integer := 0;

        CONSTANT numvecs: INTEGER := 16;
        TYPE cntlrom is array(0 to (numvecs - 1)) of std_logic; -- RST inputs
        TYPE datarom is array(0 to (numvecs - 1)) of std_logic_vector(7 DOWNTO 0); -- A,B inputs
        TYPE outrom is array(0 to (numvecs - 1)) of std_logic_vector(7 DOWNTO 0);  -- Q output
        CONSTANT st0_outs: std_logic_vector(7 DOWNTO 0) := "00000000";
        CONSTANT st1_outs: std_logic_vector(7 DOWNTO 0) := "00000110";
        CONSTANT st2_outs: std_logic_vector(7 DOWNTO 0) := "00011000";
        CONSTANT st3_outs: std_logic_vector(7 DOWNTO 0) := "01100000";
        CONSTANT st4_outs: std_logic_vector(7 DOWNTO 0) := "1------0";
        CONSTANT st5_outs: std_logic_vector(7 DOWNTO 0) := "-1----0-";
        CONSTANT st6_outs: std_logic_vector(7 DOWNTO 0) := "00011111";
        CONSTANT st7_outs: std_logic_vector(7 DOWNTO 0) := "00111111";
        CONSTANT st8_outs: std_logic_vector(7 DOWNTO 0) := "01111111";
        CONSTANT st9_outs: std_logic_vector(7 DOWNTO 0) := "11111111";
        CONSTANT st10_outs: std_logic_vector(7 DOWNTO 0) := "-1-1-1-1";
        CONSTANT st11_outs: std_logic_vector(7 DOWNTO 0) := "1-1-1-1-";
        CONSTANT st12_outs: std_logic_vector(7 DOWNTO 0) := "11111101";
        CONSTANT st13_outs: std_logic_vector(7 DOWNTO 0) := "11110111";
        CONSTANT st14_outs: std_logic_vector(7 DOWNTO 0) := "11011111";
        CONSTANT st15_outs: std_logic_vector(7 DOWNTO 0) := "01111111";


        COMPONENT prep4 
                PORT(   
                       CLK : IN std_logic;
                       RST : IN std_logic;      
                       I   : IN std_logic_vector(7 DOWNTO 0);
                       O   : OUT std_logic_vector(7 DOWNTO 0)
                );
        END COMPONENT;  
                                                                                                         -- index
        CONSTANT cntl: cntlrom := -- RST
        (
           '1', '1', '0', '0', '0', -- 0-4 
           '0', '0', '0', '0', '0', -- 5-9
           '0', '0', '0', '0', '0', -- 10-14     
           '0'                      -- 16
        );
       CONSTANT invec: datarom := 
       (
          "00000000", -- 0 I=0
          "00000000", -- 1 I=0
          "00000000", -- 2 I=0
          "00000001", -- 3 I=1
          "00000011", -- 4 I=0x03
          "00000100", -- 5 I=0x04
          "00011111", -- 6 I=0x1F
          "10101010",  -- 7 I=0xAA
          "01010100",  -- 8 I=0x54
          "00000001",  -- 9 I=0xAA
          "11000000",  -- 10 I=0xC0
          "11101010",  -- 11 I=0xDA
          "10001011",  -- 12 I=0x8B
          "00000001",  -- 13 I=0x01
          "01000000",  -- 14 I=0x40
          "10111111"  -- 15 I=0xBF
        );
        CONSTANT outvec: outrom := 
        (
           "XXXXXXXX", -- 0 O=UNKOWN
           st0_outs, -- 1 O=0 RST
           st0_outs, -- 2 O=
           st1_outs, -- 3 O=
           st0_outs, -- 4 O=
           st2_outs, -- 5 O=
           st3_outs,  -- 6 O=
           st5_outs,  -- 7 O=
           st5_outs,  -- 8 O=
           st7_outs,  -- 9 O=
           st4_outs,  -- 10 O=
           st6_outs,  -- 11 O=
           st9_outs,  -- 12 O=
           st11_outs,  -- 13 O=
           st15_outs,  -- 14 O=
           st0_outs  -- 15 O=
        );
BEGIN
I1: prep4 port map (
                      CLK => CLK,
                      RST => RST,
                      I => I, 
                      O => O
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
                        IF O /= outvec(loopindex) THEN
                                numerrors <= numerrors + 1;
                                -- display en error message
                                qafail(outvec(loopindex), O, "O");
                        END IF;
                        loopindex <= loopindex + 1;
                        IF loopindex + 1 < numvecs THEN
                                RST <= cntl(loopindex + 1);
                                I <= invec(loopindex + 1);
                        END IF;
                ELSIF CLK = '1' THEN
                ELSE
                        -- CLK is unknown
                END IF;
        END PROCESS testjig;
END behave;

CONFIGURATION behave_test_prep4 OF test_prep4 IS
        FOR behave
                FOR I1: prep4 USE ENTITY work.prep4(behave);
                END FOR;
        END FOR;
END behave_test_prep4;

