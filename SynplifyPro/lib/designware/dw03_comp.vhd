--$Header: //synplicity/mapgw/designware/dw03_comp.vhd#1 $
---------------------------------------------------------------------------------------------------
--
-- File        : dw03_comp.vhd
-- Design      : Contains 18 basic DesignWare components declarations and functions
-- Company     : Synplicity Inc.
-- Date        : Aug 25, 2008
-- Author      : Selvam R
-- Version     : 3.1
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package DW03_components is

	function bit_width(X : integer)return integer;
	function maximum (L,R : integer)return integer;	
	function min     (L,R : integer)return integer;
      function data_hold_width ( din_width, dout_width : integer ) return integer; 
      function cnt_width ( din_width, dout_width : integer ) return integer;


 component DW_asymfifoctl_s1_df is
		generic (
			data_in_width 	: INTEGER;
			data_out_width 	: INTEGER;
			depth 		: INTEGER;
			err_mode 		: INTEGER;
			rst_mode 		: INTEGER;
			byte_order 		: INTEGER 
			);
		port (
			clk 			: in std_logic;
			rst_n 			: in std_logic;
			push_req_n 		: in std_logic;
			flush_n 		: in std_logic;
			pop_req_n 		: in std_logic;
			diag_n 			: in std_logic;
			ae_level    	: in  std_logic_vector(bit_width(depth)-1 downto 0); 
			af_thresh   	: in  std_logic_vector(bit_width(depth)-1 downto 0); 
			data_in 		: in std_logic_vector(data_in_width-1 downto 0);
			rd_data 		: in std_logic_vector(maximum(data_in_width, data_out_width)-1 downto 0);
			we_n 			: out std_logic;
			empty 			: out std_logic;
			almost_empty 	: out std_logic;
			half_full 		: out std_logic;
			almost_full 	: out std_logic;
			full 			: out std_logic;
			ram_full 		: out std_logic;
			error 			: out std_logic;
			part_wd 		: out std_logic;
			wr_data 		: out std_logic_vector(maximum(data_in_width, data_out_width)-1 downto 0);
			wr_addr 		: out std_logic_vector(bit_width(depth)-1 downto 0);
			rd_addr 		: out std_logic_vector(bit_width(depth)-1 downto 0);
			data_out 		: out std_logic_vector(data_out_width-1 downto 0)
			);
	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_asymfifoctl_s1_df  : component is "weak";

component DW_asymfifoctl_s1_sf is
	generic(
			data_in_width    :	INTEGER ;
			data_out_width   :	INTEGER ;
			depth		     :	INTEGER ;
                  ae_level	     :      INTEGER ;
			af_level	     :	INTEGER ;
			err_mode 	     :	INTEGER ;
			rst_mode	     :	INTEGER ;
			byte_order	     :	INTEGER 
				
			);	 

       port ( 
            	clk 	     : in std_logic ;
			rst_n 	     : in std_logic ;
        		push_req_n	 : in std_logic ;
			flush_n 	: in std_logic;
			pop_req_n	 : in std_logic ;
			diag_n		: in std_logic;
			data_in	    : in std_logic_vector ( ( data_in_width - 1 ) downto 0 );
		    	rd_data		: in std_logic_vector ( maximum(data_in_width, data_out_width)-1 downto 0);	
			we_n		 : out std_logic;
			empty	: out std_logic;
			almost_empty	: out std_logic;
			half_full	: out std_logic;			
			almost_full : out std_logic;			
			full		: out std_logic;			
			ram_full	: out std_logic;
			error	: out std_logic;
			part_wd		: out std_logic;			

			wr_data		: out std_logic_vector ( maximum(data_in_width, data_out_width)-1 downto 0);	 
			rd_addr		: out std_logic_vector ( ( bit_width(depth)  - 1) downto 0);

			wr_addr		: out std_logic_vector ( ( bit_width(depth)  - 1) downto 0);
			data_out    : out std_logic_vector ( ( data_out_width - 1 ) downto 0 )

			
		);


end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_asymfifoctl_s1_sf : component is "weak";





		
	component DW_fifoctl_s1_sf is
		generic (
			depth    : INTEGER ;
			ae_level : INTEGER ;
			af_level : INTEGER ;
			err_mode : INTEGER ;
			rst_mode : INTEGER 
			);
		port (
			clk 		: in std_logic;
			rst_n 		: in std_logic;
			push_req_n 	: in std_logic;
			pop_req_n 	: in std_logic;
			diag_n 		: in std_logic;
			we_n 		: out std_logic;
			empty 		: out std_logic;
			almost_empty: out std_logic;
			half_full 	: out std_logic;
			almost_full	: out std_logic;
			full 		: out std_logic;
			error 		: out std_logic;
			wr_addr 	: out std_logic_vector(bit_width(depth)-1 downto 0);
			rd_addr 	: out std_logic_vector(bit_width(depth)-1 downto 0)
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fifoctl_s1_sf : component is "weak";

	component DW_fifoctl_s1_df is
		generic (
			depth 	 : INTEGER ;
			err_mode : INTEGER ;
			rst_mode : INTEGER 
			);
		port (
			clk 		: in std_logic;
			rst_n 		: in std_logic;
			push_req_n 	: in std_logic;
			pop_req_n 	: in std_logic;
			diag_n 		: in std_logic;
			ae_level 	: in std_logic_vector(bit_width(depth)-1 downto 0);
			af_thresh 	: in std_logic_vector(bit_width(depth)-1 downto 0);
			we_n 		: out std_logic;
			empty 		: out std_logic;
			almost_empty: out std_logic;
			half_full 	: out std_logic;
			almost_full : out std_logic;
			full 		: out std_logic;
			error 		: out std_logic;
			wr_addr 	: out std_logic_vector(bit_width(depth)-1 downto 0);
			rd_addr 	: out std_logic_vector(bit_width(depth)-1 downto 0)
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fifoctl_s1_df : component is "weak";

component DW_fifoctl_s2_sf is
                generic (
                        depth           : INTEGER ;
                        push_ae_lvl : INTEGER ;
                        push_af_lvl : INTEGER ;
                        pop_ae_lvl      : INTEGER ;
                        pop_af_lvl  : INTEGER ;
                        err_mode        : INTEGER ;
                        push_sync       : INTEGER ;
                        pop_sync        : INTEGER ;
                        rst_mode        : INTEGER ;
                        tst_mode        : INTEGER
                        );
                port (
                        clk_push        : in std_logic;
                        clk_pop         : in std_logic;
                        rst_n           : in std_logic;
                        push_req_n  : in std_logic;
                        pop_req_n       : in std_logic;
                        we_n            : out std_logic;
                        push_empty  : out std_logic;
                        push_ae         : out std_logic;
                        push_hf         : out std_logic;
                        push_af         : out std_logic;
                        push_full       : out std_logic;
                        push_error  : out std_logic;
                        pop_empty       : out std_logic;
                        pop_ae          : out std_logic;
                        pop_hf          : out std_logic;
                        pop_af          : out std_logic;
                        pop_full        : out std_logic;
                        pop_error       : out std_logic;
                        wr_addr         : out std_logic_vector(bit_width(depth)-1 downto 0);
                        rd_addr         : out std_logic_vector(bit_width(depth)-1 downto 0);
                        push_word_count : out std_logic_vector(bit_width(depth+1)-1 downto 0);
                        pop_word_count : out std_logic_vector(bit_width(depth+1)-1 downto 0);
                        test : in std_logic
                        );

        end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fifoctl_s2_sf : component is "weak";

	

	component DW_stackctl is
		generic (
			depth    : INTEGER ;
			err_mode : INTEGER ;
			rst_mode : INTEGER 
			);
		port (
			clk 		: in std_logic;
			rst_n 		: in std_logic;
			push_req_n  : in std_logic;
			pop_req_n   : in std_logic;
			we_n 		: out std_logic;
			empty 		: out std_logic;
			full 		: out std_logic;
			error 		: out std_logic;
			wr_addr	    : out std_logic_vector(bit_width(depth)-1 downto 0);
			rd_addr 	: out std_logic_vector(bit_width(depth)-1 downto 0)
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_stackctl : component is "weak";


	component DW03_lfsr_dcnto is
		generic (
			width : INTEGER 
			);
		port (
			data 		: in std_logic_vector(width-1 downto 0);
			count_to 	: in std_logic_vector(width-1 downto 0);
			load 		: in std_logic;
			cen 		: in std_logic;
			clk 		: in std_logic;
			reset 		: in std_logic;
			count 		: out std_logic_vector(width-1 downto 0);
			tercnt 		: out std_logic
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_lfsr_dcnto : component is "weak";

	component DW03_lfsr_scnto is
		generic(width	 :	INTEGER ;
			    count_to :  INTEGER 
				);
		port( 
			data 	: in std_logic_vector(width-1 downto 0);
			load 	: in std_logic;
			cen 	: in std_logic;
			clk 	: in std_logic;
			reset 	: in std_logic;
			count	: out std_logic_vector(width-1 downto 0);
			tercnt 	: out std_logic
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_lfsr_scnto : component is "weak";

	component DW03_lfsr_load is
		generic (
			width : INTEGER 
			);
		port (
			data 	: in std_logic_vector(width-1 downto 0);
			load 	: in std_logic;
			cen 	: in std_logic;
			clk 	: in std_logic;
			reset 	: in std_logic;
			count 	: out std_logic_vector(width-1 downto 0)
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_lfsr_load : component is "weak";

	component DW03_lfsr_updn is
		generic (
			width : INTEGER 
			);
		port (
			updn 	: in std_logic;
			cen 	: in std_logic;
			clk 	: in std_logic;
			reset 	: in std_logic;
			count 	: out std_logic_vector(width-1 downto 0);
			tercnt  : out std_logic
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_lfsr_updn : component is "weak";

	component DW03_pipe_reg 
	
			generic(
					width : INTEGER ;
					depth : INTEGER 
					);
	
				port(
					A	: in std_logic_vector(width-1 downto 0);
				    clk	: in std_logic;
					B	: out std_logic_vector(width-1 downto 0)
					);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_pipe_reg : component is "weak";
	
	component DW03_shftreg is
		generic (
			length : NATURAL 
			);
		port (
			clk 	: in std_logic;
			s_in 	: in std_logic;
			p_in 	: in std_logic_vector(length-1 downto 0);
			shift_n : in std_logic;
			load_n 	: in std_logic;
			p_out 	: out std_logic_vector(length-1 downto 0)
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_shftreg : component is "weak";

	component DW03_reg_s_pl is
		generic ( 
			width       : POSITIVE ;
     		reset_value : INTEGER   
			);
		port (
			d       : in std_logic_vector(width-1 downto 0);
			clk     : in std_logic;
			reset_n : in std_logic;
			enable  : in std_logic;
			q       : out std_logic_vector(width-1 downto 0)
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_reg_s_pl : component is "weak";

	component DW03_bictr_scnto is
		generic (
			width 	 : POSITIVE ;
			count_to : POSITIVE 
			);
		port (
			data 	: in std_logic_vector(width-1 downto 0);
			up_dn 	: in std_logic;
			load 	: in std_logic;
			cen 	: in std_logic;
			clk 	: in std_logic;
			reset 	: in std_logic;
			count 	: out std_logic_vector(width-1 downto 0);
			tercnt 	: out std_logic
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_bictr_scnto : component is "weak";
	
	component DW03_bictr_dcnto is 
		generic (
			width :	integer	
			);
		port (
			data	: in 	std_logic_vector(width-1 downto 0);
			count_to: in 	std_logic_vector(width-1 downto 0);
			up_dn	: in 	std_logic;
			load	: in 	std_logic;
			cen		: in 	std_logic;
			clk		: in 	std_logic;
			reset	: in 	std_logic;			
			count	: out 	std_logic_vector(width-1 downto 0);
			tercnt	: out 	std_logic
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_bictr_dcnto : component is "weak";

	component DW03_bictr_decode is
		generic(
			width: POSITIVE 
			);
		port (
			data		: in 	std_logic_vector((width-1) downto 0);
			up_dn		: in 	std_logic;
			load		: in 	std_logic;
			cen			: in 	std_logic;			
			clk			: in 	std_logic;
			reset		: in 	std_logic;
			count_dec	:out	std_logic_vector((2**width-1) downto 0);
			tercnt		: out 	std_logic			
			);


	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_bictr_decode : component is "weak";
	
	component DW03_cntr_gray is
		generic (
			width : INTEGER 
			);
		port (
			clk 	    : in std_logic;
			reset 		: in std_logic;
			cen 		: in std_logic;
			count 		: out std_logic_vector(width-1 downto 0);
			decode_out 	: out std_logic_vector(2**width-1 downto 0)
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_cntr_gray : component is "weak";

	component DW03_updn_ctr is
		generic(
			width : POSITIVE 
			); 
		port(
			data	: in  	std_logic_vector( (width-1) downto 0);
			up_dn	: in  	std_logic;
			load	: in  	std_logic;
			cen		: in  	std_logic;
			clk		: in  	std_logic;
			reset	: in  	std_logic;
			count	: out 	std_logic_vector(( width-1) downto 0);
			tercnt	: out 	std_logic
			);

	end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_updn_ctr : component is "weak";

 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW03_components : package is "weak";
	
end DW03_components;

package body DW03_components is
 
		FUNCTION bit_width (X : integer ) return integer is
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
	

end  DW03_components;

