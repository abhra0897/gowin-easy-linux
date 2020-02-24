--
-- This file is written in an extended VHDL that maps functions
-- onto builtins for Synplify.  The numeric standard simulation 
-- package and package
-- body is available on a royalty basis from ieee.
--

-- ----------------------------------------------------------------------------
--   Title      : NUMERIC_STD arithmetic package for synthesis
--              : Rev. 1.8 (Dec. 14 1994)
--              :
--   Library    : This package shall be compiled into a library symbolically
--              : named IEEE.
--              :
--   Developers : IEEE DASC Synthesis Working Group, PAR 1076.3
--              :
--   Purpose    : This package defines numeric types and arithmetic functions
--              : for use with synthesis tools. Two numeric types are defined:
--              :     -- > UNSIGNED: represents UNSIGNED number in vector form
--              :     -- > SIGNED: represents a SIGNED number in vector form
--              : The base element type is type STD_LOGIC.
--              : The leftmost bit is treated as the most significant bit.
--              : Signed vectors are represented in two's complement form.
--              : This package contains overloaded arithmetic operators on
--              : the SIGNED and UNSIGNED types. The package also contains
--              : useful type conversions functions.
--              :
--              : If any argument to a function is a null array, a null array is
--              : returned (exceptions, if any, are noted individually).
--              :
--   Note       : No declarations or definitions shall be included in, or
--              : excluded from, this package. The package declaration declares
--              : the functions that can be used by a user. The package body
--              : shall be considered the formal definition of the semantics of
--              : this package. Tool developers may choose to implement the
--              : package body in the most efficient manner available to them.
--              :
--              : Rev. 2.4 (Apr. 12 1995)
--              : The functions D.5, D.6, D.7, D.8 does not exist in Rev 2.4.
--              : Thus, these functions are commented out to comply with
--              : IEEE standard.
--              :
-- ----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package NUMERIC_STD is

  --===========================================================================
  -- Numeric array type definitions
  --===========================================================================

  type UNSIGNED is array (NATURAL range <> ) of STD_LOGIC;
  type SIGNED is array (NATURAL range <> ) of STD_LOGIC;

  --===========================================================================
  -- Arithmetic Operators:
  --===========================================================================

  -- Id: A.1
  function "abs" (L: SIGNED) return SIGNED; -- in body
  -- Result subtype: SIGNED(L'LENGTH-1 downto 0).
  -- Result: Returns the absolute value of a SIGNED vector L.

  -- Id: A.2
  function "-" (ARG: SIGNED) return SIGNED  => "usminus";
  -- Result subtype: SIGNED(ARG'LENGTH-1 downto 0).
  -- Result: Returns the value of the unary minus operation on a
  --         SIGNED vector ARG.

  --============================================================================

  -- Id: A.3
  function "+" (L, R: UNSIGNED) return UNSIGNED => "plus";
  -- Result subtype: UNSIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Result: Adds two UNSIGNED vectors that may be of different lengths.

  -- Id: A.4
  function "+" (L, R: SIGNED) return SIGNED => "splus";
  -- Result subtype: SIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Result: Adds two SIGNED vectors that may be of different lengths.

  -- Id: A.5
  function "+" (L: UNSIGNED; R: NATURAL) return UNSIGNED => "plus";
  -- Result subtype: UNSIGNED(L'LENGTH-1 downto 0).
  -- Result: Adds an UNSIGNED vector, L, with a non-negative INTEGER, R.

  -- Id: A.6
  function "+" (L: NATURAL; R: UNSIGNED) return UNSIGNED => "plus";
  -- Result subtype: UNSIGNED(R'LENGTH-1 downto 0).
  -- Result: Adds a non-negative INTEGER, L, with an UNSIGNED vector, R.

  -- Id: A.7
  function "+" (L: INTEGER; R: SIGNED) return SIGNED => "splus";
  -- Result subtype: SIGNED(R'LENGTH-1 downto 0).
  -- Result: Adds an INTEGER, L(may be positive or negative), to a SIGNED
  --         vector, R.

  -- Id: A.8
  function "+" (L: SIGNED; R: INTEGER) return SIGNED => "splus";
  -- Result subtype: SIGNED(L'LENGTH-1 downto 0).
  -- Result: Adds a SIGNED vector, L, to an INTEGER, R.

  --============================================================================

  -- Id: A.9
  function "-" (L, R: UNSIGNED) return UNSIGNED => "minus";
  -- Result subtype: UNSIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Result: Subtracts two UNSIGNED vectors that may be of different lengths.

  -- Id: A.10
  function "-" (L, R: SIGNED) return SIGNED => "sminus";
  -- Result subtype: SIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Result: Subtracts a SIGNED vector, R, from another SIGNED vector, L,
  --         that may possibly be of different lengths.

  -- Id: A.11
  function "-" (L: UNSIGNED;R: NATURAL) return UNSIGNED => "minus";
  -- Result subtype: UNSIGNED(L'LENGTH-1 downto 0).
  -- Result: Subtracts a non-negative INTEGER, R, from an UNSIGNED vector, L.

  -- Id: A.12
  function "-" (L: NATURAL; R: UNSIGNED) return UNSIGNED => "minus";
  -- Result subtype: UNSIGNED(R'LENGTH-1 downto 0).
  -- Result: Subtracts an UNSIGNED vector, R, from a non-negative INTEGER, L.

  -- Id: A.13
  function "-" (L: SIGNED; R: INTEGER) return SIGNED => "sminus";
  -- Result subtype: SIGNED(L'LENGTH-1 downto 0).
  -- Result: Subtracts an INTEGER, R, from a SIGNED vector, L.

  -- Id: A.14
  function "-" (L: INTEGER; R: SIGNED) return SIGNED => "sminus";
  -- Result subtype: SIGNED(R'LENGTH-1 downto 0).
  -- Result: Subtracts a SIGNED vector, R, from an INTEGER, L.

  --============================================================================

  -- Id: A.15
  function "*" (L, R: UNSIGNED) return UNSIGNED => "mult";
  -- Result subtype: UNSIGNED((L'LENGTH+R'LENGTH-1) downto 0).
  -- Result: Performs the multiplication operation on two UNSIGNED vectors
  --         that may possibly be of different lengths.

  -- Id: A.16
  function "*" (L, R: SIGNED) return SIGNED => "smult";
  -- Result subtype: SIGNED((L'LENGTH+R'LENGTH-1) downto 0)
  -- Result: Multiplies two SIGNED vectors that may possibly be of
  --         different lengths.

  -- Id: A.17
  function "*" (L: UNSIGNED; R: NATURAL) return UNSIGNED => "nsmult";
  -- Result subtype: UNSIGNED((L'LENGTH+L'LENGTH-1) downto 0).
  -- Result: Multiplies an UNSIGNED vector, L, with a non-negative
  --         INTEGER, R. R is converted to an UNSIGNED vector of
  --         SIZE L'LENGTH before multiplication.

  -- Id: A.18
  function "*" (L: NATURAL; R: UNSIGNED) return UNSIGNED => "nsmult";
  -- Result subtype: UNSIGNED((R'LENGTH+R'LENGTH-1) downto 0).
  -- Result: Multiplies an UNSIGNED vector, R, with a non-negative
  --         INTEGER, L. L is converted to an UNSIGNED vector of
  --         SIZE R'LENGTH before multiplication.

  -- Id: A.19
  function "*" (L: SIGNED; R: INTEGER) return SIGNED => "nssmult";
  -- Result subtype: SIGNED((L'LENGTH+L'LENGTH-1) downto 0)
  -- Result: Multiplies a SIGNED vector, L, with an INTEGER, R. R is
  --         converted to a SIGNED vector of SIZE L'LENGTH before
  --         multiplication.

  -- Id: A.20
  function "*" (L: INTEGER; R: SIGNED) return SIGNED => "nssmult";
  -- Result subtype: SIGNED((R'LENGTH+R'LENGTH-1) downto 0)
  -- Result: Multiplies a SIGNED vector, R, with an INTEGER, L. L is
  --         converted to a SIGNED vector of SIZE R'LENGTH before
  --         multiplication.

  --============================================================================
  --
  --  NOTE: If second argument is zero for "/" operator, a severity level
  --        of ERROR is issued.

  -- Id: A.21
  function "/" (L, R: UNSIGNED) return UNSIGNED => "div";
  -- Result subtype: UNSIGNED(L'LENGTH-1 downto 0)
  -- Result: Divides an UNSIGNED vector, L, by another UNSIGNED vector, R.

  -- Id: A.22
  function "/" (L, R: SIGNED) return SIGNED => "div";
  -- Result subtype: SIGNED(L'LENGTH-1 downto 0)
  -- Result: Divides an SIGNED vector, L, by another SIGNED vector, R.

  -- Id: A.23
  function "/" (L: UNSIGNED; R: NATURAL) return UNSIGNED => "nsdiv";
  -- Result subtype: UNSIGNED(L'LENGTH-1 downto 0)
  -- Result: Divides an UNSIGNED vector, L, by a non-negative INTEGER, R.
  --         If NO_OF_BITS(R) > L'LENGTH, then R is truncated to L'LENGTH.

  -- Id: A.24
  function "/" (L: NATURAL; R: UNSIGNED) return UNSIGNED => "nsdiv";
  -- Result subtype: UNSIGNED(R'LENGTH-1 downto 0)
  -- Result: Divides a non-negative INTEGER, L, by an UNSIGNED vector, R.
  --         If NO_OF_BITS(L) > R'LENGTH, then L is truncated to R'LENGTH.

  -- Id: A.25
  function "/" (L: SIGNED; R: INTEGER) return SIGNED => "nssdiv";
  -- Result subtype: SIGNED(L'LENGTH-1 downto 0)
  -- Result: Divides a SIGNED vector, L, by an INTEGER, R.
  --         If NO_OF_BITS(R) > L'LENGTH, then R is truncated to L'LENGTH.

  -- Id: A.26
  function "/" (L: INTEGER; R: SIGNED) return SIGNED => "nssdiv";
  -- Result subtype: SIGNED(R'LENGTH-1 downto 0)
  -- Result: Divides an INTEGER, L, by a SIGNED vector, R.
  --         If NO_OF_BITS(L) > R'LENGTH, then L is truncated to R'LENGTH.

  --============================================================================
  --
  --  NOTE: If second argument is zero for "rem" operator, a severity level
  --        of ERROR is issued.

  -- Id: A.27
  function "rem" (L, R: UNSIGNED) return UNSIGNED => "nsrem";
  -- Result subtype: UNSIGNED(R'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where L and R are UNSIGNED vectors.

  -- Id: A.28
  function "rem" (L, R: SIGNED) return SIGNED => "nssrem";
  -- Result subtype: SIGNED(R'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where L and R are SIGNED vectors.

  -- Id: A.29
  function "rem" (L: UNSIGNED; R: NATURAL) return UNSIGNED => "nsrem";
  -- Result subtype: UNSIGNED(L'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where L is an UNSIGNED vector and R is a
  --         non-negative INTEGER.
  --         If NO_OF_BITS(R) > L'LENGTH, then R is truncated to L'LENGTH.

  -- Id: A.30
  function "rem" (L: NATURAL; R: UNSIGNED) return UNSIGNED => "nsrem";
  -- Result subtype: UNSIGNED(R'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where R is an UNSIGNED vector and L is a
  --         non-negative INTEGER.
  --         If NO_OF_BITS(L) > R'LENGTH, then L is truncated to R'LENGTH.

  -- Id: A.31
  function "rem" (L: SIGNED; R: INTEGER) return SIGNED => "nssrem";
  -- Result subtype: SIGNED(L'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where L is SIGNED vector and R is an INTEGER.
  --         If NO_OF_BITS(R) > L'LENGTH, then R is truncated to L'LENGTH.

  -- Id: A.32
  function "rem" (L: INTEGER; R: SIGNED) return SIGNED => "nssrem";
  -- Result subtype: SIGNED(R'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where R is SIGNED vector and L is an INTEGER.
  --         If NO_OF_BITS(L) > R'LENGTH, then L is truncated to R'LENGTH.

  --============================================================================
  --
  --  NOTE: If second argument is zero for "mod" operator, a severity level
  --        of ERROR is issued.

  -- Id: A.33
  function "mod" (L, R: UNSIGNED) return UNSIGNED => "nsmod";
  -- Result subtype: UNSIGNED(R'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where L and R are UNSIGNED vectors.

  -- Id: A.34
  function "mod" (L, R: SIGNED) return SIGNED;
  -- Result subtype: SIGNED(R'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where L and R are SIGNED vectors.

  -- Id: A.35
  function "mod" (L: UNSIGNED; R: NATURAL) return UNSIGNED => "nsmod";
  -- Result subtype: UNSIGNED(L'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where L is an UNSIGNED vector and R
  --         is a non-negative INTEGER.
  --         If NO_OF_BITS(R) > L'LENGTH, then R is truncated to L'LENGTH.

  -- Id: A.36
  function "mod" (L: NATURAL; R: UNSIGNED) return UNSIGNED => "nsmod";
  -- Result subtype: UNSIGNED(R'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where R is an UNSIGNED vector and L
  --         is a non-negative INTEGER.
  --         If NO_OF_BITS(L) > R'LENGTH, then L is truncated to R'LENGTH.

  -- Id: A.37
  function "mod" (L: SIGNED; R: INTEGER) return SIGNED => "nsmod";
  -- Result subtype: SIGNED(L'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where L is a SIGNED vector and
  --         R is an INTEGER.
  --         If NO_OF_BITS(R) > L'LENGTH, then R is truncated to L'LENGTH.

  -- Id: A.38
  function "mod" (L: INTEGER; R: SIGNED) return SIGNED => "nsmod";
  -- Result subtype: SIGNED(R'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where L is an INTEGER and
  --         R is a SIGNED vector.
  --         If NO_OF_BITS(L) > R'LENGTH, then L is truncated to R'LENGTH.

  --============================================================================
  -- Comparison Operators
  --============================================================================

  -- Id: C.1
  function ">" (L, R: UNSIGNED) return BOOLEAN => "ugt";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.2
  function ">" (L, R: SIGNED) return BOOLEAN => "sgt";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L and R are SIGNED vectors possibly
  --         of different lengths.

  -- Id: C.3
  function ">" (L: NATURAL; R: UNSIGNED) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.4
  function ">" (L: INTEGER; R: SIGNED) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L is a INTEGER and
  --         R is a SIGNED vector.

  -- Id: C.5
  function ">" (L: UNSIGNED; R: NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  -- Id: C.6
  function ">" (L: SIGNED; R: INTEGER) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L is a SIGNED vector and
  --         R is a INTEGER.

  --============================================================================

  -- Id: C.7
  function "<" (L, R: UNSIGNED) return BOOLEAN => "ult";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.8
  function "<" (L, R: SIGNED) return BOOLEAN => "slt";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L and R are SIGNED vectors possibly
  --         of different lengths.

  -- Id: C.9
  function "<" (L: NATURAL; R: UNSIGNED) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.10
  function "<" (L: INTEGER; R: SIGNED) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L is an INTEGER and
  --         R is a SIGNED vector.

  -- Id: C.11
  function "<" (L: UNSIGNED; R: NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  -- Id: C.12
  function "<" (L: SIGNED; R: INTEGER) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L is a SIGNED vector and
  --         R is an INTEGER.

  --============================================================================

  -- Id: C.13
  function "<=" (L, R: UNSIGNED) return BOOLEAN => "ule";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.14
  function "<=" (L, R: SIGNED) return BOOLEAN => "sle";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L and R are SIGNED vectors possibly
  --         of different lengths.

  -- Id: C.15
  function "<=" (L: NATURAL; R: UNSIGNED) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.16
  function "<=" (L: INTEGER; R: SIGNED) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L is an INTEGER and
  --         R is a SIGNED vector.

  -- Id: C.17
  function "<=" (L: UNSIGNED; R: NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  -- Id: C.18
  function "<=" (L: SIGNED; R: INTEGER) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L is a SIGNED vector and
  --         R is an INTEGER.

  --============================================================================

  -- Id: C.19
  function ">=" (L, R: UNSIGNED) return BOOLEAN => "uge";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.20
  function ">=" (L, R: SIGNED) return BOOLEAN => "sge";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L and R are SIGNED vectors possibly
  --         of different lengths.

  -- Id: C.21
  function ">=" (L: NATURAL; R: UNSIGNED) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.22
  function ">=" (L: INTEGER; R: SIGNED) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L is an INTEGER and
  --         R is a SIGNED vector.

  -- Id: C.23
  function ">=" (L: UNSIGNED; R: NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  -- Id: C.24
  function ">=" (L: SIGNED; R: INTEGER) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L is a SIGNED vector and
  --         R is an INTEGER.

  --============================================================================

  -- Id: C.25
  function "=" (L, R: UNSIGNED) return BOOLEAN => "eq";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.26
  function "=" (L, R: SIGNED) return BOOLEAN => "eq";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L and R are SIGNED vectors possibly
  --         of different lengths.

  -- Id: C.27
  function "=" (L: NATURAL; R: UNSIGNED) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.28
  function "=" (L: INTEGER; R: SIGNED) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L is an INTEGER and
  --         R is a SIGNED vector.

  -- Id: C.29
  function "=" (L: UNSIGNED; R: NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  -- Id: C.30
  function "=" (L: SIGNED; R: INTEGER) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L is a SIGNED vector and
  --         R is an INTEGER.

  --============================================================================

  -- Id: C.31
  function "/=" (L, R: UNSIGNED) return BOOLEAN => "noteq";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.32
  function "/=" (L, R: SIGNED) return BOOLEAN => "noteq";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L and R are SIGNED vectors possibly
  --         of different lengths.

  -- Id: C.33
  function "/=" (L: NATURAL; R: UNSIGNED) return BOOLEAN => "noteq";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.34
  function "/=" (L: INTEGER; R: SIGNED) return BOOLEAN => "noteq";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L is an INTEGER and
  --         R is a SIGNED vector.

  -- Id: C.35
  function "/=" (L: UNSIGNED; R: NATURAL) return BOOLEAN => "noteq";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  -- Id: C.36
  function "/=" (L: SIGNED; R: INTEGER) return BOOLEAN => "noteq";
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L is a SIGNED vector and
  --         R is an INTEGER.

  --============================================================================
  -- Shift and Rotate Functions
  --============================================================================

  -- Id: S.1
  function SHIFT_LEFT (ARG: UNSIGNED; COUNT: NATURAL) return UNSIGNED => "sll";
  -- Result subtype: UNSIGNED(ARG'LENGTH-1 downto 0)
  -- Result: Performs a shift-left on an UNSIGNED vector COUNT times.
  --         The vacated positions are filled with Bit '0'.
  -- The COUNT leftmost bits are lost.

  -- Id: S.2
  function SHIFT_RIGHT (ARG: UNSIGNED; COUNT: NATURAL) return UNSIGNED => "srl";
  -- Result subtype: UNSIGNED(ARG'LENGTH-1 downto 0)
  -- Result: Performs a shift-right on an UNSIGNED vector COUNT times.
  --         The vacated positions are filled with Bit '0'.
  --         The COUNT rightmost bits are lost.

  -- Id: S.3
  function SHIFT_LEFT (ARG: SIGNED; COUNT: NATURAL) return SIGNED => "sll";
  -- Result subtype: SIGNED(ARG'LENGTH-1 downto 0)
  -- Result: Performs a shift-left on a SIGNED vector COUNT times.
  --         The vacated positions are filled with Bit '0'.
  --         The COUNT leftmost bits, except ARG'LEFT, are lost.

  -- Id: S.4
  function SHIFT_RIGHT (ARG: SIGNED; COUNT: NATURAL) return SIGNED => "sra";
  -- Result subtype: SIGNED(ARG'LENGTH-1 downto 0)
  -- Result: Performs a shift-right on a SIGNED vector COUNT times.
  --         The vacated positions are filled with the leftmost bit, ARG'LEFT.
  --         The COUNT rightmost bits are lost.

  --============================================================================

  --============================================================================

  -- Id: S.5
  function ROTATE_LEFT (ARG: UNSIGNED; COUNT: NATURAL) return UNSIGNED => "rol";
  -- Result subtype: UNSIGNED(ARG'LENGTH-1 downto 0)
  -- Result: Performs a rotate_left of an UNSIGNED vector COUNT times.

  -- Id: S.6
  function ROTATE_RIGHT (ARG: UNSIGNED; COUNT: NATURAL) return UNSIGNED => "ror";
  -- Result subtype: UNSIGNED(ARG'LENGTH-1 downto 0)
  -- Result: Performs a rotate_right of an UNSIGNED vector COUNT times.

  -- Id: S.7
  function ROTATE_LEFT (ARG: SIGNED; COUNT: NATURAL) return SIGNED => "rol";
  -- Result subtype: SIGNED(ARG'LENGTH-1 downto 0)
  -- Result: Performs a logical rotate-left of a SIGNED
  --         vector COUNT times.

  -- Id: S.8
  function ROTATE_RIGHT (ARG: SIGNED; COUNT: NATURAL) return SIGNED => "ror";
  -- Result subtype: SIGNED(ARG'LENGTH-1 downto 0)
  -- Result: Performs a logical rotate-right of a SIGNED
  --         vector COUNT times.

  --============================================================================
 
  --============================================================================
 
  ------------------------------------------------------------------------------
  --   Note: Function S.9 is not compatible with IEEE Std 1076-1987. Comment
  --   out the function (declaration and body) for IEEE Std 1076-1987 compatibility.
  ------------------------------------------------------------------------------
  -- Id: S.9
  function "sll" (ARG: UNSIGNED; COUNT: INTEGER) return UNSIGNED => "sll";
  -- Result subtype: UNSIGNED(ARG'LENGTH-1 downto 0)
  -- Result: SHIFT_LEFT(ARG, COUNT)
 
  ------------------------------------------------------------------------------
  -- Note: Function S.10 is not compatible with IEEE Std 1076-1987. Comment
  --   out the function (declaration and body) for IEEE Std 1076-1987 compatibility.
  ------------------------------------------------------------------------------
  -- Id: S.10
  function "sll" (ARG: SIGNED; COUNT: INTEGER) return SIGNED => "sll";
  -- Result subtype: SIGNED(ARG'LENGTH-1 downto 0)
  -- Result: SHIFT_LEFT(ARG, COUNT)

  ------------------------------------------------------------------------------
  --   Note: Function S.11 is not compatible with IEEE Std 1076-1987. Comment
  --   out the function (declaration and body) for IEEE StdL 1076-1987 compatibility.
  ------------------------------------------------------------------------------
  -- Id: S.11
  function "srl" (ARG: UNSIGNED; COUNT: INTEGER) return UNSIGNED => "srl";
  -- Result subtype: UNSIGNED(ARG'LENGTH-1 downto 0)
  -- Result: SHIFT_RIGHT(ARG, COUNT)
 
  ------------------------------------------------------------------------------
  --   Note: Function S.12 is not compatible with IEEE Std 1076-1987. Comment
  --   out the function (declaration and body) for IEEE Std 1076-1987 compatibility.
  ------------------------------------------------------------------------------
  -- Id: S.12
  function "srl" (ARG: SIGNED; COUNT: INTEGER) return SIGNED => "srl";
  -- Result subtype: SIGNED(ARG'LENGTH-1 downto 0)
  -- Result: SIGNED(SHIFT_RIGHT(UNSIGNED(ARG), COUNT))
 
  ------------------------------------------------------------------------------
  -- Note: Function S.13 is not compatible with IEEE Std 1076-1987. Comment
  -- out the function (declaration and body) for IEEE Std 1076-1987 compatibility.
  ------------------------------------------------------------------------------
  -- Id: S.13
  function "rol" (ARG: UNSIGNED; COUNT: INTEGER) return UNSIGNED => "rol";
  -- Result subtype: UNSIGNED(ARG'LENGTH-1 downto 0)
  -- Result: ROTATE_LEFT(ARG, COUNT)
 
  ------------------------------------------------------------------------------
  -- Id: S.14
  function "rol" (ARG: SIGNED; COUNT: INTEGER) return SIGNED => "rol";
  -- Result subtype: SIGNED(ARG'LENGTH-1 downto 0)
  -- Result: ROTATE_LEFT(ARG, COUNT)
 
  ------------------------------------------------------------------------------
  -- Note: Function S.15 is not compatible with IEEE Std 1076-1987. Comment
  --   out the function (declaration and body) for IEEE Std 1076-1987 compatibility.
  ------------------------------------------------------------------------------
  -- Id: S.15
  function "ror" (ARG: UNSIGNED; COUNT: INTEGER) return UNSIGNED => "ror";
  -- Result subtype: UNSIGNED(ARG'LENGTH-1 downto 0)
  -- Result: ROTATE_RIGHT(ARG, COUNT)
 
  ------------------------------------------------------------------------------
  --   Note: Function S.16 is not compatible with IEEE Std 1076-1987. Comment
  --   out the function (declaration and body) for IEEE Std 1076-1987 compatibility.
  ------------------------------------------------------------------------------
  -- Id: S.16
  function "ror" (ARG: SIGNED; COUNT: INTEGER) return SIGNED => "ror";
  -- Result subtype: SIGNED(ARG'LENGTH-1 downto 0)
  -- Result: ROTATE_RIGHT(ARG, COUNT)
 

  --============================================================================
  --  RESIZE Functions
  --============================================================================

  -- Id: R.1
  function RESIZE (ARG: SIGNED; NEW_SIZE: NATURAL) return SIGNED;
  -- Result subtype: SIGNED(NEW_SIZE-1 downto 0)
  -- Result: ReSIZEs the SIGNED vector ARG to the specified SIZE.
  --         To create a larger vector, the new [leftmost] bit positions
  --         are filled with the sign bit (ARG'LEFT). When truncating,
  --         the sign bit is retained along with the rightmost part.

  -- Id: R.2
  function RESIZE (ARG: UNSIGNED; NEW_SIZE: NATURAL) return UNSIGNED => "trim";
  -- Result subtype: UNSIGNED(NEW_SIZE-1 downto 0)
  -- Result: ReSIZEs the SIGNED vector ARG to the specified SIZE.
  --         To create a larger vector, the new [leftmost] bit positions
  --         are filled with '0'. When truncating, the leftmost bits
  --         are dropped.


  --============================================================================
  -- Conversion Functions
  --============================================================================

  -- Id: D.1
  function TO_INTEGER (ARG: UNSIGNED) return NATURAL => "bufi";
  -- Result subtype: NATURAL. Value cannot be negative since parameter is an
  --                 UNSIGNED vector.
  -- Result: Converts the UNSIGNED vector to an INTEGER.

  -- Id: D.2
  function TO_INTEGER (ARG: SIGNED) return INTEGER => "bufsi";
  -- Result subtype: INTEGER
  -- Result: Converts a SIGNED vector to an INTEGER.

  -- Id: D.3
  function TO_UNSIGNED (ARG, SIZE: NATURAL) return UNSIGNED => "trim";
  -- Result subtype: UNSIGNED(SIZE-1 downto 0)
  -- Result: Converts a non-negative INTEGER to an UNSIGNED vector with
  --         the specified SIZE.

  -- Id: D.4
  function TO_SIGNED (ARG: INTEGER; SIZE: NATURAL) return SIGNED => "strim";
  -- Result subtype: SIGNED(SIZE-1 downto 0)
  -- Result: Converts an INTEGER to a SIGNED vector of the specified SIZE.

  -- D.5, D.6, D.7 and D.8 are commented out, since these functions
  -- are not in IEEE NUMERIC_STD package, Rev 2.4, April 12, 1995
  -- Id: D.5
  -- function TO_UNSIGNED (ARG: STD_LOGIC_VECTOR) return UNSIGNED => "buf";
  -- Result subtype: UNSIGNED(ARG'RANGE)
  -- Result: Converts STD_LOGIC_VECTOR to UNSIGNED.

  -- Id: D.6
  -- function TO_SIGNED (ARG: STD_LOGIC_VECTOR) return SIGNED => "buf";
  -- Result subtype: SIGNED(ARG'RANGE)
  -- Result: Converts STD_LOGIC_VECTOR to SIGNED.

  -- Id: D.7
  -- function TO_STDLOGICVECTOR (ARG: UNSIGNED) return STD_LOGIC_VECTOR => "buf";
  -- Result subtype: STD_LOGIC_VECTOR(ARG'RANGE)
  -- Result: Converts UNSIGNED to STD_LOGIC_VECTOR.

  -- Id: D.8
  -- function TO_STDLOGICVECTOR (ARG: SIGNED) return STD_LOGIC_VECTOR => "buf";
  -- Result subtype: STD_LOGIC_VECTOR(ARG'RANGE)
  -- Result: Converts SIGNED to STD_LOGIC_VECTOR.

  --============================================================================
  -- Logical Operators
  --============================================================================

  -- Id: L.1
  function "not" (L: UNSIGNED) return UNSIGNED => "not";
  -- Result subtype: UNSIGNED, same range as input L
  -- Result: Termwise inversion

  -- Id: L.2
  function "and" (L, R: UNSIGNED) return UNSIGNED => "and";
  -- Result subtype: UNSIGNED, same range as input L
  -- Result: Vector AND operation

  -- Id: L.3
  function "or" (L, R: UNSIGNED) return UNSIGNED => "or";
  -- Result subtype: UNSIGNED, same range as input L
  -- Result: Vector OR operation

  -- Id: L.4
  function "nand" (L, R: UNSIGNED) return UNSIGNED => "nand";
  -- Result subtype: UNSIGNED, same range as input L
  -- Result: Vector NAND operation

  -- Id: L.5
  function "nor" (L, R: UNSIGNED) return UNSIGNED => "nor";
  -- Result subtype: UNSIGNED, same range as input L
  -- Result: Vector NOR operation

  -- Id: L.6
  function "xor" (L, R: UNSIGNED) return UNSIGNED => "xor";
  -- Result subtype: UNSIGNED, same range as input L
  -- Result: Vector XOR operation

  --  -----------------------------------------------------------------------
  --  Note : The declaration and implementation of the "xnor" function is
  --  specifically commented until at which time the VHDL language has been
  --  officially adopted as containing such a function. At such a point,
  --  the following comments may be removed along with this notice without
  --  further "official" ballotting of this 1076.3 package. It is
  --  the intent of this effort to provide such a function once it becomes
  --  available in the VHDL standard.
  --  -----------------------------------------------------------------------
  -- Id: L.7
  function "xnor" (L, R: UNSIGNED) return UNSIGNED => "xnor";
  -- Result subtype: UNSIGNED, same range as input L
  -- Result: Vector XNOR operation

  -- Id: L.8
  function "not" (L: SIGNED) return SIGNED => "not";
  -- Result subtype: SIGNED, same range as input L
  -- Result: Termwise inversion

  -- Id: L.9
  function "and" (L, R: SIGNED) return SIGNED => "and";
  -- Result subtype: SIGNED, same range as input L
  -- Result: Vector AND operation

  -- Id: L.10
  function "or" (L, R: SIGNED) return SIGNED => "or";
  -- Result subtype: SIGNED, same range as input L
  -- Result: Vector OR operation

  -- Id: L.11
  function "nand" (L, R: SIGNED) return SIGNED => "nand";
  -- Result subtype: SIGNED, same range as input L
  -- Result: Vector NAND operation

  -- Id: L.12
  function "nor" (L, R: SIGNED) return SIGNED => "nor";
  -- Result subtype: SIGNED, same range as input L
  -- Result: Vector NOR operation

  -- Id: L.13
  function "xor" (L, R: SIGNED) return SIGNED => "xor";
  -- Result subtype: SIGNED, same range as input L
  -- Result: Vector XOR operation

  --  -----------------------------------------------------------------------
  --  Note : The declaration and implementation of the "xnor" function is
  --  specifically commented until at which time the VHDL language has been
  --  officially adopted as containing such a function. At such a point,
  --  the following comments may be removed along with this notice without
  --  further "official" ballotting of this 1076.3 package. It is
  --  the intent of this effort to provide such a function once it becomes
  --  available in the VHDL standard.
  --  -----------------------------------------------------------------------
  -- Id: L.14
  function "xnor" (L, R: SIGNED) return SIGNED => "xnor";
  -- Result subtype: SIGNED, same range as input L
  -- Result: Vector XNOR operation

  --============================================================================
  -- Match Functions
  --============================================================================

  -- Id: M.1
  function STD_MATCH (L, R: STD_ULOGIC) return BOOLEAN;
  -- Result: terms compared per STD_LOGIC_1164 intent

  -- Id: M.2
  function STD_MATCH (L, R: UNSIGNED) return BOOLEAN;
  -- Result: terms compared per STD_LOGIC_1164 intent

  -- Id: M.3
  function STD_MATCH (L, R: SIGNED) return BOOLEAN;
  -- Result: terms compared per STD_LOGIC_1164 intent

  -- Id: M.4
  function STD_MATCH (L, R: STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result: terms compared per STD_LOGIC_1164 intent

  -- Id: M.5
  function STD_MATCH (L, R: STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result: termwise comparison per STD_LOGIC_1164 intent

  --============================================================================
  -- Translation Functions
  --============================================================================

  -- Id: T.1
  function TO_01 (S: UNSIGNED; XMAP:STD_LOGIC := '0') return UNSIGNED => "buf";
  -- Result: Termwise, 'h' is translated to '1' and 'l' is translated
  --         to '0'. If a value other than '0'|'1'|'h'|'l' is found,
  --         the array is set to (others => xmap), and a warning is
  --         issued. S'Range is preserved.

  -- Id: T.2
  function TO_01 (S: SIGNED; XMAP:STD_LOGIC := '0') return SIGNED => "buf";
  -- Result: Termwise, 'h' is translated to '1' and 'l' is translated
  --         to '0'. If a value other than '0'|'1'|'h'|'l' is found,
  --         the array is set to (others => xmap), and a warning is
  --         issued. S'Range is preserved.

  function reminder (x : signed; y : signed; width:integer) return signed;

end NUMERIC_STD;

library ieee;
use ieee.std_logic_1164.all;
package body NUMERIC_STD is
	function number_of_bits_unsigned(num : natural) return natural is
		variable tmp, number_of_bits : natural;
	begin
		tmp := num;
		number_of_bits := 1;
		while tmp > 1 loop
			number_of_bits := number_of_bits+1;
			tmp := tmp/2;
		end loop;
		return number_of_bits;
	end number_of_bits_unsigned;
	function number_of_bits_signed (num: integer) return natural is
		variable number_of_bits: natural;
		variable tmp: natural;
	begin
		tmp := num;
		if num < 0 then
		  tmp := -(num+1);
		end if;
		number_of_bits := 1;
		while tmp > 0 loop
		  number_of_bits := number_of_bits+1;
		  tmp := tmp / 2;
		end loop;
		return number_of_bits;
	end number_of_bits_signed;
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
    function STD_MATCH (L, R: STD_ULOGIC) return BOOLEAN is
		variable result : boolean;
		variable dashnotfound : boolean;
	begin
		result := false;
		dashnotfound := false;
		if not (L = '-'  or R = '-') then
			dashnotfound := true;
			result := L = R;
		end if;
		return (result or (not dashnotfound));
	end;
    function STD_MATCH (L, R: UNSIGNED) return BOOLEAN is
		variable result : boolean;
		variable i : integer;
		variable la, ra : UNSIGNED(L'length - 1 downto 0);
		variable lai, rai : std_logic;
    begin
		la := L;
		ra := R;
		for i in 0 to L'length - 1 loop
			lai := la(i);
			rai := ra(i);
			if not (lai = '-' or rai = '-') then
				result := (lai = rai);
				if(not result) then
					return(FALSE);
				end if;
			else
				result := true;
			end if;
		end loop;
		return(TRUE);
    end;
    function STD_MATCH (L, R: SIGNED) return BOOLEAN is
		variable result : boolean;
		variable i : integer;
		variable la, ra : SIGNED(L'length - 1 downto 0);
		variable lai, rai : std_logic;
    begin
		la := L;
		ra := R;
		for i in 0 to L'length - 1 loop
			lai := la(i);
			rai := ra(i);
			if not (lai = '-' or rai = '-') then
				result := (lai = rai);
				if(not result) then
					return(FALSE);
				end if;
			else
				result := true;
			end if;
		end loop;
		return(TRUE);
    end;
    function STD_MATCH (L, R: std_logic_vector) return BOOLEAN is
		variable result : boolean;
		variable i : integer;
		variable la, ra : std_logic_vector(L'length - 1 downto 0);
		variable lai, rai : std_logic;
    begin
		la := L;
		ra := R;
		for i in 0 to L'length - 1 loop
			lai := la(i);
			rai := ra(i);
			if not (lai = '-' or rai = '-') then
				result := (lai = rai);
				if(not result) then
					return(FALSE);
				end if;
			else
				result := true;
			end if;
		end loop;
		return(TRUE);
    end;
    function STD_MATCH (L, R: std_ulogic_vector) return BOOLEAN is
		variable result : boolean;
		variable i : integer;
		variable la, ra : std_ulogic_vector(L'length - 1 downto 0);
		variable lai, rai : std_ulogic;
    begin
		la := L;
		ra := R;
		for i in 0 to L'length - 1 loop
			lai := la(i);
			rai := ra(i);
			if not (lai = '-' or rai = '-') then
				result := (lai = rai);
				if(not result) then
					return(FALSE);
				end if;
			else
				result := true;
			end if;
		end loop;
		return(TRUE);
    end;

    function resize (ARG: SIGNED; NEW_SIZE: NATURAL) return SIGNED is
            alias bits: SIGNED(ARG'LENGTH-1 downto 0) is ARG;
            variable result: SIGNED(NEW_SIZE-1 downto 0) := (others => '0');
            constant argLen: INTEGER := ARG'LENGTH;
    begin
            if (argLen = NEW_SIZE) then
                 return bits;
            end if;

            result := (others => ARG(ARG'LEFT));
            if (NEW_SIZE < 2) then
                return result;
            end if;

            if (NEW_SIZE < 2 or argLen < 2) then
                 return result;
            elsif (argLen < NEW_SIZE) then
                 result(argLen-2 downto 0) := bits(argLen-2 downto 0);
            else
                 result(NEW_SIZE-2 downto 0) := bits(NEW_SIZE-2 downto 0);
            end if;
            return result;
    end;
	function "<" (L: UNSIGNED; R: NATURAL) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_unsigned(R);
		if numbits > L'LENGTH then
			return TRUE;
		end if;
		return "<"(L, TO_UNSIGNED(R, L'LENGTH));
	end;

	function "<" (L: NATURAL; R: UNSIGNED) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_unsigned(L);
		if numbits > R'LENGTH then
			return FALSE;
		end if;
		return "<"(TO_UNSIGNED(L, R'LENGTH), R);
	end;

	function "<" (L: INTEGER; R: SIGNED) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_signed(L);
		if numbits > R'LENGTH then
			return L < 0;
		end if;
		return "<"(TO_SIGNED(L, R'LENGTH), R);
	end "<";

	function "<"(L: SIGNED; R: INTEGER) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_signed(R);
		if numbits > L'LENGTH then
			return 0 < R;
		end if;
		return "<"(L, TO_SIGNED(R, L'LENGTH));
	end "<";

      function ">" (L: UNSIGNED; R: NATURAL) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_unsigned(R);
		if numbits > L'LENGTH then
			return FALSE;
		end if;
		return ">"(L, TO_UNSIGNED(R, L'LENGTH));
	end;

	function ">" (L: NATURAL; R: UNSIGNED) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_unsigned(L);
		if numbits > R'LENGTH then
			return TRUE;
		end if;
		return ">"(TO_UNSIGNED(L, R'LENGTH), R);
	end;

	function ">" (L: INTEGER; R: SIGNED) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_signed(L);
		if numbits > R'LENGTH then
			return L > 0;
		end if;
		return ">"(TO_SIGNED(L, R'LENGTH), R);
	end ">";

	function ">"(L: SIGNED; R: INTEGER) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_signed(R);
		if numbits > L'LENGTH then
			return 0 > R;
		end if;
		return ">"(L, TO_SIGNED(R, L'LENGTH));
	end ">";


	function "<=" (L: UNSIGNED; R: NATURAL) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_unsigned(R);
		if numbits > L'LENGTH then
			return TRUE;
		end if;
		return "<="(L, TO_UNSIGNED(R, L'LENGTH));
	end;

	function "<=" (L: NATURAL; R: UNSIGNED) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_unsigned(L);
		if numbits > R'LENGTH then
			return FALSE;
		end if;
		return "<="(TO_UNSIGNED(L, R'LENGTH), R);
	end;

	function "<=" (L: INTEGER; R: SIGNED) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_signed(L);
		if numbits > R'LENGTH then
			return L < 0;
		end if;
		return "<="(TO_SIGNED(L, R'LENGTH), R);
	end "<=";

	function "<="(L: SIGNED; R: INTEGER) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_signed(R);
		if numbits > L'LENGTH then
			return 0 < R;
		end if;
		return "<="(L, TO_SIGNED(R, L'LENGTH));
	end "<=";

      function ">=" (L: UNSIGNED; R: NATURAL) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_unsigned(R);
		if numbits > L'LENGTH then
			return FALSE;
		end if;
		return ">="(L, TO_UNSIGNED(R, L'LENGTH));
	end;

	function ">=" (L: NATURAL; R: UNSIGNED) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_unsigned(L);
		if numbits > R'LENGTH then
			return TRUE;
		end if;
		return ">="(TO_UNSIGNED(L, R'LENGTH), R);
	end;

	function ">=" (L: INTEGER; R: SIGNED) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_signed(L);
		if numbits > R'LENGTH then
			return L > 0;
		end if;
		return ">="(TO_SIGNED(L, R'LENGTH), R);
	end ">=";

	function ">="(L: SIGNED; R: INTEGER) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_signed(R);
		if numbits > L'LENGTH then
			return 0 > R;
		end if;
		return ">="(L, TO_SIGNED(R, L'LENGTH));
	end ">=";


	function "="(L: SIGNED; R: INTEGER) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_signed(R);
		if(numbits > L'LENGTH) then
			return(FALSE);
		else
			return "="(L, TO_SIGNED(R, L'LENGTH));
		end if;
	end "=";
	
	function "="(L: INTEGER; R: SIGNED) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_signed(L);
		if(numbits > R'LENGTH) then
			return(FALSE);
		else
			return "="(R, TO_SIGNED(L, R'LENGTH));
		end if;
	end "=";

      function "="(L: UNSIGNED; R: NATURAL) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_unsigned(R);
		if(numbits > L'LENGTH) then
			return(FALSE);
		else
			return "="(L, TO_UNSIGNED(R, L'LENGTH));
		end if;
	end "=";
	
	function "="(L: NATURAL; R: UNSIGNED) return BOOLEAN is
	variable numbits: NATURAL;
	begin
		numbits := number_of_bits_unsigned(L);
		if(numbits > R'LENGTH) then
			return(FALSE);
		else
			return "="(R, TO_UNSIGNED(L, R'LENGTH));
		end if;
	end "=";


	function "mod" (L, R: SIGNED) return SIGNED is
	variable result : signed(R'length-1 downto 0);
	variable remainder : unsigned(R'length-1 downto 0);
	variable tmpl : unsigned(L'length-1 downto 0);
	variable tmpr : unsigned(R'length-1 downto 0);
	variable widtha : integer := L'length;
	variable widthb : integer := R'length;
	variable rightneg: BOOLEAN := FALSE;
	begin
		if (L(L'LEFT) = '1') then
			tmpl := unsigned(-L);
		else
			tmpl := unsigned(L);
		end if;
		if (R(R'LEFT) = '1') then
			tmpr := unsigned(-R);
			rightneg := TRUE;
		else
			tmpr := unsigned(R);
		end if;
		if(R = 0) then
			result := (others => '0');
		else	 
			--remainder
			remainder := "rem"(tmpl,tmpr);
			if rightneg and L(L'LEFT)='1' then
			  remainder := "0"-remainder;
			elsif rightneg and remainder/="0" then
			  remainder := remainder-tmpr;
			elsif L(L'LEFT)='1' and remainder/="0" then
			  remainder := tmpr-remainder;
				end if;
			result := SIGNED(remainder);
		end if;
		return result;
	end "mod";

end NUMERIC_STD;