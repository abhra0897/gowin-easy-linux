-----------------------------------------------------------------------------
--                                                                         --
-- Copyright (c) 1994, 1990 - 1993 by Synopsys, Inc.  All rights reserved. --
--                                                                         --
-- This source file may be used and distributed without restriction        --
-- provided that this copyright statement is not removed from the file     --
-- and that any derivative work contains this copyright notice.            --
--                                                                         --
--                                                                         --
--  Package name: std_logic_unsigned                                       --
--                                                                         --
--  Description:  This package contains a set of unsigned arithemtic       --
--                operators and functions.                                 --
--                                                                         --
--                                                                         --
--                                                                         --
-----------------------------------------------------------------------------
-- $Header: //synplicity/compdevb/compilers/vhdl/vhd/unsigned.vhd#2 $

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

package std_logic_unsigned is

    function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: STD_LOGIC_VECTOR; R: INTEGER) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: INTEGER; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "plus";

    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: STD_LOGIC_VECTOR; R: INTEGER) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: INTEGER; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "minus";

    function "+"(L: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "uplus";

    function "*"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "mult";

    function "<"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN => "ult";
    function "<"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN;
    function "<"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN;


    function "<="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN => "ule";
    function "<="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN;
    function "<="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN;


    function ">"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN => "ugt";
    function ">"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN;
    function ">"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN;


    function ">="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN => "uge";
    function ">="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN;
    function ">="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN;


    function "="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN => "eq";
    function "="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN;
    function "="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN;


    function "/="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN => "noteq";
    function "/="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN;
    function "/="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN;

    function SHL(ARG:STD_LOGIC_VECTOR;COUNT: STD_LOGIC_VECTOR) 
	return STD_LOGIC_VECTOR => "ssll";
    function SHR(ARG:STD_LOGIC_VECTOR;COUNT: STD_LOGIC_VECTOR) 
	return STD_LOGIC_VECTOR => "ssrl";

    function CONV_INTEGER(ARG: STD_LOGIC_VECTOR) return INTEGER => "bufi";

end std_logic_unsigned;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
package body std_logic_unsigned is

    function ">"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   UNSIGNED(L) > R;
    end;

    function ">"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L > UNSIGNED(R);
    end;

    function ">="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   UNSIGNED(L) >= R;
    end;

    function ">="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L >= UNSIGNED(R);
    end;

    function "<"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   UNSIGNED(L) < R;
    end;

    function "<"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L < UNSIGNED(R);
    end;

    function "<="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   UNSIGNED(L) <= R;
    end;

    function "<="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L <= UNSIGNED(R);
    end;

    function "="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   UNSIGNED(L) = R;
    end;

    function "="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L = UNSIGNED(R);
    end;

    function "/="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   UNSIGNED(L) /= R;
    end;

    function "/="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L /= UNSIGNED(R);
    end;


end std_logic_unsigned;
