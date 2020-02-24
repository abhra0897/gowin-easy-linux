--
-- Modified by Synplicity, Inc for use with Synplify.
-- This file is not suitable for simulation.  See the original in
-- the vhdl_sim directory.
--
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
-- $Header: //synplicity/compdevb/compilers/vhdl/vhd/arith.vhd#1 $

--synthesis internal_package
library IEEE;
use IEEE.std_logic_1164.ALL;

package std_logic_arith is

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

    function "+"(L: UNSIGNED) return UNSIGNED => "uplus";
    function "+"(L: SIGNED) return SIGNED => "uplus";
    function "-"(L: SIGNED) return SIGNED => "usminus";
    function "ABS"(L: SIGNED) return SIGNED; -- in body

    function "+"(L: UNSIGNED) return STD_LOGIC_VECTOR => "uplus";
    function "+"(L: SIGNED) return STD_LOGIC_VECTOR => "uplus";
    function "-"(L: SIGNED) return STD_LOGIC_VECTOR => "usminus";
    function "ABS"(L: SIGNED) return STD_LOGIC_VECTOR; -- in body

    function "*"(L: UNSIGNED; R: UNSIGNED) return UNSIGNED => "mult";
    function "*"(L: SIGNED; R: SIGNED) return SIGNED       => "smult";
    function "*"(L: SIGNED; R: UNSIGNED) return SIGNED;
    function "*"(L: UNSIGNED; R: SIGNED) return SIGNED;

    function "*"(L: UNSIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR => "mult";
    function "*"(L: SIGNED; R: SIGNED) return STD_LOGIC_VECTOR     => "smult";
    function "*"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR;
    function "*"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR;

    function "<"(L: UNSIGNED; R: UNSIGNED) return BOOLEAN => "ult";
    function "<"(L: SIGNED; R: SIGNED) return BOOLEAN     => "slt";
    function "<"(L: UNSIGNED; R: SIGNED) return BOOLEAN   => "slt";
    function "<"(L: SIGNED; R: UNSIGNED) return BOOLEAN   => "slt";
    function "<"(L: UNSIGNED; R: INTEGER) return BOOLEAN;
    function "<"(L: INTEGER; R: UNSIGNED) return BOOLEAN;
    function "<"(L: SIGNED; R: INTEGER) return BOOLEAN    => "slt";
    function "<"(L: INTEGER; R: SIGNED) return BOOLEAN    => "slt";

    function "<="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN => "ule";
    function "<="(L: SIGNED; R: SIGNED) return BOOLEAN     => "sle";
    function "<="(L: UNSIGNED; R: SIGNED) return BOOLEAN   => "sle";
    function "<="(L: SIGNED; R: UNSIGNED) return BOOLEAN   => "sle";
    function "<="(L: UNSIGNED; R: INTEGER) return BOOLEAN;
    function "<="(L: INTEGER; R: UNSIGNED) return BOOLEAN;
    function "<="(L: SIGNED; R: INTEGER) return BOOLEAN    => "sle";
    function "<="(L: INTEGER; R: SIGNED) return BOOLEAN    => "sle";

    function ">"(L: UNSIGNED; R: UNSIGNED) return BOOLEAN  => "ugt";
    function ">"(L: SIGNED; R: SIGNED) return BOOLEAN      => "sgt";
    function ">"(L: UNSIGNED; R: SIGNED) return BOOLEAN    => "sgt";
    function ">"(L: SIGNED; R: UNSIGNED) return BOOLEAN    => "sgt";
    function ">"(L: UNSIGNED; R: INTEGER) return BOOLEAN;
    function ">"(L: INTEGER; R: UNSIGNED) return BOOLEAN;
    function ">"(L: SIGNED; R: INTEGER) return BOOLEAN     => "sgt";
    function ">"(L: INTEGER; R: SIGNED) return BOOLEAN     => "sgt";

    function ">="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN => "uge";
    function ">="(L: SIGNED; R: SIGNED) return BOOLEAN     => "sge";
    function ">="(L: UNSIGNED; R: SIGNED) return BOOLEAN   => "sge";
    function ">="(L: SIGNED; R: UNSIGNED) return BOOLEAN   => "sge";
    function ">="(L: UNSIGNED; R: INTEGER) return BOOLEAN;
    function ">="(L: INTEGER; R: UNSIGNED) return BOOLEAN;
    function ">="(L: SIGNED; R: INTEGER) return BOOLEAN    => "sge";
    function ">="(L: INTEGER; R: SIGNED) return BOOLEAN    => "sge";

    function "="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN  => "eq";
    function "="(L: SIGNED; R: SIGNED) return BOOLEAN      => "eq";
    function "="(L: UNSIGNED; R: SIGNED) return BOOLEAN    => "eq";
    function "="(L: SIGNED; R: UNSIGNED) return BOOLEAN    => "eq";
    function "="(L: UNSIGNED; R: INTEGER) return BOOLEAN   => "eq";
    function "="(L: INTEGER; R: UNSIGNED) return BOOLEAN   => "eq";
    function "="(L: SIGNED; R: INTEGER) return BOOLEAN     => "eq";
    function "="(L: INTEGER; R: SIGNED) return BOOLEAN     => "eq";

    function "/="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN => "noteq";
    function "/="(L: SIGNED; R: SIGNED) return BOOLEAN     => "noteq";
    function "/="(L: UNSIGNED; R: SIGNED) return BOOLEAN   => "noteq";
    function "/="(L: SIGNED; R: UNSIGNED) return BOOLEAN   => "noteq";
    function "/="(L: UNSIGNED; R: INTEGER) return BOOLEAN  => "noteq";
    function "/="(L: INTEGER; R: UNSIGNED) return BOOLEAN  => "noteq";
    function "/="(L: SIGNED; R: INTEGER) return BOOLEAN    => "noteq";
    function "/="(L: INTEGER; R: SIGNED) return BOOLEAN    => "noteq";

    function SHL(ARG: UNSIGNED; COUNT: UNSIGNED) return UNSIGNED => "ssll";
    function SHL(ARG: SIGNED; COUNT: UNSIGNED) return SIGNED     => "ssll";
    function SHR(ARG: UNSIGNED; COUNT: UNSIGNED) return UNSIGNED => "ssrl";
    function SHR(ARG: SIGNED; COUNT: UNSIGNED) return SIGNED     => "sra";

    function CONV_INTEGER(ARG: INTEGER) return INTEGER      => "bufsi";
    function CONV_INTEGER(ARG: UNSIGNED) return INTEGER     => "bufi";
    function CONV_INTEGER(ARG: SIGNED) return INTEGER       => "bufsi";
    function CONV_INTEGER(ARG: STD_ULOGIC) return SMALL_INT => "bufi";

    function CONV_UNSIGNED(ARG: INTEGER; SIZE: INTEGER) return UNSIGNED => "strim";
    function CONV_UNSIGNED(ARG: UNSIGNED; SIZE: INTEGER) return UNSIGNED => "trim";
    function CONV_UNSIGNED(ARG: SIGNED; SIZE: INTEGER) return UNSIGNED => "strim";
    function CONV_UNSIGNED(ARG: STD_ULOGIC; SIZE: INTEGER) return UNSIGNED => "trim";

    function CONV_SIGNED(ARG: INTEGER; SIZE: INTEGER) return SIGNED => "strim";
    function CONV_SIGNED(ARG: UNSIGNED; SIZE: INTEGER) return SIGNED => "trim";
    function CONV_SIGNED(ARG: SIGNED; SIZE: INTEGER) return SIGNED => "strim";
    function CONV_SIGNED(ARG: STD_ULOGIC; SIZE: INTEGER) return SIGNED => "trim";

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
    function EXT(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) 
				return STD_LOGIC_VECTOR => "trim";

    -- sign extend STD_LOGIC_VECTOR (ARG) to SIZE, 
    -- SIZE < 0 is same as SIZE = 0
    -- return STD_LOGIC_VECTOR(SIZE-1 downto 0)
    function SXT(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) 
				return STD_LOGIC_VECTOR; -- see body

end std_logic_arith;

-- Now for the body

library IEEE;
use IEEE.std_logic_1164.all;
package body std_logic_arith is
    function "ABS"(L: SIGNED) return SIGNED is
		variable result: SIGNED(L'length-1 downto 0);
    begin
		if (L(L'left) = '0') then
			result := L;
		else
			result :=  0 - L;
		end if;
        return result;
    end;
    function "ABS"(L: SIGNED) return STD_LOGIC_VECTOR is
		variable tmp: SIGNED(L'length-1 downto 0);
    begin
		if (L(L'left) = '0') then
			tmp := L;
		else
			tmp := 0 - L;
		end if;
		return STD_LOGIC_VECTOR (tmp);
    end;


    function "*"(L: UNSIGNED; R: SIGNED) return SIGNED is
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

    function ">="(L: UNSIGNED; R: INTEGER) return BOOLEAN is
          constant length: INTEGER := L'length + 1;
    begin
          return(CONV_SIGNED(L,length) >= CONV_SIGNED(R,length));
    end;

    function ">="(L: INTEGER; R: UNSIGNED) return BOOLEAN is
          constant length: INTEGER := R'length + 1;
    begin
          return(CONV_SIGNED(L,length) >= CONV_SIGNED(R,length));
    end;

    function ">"(L: UNSIGNED; R: INTEGER) return BOOLEAN is
          constant length: INTEGER := L'length + 1;
    begin
          return(CONV_SIGNED(L,length) > CONV_SIGNED(R,length));
    end;

    function ">"(L: INTEGER; R: UNSIGNED) return BOOLEAN is
          constant length: INTEGER := R'length + 1;
    begin
          return(CONV_SIGNED(L,length) > CONV_SIGNED(R,length));
    end;

    function "<"(L: UNSIGNED; R: INTEGER) return BOOLEAN is
          constant length: INTEGER := L'length + 1;
    begin
          return(CONV_SIGNED(L,length) < CONV_SIGNED(R,length));
    end;

    function "<"(L: INTEGER; R: UNSIGNED) return BOOLEAN is
          constant length: INTEGER := R'length + 1;
    begin
          return(CONV_SIGNED(L,length) < CONV_SIGNED(R,length));
    end;

    function "<="(L: UNSIGNED; R: INTEGER) return BOOLEAN is
          constant length: INTEGER := L'length + 1;
    begin
          return(CONV_SIGNED(L,length) <= CONV_SIGNED(R,length));
    end;

    function "<="(L: INTEGER; R: UNSIGNED) return BOOLEAN is
          constant length: INTEGER := R'length + 1;
    begin
          return(CONV_SIGNED(L,length) <= CONV_SIGNED(R,length));
    end;

    
    function SXT(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) return STD_LOGIC_VECTOR is
          variable ret : std_logic_vector(size-1 downto 0);
          variable oper: std_logic_vector(arg'length-1 downto 0) := arg;
    begin
       if (ARG'length > SIZE) then
                 ret := oper(size-1 downto 0);
           else
                 ret := (others => oper(oper'left));
                 ret(oper'length-1 downto 0) := oper;
       end if;
       return(ret);
    end;

end std_logic_arith;
