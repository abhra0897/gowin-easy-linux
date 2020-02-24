-----------------------------------------------------------------------------
--                                                                         --
-- Copyright (c) 1999 by Synplicity, Inc.  All rights reserved.            --
--                                                                         --
-- This source file may be used and distributed without restriction        --
-- provided that this copyright statement is not removed from the file     --
-- and that any derivative work contains this copyright notice.            --
--                                                                         --
--                                                                         --
--  Library name: synplify                                                 --
--  Package name: utilities
--                                                                         --
--  Description:  This package contains declarations for synplify          --
--                attributes                                               --
--                                                                         --
--                                                                         --
--                                                                         --
-----------------------------------------------------------------------------
-- Author:  Ken McElvain, Synplicity Inc.
--
library ieee;
use ieee.std_logic_1164.all;
package utilities is
	-- convert integer to string
	function int_image(i : integer) return string;
	-- make a xilinx RLOC string
	function make_rloc(row, col : integer; suf : string) return string;
end package utilities;

package body utilities is
	type mystring is array (natural range <>) of character;
	constant digits : mystring(0 to 9) := "0123456789";

	function int_image(i : integer) return string is
		variable j : integer;
	begin
		if(i < 10) then
			return string(digits(i to i));
		else
			j := i mod 10;
			return int_image(i / 10) & string(digits(j to j));
		end if;
	end function int_image;

	function make_rloc(row, col : integer; suf : string) return string is
	begin
		if suf'length = 0 then
			return 'R' & int_image(row) & 'C' & int_image(col);
		else
			return 'R' & int_image(row) & 'C' & int_image(col) & '.' & suf;
		end if;
	end function make_rloc;
end package body utilities;
