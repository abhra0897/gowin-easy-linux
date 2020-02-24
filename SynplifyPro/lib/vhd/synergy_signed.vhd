--------------------------------------------------------------------------
--                                                                      --
-- Copyright (c) 1990, 1991 by Synopsys, Inc.  All rights reserved.     --
--                                                                      --
-- This source file may be used and distributed without restriction     --
-- provided that this copyright statement is not removed from the file  --
-- and that any derivative work contains this copyright notice.         --
--                                                                      --
--------------------------------------------------------------------------
--------------------------------------------------------------------------
-- Package name: SIGNED_ARITH                                           --
--                                                                      --
-- Purpose:                                                             --
-- A set of arithemtic, conversion, and comparison functions            --
-- for SIGNED, UNSIGNED, SMALL_INT, INTEGER,                            --
-- STD_ULOGIC, STD_LOGIC, and STD_LOGIC_VECTOR.                         --
--                                                                      --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package SIGNED_ARITH is

    type UNSIGNED is array (NATURAL range <>) of STD_LOGIC;
    type SIGNED is array (NATURAL range <>) of STD_LOGIC;
    subtype SMALL_INT is INTEGER range 0 to 1;

    function "+"(L: UNSIGNED; R: UNSIGNED) return UNSIGNED => "plus";
    function "+"(L: SIGNED; R: SIGNED) return SIGNED => "splus";
    function "+"(L: UNSIGNED; R: SIGNED) return SIGNED => "splus";
    function "+"(L: SIGNED; R: UNSIGNED) return SIGNED => "splus";
    function "+"(L: UNSIGNED; R: INTEGER) return UNSIGNED => "splus";
    function "+"(L: INTEGER; R: UNSIGNED) return UNSIGNED => "splus";
    function "+"(L: SIGNED; R: INTEGER) return SIGNED => "splus";
    function "+"(L: INTEGER; R: SIGNED) return SIGNED => "splus";
    function "+"(L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED => "plus";
    function "+"(L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED => "plus";
    function "+"(L: SIGNED; R: STD_ULOGIC) return SIGNED => "splus";
    function "+"(L: STD_ULOGIC; R: SIGNED) return SIGNED => "splus";

    function "+"(L: UNSIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: SIGNED; R: SIGNED) return STD_LOGIC_VECTOR => "splus";
    function "+"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR => "splus";
    function "+"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR => "splus";
    function "+"(L: UNSIGNED; R: INTEGER) return STD_LOGIC_VECTOR => "splus";
    function "+"(L: INTEGER; R: UNSIGNED) return STD_LOGIC_VECTOR => "splus";
    function "+"(L: SIGNED; R: INTEGER) return STD_LOGIC_VECTOR => "splus";
    function "+"(L: INTEGER; R: SIGNED) return STD_LOGIC_VECTOR => "splus";
    function "+"(L: UNSIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: STD_ULOGIC; R: UNSIGNED) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: SIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR => "splus";
    function "+"(L: STD_ULOGIC; R: SIGNED) return STD_LOGIC_VECTOR => "splus";

    function "-"(L: UNSIGNED; R: UNSIGNED) return UNSIGNED => "minus";
    function "-"(L: SIGNED; R: SIGNED) return SIGNED => "sminus";
    function "-"(L: UNSIGNED; R: SIGNED) return SIGNED => "sminus";
    function "-"(L: SIGNED; R: UNSIGNED) return SIGNED => "sminus";
    function "-"(L: UNSIGNED; R: INTEGER) return UNSIGNED => "sminus";
    function "-"(L: INTEGER; R: UNSIGNED) return UNSIGNED => "sminus";
    function "-"(L: SIGNED; R: INTEGER) return SIGNED => "sminus";
    function "-"(L: INTEGER; R: SIGNED) return SIGNED => "sminus";
    function "-"(L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED => "minus";
    function "-"(L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED => "minus";
    function "-"(L: SIGNED; R: STD_ULOGIC) return SIGNED => "sminus";
    function "-"(L: STD_ULOGIC; R: SIGNED) return SIGNED => "sminus";

    function "-"(L: UNSIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: SIGNED; R: SIGNED) return STD_LOGIC_VECTOR => "sminus";
    function "-"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR => "sminus";
    function "-"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR => "sminus";
    function "-"(L: UNSIGNED; R: INTEGER) return STD_LOGIC_VECTOR => "sminus";
    function "-"(L: INTEGER; R: UNSIGNED) return STD_LOGIC_VECTOR => "sminus";
    function "-"(L: SIGNED; R: INTEGER) return STD_LOGIC_VECTOR => "sminus";
    function "-"(L: INTEGER; R: SIGNED) return STD_LOGIC_VECTOR => "sminus";
    function "-"(L: UNSIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: STD_ULOGIC; R: UNSIGNED) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: SIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR => "sminus";
    function "-"(L: STD_ULOGIC; R: SIGNED) return STD_LOGIC_VECTOR => "sminus";

    function "+"(L: UNSIGNED) return UNSIGNED => "buf";
    function "+"(L: SIGNED) return SIGNED => "buf";
    function "-"(L: SIGNED) return SIGNED => "uminus";
    function "ABS"(L: SIGNED) return SIGNED;

    function "+"(L: UNSIGNED) return STD_LOGIC_VECTOR => "buf";
    function "+"(L: SIGNED) return STD_LOGIC_VECTOR => "buf";
    function "-"(L: SIGNED) return STD_LOGIC_VECTOR => "uminus";
    function "ABS"(L: SIGNED) return STD_LOGIC_VECTOR;

    function "*"(L: UNSIGNED; R: UNSIGNED) return UNSIGNED => "mult";
    function "*"(L: SIGNED; R: SIGNED) return SIGNED => "smult";
    function "*"(L: SIGNED; R: UNSIGNED) return SIGNED;
    function "*"(L: UNSIGNED; R: SIGNED) return SIGNED;

    function "*"(L: UNSIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR => "mult";
    function "*"(L: SIGNED; R: SIGNED) return STD_LOGIC_VECTOR => "smult";
    function "*"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "*"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR;

    function "<"(L: UNSIGNED; R: UNSIGNED) return BOOLEAN => "ult";
    function "<"(L: SIGNED; R: SIGNED) return BOOLEAN => "slt";
    function "<"(L: UNSIGNED; R: SIGNED) return BOOLEAN => "slt";
    function "<"(L: SIGNED; R: UNSIGNED) return BOOLEAN => "slt";
    function "<"(L: UNSIGNED; R: INTEGER) return BOOLEAN => "slt";
    function "<"(L: INTEGER; R: UNSIGNED) return BOOLEAN => "slt";
    function "<"(L: SIGNED; R: INTEGER) return BOOLEAN => "slt";
    function "<"(L: INTEGER; R: SIGNED) return BOOLEAN => "slt";

    function "<="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN => "ule";
    function "<="(L: SIGNED; R: SIGNED) return BOOLEAN => "sle";
    function "<="(L: UNSIGNED; R: SIGNED) return BOOLEAN => "sle";
    function "<="(L: SIGNED; R: UNSIGNED) return BOOLEAN => "sle";
    function "<="(L: UNSIGNED; R: INTEGER) return BOOLEAN => "sle";
    function "<="(L: INTEGER; R: UNSIGNED) return BOOLEAN => "sle";
    function "<="(L: SIGNED; R: INTEGER) return BOOLEAN => "sle";
    function "<="(L: INTEGER; R: SIGNED) return BOOLEAN => "sle";

    function ">"(L: UNSIGNED; R: UNSIGNED) return BOOLEAN => "ugt";
    function ">"(L: SIGNED; R: SIGNED) return BOOLEAN => "sgt";
    function ">"(L: UNSIGNED; R: SIGNED) return BOOLEAN => "sgt";
    function ">"(L: SIGNED; R: UNSIGNED) return BOOLEAN => "sgt";
    function ">"(L: UNSIGNED; R: INTEGER) return BOOLEAN => "sgt";
    function ">"(L: INTEGER; R: UNSIGNED) return BOOLEAN => "sgt";
    function ">"(L: SIGNED; R: INTEGER) return BOOLEAN => "sgt";
    function ">"(L: INTEGER; R: SIGNED) return BOOLEAN => "sgt";

    function ">="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN => "uge";
    function ">="(L: SIGNED; R: SIGNED) return BOOLEAN => "sge";
    function ">="(L: UNSIGNED; R: SIGNED) return BOOLEAN => "sge";
    function ">="(L: SIGNED; R: UNSIGNED) return BOOLEAN => "sge";
    function ">="(L: UNSIGNED; R: INTEGER) return BOOLEAN => "sge";
    function ">="(L: INTEGER; R: UNSIGNED) return BOOLEAN => "sge";
    function ">="(L: SIGNED; R: INTEGER) return BOOLEAN => "sge";
    function ">="(L: INTEGER; R: SIGNED) return BOOLEAN => "sge";

    function "="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN => "eq";
    function "="(L: SIGNED; R: SIGNED) return BOOLEAN => "eq";
    function "="(L: UNSIGNED; R: SIGNED) return BOOLEAN => "eq";
    function "="(L: SIGNED; R: UNSIGNED) return BOOLEAN => "eq";
    function "="(L: UNSIGNED; R: INTEGER) return BOOLEAN => "eq";
    function "="(L: INTEGER; R: UNSIGNED) return BOOLEAN => "eq";
    function "="(L: SIGNED; R: INTEGER) return BOOLEAN => "eq";
    function "="(L: INTEGER; R: SIGNED) return BOOLEAN => "eq";

    function "/="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN => "noteq";
    function "/="(L: SIGNED; R: SIGNED) return BOOLEAN => "noteq";
    function "/="(L: UNSIGNED; R: SIGNED) return BOOLEAN => "noteq";
    function "/="(L: SIGNED; R: UNSIGNED) return BOOLEAN => "noteq";
    function "/="(L: UNSIGNED; R: INTEGER) return BOOLEAN => "noteq";
    function "/="(L: INTEGER; R: UNSIGNED) return BOOLEAN => "noteq";
    function "/="(L: SIGNED; R: INTEGER) return BOOLEAN => "noteq";
    function "/="(L: INTEGER; R: SIGNED) return BOOLEAN => "noteq";
    -------Boolean functions below  ADDED in SEPT 1995 ----------------
    function "not" (L: SIGNED) return SIGNED => "not";
    function "not" (L: SIGNED) return UNSIGNED => "not";
    function "not" (L: UNSIGNED) return SIGNED => "not";
    function "not" (L: UNSIGNED) return UNSIGNED => "not";

    function "or" (L: SIGNED; R: SIGNED) return SIGNED => "or";
    function "or" (L: SIGNED; R: SIGNED) return UNSIGNED => "or";
    function "or" (L: SIGNED; R: UNSIGNED) return SIGNED => "or";
    function "or" (L: SIGNED; R: UNSIGNED) return UNSIGNED => "or";
    function "or" (L: UNSIGNED; R: SIGNED) return SIGNED => "or";
    function "or" (L: UNSIGNED; R: SIGNED) return UNSIGNED => "or";
    function "or" (L: UNSIGNED; R: UNSIGNED) return SIGNED => "or";
    function "or" (L: UNSIGNED; R: UNSIGNED) return UNSIGNED => "or";

    function "and" (L: SIGNED; R: SIGNED) return SIGNED => "and";
    function "and" (L: SIGNED; R: SIGNED) return UNSIGNED => "and";
    function "and" (L: SIGNED; R: UNSIGNED) return SIGNED => "and";
    function "and" (L: SIGNED; R: UNSIGNED) return UNSIGNED => "and";
    function "and" (L: UNSIGNED; R: SIGNED) return SIGNED => "and";
    function "and" (L: UNSIGNED; R: SIGNED) return UNSIGNED => "and";
    function "and" (L: UNSIGNED; R: UNSIGNED) return SIGNED => "and";
    function "and" (L: UNSIGNED; R: UNSIGNED) return UNSIGNED => "and";

    function "xor" (L: SIGNED; R: SIGNED) return SIGNED => "xor";
    function "xor" (L: SIGNED; R: SIGNED) return UNSIGNED => "xor";
    function "xor" (L: SIGNED; R: UNSIGNED) return SIGNED => "xor";
    function "xor" (L: SIGNED; R: UNSIGNED) return UNSIGNED => "xor";
    function "xor" (L: UNSIGNED; R: SIGNED) return SIGNED => "xor";
    function "xor" (L: UNSIGNED; R: SIGNED) return UNSIGNED => "xor";
    function "xor" (L: UNSIGNED; R: UNSIGNED) return SIGNED => "xor";
    function "xor" (L: UNSIGNED; R: UNSIGNED) return UNSIGNED => "xor";

    function "nor" (L: SIGNED; R: SIGNED) return SIGNED => "nor";
    function "nor" (L: SIGNED; R: SIGNED) return UNSIGNED => "nor";
    function "nor" (L: SIGNED; R: UNSIGNED) return SIGNED => "nor";
    function "nor" (L: SIGNED; R: UNSIGNED) return UNSIGNED => "nor";
    function "nor" (L: UNSIGNED; R: SIGNED) return SIGNED => "nor";
    function "nor" (L: UNSIGNED; R: SIGNED) return UNSIGNED => "nor";
    function "nor" (L: UNSIGNED; R: UNSIGNED) return SIGNED => "nor";
    function "nor" (L: UNSIGNED; R: UNSIGNED) return UNSIGNED => "nor";

    function "nand" (L: SIGNED; R: SIGNED) return SIGNED => "nand";
    function "nand" (L: SIGNED; R: SIGNED) return UNSIGNED => "nand";
    function "nand" (L: SIGNED; R: UNSIGNED) return SIGNED => "nand";
    function "nand" (L: SIGNED; R: UNSIGNED) return UNSIGNED => "nand";
    function "nand" (L: UNSIGNED; R: SIGNED) return SIGNED => "nand";
    function "nand" (L: UNSIGNED; R: SIGNED) return UNSIGNED => "nand";
    function "nand" (L: UNSIGNED; R: UNSIGNED) return SIGNED => "nand";
    function "nand" (L: UNSIGNED; R: UNSIGNED) return UNSIGNED => "nand";
    ----------------------------------------------------------

    function SHL(ARG: UNSIGNED; COUNT: UNSIGNED) return UNSIGNED => "sll";
    function SHL(ARG: SIGNED; COUNT: UNSIGNED) return SIGNED => "sll";
    function SHR(ARG: UNSIGNED; COUNT: UNSIGNED) return UNSIGNED => "srl";
    function SHR(ARG: SIGNED; COUNT: UNSIGNED) return SIGNED => "sra";

    function CONV_INTEGER(ARG: INTEGER) return INTEGER => "bufsi";
    function CONV_INTEGER(ARG: UNSIGNED) return INTEGER => "bufi";
    function CONV_INTEGER(ARG: SIGNED) return INTEGER => "bufsi";
    function CONV_INTEGER(ARG: STD_ULOGIC) return SMALL_INT => "bufi";

    function CONV_UNSIGNED(ARG: INTEGER; SIZE: INTEGER) return UNSIGNED => "strim";
    function CONV_UNSIGNED(ARG: UNSIGNED; SIZE: INTEGER) return UNSIGNED => "trim";
    function CONV_UNSIGNED(ARG: SIGNED; SIZE: INTEGER) return UNSIGNED => "strim";
    function CONV_UNSIGNED(ARG: STD_ULOGIC; SIZE: INTEGER) return UNSIGNED => "trim";
    function CONV_UNSIGNED(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) return UNSIGNED => "trim";

    function CONV_SIGNED(ARG: INTEGER; SIZE: INTEGER) return SIGNED => "strim";
    function CONV_SIGNED(ARG: UNSIGNED; SIZE: INTEGER) return SIGNED => "trim";
    function CONV_SIGNED(ARG: SIGNED; SIZE: INTEGER) return SIGNED => "strim";
    function CONV_SIGNED(ARG: STD_ULOGIC; SIZE: INTEGER) return SIGNED => "trim";
    function CONV_SIGNED(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) return SIGNED => "strim";

    function CONV_STD_LOGIC_VECTOR(ARG: INTEGER; SIZE: INTEGER) 
						       return STD_LOGIC_VECTOR => "strim";
    function CONV_STD_LOGIC_VECTOR(ARG: UNSIGNED; SIZE: INTEGER) 
						       return STD_LOGIC_VECTOR => "trim";
    function CONV_STD_LOGIC_VECTOR(ARG: SIGNED; SIZE: INTEGER) 
						       return STD_LOGIC_VECTOR => "strim";
    function CONV_STD_LOGIC_VECTOR(ARG: STD_ULOGIC; SIZE: INTEGER) 
						       return STD_LOGIC_VECTOR => "trim";
    -- zero extend STD_LOGIC_VECTOR (ARG) to SIZE, 
    -- SIZE < 0 is same as SIZE = 0
    -- returns STD_LOGIC_VECTOR(SIZE-1 downto 0)
    function EXT(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) return STD_LOGIC_VECTOR => "trim";

    -- sign extend STD_LOGIC_VECTOR (ARG) to SIZE, 
    -- SIZE < 0 is same as SIZE = 0
    -- return STD_LOGIC_VECTOR(SIZE-1 downto 0)
    function SXT(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) return STD_LOGIC_VECTOR => "strim";

    function TO_BOOLEAN(OPER: STD_ULOGIC) return BOOLEAN => "buf";
    function TO_MVL9(OPER: BOOLEAN) return STD_ULOGIC => "buf";
    function MVL9_TO_BIT(OPER: STD_ULOGIC) return BIT => "buf";
    function MVL9_TO_BITV(OPER: STD_LOGIC_VECTOR)  return BIT_VECTOR => "buf";

end SIGNED_ARITH;



library IEEE;
use IEEE.std_logic_1164.all;

package body SIGNED_ARITH is


    function "ABS"(L: SIGNED) return STD_LOGIC_VECTOR is
	variable tmp: SIGNED(L'length-1 downto 0);
    begin
	if (L(L'left) = '0' or L(L'left) = 'L') then
	    tmp := L;
	else
	    tmp := 0 - L;
	end if;
	return STD_LOGIC_VECTOR(tmp);
    end;

    function "ABS"(L: SIGNED) return SIGNED is
	variable tmp: SIGNED(L'length-1 downto 0);
    begin
	if (L(L'left) = '0' or L(L'left) = 'L') then
	    tmp := L;
	else
	    tmp := 0 - L;
	end if;
	return (tmp);
    end;

    function  "*"(L: UNSIGNED; R: SIGNED) return SIGNED is
    begin
        return  (CONV_SIGNED(L, L'length+1) * R);
    end;

    function "*"(L: SIGNED; R: UNSIGNED) return SIGNED is
    begin
        return  (L * CONV_SIGNED(R, R'length+1));
    end;

    function "*"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR is
    begin
        return (CONV_SIGNED(L, L'length+1) * R);
    end;
	
    function "*"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR is
	begin
        return (L * CONV_SIGNED(R, R'length+1));
    end; 
end SIGNED_ARITH;

