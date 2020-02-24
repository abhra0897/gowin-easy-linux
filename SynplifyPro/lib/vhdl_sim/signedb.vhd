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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

package body std_logic_signed is


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
        result  := SIGNED(L) + SIGNED(R);
        return   std_logic_vector(result);
    end;

    function "+"(L: STD_LOGIC_VECTOR; R: INTEGER) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := SIGNED(L) + R;
        return   std_logic_vector(result);
    end;

    function "+"(L: INTEGER; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (R'range);
    begin
        result  := L + SIGNED(R);
        return   std_logic_vector(result);
    end;

    function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := SIGNED(L) + R;
        return   std_logic_vector(result);
    end;

    function "+"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (R'range);
    begin
        result  := L + SIGNED(R);
        return   std_logic_vector(result);
    end;

    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        constant length: INTEGER := maximum(L'length, R'length);
        variable result  : STD_LOGIC_VECTOR (length-1 downto 0);
    begin
        result  := SIGNED(L) - SIGNED(R);
        return   std_logic_vector(result);
    end;

    function "-"(L: STD_LOGIC_VECTOR; R: INTEGER) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := SIGNED(L) - R;
        return   std_logic_vector(result);
    end;

    function "-"(L: INTEGER; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (R'range);
    begin
        result  := L - SIGNED(R);
        return   std_logic_vector(result);
    end;

    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := SIGNED(L) - R;
        return   std_logic_vector(result);
    end;

    function "-"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (R'range);
    begin
        result  := L - SIGNED(R);
        return   std_logic_vector(result);
    end;

    function "+"(L: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := + SIGNED(L);
        return   std_logic_vector(result);
    end;

    function "-"(L: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := - SIGNED(L);
        return   std_logic_vector(result);
    end;

    function "ABS"(L: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        variable result  : STD_LOGIC_VECTOR (L'range);
    begin
        result  := ABS( SIGNED(L));
        return   std_logic_vector(result);
    end;

    function "*"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
        constant length: INTEGER := maximum(L'length, R'length);
        variable result  : STD_LOGIC_VECTOR ((L'length+R'length-1) downto 0);
    begin
        result  := SIGNED(L) * SIGNED(R);
        return   std_logic_vector(result);
    end;
        
    function "<"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN is
        constant length: INTEGER := maximum(L'length, R'length);
    begin
        return   SIGNED(L) < SIGNED(R);
    end;

    function "<"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   SIGNED(L) < R;
    end;

    function "<"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L < SIGNED(R);
    end;

    function "<="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   SIGNED(L) <= SIGNED(R);
    end;

    function "<="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   SIGNED(L) <= R;
    end;

    function "<="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L <= SIGNED(R);
    end;

    function ">"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   SIGNED(L) > SIGNED(R);
    end;

    function ">"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   SIGNED(L) > R;
    end;

    function ">"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L > SIGNED(R);
    end;

    function ">="(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   SIGNED(L) >= SIGNED(R);
    end;

    function ">="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   SIGNED(L) >= R;
    end;

    function ">="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L >= SIGNED(R);
    end;

    function "="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   SIGNED(L) = R;
    end;

    function "="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L = SIGNED(R);
    end;

    function "/="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN is
    begin
        return   SIGNED(L) /= R;
    end;

    function "/="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN is
    begin
        return   L /= SIGNED(R);
    end;

    function SHL(ARG:STD_LOGIC_VECTOR;COUNT: STD_LOGIC_VECTOR)
       return STD_LOGIC_VECTOR is
    begin
       return STD_LOGIC_VECTOR(SHL(SIGNED(ARG),UNSIGNED(COUNT)));
    end;

    function SHR(ARG:STD_LOGIC_VECTOR;COUNT: STD_LOGIC_VECTOR)
        return STD_LOGIC_VECTOR is
    begin
       return STD_LOGIC_VECTOR(SHR(SIGNED(ARG),UNSIGNED(COUNT)));
    end;

--  This function converts std_logic_vector to a signed integer value
--  using a conversion function in std_logic_arith
    function CONV_INTEGER(ARG: STD_LOGIC_VECTOR) return INTEGER is
        variable result    : SIGNED(ARG'range);
    begin
        result    := SIGNED(ARG);
        return   CONV_INTEGER(result);
    end;
end std_logic_signed;


