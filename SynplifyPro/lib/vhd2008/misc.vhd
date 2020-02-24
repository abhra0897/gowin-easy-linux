--------------------------------------------------------------------------
--
-- Copyright (c) 1990, 1991, 1992 by Synopsys, Inc.  All rights reserved.
-- 
-- This source file may be used and distributed without restriction 
-- provided that this copyright statement is not removed from the file 
-- and that any derivative work contains this copyright notice.
--
--	Package name: std_logic_misc
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions for the Std_logic_1164 Package.
--
--	Author:  GWH
--
-- Modified by KSM for Synplify
-- This is a stripped down version without all the simulation stuff
-- and the references to Synposys libraries.
-- This version is still missing the functions that deal with
-- signal strength.  Some of them are not really appropriate for
-- synthesis
--------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package std_logic_misc is
	function Drive (V: STD_ULOGIC_VECTOR) return STD_LOGIC_VECTOR => "buf";

	function Drive (V: STD_LOGIC_VECTOR) return STD_ULOGIC_VECTOR => "buf";

    -- comment out the functions below for VHDL 2008 (conflict between std_ulogic_vector and std_logic_vector)
    -- In VHDL 2008 we only need the std_ulogic_vector functions
--	function AND_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01;
--	function NAND_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01;
--	function OR_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01;
--	function NOR_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01;
--	function XOR_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01;
--	function XNOR_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01;

	function AND_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01;
	function NAND_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01;
	function OR_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01;
	function NOR_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01;
	function XOR_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01;
	function XNOR_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01;

	function fun_MUX2x1(Input0, Input1, Sel: UX01) return UX01;

	function fun_MAJ23(Input0, Input1, Input2: UX01) return UX01;
end;


package body std_logic_misc is

    -- comment out the functions below for VHDL 2008 (conflict between std_ulogic_vector and std_logic_vector)
    -- In VHDL 2008 we only need the std_ulogic_vector functions
    
--    function AND_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01 is
--	variable result: STD_LOGIC;
--    begin
--	result := '1';
--	for i in ARG'range loop
--	    result := result and ARG(i);
--	end loop;
--        return result;
--    end;
--
--    function NAND_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01 is
--    begin
--        return not AND_REDUCE(ARG);
--    end;
--
--    function OR_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01 is
--	variable result: STD_LOGIC;
--    begin
--	result := '0';
--	for i in ARG'range loop
--	    result := result or ARG(i);
--	end loop;
--        return result;
--    end;
--
--    function NOR_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01 is
--    begin
--        return not OR_REDUCE(ARG);
--    end;
--
--    function XOR_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01 is
--	variable result: STD_LOGIC;
--    begin
--	result := '0';
--	for i in ARG'range loop
--	    result := result xor ARG(i);
--	end loop;
--        return result;
--    end;
--
--    function XNOR_REDUCE(ARG: STD_LOGIC_VECTOR) return UX01 is
--    begin
--        return not XOR_REDUCE(ARG);
--    end;

    function AND_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01 is
	variable result: STD_LOGIC;
    begin
	result := '1';
	for i in ARG'range loop
	    result := result and ARG(i);
	end loop;
        return result;
    end;

    function NAND_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01 is
    begin
        return not AND_REDUCE(ARG);
    end;

    function OR_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01 is
	variable result: STD_LOGIC;
    begin
	result := '0';
	for i in ARG'range loop
	    result := result or ARG(i);
	end loop;
        return result;
    end;

    function NOR_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01 is
    begin
        return not OR_REDUCE(ARG);
    end;

    function XOR_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01 is
	variable result: STD_LOGIC;
    begin
	result := '0';
	for i in ARG'range loop
	    result := result xor ARG(i);
	end loop;
        return result;
    end;

    function XNOR_REDUCE(ARG: STD_ULOGIC_VECTOR) return UX01 is
    begin
        return not XOR_REDUCE(ARG);
    end;

    function fun_MUX2x1(Input0, Input1, Sel: UX01) return UX01 is
	variable m : UX01;
    begin
	if Sel = '1' then
		m := Input1;
	else
		m := Input0;
	end if;
	return m;
    end fun_MUX2x1;
    function fun_MAJ23(Input0, Input1, Input2: UX01) return UX01 is
    begin
	return ((Input0 and Input1) or (Input0 and Input2) or
		(Input1 and Input2));
    end fun_MAJ23;
end;