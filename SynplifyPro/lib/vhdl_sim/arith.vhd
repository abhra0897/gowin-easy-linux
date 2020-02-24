-----------------------------------------------------------------------------
--                                                                         --
-- Copyright (c) 1994, 1990 - 1993 by Synopsys, Inc.  All rights reserved. --
--                                                                         --
-- This source file may be used and distributed without restriction        --
-- provided that this copyright statement is not removed from the file     --
-- and that any derivative work contains this copyright notice.            --
--                                                                         --
--                                                                         --
--  Package name: std_logic_arith                                          --
--                                                                         --
--  Description:  This package contains a set of arithmetic operators      --
--                and functions.                                           --
--                                                                         --
--                                                                         --
--                                                                         --
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;

package std_logic_arith is

    type UNSIGNED is array (NATURAL range <>) of STD_LOGIC;
    type SIGNED is array (NATURAL range <>) of STD_LOGIC;
    subtype SMALL_INT is INTEGER range 0 to 1;

    function "+"(L: UNSIGNED; R: UNSIGNED) return UNSIGNED;
    function "+"(L: SIGNED; R: SIGNED) return SIGNED;
    function "+"(L: UNSIGNED; R: SIGNED) return SIGNED;
    function "+"(L: SIGNED; R: UNSIGNED) return SIGNED;
    function "+"(L: UNSIGNED; R: INTEGER) return UNSIGNED;
    function "+"(L: INTEGER; R: UNSIGNED) return UNSIGNED;
    function "+"(L: SIGNED; R: INTEGER) return SIGNED;
    function "+"(L: INTEGER; R: SIGNED) return SIGNED;
    function "+"(L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED;
    function "+"(L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED;
    function "+"(L: SIGNED; R: STD_ULOGIC) return SIGNED;
    function "+"(L: STD_ULOGIC; R: SIGNED) return SIGNED;

    function "+"(L: UNSIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "+"(L: SIGNED; R: SIGNED) return STD_LOGIC_VECTOR;
    function "+"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR;
    function "+"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "+"(L: UNSIGNED; R: INTEGER) return STD_LOGIC_VECTOR;
    function "+"(L: INTEGER; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "+"(L: SIGNED; R: INTEGER) return STD_LOGIC_VECTOR;
    function "+"(L: INTEGER; R: SIGNED) return STD_LOGIC_VECTOR;
    function "+"(L: UNSIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR;
    function "+"(L: STD_ULOGIC; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "+"(L: SIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR;
    function "+"(L: STD_ULOGIC; R: SIGNED) return STD_LOGIC_VECTOR;

    function "-"(L: UNSIGNED; R: UNSIGNED) return UNSIGNED;
    function "-"(L: SIGNED; R: SIGNED) return SIGNED;
    function "-"(L: UNSIGNED; R: SIGNED) return SIGNED;
    function "-"(L: SIGNED; R: UNSIGNED) return SIGNED;
    function "-"(L: UNSIGNED; R: INTEGER) return UNSIGNED;
    function "-"(L: INTEGER; R: UNSIGNED) return UNSIGNED;
    function "-"(L: SIGNED; R: INTEGER) return SIGNED;
    function "-"(L: INTEGER; R: SIGNED) return SIGNED;
    function "-"(L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED;
    function "-"(L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED;
    function "-"(L: SIGNED; R: STD_ULOGIC) return SIGNED;
    function "-"(L: STD_ULOGIC; R: SIGNED) return SIGNED;

    function "-"(L: UNSIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "-"(L: SIGNED; R: SIGNED) return STD_LOGIC_VECTOR;
    function "-"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR;
    function "-"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "-"(L: UNSIGNED; R: INTEGER) return STD_LOGIC_VECTOR;
    function "-"(L: INTEGER; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "-"(L: SIGNED; R: INTEGER) return STD_LOGIC_VECTOR;
    function "-"(L: INTEGER; R: SIGNED) return STD_LOGIC_VECTOR;
    function "-"(L: UNSIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR;
    function "-"(L: STD_ULOGIC; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "-"(L: SIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR;
    function "-"(L: STD_ULOGIC; R: SIGNED) return STD_LOGIC_VECTOR;

    function "+"(L: UNSIGNED) return UNSIGNED;
    function "+"(L: SIGNED) return SIGNED;
    function "-"(L: SIGNED) return SIGNED;
    function "ABS"(L: SIGNED) return SIGNED;

    function "+"(L: UNSIGNED) return STD_LOGIC_VECTOR;
    function "+"(L: SIGNED) return STD_LOGIC_VECTOR;
    function "-"(L: SIGNED) return STD_LOGIC_VECTOR;
    function "ABS"(L: SIGNED) return STD_LOGIC_VECTOR;

    function "*"(L: UNSIGNED; R: UNSIGNED) return UNSIGNED;
    function "*"(L: SIGNED; R: SIGNED) return SIGNED;
    function "*"(L: SIGNED; R: UNSIGNED) return SIGNED;
    function "*"(L: UNSIGNED; R: SIGNED) return SIGNED;

    function "*"(L: UNSIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "*"(L: SIGNED; R: SIGNED) return STD_LOGIC_VECTOR;
    function "*"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "*"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR;

    function "<"(L: UNSIGNED; R: UNSIGNED) return BOOLEAN;
    function "<"(L: SIGNED; R: SIGNED) return BOOLEAN;
    function "<"(L: UNSIGNED; R: SIGNED) return BOOLEAN;
    function "<"(L: SIGNED; R: UNSIGNED) return BOOLEAN;
    function "<"(L: UNSIGNED; R: INTEGER) return BOOLEAN;
    function "<"(L: INTEGER; R: UNSIGNED) return BOOLEAN;
    function "<"(L: SIGNED; R: INTEGER) return BOOLEAN;
    function "<"(L: INTEGER; R: SIGNED) return BOOLEAN;

    function "<="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN;
    function "<="(L: SIGNED; R: SIGNED) return BOOLEAN;
    function "<="(L: UNSIGNED; R: SIGNED) return BOOLEAN;
    function "<="(L: SIGNED; R: UNSIGNED) return BOOLEAN;
    function "<="(L: UNSIGNED; R: INTEGER) return BOOLEAN;
    function "<="(L: INTEGER; R: UNSIGNED) return BOOLEAN;
    function "<="(L: SIGNED; R: INTEGER) return BOOLEAN;
    function "<="(L: INTEGER; R: SIGNED) return BOOLEAN;

    function ">"(L: UNSIGNED; R: UNSIGNED) return BOOLEAN;
    function ">"(L: SIGNED; R: SIGNED) return BOOLEAN;
    function ">"(L: UNSIGNED; R: SIGNED) return BOOLEAN;
    function ">"(L: SIGNED; R: UNSIGNED) return BOOLEAN;
    function ">"(L: UNSIGNED; R: INTEGER) return BOOLEAN;
    function ">"(L: INTEGER; R: UNSIGNED) return BOOLEAN;
    function ">"(L: SIGNED; R: INTEGER) return BOOLEAN;
    function ">"(L: INTEGER; R: SIGNED) return BOOLEAN;

    function ">="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN;
    function ">="(L: SIGNED; R: SIGNED) return BOOLEAN;
    function ">="(L: UNSIGNED; R: SIGNED) return BOOLEAN;
    function ">="(L: SIGNED; R: UNSIGNED) return BOOLEAN;
    function ">="(L: UNSIGNED; R: INTEGER) return BOOLEAN;
    function ">="(L: INTEGER; R: UNSIGNED) return BOOLEAN;
    function ">="(L: SIGNED; R: INTEGER) return BOOLEAN;
    function ">="(L: INTEGER; R: SIGNED) return BOOLEAN;

    function "="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN;
    function "="(L: SIGNED; R: SIGNED) return BOOLEAN;
    function "="(L: UNSIGNED; R: SIGNED) return BOOLEAN;
    function "="(L: SIGNED; R: UNSIGNED) return BOOLEAN;
    function "="(L: UNSIGNED; R: INTEGER) return BOOLEAN;
    function "="(L: INTEGER; R: UNSIGNED) return BOOLEAN;
    function "="(L: SIGNED; R: INTEGER) return BOOLEAN;
    function "="(L: INTEGER; R: SIGNED) return BOOLEAN;

    function "/="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN;
    function "/="(L: SIGNED; R: SIGNED) return BOOLEAN;
    function "/="(L: UNSIGNED; R: SIGNED) return BOOLEAN;
    function "/="(L: SIGNED; R: UNSIGNED) return BOOLEAN;
    function "/="(L: UNSIGNED; R: INTEGER) return BOOLEAN;
    function "/="(L: INTEGER; R: UNSIGNED) return BOOLEAN;
    function "/="(L: SIGNED; R: INTEGER) return BOOLEAN;
    function "/="(L: INTEGER; R: SIGNED) return BOOLEAN;

    function SHL(ARG: UNSIGNED; COUNT: UNSIGNED) return UNSIGNED;
    function SHL(ARG: SIGNED; COUNT: UNSIGNED) return SIGNED;
    function SHR(ARG: UNSIGNED; COUNT: UNSIGNED) return UNSIGNED;
    function SHR(ARG: SIGNED; COUNT: UNSIGNED) return SIGNED;

    function CONV_INTEGER(ARG: INTEGER) return INTEGER;
    function CONV_INTEGER(ARG: UNSIGNED) return INTEGER;
    function CONV_INTEGER(ARG: SIGNED) return INTEGER;
    function CONV_INTEGER(ARG: STD_ULOGIC) return SMALL_INT;

    function CONV_UNSIGNED(ARG: INTEGER; SIZE: INTEGER) return UNSIGNED;
    function CONV_UNSIGNED(ARG: UNSIGNED; SIZE: INTEGER) return UNSIGNED;
    function CONV_UNSIGNED(ARG: SIGNED; SIZE: INTEGER) return UNSIGNED;
    function CONV_UNSIGNED(ARG: STD_ULOGIC; SIZE: INTEGER) return UNSIGNED;

    function CONV_SIGNED(ARG: INTEGER; SIZE: INTEGER) return SIGNED;
    function CONV_SIGNED(ARG: UNSIGNED; SIZE: INTEGER) return SIGNED;
    function CONV_SIGNED(ARG: SIGNED; SIZE: INTEGER) return SIGNED;
    function CONV_SIGNED(ARG: STD_ULOGIC; SIZE: INTEGER) return SIGNED;

    function CONV_STD_LOGIC_VECTOR(ARG: INTEGER; SIZE: INTEGER) 
						       return STD_LOGIC_VECTOR;
    function CONV_STD_LOGIC_VECTOR(ARG: UNSIGNED; SIZE: INTEGER) 
						       return STD_LOGIC_VECTOR;
    function CONV_STD_LOGIC_VECTOR(ARG: SIGNED; SIZE: INTEGER) 
						       return STD_LOGIC_VECTOR;
    function CONV_STD_LOGIC_VECTOR(ARG: STD_ULOGIC; SIZE: INTEGER) 
						       return STD_LOGIC_VECTOR;
    -- zero extend STD_LOGIC_VECTOR (ARG) to SIZE, 
    -- SIZE < 0 is same as SIZE = 0
    -- returns STD_LOGIC_VECTOR(SIZE-1 downto 0)
    function EXT(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) return STD_LOGIC_VECTOR;

    -- sign extend STD_LOGIC_VECTOR (ARG) to SIZE, 
    -- SIZE < 0 is same as SIZE = 0
    -- return STD_LOGIC_VECTOR(SIZE-1 downto 0)
    function SXT(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) return STD_LOGIC_VECTOR;

end std_logic_arith;
