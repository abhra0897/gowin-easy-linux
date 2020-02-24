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
-- PREP Benchmark Circuit #2 - TIMER/COUNTER circuit (1 instance)
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

ENTITY test_prep2 IS 

END test_prep2;

ARCHITECTURE behave of test_prep2 IS

        SIGNAL RST,CLK,SEL,LDCOMP,LDPRE: std_logic;
        SIGNAL DATA1,DATA2: std_logic_vector(7 DOWNTO 0);
        SIGNAL DATA0: std_logic_vector(7 DOWNTO 0);

        CONSTANT numvecs: INTEGER := 14;
        TYPE cntlrom is array(0 to (numvecs - 1)) of std_logic_vector(3 DOWNTO 0); -- RST inputs
        TYPE datarom is array(0 to (numvecs - 1)) of std_logic_vector(15 DOWNTO 0); -- A,B inputs
        TYPE outrom is array(0 to (numvecs - 1)) of std_logic_vector(7 DOWNTO 0);  -- Q output

        SIGNAL loopindex: integer := 0;
        SIGNAL numerrors: integer := 0;

        COMPONENT prep2 
        PORT (   
               CLK: IN std_logic;
               RST : IN std_logic;      
               SEL : IN std_logic;
               LDCOMP : IN std_logic;
               LDPRE : IN std_logic;
               DATA1,DATA2   : IN std_logic_vector(7 DOWNTO 0);
               DATA0   : OUT std_logic_vector(7 DOWNTO 0)
        );
        END COMPONENT;  
                                                                                                         -- index
        CONSTANT cntl: cntlrom := -- RST,SEL,LDPRE,LDCOMP
        (
           "1100", "1100", "0100", "0001", "0000", -- 0-4 
           "0000", "0000", "0010", "0000", "0000", -- 5-9
           "0000", "0000", "0100", "0100"          -- 10-14     
        );
        CONSTANT invec: datarom := 
        (
           "0000000000000000", -- 0 DATA1 = 0, DATA0 = 0  
           "1111111000000001", -- 1 DATA1 = FE, DATA0 = 01
           "1111111000000001", -- 2 DATA1 = FE, DATA0 = 01 ;COUNTER Loads Data1
           "1111111000000001", -- 3 DATA1 = FE, DATA0 = 01 ;CNT, COMPREG Load Data2
           "1111111000000001", -- 4 CNT, 
           "1111111000000001", -- 5 EQUAL AT 01, LOAD COUNTER next cycle from PreReg
           "1111111000000001", -- 6 PREREG should be 0,
           "0000000011111110", -- 7 Cnt again, goes to 1, LDPRE with DATA2
           "0000000011111110", -- 8 LD COUNTER with Data2
           "0000000011111110", -- 9 Cnt, 
           "0000000011111110", -- 10 CNT
           "0000000011111110", -- 11 CNT =1,EQ
           "0000000011111110", -- 12 Load COUNTER from data1
           "0000000011111110"  -- 13 
        );
        CONSTANT outvec: outrom := 
        (
           "UUUUUUUU", -- 0 COUNTER=0x00 UNKOWN
           "00000000", -- 1 COUNTER=0x00 RST
           "11111110", -- 2 COUNTER=0xFE LOAD Data1
           "11111111", -- 3 COUNTER=0xFF Count
           "00000000", -- 4 COUNTER=0x00 Count
           "00000001", -- 5  COUNTER=0x01 Count
           "00000000",  -- 6 COUNTER=0x00 Load from PREREG=0
           "00000001",  -- 7 COUNTER=0x01 COUNT,EQ
           "11111110",  -- 8 COUNTER=0xFE Load with PREREG=FE
           "11111111",  -- 9 COUNTER=0xFF Count
           "00000000",  -- 10 COUNTER=0x00 Count
           "00000001",  -- 11 COUNTER=0x01 Count=1,Eq
           "00000000",  -- 12 COUNTER=0x00 Load from Data1=0
           "00000001"  -- 13 COUNTER=0x01 Count
        );
BEGIN
I1: prep2 port map ( 
                      CLK => CLK,
                      RST => RST,
                      SEL => SEL,
                      LDCOMP => LDCOMP,
                      LDPRE => LDPRE,
                      DATA1 => DATA1, 
                      DATA2 => DATA2, 
                      DATA0 => DATA0 
                   );
        toggleclk: PROCESS (CLK)
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

        testjig: PROCESS (CLK)
        BEGIN
                IF CLK = '0' THEN
                        IF DATA0 /= outvec(loopindex) THEN
                                numerrors <= numerrors + 1;
                                -- display en error message
                        END IF;
                        loopindex <= loopindex + 1;
                        IF ( (loopindex + 1 ) < numvecs) THEN
                                RST <= cntl(loopindex + 1)(3);
                                SEL <= cntl(loopindex + 1)(2);
                                LDPRE <= cntl(loopindex + 1)(1);
                                LDCOMP <= cntl(loopindex + 1)(0);
                                DATA1 <= invec(loopindex + 1)(15 DOWNTO 8);
                                DATA2 <= invec(loopindex + 1)(7 DOWNTO 0);
                        END IF;
                ELSIF CLK = '1' THEN
                ELSE
                        -- CLK is unknown
                END IF;
        END PROCESS testjig;
END behave;

CONFIGURATION behave_test_prep2 OF test_prep2 IS
        FOR behave
                FOR I1: prep2 USE ENTITY work.prep2(behave);
                END FOR;
        END FOR;
END behave_test_prep2;

