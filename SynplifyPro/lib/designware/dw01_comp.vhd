--$Header: //synplicity/mapgw/designware/dw01_comp.vhd#1 $
---------------------------------------------------------------------------------------------------
--
-- Title       : dw01_comp.vhd
-- Design      : Contains 21 basic DesignWare components declarations
-- Company     : Synplicity Inc.
-- Date        : Aug 25, 2008
-- Author      : Selvam R
-- Version     : 3.1
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

package DW01_components is 

component DW01_satrnd is

generic ( width : POSITIVE := 8;
msb_out : NATURAL := 6;
lsb_out : NATURAL := 2 );

port ( din : in std_logic_vector(width-1 downto 0);
tc : in std_logic;
sat : in std_logic;
rnd : in std_logic;
ov : out std_logic;
dout : out std_logic_vector(msb_out-lsb_out downto 0)
);

end component;

	-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_satrnd : component is "weak";


	component DW_cmp_dx is
		generic(
				width    : natural ;
				p1_width : natural
				);
		port( 
			a 		: in std_logic_vector(width-1 downto 0);
			b 		: in std_logic_vector(width-1 downto 0);
			tc 		: in std_logic;
			dplx 	: in std_logic;
			lt1 	: out std_logic;
			eq1 	: out std_logic;
			gt1 	: out std_logic;
			lt2 	: out std_logic;
			eq2 	: out std_logic;
			gt2 	: out std_logic
			);

	end component;
	-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_cmp_dx : component is "weak";

	component DW_shifter 

	generic(
			data_width	: POSITIVE ;
		    sh_width	: POSITIVE ;
			inv_mode	: INTEGER 
			);

		port(	
			data_in	: in std_logic_vector(data_width-1 downto 0);
			data_tc	: in std_logic;
			sh		: in std_logic_vector(sh_width-1 downto 0);
			sh_tc  	: in std_logic;
			sh_mode	: in std_logic;
			data_out: out std_logic_vector(data_width-1 downto 0)
			);	

												  
	end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_shifter : component is "weak";

	component DW01_csa 
	generic (
			width : integer 
			);
	port (
 			a 		: in std_logic_vector(width-1 downto 0);
 			b 		: in std_logic_vector(width-1 downto 0);
 			c 		: in std_logic_vector(width-1 downto 0);
 			ci 		: in std_logic;
 			carry	: out std_logic_vector(width-1 downto 0);
 			sum		: out std_logic_vector(width-1 downto 0);
 			co		: out std_logic
	);
	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_csa : component is "weak";


	component DW01_ash is
		generic(
				A_width  : positive ;
				SH_width : positive 
				);
		port( 
			A 		: in std_logic_vector(A_width-1 downto 0);
			DATA_TC : in std_logic;
			SH 		: in std_logic_vector(SH_width-1 downto 0);
			SH_TC 	: in std_logic;
			B		: out std_logic_vector(A_width-1 downto 0)
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_ash : component is "weak";
	
	component DW01_dec is
		generic(
				width : natural 
			   );
		port( 
			A     : in 	std_logic_vector (width-1 downto 0);
			SUM   : out std_logic_vector (width-1 downto 0)
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_dec : component is "weak";
	
	component DW01_inc is
		generic(
				width : natural 
				);
		port( 
			A     : in 	std_logic_vector (width-1 downto 0);
			SUM   : out std_logic_vector (width-1 downto 0)
			);


	end component; 
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_inc : component is "weak";
	
	component DW01_add is 
		generic(
				width : natural 
				);
		port( 
			A	 : in  	std_logic_vector(width-1 downto 0);
			B    : in  	std_logic_vector(width-1 downto 0);
			SUM  : out 	std_logic_vector(width-1 downto 0);
			CI   : in  	std_logic;
			CO   : out 	std_logic
			);


	end component;  
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_add : component is "weak";
	
	component DW01_incdec is
		generic(
				width : natural
				);
		port(
			A		: in 	std_logic_vector(width-1 downto 0);
			INC_DEC	: in 	std_logic;
			SUM 	: out 	std_logic_vector(width-1 downto 0) 		 
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_incdec : component is "weak";
	
	component DW01_sub is
		generic(
				width : natural 
				);
		port(
			A	: in 	std_logic_vector(width-1 downto 0);
			B	: in 	std_logic_vector(width-1 downto 0);
			CI	: in 	std_logic;
			DIFF: out 	std_logic_vector(width-1 downto 0);
			CO	: out 	std_logic
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_sub : component is "weak";
	
	component DW01_addsub is
		generic(
				width : natural
				);
		port(
			A		: in 	std_logic_vector(width-1 downto 0);
			B		: in 	std_logic_vector(width-1 downto 0);
			CI		: in 	std_logic;
			ADD_SUB	: in 	std_logic;
			SUM		: out 	std_logic_vector(width-1 downto 0);
			CO		: out 	std_logic
			);
	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_addsub : component is "weak";
	
	component DW01_absval is 
		generic(
				width : natural 
				);
		port(
			A		: in 	std_logic_vector(width-1 downto 0);
			ABSVAL	: out 	std_logic_vector(width-1 downto 0)
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_absval : component is "weak";
	
	component DW01_cmp2 is 
		generic(
				width : natural 
				);
		port(
			A		:  in 	std_logic_vector(width-1 downto 0);
			B		:  in 	std_logic_vector(width-1 downto 0);
			LEQ		:  in 	std_logic;
			TC		:  in 	std_logic;
			GE_GT	:  out 	std_logic;
			LT_LE	:  out 	std_logic
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_cmp2 : component is "weak";
	
	component DW01_cmp6 is 
		generic(
				width : natural 
				);
		port (
			A	:  in 	std_logic_vector(width-1 downto 0);
			B	:  in 	std_logic_vector(width-1 downto 0);
			TC	:  in 	std_logic;
			GE	:  out 	std_logic;
			GT	:  out 	std_logic;
			LT	:  out 	std_logic;
			LE	:  out 	std_logic;
			NE	:  out 	std_logic;
			EQ	:  out 	std_logic
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_cmp6 : component is "weak";
	
	component DW01_mux_any is 
		generic(
				A_width    : positive ;
				SEL_width  : positive ;
				MUX_width  : positive 
				);
		port(
			A	:  in 	std_logic_vector(A_width-1 downto 0);
			SEL	:  in 	std_logic_vector(SEL_width-1 downto 0);
			MUX	:  out 	std_logic_vector(MUX_width-1 downto 0)
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_mux_any : component is "weak";
	
	component DW01_decode 
		generic(
				width : natural
				);
		port(
			A 	: in 	std_logic_vector(width-1 downto 0);
			B 	: out 	std_logic_vector(2**width-1 downto 0)
			);
		
	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_decode : component is "weak";
	
	component DW01_prienc is
		generic(
				A_width     : positive ;
				INDEX_width : positive 
				); 
		port(
			A 		:  in  	std_logic_vector(A_width downto 1); -- Modified by Selvam to match Verilog component declaration
			INDEX	:  out 	std_logic_vector(INDEX_width-1 downto 0)
			);
	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_prienc : component is "weak";
	
	component DW01_binenc is
		generic(
				A_width		: positive ;
				ADDR_width  : positive
				); 
		port(
			A	 :  in    std_logic_vector(A_width-1 downto 0);
			ADDR :  out   std_logic_vector(ADDR_width-1 downto 0)
			);
	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_binenc : component is "weak";

	component DW01_bsh is 
		generic(
				A_width  : positive ;
				SH_width : positive 
				);
		port(
			A	:  in 	std_logic_vector(A_width-1 downto 0);
			SH  :  in 	std_logic_vector(SH_width-1 downto 0);
			B	:  out 	std_logic_vector(A_width-1 downto 0)
			);
	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_bsh : component is "weak";


component DW_norm 
generic (
a_width : POSITIVE := 8;
srch_wind : POSITIVE := 8;
exp_width : POSITIVE := 4;
exp_ctr : INTEGER := 0
);

port (
a : in std_logic_vector(a_width-1 downto 0);
exp_offset : in std_logic_vector(exp_width-1 downto 0);
no_detect: out std_logic;
ovfl: out std_logic;
b: out std_logic_vector(a_width-1 downto 0);
exp_adj: out std_logic_vector(exp_width-1 downto 0)
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_norm : component is "weak";


component DW_norm_rnd
generic (
a_width : POSITIVE := 16;
srch_wind : POSITIVE := 4;
exp_width : POSITIVE := 4;
b_width : POSITIVE := 10;
exp_ctr : INTEGER := 0
);

port (
a_mag : in std_logic_vector(a_width-1 downto 0);
pos_offset : in std_logic_vector(exp_width-1 downto 0);
sticky_bit : in std_logic;
a_sign : in std_logic;
rnd_mode : in std_logic_vector(2 downto 0);
pos_err: out std_logic;
no_detect: out std_logic;
b: out std_logic_vector(b_width-1 downto 0);
pos: out std_logic_vector(exp_width-1 downto 0)
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_norm_rnd : component is "weak";



 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW01_components : package is "weak";
	
end DW01_components;
