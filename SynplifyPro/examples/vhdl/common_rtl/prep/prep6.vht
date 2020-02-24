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
-- PREP Benchmark Circuit #6 -Accumulator (1 instance)
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

ENTITY test_prep6 IS 

END test_prep6;

ARCHITECTURE behave of test_prep6 IS
        SIGNAL RST,CLK: std_logic;
        SIGNAL D: std_logic_vector(15 DOWNTO 0);
        SIGNAL Q: std_logic_vector(15 DOWNTO 0);
        SIGNAL numerrors: integer := 0;
        SIGNAL loopindex: integer := 0;

        CONSTANT numvecs: INTEGER := 13;
        TYPE cntlrom is array(0 to (numvecs - 1)) of std_logic; -- RST inputs
        TYPE datarom is array(0 to (numvecs - 1)) of std_logic_vector(15 DOWNTO 0); -- D input
        TYPE outrom is array(0 to (numvecs - 1)) of std_logic_vector(15 DOWNTO 0);  -- Q output
        COMPONENT prep6 
                PORT(
                       CLK : IN std_logic;
                       RST : IN std_logic;      
                       D   : IN std_logic_vector(15 DOWNTO 0);
                       Q   : OUT std_logic_vector(15 DOWNTO 0)
                );
        END COMPONENT;  
                                                                                                         -- index
        CONSTANT cntl: cntlrom := -- RST
        (
           '1', '1', '0', '0', '0', -- 0-4 Begin counting at index 5, init count =20
           '0', '0', '1', '0', '0', -- 5-9  We will count up to 35(improve this to wrap cnt!)
           '0', '0', '0'            -- 10-12
        );
        CONSTANT invec: datarom := 
        (       
           "0000000000010100", -- 0 D=20
           "0000000000001010", -- 1 D=10
           "0000000000000101", -- 2 D=5
           "0000000000000111", -- 3 D=7
           "0000000001010000", -- 4 D=80
           "0000001111101011", -- 5 D=1003
           "0000000000000001", -- 6 D=1
           "0000000000011001", -- 7 D=25
           "0000000001010000", -- 4 D=80
           "0000000000000000", -- 9 D=0
           "1111111111111111", -- 10 D=65535
           "0000000000010010", -- 11 D=18
           "0000000111110100" -- 12 D=500
        );
        CONSTANT outvec: outrom := 
        (       
           "UUUUUUUUUUUUUUUU", -- 0
           "0000000000000000", -- 1
           "0000000000000101", -- 2 Q=5
           "0000000000001100", -- 3 Q=12
           "0000000001011100", -- 4 Q=92
           "0000010001000111", -- 5 Q=1095
           "0000010001001000", -- 6 Q=1096
           "0000000000000000", -- 7 Q=0
           "0000000001010000", -- 8 Q=80
           "0000000001010000", -- 9 Q=80
           "0000000001001111", -- 10 Q=79
           "0000000001100001", -- 11 Q=97
           "0000001001010101"  -- 12 Q=597
        );
BEGIN
I1: prep6 port map (
                      CLK => CLK,
                      RST => RST,
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
                                RST <= cntl(loopindex + 1);
                                D <= invec(loopindex + 1);
                        END IF;
                END IF;
        END PROCESS testjig;
END behave;

CONFIGURATION behave_test_prep6 OF test_prep6 IS
        FOR behave
                FOR I1: prep6 USE ENTITY work.prep6(behave);
                END FOR;
        END FOR;
END behave_test_prep6;
