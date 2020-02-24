--$Header: //synplicity/mapgw/designware/dw02_comp.vhd#1 $
---------------------------------------------------------------------------------------------------
--
-- File        : dw02_comp.vhd
-- Design      : Contains 24 basic DesignWare components declarations
-- Company     : Synplicity Inc.
-- Date        : Aug 25, 2008 
-- Author      : Selvam R
-- Version     : 3.1
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package DW02_components is

component DW02_sin is
generic ( A_width : INTEGER := 16;
sin_width : INTEGER := 32 );
port ( A : in std_logic_vector(A_width-1 downto 0);
SIN : out std_logic_vector(sin_width-1 downto 0) );

end component;

 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_sin : component is "weak";

component DW02_sincos is

generic ( A_width : INTEGER := 16;
wave_width : INTEGER := 32 ); 

port ( A : in std_logic_vector(A_width-1 downto 0);
SIN_COS : in std_logic;
WAVE : out std_logic_vector(wave_width-1 downto 0) );

end component;

 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_sincos : component is "weak";

component DW02_cos is

generic ( A_width : INTEGER := 16;
cos_width : INTEGER := 32 ); 

port ( A : in std_logic_vector(A_width-1 downto 0);
COS : out std_logic_vector(cos_width-1 downto 0) );


end component;

 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_cos : component is "weak";


	component DW_div_rem is
	generic(
			a_width :POSITIVE;
			b_width :POSITIVE;
			tc_mode :INTEGER  		
			);
		port(
			a 			: in std_logic_vector(a_width-1 downto 0);
			b 			: in std_logic_vector(b_width-1 downto 0);
			tc			: in std_logic;
			remainder	: out std_logic_vector(b_width-1 downto 0);
			quotient	: out std_logic_vector(a_width-1 downto 0);
			divide_by_0	: out std_logic
			);

	end component ;
 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_div_rem : component is "weak";

	component DW_square is
	generic(
			width : NATURAL
			);
		port(
			a		:  in 	std_logic_vector(width-1 downto 0);
			tc		:  in 	std_logic;	
			square	:  out 	std_logic_vector((2 * width)-1 downto 0)
			);
	end component;
 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_square : component is "weak";

	component DW_squarep is
	generic (
			width : NATURAL 
 			);
		port(
		    a    : in  std_logic_vector(width-1 downto 0);
		    tc   : in  std_logic;
			out0 : out std_logic_vector(2*width-1 downto 0);
			out1 : out std_logic_vector(2*width-1 downto 0)
			);
	end component;
 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_squarep : component is "weak";

	component DW_ver_mod is 
	generic(
			A_width : POSITIVE ;
			B_width : POSITIVE ;
			TC_mode : INTEGER  
			);
		port(
			A		:  in 	std_logic_vector(A_width-1 downto 0);
			B		:  in 	std_logic_vector(B_width-1 downto 0);
			TC		:  in 	std_logic;
			MODULUS	:  out 	std_logic_vector(B_width-1 downto 0)
			);
	end component;
 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ver_mod : component is "weak";

	component DW_vhd_mod is
	generic(
			A_width : POSITIVE ;
			B_width : POSITIVE ;
			TC_mode : INTEGER  
			);
		port(
			A  		:  in 	std_logic_vector(A_width-1 downto 0);
			B  		:  in 	std_logic_vector(B_width-1 downto 0);
			TC 		:  in 	std_logic;
			MODULUS :  out 	std_logic_vector(B_width-1 downto 0)
			);
	end component;
 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_vhd_mod : component is "weak";

	component DW02_mult_2_stage is
	generic(
			A_width : POSITIVE ;
			B_width : POSITIVE
			);
		port(
			A 		: in std_logic_vector(A_width-1 downto 0);
			B 		: in std_logic_vector(B_width-1 downto 0);
			TC 		: in std_logic;
			CLK 	: in std_logic;
			PRODUCT : out std_logic_vector(A_width+B_width-1 downto 0)
			);
	end component;
 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_mult_2_stage : component is "weak";

	component DW02_mult_3_stage is
	generic(
			A_width : POSITIVE ;
			B_width : POSITIVE 
			);
		port(
			A 		: in std_logic_vector(A_width-1 downto 0);
			B 		: in std_logic_vector(B_width-1 downto 0);
			TC 		: in std_logic;
			CLK 	: in std_logic;
			PRODUCT : out std_logic_vector(A_width+B_width-1 downto 0)
			);



	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_mult_3_stage : component is "weak";

		component DW02_mult_4_stage 
					generic (
						A_width : POSITIVE ;
						B_width : POSITIVE 
							);
					port (
						A 			: in std_logic_vector(A_width-1 downto 0);
						B 			: in std_logic_vector(B_width-1 downto 0);
						TC 	    	: in std_logic;
						CLK 		: in std_logic;
						PRODUCT 	: out std_logic_vector(A_width+B_width-1 downto 0)
						);

		end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_mult_4_stage : component is "weak";
	
	
	
		component DW02_mult_5_stage 
				generic (
					A_width : POSITIVE ;
					B_width : POSITIVE 
						);
				port (
					A 			: in std_logic_vector(A_width-1 downto 0);
					B 			: in std_logic_vector(B_width-1 downto 0);
					TC 	    	: in std_logic;
					CLK 		: in std_logic;
					PRODUCT 	: out std_logic_vector(A_width+B_width-1 downto 0)
					);

	   end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_mult_5_stage : component is "weak";
	
	
	   component DW02_mult_6_stage 
				generic (
					A_width : POSITIVE ;
					B_width : POSITIVE 
						);
				port (
					A 			: in std_logic_vector(A_width-1 downto 0);
					B 			: in std_logic_vector(B_width-1 downto 0);
					TC 	    	: in std_logic;
					CLK 		: in std_logic;
					PRODUCT 	: out std_logic_vector(A_width+B_width-1 downto 0)
					);


	  end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_mult_6_stage : component is "weak";




	component DW02_tree is 
	generic( 
			num_inputs  : POSITIVE ;
			input_width : POSITIVE 
			);
		port(
			INPUT 	: in std_logic_vector((num_inputs * input_width)-1 downto 0);
			OUT0	: out std_logic_vector(input_width-1 downto 0);
			OUT1	: out std_logic_vector(input_width-1 downto 0)
			);



	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_tree : component is "weak";

	component DW02_multp is
	generic (
			a_width   : NATURAL ;
			b_width   : NATURAL ;
			out_width : NATURAL 
			);
		port(
			a     : in  std_logic_vector(a_width-1 downto 0);
			b     : in  std_logic_vector(b_width-1 downto 0);
			tc    : in  std_logic;
			out0  : out std_logic_vector(out_width-1 downto 0);
			out1  : out std_logic_vector(out_width-1 downto 0)
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_multp : component is "weak";

	component DW02_prod_sum is
	generic (
			 A_width 	: NATURAL  ;
			 B_width 	: NATURAL  ;
			 num_inputs	: POSITIVE ;
			 SUM_width 	: NATURAL 
			);
		port(
			A 	: in std_logic_vector(num_inputs*A_width-1 downto 0);
			B 	: in std_logic_vector(num_inputs*B_width-1 downto 0);
			TC 	: in std_logic;
			SUM : out std_logic_vector(SUM_width-1 downto 0)
		);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_prod_sum : component is "weak";

	component DW02_prod_sum1 is
	generic (
			A_width : NATURAL ;
			B_width : NATURAL ;
			SUM_width : NATURAL 
			);
		port(
			A 	: in std_logic_vector(A_width-1 downto 0);
			B 	: in std_logic_vector(B_width-1 downto 0);
			C 	: in std_logic_vector(SUM_width-1 downto 0);
			TC 	: in std_logic;
			SUM	: out std_logic_vector(SUM_width-1 downto 0)
		    );

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_prod_sum1 : component is "weak";

	component DW02_sum is 
	generic(
			input_width :NATURAL ;
			num_inputs  :NATURAL
			);
		port(
			INPUT	: in  std_logic_vector(input_width * num_inputs-1 downto 0);
			SUM  	: out std_logic_vector(input_width-1 downto 0)
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_sum : component is "weak";



	component DW02_mac is
	generic(
			A_width : NATURAL;
            B_width : NATURAL
		   	);
		port(
			A 	: in std_logic_vector(A_width-1 downto 0);
			B 	: in std_logic_vector(B_width-1 downto 0);
			C 	: in std_logic_vector(A_width + B_width-1 downto 0);
			TC 	: in std_logic;
			MAC	: out std_logic_vector(A_width + B_width-1 downto 0)
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_mac : component is "weak";

	component DW02_mult is 
	generic(
			A_width: NATURAL ;
			B_width: NATURAL 
			);
		port(
			A		:  in 	std_logic_vector(A_width-1 downto 0);
			B		:  in 	std_logic_vector(B_width-1 downto 0);
			TC		:  in 	std_logic;
			PRODUCT	:  out 	std_logic_vector(A_width + B_width -1 downto 0)
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_mult : component is "weak";
	
	component DW02_sqrt is 
	generic(
			width	: POSITIVE ;
			TC_mode : INTEGER  
			);
		port(
			A	:  in 	std_logic_vector(width-1 downto 0);
			TC  :  in 	std_logic;
			ROOT:  out 	std_logic_vector((width+1)/2-1 downto 0)
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_sqrt : component is "weak";
	
	component DW02_divide is
	generic(
			A_width : POSITIVE ;
			B_width : POSITIVE ;
			TC_mode : INTEGER 
			);
		port(
			A			: in 	std_logic_vector(A_width-1 downto 0);
			B			: in 	std_logic_vector(B_width-1 downto 0);
			TC			: in 	std_logic;
			DIVIDE_BY_0	: out 	std_logic;
			QUOTIENT	: out 	std_logic_vector(A_width-1 downto 0)		
			);
		
	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_divide : component is "weak";
	
	component DW02_rem is
	generic(
			A_width : POSITIVE ;
			B_width : POSITIVE ;
			TC_mode : INTEGER  
			);
		port(
			A			:  in 	std_logic_vector(A_width-1 downto 0);
			B			:  in 	std_logic_vector(B_width-1 downto 0);
			TC			:  in 	std_logic;
			REMAINDER	:  out 	std_logic_vector(B_width-1 downto 0)
			); 	

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_rem : component is "weak";

component DW_inv_sqrt is

generic (
a_width : POSITIVE := 8;
prec_control : NATURAL := 0
);

port (
a : in std_logic_vector(a_width-1 downto 0);
b : out std_logic_vector(a_width-1 downto 0);
t : out std_logic
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_inv_sqrt : component is "weak";

 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW02_components : package is "weak";

end DW02_components;
