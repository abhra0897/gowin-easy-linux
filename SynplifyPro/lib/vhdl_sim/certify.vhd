-----------------------------------------------------------------------------
--                                                                         --
-- Copyright (c) 1997 by Synplicity, Inc.  All rights reserved.            --
--                                                                         --
-- This source file may be used and distributed without restriction        --
-- provided that this copyright statement is not removed from the file     --
-- and that any derivative work contains this copyright notice.            --
--                                                                         --
-- Primitive library for post synthesis simulation                         --
-- These models are not intended for efficient synthesis                   --
--                                                                         --
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package SIMULATE is
	function MULT (L: UNSIGNED; R: UNSIGNED; RESULT_LEN: INTEGER) 
	return UNSIGNED;
	-- Result subtype: UNSIGNED(RESULT_LEN-1 downto 0)
	-- Result: Multiplies two UNSIGNED vectors and truncates the result
	-- (if required) to give a STD_LOGIC_VECTOR result of length RESULT_LEN
	function SMULT (L: SIGNED; R: SIGNED; RESULT_LEN: INTEGER) 
	return SIGNED;
	-- Result subtype: UNSIGNED(RESULT_LEN-1 downto 0)
	-- Result: Multiplies two UNSIGNED vectors and truncates the result
	-- (if required) to give a STD_LOGIC_VECTOR result of length RESULT_LEN
	function PLUS (L: UNSIGNED; R: UNSIGNED) 
	return UNSIGNED;
	-- Result subtype: UNSIGNED(R'LENGTH+L'LENGTH-1 downto 0)
	-- Result: Add two UNSIGNED vectors 
	function UMINUS (L: SIGNED) 
	return SIGNED;
	-- Result subtype: SIGNED(L'LENGTH-1 downto 0)
	-- Result: unary minus of the SIGNED vector 
end SIMULATE;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package body SIMULATE is
	function MULT (L: UNSIGNED; R: UNSIGNED; RESULT_LEN: INTEGER) 
	return UNSIGNED is
		variable operand_sum: integer := L'length+R'length;
		variable result: unsigned(L'length+R'length-1 downto 0);
	begin
		result := L * R;
		if (RESULT_LEN >= operand_sum) then
			return result;
		else
			return result(RESULT_LEN-1 downto 0);
		end if;
	end MULT;

	function SMULT (L: SIGNED; R: SIGNED; RESULT_LEN: INTEGER) 
	return SIGNED is
		variable operand_sum: integer := L'length+R'length;
		variable result: signed(L'length+R'length-1 downto 0);
	begin
		result := L * R;
		if (RESULT_LEN >= operand_sum) then
			return result;
		else
			return result(RESULT_LEN-1 downto 0);
		end if;
	end SMULT;

        function PLUS (L: UNSIGNED; R: UNSIGNED)
        return UNSIGNED is
        begin
                return L + R;
        end PLUS;

        function UMINUS (L: SIGNED)
        return SIGNED is
        begin
                return -L;
        end UMINUS;

end SIMULATE;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package SIMULATE_STD_ARITH is
		-- Id: D.1
		function TO_INTEGER (ARG: UNSIGNED) return NATURAL;
		-- Result subtype: NATURAL. Value cannot be negative since parameter is an
		--             UNSIGNED vector.
		-- Result: Converts the UNSIGNED vector to an INTEGER.


		-- Id: D.2
		function TO_INTEGER (ARG: SIGNED) return INTEGER;
		-- Result subtype: INTEGER
		-- Result: Converts a SIGNED vector to an INTEGER.


        function MULT (L: UNSIGNED; R: UNSIGNED; RESULT_LEN: INTEGER)
        return UNSIGNED;
        -- Result subtype: UNSIGNED(RESULT_LEN-1 downto 0)
        -- Result: Multiplies two UNSIGNED vectors and truncates the result
        -- (if required) to give a STD_LOGIC_VECTOR result of length RESULT_LEN
        function SMULT (L: SIGNED; R: SIGNED; RESULT_LEN: INTEGER)
        return SIGNED;
        -- Result subtype: UNSIGNED(RESULT_LEN-1 downto 0)
        -- Result: Multiplies two UNSIGNED vectors and truncates the result
        -- (if required) to give a STD_LOGIC_VECTOR result of length RESULT_LEN
	function PLUS (L: UNSIGNED; R: UNSIGNED) 
	return UNSIGNED;
	-- Result subtype: UNSIGNED(R'LENGTH+L'LENGTH-1 downto 0)
	-- Result: Adds two UNSIGNED vectors
	function UMINUS (L: SIGNED) 
	return SIGNED;
	-- Result subtype: SIGNED(L'LENGTH-1 downto 0)
	-- Result: unary minus of the SIGNED vector 
end SIMULATE_STD_ARITH;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package body SIMULATE_STD_ARITH is
		-- Id: D.1
		function TO_INTEGER (ARG: UNSIGNED) return NATURAL is
		  constant ARG_LEFT: INTEGER := ARG'LENGTH-1;
		  alias XXARG: UNSIGNED(ARG_LEFT downto 0) is ARG;
		  variable XARG: UNSIGNED(ARG_LEFT downto 0);
		  variable RESULT: NATURAL := 0;
		begin
		  if (ARG'LENGTH < 1) then
			return 0;
		  end if;
		  XARG := ARG;
		  for I in XARG'RANGE loop
			RESULT := RESULT+RESULT;
			if XARG(I) = '1' then
			  RESULT := RESULT + 1;
			end if;
		  end loop;
		  return RESULT;
		end TO_INTEGER;

		-- Id: D.2
		function unm(ARG : SIGNED) return SIGNED is
		constant length : INTEGER := ARG'length;        
		begin
				return((CONV_SIGNED(0, length) - ARG));
		end unm;


		function tmpf(ARG : SIGNED) return SIGNED is
		constant length : INTEGER := ARG'length;        
		begin
				return(unm((ARG + CONV_SIGNED(1, length))));
		end tmpf;

		-- Id: D.2
		function TO_INTEGER (ARG: SIGNED) return INTEGER is
		  variable XARG: SIGNED(ARG'LENGTH-1 downto 0);
		begin
		  if (ARG'LENGTH < 1) then
				return 0;
		  end if;
		  XARG := ARG;
		  if XARG(XARG'LEFT) = '0' then
				return TO_INTEGER(UNSIGNED(XARG));
		  else
--                      return (- (TO_INTEGER(UNSIGNED(- (XARG + 1)))) -1);
				return (- (TO_INTEGER(UNSIGNED(tmpf(XARG))) -1));
		  end if;
		end TO_INTEGER;



--		function TO_INTEGER (ARG: SIGNED) return INTEGER is
--		  variable XARG: SIGNED(ARG'LENGTH-1 downto 0);
--		begin
--		  if (ARG'LENGTH < 1) then
--			return 0;
--		  end if;
--		  XARG := ARG;
--		  if XARG(XARG'LEFT) = '0' then
--			return TO_INTEGER(UNSIGNED(XARG));
--		  else
--			return (- (TO_INTEGER(UNSIGNED(- (XARG + 1)))) -1);
--		  end if;
--		end TO_INTEGER;

        function MULT (L: UNSIGNED; R: UNSIGNED; RESULT_LEN: INTEGER)
        return UNSIGNED is
                variable operand_sum: integer := L'length+R'length;
                variable result: unsigned(L'length+R'length-1 downto 0);
        begin
                result := L * R;
                if (RESULT_LEN >= operand_sum) then
                        return result;
                else
                        return result(RESULT_LEN-1 downto 0);
                end if;
        end MULT;

        function SMULT (L: SIGNED; R: SIGNED; RESULT_LEN: INTEGER)
        return SIGNED is
                variable operand_sum: integer := L'length+R'length;
                variable result: signed(L'length+R'length-1 downto 0);
        begin
                result := L * R;
                if (RESULT_LEN >= operand_sum) then
                        return result;
                else
                        return result(RESULT_LEN-1 downto 0);
                end if;
        end SMULT;

        function PLUS (L: UNSIGNED; R: UNSIGNED)
        return UNSIGNED is
        begin
                return L + R;
        end PLUS;

        function UMINUS (L: SIGNED)
        return SIGNED is
        begin
                return -L;
        end UMINUS;

end SIMULATE_STD_ARITH;

library ieee;
use ieee.std_logic_1164.all;

package slp_conv_funcs is

type tbl_type is array (STD_ULOGIC) of STD_ULOGIC;
constant tbl_BINARY : tbl_type :=
	('X', 'X', '0', '1', 'X', 'X', '0', '1', 'X');

function slp_to_slv32(ARG: INTEGER) return STD_LOGIC_VECTOR;
function slp_to_slv4(ARG: INTEGER) return STD_LOGIC_VECTOR;

function slp_to_slv(ARG: bit) return std_logic_vector;
function slp_to_bit(ARG: std_logic_vector) return bit;

function slp_to_slv(ARG: std_logic) return STD_LOGIC_VECTOR;
function slp_to_stdlogic(ARG: std_logic_vector) return std_logic;

function slp_to_stdulogic(ARG: std_logic_vector) return std_ulogic;

function slp_to_signed_int(ARG: STD_LOGIC_VECTOR) return INTEGER;
function slp_to_unsigned_int(ARG: STD_LOGIC_VECTOR) return INTEGER;

end slp_conv_funcs;

package body slp_conv_funcs is

function slp_to_slv32(ARG: integer) return std_logic_vector is
	variable result: std_logic_vector (31 downto 0);
	variable temp: integer;
    begin
	temp := ARG;
	for i in 0 to 31 loop
	    if (temp mod 2) = 1 then
		result(i) := '1';
	    else 
		result(i) := '0';
	    end if;
	    if temp > 0 then
  		temp := temp / 2;
	    else
  		temp := (temp - 1) / 2; -- simulate ASR
	    end if;
	end loop;
	return result;
    end;

	function slp_to_slv4(ARG: INTEGER) return STD_LOGIC_VECTOR is
		variable stdlogicVal: std_logic_vector(31 downto 0);
	begin
		stdlogicVal := slp_to_slv32(arg);
		return(stdlogicVal(3 downto 0));
	end;

	function slp_to_slv(ARG: bit) return STD_LOGIC_VECTOR is
		variable result: std_logic_vector(0 downto 0);
	begin
		result(0) := to_stdulogic(arg);
		return(result);
	end;

	function slp_to_bit(ARG: std_logic_vector) return bit is
		variable result: bit := '0';
	begin
		result := to_bit(arg(0));
		return(result);
	end;

	function slp_to_slv(ARG: std_logic) return STD_LOGIC_VECTOR is
		variable result: std_logic_vector(0 downto 0);
	begin
		result(0) := arg;
		return(result);
	end;

	function slp_to_stdlogic(ARG: std_logic_vector) return std_logic is
	begin
		return(arg(0));
	end;


	function slp_to_stdulogic(ARG: std_logic_vector) return std_ulogic is
	begin
		return(arg(0));
	end;




	function slp_to_signed_int(ARG: std_logic_vector) return integer is
	variable result: INTEGER;
	variable tmp: STD_ULOGIC;
    begin
	assert ARG'length <= 32
	    report "ARG is too large in slp_to_signed"
	    severity FAILURE;
	result := 0;
	for i in ARG'range loop
	    if i /= ARG'left then
		result := result * 2;
	        tmp := tbl_BINARY(ARG(i));
	        if tmp = '1' then
		    result := result + 1;
	        elsif tmp = 'X' then
		    assert false
		    report "CONV_INTEGER: There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, and it has been converted to 0."
		    severity WARNING;
	        end if;
	    end if;
	end loop;
	tmp := ARG(ARG'left);
	if tmp = '1' then
	    if ARG'length = 32 then
		result := (result - 2**30) - 2**30;
	    else
		result := result - (2 ** (ARG'length-1));
	    end if;
	end if;
	return result;
    end;

	function slp_to_unsigned_int(ARG: STD_LOGIC_VECTOR) return INTEGER is
	variable result: INTEGER;
	variable tmp: STD_ULOGIC;
    begin
	assert ARG'length <= 32
	    report "ARG is too large in to_unsigned_int"
	    severity FAILURE;
	result := 0;
	for i in ARG'range loop
	    if i /= ARG'left then
		result := result * 2;
	        tmp := tbl_BINARY(ARG(i));
	        if tmp = '1' then
		    result := result + 1;
	        elsif tmp = 'X' then
		    assert false
		    report "to_unsigned_int: There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, and it has been converted to 0."
		    severity WARNING;
	        end if;
	    end if;
	end loop;
	return result;
    end;


end slp_conv_funcs;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

package slp_bit_convfuncs is

function slp_to_slv(ARG: signed) return std_logic_vector;
function slp_to_slv(ARG: unsigned) return std_logic_vector;

function slp_to_signed(ARG: std_logic_vector) return signed;
function slp_to_unsigned(ARG: std_logic_vector) return unsigned;

end slp_bit_convfuncs;

package body slp_bit_convfuncs is


	function slp_to_slv(ARG: signed) return std_logic_vector is
		variable result: std_logic_vector(ARG'RANGE);
	begin
		result := (others => '0');
		for I in result'RANGE loop
			if (ARG(i) = '1') then
				result(i) := '1';
			end if;
		end loop;
		return(result);
	end;

	function slp_to_slv(ARG: unsigned) return std_logic_vector is
		variable result: std_logic_vector(ARG'RANGE);
	begin
		result := (others => '0');
		for I in result'RANGE loop
			if (ARG(i) = '1') then
				result(i) := '1';
			end if;
		end loop;
		return(result);
	end;

	function slp_to_signed(ARG: std_logic_vector) return signed is
		variable result: signed(ARG'RANGE);
	begin
		result := (others => '0');
		for I in result'RANGE loop
			if (ARG(i) = '1') then
				result(i) := '1';
			end if;
		end loop;
		return(result);
	end;

	function slp_to_unsigned(ARG: std_logic_vector) return unsigned is
		variable result: unsigned(ARG'RANGE);
	begin
		result := (others => '0');
		for I in result'RANGE loop
			if (ARG(i) = '1') then
				result(i) := '1';
			end if;
		end loop;
		return(result);
	end;

end slp_bit_convfuncs;

