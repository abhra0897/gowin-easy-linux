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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

package body std_logic_unsigned is


    function maximum(L, R: INTEGER) return INTEGER is
        variable result: INTEGER;
    begin
        if L > R then
            result := L;
        else
            result := R;
        end if;

        return result;
    end;


    function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        constant length: INTEGER := maximum(L'length, R'length);
        variable result  : STD_LOGIC_VECTOR (length-1 downto 0);
    begin
        result  := UNSIGNED(L) + UNSIGNED(R);
        return   std_logic_vector(result);
    end;

    function "+"(L: STD_LOGIC_VECTOR; R: INTEGER) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := UNSIGNED(L) + R;
        return   std_logic_vector(result);
    end;

    function "+"(L: INTEGER; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (R'range);
    begin
        result  := L + UNSIGNED(R);
        return   std_logic_vector(result);
    end;

    function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := UNSIGNED(L) + R;
        return   std_logic_vector(result);
    end;

    function "+"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (R'range);
    begin
        result  := L + UNSIGNED(R);
        return   std_logic_vector(result);
    end;

    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        constant length: INTEGER := maximum(L'length, R'length);
        variable result  : STD_LOGIC_VECTOR (length-1 downto 0);
    begin
        result  := UNSIGNED(L) - UNSIGNED(R);
        return   std_logic_vector(result);
    end;

    function "-"(L: STD_LOGIC_VECTOR; R: INTEGER) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := UNSIGNED(L) - R;
        return   std_logic_vector(result);
    end;

    function "-"(L: INTEGER; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (R'range);
    begin
        result  := L - UNSIGNED(R);
        return   std_logic_vector(result);
    end;

    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := UNSIGNED(L) - R;
        return   std_logic_vector(result);
    end;

    function "-"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (R'range);
    begin
        result  := L - UNSIGNED(R);
        return   std_logic_vector(result);
    end;

    function "+"(L: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := + UNSIGNED(L);
        return   std_logic_vector(result);
    end;

    function "*"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        constant length: INTEGER := maximum(L'length, R'length);
        variable result  : STD_LOGIC_VECTOR ((L'length+R'length-1) downto 0);
    begin
        result  := UNSIGNED(L) * UNSIGNED(R);
        return   std_logic_vector(result);
    end;
        
    function "<"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN is
        constant length: INTEGER := maximum(L'length, R'length);
    begin
        return   UNSIGNED(L) < UNSIGNED(R);
    end;

    function "<"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   UNSIGNED(L) < R;
    end;

    function "<"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L < UNSIGNED(R);
    end;

    function "<="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   UNSIGNED(L) <= UNSIGNED(R);
    end;

    function "<="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   UNSIGNED(L) <= R;
    end;

    function "<="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L <= UNSIGNED(R);
    end;

    function ">"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   UNSIGNED(L) > UNSIGNED(R);
    end;

    function ">"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   UNSIGNED(L) > R;
    end;

    function ">"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L > UNSIGNED(R);
    end;

    function ">="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   UNSIGNED(L) >= UNSIGNED(R);
    end;

    function ">="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   UNSIGNED(L) >= R;
    end;

    function ">="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L >= UNSIGNED(R);
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

    function SHL(ARG:STD_LOGIC_VECTOR;COUNT: STD_LOGIC_VECTOR)
        return STD_LOGIC_VECTOR is
    begin
        return STD_LOGIC_VECTOR(SHL(UNSIGNED(ARG),UNSIGNED(COUNT)));
    end;

    function SHR(ARG:STD_LOGIC_VECTOR;COUNT: STD_LOGIC_VECTOR)
        return STD_LOGIC_VECTOR is
    begin
        return STD_LOGIC_VECTOR(SHR(UNSIGNED(ARG),UNSIGNED(COUNT)));
    end;

    function CONV_INTEGER(ARG: STD_LOGIC_VECTOR) return INTEGER is
        variable result    : UNSIGNED(ARG'range);
    begin
        result    := UNSIGNED(ARG);
        return   CONV_INTEGER(result);
    end;



end std_logic_unsigned;


