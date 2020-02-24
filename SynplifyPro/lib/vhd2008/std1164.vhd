--
-- This is a heavily customized version of the std_logic_1164 package
-- For Synplify VHDL Synthesis.
-- This file is not suitable for use with simulation.
-- $Header: //synplicity/compdevb/compilers/vhdl/vhd/std1164.vhd#2 $
-- --------------------------------------------------------------------
--
--   Title     :  std_logic_1164 multi-value logic system
--   Library   :  This package shall be compiled into a library 
--             :  symbolically named IEEE.
--             :  
--   Developers:  IEEE model standards group (par 1164)
--   Purpose   :  This packages defines a standard for designers
--             :  to use in describing the interconnection data types
--             :  used in vhdl modeling.
--             : 
--   Limitation:  The logic system defined in this package may
--             :  be insufficient for modeling switched transistors,
--             :  since such a requirement is out of the scope of this
--             :  effort. Furthermore, mathematics, primitives,
--             :  timing standards, etc. are considered orthogonal
--             :  issues as it relates to this package and are therefore
--             :  beyond the scope of this effort.
--             :  
--   Note      :  No declarations or definitions shall be included in,
--             :  or excluded from this package. The "package declaration" 
--             :  defines the types, subtypes and declarations of 
--             :  std_logic_1164. The std_logic_1164 package body shall be 
--             :  considered the formal definition of the semantics of 
--             :  this package. Tool developers may choose to implement 
--             :  the package body in the most efficient manner available 
--             :  to them.
--             :
-- --------------------------------------------------------------------
--   modification history :
-- --------------------------------------------------------------------
--  version | mod. date:| 
--   v4.200 | 01/02/92  | 
-- --------------------------------------------------------------------

use STD.TEXTIO.all;

PACKAGE std_logic_1164 IS

    -------------------------------------------------------------------    
    -- logic state system  (unresolved)
    -------------------------------------------------------------------    
    TYPE std_ulogic IS ( 'U',  -- Uninitialized
                         'X',  -- Forcing  Unknown
                         '0',  -- Forcing  0
                         '1',  -- Forcing  1
                         'Z',  -- High Impedance   
                         'W',  -- Weak     Unknown
                         'L',  -- Weak     0       
                         'H',  -- Weak     1       
                         '-'   -- Wild card
                       ) => ( -- implementation values 
			 'X',
			 'X',
			 '0',
			 '1',
			 'Z',
			 'X',
			 '0',
			 '1',
			 '-'
		       );
    -------------------------------------------------------------------    
    -- unconstrained array of std_ulogic for use with the resolution function
    -------------------------------------------------------------------    
    TYPE std_ulogic_vector IS ARRAY ( NATURAL RANGE <> ) OF std_ulogic;
                                    
    -------------------------------------------------------------------    
    -- resolution function
    -------------------------------------------------------------------    
    FUNCTION resolved ( s : std_ulogic_vector ) RETURN std_ulogic;
    
    -------------------------------------------------------------------    
    -- *** industry standard logic type ***
    -------------------------------------------------------------------    
    SUBTYPE std_logic IS resolved std_ulogic;

    -------------------------------------------------------------------    
    -- unconstrained array of resolved std_ulogic for use in declaring
    -- signal arrays of resolved elements
    -------------------------------------------------------------------    
    subtype STD_LOGIC_VECTOR is resolved STD_ULOGIC_VECTOR;


    -------------------------------------------------------------------    
    -- common subtypes
    -------------------------------------------------------------------    
    SUBTYPE X01     IS resolved std_ulogic RANGE 'X' TO '1'; -- ('X','0','1') 
    SUBTYPE X01Z    IS resolved std_ulogic RANGE 'X' TO 'Z'; -- ('X','0','1','Z') 
    SUBTYPE UX01    IS resolved std_ulogic RANGE 'U' TO '1'; -- ('U','X','0','1') 
    SUBTYPE UX01Z   IS resolved std_ulogic RANGE 'U' TO 'Z'; -- ('U','X','0','1','Z') 

    -------------------------------------------------------------------    
    -- overloaded logical operators
    -------------------------------------------------------------------    

    FUNCTION "and"  ( l : std_ulogic; r : std_ulogic ) RETURN UX01 => "and";
    FUNCTION "nand" ( l : std_ulogic; r : std_ulogic ) RETURN UX01 => "nand";
    FUNCTION "or"   ( l : std_ulogic; r : std_ulogic ) RETURN UX01 => "or";
    FUNCTION "nor"  ( l : std_ulogic; r : std_ulogic ) RETURN UX01 => "nor";
    FUNCTION "xor"  ( l : std_ulogic; r : std_ulogic ) RETURN UX01 => "xor";
    FUNCTION "xnor" ( l : std_ulogic; r : std_ulogic ) RETURN UX01 => "xnor";
    FUNCTION "not"  ( l : std_ulogic                 ) RETURN UX01 => "not";
    
    -------------------------------------------------------------------    
    -- vectorized overloaded logical operators
    -------------------------------------------------------------------    

    FUNCTION "and"  ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "and";
    FUNCTION "nand" ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "nand";
    FUNCTION "or"   ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "or";
    FUNCTION "nor"  ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "nor";
    FUNCTION "xor"  ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "xor";
    FUNCTION "xnor" ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "xnor";
    FUNCTION "not"  ( l : std_ulogic_vector ) RETURN std_ulogic_vector => "not";

	function "&"   (a : std_logic_vector; b : std_logic_vector) return std_logic_vector => "concat";

    -------------------------------------------------------------------
    -- conversion functions
    -------------------------------------------------------------------
    FUNCTION To_bit       ( s : std_ulogic;        xmap : BIT := '0') RETURN BIT => "buf";
    FUNCTION To_bitvector ( s : std_ulogic_vector; xmap : BIT := '0') RETURN BIT_VECTOR => "buf";

    FUNCTION To_StdULogic       ( b : BIT               ) RETURN std_ulogic => "buf";
    FUNCTION To_StdLogicVector  ( b : BIT_VECTOR        ) RETURN std_logic_vector => "buf";
    function To_StdLogicVector (s : std_ulogic_vector ) RETURN std_logic_vector;
    FUNCTION To_StdLogicVector_core  ( s : std_ulogic_vector ) RETURN std_logic_vector => "buf";
    FUNCTION To_StdULogicVector ( b : BIT_VECTOR        ) RETURN std_ulogic_vector => "buf";
    FUNCTION To_StdULogicVector ( s : std_logic_vector  ) RETURN std_ulogic_vector => "buf";
	
	alias To_Bit_Vector is To_bitvector[STD_ULOGIC_VECTOR, BIT return BIT_VECTOR];
	alias To_BV is To_bitvector[STD_ULOGIC_VECTOR, BIT return BIT_VECTOR];
  
	alias To_Std_Logic_Vector is To_StdLogicVector[BIT_VECTOR return STD_LOGIC_VECTOR];
	alias To_SLV is To_StdLogicVector[BIT_VECTOR return STD_LOGIC_VECTOR];

	alias To_Std_Logic_Vector is To_StdLogicVector[STD_ULOGIC_VECTOR return STD_LOGIC_VECTOR];
	alias To_SLV is To_StdLogicVector[STD_ULOGIC_VECTOR return STD_LOGIC_VECTOR];

	alias To_Std_ULogic_Vector is To_StdULogicVector[BIT_VECTOR return STD_ULOGIC_VECTOR];
	alias To_SULV is To_StdULogicVector[BIT_VECTOR return STD_ULOGIC_VECTOR];

	alias To_Std_ULogic_Vector is To_StdULogicVector[STD_LOGIC_VECTOR return STD_ULOGIC_VECTOR];
	alias To_SULV is To_StdULogicVector[STD_LOGIC_VECTOR return STD_ULOGIC_VECTOR];
    
    -------------------------------------------------------------------    
    -- strength strippers and type convertors
    -------------------------------------------------------------------    

	function TO_01 (s : STD_ULOGIC_VECTOR; xmap : STD_ULOGIC := '0') return STD_ULOGIC_VECTOR => "buf";
    function TO_01 (s : STD_ULOGIC; xmap : STD_ULOGIC := '0') return STD_ULOGIC => "buf";
    function TO_01 (s : BIT_VECTOR; xmap : STD_ULOGIC := '0') return STD_ULOGIC_VECTOR;
    function TO_01 (s : BIT; xmap : STD_ULOGIC := '0') return STD_ULOGIC => "buf";
	
    FUNCTION To_X01  ( s : std_ulogic_vector ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_X01  ( s : std_ulogic        ) RETURN  X01 => "buf";
    FUNCTION To_X01  ( b : BIT_VECTOR        ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_X01  ( b : BIT               ) RETURN  X01 => "buf";

    FUNCTION To_X01Z ( s : std_ulogic_vector ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_X01Z ( s : std_ulogic        ) RETURN  X01Z => "buf";
    FUNCTION To_X01Z ( b : BIT_VECTOR        ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_X01Z ( b : BIT               ) RETURN  X01Z => "buf";

    FUNCTION To_UX01  ( s : std_ulogic_vector ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_UX01  ( s : std_ulogic        ) RETURN  UX01 => "buf";
    FUNCTION To_UX01  ( b : BIT_VECTOR        ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_UX01  ( b : BIT               ) RETURN  UX01 => "buf";

    -------------------------------------------------------------------    
    -- edge detection
    -------------------------------------------------------------------    
    FUNCTION rising_edge  (SIGNAL s : std_ulogic) RETURN BOOLEAN => "rise";
    FUNCTION falling_edge (SIGNAL s : std_ulogic) RETURN BOOLEAN => "fall";

    -------------------------------------------------------------------    
    -- object contains an unknown
    -------------------------------------------------------------------    
    FUNCTION Is_X ( s : std_ulogic_vector ) RETURN  BOOLEAN => "is_x";
    FUNCTION Is_X ( s : std_ulogic        ) RETURN  BOOLEAN => "is_x";

    -------------------------------------------------------------------    
    -- Comparison function overloads
    -------------------------------------------------------------------    
--    FUNCTION "=" (a, b : std_logic_vector ) RETURN BOOLEAN => "eq";
--    FUNCTION "/=" (a, b : std_logic_vector ) RETURN BOOLEAN => "noteq";
--    FUNCTION "<" (a, b : std_logic_vector ) RETURN BOOLEAN => "lt";
--    FUNCTION "<=" (a, b : std_logic_vector ) RETURN BOOLEAN => "le";
--    FUNCTION ">" (a, b : std_logic_vector ) RETURN BOOLEAN => "gt";
--    FUNCTION ">=" (a, b : std_logic_vector ) RETURN BOOLEAN => "ge";
--
--    FUNCTION "=" (a, b : std_ulogic_vector ) RETURN BOOLEAN => "eq";
--    FUNCTION "/=" (a, b : std_ulogic_vector ) RETURN BOOLEAN => "noteq";
--    FUNCTION "<" (a, b : std_ulogic_vector ) RETURN BOOLEAN => "lt";
--    FUNCTION "<=" (a, b : std_ulogic_vector ) RETURN BOOLEAN => "le";
--    FUNCTION ">" (a, b : std_ulogic_vector ) RETURN BOOLEAN => "gt";
--    FUNCTION ">=" (a, b : std_ulogic_vector ) RETURN BOOLEAN => "ge";


  -- I/O Functions copied over from std_logic_textio (Moved to std_logic_1164 for VHDL 2008)
	-- Read and Write procedures for STD_ULOGIC and STD_ULOGIC_VECTOR
	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC);
	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC; GOOD: out BOOLEAN);
	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR);
	procedure READ(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR; GOOD: out BOOLEAN);

	procedure HREAD(L:inout LINE; VALUE:out BIT_VECTOR);
	procedure HREAD(L:inout LINE; VALUE:out BIT_VECTOR; GOOD: out BOOLEAN);

	-- Hex Read procedures for STD_ULOGIC_VECTOR
	procedure HREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR);
	procedure HREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR; GOOD: out BOOLEAN);

	procedure OREAD(L:inout LINE; VALUE:out BIT_VECTOR);
	procedure OREAD(L:inout LINE; VALUE:out BIT_VECTOR; GOOD: out BOOLEAN);

	-- Octal Read procedures for STD_ULOGIC_VECTOR
	procedure OREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR);
	procedure OREAD(L:inout LINE; VALUE:out STD_ULOGIC_VECTOR; GOOD: out BOOLEAN);

      --alias OCTAL_READ is OREAD [LINE, STD_ULOGIC_VECTOR, BOOLEAN];
      --alias OCTAL_READ is OREAD [LINE, STD_ULOGIC_VECTOR];
      --alias HEX_READ is HREAD [LINE, STD_ULOGIC_VECTOR, BOOLEAN];
      --alias HEX_READ is HREAD [LINE, STD_ULOGIC_VECTOR];

      --alias OCTAL_READ is OREAD [LINE, STD_LOGIC_VECTOR, BOOLEAN];
      --alias OCTAL_READ is OREAD [LINE, STD_LOGIC_VECTOR];
      --alias HEX_READ is HREAD [LINE, STD_LOGIC_VECTOR, BOOLEAN];
      --alias HEX_READ is HREAD [LINE, STD_LOGIC_VECTOR];

	function v_read_l_to_sul_check(L:LINE) return boolean => "read_l_to_sul_check";
	function v_read_l_to_sul(L:LINE) return std_ulogic => "read_l_to_sul";
	function v_read_l_to_sulv_check(L:LINE; len:natural) return boolean => "read_l_to_sulv_check";
	function v_read_l_to_sulv(L:LINE; len:natural) return std_ulogic_vector => "read_l_to_sulv";
	function v_hread_l_to_bitv(L: LINE; len:natural) return bit_vector => "hread_l_to_bitv";
	function v_hread_l_to_bitv_check(L: LINE; len:natural) return boolean => "hread_l_to_bitv_check";
	function v_oread_l_to_bitv(L: LINE; len:natural) return bit_vector => "oread_l_to_bitv";
	function v_oread_l_to_bitv_check(L: LINE; len:natural) return boolean => "oread_l_to_bitv_check";

  -- End of I/O Functions copied over from std_logic_textio 


  -------------------------------------------------------------------    
  -- overloaded shift operators
  ------------------------------------------------------------------- 

  function "sll" (l : STD_ULOGIC_VECTOR; r : INTEGER) return STD_ULOGIC_VECTOR => "sll";
  function "srl" (l : STD_ULOGIC_VECTOR; r : INTEGER) return STD_ULOGIC_VECTOR => "srl";
  function "rol" (l : STD_ULOGIC_VECTOR; r : INTEGER) return STD_ULOGIC_VECTOR => "rol";
  function "ror" (l  : STD_ULOGIC_VECTOR; r : INTEGER) return STD_ULOGIC_VECTOR => "ror";

  -------------------------------------------------------------------
  -- vector/scalar overloaded logical operators
  -------------------------------------------------------------------
  function "and" (l  : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR;
  function "and" (l  : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  function "nand" (l : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR;
  function "nand" (l : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  function "or" (l   : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR;
  function "or" (l   : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  function "nor" (l  : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR;
  function "nor" (l  : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  function "xor" (l  : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR;
  function "xor" (l  : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  function "xnor" (l : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR;
  function "xnor" (l : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;

  -------------------------------------------------------------------
  -- vector-reduction functions.
  -- "and" functions default to "1", or defaults to "0"
  -------------------------------------------------------------------
   function "and" ( l  : std_ulogic_vector ) RETURN std_ulogic; 
   function "nand" ( l  : std_ulogic_vector ) RETURN std_ulogic;
   function "or" ( l  : std_ulogic_vector ) RETURN std_ulogic;
   function "nor" ( l  : std_ulogic_vector ) RETURN std_ulogic;
   function "xor" ( l  : std_ulogic_vector ) RETURN std_ulogic;
   function "xnor" ( l  : std_ulogic_vector ) RETURN std_ulogic;

  -------------------------------------------------------------------
  -- ?= operators, same functionality as 1076.3 1994 std_match
  -------------------------------------------------------------------
  FUNCTION "?=" ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION "?=" ( l, r : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION "?/=" ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION "?/=" ( l, r : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION "?>" ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION "?>=" ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION "?<" ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION "?<=" ( l, r : std_ulogic ) RETURN std_ulogic;

  -- "??" operator, converts a std_ulogic to a boolean.
  FUNCTION "??" (S : STD_ULOGIC) RETURN BOOLEAN;

  function to_string (value : STD_ULOGIC) return STRING;
  function to_string (value : STD_ULOGIC_VECTOR) return STRING;

  -- explicitly defined operations

  alias TO_BSTRING is TO_STRING [STD_ULOGIC_VECTOR return STRING];
  alias TO_BINARY_STRING is TO_STRING [STD_ULOGIC_VECTOR return STRING];
  function TO_OSTRING (VALUE : STD_ULOGIC_VECTOR) return STRING;
  alias TO_OCTAL_STRING is TO_OSTRING [STD_ULOGIC_VECTOR return STRING];
  function TO_HSTRING (VALUE : STD_ULOGIC_VECTOR) return STRING;
  alias TO_HEX_STRING is TO_HSTRING [STD_ULOGIC_VECTOR return STRING];
  
-- pragma synthesis_off
  -- rtl_synthesis off
  
  -- READ, OREAD, HREAD functions declared above and commented out here
  --procedure READ (L : inout LINE; VALUE : out STD_ULOGIC; GOOD : out BOOLEAN);
  --procedure READ (L : inout LINE; VALUE : out STD_ULOGIC);

  --procedure READ (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR; GOOD : out BOOLEAN);
  --procedure READ (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR);

  procedure WRITE (L         : inout LINE; VALUE : in STD_ULOGIC;
                   JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);

  procedure WRITE (L         : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
                   JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);

  alias BREAD is READ [LINE, STD_ULOGIC_VECTOR, BOOLEAN];
  alias BREAD is READ [LINE, STD_ULOGIC_VECTOR];
  alias BINARY_READ is READ [LINE, STD_ULOGIC_VECTOR, BOOLEAN];
  alias BINARY_READ is READ [LINE, STD_ULOGIC_VECTOR];

  --procedure OREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR; GOOD : out BOOLEAN);
  --procedure OREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR);
  --alias OCTAL_READ is OREAD [LINE, STD_ULOGIC_VECTOR, BOOLEAN];
  --alias OCTAL_READ is OREAD [LINE, STD_ULOGIC_VECTOR];

  --procedure HREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR; GOOD : out BOOLEAN);
  --procedure HREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR);
  --alias HEX_READ is HREAD [LINE, STD_ULOGIC_VECTOR, BOOLEAN];
  --alias HEX_READ is HREAD [LINE, STD_ULOGIC_VECTOR];

  alias BWRITE is WRITE [LINE, STD_ULOGIC_VECTOR, SIDE, WIDTH];
  alias BINARY_WRITE is WRITE [LINE, STD_ULOGIC_VECTOR, SIDE, WIDTH];
  
  procedure OWRITE (L         : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
                    JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);
  alias OCTAL_WRITE is OWRITE [LINE, STD_ULOGIC_VECTOR, SIDE, WIDTH];
  
  procedure HWRITE (L         : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
                    JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);
  alias HEX_WRITE is HWRITE [LINE, STD_ULOGIC_VECTOR, SIDE, WIDTH];

  --procedure READ (L : inout LINE; VALUE : out STD_LOGIC_VECTOR; GOOD : out BOOLEAN);
  --procedure READ (L : inout LINE; VALUE : out STD_LOGIC_VECTOR);

  --procedure WRITE (L         : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  --                 JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);

  --procedure OREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR; GOOD : out BOOLEAN);
  --procedure OREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR);
  --alias OCTAL_READ is OREAD [LINE, STD_LOGIC_VECTOR, BOOLEAN];
  --alias OCTAL_READ is OREAD [LINE, STD_LOGIC_VECTOR];

  --procedure HREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR; GOOD : out BOOLEAN);
  --procedure HREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR);
  --alias HEX_READ is HREAD [LINE, STD_LOGIC_VECTOR, BOOLEAN];
  --alias HEX_READ is HREAD [LINE, STD_LOGIC_VECTOR];

  --alias BWRITE is WRITE [LINE, STD_LOGIC_VECTOR, SIDE, WIDTH];
  --alias BINARY_WRITE is WRITE [LINE, STD_LOGIC_VECTOR, SIDE, WIDTH];
  
  --procedure OWRITE (L         : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  --                  JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);
  --alias OCTAL_WRITE is OWRITE [LINE, STD_LOGIC_VECTOR, SIDE, WIDTH];
  
  --procedure HWRITE (L         : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  --                  JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0);
  --alias HEX_WRITE is HWRITE [LINE, STD_LOGIC_VECTOR, SIDE, WIDTH];
  
-- rtl_synthesis on
-- pragma synthesis_on

function maximum (l, r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
function maximum (l, r : STD_ULOGIC) return STD_ULOGIC;
function minimum (l, r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
function minimum (l, r : STD_ULOGIC) return STD_ULOGIC;

END std_logic_1164;

package body std_logic_1164 is
  type stdlogic_table is array(STD_ULOGIC, STD_ULOGIC) of STD_ULOGIC;


  function To_StdLogicVector (s : std_ulogic_vector )
    return STD_LOGIC_VECTOR
  is
    variable result : STD_LOGIC_VECTOR (s'length-1 downto 0);
  begin
    result := To_StdLogicVector_core(s);
    return result;
  end function To_StdLogicVector;


  -----------------------------------------------------------------------------
  -- New/updated funcitons for VHDL-200X fast track
  -----------------------------------------------------------------------------
  -------------------------------------------------------------------    
  -- overloaded shift operators
  ------------------------------------------------------------------- 

  -------------------------------------------------------------------    
  -- sll
  -------------------------------------------------------------------    
--  function "sll" (l : STD_ULOGIC_VECTOR; r : INTEGER) return STD_ULOGIC_VECTOR is
--    alias lv        : STD_ULOGIC_VECTOR (1 to l'length) is l;
--    variable result : STD_ULOGIC_VECTOR (1 to l'length) := (others => '0');
--  begin
--    if r >= 0 then
--      result(1 to l'length - r) := lv(r + 1 to l'length);
--    else
--      result := l srl -r;
--    end if;
--    return result;
--  end function "sll";
--
--  -------------------------------------------------------------------    
--  -- srl
--  -------------------------------------------------------------------    
--  function "srl" (l : STD_ULOGIC_VECTOR; r : INTEGER) return STD_ULOGIC_VECTOR is
--    alias lv        : STD_ULOGIC_VECTOR (1 to l'length) is l;
--    variable result : STD_ULOGIC_VECTOR (1 to l'length) := (others => '0');
--  begin
--    if r >= 0 then
--      result(r + 1 to l'length) := lv(1 to l'length - r);
--    else
--      result := l sll -r;
--    end if;
--    return result;
--  end function "srl";
--
--  -------------------------------------------------------------------    
--  -- rol
--  -------------------------------------------------------------------    
--  function "rol" (l : STD_ULOGIC_VECTOR; r : INTEGER) return STD_ULOGIC_VECTOR is
--    alias lv        : STD_ULOGIC_VECTOR (1 to l'length) is l;
--    variable result : STD_ULOGIC_VECTOR (1 to l'length);
--    constant rm     : INTEGER := r mod l'length;
--  begin
--    if r >= 0 then
--      result(1 to l'length - rm)            := lv(rm + 1 to l'length);
--      result(l'length - rm + 1 to l'length) := lv(1 to rm);
--    else
--      result := l ror -r;
--    end if;
--    return result;
--  end function "rol";
--
--  -------------------------------------------------------------------    
--  -- ror
--  -------------------------------------------------------------------    
--  function "ror" (l : STD_ULOGIC_VECTOR; r : INTEGER) return STD_ULOGIC_VECTOR is
--    alias lv        : STD_ULOGIC_VECTOR (1 to l'length) is l;
--    variable result : STD_ULOGIC_VECTOR (1 to l'length) := (others => '0');
--    constant rm     : INTEGER := r mod l'length;
--  begin
--    if r >= 0 then
--      result(rm + 1 to l'length) := lv(1 to l'length - rm);
--      result(1 to rm)            := lv(l'length - rm + 1 to l'length);
--    else
--      result := l rol -r;
--    end if;
--    return result;
--  end function "ror";


  -------------------------------------------------------------------
  -- vector/scalar overloaded logical operators
  -------------------------------------------------------------------

  -------------------------------------------------------------------
  -- and
  -------------------------------------------------------------------
  function "and" (l : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR is
    alias lv        : STD_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : STD_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := "and" (lv(i), r);
    end loop;
    return result;
  end function "and";
  -------------------------------------------------------------------
  function "and" (l : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
    alias rv        : STD_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : STD_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := "and" (l, rv(i));
    end loop;
    return result;
  end function "and";

  -------------------------------------------------------------------
  -- nand
  -------------------------------------------------------------------
  function "nand" (l : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR is
    alias lv        : STD_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : STD_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := "not"("and" (lv(i), r));
    end loop;
    return result;
  end function "nand";
  -------------------------------------------------------------------
  function "nand" (l : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
    alias rv        : STD_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : STD_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := "not"("and" (l, rv(i)));
    end loop;
    return result;
  end function "nand";

  -------------------------------------------------------------------
  -- or
  -------------------------------------------------------------------
  function "or" (l : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR is
    alias lv        : STD_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : STD_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := "or" (lv(i), r);
    end loop;
    return result;
  end function "or";
  -------------------------------------------------------------------
  function "or" (l : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
    alias rv        : STD_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : STD_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := "or" (l, rv(i));
    end loop;
    return result;
  end function "or";

  -------------------------------------------------------------------
  -- nor
  -------------------------------------------------------------------
  function "nor" (l : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR is
    alias lv        : STD_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : STD_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := "not"("or" (lv(i), r));
    end loop;
    return result;
  end function "nor";
  -------------------------------------------------------------------
  function "nor" (l : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
    alias rv        : STD_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : STD_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := "not"("or" (l, rv(i)));
    end loop;
    return result;
  end function "nor";

  -------------------------------------------------------------------
  -- xor
  -------------------------------------------------------------------
  function "xor" (l : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR is
    alias lv        : STD_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : STD_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := "xor" (lv(i), r);
    end loop;
    return result;
  end function "xor";
  -------------------------------------------------------------------
  function "xor" (l : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
    alias rv        : STD_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : STD_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := "xor" (l, rv(i));
    end loop;
    return result;
  end function "xor";

  -------------------------------------------------------------------
  -- xnor
  -------------------------------------------------------------------
  function "xnor" (l : STD_ULOGIC_VECTOR; r : STD_ULOGIC) return STD_ULOGIC_VECTOR is
    alias lv        : STD_ULOGIC_VECTOR (1 to l'length) is l;
    variable result : STD_ULOGIC_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := "not"("xor" (lv(i), r));
    end loop;
    return result;
  end function "xnor";
  -------------------------------------------------------------------
  function "xnor" (l : STD_ULOGIC; r : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
    alias rv        : STD_ULOGIC_VECTOR (1 to r'length) is r;
    variable result : STD_ULOGIC_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := "not"("xor" (l, rv(i)));
    end loop;
    return result;
  end function "xnor";

  -------------------------------------------------------------------
  -- vector-reduction functions
  -------------------------------------------------------------------

  -------------------------------------------------------------------
  -- and
  -------------------------------------------------------------------
  
  function "and" (l : STD_ULOGIC_VECTOR) return STD_ULOGIC is
    variable result : STD_ULOGIC := '1';
  begin
    for i in l'reverse_range loop
      result := (l(i) and result);
    end loop;
    return result;
  end function "and";

  -------------------------------------------------------------------
  -- nand
  -------------------------------------------------------------------
  
  function "nand" (l : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  not (and(l));
  end function "nand";

  -------------------------------------------------------------------
  -- or
  -------------------------------------------------------------------
  
  function "or" (l : STD_ULOGIC_VECTOR) return STD_ULOGIC is
    variable result : STD_ULOGIC := '0';
  begin
    for i in l'reverse_range loop
      result := (l(i) or result);
    end loop;
    return result;
  end function "or";

  -------------------------------------------------------------------
  -- nor
  -------------------------------------------------------------------
  
  function "nor"(l : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  begin
    return "not"(or(l));
  end function "nor";

  -------------------------------------------------------------------
  -- xor
  -------------------------------------------------------------------
  
  function "xor" (l : STD_ULOGIC_VECTOR) return STD_ULOGIC is
    variable result : STD_ULOGIC := '0';
  begin
    for i in l'reverse_range loop
      result := (l(i) xor result);
    end loop;
    return result;
  end function "xor";

  -------------------------------------------------------------------
  -- xnor
  -------------------------------------------------------------------
  
  function "xnor" (l : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  begin
    return "not"(xor(l));
  end function "xnor";


  -- The following functions are implicity in 1076-2006
  -- truth table for "?=" function
  constant match_logic_table : stdlogic_table := (
    -----------------------------------------------------
    -- U    X    0    1    Z    W    L    H    -         |   |  
    -----------------------------------------------------
    ('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', '1'),  -- | U |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1'),  -- | X |
    ('U', 'X', '1', '0', 'X', 'X', '1', '0', '1'),  -- | 0 |
    ('U', 'X', '0', '1', 'X', 'X', '0', '1', '1'),  -- | 1 |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1'),  -- | Z |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1'),  -- | W |
    ('U', 'X', '1', '0', 'X', 'X', '1', '0', '1'),  -- | L |
    ('U', 'X', '0', '1', 'X', 'X', '0', '1', '1'),  -- | H |
    ('1', '1', '1', '1', '1', '1', '1', '1', '1')   -- | - |
    );

  constant no_match_logic_table : stdlogic_table := (
    -----------------------------------------------------
    -- U    X    0    1    Z    W    L    H    -         |   |  
    -----------------------------------------------------
    ('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', '0'),  -- | U |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '0'),  -- | X |
    ('U', 'X', '0', '1', 'X', 'X', '0', '1', '0'),  -- | 0 |
    ('U', 'X', '1', '0', 'X', 'X', '1', '0', '0'),  -- | 1 |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '0'),  -- | Z |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '0'),  -- | W |
    ('U', 'X', '0', '1', 'X', 'X', '0', '1', '0'),  -- | L |
    ('U', 'X', '1', '0', 'X', 'X', '1', '0', '0'),  -- | H |
    ('0', '0', '0', '0', '0', '0', '0', '0', '0')   -- | - |
    );

  -------------------------------------------------------------------
  -- ?= functions, Similar to "std_match", but returns "std_ulogic".
  -------------------------------------------------------------------
  FUNCTION "?=" ( l, r : std_ulogic ) RETURN std_ulogic IS
  begin
    return match_logic_table (l, r);
  END FUNCTION "?=";
  -------------------------------------------------------------------
  
  FUNCTION "?=" ( l, r : std_ulogic_vector ) RETURN std_ulogic IS
    alias lv                 : STD_ULOGIC_VECTOR(1 to l'length) is l;
    alias rv                 : STD_ULOGIC_VECTOR(1 to r'length) is r;
    variable result, result1 : STD_ULOGIC;
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?="": null detected, returning X"
        severity warning;
      return 'X';
    end if;
    if lv'length /= rv'length then
      report "STD_LOGIC_1164.""?="": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    else
      result := '1';
      for i in lv'low to lv'high loop
        result1 := match_logic_table(lv(i), rv(i));
        if result1 = 'U' then
          return 'U';
        elsif result1 = 'X' or result = 'X' then
          result := 'X';
        else
          result := result and result1;
        end if;
      end loop;
      return result;
    end if;
  END FUNCTION "?=";

  FUNCTION "?/=" ( l, r : std_ulogic ) RETURN std_ulogic is
  begin
    return no_match_logic_table (l, r);
  END FUNCTION "?/=";


  FUNCTION "?/=" ( l, r : std_ulogic_vector ) RETURN std_ulogic is
    alias lv                 : STD_ULOGIC_VECTOR(1 to l'length) is l;
    alias rv                 : STD_ULOGIC_VECTOR(1 to r'length) is r;
    variable result, result1 : STD_ULOGIC;
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?/="": null detected, returning X"
        severity warning;
      return 'X';
    end if;
    if lv'length /= rv'length then
      report "STD_LOGIC_1164.""?/="": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    else
      result := '0';
      for i in lv'low to lv'high loop
        result1 := no_match_logic_table(lv(i), rv(i));
        if result1 = 'U' then
          return 'U';
        elsif result1 = 'X' or result = 'X' then
          result := 'X';
        else
          result := result or result1;
        end if;
      end loop;
      return result;
    end if;
  END FUNCTION "?/=";

  FUNCTION "?>" ( l, r : std_ulogic ) RETURN std_ulogic is
    variable lx, rx : STD_ULOGIC;
  begin
    if (l = '-') or (r = '-') then
      report "STD_LOGIC_1164.""?>"": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01 (l);
      rx := to_x01 (r);
      if lx = 'X' or rx = 'X' then
        return 'X';
      elsif lx > rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  END FUNCTION "?>";

  FUNCTION "?>=" ( l, r : std_ulogic ) RETURN std_ulogic is
    variable lx, rx : STD_ULOGIC;
  begin
    if (l = '-') or (r = '-') then
      report "STD_LOGIC_1164.""?>="": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01 (l);
      rx := to_x01 (r);
      if lx = 'X' or rx = 'X' then
        return 'X';
      elsif lx >= rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  END FUNCTION "?>=";

  FUNCTION "?<" ( l, r : std_ulogic ) RETURN std_ulogic is
    variable lx, rx : STD_ULOGIC;
  begin
    if (l = '-') or (r = '-') then
      report "STD_LOGIC_1164.""?<"": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01 (l);
      rx := to_x01 (r);
      if lx = 'X' or rx = 'X' then
        return 'X';
      elsif lx < rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  END FUNCTION "?<";

  FUNCTION "?<=" ( l, r : std_ulogic ) RETURN std_ulogic is
    variable lx, rx : STD_ULOGIC;
  begin
    if (l = '-') or (r = '-') then
      report "STD_LOGIC_1164.""?<="": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01 (l);
      rx := to_x01 (r);
      if lx = 'X' or rx = 'X' then
        return 'X';
      elsif lx <= rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  END FUNCTION "?<=";

  -- "??" operator, converts a std_ulogic to a boolean.
  function "??" (S : STD_ULOGIC) return BOOLEAN is
  begin
    return S = '1' or S = 'H';
  END FUNCTION "??";

  -----------------------------------------------------------------------------
  -- This section copied from "std_logic_textio"
  -----------------------------------------------------------------------------
  -- Type and constant definitions used to map STD_ULOGIC values 
  -- into/from character values.
  type MVL9plus is ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-', error);
  type char_indexed_by_MVL9 is array (STD_ULOGIC) of CHARACTER;
  type MVL9_indexed_by_char is array (CHARACTER) of STD_ULOGIC;
  type MVL9plus_indexed_by_char is array (CHARACTER) of MVL9plus;
  constant MVL9_to_char : char_indexed_by_MVL9 := "UX01ZWLH-";
  constant char_to_MVL9 : MVL9_indexed_by_char :=
    ('U' => 'U', 'X' => 'X', '0' => '0', '1' => '1', 'Z' => 'Z',
     'W' => 'W', 'L' => 'L', 'H' => 'H', '-' => '-', others => 'U');
  constant char_to_MVL9plus : MVL9plus_indexed_by_char :=
    ('U' => 'U', 'X' => 'X', '0' => '0', '1' => '1', 'Z' => 'Z',
     'W' => 'W', 'L' => 'L', 'H' => 'H', '-' => '-', others => error);

--  constant NBSP : CHARACTER      := CHARACTER'val(160);  -- space character
  constant NUS  : STRING(2 to 1) := (others => ' ');     -- null string


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

-- pragma synthesis_off
  -- rtl_synthesis off

  procedure WRITE (L         : inout LINE; VALUE : in STD_ULOGIC;
                   JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0) is
  begin
    write(l, MVL9_to_char(VALUE), justified, field);
  end procedure WRITE;

  procedure WRITE (L         : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
                   JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0) is
    variable s : STRING(1 to VALUE'length);
    variable m : STD_ULOGIC_VECTOR(1 to VALUE'length) := VALUE;
  begin
    for i in 1 to VALUE'length loop
      s(i) := MVL9_to_char(m(i));
    end loop;
    write(l, s, justified, field);
  end procedure WRITE;


  -----------------------------------------------------------------------
  -- Alias for bread and bwrite are provided with call out the read and
  -- write functions.
  -----------------------------------------------------------------------

  -- Hex Read and Write procedures for STD_ULOGIC_VECTOR.
  -- Modified from the original to be more forgiving.

  procedure Char2QuadBits (C           :     CHARACTER;
                           RESULT      : out STD_ULOGIC_VECTOR(3 downto 0);
                           GOOD        : out BOOLEAN;
                           ISSUE_ERROR : in  BOOLEAN) is
  begin
    case c is
      when '0'       => result := x"0"; good := true;
      when '1'       => result := x"1"; good := true;
      when '2'       => result := x"2"; good := true;
      when '3'       => result := x"3"; good := true;
      when '4'       => result := x"4"; good := true;
      when '5'       => result := x"5"; good := true;
      when '6'       => result := x"6"; good := true;
      when '7'       => result := x"7"; good := true;
      when '8'       => result := x"8"; good := true;
      when '9'       => result := x"9"; good := true;
      when 'A' | 'a' => result := x"A"; good := true;
      when 'B' | 'b' => result := x"B"; good := true;
      when 'C' | 'c' => result := x"C"; good := true;
      when 'D' | 'd' => result := x"D"; good := true;
      when 'E' | 'e' => result := x"E"; good := true;
      when 'F' | 'f' => result := x"F"; good := true;
      when 'Z'       => result := "ZZZZ"; good := true;
      when 'X'       => result := "XXXX"; good := true;
      when others =>
        assert not ISSUE_ERROR
          report
          "STD_LOGIC_1164.HREAD Error: Read a '" & c &
          "', expected a Hex character (0-F)."
          severity error;
        good := false;
    end case;
  end procedure Char2QuadBits;

  
  procedure HWRITE (L         : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
                    JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0) is
  begin
    write (L, to_hstring (VALUE), JUSTIFIED, FIELD);
  end procedure HWRITE;


  -- Octal Read and Write procedures for STD_ULOGIC_VECTOR.
  -- Modified from the original to be more forgiving.

  procedure Char2TriBits (C           :     CHARACTER;
                          RESULT      : out STD_ULOGIC_VECTOR(2 downto 0);
                          GOOD        : out BOOLEAN;
                          ISSUE_ERROR : in  BOOLEAN) is
  begin
    case c is
      when '0' => result := o"0"; good := true;
      when '1' => result := o"1"; good := true;
      when '2' => result := o"2"; good := true;
      when '3' => result := o"3"; good := true;
      when '4' => result := o"4"; good := true;
      when '5' => result := o"5"; good := true;
      when '6' => result := o"6"; good := true;
      when '7' => result := o"7"; good := true;
      when 'Z' => result := "ZZZ"; good := true;
      when 'X' => result := "XXX"; good := true;
      when others =>
        assert not ISSUE_ERROR
          report
          "STD_LOGIC_1164.OREAD Error: Read a '" & c &
          "', expected an Octal character (0-7)."
          severity error;
        good := false;
    end case;
  end procedure Char2TriBits;

  procedure OWRITE (L         : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
                    JUSTIFIED : in    SIDE := right; FIELD : in WIDTH := 0) is
  begin
    write (L, to_ostring(VALUE), JUSTIFIED, FIELD);
  end procedure OWRITE;

    -- rtl_synthesis on
-- pragma synthesis_on
  -----------------------------------------------------------------------------
  -- New string functions for vhdl-200x fast track
  -----------------------------------------------------------------------------
  function to_string (value     : in STD_ULOGIC) return STRING is
    variable result : STRING (1 to 1);
  begin
    result (1) := MVL9_to_char (value);
    return result;
  end function to_string;
  -------------------------------------------------------------------    
  -- TO_STRING (an alias called "to_bstring" is provide)
  -------------------------------------------------------------------   
  function to_string (value     : in STD_ULOGIC_VECTOR) return STRING is
    alias ivalue    : STD_ULOGIC_VECTOR(1 to value'length) is value;
    variable result : STRING(1 to value'length);
  begin
    if value'length < 1 then
      return NUS;
    else
      for i in ivalue'range loop
        result(i) := MVL9_to_char(iValue(i));
      end loop;
      return result;
    end if;
  end function to_string;

  -------------------------------------------------------------------    
  -- TO_HSTRING
  -------------------------------------------------------------------   
  function to_hstring (value     : in STD_ULOGIC_VECTOR) return STRING is
    constant ne     : INTEGER := (value'length+3)/4;
    variable pad    : STD_ULOGIC_VECTOR(0 to (ne*4 - value'length) - 1);
    variable ivalue : STD_ULOGIC_VECTOR(0 to ne*4 - 1);
    variable result : STRING(1 to ne);
    variable quad   : STD_ULOGIC_VECTOR(0 to 3);
  begin
    if value'length < 1 then
      return NUS;
    else
      if value (value'left) = 'Z' then
        pad := (others => 'Z');
      else
        pad := (others => '0');
      end if;
      ivalue := pad & value;
      for i in 0 to ne-1 loop
        case ivalue(4*i to 4*i+3) is
          when x"0"   => result(i+1) := '0';
          when x"1"   => result(i+1) := '1';
          when x"2"   => result(i+1) := '2';
          when x"3"   => result(i+1) := '3';
          when x"4"   => result(i+1) := '4';
          when x"5"   => result(i+1) := '5';
          when x"6"   => result(i+1) := '6';
          when x"7"   => result(i+1) := '7';
          when x"8"   => result(i+1) := '8';
          when x"9"   => result(i+1) := '9';
          when x"A"   => result(i+1) := 'A';
          when x"B"   => result(i+1) := 'B';
          when x"C"   => result(i+1) := 'C';
          when x"D"   => result(i+1) := 'D';
          when x"E"   => result(i+1) := 'E';
          when x"F"   => result(i+1) := 'F';
          when "ZZZZ" => result(i+1) := 'Z';
          when others => result(i+1) := 'X';
        end case;
      end loop;
      return result;
    end if;
  end function to_hstring;

  -------------------------------------------------------------------    
  -- TO_OSTRING
  -------------------------------------------------------------------   
  function to_ostring (value     : in STD_ULOGIC_VECTOR) return STRING is
    constant ne     : INTEGER := (value'length+2)/3;
    variable pad    : STD_ULOGIC_VECTOR(0 to (ne*3 - value'length) - 1);
    variable ivalue : STD_ULOGIC_VECTOR(0 to ne*3 - 1);
    variable result : STRING(1 to ne);
    variable tri    : STD_ULOGIC_VECTOR(0 to 2);
  begin
    if value'length < 1 then
      return NUS;
    else
      if value (value'left) = 'Z' then
        pad := (others => 'Z');
      else
        pad := (others => '0');
      end if;
      ivalue := pad & value;
      for i in 0 to ne-1 loop
        tri := To_X01Z(ivalue(3*i to 3*i+2));
        case tri is
          when o"0"   => result(i+1) := '0';
          when o"1"   => result(i+1) := '1';
          when o"2"   => result(i+1) := '2';
          when o"3"   => result(i+1) := '3';
          when o"4"   => result(i+1) := '4';
          when o"5"   => result(i+1) := '5';
          when o"6"   => result(i+1) := '6';
          when o"7"   => result(i+1) := '7';
          when "ZZZ"  => result(i+1) := 'Z';
          when others => result(i+1) := 'X';
        end case;
      end loop;
      return result;
    end if;
  end function to_ostring;


  function maximum (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin  -- function maximum
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  -- std_logic_vector output
  function minimum (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin  -- function minimum
    if L > R then return R;
    else return L;
    end if;
  end function minimum;

  function maximum (L, R : STD_ULOGIC) return STD_ULOGIC is
  begin  -- function maximum
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  -- std_logic_vector output
  function minimum (L, R : STD_ULOGIC) return STD_ULOGIC is
  begin  -- function minimum
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  
  function TO_01 (s : BIT_VECTOR; xmap : STD_ULOGIC := '0')
    return STD_ULOGIC_VECTOR
  is
    variable RESULT : STD_ULOGIC_VECTOR(s'length-1 downto 0);
    alias XS        : BIT_VECTOR(s'length-1 downto 0) is s;
  begin
    for I in RESULT'range loop
      case XS(I) is
        when '0' => RESULT(I) := '0';
        when '1' => RESULT(I) := '1';
      end case;
    end loop;
    return RESULT;
  end function TO_01;

end package body std_logic_1164;
