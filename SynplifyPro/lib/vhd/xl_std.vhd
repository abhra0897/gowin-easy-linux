
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
--!!                                                                        !!--
--!!                          XL_STD    V 1.3                               !!--
--!!                                                                        !!--
--!! This program is the confidential and proprietary product of            !!--
--!! Cadence Design Systems, Inc. Any unauthorized use,                     !!--
--!! reproduction, or transfer of this program is strictly prohibited.      !!--
--!! Copyright (c) 1990, 1991 by Cadence Design Systems, Inc.               !!--
--!! All Rights Reserved.                                                   !!--
--!!                                                                        !!--
--!! The following package is provided with VHDL-XL to define the           !!--
--!! simulation environment for this tool. It contains definitions          !!--
--!! for the multi-value logic set, overloaded operators, and               !!--
--!! resolution functions. A set of utility routines are also               !!--
--!! included to convert types and do other useful operations.              !!--
--!! This package must not be modified under any circumstances.             !!--
--!!                                                                        !!--
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
--use STD.TEXTIO.all;
package XL_STD is

 --###########################################################################--
 --                                                                           --
 -- The MVL type is a 120 element enumerated type which supports:             --
 --    6 basic logic values ('X', '0', '1', 'Z', 'L' and 'H') and             --
 --    8 basic strength levels (5 drive strengths, 3 charge-storage strengths)--
 --                                                                           --
 -- The following naming convention has been used for the MVL type definition:--
 --                                                                           --
 --  +----------- 'Basic' strength name (Sm, Me, We, La, Pu, St, Su)          --
 --  |                                                                        --
 --  | +--------- Indicates the logic value (0, 1, Z, X, L, H)                --
 --  | |                                                                      --
 --  | | +------- Intermediate strength values (a, b, c, d, e, and f), in     --
 --  v v v           the increasing order.                                    --
 --  La1_a                                                                    --
 --                                                                           --
 -- Exception to the above convention are made for                            --
 --                                                                           --
 --  1.  Default strengths, when                                              --
 --          St0 is represented as '0'                                        --
 --          St1 is represented as '1'                                        --
 --          StX is represented as 'X'                                        --
 --          Z   is represented as 'Z'                                        --
 --                                                                           --
 --  2.  Values representing the exact basic strengths  e.g, Sm1, Su0 etc.    --
 --                                                                           --
 --###########################################################################--

    type UMVL is ( 

    -- Basic logic values which should be used by the user 

      'X', '0', '1', 'Z') => ('X', '0', '1', 'Z');                            -- Basic logic values

    -- The following values are defined for accurate strength modelling 
    -- and are to be used INTERNALLY BY THE SYSTEM ONLY                 
  
    -- '0' values with different strengths  
-- Changed for synthesis : Mala               
--      Sm0,                                           -- Small capacitor 
--      Me0, Me0_a,                                    -- Medium capacitor 
--      We0, We0_a, We0_b,                             -- Weak drive 
--      La0, La0_a, La0_b, La0_c,                      -- Large capacitor 
--      Pu0, Pu0_a, Pu0_b, Pu0_c, Pu0_d,               -- Pull drive 
--      St0_a, St0_b, St0_c, St0_d, St0_e,             -- Strong drive 
--      Su0, Su0_a, Su0_b, Su0_c, Su0_d, Su0_e, Su0_f, -- Supply drive 
                                                                                
    -- '1' values with different strengths  --                                                                                                                  
--      Sm1,                                           -- Small capacitor      
--      Me1, Me1_a,                                    -- Medium capacitor 
--      We1, We1_a, We1_b,                             -- Weak drive
--      La1, La1_a, La1_b, La1_c,                      -- Large capacitor
--      Pu1 , Pu1_a, Pu1_b, Pu1_c, Pu1_d,              -- Pull drive 
--      St1_a, St1_b, St1_c, St1_d, St1_e,             -- Strong drive 
--      Su1, Su1_a, Su1_b, Su1_c, Su1_d, Su1_e, Su1_f, -- Supply drive 
                                                                                
    -- 'X' values with different strengths                                                                                                                    
--      SmX, SmX_a, SmX_b, SmX_c, SmX_d, SmX_e, SmX_f, -- Small capacitor 
--      MeX_a, MeX, MeX_b, MeX_c, MeX_d, MeX_e, MeX_f, -- Medium capacitor 
--      WeX_a, WeX_b, WeX, WeX_c, WeX_d, WeX_e, WeX_f, -- Weak drive 
--      LaX_a, LaX_b, LaX_c, LaX, LaX_d, LaX_e, LaX_f, -- Large capacitor 
--      PuX_a, PuX_b, PuX_c, PuX_d, PuX, PuX_e, PuX_f, -- Pull drive 
--      StX_a, StX_b, StX_c, StX_d, StX_e, StX_f,      -- Strong drive 
--      SuX_a, SuX_b, SuX_c, SuX_d, SuX_e, SuX_f, SuX, -- Supply drive 
      
      -- 'L' values with different strengths 
  
--      SmL, MeL, WeL, LaL, PuL, StL, SuL,             -- 'L' values
  
      -- 'H' values with different strengths 
  
--      SmH, MeH, WeH, LaH, PuH, StH, SuH              -- 'H' values
     
--      );
    TYPE umvl_vector IS ARRAY ( NATURAL RANGE <> ) OF umvl;
                                    
    -------------------------------------------------------------------    
    -- resolution function
    -------------------------------------------------------------------    
    FUNCTION resolved ( s : umvl_vector ) RETURN umvl;
    
    -------------------------------------------------------------------    
    -- *** industry standard logic type ***
    -------------------------------------------------------------------    
    SUBTYPE mvl IS resolved umvl;


 --########################################################################--
 --                                                                        -- 
 --  ADDITIONAL TYPES/SUBTYPES:                                            --
 --                                                                        -- 
 --########################################################################--

    -- Subtypes of MVL 

    subtype MVL_X01Z is MVL range 'X' to 'Z'; -- for logic values X 0 1 Z 
    subtype MVL_X01  is MVL range 'X' to '1'; -- for logic values X 0 1

    -- Unconstrained Vectors of type MVL 

    type MVL_VECTOR      is array (NATURAL range <> ) of MVL; 
    type MVL_X01Z_VECTOR is array (NATURAL range <> ) of MVL_X01Z; 
    type MVL_X01_VECTOR  is array (NATURAL range <> ) of MVL_X01; 


    -- Type declaration for strength representation 

    subtype STRENGTH is BIT_VECTOR (7 downto 0);

    -- Array type declarations for some of the types defined in package STANDARD

    type BOOLEAN_VECTOR  is array (NATURAL Range <>) of BOOLEAN;
    type INTEGER_VECTOR  is array (NATURAL Range <>) of INTEGER;
    type SEVERITY_VECTOR is array (NATURAL Range <>) of SEVERITY_LEVEL;
    type TIME_VECTOR     is array (NATURAL Range <>) of TIME;

    -- 2-Dimensional vectors for MVL types (for Memories) 

    type MVL_1_MEMORY  is array (NATURAL Range <>) of MVL;
    type MVL_2_MEMORY  is array (NATURAL Range <>) of MVL_VECTOR (2 downto 1);
    type MVL_3_MEMORY  is array (NATURAL Range <>) of MVL_VECTOR (3 downto 1);
    type MVL_4_MEMORY  is array (NATURAL Range <>) of MVL_VECTOR (4 downto 1);
    type MVL_5_MEMORY  is array (NATURAL Range <>) of MVL_VECTOR (5 downto 1);
    type MVL_6_MEMORY  is array (NATURAL Range <>) of MVL_VECTOR (6 downto 1);
    type MVL_7_MEMORY  is array (NATURAL Range <>) of MVL_VECTOR (7 downto 1);
    type MVL_8_MEMORY  is array (NATURAL Range <>) of MVL_VECTOR (8 downto 1);
    type MVL_9_MEMORY  is array (NATURAL Range <>) of MVL_VECTOR (9 downto 1);
    type MVL_10_MEMORY is array (NATURAL Range <>) of MVL_VECTOR (10 downto 1);
    type MVL_16_MEMORY is array (NATURAL Range <>) of MVL_VECTOR (16 downto 1);
    type MVL_17_MEMORY is array (NATURAL Range <>) of MVL_VECTOR (17 downto 1);
    type MVL_32_MEMORY is array (NATURAL Range <>) of MVL_VECTOR (32 downto 1);
    type MVL_33_MEMORY is array (NATURAL Range <>) of MVL_VECTOR (33 downto 1);
    type MVL_64_MEMORY is array (NATURAL Range <>) of MVL_VECTOR (64 downto 1);
    type MVL_65_MEMORY is array (NATURAL Range <>) of MVL_VECTOR (65 downto 1);

    -- 2-Dimensional vectors for BIT types (for Memories) 

    type BIT_1_MEMORY  is array (NATURAL Range <>) of BIT;
    type BIT_2_MEMORY  is array (NATURAL Range <>) of BIT_VECTOR (2 downto 1);
    type BIT_3_MEMORY  is array (NATURAL Range <>) of BIT_VECTOR (3 downto 1);
    type BIT_4_MEMORY  is array (NATURAL Range <>) of BIT_VECTOR (4 downto 1);
    type BIT_5_MEMORY  is array (NATURAL Range <>) of BIT_VECTOR (5 downto 1);
    type BIT_6_MEMORY  is array (NATURAL Range <>) of BIT_VECTOR (6 downto 1);
    type BIT_7_MEMORY  is array (NATURAL Range <>) of BIT_VECTOR (7 downto 1);
    type BIT_8_MEMORY  is array (NATURAL Range <>) of BIT_VECTOR (8 downto 1);
    type BIT_9_MEMORY  is array (NATURAL Range <>) of BIT_VECTOR (9 downto 1);
    type BIT_10_MEMORY  is array (NATURAL Range <>) of BIT_VECTOR (10 downto 1);
    type BIT_16_MEMORY is array (NATURAL Range <>) of BIT_VECTOR (16 downto 1);
    type BIT_17_MEMORY is array (NATURAL Range <>) of BIT_VECTOR (17 downto 1);
    type BIT_32_MEMORY is array (NATURAL Range <>) of BIT_VECTOR (32 downto 1);
    type BIT_33_MEMORY is array (NATURAL Range <>) of BIT_VECTOR (33 downto 1);
    type BIT_64_MEMORY is array (NATURAL Range <>) of BIT_VECTOR (64 downto 1);
    type BIT_65_MEMORY is array (NATURAL Range <>) of BIT_VECTOR (65 downto 1);

    -- New array type definition for SIGNED/UNSIGNED BIT vectors

    type SIGNED   is array (INTEGER range <> ) of BIT;
    type UNSIGNED is array (INTEGER range <> ) of BIT;

    -- Type for unconnected ports

    type UNCONNECTED_PORT is (UNCONNECTED);
 

--###########################################################################--
--                                                                           --
-- RESOLUTION FUNCTIONS                                                      --
--                                                                           --
--###########################################################################--

    -- RESOLUTION FUNCTIONS FOR RESOLVED SIGNALS
-- not implemented
    function resolve_tri        (sources: MVL_VECTOR) return MVL; -- WIRE
    function resolve_trior      (sources: MVL_VECTOR) return MVL; -- WIRED OR
    function resolve_triand     (sources: MVL_VECTOR) return MVL; -- WIRED AND
    function resolve_tri1       (sources: MVL_VECTOR) return MVL; -- PULLUP
    function resolve_tri0       (sources: MVL_VECTOR) return MVL; -- PULLDOWN
    function resolve_supply1    (sources: MVL_VECTOR) return MVL; -- SUPPLTY1
    function resolve_supply0    (sources: MVL_VECTOR) return MVL; -- SUPPLY0

    -- SUBTYPE DEFINITIONS FOR RESOLVED SIGNALS TYPES

    subtype WIRE    is resolve_tri      MVL;  -- WIRE
    subtype WOR     is resolve_trior    MVL;  -- WIRED OR
    subtype WAND    is resolve_triand   MVL;  -- WIRED AND
    subtype TRI1    is resolve_tri1     MVL;  -- PULLUP
    subtype TRI0    is resolve_tri0     MVL;  -- PULLDOWN
    subtype SUPPLY1 is resolve_supply1  MVL;  -- SUPPLY 1
    subtype SUPPLY0 is resolve_supply0  MVL;  -- SUPPLY 0
            
    -- TYPE DEFINITIONS FOR VECTORS OF RESOLVED SIGNAL TYPES
                                                 
    type WIRE_VECTOR    is array (NATURAL range <> ) of WIRE; 
    type WAND_VECTOR    is array (NATURAL range <> ) of WAND; 
    type WOR_VECTOR     is array (NATURAL range <> ) of WOR; 
    type TRI1_VECTOR    is array (NATURAL range <> ) of TRI1; 
    type TRI0_VECTOR    is array (NATURAL range <> ) of TRI0; 
    type SUPPLY1_VECTOR is array (NATURAL range <> ) of SUPPLY1; 
    type SUPPLY0_VECTOR is array (NATURAL range <> ) of SUPPLY0; 

 

--########################################################################--
--                                                                        -- 
--  CONSTANTS:                                                            --
--                                                                        -- 
--########################################################################--

    -- These constants describe the 8 levels of strengths used for coercion. 

    constant SUPPLY : STRENGTH := "10000000";
    constant STRONG : STRENGTH := "01000000";
    constant PULL   : STRENGTH := "00100000";
    constant LARGE  : STRENGTH := "00010000";
    constant WEAK   : STRENGTH := "00001000";
    constant MEDIUM : STRENGTH := "00000100";
    constant SMALL  : STRENGTH := "00000010";
    constant HIGHZ  : STRENGTH := "00000000";  

  --######################################################################--
  --                                                                      -- 
  --  CONVERSION OPERATORS:                                               --
  --                                                                      -- 
  --    The following are the specifications for the functions that       --
  --    represent the conversion to type MVL and MVL_VECTOR from          --
  --    STD_LOGIC and STL_LOGIC_VECTOR, and vice versa.                   --
  --                                                                      -- 
  --######################################################################--

    function To_StdLogicVector(ARG: MVL_VECTOR) return STD_LOGIC_VECTOR => "buf";
    function To_StdLogic(ARG: MVL) return STD_LOGIC; -- see body
    function To_StdLogicVector(ARG: MVL_VECTOR; SIZE: INTEGER) 
				return STD_LOGIC_VECTOR => "trim";
    function To_MvlVector(ARG: STD_LOGIC_VECTOR) return MVL_VECTOR => "buf";
    function To_Mvl(ARG: STD_LOGIC) return MVL => "buf";
    function To_MvlVector(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) 
				return MVL_VECTOR => "trim";

  --######################################################################--
  --                                                                      -- 
  --  OVERLOADED OPERATORS:                                               --
  --                                                                      -- 
  --    The following are the specifications for the functions that       --
  --    represent the operators for the type MVL and MVL_VECTOR. VHDL     --
  --    operators have been overloaded wherever possible.                 --
  --                                                                      -- 
  --######################################################################--
    
    -- LOGICAL OPERATORS 
                                                
    function "and" (op1, op2 : MVL_VECTOR)       return MVL_VECTOR => "and";
    function "and" (op1: MVL; op2 : MVL_VECTOR)  return MVL_VECTOR => "and";
    function "and" (op1: MVL_VECTOR; op2 : MVL)  return MVL_VECTOR => "and";
    function "and" (op1, op2 : MVL)              return MVL => "and"; 
 
--    function "and" (op1, op2 : MVL_VECTOR)       return BOOLEAN;
--    function "and" (op1: MVL; op2 : MVL_VECTOR)  return BOOLEAN;
--    function "and" (op1: MVL_VECTOR; op2 : MVL)  return BOOLEAN;
--    function "and" (op1, op2 : MVL)              return BOOLEAN; 

    function "or"  (op1, op2 : MVL_VECTOR)       return MVL_VECTOR => "or";   
    function "or"  (op1: MVL; op2 : MVL_VECTOR)  return MVL_VECTOR => "or";   
    function "or"  (op1: MVL_VECTOR; op2 : MVL)  return MVL_VECTOR => "or"; 
    function "or"  (op1, op2 : MVL)              return MVL => "or"; 

--    function "or"  (op1, op2 : MVL_VECTOR)       return BOOLEAN;   
--    function "or"  (op1: MVL; op2 : MVL_VECTOR)  return BOOLEAN;  
--    function "or"  (op1: MVL_VECTOR; op2 : MVL)  return BOOLEAN;  
--    function "or"  (op1, op2 : MVL)              return BOOLEAN; 
 
    function "xor" (op1, op2 : MVL_VECTOR)       return MVL_VECTOR => "xor";
    function "xor" (op1: MVL; op2 : MVL_VECTOR)  return MVL_VECTOR => "xor";
    function "xor" (op1: MVL_VECTOR; op2 : MVL)  return MVL_VECTOR => "xor";
    function "xor" (op1, op2 : MVL)              return MVL => "xor"; 

--    function "xor" (op1, op2 : MVL_VECTOR)       return BOOLEAN;
--    function "xor" (op1: MVL; op2 : MVL_VECTOR)  return BOOLEAN;
--    function "xor" (op1: MVL_VECTOR; op2 : MVL)  return BOOLEAN;
--    function "xor" (op1, op2 : MVL)              return BOOLEAN; 

    function "nand" (op1, op2 : MVL_VECTOR)      return MVL_VECTOR => "nand";
    function "nand" (op1: MVL; op2 : MVL_VECTOR) return MVL_VECTOR => "nand";
    function "nand" (op1: MVL_VECTOR; op2 : MVL) return MVL_VECTOR => "nand";
    function "nand" (op1, op2 : MVL)             return MVL => "nand"; 

 --   function "nand" (op1, op2 : MVL_VECTOR)      return BOOLEAN;
 --   function "nand" (op1: MVL; op2 : MVL_VECTOR) return BOOLEAN;
 --   function "nand" (op1: MVL_VECTOR; op2 : MVL) return BOOLEAN;
 --   function "nand" (op1, op2 : MVL)             return BOOLEAN; 

    function "nor"  (op1, op2 : MVL_VECTOR)      return MVL_VECTOR => "nor";   
    function "nor"  (op1: MVL; op2 : MVL_VECTOR) return MVL_VECTOR => "nor";   
    function "nor"  (op1: MVL_VECTOR; op2 : MVL) return MVL_VECTOR => "nor"; 
    function "nor"  (op1, op2 : MVL)             return MVL => "nor"; 

--    function "nor"  (op1, op2 : MVL_VECTOR)      return BOOLEAN;   
--    function "nor"  (op1: MVL; op2 : MVL_VECTOR) return BOOLEAN;  
--    function "nor"  (op1: MVL_VECTOR; op2 : MVL) return BOOLEAN;  
--    function "nor"  (op1, op2 : MVL)             return BOOLEAN; 

    -- NOT OPERATOR 

    function "not" (op1 : MVL_VECTOR)           return MVL_VECTOR => "not";
    function "not" (op1 : MVL)                  return MVL => "not"; 

--    function "not" (op1 : MVL_VECTOR)           return BOOLEAN;
--    function "not" (op1 : MVL)                  return BOOLEAN;

    -- RELATIONAL FUNCTIONS 
    
    function eq  (op1, op2 : MVL_VECTOR)      return MVL;
    function eq  (op1: MVL; op2 : MVL_VECTOR) return MVL;
    function eq  (op1: MVL_VECTOR; op2 : MVL) return MVL;
    function eq  (op1, op2 : MVL)             return MVL; 

    function neq (op1, op2 : MVL_VECTOR)      return MVL;
    function neq (op1: MVL; op2 : MVL_VECTOR) return MVL;
    function neq (op1: MVL_VECTOR; op2 : MVL) return MVL;  
    function neq (op1, op2 : MVL)             return MVL; 

    function lt  (op1, op2 : MVL_VECTOR)      return MVL;
    function lt  (op1: MVL; op2 : MVL_VECTOR) return MVL;
    function lt  (op1: MVL_VECTOR; op2 : MVL) return MVL;
    function lt  (op1, op2 : MVL)             return MVL; 

    function lte (op1, op2 : MVL_VECTOR)      return MVL;
    function lte (op1: MVL; op2 : MVL_VECTOR) return MVL;
    function lte (op1: MVL_VECTOR; op2 : MVL) return MVL;
    function lte (op1, op2 : MVL)             return MVL; 

    function gt  (op1, op2 : MVL_VECTOR)      return MVL;
    function gt  (op1: MVL; op2 : MVL_VECTOR) return MVL;
    function gt  (op1: MVL_VECTOR; op2 : MVL) return MVL;
    function gt  (op1, op2 : MVL)             return MVL; 

    function gte (op1, op2 : MVL_VECTOR)      return MVL;
    function gte (op1: MVL; op2 : MVL_VECTOR) return MVL;
    function gte (op1: MVL_VECTOR; op2 : MVL) return MVL;
    function gte (op1, op2 : MVL)             return MVL; 

    -- ADDING OPERATORS 

    function "+"   (op1, op2 : MVL_VECTOR)	  return MVL_VECTOR; -- see body
    function "+"   (op1 : MVL; op2 : MVL_VECTOR)  return MVL_VECTOR; -- see body 
    function "+"   (op1 : MVL_VECTOR; op2 : MVL)  return MVL_VECTOR; -- see body
    function "+"   (op1, op2 : MVL)               return MVL => "xor";

    function "+"   (op1: UNSIGNED; op2: UNSIGNED) return UNSIGNED => "plus";
    function "+"   (op1: SIGNED;   op2: SIGNED)   return SIGNED => "splus";
    function "+"   (op1: UNSIGNED; op2: SIGNED)   return SIGNED => "splus";
    function "+"   (op1: SIGNED;   op2: UNSIGNED) return SIGNED => "splus";

    function "-"   (op1, op2 : MVL_VECTOR)      return MVL_VECTOR;
    function "-"   (op1: MVL; op2 : MVL_VECTOR) return MVL_VECTOR;
    function "-"   (op1: MVL_VECTOR; op2 : MVL) return MVL_VECTOR;
    function "-"   (op1, op2 : MVL)             return MVL => "xor";

    function "-"   (op1: UNSIGNED; op2: UNSIGNED) return UNSIGNED => "minus";
    function "-"   (op1: SIGNED;   op2: SIGNED)   return SIGNED => "sminus";
    function "-"   (op1: UNSIGNED; op2: SIGNED)   return SIGNED => "sminus";
    function "-"   (op1: SIGNED;   op2: UNSIGNED) return SIGNED => "sminus";

    -- UNARY OPERATORS

    function "-" (op1: MVL_VECTOR) return MVL_VECTOR => "uminus";
    function "-" (op1: MVL)        return MVL_VECTOR => "uminus";
    function "-" (op1: SIGNED)     return SIGNED => "uminus";

    function "+" (op1: UNSIGNED)   return UNSIGNED => "buf";
    function "+" (op1: SIGNED)     return SIGNED => "buf";

    function "ABS" (op1: SIGNED)   return SIGNED;

    -- MULTIPLYING OPERATORS 
 
    function "*"   (op1, op2 : MVL_VECTOR)      return MVL_VECTOR;
    function "*"   (op1: MVL; op2 : MVL_VECTOR) return MVL_VECTOR;
    function "*"   (op1: MVL_VECTOR; op2 : MVL) return MVL_VECTOR;
    function "*"   (op1, op2 : MVL)             return MVL => "and";
 
    function "/"   (op1, op2 : MVL_VECTOR)      return MVL_VECTOR => "div";
    function "/"   (op1: MVL; op2 : MVL_VECTOR) return MVL_VECTOR => "div";
    function "/"   (op1: MVL_VECTOR; op2 : MVL) return MVL_VECTOR => "div";
    function "/"   (op1, op2 : MVL)             return MVL => "div";
 
    function "mod"   (op1, op2 : MVL_VECTOR)      return MVL_VECTOR => "mod";
    function "mod"   (op1: MVL; op2 : MVL_VECTOR) return MVL_VECTOR => "mod";
    function "mod"   (op1: MVL_VECTOR; op2 : MVL) return MVL_VECTOR => "mod";
    function "mod"   (op1, op2 : MVL)             return MVL => "mod";

    -- CONDITIONAL FUNCTIONS 
	-- not implemented
    function cond_op (cond, left_val, right_val: MVL_VECTOR) return MVL_VECTOR ;
    function cond_op (cond, left_val, right_val: MVL)        return MVL ;

    function cond_op (cond, left_val: MVL; right_val: MVL_VECTOR)
       return MVL_VECTOR;
    function cond_op (cond: MVL; left_val, right_val: MVL_VECTOR)
       return MVL_VECTOR;
    function cond_op (cond: MVL; left_val: MVL_VECTOR; right_val: MVL)
       return MVL_VECTOR;

    function cond_op (cond: MVL_VECTOR; left_val, right_val: MVL)
       return MVL_VECTOR;
    function cond_op (cond: MVL_VECTOR; left_val: MVL_VECTOR; right_val: MVL)
       return MVL_VECTOR;
    function cond_op (cond: MVL_VECTOR; left_val: MVL; right_val: MVL_VECTOR)
       return MVL_VECTOR;

    -- REDUCTION FUNCTIONS  
    function red_and  (op1 : MVL_VECTOR) return MVL; -- see body
    function red_and  (op1 : MVL)        return MVL; -- see body
    function red_and  (oper: BIT_VECTOR) return BIT; 

    function red_nand (op1 : MVL_VECTOR) return MVL; -- see body
    function red_nand (op1 : MVL)        return MVL; -- see body
    function red_nand (oper: BIT_VECTOR) return BIT;

    function red_or   (op1 : MVL_VECTOR) return MVL; -- see body
    function red_or   (op1 : MVL)        return MVL; -- see body
    function red_or   (oper: BIT_VECTOR) return BIT;

    function red_nor  (op1 : MVL_VECTOR) return MVL; -- see body
    function red_nor  (op1 : MVL)        return MVL; -- see body
    function red_nor  (oper: BIT_VECTOR) return BIT;

    function red_xor  (op1 : MVL_VECTOR) return MVL; -- see body
    function red_xor  (op1 : MVL)        return MVL; -- see body
    function red_xor  (oper: BIT_VECTOR) return BIT;

    function red_xnor (op1 : MVL_VECTOR) return MVL; -- see body
    function red_xnor (op1 : MVL)        return MVL; -- see body
    function red_xnor (oper: BIT_VECTOR) return BIT;


    -- SHIFT FUNCTIONS 

    function sh_left  (op1: MVL_VECTOR; op2 : NATURAL)  return MVL_VECTOR => "sll";
    function sh_left  (oper: UNSIGNED; COUNT: UNSIGNED) return UNSIGNED => "sll";
    function sh_left  (oper: SIGNED; COUNT: UNSIGNED)   return SIGNED => "sll";

    function sh_right (op1: MVL_VECTOR; op2 : NATURAL)  return MVL_VECTOR => "srl";
    function sh_right (oper: UNSIGNED; COUNT: UNSIGNED) return UNSIGNED => "srl";
    function sh_right (oper: SIGNED; COUNT: UNSIGNED)   return SIGNED => "srl";


    -- CASE COMPARISON FUNCTIONS
 
    function case_eq  (op1, op2 : MVL_VECTOR)      return MVL => "eq";
    function case_eq  (op1: MVL; op2 : MVL_VECTOR) return MVL => "eq";
    function case_eq  (op1: MVL_VECTOR; op2 : MVL) return MVL => "eq";
    function case_eq  (op1, op2 : MVL)             return MVL => "eq";
 
    function case_neq (op1, op2 : MVL_VECTOR)      return MVL => "noteq";
    function case_neq (op1: MVL; op2 : MVL_VECTOR) return MVL => "noteq";
    function case_neq (op1: MVL_VECTOR; op2 : MVL) return MVL => "noteq";
    function case_neq (op1, op2 : MVL)             return MVL => "noteq";

	-- not implemented 
    function casez_eq (exp1, exp2 : in MVL_VECTOR) return BOOLEAN;
    function casex_eq (exp1, exp2 : in MVL_VECTOR) return BOOLEAN;
 

    -- RELATIONAL FUNCTIONS FOR SIGNED/UNSIGNED
 
    function slt   (op1: SIGNED;     op2: SIGNED)   return BOOLEAN => "slt";
    function slt   (op1: UNSIGNED;   op2: SIGNED)   return BOOLEAN => "slt";
    function slt   (op1: SIGNED;     op2: UNSIGNED) return BOOLEAN => "slt";
    
    function sle   (op1: SIGNED;     op2: SIGNED)   return BOOLEAN => "sle";
    function sle   (op1: UNSIGNED;   op2: SIGNED)   return BOOLEAN => "sle";
    function sle   (op1: SIGNED;     op2: UNSIGNED) return BOOLEAN => "sle";
    
    function sgt   (op1: SIGNED;     op2: SIGNED)   return BOOLEAN => "sgt";
    function sgt   (op1: UNSIGNED;   op2: SIGNED)   return BOOLEAN => "sgt";
    function sgt   (op1: SIGNED;     op2: UNSIGNED) return BOOLEAN => "sgt";
     
    function sge   (op1: SIGNED;     op2: SIGNED)   return BOOLEAN => "sge";
    function sge   (op1: UNSIGNED;   op2: SIGNED)   return BOOLEAN => "sge";
    function sge   (op1: SIGNED;     op2: UNSIGNED) return BOOLEAN => "sge";
     
    function seq   (op1: UNSIGNED;   op2: SIGNED)   return BOOLEAN => "eq";
    function seq   (op1: SIGNED;     op2: UNSIGNED) return BOOLEAN => "eq";
     
    function sne   (op1: UNSIGNED;   op2: SIGNED)   return BOOLEAN => "noteq";
    function sne   (op1: SIGNED;     op2: UNSIGNED) return BOOLEAN => "noteq";
 

--###########################################################################--
--                                                                           --
-- UTILITY FUNCTIONS:                                                        --
--                                                                           --
--###########################################################################--

    -- DEFINITIONS FOR FUNCTIONS FOR DRIVING VARIOUS TYPES
	
    function drive (V: MVL)         return MVL => "buf";
    function drive (V: MVL_VECTOR)  return MVL_VECTOR => "buf";
    function drive (V: MVL_VECTOR)  return WIRE_VECTOR => "buf";
    function drive (V: MVL_VECTOR)  return WAND_VECTOR => "buf";
    function drive (V: MVL_VECTOR)  return WOR_VECTOR => "buf";
    function drive (V: MVL_VECTOR)  return TRI1_VECTOR => "buf";
    function drive (V: MVL_VECTOR)  return TRI0_VECTOR => "buf";
    function drive (V: MVL_VECTOR)  return SUPPLY1_VECTOR => "buf";
    function drive (V: MVL_VECTOR)  return SUPPLY0_VECTOR => "buf";

    -- DEFINITIONS FOR SENSING VARIOUS TYPES
	-- not implemented
    function sense (V: MVL)  return MVL;
    function sense (V: MVL_VECTOR)      return MVL_VECTOR;
    function sense (V: WIRE_VECTOR)     return MVL_VECTOR;
    function sense (V: WAND_VECTOR)     return MVL_VECTOR;
    function sense (V: WOR_VECTOR)      return MVL_VECTOR;
    function sense (V: TRI1_VECTOR)     return MVL_VECTOR;
    function sense (V: TRI0_VECTOR)     return MVL_VECTOR;
    function sense (V: SUPPLY1_VECTOR)  return MVL_VECTOR;
    function sense (V: SUPPLY0_VECTOR)  return MVL_VECTOR;

    function sense (V: MVL;            vZ: MVL_X01Z)  return MVL;
    function sense (V: MVL_VECTOR;     vZ: MVL_X01Z)  return MVL_VECTOR;
    function sense (V: WIRE_VECTOR;    vZ: MVL_X01Z)  return MVL_VECTOR;
    function sense (V: WAND_VECTOR;    vZ: MVL_X01Z)  return MVL_VECTOR;
    function sense (V: WOR_VECTOR;     vZ: MVL_X01Z)  return MVL_VECTOR;
    function sense (V: TRI1_VECTOR;    vZ: MVL_X01Z)  return MVL_VECTOR;
    function sense (V: TRI0_VECTOR;    vZ: MVL_X01Z)  return MVL_VECTOR;
    function sense (V: SUPPLY1_VECTOR; vZ: MVL_X01Z)  return MVL_VECTOR;
    function sense (V: SUPPLY0_VECTOR; vZ: MVL_X01Z)  return MVL_VECTOR;

    -- CONVERSION TO MVL FROM BIT, BOOLEAN OR INTEGER

    function to_mvl  (oper : BIT)        return MVL => "buf";
    function to_mvl  (oper : BOOLEAN)    return MVL => "buf";

    function to_mvlv (oper : BIT)        return MVL_VECTOR; -- see body
    function to_mvlv (oper : MVL)        return MVL_VECTOR; -- see body
    function to_mvlv (oper : BOOLEAN)    return MVL_VECTOR; -- see body
    function to_mvlv (oper : BIT_VECTOR) return MVL_VECTOR => "buf";
    function to_mvlv (oper: INTEGER; length: INTEGER := -1) return MVL_VECTOR => "buf";

    -- CONVERSION TO INTEGER FROM MVL and MVL_VECTOR

    function to_integer (oper : MVL_VECTOR) return INTEGER => "bufi";
    function to_integer (oper: MVL)         return INTEGER => "bufi";

    -- CONVERSION TO INTEGER FROM BIT and BIT_VECTOR

    function to_integer (oper: BIT)         return INTEGER => "bufi";
    function to_integer (oper : BIT_VECTOR) return INTEGER => "bufi";

    -- CONVERSION TO INTEGER FROM SIGNED and UNSIGNED

    function to_integer (oper: SIGNED)      return INTEGER => "bufsi";
    function to_integer (oper: UNSIGNED)    return INTEGER => "bufi";

    -- CONVERSION TO BOOLEAN
 
    function  to_boolean (oper: MVL_VECTOR) return BOOLEAN => "buf";
    function  to_boolean (oper: MVL)        return BOOLEAN => "buf";

     -- CONVERSION TO BIT and BIT_VECTOR
 
    function  to_bit  (oper: MVL)        return BIT=> "buf";
    function  to_bit  (oper: BOOLEAN)    return BIT=> "buf";

    function  to_bitv (oper: MVL)        return BIT_VECTOR => "buf";
    function  to_bitv (oper: BIT)        return BIT_VECTOR => "buf";
    function  to_bitv (oper: BOOLEAN)    return BIT_VECTOR => "buf";
    function  to_bitv (oper: MVL_VECTOR) return BIT_VECTOR => "buf";
    function  to_bitv (oper: INTEGER; length: INTEGER := -1) return BIT_VECTOR => "buf";

    function  to_bitv (oper: SIGNED; size: POSITIVE)    return BIT_VECTOR => "buf";
    function  to_bitv (oper: UNSIGNED; size: POSITIVE)  return BIT_VECTOR => "buf";

    -- CONVERSION TO UNSIGNED   

    function  to_unsigned (oper: INTEGER; size: POSITIVE)  return UNSIGNED => "trim";
    function  to_unsigned (oper: SIGNED; size: POSITIVE)   return UNSIGNED => "trim";
    function  to_unsigned (oper: BIT_VECTOR; size: POSITIVE)  return UNSIGNED => "trim";

    -- CONVERSION TO SIGNED   

    function  to_signed (oper: INTEGER; size: POSITIVE)     return SIGNED => "strim";
    function  to_signed (oper: UNSIGNED; size: POSITIVE)    return SIGNED => "strim";
    function  to_signed (oper: BIT_VECTOR; size: POSITIVE)  return SIGNED => "strim";

    -- FUNCTION TO ALLOW ASSIGNMENTS OF MVL_VECTORS OF UNEQUAL SIZES 

    function align_size (oper : MVL_VECTOR; size : NATURAL) return MVL_VECTOR => "trim";
    function align_size (oper : MVL;        size : NATURAL) return MVL_VECTOR => "trim";
    function align_size (oper : MVL;        size : NATURAL) return MVL => "buf";
    function align_size (oper : MVL_VECTOR; size : NATURAL) return MVL; -- see body

    -- FUNCTION TO ALLOW ASSIGNMENTS OF SIGNED/UNSIGNED OF UNEQUAL SIZES 

    function align_size (oper : SIGNED;     size : NATURAL) return SIGNED => "strim";
    function align_size (oper : UNSIGNED;   size : NATURAL) return SIGNED => "trim";
    function align_size (oper : UNSIGNED;   size : NATURAL) return UNSIGNED => "trim";
    function align_size (oper : SIGNED;     size : NATURAL) return UNSIGNED => "strim";

    -- PROCEDURE TO FINISH SIMULATION
	-- not implemented
    procedure finish (MESSAGE : STRING := "Finishing Simulation");

    -- FUNCTIONS NEEDED BY PREDEFINED XL_GATES 
 	-- not implemented
    function get_0_strength (m1: MVL) return STRENGTH;
    function get_1_strength (m1: MVL) return STRENGTH;
    function get_mvl_0      (b1, b2, b3, b4, b5, b6, b7, b8: BIT) return MVL;
    function get_mvl_1      (b1, b2, b3, b4, b5, b6, b7, b8: BIT) return MVL;
    function get_coerced_L  (b1, b2, b3, b4, b5, b6, b7, b8: BIT) return MVL;
    function get_coerced_H  (b1, b2, b3, b4, b5, b6, b7, b8: BIT) return MVL;
    function get_tern_val   (m1: MVL) return MVL;
    function modify_mos_strength (m1: MVL) return MVL;
    function reduce_mos_strength (m1: MVL) return MVL;
    function get_coerced_val (value: MVL; strength0, strength1: STRENGTH)
                                           return MVL;
    function get_coerced_val (value: MVL_VECTOR; strength0, strength1: STRENGTH)
                                           return MVL_VECTOR;
    function fill_mvl_vector (value: MVL; size: INTEGER) return MVL_VECTOR ;
 
    function get_delay2 (d1, d2: TIME;  value: MVL)           return TIME;
    function get_delay2 (d1, d2: TIME;  value: MVL_VECTOR)    return TIME;
    function get_delay3 (d1, d2, d3: TIME; value: MVL)        return TIME;
    function get_delay3 (d1, d2, d3: TIME; value: MVL_VECTOR) return TIME;

    -- FUNCTION TO READ PLAs
	-- not implemented
--    procedure SYS_READMEMB (variable FILE_NAME: in     TEXT;
--                                     DATA :     inout  MVL_VECTOR);

    -- Procedure to execute a system command
	-- not implemented
    procedure SYSTEM (command : in STRING);

    -- Function to return time in MVL_VECTOR
	-- not implemented
--    function  SYS_TIME (time_unit : time) return MVL_VECTOR;
	
    -- Procedure to execute a PLI task
    -- This procedure allows the user to execute a PLI routine from
    -- VHDL code. The argument to CALL_PLI is the actual PLI call
    -- and its parameters e.g. call_pli("$delay_calc(top)");

    procedure CALL_PLI (pli_command_with_arguments : in STRING);
	-- not implemented

end XL_STD;

package body XL_STD is

function To_StdLogic(op1: MVL) return STD_LOGIC is
variable tmp: STD_LOGIC;
begin
  case op1 is
	when '0' => tmp := '0';
    when '1' => tmp := '1';
	when 'X' => tmp := 'X';
	when 'Z' => tmp := 'Z';
	when others => tmp := 'X';
  end case;
  return(tmp);
end;
	
function "+"(op1: MVL_VECTOR; op2: MVL_VECTOR) return MVL_VECTOR is
begin
   if (op1'length < op2'length) then
     return(To_MvlVector(To_StdLogicVector(op1) + To_StdLogicVector(op2), op2'length));
   else
   	 return(To_MvlVector(To_StdLogicVector(op1) + To_StdLogicVector(op2), op1'length));
   end if;
end;

function "+"(op1: MVL_VECTOR; op2: MVL) return MVL_VECTOR is
begin
   return(To_MvlVector(To_StdLogicVector(op1) + To_StdLogic(op2), op1'length));
end;

function "+"(op1: MVL; op2: MVL_VECTOR) return MVL_VECTOR is
begin
   return(To_MvlVector(To_StdLogic(op1) + To_StdLogicVector(op2), op2'length));
end;

function "-"(op1: MVL_VECTOR; op2: MVL_VECTOR) return MVL_VECTOR is
begin
   if (op1'length < op2'length) then
     return(To_MvlVector(To_StdLogicVector(op1) - To_StdLogicVector(op2), op2'length));
   else
   	 return(To_MvlVector(To_StdLogicVector(op1) - To_StdLogicVector(op2), op1'length));
   end if;
end;

function "-"(op1: MVL_VECTOR; op2: MVL) return MVL_VECTOR is
begin
   return(To_MvlVector(To_StdLogicVector(op1) - To_StdLogic(op2), op1'length));
end;

function "-"(op1: MVL; op2: MVL_VECTOR) return MVL_VECTOR is
begin
   return(To_MvlVector(To_StdLogic(op1) - To_StdLogicVector(op2), op2'length));
end;

function "*"(op1: MVL_VECTOR; op2: MVL_VECTOR) return MVL_VECTOR is
begin
   return(To_MvlVector(To_StdLogicVector(op1) * To_StdLogicVector(op2)));
end;

function "*"(op1: MVL_VECTOR; op2: MVL) return MVL_VECTOR is
begin
   return(To_MvlVector(To_StdLogicVector(op1, op1'length) * To_StdLogic(op2)));
end;

function "*"(op1: MVL; op2: MVL_VECTOR) return MVL_VECTOR is
begin
   return(To_MvlVector(To_StdLogic(op1) * To_StdLogicVector(op2, op2'length)));
end;

function align_size (oper : MVL_VECTOR; size : NATURAL) return MVL is
begin
	return(oper(oper'RIGHT));
end;

function red_and (op1: MVL_VECTOR) return MVL is 
   variable result: MVL; 
   variable has_no_X: BOOLEAN := TRUE;
begin 

   for I in op1'RANGE loop 
     case (op1(I)) is
       when '0' =>
         return ('0');       -- result is '0'
       when '1' => 
         null;
       when others =>
         has_no_X := FALSE;  -- value is 'X', set flag to FALSE
            end case;  
   end loop; 
                                       -- op1 has no '0's
   if (has_no_X) then
     return ('1');              -- result is '1'
   end if;
   return ('X');              -- result is 'X'
end red_and;  

function red_and (op1: MVL) return MVL is 
begin 
        return (op1);
end red_and;  

function red_nand (op1: MVL_VECTOR) return MVL is 
   variable result: MVL; 
   variable has_no_X: BOOLEAN := TRUE;

begin 
  for I in op1'RANGE loop
    case (op1(I)) is
      when '0' =>
        return ('1');       -- result is '1'
      when '1' => 
        null;
      when others =>
        has_no_X := FALSE;  -- value is 'X', set flag to FALSE
    end case;  
  end loop; 
                                       -- op1 has no '0's
  if (has_no_X) then
    return ('0');              -- result is '0'
  end if;
  return ('X');              -- result is 'X'
end red_nand;  

function red_nand (op1: MVL) return MVL is 
begin 
  case (op1) is
    when '1' =>
      return '0';
    when '0' =>
      return '1';
    when others =>
      return 'X';
    end case;
end red_nand;  


function red_or (op1: MVL_VECTOR) return MVL is 
   variable result: MVL; 
   variable has_no_X: BOOLEAN := TRUE;

begin 
  for I in op1'RANGE loop
    case (op1(I)) is
      when '0' =>
        null;
      when '1' => 
        return ('1');       -- result is '1'
      when others =>
        has_no_X := FALSE;  -- value is 'X', set flag to FALSE
    end case;  
  end loop; 
                                       -- op1 has no '1's
  if (has_no_X) then
    return ('0');              -- result is '0'
  end if;
  return ('X');              -- result is 'X'
end red_or;  

function red_or (op1: MVL) return MVL is 
begin 
  return (op1);
end red_or;  

function red_nor (op1: MVL_VECTOR) return MVL is 
  variable result: MVL; 
  variable has_no_X: BOOLEAN := TRUE;

begin 
  for I in op1'RANGE loop
    case (op1(I)) is
      when '0' =>
        null;
      when '1' => 
        return ('0');       -- result is '0'
      when others =>
        has_no_X := FALSE;  -- value is 'X', set flag to FALSE
    end case;  
  end loop; 
                                       -- op1 has no '1's
  if (has_no_X) then
    return ('1');              -- result is '1'
  end if;
  return ('X');              -- result is 'X'
end red_nor;  

function red_nor (op1: MVL) return MVL is 
begin 
  case (op1) is
    when '1' =>
      return '0';
    when '0' =>
      return '1';
    when others =>
      return 'X';
    end case;
end red_nor;  

function red_xor (op1: MVL_VECTOR) return MVL is 
  variable bit_result: BIT := '0'; 
begin 
  for I in op1'RANGE loop
    case (op1(I)) is
      when 'X' =>
        return ('X');       -- value is 'X', result is 'X' 
      when '1' =>
        bit_result := bit_result xor '1';
      when '0' =>
        bit_result := bit_result xor '0';
      when others =>
        null;
    end case;  
  end loop;  
  if (bit_result = '0') then          -- invert result
    return ('0');
  else
    return ('1'); 
  end if;

end red_xor;  

function red_xor (op1: MVL) return MVL is 
begin 
    return (op1);
end red_xor;  

function red_xnor (op1: MVL_VECTOR) return MVL is 
  variable bit_result : BIT := '0';
begin 
  for I in op1'RANGE loop
    case (op1(I)) is
      when 'X' =>
        return ('X');       -- value is 'X', result is 'X' 
      when '1'=>
        bit_result := bit_result xor '1';
      when '0' =>
        bit_result := bit_result xor '0';
      when others =>
        null;
    end case;  
  end loop;  

  if (bit_result = '0') then          -- invert result
    return ('1');
  else
    return ('0'); 
  end if;
end red_xnor;  

function red_xnor (op1: MVL) return MVL is 
begin 
  case (op1) is
    when '1' =>
      return '0';
    when '0' =>
      return '1';
    when others =>
      return 'X';
  end case;
end red_xnor;  

function fill_mvl_vector (value: MVL; size: INTEGER) return MVL_VECTOR is
variable mask: MVL_VECTOR(size-1 downto 0);
begin
  mask := (size-1 downto 0 => value);
  return (mask);
end fill_mvl_vector;

function to_mvlv(oper: bit) return mvl_vector is
 variable RETURN_VECTOR : MVL_VECTOR (0 to 0);
    begin
        case oper is
            when '1' => RETURN_VECTOR(0) := '1';
            when '0' => RETURN_VECTOR(0) := '0';
        end case;
        return(RETURN_VECTOR);
end to_mvlv;

function to_mvlv (oper : MVL) return MVL_VECTOR is
 variable RETURN_VECTOR : MVL_VECTOR (0 to 0);
begin
        RETURN_VECTOR(0) := oper;
        return(RETURN_VECTOR);
end to_mvlv;

function to_mvlv (oper : BOOLEAN) return MVL_VECTOR is
 variable RETURN_VECTOR : MVL_VECTOR (0 to 0);
begin
  case oper is
     when TRUE => RETURN_VECTOR(0) := '1';
     when FALSE => RETURN_VECTOR(0) := '0';
  end case;
  return(RETURN_VECTOR);
end to_mvlv;

function eq (op1, op2: mvl) return mvl is
  begin
    if ( op1 = op2) then
     return '1';
    else
     return '0';
    end if;
end eq;

function eq (op1, op2: mvl_vector) return mvl is
  begin
    if ( op1 = op2) then
     return '1';
    else
     return '0';
    end if;
end eq;

function eq (op1: mvl; op2: mvl_vector) return mvl is
  variable t : mvl_vector(op2'length -1 downto 0);
  begin
	t := align_size(op1, op2'length);
    if ( t = op2) then
     return '1';
    else
     return '0';
    end if;
end eq;

function eq (op1: mvl_vector; op2: mvl) return mvl is
  variable t : mvl_vector(op1'length -1 downto 0);
  begin
	t := align_size(op2, op1'length);
    if ( t = op1) then
     return '1';
    else
     return '0';
    end if;
end eq;

function neq (op1, op2: mvl) return mvl is
  begin
    if ( op1 /= op2) then
     return '1';
    else
     return '0';
    end if;
end neq;

function neq (op1, op2: mvl_vector) return mvl is
  begin
    if ( op1 /= op2) then
     return '1';
    else
     return '0';
    end if;
end neq;

function neq (op1: mvl; op2: mvl_vector) return mvl is
  variable t : mvl_vector(op2'length -1 downto 0);
  begin
	t := align_size(op1, op2'length);
    if ( t /= op2) then
     return '1';
    else
     return '0';
    end if;
end neq;

function neq (op1: mvl_vector; op2: mvl) return mvl is
  variable t : mvl_vector(op1'length -1 downto 0);
  begin
	t := align_size(op2, op1'length);
    if ( t /= op1) then
     return '1';
    else
     return '0';
    end if;
end neq;

function lt (op1, op2: mvl) return mvl is
  begin
    if ( op1 < op2) then
     return '1';
    else
     return '0';
    end if;
end lt;

function lt (op1, op2: mvl_vector) return mvl is
  begin
    if ( op1 < op2) then
     return '1';
    else
     return '0';
    end if;
end lt;

function lt (op1: mvl; op2: mvl_vector) return mvl is
  variable t : mvl_vector(op2'length -1 downto 0);
  begin
	t := align_size(op1, op2'length);
    if ( t < op2) then
     return '1';
    else
     return '0';
    end if;
end lt;

function lt (op1: mvl_vector; op2: mvl) return mvl is
  variable t : mvl_vector(op1'length -1 downto 0);
  begin
	t := align_size(op2, op1'length);
    if (op1 < t) then
     return '1';
    else
     return '0';
    end if;
end lt;

function lte (op1, op2: mvl) return mvl is
  begin
    if ( op1 <= op2) then
     return '1';
    else
     return '0';
    end if;
end lte;

function lte (op1, op2: mvl_vector) return mvl is
  begin
    if ( op1 <= op2) then
     return '1';
    else
     return '0';
    end if;
end lte;

function lte (op1: mvl; op2: mvl_vector) return mvl is
  variable t : mvl_vector(op2'length -1 downto 0);
  begin
	t := align_size(op1, op2'length);
    if ( t <= op2) then
     return '1';
    else
     return '0';
    end if;
end lte;

function lte (op1: mvl_vector; op2: mvl) return mvl is
  variable t : mvl_vector(op1'length -1 downto 0);
  begin
	t := align_size(op2, op1'length);
    if (op1 <= t) then
     return '1';
    else
     return '0';
    end if;
end lte;

function gt (op1, op2: mvl) return mvl is
  begin
    if ( op1 > op2) then
     return '1';
    else
     return '0';
    end if;
end gt;

function gt (op1, op2: mvl_vector) return mvl is
  begin
    if ( op1 > op2) then
     return '1';
    else
     return '0';
    end if;
end gt;

function gt (op1: mvl; op2: mvl_vector) return mvl is
  variable t : mvl_vector(op2'length -1 downto 0);
  begin
	t := align_size(op1, op2'length);
    if ( t > op2) then
     return '1';
    else
     return '0';
    end if;
end gt;

function gt (op1: mvl_vector; op2: mvl) return mvl is
  variable t : mvl_vector(op1'length -1 downto 0);
  begin
	t := align_size(op2, op1'length);
    if (op1 > t) then
     return '1';
    else
     return '0';
    end if;
end gt;

function gte (op1, op2: mvl) return mvl is
  begin
    if ( op1 >= op2) then
     return '1';
    else
     return '0';
    end if;
end gte;

function gte (op1, op2: mvl_vector) return mvl is
  begin
    if ( op1 >= op2) then
     return '1';
    else
     return '0';
    end if;
end gte;

function gte (op1: mvl; op2: mvl_vector) return mvl is
  variable t : mvl_vector(op2'length -1 downto 0);
  begin
	t := align_size(op1, op2'length);
    if ( t >= op2) then
     return '1';
    else
     return '0';
    end if;
end gte;

function gte (op1: mvl_vector; op2: mvl) return mvl is
  variable t : mvl_vector(op1'length -1 downto 0);
  begin
	t := align_size(op2, op1'length);
    if (op1 >= t) then
     return '1';
    else
     return '0';
    end if;
end gte;

end XL_STD;

