-----------------------------------------------------------------------------
--                                                                         --
-- Copyright (c) 1994, 1990 - 1993 by Synopsys, Inc.  All rights reserved. --
--                                                                         --
-- This source file may be used and distributed without restriction        --
-- provided that this copyright statement is not removed from the file     --
-- and that any derivative work contains this copyright notice.            --
--                                                                         --
--                                                                         --
--  Package name: std_logic_signed                                         --
--                                                                         --
--  Description:  This package contains a set of signed arithemtic         --
--                operators and functions.                                 --
--                                                                         --
--                                                                         --
--                                                                         --
-----------------------------------------------------------------------------
-- $Header: //synplicity/compdevb/compilers/vhdl/vhd/signed.vhd#1 $

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

package std_logic_signed is
    function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
    function "+"(L: STD_LOGIC_VECTOR; R: INTEGER) return STD_LOGIC_VECTOR => "splus";
    function "+"(L: INTEGER; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "splus";
    function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "plus";

    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
    function "-"(L: STD_LOGIC_VECTOR; R: INTEGER) return STD_LOGIC_VECTOR => "sminus";
    function "-"(L: INTEGER; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "sminus";
    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "minus";

    function "+"(L: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "uplus";
    function "-"(L: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "uminus";
    function "ABS"(L: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;


    function "*"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;

    function "<"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN => "slt";
    function "<"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "slt";
    function "<"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "slt";

    function "<="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "sle";
    function "<="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "sle";
    function "<="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN => "sle";

    function ">"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN => "sgt";
    function ">"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "sgt";
    function ">"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "sgt";

    function ">="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "sge";
    function ">="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "sge";
    function ">="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN => "sge";

    function "="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN;
    function "="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN;
    function "="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN;

    function "/="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN;
    function "/="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN;
    function "/="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN;

    function SHL(ARG:STD_LOGIC_VECTOR;COUNT: STD_LOGIC_VECTOR) 
    return STD_LOGIC_VECTOR => "sll";
    function SHR(ARG:STD_LOGIC_VECTOR;COUNT: STD_LOGIC_VECTOR) 
    return STD_LOGIC_VECTOR => "sra";

    function CONV_INTEGER(ARG: STD_LOGIC_VECTOR) return INTEGER => "bufsi";

end std_logic_signed;

package body std_logic_signed is
    function "ABS"(L: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
    if(L(L'left) = '0') then
        result := L;
    else
        result := 0 - L;
    end if;
    return result;
    end;

    function "*"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
    begin
         return(SIGNED(L) * SIGNED(R));
    end;

    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
   begin
    return(SIGNED(L) - SIGNED(R));
   end;

    function "="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN IS
   begin
    return(SIGNED(L) = SIGNED(R));
   end;
    function "="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN IS
   begin
    return(SIGNED(L) = R);
   end;
    function "="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN IS
   begin
    return(L = SIGNED(R));
   end;

    function "/="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN IS
   begin
    return(SIGNED(L) /= SIGNED(R));
   end;
    function "/="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN IS
   begin
    return(SIGNED(L) /= R);
   end;
    function "/="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN IS
   begin
    return(L /= SIGNED(R));
   end;

    function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
   begin
    return(SIGNED(L) + SIGNED(R));
   end;
end std_logic_signed;
