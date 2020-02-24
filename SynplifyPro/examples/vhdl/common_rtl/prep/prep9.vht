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
-- PREP Benchmark Circuit #9 - Memory MapScaled Counter (1 instance)
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

ENTITY test_prep9 IS 

END test_prep9;

ARCHITECTURE behave of test_prep9 IS
        SIGNAL CLK: std_logic;
        SIGNAL RST,AS: std_logic;
        SIGNAL AL,AH: std_logic_vector(7 DOWNTO 0);
        -- SIGNAL addr: std_logic_vector(15 DOWNTO 0);
        SIGNAL BE: std_logic;
        SIGNAL Q: std_logic_vector(7 DOWNTO 0);
        SIGNAL numerrors: integer := 0;
        SIGNAL loopindex: integer := 0;

        CONSTANT numvecs: INTEGER := 30;
        TYPE cntlrom is array(0 to (numvecs - 1)) of std_logic_vector(1 DOWNTO 0); -- rst,as inputs
        TYPE addrrom is array(0 to (numvecs - 1)) of std_logic_vector(15 DOWNTO 0); -- addr input
        TYPE outrom is array(0 to (numvecs - 1)) of std_logic_vector( 8 DOWNTO 0);  -- be,q output
        COMPONENT prep9 
                PORT(   
                       CLK : IN std_logic;
                       RST : IN std_logic;      
                       AS  : IN std_logic;      
                       AL,AH   : IN std_logic_vector(7 DOWNTO 0);
                       BE  : OUT std_logic;     
                       Q   : OUT std_logic_vector(7 DOWNTO 0)
                );
        END COMPONENT;  
                                                                                                         -- index
        CONSTANT cntl: cntlrom :=
        (
           "10", "01", "01", "01", "01", -- 0-4
           "01", "01", "01", "01", "01", -- 5-9
           "01", "01", "01", "01", "01", -- 10-14
           "01", "01", "01", "01", "01", -- 15-19
           "01", "01", "01", "01", "01", -- 20-24
           "01", "00", "01", "00", "11"  -- 25-29
        );
         CONSTANT invec: addrrom := 
         (
            "UUUUUUUUUUUUUUUU", -- 0
            "0000000000000000", -- 1
            "0000000010100000", -- 2
            "1110001010101010", -- 3
            "1110001010101011", -- 4
            "1110001010101100", -- 5
            "1110001010101110", -- 6
            "1110001010101111", -- 7
            "1110001010110000", -- 8
            "1110001010111110", -- 9
            "1110001010111111", -- 10
            "1110001011000000", -- 11
            "1110001011010010", -- 12
            "1110001011111111", -- 13
            "1110001100000000", -- 14
            "1110001111110000", -- 15
            "1110001111111111", -- 16
            "1110010000000000", -- 17
            "1110011111110011", -- 18
            "1110011111111111", -- 19
            "1110100000000000", -- 20
            "1110101010101010", -- 21
            "1110111111111111", -- 22
            "1111000000000000", -- 23
            "1111101010111100", -- 24
            "1111111111111111", -- 25
            "1111111111111111", -- 26
            "0000000000000010", -- 27
            "1111111111111111", -- 28
            "1111111111111111"  -- 29
        );
        CONSTANT outvec: outrom := 
        (       
            "UUUUUUUUU", -- 0
            "100000000", -- 1
            "100000000", -- 2
            "100000000", -- 3
            "010000000", -- 4
            "001000000", -- 5
            "001000000", -- 6
            "001000000", -- 7
            "000100000", -- 8
            "000100000", -- 9
            "000100000", -- 10
            "000010000", -- 11
            "000010000", -- 12
            "000010000", -- 13
            "000001000", -- 14
            "000001000", -- 15
            "000001000", -- 16
            "000000100", -- 17
            "000000100", -- 18
            "000000100", -- 19
            "000000010", -- 20
            "000000010", -- 21
            "000000010", -- 22
            "000000001", -- 23
            "000000001", -- 24
            "000000001", -- 25
            "000000000", -- 26
            "100000000", -- 27
            "100000000", -- 28
            "000000000"  -- 29
        );
BEGIN
I1: prep9 port map (
                      CLK => CLK,
                      RST => RST,
                      AS  => AS,
                      AL  => AL,
                      AH  => AH,
                      BE => BE, 
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
                        IF BE /= outvec(loopindex)(8) or Q /= outvec(loopindex)(7 downto 0) THEN
                                numerrors <= numerrors + 1;
                                -- display en error message
                        END IF;
                        loopindex <= loopindex + 1;
                IF loopindex + 1 < numvecs THEN
                                RST <= cntl(loopindex + 1)(1);
                                AS <= cntl(loopindex + 1)(0);
                                AH <= invec(loopindex + 1)(15 downto 8);
                                AL <= invec(loopindex + 1)(7 downto 0);
                        END IF;
                END IF;
        END PROCESS testjig;
END behave;

CONFIGURATION behave_test_prep9 OF test_prep9 IS
        FOR behave
                FOR I1: prep9 USE ENTITY work.prep9(behave);
                END FOR;
        END FOR;
END behave_test_prep9;
