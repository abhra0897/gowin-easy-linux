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
-- PREP Benchmark Circuit #1 -Datapath circuit (1 instance)
--
-- Copyright (c) 1994-1996 Synplicity, Inc.
--
-- You may distribute freely, as long as this header remains attached.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
use std.textio.all;
use work.qatools.all;

ENTITY test_prep1 IS 

END test_prep1;

ARCHITECTURE behave of test_prep1 IS

        SIGNAL RST,CLK,S_L: std_logic;
        SIGNAL S: std_logic_VECTOR(1 DOWNTO 0);
        SIGNAL d0,d1,d2,d3: std_logic_VECTOR(7 DOWNTO 0);
        SIGNAL Q: std_logic_VECTOR(7 DOWNTO 0);

        CONSTANT numvecs: INTEGER := 20;
        TYPE cntlrom is array(0 to (numvecs - 1)) of std_logic_VECTOR(3 DOWNTO 0); -- RST,S_L,S inputs
        TYPE datarom is array(0 to (numvecs - 1)) of std_logic_VECTOR(31 DOWNTO 0); -- d0,d1,d2,d3 inputs
        TYPE outrom is array(0 to (numvecs - 1)) of std_logic_VECTOR(7 DOWNTO 0);  -- Q output

        SIGNAL loopindex: integer := 0;
        SIGNAL numerrors: integer := 0;

        COMPONENT prep1 
	   PORT (   
              CLK: IN std_logic;
              RST : IN std_logic;       
              S_L : IN std_logic;
              S : IN std_logic_VECTOR(1 DOWNTO 0);
              d0,d1,d2,d3   : IN std_logic_VECTOR(7 DOWNTO 0);
              Q   : OUT std_logic_VECTOR(7 DOWNTO 0)
           );
        END COMPONENT;  
                                                                                                         -- index
        CONSTANT cntl: cntlrom := -- RST,S_L, S(1:0)
         (
            "1000", "1000", "1000", "0001", "0010", -- 0-4 
            "0011", "0011", "0000", "0011", "0011", -- 5-9
            "0111", "0111", "0111", "0111", "0111", -- 10-14     
            "0111", "0111", "0111", "0111", "1111"  -- 15-19     
         );
        CONSTANT invec: datarom :=       -- d3,d2,d1,d0
         (      
            "00000000000000000000000000000000", -- 0 0
            "11111110000000010000000000000000", -- 1 0
            "00010001001000101010101011111111", -- 2 11_22_aa_ff
            "00010001001000101010101011111111", -- 3 11_22_aa_ff
            "00010001001000101010101011111111", -- 4 11_22_aa_ff
            "00010001001000101010101011111111", -- 5 11_22_aa_ff
            "11111111001000101010101011111111", -- 6 FF_22_aa_ff
            "00010001001000101010101000000001", -- 7 11_22_aa_01
            "00000001000100011010101011111111", -- 8 01_11_aa_ff
            "11111111001000101010101011111111", -- 9 xx_22_aa_ff
            "00010001001000101010101011111111", -- 10 11_22_aa_ff
            "00010001001000101010101011111111", -- 11 11_22_aa_ff
            "00010001001000101010101011111111", -- 12 11_22_aa_ff
            "00010001001000101010101011111111", -- 13 11_22_aa_ff
            "00010001001000101010101011111111", -- 14 11_22_aa_ff
            "00010001001000101010101011111111", -- 15 11_22_aa_ff
            "00010001001000101010101011111111",  -- 16 11_22_aa_ff
            "00010001001000101010101011111111",  -- 17 11_22_aa_ff
            "00010001001000101010101011111111",  -- 18 11_22_aa_ff
            "00010001001000101010101011111111"   -- 19 11_22_aa_ff
         );
        CONSTANT outvec: outrom := 
         (
           "UUUUUUUU", -- 0 Q=0x00 UNKNOWN
           "00000000", -- 1 Q=0x00 RST
           "00000000", -- 2 Q=0x00 
           "00000000", -- 3 Q=0x00 
           "10101010", -- 4 Q=0xAA invec(3)
           "00100010", -- 5  Q=0x22 invec(4)
           "00010001",  -- 6 Q=0x11 invec(5)
           "11111111",  -- 7 Q=0xFF invec(6)
           "00000001",  -- 8 Q=0x01 invec(7)
           "00000001",  -- 9 Q=0x01 invec(8) comes out
           "00000010",  -- 10 Q=0x02 rotate
           "00000100",  -- 11 Q=0x04 rotate
           "00001000",  -- 12 Q=0x08 rotate
           "00010000", -- 13 Q=0x10 rotate
           "00100000", -- 14 Q=0x20 rotate
           "01000000",  -- 15 Q=0x40 rotate
           "10000000",  -- 16 Q=0x80 rotate
           "00000001",  -- 17 Q=0x01 rotate
           "00000010",  -- 18 Q=0x02 rotate
           "00000000"   -- 19 Q=0x00 Reset all bits
         );
BEGIN
I1: prep1 port map ( 
                      CLK => CLK,
                      RST => RST,
                      S_L => S_L,
                      S => S,
                      d0 => d0,
                      d1 => d1,
                      d2 => d2,
                      d3 => d3,
                      Q => Q 
                   );
        toggleclk: PROCESS (CLK)
        VARIABLE l: LINE;
        BEGIN
                IF loopindex >= numvecs THEN
                                -- go to finish routine
                                qatestdone(numerrors);
                ELSE
                        IF CLK = '1' OR CLK = '0' THEN
                                CLK <= NOT CLK AFTER 10 ns;
                        ELSE 
                                CLK <= '0' AFTER 10 ns;
                        END IF;
                END IF;
        END PROCESS toggleclk;

        testjig: PROCESS  (CLK)
        BEGIN
                IF CLK = '0' THEN
                        IF Q /= outvec(loopindex) THEN
                                numerrors <= numerrors + 1;
                                -- display en error message
                        END IF;
                        loopindex <= loopindex + 1; -- scheduled, so bump in next assignments
                        IF (loopindex + 1) < numvecs THEN
                                RST <= cntl(loopindex + 1)(3);
                                S_L <= cntl(loopindex + 1)(2);
                                S <= cntl(loopindex + 1)(1 DOWNTO 0);
                                d3 <= invec(loopindex + 1)(31 DOWNTO 24);
                                d2 <= invec(loopindex + 1)(23 DOWNTO 16);
                                d1 <= invec(loopindex + 1)(15 DOWNTO 8);
                                d0 <= invec(loopindex + 1)(7 DOWNTO 0);
                        END IF;
                ELSIF CLK = '1' THEN
                ELSE
                        -- CLK is unknown
                END IF;
        END PROCESS testjig;
END behave;

CONFIGURATION behave_test_prep1 OF test_prep1 IS
        FOR behave
                FOR I1: prep1 USE ENTITY work.prep1(behave);
                END FOR;
        END FOR;
END behave_test_prep1;

