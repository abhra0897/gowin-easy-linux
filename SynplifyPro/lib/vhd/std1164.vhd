--
-- This is a heavily customized version of the std_logic_1164 package
-- For Synplify VHDL Synthesis.
-- This file is not suitable for use with simulation.
-- $Header: //synplicity/comp2019q3p1/compilers/vhdl/vhd/std1164.vhd#1 $
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
    -- unconstrained array of std_logic for use in declaring signal arrays
    -------------------------------------------------------------------    
    TYPE std_logic_vector IS ARRAY ( NATURAL RANGE <>) OF std_logic;

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
    FUNCTION "and"  ( l, r : std_logic_vector  ) RETURN std_logic_vector => "and";
    FUNCTION "and"  ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "and";

    FUNCTION "nand" ( l, r : std_logic_vector  ) RETURN std_logic_vector => "nand";
    FUNCTION "nand" ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "nand";

    FUNCTION "or"   ( l, r : std_logic_vector  ) RETURN std_logic_vector => "or";
    FUNCTION "or"   ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "or";

    FUNCTION "nor"  ( l, r : std_logic_vector  ) RETURN std_logic_vector => "nor";
    FUNCTION "nor"  ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "nor";

    FUNCTION "xor"  ( l, r : std_logic_vector  ) RETURN std_logic_vector => "xor";
    FUNCTION "xor"  ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "xor";

    FUNCTION "xnor" ( l, r : std_logic_vector  ) RETURN std_logic_vector => "xnor";
    FUNCTION "xnor" ( l, r : std_ulogic_vector ) RETURN std_ulogic_vector => "xnor";

    FUNCTION "not"  ( l : std_logic_vector  ) RETURN std_logic_vector => "not";
    FUNCTION "not"  ( l : std_ulogic_vector ) RETURN std_ulogic_vector => "not";

	function "&"   (a : std_logic_vector; b : std_logic_vector) return std_logic_vector => "concat";

    -------------------------------------------------------------------
    -- conversion functions
    -------------------------------------------------------------------
    FUNCTION To_bit       ( s : std_ulogic;        xmap : BIT := '0') RETURN BIT => "buf";
    FUNCTION To_bitvector ( s : std_logic_vector ; xmap : BIT := '0') RETURN BIT_VECTOR => "buf";
    FUNCTION To_bitvector ( s : std_ulogic_vector; xmap : BIT := '0') RETURN BIT_VECTOR => "buf";

    FUNCTION To_StdULogic       ( b : BIT               ) RETURN std_ulogic => "buf";
    FUNCTION To_StdLogicVector ( b : BIT_VECTOR        ) RETURN std_logic_vector => "buf";
    function To_StdLogicVector (s : std_ulogic_vector ) RETURN std_logic_vector;
    FUNCTION To_StdLogicVector_core  ( s : std_ulogic_vector ) RETURN std_logic_vector => "buf";
    FUNCTION To_StdULogicVector ( b : BIT_VECTOR        ) RETURN std_ulogic_vector => "buf";
    FUNCTION To_StdULogicVector ( s : std_logic_vector  ) RETURN std_ulogic_vector => "buf";
    
    -------------------------------------------------------------------    
    -- strength strippers and type convertors
    -------------------------------------------------------------------    

    FUNCTION To_X01  ( s : std_logic_vector  ) RETURN  std_logic_vector => "buf";
    FUNCTION To_X01  ( s : std_ulogic_vector ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_X01  ( s : std_ulogic        ) RETURN  X01 => "buf";
    FUNCTION To_X01  ( b : BIT_VECTOR        ) RETURN  std_logic_vector => "buf";
    FUNCTION To_X01  ( b : BIT_VECTOR        ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_X01  ( b : BIT               ) RETURN  X01 => "buf";

    FUNCTION To_X01Z ( s : std_logic_vector  ) RETURN  std_logic_vector => "buf";
    FUNCTION To_X01Z ( s : std_ulogic_vector ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_X01Z ( s : std_ulogic        ) RETURN  X01Z => "buf";
    FUNCTION To_X01Z ( b : BIT_VECTOR        ) RETURN  std_logic_vector => "buf";
    FUNCTION To_X01Z ( b : BIT_VECTOR        ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_X01Z ( b : BIT               ) RETURN  X01Z => "buf";

    FUNCTION To_UX01  ( s : std_logic_vector  ) RETURN  std_logic_vector => "buf";
    FUNCTION To_UX01  ( s : std_ulogic_vector ) RETURN  std_ulogic_vector => "buf";
    FUNCTION To_UX01  ( s : std_ulogic        ) RETURN  UX01 => "buf";
    FUNCTION To_UX01  ( b : BIT_VECTOR        ) RETURN  std_logic_vector => "buf";
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
    FUNCTION Is_X ( s : std_logic_vector  ) RETURN  BOOLEAN => "is_x";
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

END std_logic_1164;


package body std_logic_1164 is

function To_StdLogicVector (s : std_ulogic_vector )
    return STD_LOGIC_VECTOR
  is
    variable result : STD_LOGIC_VECTOR (s'length-1 downto 0);
  begin
    result := To_StdLogicVector_core(s);
    return result;
  end function To_StdLogicVector;

end package body std_logic_1164;
