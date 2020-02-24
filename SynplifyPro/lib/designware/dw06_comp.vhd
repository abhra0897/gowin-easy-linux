--$Header: //synplicity/mapgw/designware/dw06_comp.vhd#1 $
---------------------------------------------------------------------------------------------------
--
-- File        : dw06_comp.vhd
-- Design      : Contains 18 basic DesignWare components declarations and functions
-- Company     : Synplicity Inc.
-- Date        : Aug 25, 2008
-- Author      : Selvam R
-- Version     : 3.1
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package DW06_components is
	
	function bit_width(X : integer)return integer;
	function maximum (L,R : integer)return integer;	
	function min     (L,R : integer)return integer;
	function data_hold_width ( din_width, dout_width : integer ) return integer; 
	function cnt_width ( din_width, dout_width : integer ) return integer;

component DW_asymfifo_s1_df is
		generic (
			data_in_width	: INTEGER := 8;
			data_out_width	: INTEGER := 16;
			depth 			: INTEGER := 8;	  
			err_mode 		: INTEGER := 1;
			rst_mode		: INTEGER := 1;
			byte_order		: INTEGER := 0
			);
		port (
		    clk   			: in  std_logic;
			rst_n  			: in  std_logic;
			push_req_n  	: in  std_logic;
			flush_n			: in  std_logic;
			pop_req_n   	: in  std_logic;
			diag_n  		: in  std_logic;
			data_in 		: in  std_logic_vector(data_in_width-1 downto 0);
			ae_level        : in  std_logic_vector( ( bit_width(depth) - 1) downto 0 );
			af_thresh		: in  std_logic_vector( ( bit_width(depth) - 1) downto 0 );	
			empty  			: out std_logic;
			almost_empty	: out std_logic;
			half_full 		: out std_logic;
			almost_full 	: out std_logic;
			full  			: out std_logic;
			ram_full		: out std_logic;
			error  			: out std_logic;
			part_wd			: out std_logic;
			data_out		: out std_logic_vector(data_out_width-1 downto 0)	
				
			);

	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_asymfifo_s1_df : component is "weak";

 component DW_asymfifo_s1_sf is
		generic (
			data_in_width	: INTEGER := 24;
			data_out_width	: INTEGER := 8;
			depth 			: INTEGER := 8;	  
			ae_level    	: INTEGER := 4;
			af_level   	    : INTEGER := 4;
			err_mode 		: INTEGER := 1;
			rst_mode		: INTEGER := 1;
			byte_order		: INTEGER := 0
			);
		port (
			push_req_n  	: in  std_logic;
			pop_req_n   	: in  std_logic;	 
			data_in 		: in  std_logic_vector(data_in_width-1 downto 0);
			flush_n			: in  std_logic;
			data_out		: out std_logic_vector(data_out_width-1 downto 0);	
			ram_full		: out std_logic;
			part_wd			: out std_logic;
			diag_n  		: in  std_logic;
			clk   			: in  std_logic;
			rst_n  			: in  std_logic;
			full  			: out std_logic;
			almost_full 	: out std_logic;
			half_full 		: out std_logic;
			almost_empty	: out std_logic;
			empty  			: out std_logic;
			error  			: out std_logic
			);


	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_asymfifo_s1_sf : component is "weak";



	component DW_fifo_s1_sf is
		generic (
			width 	 : INTEGER ;
			depth 	 : INTEGER ;
			ae_level : INTEGER ;
			af_level : INTEGER ;
			err_mode : INTEGER ;
			rst_mode : INTEGER 
			);
		port (
			clk 			: in std_logic;
			rst_n 			: in std_logic;
			push_req_n  	: in std_logic;
			pop_req_n 		: in std_logic;
			diag_n 			: in std_logic;
			data_in 		: in std_logic_vector(width-1 downto 0);
			empty 			: out std_logic;
			almost_empty 	: out std_logic;
			half_full 		: out std_logic;
			almost_full 	: out std_logic;
			full 			: out std_logic;
			error 			: out std_logic;
			data_out 		: out std_logic_vector(width-1 downto 0)
			);


	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fifo_s1_sf : component is "weak";
	
	component DW_fifo_s1_df is
	generic (
		depth    : INTEGER ;
		width    : INTEGER ;	
		err_mode : INTEGER ;
		rst_mode : INTEGER 
		);
	port (
		clk 		: in std_logic;
		rst_n		: in std_logic;	
		push_req_n 	: in std_logic;
		pop_req_n  	: in std_logic;
		diag_n		: in std_logic;
		ae_level    : in std_logic_vector(bit_width(depth)-1 downto 0);
		af_thresh   : in std_logic_vector(bit_width(depth)-1 downto 0);
		data_in     : in std_logic_vector(width-1 downto 0);
		empty		: out std_logic;
		almost_empty: out std_logic;		
		half_full	: out std_logic;
		almost_full	: out std_logic;
		full		: out std_logic;		
		error		: out std_logic;
		data_out    : out std_logic_vector(width-1 downto 0)
		);
	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fifo_s1_df : component is "weak";
	
	component DW_fifo_s2_sf is
		generic (
			width 		: INTEGER ;
			depth 		: INTEGER ;
			push_ae_lvl : INTEGER ;
			push_af_lvl : INTEGER ;
			pop_ae_lvl  : INTEGER ;
			pop_af_lvl  : INTEGER ;
			err_mode 	: INTEGER ;
			push_sync 	: INTEGER ;
			pop_sync 	: INTEGER ;
			rst_mode 	: INTEGER 
			);
		port (
			clk_push 	: in std_logic;
			clk_pop 	: in std_logic;
			rst_n 		: in std_logic;
			push_req_n  : in std_logic;
			pop_req_n   : in std_logic;
			data_in 	: in std_logic_vector(width-1 downto 0);
			push_empty  : out std_logic;
			push_ae 	: out std_logic;
			push_hf 	: out std_logic;
			push_af 	: out std_logic;
			push_full   : out std_logic;
			push_error  : out std_logic;
			pop_empty 	: out std_logic;
			pop_ae 		: out std_logic;
			pop_hf 		: out std_logic;
			pop_af 		: out std_logic;
			pop_full 	: out std_logic;
			pop_error 	: out std_logic;
			data_out 	: out std_logic_vector(width-1 downto 0)
			);

	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fifo_s2_sf : component is "weak";

	component DW_stack is
		generic (
			width 	 : INTEGER ;
			depth 	 : INTEGER ;
			err_mode : INTEGER ;
			rst_mode : INTEGER 
			);
		port (
			clk 		: in std_logic;
			rst_n 		: in std_logic;
			push_req_n  : in std_logic;
			pop_req_n 	: in std_logic;
			data_in 	: in std_logic_vector(width-1 downto 0);
			empty 		: out std_logic;
			full 		: out std_logic;
			error 		: out std_logic;
			data_out 	: out std_logic_vector(width-1 downto 0)
			);

	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_stack : component is "weak";

	component DW_ram_rw_a_dff is
		generic (
			data_width : INTEGER ;
			depth      : INTEGER ;
			rst_mode   : INTEGER 
			);
		port (
			rst_n        : in  std_logic;
			cs_n         : in  std_logic;
			wr_n         : in  std_logic;	 
			test_mode    : in  std_logic;
			test_clk     : in  std_logic;
			rw_addr      : in  std_logic_vector(bit_width(depth)-1 downto 0);
			data_in      : in  std_logic_vector(data_width-1 downto 0);
			data_out     : out std_logic_vector(data_width-1 downto 0)	
			);

	end component;		
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_rw_a_dff : component is "weak";
	
	component DW_ram_rw_a_lat is
		generic (
			data_width : INTEGER ;
			depth      : INTEGER ;
			rst_mode   : INTEGER 
			);
		port (
			rst_n    : in  std_logic;
			cs_n     : in  std_logic;
			wr_n     : in  std_logic;
			rw_addr  : in  std_logic_vector(bit_width(depth)-1 downto 0);
			data_in  : in  std_logic_vector(data_width-1 downto 0);
			data_out : out std_logic_vector(data_width-1 downto 0)	
			);

	end component;	
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_rw_a_lat : component is "weak";
	
	component DW_ram_r_w_a_dff is
		generic (
			data_width : INTEGER ;
			depth      : INTEGER ;
			rst_mode   : INTEGER 
			);		
		port (
			rst_n      : in  std_logic;
			cs_n       : in  std_logic;
			wr_n       : in  std_logic;
			test_mode  : in  std_logic;
			test_clk   : in  std_logic;
			rd_addr    : in  std_logic_vector(bit_width (depth)-1 downto 0);
			wr_addr    : in  std_logic_vector(bit_width (depth)-1 downto 0);
			data_in    : in  std_logic_vector(data_width-1 downto 0);
			data_out   : out std_logic_vector(data_width-1 downto 0) 
			);

	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_r_w_a_dff : component is "weak";
	
	
	component DW_ram_r_w_a_lat is
		generic (
			data_width : INTEGER ;
			depth      : INTEGER ;
			rst_mode   : INTEGER 
			);
		port (
			rst_n 	   : in  std_logic;
			cs_n 	   : in  std_logic;
			wr_n       : in  std_logic;
			rd_addr    : in  std_logic_vector(bit_width(depth)-1 downto 0);
			wr_addr    : in  std_logic_vector(bit_width(depth)-1 downto 0);
			data_in    : in  std_logic_vector(data_width-1 downto 0);
			data_out   : out std_logic_vector(data_width-1 downto 0)
			);

	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_r_w_a_lat : component is "weak";
	
	component DW_ram_2r_w_a_dff is					   
		generic (
			data_width : INTEGER ;
			depth      : INTEGER ;
			rst_mode   : INTEGER 
			);	
		port (
			rst_n        : in  std_logic;
			cs_n         : in  std_logic;
			wr_n         : in  std_logic;
			test_mode    : in  std_logic;
			test_clk     : in  std_logic;
			rd1_addr     : in  std_logic_vector(bit_width(depth)-1 downto 0);
			rd2_addr     : in  std_logic_vector(bit_width(depth)-1 downto 0);
			wr_addr      : in  std_logic_vector(bit_width(depth)-1 downto 0);
			data_in      : in  std_logic_vector(data_width-1 downto 0);
			data_rd1_out : out std_logic_vector(data_width-1 downto 0);
			data_rd2_out : out std_logic_vector(data_width-1 downto 0)
			);

	end component;	 
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_2r_w_a_dff : component is "weak";
	
	
	component DW_ram_2r_w_a_lat is
		generic (
			data_width : INTEGER ;
			depth      : INTEGER ;
			rst_mode   : INTEGER 
			);	
		port (
			rst_n 			: in  std_logic;
			cs_n 			: in  std_logic;
			wr_n 			: in  std_logic;
			rd1_addr 		: in  std_logic_vector(bit_width(depth)-1 downto 0);
			rd2_addr 		: in  std_logic_vector(bit_width(depth)-1 downto 0);
			wr_addr 		: in  std_logic_vector(bit_width(depth)-1 downto 0);
			data_in 		: in  std_logic_vector(data_width-1 downto 0);
			data_rd1_out 	: out std_logic_vector(data_width-1 downto 0);
			data_rd2_out 	: out std_logic_vector(data_width-1 downto 0) 
			);

	end component;	
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_2r_w_a_lat : component is "weak";

	component DW_ram_rw_s_dff is
		generic (
			data_width : INTEGER ;
			depth 	   : INTEGER ;
			rst_mode   : INTEGER 
			);
		port (
			clk 		: in std_logic;
			rst_n 		: in std_logic;
			cs_n 		: in std_logic;
			wr_n 		: in std_logic;
			rw_addr 	: in std_logic_vector(bit_width(depth)-1 downto 0);
			data_in 	: in std_logic_vector(data_width-1 downto 0);
			data_out 	: out std_logic_vector(data_width-1 downto 0)
			);

	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_rw_s_dff : component is "weak";
	
	component DW_ram_rw_s_lat is 
		generic ( 
			data_width : INTEGER ;
			depth      : INTEGER 
		    );		
		port( 
			clk        : in  std_logic;
			cs_n       : in  std_logic;
			wr_n       : in  std_logic;
			rw_addr    : in  std_logic_vector (bit_width(depth)-1 downto 0);
			data_in    : in  std_logic_vector (data_width-1 downto 0);
			data_out   : out std_logic_vector (data_width-1 downto 0)	
			);

	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_rw_s_lat : component is "weak";
	
	component DW_ram_r_w_s_dff is 
		generic ( 
			data_width : INTEGER ;
			depth      : INTEGER ;
			rst_mode   : INTEGER 
			);		
		port ( 
			rd_addr  : in  std_logic_vector(bit_width(depth)-1 downto 0);
			wr_addr  : in  std_logic_vector(bit_width(depth)-1 downto 0);
			data_in  : in  std_logic_vector(data_width-1 downto 0);
			clk		 : in  std_logic;
			rst_n	 : in  std_logic;
			cs_n     : in  std_logic;
			wr_n	 : in  std_logic;
			data_out : out std_logic_vector(data_width-1 downto 0)   
			);

	end component; 	 
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_r_w_s_dff : component is "weak";
	
	component DW_ram_r_w_s_lat is 
		generic ( 
			data_width : INTEGER ;
			depth      : INTEGER 
			);		
		port ( 
			rd_addr  : in  std_logic_vector(bit_width(depth)-1 downto 0);
			wr_addr  : in  std_logic_vector(bit_width(depth)-1 downto 0);
			data_in  : in  std_logic_vector(data_width-1 downto 0);
			clk		 : in  std_logic;
			cs_n     : in  std_logic;
			wr_n	 : in  std_logic;
			data_out : out std_logic_vector(data_width-1 downto 0)
			);

	end component; 
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_r_w_s_lat : component is "weak";

	component DW_ram_2r_w_s_dff is
		generic (
			data_width : INTEGER ;
			depth 	   : INTEGER ;
			rst_mode   : INTEGER 
			);
		port (
			clk 			: in std_logic;
			rst_n 			: in std_logic;
			cs_n 			: in std_logic;
			wr_n 			: in std_logic;
			rd1_addr 		: in std_logic_vector(bit_width(depth)-1 downto 0);
			rd2_addr 		: in std_logic_vector(bit_width(depth)-1 downto 0);
			wr_addr 		: in std_logic_vector(bit_width(depth)-1 downto 0);
			data_in 		: in std_logic_vector(data_width-1 downto 0);
			data_rd1_out 	: out std_logic_vector(data_width-1 downto 0);
			data_rd2_out 	: out std_logic_vector(data_width-1 downto 0)
			);

	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_2r_w_s_dff : component is "weak";

	component DW_ram_2r_w_s_lat is
		generic ( 
			data_width : INTEGER ;
			depth      : INTEGER 
			);			
		port ( 
			clk 		 : in std_logic;
			cs_n    	 : in std_logic;
			wr_n    	 : in std_logic;
			rd1_addr 	 : in std_logic_vector(bit_width(depth)-1 downto 0);
			rd2_addr 	 : in std_logic_vector(bit_width(depth)-1 downto 0);
			wr_addr		 : in std_logic_vector(bit_width(depth)-1 downto 0);
			data_in 	 : in std_logic_vector(data_width-1 downto 0);
			data_rd1_out : out std_logic_vector(data_width-1 downto 0);
			data_rd2_out : out std_logic_vector(data_width-1 downto 0)  	   
			);

	end component;
  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_ram_2r_w_s_lat : component is "weak";

 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW06_components : package is "weak";

end DW06_components;  

--===============================================================				
package body DW06_components is 
	
	FUNCTION bit_width (X : integer ) return integer is
		variable rd  : integer:=1;
		variable ret :integer := 0;
		variable num : integer:=2;
	begin
		for i in 0 to X	 loop
			rd := rd * num;
			ret:=i+1;
			if(rd >= X)then exit;
			end if;
		end loop;
		return ret;
	end bit_width;

	FUNCTION maximum(L, R: INTEGER) return INTEGER is
	        begin
	        if L > R then return L;
	        else          return R;
	        end if;
        end maximum;	 
		
	FUNCTION min(L, R: INTEGER) return INTEGER is
	        begin
	        if L < R then return L;
	        else          return R;
	        end if;
        end min;
function data_hold_width ( din_width, dout_width : integer ) return integer is
variable w1, w2, k1, k2 : integer;
begin
	w1 := din_width;
	w2 := dout_width;
	k1 := w1/w2;
	k2 := w2/w1;
	if ( w1 < w2 ) then
		return ( (k2 -1) * din_width );
	elsif ( w1 = w2 ) then
	return din_width;
	else
		return ( ( k1 -1 ) * din_width );
	end if;
end data_hold_width;

function cnt_width ( din_width, dout_width : integer ) return integer is
variable w1, w2, k1, k2 : integer;
variable sum, power_of2 : integer;
begin
	w1 := din_width;
	w2 := dout_width;
	k1 := w1/w2;
	k2 := w2/w1; 
	
	if ( w1 = w2 ) then
		return 2;
	elsif ( w1 < w2 ) then 
	sum := 0;
	power_of2 := 1;
	for i in 1 to 9 loop 
		if ( k2 > power_of2 ) then
			sum := sum + 1;
		end if;
		power_of2 := power_of2 * 2;
	end loop;
	return sum;
	else
	sum := 0;
	power_of2 := 1;
	for i in 1 to 9 loop 
		if ( k1 > power_of2 ) then
			sum := sum + 1;
		end if;
		power_of2 := power_of2 * 2;
	end loop;
	return sum;	
	end if;
end cnt_width;


end  DW06_components;
