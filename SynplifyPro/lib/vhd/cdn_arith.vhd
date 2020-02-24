--
-- Modified by Synplicity, Inc from Cadence source for use with Synplify.
-- This file is not suitable for simulation.
--
------------------------------------------------------------------------------
-- $Header: //synplicity/comp2019q3p1/compilers/vhdl/vhd/cdn_arith.vhd#1 $

library IEEE;
use IEEE.std_logic_1164.ALL;

package std_logic_arith is

    type UNSIGNED is array (NATURAL range <>) of STD_LOGIC;
    type SIGNED is array (NATURAL range <>) of STD_LOGIC;
    subtype SMALL_INT is INTEGER range 0 to 1;

    function align_size(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) 
				   return STD_LOGIC_VECTOR => "trim";
    function align_size(ARG: STD_LOGIC; SIZE: INTEGER) 
				   return STD_LOGIC_VECTOR => "trim";
    function align_size(ARG: STD_ULOGIC_VECTOR; SIZE: INTEGER) 
				   return STD_ULOGIC_VECTOR => "trim";
    function align_size(ARG: STD_ULOGIC; SIZE: INTEGER) 
				   return STD_ULOGIC_VECTOR => "trim";

    function TO_STDLOGICVECTOR(ARG: INTEGER; SIZE: INTEGER) return STD_LOGIC_VECTOR => "strim"; 
    function TO_STDULOGICVECTOR(ARG: INTEGER; SIZE: INTEGER) return STD_ULOGIC_VECTOR => "trim";
    function TO_STDLOGICVECTOR(ARG: STD_ULOGIC_VECTOR) return STD_LOGIC_VECTOR => "buf";

    function TO_INTEGER(ARG: STD_LOGIC_VECTOR) return INTEGER => "bufi";
    function TO_INTEGER(SRG: STD_ULOGIC) return INTEGER => "bufi";
    function TO_INTEGER(ARG: STD_ULOGIC_VECTOR) return INTEGER => "bufi";

    function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: STD_LOGIC_VECTOR; R: INTEGER) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: INTEGER; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR => "plus";
    function "+"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "plus";

    function "+"(L: std_ulogic; R: std_ulogic) return std_ulogic => "xor";
    function "+"(L: std_ulogic_vector; R: std_ulogic_vector) 
				   return STD_ULOGIC_VECTOR => "plus";
    function "+"(L: std_ulogic_vector; R: std_ulogic) 
				   return STD_ULOGIC_VECTOR => "plus";
    function "+"(L: std_ulogic; R: std_ulogic_vector) 
				   return STD_ULOGIC_VECTOR => "plus";
    function "+"(L: integer; R: std_ulogic_vector) 
				   return STD_ULOGIC_VECTOR => "plus";
    function "+"(L: std_ulogic_vector; R: integer) 
				   return STD_ULOGIC_VECTOR => "plus";

    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: STD_LOGIC_VECTOR; R: INTEGER) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: INTEGER; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "minus";
    function "-"(L: std_ulogic; R: std_ulogic) return std_ulogic => "xor";
    function "-"(L: std_ulogic_vector; R: std_ulogic_vector) 
				   return STD_ULOGIC_VECTOR => "minus";
    function "-"(L: std_ulogic_vector; R: std_ulogic) 
				   return STD_ULOGIC_VECTOR => "minus";
    function "-"(L: std_ulogic; R: std_ulogic_vector) 
				   return STD_ULOGIC_VECTOR => "minus";
    function "-"(L: integer; R: std_ulogic_vector) 
				   return STD_ULOGIC_VECTOR => "minus";
    function "-"(L: std_ulogic_vector; R: integer) 
				   return STD_ULOGIC_VECTOR => "minus";

    function "+"(L: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "buf";
    function "+"(ARG: STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR => "buf";

    function "*"(L: std_ulogic; R: std_ulogic) return std_ulogic => "and";
    function "*"(L: std_logic_vector; R: std_logic) return std_logic_vector ; -- see body
    function "*"(L: std_logic; R: std_logic_vector) return std_logic_vector ; -- see body
    function "*"(L: std_ulogic_vector; R: std_ulogic_vector) 
				   return std_ulogic_vector => "mult";
    function "*"(L: STD_LOGIC_VECTOR; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR => "mult";
    function "*"(L: std_ulogic; R: std_ulogic_vector) return std_ulogic_vector; -- see body
    function "*"(L: std_ulogic_vector; R: std_ulogic) return std_ulogic_vector; -- see body
    function "/"(L: std_ulogic_vector; R: std_ulogic) return std_ulogic_vector => "div"; 
    function "/"(L: std_ulogic; R: std_ulogic_vector) return std_ulogic_vector => "div";
    function "/"(L: std_ulogic; R: std_ulogic) return std_ulogic => "div";

    function "<"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "lt"; 
    function "<"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "lt"; 
    function "<"(L: INTEGER; R: STD_ULOGIC_VECTOR) return BOOLEAN => "lt"; 
    function "<"(L: STD_ULOGIC_VECTOR; R: INTEGER) return BOOLEAN => "lt"; 

    function "<="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "le"; 
    function "<="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "le"; 
    function "<="(L: INTEGER; R: STD_ULOGIC_VECTOR) return BOOLEAN => "le"; 
    function "<="(L: STD_ULOGIC_VECTOR; R: INTEGER) return BOOLEAN => "le"; 

    function ">"(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "gt"; 
    function ">"(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "gt"; 
    function ">"(L: INTEGER; R: STD_ULOGIC_VECTOR) return BOOLEAN => "gt"; 
    function ">"(L: STD_ULOGIC_VECTOR; R: INTEGER) return BOOLEAN => "gt"; 

    function ">="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "ge"; 
    function ">="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "ge"; 
    function ">="(L: INTEGER; R: STD_ULOGIC_VECTOR) return BOOLEAN => "ge"; 
    function ">="(L: STD_ULOGIC_VECTOR; R: INTEGER) return BOOLEAN => "ge"; 

    function "="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "eq"; 
    function "="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "eq"; 
    function "="(L: INTEGER; R: STD_ULOGIC_VECTOR) return BOOLEAN => "eq"; 
    function "="(L: STD_ULOGIC_VECTOR; R: INTEGER) return BOOLEAN => "eq"; 

    function "/="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "noteq"; 
    function "/="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "noteq"; 
    function "/="(L: INTEGER; R: STD_LOGIC_VECTOR) return BOOLEAN => "noteq"; 
    function "/="(L: STD_LOGIC_VECTOR; R: INTEGER) return BOOLEAN => "noteq"; 

    function sh_left(L: STD_ULOGIC_VECTOR; SIZE: NATURAL) return STD_ULOGIC_VECTOR => "sll";
    function sh_right(L: STD_ULOGIC_VECTOR; SIZE: NATURAL) return STD_ULOGIC_VECTOR => "srl";
    function sh_left(L: STD_LOGIC_VECTOR; SIZE: NATURAL) return STD_LOGIC_VECTOR => "sll";
    function sh_right(L: STD_LOGIC_VECTOR; SIZE: NATURAL) return STD_LOGIC_VECTOR => "srl";

end std_logic_arith;

-- Now for the body

library IEEE;
use IEEE.std_logic_1164.all;
package body std_logic_arith is
    function "*"(L: STD_LOGIC; R: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
      variable tmp: std_logic_vector(R'length-1 downto 0) := (others => '0');
	begin
	  if (L = '1') then
	    tmp := R;
	  end if;
        return(tmp);
    end;
    function "*"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR is
      variable tmp: std_logic_vector(L'length-1 downto 0) := (others => '0');
	begin
	  if (R = '1') then
	    tmp := L;
	  end if;
        return(tmp);
    end;
    function "*"(L: STD_ULOGIC; R: STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
      variable tmp: std_Ulogic_vector(R'length-1 downto 0) := (others => '0');
	begin
	  if (L = '1') then
	    tmp := R;
	  end if;
        return(tmp);
    end;
    function "*"(L: STD_ULOGIC_VECTOR; R: STD_ULOGIC) return STD_ULOGIC_VECTOR is
      variable tmp: std_Ulogic_vector(L'length-1 downto 0) := (others => '0');
	begin
	  if (R = '1') then
	    tmp := L;
	  end if;
        return(tmp);
    end;
	
    

end std_logic_arith;

