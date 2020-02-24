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
-- PREP Benchmark Circuit #5 -Arithemetic circuit (1 instance)
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

ENTITY test_prep5 IS 

END test_prep5;

ARCHITECTURE behave of test_prep5 IS
        SIGNAL RST,CLK,MAC: std_logic;
        SIGNAL A,B: std_logic_vector(3 DOWNTO 0);
        SIGNAL Q: std_logic_vector(7 DOWNTO 0);
        SIGNAL numerrors: integer := 0;
        SIGNAL loopindex: integer := 0;

        CONSTANT numvecs: INTEGER := 7;
        TYPE cntlrom is array(0 to (numvecs - 1)) of std_logic_vector(1 DOWNTO 0); -- RST,MAC inputs
        TYPE datarom is array(0 to (numvecs - 1)) of std_logic_vector(7 DOWNTO 0); -- A,B inputs
        TYPE outrom is array(0 to (numvecs - 1)) of std_logic_vector(7 DOWNTO 0);  -- Q output
        COMPONENT prep5 
                PORT(   
                       CLK : IN std_logic;
                       RST : IN std_logic;      
                       MAC : IN std_logic;      
                       A,B   : IN std_logic_vector(3 DOWNTO 0);
                       Q   : OUT std_logic_vector(7 DOWNTO 0)
                );
        END COMPONENT;  
                                                                                                         -- index
        CONSTANT cntl: cntlrom := -- RST
        (
           "00", "10", "00", "00", "01", -- 0-4 
            "01", "11"                    -- 5
        );
        CONSTANT invec: datarom := 
        (
           "00000000",  -- 0 A=0,B=0
           "01000011", -- 1 A=4,B=3
           "01000011", -- 2 A=4,B=3
           "10100011", -- 3 A=10,B=3
           "01100010", -- 4 A=6,B=2
           "10110101", -- 5 A=11,B=5
           "10100011"  -- 6 A=10,B=3
        );
        CONSTANT outvec: outrom := 
        (       
           "UUUUUUUU", -- 0 Q=UNKOWN
           "00000000", -- 1 Q=0
           "00001100", -- 2 Q=12
           "00011110", -- 3 Q=30
           "00101010", -- 4 Q=42
           "01100001", -- 5 Q=97
           "00000000"  -- 6 Q=0
        );
BEGIN
I1: prep5 port map (
                      CLK => CLK,
                      RST => RST,
                      MAC => MAC,
                      A => A, 
                      B => B, 
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
                                RST <= cntl(loopindex + 1)(1);
                                MAC <= cntl(loopindex + 1)(0);
                                A <= invec(loopindex + 1)(7 DOWNTO 4);
                                B <= invec(loopindex + 1)(3 DOWNTO 0);
                        END IF;
                END IF;
        END PROCESS testjig;
END behave;

CONFIGURATION behave_test_prep5 OF test_prep5 IS
        FOR behave
                FOR I1: prep5 USE ENTITY work.prep5(behave);
                END FOR;
        END FOR;
END behave_test_prep5;
