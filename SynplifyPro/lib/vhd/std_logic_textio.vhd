--
-- This version of the STD_LOGIC_TEXTIO package is
-- Specific to Synplify and is not usable for simulation
-- Copyright (c) 2002, Synplicity, Inc. All rights reserved
--
--
----------------------------------------------------------------------------
--
-- Copyright (c) 1990, 1991, 1992 by Synopsys, Inc.  All rights reserved.
-- 
-- This source file may be used and distributed without restriction 
-- provided that this copyright statement is not removed from the file 
-- and that any derivative work contains this copyright notice.
--
--	Package name: STD_LOGIC_TEXTIO
--
--	Purpose: This package overloads the standard TEXTIO procedures
--		 READ and WRITE.
--
--	Author: CRC, TS
--
----------------------------------------------------------------------------

use STD.textio.all;
library IEEE;
use IEEE.std_logic_1164.all;

package std_logic_textio is
--synopsys synthesis_off
	-- Read and Write procedures for STD_ULOGIC and STD_ULOGIC_VECTOR
	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC);
	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC; GOOD: out BOOLEAN);
	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR);
	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR; GOOD: out BOOLEAN);

	-- Read and Write procedures for STD_LOGIC_VECTOR
	procedure READ(L:inout LINE; VALUE:out STD_LOGIC_VECTOR);
	procedure READ(L:inout LINE; VALUE:out STD_LOGIC_VECTOR; GOOD: out BOOLEAN);

	procedure HREAD(L:inout LINE; VALUE:out BIT_VECTOR);
	procedure HREAD(L:inout LINE; VALUE:out BIT_VECTOR; GOOD: out BOOLEAN);

	-- Hex Read procedures for STD_ULOGIC_VECTOR
	procedure HREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR);
	procedure HREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR; GOOD: out BOOLEAN);
	-- Hex Read procedures for STD_LOGIC_VECTOR
	procedure HREAD(L:inout LINE; VALUE:out STD_LOGIC_VECTOR);
	procedure HREAD(L:inout LINE; VALUE:out STD_LOGIC_VECTOR; GOOD: out BOOLEAN);

	procedure OREAD(L:inout LINE; VALUE:out BIT_VECTOR);
	procedure OREAD(L:inout LINE; VALUE:out BIT_VECTOR; GOOD: out BOOLEAN);

	-- Octal Read procedures for STD_ULOGIC_VECTOR
	procedure OREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR);
	procedure OREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR; GOOD: out BOOLEAN);
	-- Octal Read procedures for STD_LOGIC_VECTOR
	procedure OREAD(L:inout LINE; VALUE:out STD_LOGIC_VECTOR);
	procedure OREAD(L:inout LINE; VALUE:out STD_LOGIC_VECTOR; GOOD: out BOOLEAN);

	function v_read_l_to_sul_check(L:LINE) return boolean => "read_l_to_sul_check";
	function v_read_l_to_sul(L:LINE) return std_ulogic => "read_l_to_sul";
	function v_read_l_to_sulv_check(L:LINE; len:natural) return boolean => "read_l_to_sulv_check";
	function v_read_l_to_sulv(L:LINE; len:natural) return std_ulogic_vector => "read_l_to_sulv";
	function v_hread_l_to_bitv(L: LINE; len:natural) return bit_vector => "hread_l_to_bitv";
	function v_hread_l_to_bitv_check(L: LINE; len:natural) return boolean => "hread_l_to_bitv_check";
	function v_oread_l_to_bitv(L: LINE; len:natural) return bit_vector => "oread_l_to_bitv";
	function v_oread_l_to_bitv_check(L: LINE; len:natural) return boolean => "oread_l_to_bitv_check";

	
--synopsys synthesis_on
end std_logic_textio;

package body std_logic_textio is
--synopsys synthesis_off

	-- Type and constant definitions used to map STD_ULOGIC values 
	-- into/from character values.

	type MVL9plus is ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-', ERROR);
	type char_indexed_by_MVL9 is array (STD_ULOGIC) of character;
	type MVL9_indexed_by_char is array (character) of STD_ULOGIC;
	type MVL9plus_indexed_by_char is array (character) of MVL9plus;

	constant MVL9_to_char: char_indexed_by_MVL9 := "UX01ZWLH-";
	constant char_to_MVL9: MVL9_indexed_by_char := 
		('U' => 'U', 'X' => 'X', '0' => '0', '1' => '1', 'Z' => 'Z',
		 'W' => 'W', 'L' => 'L', 'H' => 'H', '-' => '-', others => 'U');
	constant char_to_MVL9plus: MVL9plus_indexed_by_char := 
		('U' => 'U', 'X' => 'X', '0' => '0', '1' => '1', 'Z' => 'Z',
		 'W' => 'W', 'L' => 'L', 'H' => 'H', '-' => '-', others => ERROR);


	-- Overloaded procedures.

	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC; GOOD:out BOOLEAN) is
	begin
		good := v_read_l_to_sul_check(L);
		value := v_read_l_to_sul(L);
	end READ;

	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR; GOOD:out BOOLEAN) is
		variable len: natural := value'length;
	begin
		good := v_read_l_to_sulv_check(L, len);
		value := v_read_l_to_sulv(L, len);
	end READ;
	
	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC) is
	begin
		value := v_read_l_to_sul(L);
	end READ;

	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR) is
		variable len: natural := value'length;
	begin
		value := v_read_l_to_sulv(L, len);
	end READ;

	-- Read procedures for STD_LOGIC_VECTOR
	procedure READ(L:inout LINE; VALUE:out STD_LOGIC_VECTOR) is
		variable tmp: STD_ULOGIC_VECTOR(VALUE'length-1 downto 0);
	begin
		READ(L, tmp);
		VALUE := STD_LOGIC_VECTOR(tmp);
	end READ;

	procedure READ(L:inout LINE; VALUE:out STD_LOGIC_VECTOR; GOOD: out BOOLEAN) is
		variable tmp: STD_ULOGIC_VECTOR(VALUE'length-1 downto 0);
	begin
		READ(L, tmp, GOOD);
		VALUE := STD_LOGIC_VECTOR(tmp);
	end READ;

	procedure HREAD(L:inout LINE; VALUE:out BIT_VECTOR)  is
		variable len : natural := VALUE'length;
	begin
		value := v_hread_l_to_bitv(L, len);
	end HREAD;

	procedure HREAD(L:inout LINE; VALUE:out BIT_VECTOR; GOOD:out BOOLEAN)  is
		variable len : natural := VALUE'length;
	begin
		good := v_hread_l_to_bitv_check(L, len);
		value := v_hread_l_to_bitv(L, len);
	end HREAD;

	-- Hex Read procedures for STD_ULOGIC_VECTOR
	procedure HREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR;GOOD:out BOOLEAN) is
		variable tmp: bit_vector(VALUE'length-1 downto 0);
	begin
		HREAD(L, tmp, GOOD);
		VALUE := To_X01(tmp);
	end HREAD;
	
	procedure HREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR) is
		variable tmp: bit_vector(VALUE'length-1 downto 0);
	begin
		HREAD(L, tmp);
		VALUE := To_X01(tmp);
	end HREAD;
	-- Hex Read procedures for STD_LOGIC_VECTOR

	procedure HREAD(L:inout LINE; VALUE:out STD_LOGIC_VECTOR) is
		variable tmp: STD_ULOGIC_VECTOR(VALUE'length-1 downto 0);
	begin
		HREAD(L, tmp);
		VALUE := STD_LOGIC_VECTOR(tmp);
	end HREAD;

	procedure HREAD(L:inout LINE; VALUE:out STD_LOGIC_VECTOR; GOOD: out BOOLEAN) is
		variable tmp: STD_ULOGIC_VECTOR(VALUE'length-1 downto 0);
	begin
		HREAD(L, tmp, GOOD);
		VALUE := STD_LOGIC_VECTOR(tmp);
	end HREAD;

	procedure OREAD(L:inout LINE; VALUE:out BIT_VECTOR)  is
		variable len : natural := VALUE'length;
	begin
		value := v_oread_l_to_bitv(L, len);
	end OREAD;

	procedure OREAD(L:inout LINE; VALUE:out BIT_VECTOR; GOOD:out BOOLEAN)  is
		variable len : natural := VALUE'length;
	begin
		good := v_oread_l_to_bitv_check(L, len);
		value := v_oread_l_to_bitv(L, len);
	end OREAD;

	-- Octal Read procedures for STD_ULOGIC_VECTOR
	procedure OREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR;GOOD:out BOOLEAN) is
		variable tmp: bit_vector(VALUE'length-1 downto 0);
	begin
		OREAD(L, tmp, GOOD);
		VALUE := To_X01(tmp);
	end OREAD;
	
	procedure OREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR) is
		variable tmp: bit_vector(VALUE'length-1 downto 0);
	begin
		OREAD(L, tmp);
		VALUE := To_X01(tmp);
	end OREAD;
	-- Octal Read procedures for STD_LOGIC_VECTOR

	procedure OREAD(L:inout LINE; VALUE:out STD_LOGIC_VECTOR) is
		variable tmp: STD_ULOGIC_VECTOR(VALUE'length-1 downto 0);
	begin
		OREAD(L, tmp);
		VALUE := STD_LOGIC_VECTOR(tmp);
	end OREAD;

	procedure OREAD(L:inout LINE; VALUE:out STD_LOGIC_VECTOR; GOOD: out BOOLEAN) is
		variable tmp: STD_ULOGIC_VECTOR(VALUE'length-1 downto 0);
	begin
		OREAD(L, tmp, GOOD);
		VALUE := STD_LOGIC_VECTOR(tmp);
	end OREAD;
--synopsys synthesis_on
end std_logic_textio;
