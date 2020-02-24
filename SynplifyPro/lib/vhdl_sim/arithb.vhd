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

library IEEE;
use IEEE.std_logic_1164.all;

package body std_logic_arith is

    function max(L, R: INTEGER) return INTEGER is
    variable result :INTEGER;
    begin
        if L > R then
  	   result := L;
        else
	   result := R;
	end if;

        return result;
    end;


    function min(L, R: INTEGER) return INTEGER is
    variable result :INTEGER;
    begin
	if L < R then
	    result := L;
	else
	    result := R;
	end if;

        return result;
    end;

    type tbl_type is array (STD_ULOGIC) of STD_ULOGIC;
    constant tbl_BINARY : tbl_type :=
	('X', 'X', '0', '1', 'X', 'X', '0', '1', 'X');

    type tbl_mvl9_boolean is array (STD_ULOGIC) of boolean;
    constant IS_X : tbl_mvl9_boolean :=
        (true, true, false, false, true, true, false, false, true);



    function MAKE_BINARY(A : STD_ULOGIC) return STD_ULOGIC is
	variable result : STD_ULOGIC;
    begin
	    if (IS_X(A)) then
		assert false 
		report "There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es)."
		severity warning;
	        result := 'X';
            else
	        result := tbl_BINARY(A);
	    end if;

            return result;
    end;

    function MAKE_BINARY(A : UNSIGNED) return UNSIGNED is
	variable one_bit : STD_ULOGIC;
	variable result : UNSIGNED (A'range);
    begin
	    for i in A'range loop
	        if (IS_X(A(i))) then
  		    assert false 
		    report "There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es)."
		    severity warning;
--		    result := (others => 'X');
                    for j in A'range loop
                       result(j) := 'X';
                    end loop;
	        else
		    result(i) := tbl_BINARY(A(i));
                end if;
	    end loop;

	    return result;
    end;

    function MAKE_BINARY(A : UNSIGNED) return SIGNED is
	variable one_bit : STD_ULOGIC;
	variable result : SIGNED (A'range);
    begin
	    for i in A'range loop
	        if (IS_X(A(i))) then
		    assert false 
		    report "There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es)."
		    severity warning;
--		    result := (others => 'X');
                    for j in A'range loop
                       result(j) := 'X';
                    end loop;
                else
		    result(i) := tbl_BINARY(A(i));
	        end if;
	    end loop;

	    return result;
    end;

    function MAKE_BINARY(A : SIGNED) return UNSIGNED is
	variable one_bit : STD_ULOGIC;
	variable result : UNSIGNED (A'range);
    begin
	    for i in A'range loop
	        if (IS_X(A(i))) then
		    assert false 
		    report "There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es)."
		    severity warning;
--		    result := (others => 'X');
                    for j in A'range loop
                       result(j) := 'X';
                    end loop;
                else
		    result(i) := tbl_BINARY(A(i));
	        end if;
	    end loop;

	    return result;
    end;

    function MAKE_BINARY(A : SIGNED) return SIGNED is
	variable one_bit : STD_ULOGIC;
	variable result : SIGNED (A'range);
    begin
	    for i in A'range loop
	        if (IS_X(A(i))) then
		    assert false 
		    report "There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es)."
		    severity warning;
--		    result := (others => 'X');
                    for j in A'range loop
                       result(j) := 'X';
                    end loop;
                else
		    result(i) := tbl_BINARY(A(i));
	        end if;
	    end loop;

	    return result;
    end;

    function MAKE_BINARY(A : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
	variable one_bit : STD_ULOGIC;
	variable result : STD_LOGIC_VECTOR (A'range);
    begin
	    for i in A'range loop
	        if (IS_X(A(i))) then
		    assert false 
		    report "There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es)."
		    severity warning;
--		    result := (others => 'X');
                    for j in A'range loop
                       result(j) := 'X';
                    end loop;
                else
		    result(i) := tbl_BINARY(A(i));
	        end if;
	    end loop;

	    return result;
    end;

    function MAKE_BINARY(A : UNSIGNED) return STD_LOGIC_VECTOR is
	variable one_bit : STD_ULOGIC;
	variable result : STD_LOGIC_VECTOR (A'range);
    begin
	    for i in A'range loop
	        if (IS_X(A(i))) then
		    assert false 
		    report "There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es)."
		    severity warning;
--		    result := (others => 'X');
                    for j in A'range loop
                       result(j) := 'X';
                    end loop;
                else
		    result(i) := tbl_BINARY(A(i));
	        end if;
	    end loop;

	    return result;
    end;

    function MAKE_BINARY(A : SIGNED) return STD_LOGIC_VECTOR is
	variable one_bit : STD_ULOGIC;
	variable result : STD_LOGIC_VECTOR (A'range);
    begin
	    for i in A'range loop
	        if (IS_X(A(i))) then
		    assert false 
		    report "There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, the result will be 'X'(es)."
		    severity warning;
--		    result := (others => 'X');
                    for j in A'range loop
                       result(j) := 'X';
                    end loop;
                else
		    result(i) := tbl_BINARY(A(i));
	        end if;
	    end loop;

	    return result;
    end;



    -- Type propagation function which returns a signed type with the
    -- size of the left arg.
    function LEFT_SIGNED_ARG(A,B: SIGNED) return SIGNED is
      variable Z: SIGNED (A'left downto 0);
    begin
      return(Z);
    end;
	
    -- Type propagation function which returns an unsigned type with the
    -- size of the left arg.
    function LEFT_UNSIGNED_ARG(A,B: UNSIGNED) return UNSIGNED is
      variable Z: UNSIGNED (A'left downto 0);
    begin
      return(Z);
    end;
	
    -- Type propagation function which returns a signed type with the
    -- size of the result of a signed multiplication
    function MULT_SIGNED_ARG(A,B: SIGNED) return SIGNED is
      variable Z: SIGNED ((A'length+B'length-1) downto 0);
    begin
      return(Z);
    end;
	
    -- Type propagation function which returns an unsigned type with the
    -- size of the result of a unsigned multiplication
    function MULT_UNSIGNED_ARG(A,B: UNSIGNED) return UNSIGNED is
      variable Z: UNSIGNED ((A'length+B'length-1) downto 0);
    begin
      return(Z);
    end;



    function mult(A,B: SIGNED) return SIGNED is

      variable BA: SIGNED((A'length+B'length-1) downto 0);
      variable PA: SIGNED((A'length+B'length-1) downto 0);
      variable AA: SIGNED(A'length downto 0);
      variable neg: STD_ULOGIC;
      constant one : UNSIGNED(1 downto 0) := "01";
      

      begin
	if (A(A'left) = 'X' or B(B'left) = 'X') then
--          PA := (others => 'X');
            for j in A'range loop
                PA(j) := 'X';
            end loop;
	else
--          PA := (others => '0');
            for j in PA'range loop
                PA(j) := '0';
            end loop;
            neg := B(B'left) xor A(A'left);
            BA := CONV_SIGNED(('0' & ABS(B)),(A'length+B'length));
            AA := '0' & ABS(A);
            for i in 0 to A'length-1 loop
              if AA(i) = '1' then
                PA := PA+BA;
              end if;
              BA := SHL(BA,one);
            end loop;
            if (neg= '1') then
               PA := 0 - PA;
            end if;
         end if;

         return(PA);
      end;

    function mult(A,B: UNSIGNED) return UNSIGNED is

      variable BA: UNSIGNED((A'length+B'length-1) downto 0);
      variable PA: UNSIGNED((A'length+B'length-1) downto 0);
      constant one : UNSIGNED(1 downto 0) := "01";
      

      begin
	if (A(A'left) = 'X' or B(B'left) = 'X') then
--          PA := (others => 'X');
            for j in A'range loop
                PA(j) := 'X';
            end loop;
        else
--          PA := (others => '0');
            for j in PA'range loop
                PA(j) := '0';
            end loop;
            BA := CONV_UNSIGNED(B,(A'length+B'length));
            for i in 0 to A'length-1 loop
              if A(i) = '1' then
                PA := PA+BA;
              end if;
              BA := SHL(BA,one);
            end loop;
	end if;

        return(PA);
      end;

    -- subtract two signed numbers of the same length
    -- both arrays must have range (msb downto 0)
    function minus(A, B: SIGNED) return SIGNED is
	variable carry: STD_ULOGIC;
	variable BV: STD_ULOGIC_VECTOR (A'left downto 0);
	variable sum: SIGNED (A'left downto 0);



    begin
	if (A(A'left) = 'X' or B(B'left) = 'X') then
--          sum := (others => 'X');
            for j in sum'range loop
                sum(j) := 'X';
            end loop;
        else
	    carry := '1';
	    BV := not STD_ULOGIC_VECTOR(B);

	    for i in 0 to A'left loop
	        sum(i) := A(i) xor BV(i) xor carry;
	        carry := (A(i) and BV(i)) or
		        (A(i) and carry) or
		        (carry and BV(i));
	    end loop;
	end if;
	return sum;
    end;

    -- add two signed numbers of the same length
    -- both arrays must have range (msb downto 0)
    function plus(A, B: SIGNED) return SIGNED is
	variable carry: STD_ULOGIC;
	variable BV, sum: SIGNED (A'left downto 0);


    begin
	if (A(A'left) = 'X' or B(B'left) = 'X') then
--          sum := (others => 'X');
            for j in sum'range loop
                sum(j) := 'X';
            end loop;
        else
	    carry := '0';
	    BV := B;

	    for i in 0 to A'left loop
	        sum(i) := A(i) xor BV(i) xor carry;
	        carry := (A(i) and BV(i)) or
		        (A(i) and carry) or
		        (carry and BV(i));
	    end loop;
        end if;
	return sum;
    end;


    -- subtract two unsigned numbers of the same length
    -- both arrays must have range (msb downto 0)
    function unsigned_minus(A, B: UNSIGNED) return UNSIGNED is
	variable carry: STD_ULOGIC;
	variable BV: STD_ULOGIC_VECTOR (A'left downto 0);
	variable sum: UNSIGNED (A'left downto 0);


    begin
	if (A(A'left) = 'X' or B(B'left) = 'X') then
--          sum := (others => 'X');
            for j in sum'range loop
                sum(j) := 'X';
            end loop;
        else
	    carry := '1';
	    BV := not STD_ULOGIC_VECTOR(B);

	    for i in 0 to A'left loop
	        sum(i) := A(i) xor BV(i) xor carry;
	        carry := (A(i) and BV(i)) or
		        (A(i) and carry) or
		        (carry and BV(i));
	    end loop;
	end if;
	return sum;
    end;

    -- add two unsigned numbers of the same length
    -- both arrays must have range (msb downto 0)
    function unsigned_plus(A, B: UNSIGNED) return UNSIGNED is
	variable carry: STD_ULOGIC;
	variable BV, sum: UNSIGNED (A'left downto 0);

    begin
	if (A(A'left) = 'X' or B(B'left) = 'X') then
--          sum := (others => 'X');
            for j in sum'range loop
                sum(j) := 'X';
            end loop;
        else
    	    carry := '0';
	    BV := B;

	    for i in 0 to A'left loop
	        sum(i) := A(i) xor BV(i) xor carry;
	        carry := (A(i) and BV(i)) or
		        (A(i) and carry) or
		        (carry and BV(i));
	    end loop;
	end if;
	return sum;
    end;



    function "*"(L: SIGNED; R: SIGNED) return SIGNED is
    begin
          return     mult(CONV_SIGNED(L, L'length),
		          CONV_SIGNED(R, R'length)); 
    end;
      
    function "*"(L: UNSIGNED; R: UNSIGNED) return UNSIGNED is
    begin
          return   mult(CONV_UNSIGNED(L, L'length),
                        CONV_UNSIGNED(R, R'length));
    end;
        
    function "*"(L: UNSIGNED; R: SIGNED) return SIGNED is
    begin
 	return       mult(CONV_SIGNED(L, L'length+1),
		          CONV_SIGNED(R, R'length));
    end;

    function "*"(L: SIGNED; R: UNSIGNED) return SIGNED is
    begin
	return      mult(CONV_SIGNED(L, L'length),
		         CONV_SIGNED(R, R'length+1));
    end;


    function "*"(L: SIGNED; R: SIGNED) return STD_LOGIC_VECTOR is
    begin
          return STD_LOGIC_VECTOR (mult(CONV_SIGNED(L, L'length),
		          CONV_SIGNED(R, R'length)));
    end;
      
    function "*"(L: UNSIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR is
    begin
          return STD_LOGIC_VECTOR (mult(CONV_UNSIGNED(L, L'length),
                        CONV_UNSIGNED(R, R'length)));
    end;
        
    function "*"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR is
    begin
 	return STD_LOGIC_VECTOR (mult(CONV_SIGNED(L, L'length+1),
		          CONV_SIGNED(R, R'length))); 
    end;

    function "*"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR is
    begin
	return STD_LOGIC_VECTOR (mult(CONV_SIGNED(L, L'length),
		         CONV_SIGNED(R, R'length+1)));
    end;


    function "+"(L: UNSIGNED; R: UNSIGNED) return UNSIGNED is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return unsigned_plus(CONV_UNSIGNED(L, length),
			     CONV_UNSIGNED(R, length)); 
    end;


    function "+"(L: SIGNED; R: SIGNED) return SIGNED is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)); 
    end;


    function "+"(L: UNSIGNED; R: SIGNED) return SIGNED is
	constant length: INTEGER := max(L'length + 1, R'length);
    begin
	return plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length));
    end;


    function "+"(L: SIGNED; R: UNSIGNED) return SIGNED is
	constant length: INTEGER := max(L'length, R'length + 1);
    begin
	return plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)); 
    end;


    function "+"(L: UNSIGNED; R: INTEGER) return UNSIGNED is
	constant length: INTEGER := L'length + 1;
    begin
	return CONV_UNSIGNED(
		plus(
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1);
    end;


    function "+"(L: INTEGER; R: UNSIGNED) return UNSIGNED is
	constant length: INTEGER := R'length + 1;
    begin
	return CONV_UNSIGNED(
		plus( 
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1);
    end;


    function "+"(L: SIGNED; R: INTEGER) return SIGNED is
	constant length: INTEGER := L'length;
    begin
	return plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length));
    end;


    function "+"(L: INTEGER; R: SIGNED) return SIGNED is
	constant length: INTEGER := R'length;
    begin
	return plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length));
    end;


    function "+"(L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED is
	constant length: INTEGER := L'length;
    begin
	return unsigned_plus(CONV_UNSIGNED(L, length),
		     CONV_UNSIGNED(R, length)) ;
    end;


    function "+"(L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED is
	constant length: INTEGER := R'length;
    begin
	return unsigned_plus(CONV_UNSIGNED(L, length),
		     CONV_UNSIGNED(R, length)); 
    end;


    function "+"(L: SIGNED; R: STD_ULOGIC) return SIGNED is
	constant length: INTEGER := L'length;
    begin
	return plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length));
    end;


    function "+"(L: STD_ULOGIC; R: SIGNED) return SIGNED is
	constant length: INTEGER := R'length;
    begin
	return plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)); 
    end;



    function "+"(L: UNSIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return STD_LOGIC_VECTOR (unsigned_plus(CONV_UNSIGNED(L, length),
			     CONV_UNSIGNED(R, length))); 
    end;


    function "+"(L: SIGNED; R: SIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return STD_LOGIC_VECTOR (plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)));
    end;


    function "+"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := max(L'length + 1, R'length);
    begin
	return STD_LOGIC_VECTOR (plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length))); 
    end;


    function "+"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := max(L'length, R'length + 1);
    begin
	return STD_LOGIC_VECTOR (plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length))); 
    end;


    function "+"(L: UNSIGNED; R: INTEGER) return STD_LOGIC_VECTOR is
	constant length: INTEGER := L'length + 1;
    begin
	return STD_LOGIC_VECTOR (CONV_UNSIGNED(
		plus(
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1));
    end;


    function "+"(L: INTEGER; R: UNSIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := R'length + 1;
    begin
	return STD_LOGIC_VECTOR (CONV_UNSIGNED(
		plus(
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1));
    end;


    function "+"(L: SIGNED; R: INTEGER) return STD_LOGIC_VECTOR is
	constant length: INTEGER := L'length;
    begin
	return STD_LOGIC_VECTOR (plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)));
    end;


    function "+"(L: INTEGER; R: SIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := R'length;
    begin
	return STD_LOGIC_VECTOR (plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length))); 
    end;


    function "+"(L: UNSIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR is
	constant length: INTEGER := L'length;
    begin
	return STD_LOGIC_VECTOR (unsigned_plus(CONV_UNSIGNED(L, length),
		     CONV_UNSIGNED(R, length))) ; 
    end;


    function "+"(L: STD_ULOGIC; R: UNSIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := R'length;
    begin
	return STD_LOGIC_VECTOR (unsigned_plus(CONV_UNSIGNED(L, length),
		     CONV_UNSIGNED(R, length)));
    end;


    function "+"(L: SIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR is
	constant length: INTEGER := L'length;
    begin
	return STD_LOGIC_VECTOR (plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length))); 
    end;


    function "+"(L: STD_ULOGIC; R: SIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := R'length;
    begin
	return STD_LOGIC_VECTOR (plus(CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length))); 
    end;



    function "-"(L: UNSIGNED; R: UNSIGNED) return UNSIGNED is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return unsigned_minus(CONV_UNSIGNED(L, length),
		      	      CONV_UNSIGNED(R, length)); 
    end;


    function "-"(L: SIGNED; R: SIGNED) return SIGNED is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length));
    end;


    function "-"(L: UNSIGNED; R: SIGNED) return SIGNED is
	constant length: INTEGER := max(L'length + 1, R'length);
    begin
	return minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length)); 
    end;


    function "-"(L: SIGNED; R: UNSIGNED) return SIGNED is
	constant length: INTEGER := max(L'length, R'length + 1);
    begin
	return minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length));
    end;


    function "-"(L: UNSIGNED; R: INTEGER) return UNSIGNED is
	constant length: INTEGER := L'length + 1;
    begin
	return CONV_UNSIGNED(
		minus(
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1);
    end;


    function "-"(L: INTEGER; R: UNSIGNED) return UNSIGNED is
	constant length: INTEGER := R'length + 1;
    begin
	return CONV_UNSIGNED(
		minus(
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1);
    end;


    function "-"(L: SIGNED; R: INTEGER) return SIGNED is
	constant length: INTEGER := L'length;
    begin
	return minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length));
    end;


    function "-"(L: INTEGER; R: SIGNED) return SIGNED is
	constant length: INTEGER := R'length;
    begin
	return minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length)); 
    end;


    function "-"(L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED is
	constant length: INTEGER := L'length + 1;
    begin
	return CONV_UNSIGNED(
		minus( 
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1);
    end;


    function "-"(L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED is
	constant length: INTEGER := R'length + 1;
    begin
	return CONV_UNSIGNED(
		minus( 
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1);
    end;


    function "-"(L: SIGNED; R: STD_ULOGIC) return SIGNED is
	constant length: INTEGER := L'length;
    begin
	return minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length)); 
    end;


    function "-"(L: STD_ULOGIC; R: SIGNED) return SIGNED is
	constant length: INTEGER := R'length;
    begin
	return minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length)); 
    end;




    function "-"(L: UNSIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return STD_LOGIC_VECTOR (unsigned_minus(CONV_UNSIGNED(L, length),
		      	      CONV_UNSIGNED(R, length)));
    end;


    function "-"(L: SIGNED; R: SIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return STD_LOGIC_VECTOR (minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length))); 
    end;


    function "-"(L: UNSIGNED; R: SIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := max(L'length + 1, R'length);
    begin
	return STD_LOGIC_VECTOR (minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length)));
    end;


    function "-"(L: SIGNED; R: UNSIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := max(L'length, R'length + 1);
    begin
	return STD_LOGIC_VECTOR (minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length))); 
    end;


    function "-"(L: UNSIGNED; R: INTEGER) return STD_LOGIC_VECTOR is
	constant length: INTEGER := L'length + 1;
    begin
	return STD_LOGIC_VECTOR (CONV_UNSIGNED(
		minus( 
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1));
    end;


    function "-"(L: INTEGER; R: UNSIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := R'length + 1;
    begin
	return STD_LOGIC_VECTOR (CONV_UNSIGNED(
		minus(
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1));
    end;


    function "-"(L: SIGNED; R: INTEGER) return STD_LOGIC_VECTOR is
	constant length: INTEGER := L'length;
    begin
	return STD_LOGIC_VECTOR (minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length)));
    end;


    function "-"(L: INTEGER; R: SIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := R'length;
    begin
	return STD_LOGIC_VECTOR (minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length)));
    end;


    function "-"(L: UNSIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR is
	constant length: INTEGER := L'length + 1;
    begin
	return STD_LOGIC_VECTOR (CONV_UNSIGNED(
		minus(
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1));
    end;


    function "-"(L: STD_ULOGIC; R: UNSIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := R'length + 1;
    begin
	return STD_LOGIC_VECTOR (CONV_UNSIGNED(
		minus(
		    CONV_SIGNED(L, length),
		    CONV_SIGNED(R, length)),
		length-1));
    end;


    function "-"(L: SIGNED; R: STD_ULOGIC) return STD_LOGIC_VECTOR is
	constant length: INTEGER := L'length;
    begin
	return STD_LOGIC_VECTOR (minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length)));
    end;


    function "-"(L: STD_ULOGIC; R: SIGNED) return STD_LOGIC_VECTOR is
	constant length: INTEGER := R'length;
    begin
	return STD_LOGIC_VECTOR (minus(CONV_SIGNED(L, length),
		     CONV_SIGNED(R, length)));
    end;




    function "+"(L: UNSIGNED) return UNSIGNED is
    begin
	return L;
    end;


    function "+"(L: SIGNED) return SIGNED is
    begin
	return L;
    end;


    function "-"(L: SIGNED) return SIGNED is
    begin
	return 0 - L; 
    end;


    function "ABS"(L: SIGNED) return SIGNED is
	variable result: SIGNED(L'length-1 downto 0);
    begin
	if (L(L'left) = '0' or L(L'left) = 'L') then
	    result := L;
	else
	    result :=  0 - L;
	end if;

        return result;
    end;


    function "+"(L: UNSIGNED) return STD_LOGIC_VECTOR is
    begin
	return STD_LOGIC_VECTOR (L);
    end;


    function "+"(L: SIGNED) return STD_LOGIC_VECTOR is
    begin
	return STD_LOGIC_VECTOR (L);
    end;


    function "-"(L: SIGNED) return STD_LOGIC_VECTOR is
	variable tmp: SIGNED(L'length-1 downto 0);
    begin
	tmp := 0 - L;  
	return STD_LOGIC_VECTOR (tmp); 
    end;


    function "ABS"(L: SIGNED) return STD_LOGIC_VECTOR is
	variable tmp: SIGNED(L'length-1 downto 0);
    begin
	if (L(L'left) = '0' or L(L'left) = 'L') then
	    tmp := L;
	else
	    tmp := 0 - L;
	end if;

        return STD_LOGIC_VECTOR (tmp);
    end;


    -- Type propagation function which returns the type BOOLEAN
    function UNSIGNED_RETURN_BOOLEAN(A,B: UNSIGNED) return BOOLEAN is
      variable Z: BOOLEAN;
    begin
      return(Z);
    end;
	
    -- Type propagation function which returns the type BOOLEAN
    function SIGNED_RETURN_BOOLEAN(A,B: SIGNED) return BOOLEAN is
      variable Z: BOOLEAN;
    begin
      return(Z);
    end;
	

    -- compare two signed numbers of the same length
    -- both arrays must have range (msb downto 0)
    function is_less(A, B: SIGNED) return BOOLEAN is
	constant sign: INTEGER := A'left;
	variable a_is_0, b_is_1, result : boolean;

    begin
	if A(sign) /= B(sign) then
	    result := A(sign) = '1';
	else
	    result := FALSE;
	    for i in 0 to sign-1 loop
		a_is_0 := A(i) = '0';
		b_is_1 := B(i) = '1';
		result := (a_is_0 and b_is_1) or
			  (a_is_0 and result) or
			  (b_is_1 and result);
	    end loop;
	end if;
	return result;
    end;


    -- compare two signed numbers of the same length
    -- both arrays must have range (msb downto 0)
    function is_less_or_equal(A, B: SIGNED) return BOOLEAN is
	constant sign: INTEGER := A'left;
	variable a_is_0, b_is_1, result : boolean;

    begin
	if A(sign) /= B(sign) then
	    result := A(sign) = '1';
	else
	    result := TRUE;
	    for i in 0 to sign-1 loop
		a_is_0 := A(i) = '0';
		b_is_1 := B(i) = '1';
		result := (a_is_0 and b_is_1) or
			  (a_is_0 and result) or
			  (b_is_1 and result);
	    end loop;
	end if;
	return result;
    end;



    -- compare two unsigned numbers of the same length
    -- both arrays must have range (msb downto 0)
    function unsigned_is_less(A, B: UNSIGNED) return BOOLEAN is
	constant sign: INTEGER := A'left;
	variable a_is_0, b_is_1, result : boolean;

    begin
	result := FALSE;
	for i in 0 to sign loop
	    a_is_0 := A(i) = '0';
	    b_is_1 := B(i) = '1';
	    result := (a_is_0 and b_is_1) or
		      (a_is_0 and result) or
		      (b_is_1 and result);
	end loop;
	return result;
    end;


    -- compare two unsigned numbers of the same length
    -- both arrays must have range (msb downto 0)
    function unsigned_is_less_or_equal(A, B: UNSIGNED) return BOOLEAN is
	constant sign: INTEGER := A'left;
	variable a_is_0, b_is_1, result : boolean;

    begin
	result := TRUE;
	for i in 0 to sign loop
	    a_is_0 := A(i) = '0';
	    b_is_1 := B(i) = '1';
	    result := (a_is_0 and b_is_1) or
		      (a_is_0 and result) or
		      (b_is_1 and result);
	end loop;
	return result;
    end;




    function "<"(L: UNSIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return unsigned_is_less(CONV_UNSIGNED(L, length),
				CONV_UNSIGNED(R, length));
    end;


    function "<"(L: SIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return is_less(CONV_SIGNED(L, length),
			CONV_SIGNED(R, length));
    end;


    function "<"(L: UNSIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length + 1, R'length);
    begin
	return is_less(CONV_SIGNED(L, length),
			CONV_SIGNED(R, length));
    end;


    function "<"(L: SIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length + 1);
    begin
	return is_less(CONV_SIGNED(L, length),
			CONV_SIGNED(R, length));
    end;


    function "<"(L: UNSIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length + 1;
    begin
	return is_less(CONV_SIGNED(L, length),
			CONV_SIGNED(R, length));
    end;


    function "<"(L: INTEGER; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := R'length + 1;
    begin
	return is_less(CONV_SIGNED(L, length),
			CONV_SIGNED(R, length)); 
    end;


    function "<"(L: SIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length;
    begin
	return is_less(CONV_SIGNED(L, length),
			CONV_SIGNED(R, length));
    end;


    function "<"(L: INTEGER; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := R'length;
    begin
	return is_less(CONV_SIGNED(L, length),
			CONV_SIGNED(R, length));
    end;


    function "<="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return unsigned_is_less_or_equal(CONV_UNSIGNED(L, length),
			     CONV_UNSIGNED(R, length)); 
    end;


    function "<="(L: SIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return is_less_or_equal(CONV_SIGNED(L, length),
				CONV_SIGNED(R, length));
    end;


    function "<="(L: UNSIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length + 1, R'length);
    begin
	return is_less_or_equal(CONV_SIGNED(L, length),
				CONV_SIGNED(R, length)); 
    end;


    function "<="(L: SIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length + 1);
    begin
	return is_less_or_equal(CONV_SIGNED(L, length),
				CONV_SIGNED(R, length));
    end;


    function "<="(L: UNSIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length + 1;
    begin
	return is_less_or_equal(CONV_SIGNED(L, length),
				CONV_SIGNED(R, length));
    end;


    function "<="(L: INTEGER; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := R'length + 1;
    begin
	return is_less_or_equal(CONV_SIGNED(L, length),
				CONV_SIGNED(R, length)); 
    end;


    function "<="(L: SIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length;
    begin
	return is_less_or_equal(CONV_SIGNED(L, length),
				CONV_SIGNED(R, length)); 
    end;


    function "<="(L: INTEGER; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := R'length;
    begin
	return is_less_or_equal(CONV_SIGNED(L, length),
				CONV_SIGNED(R, length));
    end;


    function ">"(L: UNSIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return unsigned_is_less(CONV_UNSIGNED(R, length),
				CONV_UNSIGNED(L, length)); 
    end;


    function ">"(L: SIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return is_less(CONV_SIGNED(R, length),
		       CONV_SIGNED(L, length));
    end;


    function ">"(L: UNSIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length + 1, R'length);
    begin
	return is_less(CONV_SIGNED(R, length),
		       CONV_SIGNED(L, length));
    end;


    function ">"(L: SIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length + 1);
    begin
	return is_less(CONV_SIGNED(R, length),
		       CONV_SIGNED(L, length)); 
    end;


    function ">"(L: UNSIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length + 1;
    begin
	return is_less(CONV_SIGNED(R, length),
		       CONV_SIGNED(L, length));
    end;


    function ">"(L: INTEGER; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := R'length + 1;
    begin
	return is_less(CONV_SIGNED(R, length),
		       CONV_SIGNED(L, length));
    end;


    function ">"(L: SIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length;
    begin
	return is_less(CONV_SIGNED(R, length),
		       CONV_SIGNED(L, length)); 
    end;


    function ">"(L: INTEGER; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := R'length;
    begin
	return is_less(CONV_SIGNED(R, length),
		       CONV_SIGNED(L, length));
    end;


    function ">="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return unsigned_is_less_or_equal(CONV_UNSIGNED(R, length),
				 CONV_UNSIGNED(L, length));
    end;


    function ">="(L: SIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return is_less_or_equal(CONV_SIGNED(R, length),
				CONV_SIGNED(L, length));
    end;


    function ">="(L: UNSIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length + 1, R'length);
    begin
	return is_less_or_equal(CONV_SIGNED(R, length),
				CONV_SIGNED(L, length));
    end;


    function ">="(L: SIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length + 1);
    begin
	return is_less_or_equal(CONV_SIGNED(R, length),
				CONV_SIGNED(L, length)); 
    end;


    function ">="(L: UNSIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length + 1;
    begin
	return is_less_or_equal(CONV_SIGNED(R, length),
				CONV_SIGNED(L, length));
    end;


    function ">="(L: INTEGER; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := R'length + 1;
    begin
	return is_less_or_equal(CONV_SIGNED(R, length),
				CONV_SIGNED(L, length));
    end;


    function ">="(L: SIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length;
    begin
	return is_less_or_equal(CONV_SIGNED(R, length),
				CONV_SIGNED(L, length)); 
    end;


    function ">="(L: INTEGER; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := R'length;
    begin
	return is_less_or_equal(CONV_SIGNED(R, length),
				CONV_SIGNED(L, length));
    end;




    -- for internal use only.  Assumes SIGNED arguments of equal length.
    function bitwise_eql(L: STD_ULOGIC_VECTOR; R: STD_ULOGIC_VECTOR)
						return BOOLEAN is
        variable result : BOOLEAN;
    begin
        result := TRUE;
	for i in L'range loop
	    if L(i) /= R(i) then
		result :=  FALSE;
	    end if;
	end loop;

        return result;
    end;

    -- for internal use only.  Assumes SIGNED arguments of equal length.
    function bitwise_neq(L: STD_ULOGIC_VECTOR; R: STD_ULOGIC_VECTOR)
						return BOOLEAN is
        variable result : BOOLEAN;
    begin
        result := FALSE;
	for i in L'range loop
	    if L(i) /= R(i) then
		result := TRUE;
	    end if;
	end loop;

        return result;
    end;


    function "="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return bitwise_eql( STD_ULOGIC_VECTOR( CONV_UNSIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_UNSIGNED(R, length) ) );
    end;


    function "="(L: SIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return bitwise_eql( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "="(L: UNSIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length + 1, R'length);
    begin
	return bitwise_eql( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "="(L: SIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length + 1);
    begin
	return bitwise_eql( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "="(L: UNSIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length + 1;
    begin
	return bitwise_eql( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "="(L: INTEGER; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := R'length + 1;
    begin
	return bitwise_eql( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "="(L: SIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length;
    begin
	return bitwise_eql( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "="(L: INTEGER; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := R'length;
    begin
	return bitwise_eql( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;




    function "/="(L: UNSIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return bitwise_neq( STD_ULOGIC_VECTOR( CONV_UNSIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_UNSIGNED(R, length) ) );
    end;


    function "/="(L: SIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length);
    begin
	return bitwise_neq( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "/="(L: UNSIGNED; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length + 1, R'length);
    begin
	return bitwise_neq( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "/="(L: SIGNED; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := max(L'length, R'length + 1);
    begin
	return bitwise_neq( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "/="(L: UNSIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length + 1;
    begin
	return bitwise_neq( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "/="(L: INTEGER; R: UNSIGNED) return BOOLEAN is
	constant length: INTEGER := R'length + 1;
    begin
	return bitwise_neq( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "/="(L: SIGNED; R: INTEGER) return BOOLEAN is
	constant length: INTEGER := L'length;
    begin
	return bitwise_neq( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;


    function "/="(L: INTEGER; R: SIGNED) return BOOLEAN is
	constant length: INTEGER := R'length;
    begin
	return bitwise_neq( STD_ULOGIC_VECTOR( CONV_SIGNED(L, length) ),
		STD_ULOGIC_VECTOR( CONV_SIGNED(R, length) ) );
    end;



    function SHL(ARG: UNSIGNED; COUNT: UNSIGNED) return UNSIGNED is
	constant control_msb: INTEGER := COUNT'length - 1;
	variable control: UNSIGNED (control_msb downto 0);
	constant result_msb: INTEGER := ARG'length-1;
	subtype rtype is UNSIGNED (result_msb downto 0);
	variable result, temp: rtype;
    begin
	control := MAKE_BINARY(COUNT);
	if (control(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
	    result := ARG;
	    for i in 0 to control_msb loop
	        if control(i) = '1' then
--		    temp := rtype'(others => '0');
                    for j in result'range loop
                        temp(j) := '0';
                    end loop;
		    if 2**i <= result_msb then
		        temp(result_msb downto 2**i) := 
				    result(result_msb - 2**i downto 0);
		    end if;
		    result := temp;
	        end if;
	    end loop;
	end if;
	return result;
    end;

    function SHL(ARG: SIGNED; COUNT: UNSIGNED) return SIGNED is
	constant control_msb: INTEGER := COUNT'length - 1;
	variable control: UNSIGNED (control_msb downto 0);
	constant result_msb: INTEGER := ARG'length-1;
	subtype rtype is SIGNED (result_msb downto 0);
	variable result, temp: rtype;
    begin
	control := MAKE_BINARY(COUNT);
	if (control(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
	    result := ARG;
	    for i in 0 to control_msb loop
	        if control(i) = '1' then
--	       	    temp := rtype'(others => '0');
                    for j in result'range loop
                        temp(j) := '0';
                    end loop;
		    if 2**i <= result_msb then
		        temp(result_msb downto 2**i) := 
				    result(result_msb - 2**i downto 0);
		    end if;
		    result := temp;
	        end if;
	    end loop;
	end if;
	return result;
    end;


    function SHR(ARG: UNSIGNED; COUNT: UNSIGNED) return UNSIGNED is
	constant control_msb: INTEGER := COUNT'length - 1;
	variable control: UNSIGNED (control_msb downto 0);
	constant result_msb: INTEGER := ARG'length-1;
	subtype rtype is UNSIGNED (result_msb downto 0);
	variable result, temp: rtype;
    begin
	control := MAKE_BINARY(COUNT);
	if (control(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
	else
	    result := ARG;
	    for i in 0 to control_msb loop
	        if control(i) = '1' then
--		    temp := rtype'(others => '0');
                    for j in result'range loop
                        temp(j) := '0';
                    end loop;
		    if 2**i <= result_msb then
		        temp(result_msb - 2**i downto 0) := 
					result(result_msb downto 2**i);
		    end if;
		    result := temp;
	        end if;
	    end loop;
        end if;
	return result;
    end;

    function SHR(ARG: SIGNED; COUNT: UNSIGNED) return SIGNED is
	constant control_msb: INTEGER := COUNT'length - 1;
	variable control: UNSIGNED (control_msb downto 0);
	constant result_msb: INTEGER := ARG'length-1;
	subtype rtype is SIGNED (result_msb downto 0);
	variable result, temp: rtype;
	variable sign_bit: STD_ULOGIC;
    begin
	control := MAKE_BINARY(COUNT);
	if (control(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
            result := ARG;
	    sign_bit := ARG(ARG'left);
	    for i in 0 to control_msb loop
	        if control(i) = '1' then
--	    	    temp := rtype'(others => sign_bit);
                    for j in result'range loop
                        temp(j) := sign_bit;
                    end loop;
		    if 2**i <= result_msb then
		        temp(result_msb - 2**i downto 0) := 
					result(result_msb downto 2**i);
		    end if;
		    result := temp;
	        end if;
	    end loop;
	end if;

	return result;
    end;




    function CONV_INTEGER(ARG: INTEGER) return INTEGER is
    begin
	return ARG;
    end;

    function CONV_INTEGER(ARG: UNSIGNED) return INTEGER is
	variable result: INTEGER;
	variable tmp: STD_ULOGIC;
    begin
	assert ARG'length <= 31
	    report "ARG is too large in CONV_INTEGER"
	    severity FAILURE;
	result := 0;
	for i in ARG'range loop
	    result := result * 2;
	    tmp := tbl_BINARY(ARG(i));
	    if tmp = '1' then
		result := result + 1;
	    elsif tmp = 'X' then
		assert false
		report "CONV_INTEGER: There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, and it has been converted to 0."
		severity WARNING;
	    end if;
	end loop;
	return result;
    end;


    function CONV_INTEGER(ARG: SIGNED) return INTEGER is
	variable result: INTEGER;
	variable tmp: STD_ULOGIC;
    begin
	assert ARG'length <= 32
	    report "ARG is too large in CONV_INTEGER"
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
	tmp := MAKE_BINARY(ARG(ARG'left));
	if tmp = '1' then
	    if ARG'length = 32 then
		result := (result - 2**30) - 2**30;
	    else
		result := result - (2 ** (ARG'length-1));
	    end if;
	end if;
	return result;
    end;


    function CONV_INTEGER(ARG: STD_ULOGIC) return SMALL_INT is
	variable tmp: STD_ULOGIC;
        variable result : SMALL_INT;
    begin
	tmp := tbl_BINARY(ARG);
	if tmp = '1' then
	    result := 1;
	elsif tmp = 'X' then
	    assert false
	    report "CONV_INTEGER: There is an 'U'|'X'|'W'|'Z'|'-' in an arithmetic operand, and it has been converted to 0."
	    severity WARNING;
	    result := 0;
	else
	    result := 0;
	end if;
        
        return result;
    end;


    -- convert an integer to a unsigned STD_ULOGIC_VECTOR
    function CONV_UNSIGNED(ARG: INTEGER; SIZE: INTEGER) return UNSIGNED is
	variable result: UNSIGNED(SIZE-1 downto 0);
	variable temp: integer;
    begin
	temp := ARG;
	for i in 0 to SIZE-1 loop
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


    function CONV_UNSIGNED(ARG: UNSIGNED; SIZE: INTEGER) return UNSIGNED is
	constant msb: INTEGER := min(ARG'length, SIZE) - 1;
	subtype rtype is UNSIGNED (SIZE-1 downto 0);
	variable new_bounds: UNSIGNED (ARG'length-1 downto 0);
	variable result: rtype;
    begin
	new_bounds := MAKE_BINARY(ARG);
	if (new_bounds(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
--	    result := rtype'(others => '0');
            for j in result'range loop
                result(j) := '0';
            end loop;
	    result(msb downto 0) := new_bounds(msb downto 0);
	end if;
	return result;
    end;


    function CONV_UNSIGNED(ARG: SIGNED; SIZE: INTEGER) return UNSIGNED is
	constant msb: INTEGER := min(ARG'length, SIZE) - 1;
	subtype rtype is UNSIGNED (SIZE-1 downto 0);
	variable new_bounds: UNSIGNED (ARG'length-1 downto 0);
	variable result: rtype;
    begin
	new_bounds := MAKE_BINARY(ARG);
	if (new_bounds(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
--	    result := rtype'(others => new_bounds(new_bounds'left));
            for j in result'range loop
                result(j) := new_bounds(new_bounds'left);
            end loop;
	    result(msb downto 0) := new_bounds(msb downto 0);
	end if;
	return result;
    end;


    function CONV_UNSIGNED(ARG: STD_ULOGIC; SIZE: INTEGER) return UNSIGNED is
	subtype rtype is UNSIGNED (SIZE-1 downto 0);
	variable result: rtype;
    begin
--	result := rtype'(others => '0');
        for j in result'range loop
            result(j) := '0';
        end loop;
	result(0) := MAKE_BINARY(ARG);
	if (result(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
	end if;
	return result;
    end;


    -- convert an integer to a 2's complement STD_ULOGIC_VECTOR
    function CONV_SIGNED(ARG: INTEGER; SIZE: INTEGER) return SIGNED is
	variable result: SIGNED (SIZE-1 downto 0);
	variable temp: integer;
    begin
	temp := ARG;
	for i in 0 to SIZE-1 loop
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


    function CONV_SIGNED(ARG: UNSIGNED; SIZE: INTEGER) return SIGNED is
	constant msb: INTEGER := min(ARG'length, SIZE) - 1;
	subtype rtype is SIGNED (SIZE-1 downto 0);
	variable new_bounds : SIGNED (ARG'length-1 downto 0);
	variable result: rtype;
    begin
	new_bounds := MAKE_BINARY(ARG);
	if (new_bounds(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
--	    result := rtype'(others => '0');
            for j in result'range loop
                result(j) := '0';
            end loop;
            result(msb downto 0) := new_bounds(msb downto 0);
	end if;
	return result;
    end;

    function CONV_SIGNED(ARG: SIGNED; SIZE: INTEGER) return SIGNED is
	constant msb: INTEGER := min(ARG'length, SIZE) - 1;
	subtype rtype is SIGNED (SIZE-1 downto 0);
	variable new_bounds : SIGNED (ARG'length-1 downto 0);
	variable result: rtype;
    begin
	new_bounds := MAKE_BINARY(ARG);
	if (new_bounds(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
--	    result := rtype'(others => new_bounds(new_bounds'left));
            for j in result'range loop
                result(j) := new_bounds(new_bounds'left);
            end loop;
	    result(msb downto 0) := new_bounds(msb downto 0);
	end if;
	return result;
    end;


    function CONV_SIGNED(ARG: STD_ULOGIC; SIZE: INTEGER) return SIGNED is
	subtype rtype is SIGNED (SIZE-1 downto 0);
	variable result: rtype;
    begin
--	result := rtype'(others => '0');
        for j in result'range loop
            result(j) := '0';
        end loop;
	result(0) := MAKE_BINARY(ARG);
	if (result(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
	end if;
	return result;
    end;


    -- convert an integer to an STD_LOGIC_VECTOR
    function CONV_STD_LOGIC_VECTOR(ARG: INTEGER; SIZE: INTEGER) return STD_LOGIC_VECTOR is
	variable result: STD_LOGIC_VECTOR (SIZE-1 downto 0);
	variable temp: integer;
    begin
	temp := ARG;
	for i in 0 to SIZE-1 loop
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


    function CONV_STD_LOGIC_VECTOR(ARG: UNSIGNED; SIZE: INTEGER) return STD_LOGIC_VECTOR is
	constant msb: INTEGER := min(ARG'length, SIZE) - 1;
	subtype rtype is STD_LOGIC_VECTOR (SIZE-1 downto 0);
	variable new_bounds : STD_LOGIC_VECTOR (ARG'length-1 downto 0);
	variable result: rtype;
    begin
	new_bounds := MAKE_BINARY(ARG);
	if (new_bounds(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
--          result := rtype'(others => '0');
            for j in result'range loop
                result(j) := '0';
            end loop;
	    result(msb downto 0) := new_bounds(msb downto 0);
	end if;

	return result;
    end;

    function CONV_STD_LOGIC_VECTOR(ARG: SIGNED; SIZE: INTEGER) return STD_LOGIC_VECTOR is
	constant msb: INTEGER := min(ARG'length, SIZE) - 1;
	subtype rtype is STD_LOGIC_VECTOR (SIZE-1 downto 0);
	variable new_bounds : STD_LOGIC_VECTOR (ARG'length-1 downto 0);
	variable result: rtype;
    begin
	new_bounds := MAKE_BINARY(ARG);
	if (new_bounds(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
--	    result := rtype'(others => new_bounds(new_bounds'left));
            for j in result'range loop
                result(j) := new_bounds(new_bounds'left);
            end loop;
	    result(msb downto 0) := new_bounds(msb downto 0);
	end if;

	return result;
    end;


    function CONV_STD_LOGIC_VECTOR(ARG: STD_ULOGIC; SIZE: INTEGER) return STD_LOGIC_VECTOR is
	subtype rtype is STD_LOGIC_VECTOR (SIZE-1 downto 0);
	variable result: rtype;
    begin
--	result := rtype'(others => '0');
        for j in result'range loop
            result(j) := '0';
        end loop;
	result(0) := MAKE_BINARY(ARG);
	if (result(0) = 'X') then
--          result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
	end if;

	return result;
    end;

    function EXT(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) 
						return STD_LOGIC_VECTOR is
	constant msb: INTEGER := min(ARG'length, SIZE) - 1;
	subtype rtype is STD_LOGIC_VECTOR (SIZE-1 downto 0);
	variable new_bounds: STD_LOGIC_VECTOR (ARG'length-1 downto 0);
	variable result: rtype;
    begin
	new_bounds := MAKE_BINARY(ARG);
	if (new_bounds(0) = 'X') then
-- 	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
--	    result := rtype'(others => '0');
            for j in result'range loop
                result(j) := '0';
            end loop;
	    result(msb downto 0) := new_bounds(msb downto 0);
	end if;
	return result;
    end;


    function SXT(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) return STD_LOGIC_VECTOR is
	constant msb: INTEGER := min(ARG'length, SIZE) - 1;
	subtype rtype is STD_LOGIC_VECTOR (SIZE-1 downto 0);
	variable new_bounds : STD_LOGIC_VECTOR (ARG'length-1 downto 0);
	variable result: rtype;
    begin
	new_bounds := MAKE_BINARY(ARG);
	if (new_bounds(0) = 'X') then
--	    result := rtype'(others => 'X');
            for j in result'range loop
                result(j) := 'X';
            end loop;
        else
--	    result := rtype'(others => new_bounds(new_bounds'left));
            for j in result'range loop
                result(j) := new_bounds(new_bounds'left);
            end loop;
	    result(msb downto 0) := new_bounds(msb downto 0);
	end if;

	return result;
    end;


end std_logic_arith;
