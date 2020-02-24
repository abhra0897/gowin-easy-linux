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
-- PREP Benchmark Circuit #8 - Counter (1 instance)
--
-- Copyright (c) 1994-1996 Synplicity, Inc.
--
-- You may distribute freely, as long as this header remains attached.
--
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.qatools.all;

ENTITY test_prep8 IS 

END test_prep8;

ARCHITECTURE behave of test_prep8 IS
        SIGNAL RST,CLK,LD,CE: std_logic;
        SIGNAL D: std_logic_vector(15 DOWNTO 0);
        SIGNAL Q: std_logic_vector(15 DOWNTO 0);
        SIGNAL numerrors: integer := 0;
        SIGNAL loopindex: integer := 0;

        CONSTANT numvecs: INTEGER := 32;
        TYPE cntlrom is array(0 to (numvecs - 1)) of std_logic_vector(2 DOWNTO 0); -- RST,CE,LD inputs
        TYPE datarom is array(0 to (numvecs - 1)) of std_logic_vector(15 DOWNTO 0); -- D input
        TYPE outrom is array(0 to (numvecs - 1)) of std_logic_vector(15 DOWNTO 0);  -- Q output
        COMPONENT prep8 
                PORT(   
                       CLK : IN std_logic;
                       RST : IN std_logic;      
                       LD  : IN std_logic;      
                       CE  : IN std_logic;
                       D   : IN std_logic_vector(15 DOWNTO 0);
                       Q   : OUT std_logic_vector(15 DOWNTO 0)
               );
        END COMPONENT;  
                                                                                                         -- index
        CONSTANT cntl: cntlrom := -- RST,CE,LD
        (
           "000", "100", "001", "000", "000", -- 0-4 Begin counting at index 5, init count =20
           "010", "010", "010", "010", "010", -- 5-9  We will count up to 35(improve this to wrap cnt!)
           "010", "010", "010", "010", "010", -- 10-14
           "010", "010", "010", "010", "010", -- 15-19 count ends.
           "000", "000", "011", "010", "010", -- 20-24 Hold count for 2clks.,load/cnt @ 23, cnt @24
           "010", "010", "010", "010", "010",  -- 25-29
           "010", "000"                       -- 30-31
        );
        CONSTANT invec: datarom := 
        (       
            "0000000000000000", -- 0
            "0000000000000000", -- 1
            "0000000000010100", -- 2 D=20
            "0000000000010100", -- 3
            "0000000000010100", -- 4
            "0000000000010100", -- 5
            "0000000000010100", -- 6
            "0000000000010100", -- 7
            "0000000000010100", -- 8
            "0000000000010100", -- 9
            "0000000000010100", -- 10
            "0000000000010100", -- 11
            "0000000000010100", -- 12
            "0000000000010100", -- 13
            "0000000000010100", -- 14
            "0000000000010100", -- 15
            "0000000000010100", -- 16
            "0000000000010100", -- 17
            "0000000000010100", -- 18
            "0000000000010100", -- 19
            "0000000000010100", -- 20
            "0000000000010100", -- 21
            "1111111111111001", -- 22 D=FFF9
            "1111111111111001", -- 23 D=FFF9
            "1111111111111001", -- 24
            "1111111111111001", -- 25
            "1111111111111001", -- 26
            "1111111111111001", -- 27
            "1111111111111001", -- 28
            "1111111111111001", -- 29
            "1111111111111001", -- 30
            "1111111111111001"  -- 31
        );
        CONSTANT outvec: outrom := 
        (       
            "UUUUUUUUUUUUUUUU", -- 0
            "1111111111111111", -- 1
            "0000000000010100", -- 2
            "0000000000010100", -- 3 Q=20
            "0000000000010100", -- 4 Q=20
            "0000000000010101", -- 5 Q=21
            "0000000000010110", -- 6
            "0000000000010111", -- 7
            "0000000000011000", -- 8
            "0000000000011001", -- 9 Q=25
            "0000000000011010", -- 10
            "0000000000011011", -- 11
            "0000000000011100", -- 12
            "0000000000011101", -- 13
            "0000000000011110", -- 14 Q=30
            "0000000000011111", -- 15
            "0000000000100000", -- 16
            "0000000000100001", -- 17
            "0000000000100010", -- 18
            "0000000000100011", -- 19 Q=35
            "0000000000100011", -- 20 Q=35
            "0000000000100011", -- 21 Q=35
            "1111111111111001", -- 22 Q=FFF9
            "1111111111111010", -- 23
            "1111111111111011", -- 24
            "1111111111111100", -- 25
            "1111111111111101", -- 26
            "1111111111111110", -- 27
            "1111111111111111", -- 28
            "0000000000000000", -- 29
            "0000000000000001", -- 30
            "0000000000000001"  -- 31
        );
BEGIN
I1: prep8 port map (
                      CLK => CLK,
                      RST => RST,
                      LD  => LD,
                      CE  => CE,
                      D => D, 
                      Q => Q
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
                        IF Q /= outvec(loopindex) THEN
                                numerrors <= numerrors + 1;
                                -- display en error message
                        END IF;
                        loopindex <= loopindex + 1;
                        IF loopindex + 1 < numvecs THEN 
                                RST <= cntl(loopindex + 1)(2);
                                CE <= cntl(loopindex + 1)(1);
                                LD <= cntl(loopindex + 1)(0);
                                D <= invec(loopindex + 1);
                        END IF;
                END IF;
        END PROCESS testjig;
END behave;

CONFIGURATION behave_test_prep8 OF test_prep8 IS
        FOR behave
                FOR I1: prep8 USE ENTITY work.prep8(behave);
                END FOR;
        END FOR;
END behave_test_prep8;
