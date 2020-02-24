--$Header: //synplicity/mapgw/designware/dw04_comp.vhd#1 $
---------------------------------------------------------------------------------------------------
--
-- File        : dw04_comp.vhd
-- Design      : Contains 15 basic DesignWare components declarations
-- Company     : Synplicity Inc.
-- Date        : Aug 25, 2008
-- Author      : Selvam R
-- Version     : 3.1
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

package DW04_components is

function bit_width(X : integer)return integer;

component DW04_par_gen 
generic (width : INTEGER := 8; par_type : INTEGER := 1);
port (datain : in std_logic_vector(width-1 downto 0);
      parity : out std_logic
    );
end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW04_par_gen : component is "weak";





component DW_ecc 
generic (width : INTEGER := 64; chkbits : INTEGER := 8; synd_sel : INTEGER := 0);
port (gen : in std_logic; 
      correct_n : in std_logic;
      datain : in std_logic_vector(width-1 downto 0);
      chkin : in std_logic_vector(chkbits-1 downto 0);
      err_detect : out std_logic;
      err_multpl : out std_logic; 
      dataout : out std_logic_vector(width-1 downto 0);
      chkout : out std_logic_vector(chkbits-1 downto 0));
end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ecc : component is "weak";





component DW_tap 
generic (width : INTEGER := 8; id : INTEGER := 0;
version : INTEGER := 0; part : INTEGER := 0;
man_num : INTEGER := 0; sync_mode : INTEGER := 0 );

port (tck : in std_logic; trst_n : in std_logic;
tms : in std_logic; tdi : in std_logic;
so : in std_logic; bypass_sel: in std_logic;
sentinel_val : in std_logic_vector(width-2 downto 0);
clock_dr : out std_logic; shift_dr : out std_logic;
update_dr : out std_logic; tdo : out std_logic;
tdo_en : out std_logic;
tap_state : out std_logic_vector(15 downto 0);
extest : out std_logic;
samp_load : out std_logic;
instructions : out std_logic_vector(width-1 downto 0);
sync_capture_en : out std_logic;
sync_update_dr : out std_logic;
test : in std_logic );

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_tap : component is "weak";



component DW_bc_1 
port (capture_clk : in std_logic; update_clk : in std_logic;
capture_en : in std_logic; update_en : in std_logic;
shift_dr : in std_logic; mode : in std_logic;
si : in std_logic; data_in : in std_logic;
data_out : out std_logic; so : out std_logic );

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_bc_1 : component is "weak";



component DW_bc_2 
port (capture_clk : in std_logic;
update_clk : in std_logic;
capture_en : in std_logic;
update_en : in std_logic;
shift_dr : in std_logic;
mode : in std_logic;
si : in std_logic;
data_in : in std_logic;
data_out : out std_logic;
so : out std_logic );

end component;


-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_bc_2 : component is "weak";



component DW_bc_3 
port (capture_clk : in std_logic; capture_en : in std_logic;
shift_dr : in std_logic; mode : in std_logic;
si : in std_logic; data_in : in std_logic;
data_out : out std_logic; so : out std_logic );

end component;


-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_bc_3 : component is "weak";


component DW_bc_4 
port (capture_clk : in std_logic;
capture_en : in std_logic;
shift_dr : in std_logic;
si : in std_logic;
data_in : in std_logic;
so : out std_logic;
data_out : out std_logic );

end component;


-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_bc_4 : component is "weak";



component DW_bc_5 
port (capture_clk : in std_logic; update_clk : in std_logic;
capture_en : in std_logic; update_en : in std_logic;
shift_dr : in std_logic; mode : in std_logic;
intest : in std_logic; si : in std_logic;
data_in : in std_logic; data_out : out std_logic;
so : out std_logic );

end component;


-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_bc_5 : component is "weak";


component DW_bc_7 
port (capture_clk : in std_logic; update_clk : in std_logic;
capture_en : in std_logic; update_en : in std_logic;
shift_dr : in std_logic; mode1 : in std_logic;
mode2 : in std_logic; si : in std_logic;
pin_input : in std_logic; control_out : in std_logic;
output_data : in std_logic; ic_input : out std_logic;
data_out : out std_logic; so : out std_logic );

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_bc_7 : component is "weak";



component DW_8b10b_dec is

generic ( bytes : integer := 2;
          k28_5_only : integer := 0;
	  en_mode : integer := 0;
	  init_mode : integer := 0
        );

port    ( clk : in std_logic;
          rst_n : in std_logic;
          init_rd_n : in std_logic;
          init_rd_val : in std_logic;
          data_in : in std_logic_vector(bytes*10-1 downto 0);
          error : out std_logic;
          rd : out std_logic;
          k_char : out std_logic_vector(bytes-1 downto 0);
          data_out : out std_logic_vector(bytes*8-1 downto 0);
	  rd_err : out std_logic;
	  code_err : out std_logic;
	  enable : in std_logic
        );

end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_8b10b_dec : component is "weak";

component DW_8b10b_enc is

generic ( bytes : integer := 16;
          k28_5_only : integer := 0;
	  en_mode : integer := 1;
	  init_mode : integer := 1 );

port   ( clk : in std_logic;
         rst_n : in std_logic;
         init_rd_n : in std_logic;
         init_rd_val : in std_logic;
         k_char : in std_logic_vector(bytes-1 downto 0);
         data_in : in std_logic_vector(bytes*8-1 downto 0);
         rd : out std_logic;
         data_out : out std_logic_vector(bytes*10-1 downto 0);
	 enable : in std_logic
        );
end component;

  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_8b10b_enc : component is "weak";

component DW_crc_p is

generic (data_width : INTEGER := 19; poly_size : INTEGER := 5;
crc_cfg : INTEGER := 7; bit_order : INTEGER := 0;
poly_coef0 : INTEGER := 5; poly_coef1 : INTEGER := 0;
poly_coef2 : INTEGER := 0; poly_coef3 : INTEGER := 0 
);

port (data_in : in std_logic_vector(data_width-1 downto 0);
crc_in : in std_logic_vector(poly_size-1 downto 0);
crc_ok : out std_logic;
crc_out : out std_logic_vector(poly_size-1 downto 0) );

end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_crc_p : component is "weak";


component DW04_crc32 is

generic (
data_width_power : INTEGER := 5;
mode_select : INTEGER := 3
);

port (
d_in : in std_logic_vector(2**data_width_power-1 downto 0);
clk : in std_logic;
reset_N : in std_logic;
enable : in std_logic;
byte_time : in std_logic;
start : in std_logic;
drain : in std_logic;
d_out : out std_logic_vector(2**data_width_power-1 downto 0);
accumulating : out std_logic;
draining : out std_logic;
crc_ok : out std_logic;
crc_reg : out std_logic_vector(31 downto 0)
);

end component;

  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW04_crc32 : component is "weak";


component DW04_shad_reg is
		generic(
				width		 : POSITIVE ;
				bld_shad_reg : NATURAL  
				);
			port( 
				datain 		: in std_logic_vector(width-1 downto 0);
				sys_clk 	: in std_logic;
				shad_clk 	: in std_logic;
				reset 		: in std_logic;
				SI 			: in std_logic;
				SE 			: in std_logic;
				sys_out 	: out std_logic_vector(width-1 downto 0);
				shad_out 	: out std_logic_vector(width-1 downto 0);
				SO 			: out std_logic
				);
end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW04_shad_reg : component is "weak";


component DW04_sync 
generic (
		num_async 	: POSITIVE ;
		redund 		: POSITIVE 
		);

port(
	async	:in  std_logic_vector(num_async-1 downto 0);
  	ref_clk	:in  std_logic;
	reset	:in  std_logic;
	error	:out std_logic;
	sync	:out std_logic_vector(num_async-1 downto 0)
	 );


end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW04_sync : component is "weak";


 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW04_components : package is "weak";

end DW04_components;


package body DW04_components is 

function bit_width (X : integer ) return integer is
variable rd  : integer:=1;
variable ret :integer := 0;
variable num : integer:=2;
begin
	for i in 0 to X	 loop
		rd := rd * num;
		ret:=i+1;
		if(rd >= X)then
			exit;
		end if;
	end loop;
	return ret;
end bit_width;	



end  DW04_components;
