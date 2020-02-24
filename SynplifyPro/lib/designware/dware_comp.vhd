--$Header: //synplicity/mapgw/designware/dware_comp.vhd#1 $
---------------------------------------------------------------------------------------------------
--
-- File        : dware_comp.vhd
-- Design      : Contains 29 basic DesignWare components declarations and functions
-- Company     : Synplicity Inc.
-- Date        : Aug 25, 2008
-- Author      : Selvam R
-- Version     : 3.1
--
---------------------------------------------------------------------------------------------------
--synthesis internal_package



library IEEE;
use IEEE.std_logic_1164.all;

package DW_Foundation_comp_arith is
        function maximum (L,R : integer)return integer;
function ceillog2 (X : integer ) return integer;
function bit_width(X : integer)return integer;

component DW_cntr_gray 
generic (width : POSITIVE := 8);

port (clk : in std_logic;
      rst_n : in std_logic;
      init_n : in std_logic;
      load_n : in std_logic;
      data : in std_logic_vector(width-1 downto 0);
      cen : in std_logic;
      count : out std_logic_vector(width-1 downto 0));
end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_cntr_gray : component is "weak";




component DW_gray2bin 
generic (width : POSITIVE := 8);

port (g : in std_logic_vector(width-1 downto 0);
      b : out std_logic_vector(width-1 downto 0));


end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_gray2bin : component is "weak";



component DW_bin2gray 
generic (width : POSITIVE := 8);

port (b : in std_logic_vector(width-1 downto 0);
      g : out std_logic_vector(width-1 downto 0));


end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_bin2gray : component is "weak";

component DW_div_pipe 

generic (a_width : POSITIVE := 8; b_width : POSITIVE := 8;
tc_mode : NATURAL := 0; rem_mode : NATURAL := 1;
num_stages : POSITIVE := 2; stall_mode : NATURAL := 1;
rst_mode : NATURAL := 1 );

port (clk : in std_logic;
rst_n : in std_logic;
en : in std_logic;
a : in std_logic_vector(a_width-1 downto 0);
b : in std_logic_vector(b_width-1 downto 0);
quotient : out std_logic_vector(a_width-1 downto 0);
remainder : out std_logic_vector(b_width-1 downto 0);
divide_by_0 : out std_logic );

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_div_pipe : component is "weak";


component DW_sqrt_pipe 
generic (width : POSITIVE := 2; tc_mode : NATURAL := 0;
num_stages : POSITIVE := 2; stall_mode : NATURAL := 1;
rst_mode : NATURAL := 1 );

port (clk : in std_logic;
rst_n : in std_logic;
en : in std_logic;
a : in std_logic_vector(width-1 downto 0);
root : out std_logic_vector((width+1)/2-1 downto 0) );


end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_sqrt_pipe : component is "weak";


component DW_mult_pipe 
generic (
a_width : POSITIVE := 8; 
b_width : POSITIVE := 8;
num_stages : POSITIVE := 2; 
stall_mode : NATURAL := 1;
rst_mode : NATURAL := 1
        );

port (
clk : in std_logic; 
rst_n : in std_logic;
en : in std_logic; 
tc : in std_logic;
a : in std_logic_vector(a_width-1 downto 0);
b : in std_logic_vector(b_width-1 downto 0);
product : out std_logic_vector(a_width + b_width-1 downto 0)
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_mult_pipe : component is "weak";


component DW_prod_sum_pipe 

generic (
a_width : POSITIVE := 2;
b_width : POSITIVE := 2;
num_inputs : POSITIVE := 2;
sum_width : POSITIVE := 4;
num_stages : POSITIVE := 2;
stall_mode : NATURAL := 1;
rst_mode : NATURAL := 1 
);

port (

clk : in std_logic;
rst_n : in std_logic;
en : in std_logic;
tc : in std_logic;
a : in std_logic_vector(a_width*num_inputs-1 downto 0);
b : in std_logic_vector(b_width*num_inputs-1 downto 0);
sum : out std_logic_vector(sum_width-1 downto 0) );

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_prod_sum_pipe : component is "weak";


component DW_bc_8 
port (capture_clk : in std_logic;
update_clk : in std_logic;
capture_en : in std_logic;
update_en : in std_logic;
shift_dr : in std_logic;
mode : in std_logic;
si : in std_logic;
pin_input : in std_logic;
output_data : in std_logic;
ic_input : out std_logic;
data_out : out std_logic;
so : out std_logic );

end component;


-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_bc_8 : component is "weak";


component DW_bc_9 
port (capture_clk : in std_logic;
update_clk : in std_logic;
capture_en : in std_logic;
update_en : in std_logic;
shift_dr : in std_logic;
mode1 : in std_logic;
mode2 : in std_logic;
si : in std_logic;
pin_input : in std_logic;
output_data : in std_logic;
data_out : out std_logic;
so : out std_logic );

end component;


-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_bc_9 : component is "weak";


component DW_bc_10 
port (capture_clk : in std_logic;
update_clk : in std_logic;
capture_en : in std_logic;
update_en : in std_logic;
shift_dr : in std_logic;
mode : in std_logic;
si : in std_logic;
pin_input : in std_logic;
output_data : in std_logic;
data_out : out std_logic;
so : out std_logic );

end component;


-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_bc_10 : component is "weak";



component  DW_asymfifo_s2_sf
generic (data_in_width : INTEGER := 16;
data_out_width : INTEGER := 8;
depth : INTEGER := 16;
push_ae_lvl : INTEGER := 2;
push_af_lvl : INTEGER := 2;
pop_ae_lvl : INTEGER := 2;
pop_af_lvl : INTEGER := 2;
err_mode : INTEGER := 0;
push_sync : INTEGER := 2;
pop_sync : INTEGER := 2;
rst_mode : INTEGER := 1;
byte_order : INTEGER := 0 );
port (clk_push : in std_logic;
clk_pop : in std_logic;
rst_n : in std_logic;
push_req_n : in std_logic;
flush_n : in std_logic;
pop_req_n : in std_logic;
data_in : in std_logic_vector(data_in_width-1 downto 0);
push_empty : out std_logic;
push_ae : out std_logic;
push_hf : out std_logic;
push_af : out std_logic;
push_full : out std_logic;
ram_full : out std_logic;
part_wd : out std_logic;
push_error : out std_logic;
pop_empty : out std_logic;
pop_ae : out std_logic;
pop_hf : out std_logic;
pop_af : out std_logic;
pop_full : out std_logic;
pop_error : out std_logic;
data_out : out std_logic_vector(data_out_width-1 downto 0)
);

end component;

  -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_asymfifo_s2_sf : component is "weak";


component DW_asymfifoctl_s2_sf 
generic (
data_in_width : INTEGER := 4;
data_out_width : INTEGER := 16;
depth : INTEGER := 8;
push_ae_lvl : INTEGER := 2;
push_af_lvl : INTEGER := 2;
pop_ae_lvl : INTEGER := 2;
pop_af_lvl : INTEGER := 2;
err_mode : INTEGER := 0;
push_sync : INTEGER := 1;
pop_sync : INTEGER := 1;
rst_mode : INTEGER := 1;
byte_order : INTEGER := 0
);
port (
clk_push : in std_logic;
clk_pop : in std_logic;
rst_n : in std_logic;
push_req_n : in std_logic;
flush_n : in std_logic;
pop_req_n : in std_logic;
data_in : in std_logic_vector(data_in_width-1 downto 0);
rd_data : in std_logic_vector(maximum(data_in_width,
data_out_width)-1 downto 0);
we_n : out std_logic;
push_empty : out std_logic;
push_ae : out std_logic;
push_hf : out std_logic;
push_af : out std_logic;
push_full : out std_logic;
ram_full : out std_logic;
part_wd : out std_logic;
push_error : out std_logic;
pop_empty : out std_logic;
pop_ae : out std_logic;
pop_hf : out std_logic;
pop_af : out std_logic;
pop_full : out std_logic;
pop_error : out std_logic;
wr_data : out std_logic_vector(maximum(data_in_width,
data_out_width)-1 downto 0);
wr_addr : out std_logic_vector(bit_width(depth)-1 downto 0);
rd_addr : out std_logic_vector(bit_width(depth)-1 downto 0);
data_out : out std_logic_vector(data_out_width-1 downto 0)
);
end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_asymfifoctl_s2_sf : component is "weak";

component DW_sqrt 

generic (width : positive := 32;
tc_mode : natural := 1);

port (a : in std_logic_vector(width-1 downto 0);
root : out std_logic_vector((width+1)/2-1 downto 0));

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_sqrt : component is "weak";

component DW_div_seq 
	generic(
		a_width	 :POSITIVE;
		b_width	 :POSITIVE;
		tc_mode	 :INTEGER;
		num_cyc  :INTEGER;
		rst_mode :INTEGER;
		input_mode :INTEGER;
		output_mode :INTEGER;
		early_start :INTEGER
		);
	port(  
		clk			: in std_logic;
		rst_n 		: in std_logic;
		hold		: in std_logic;
		start		: in std_logic;
		a 			: in std_logic_vector(a_width-1 downto 0);
		b 			: in std_logic_vector(b_width-1 downto 0);
		complete	: out std_logic; 
		divide_by_0	: out std_logic;
		quotient	: out std_logic_vector(a_width-1 downto 0);
		remainder	: out std_logic_vector(b_width-1 downto 0)
		);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_div_seq : component is "weak";


component DW_minmax is
	generic(
			width 		: NATURAL;
			num_inputs  : NATURAL
	       );
	port(
		a 	  	: in 	std_logic_vector((width * num_inputs)-1 downto 0);
		tc	  	: in 	std_logic;
		min_max : in 	std_logic;
		value	: out   std_logic_vector(width-1 downto 0);
		index	: out	std_logic_vector(ceillog2(num_inputs)-1 downto 0)
		);

end component ;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_minmax : component is "weak";


component DW_div
	generic (
			a_width 	: POSITIVE ;
			b_width 	: POSITIVE ; 
			tc_mode 	: NATURAL ;
			rem_mode 	: NATURAL 
			);
	port (
		a 			: in std_logic_vector(a_width-1 downto 0);
		b 			: in std_logic_vector(b_width-1 downto 0);
		quotient 	: out std_logic_vector(a_width-1 downto 0);
		remainder 	: out std_logic_vector(b_width-1 downto 0);
		divide_by_0 : out std_logic
		);

end component;	
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_div : component is "weak";

component DW_addsub_dx is
        generic (
                        width    : natural ;
                        p1_width : natural
                        );
        port (
                a           : in  std_logic_vector(width-1 downto 0);
                b       : in  std_logic_vector(width-1 downto 0);
                ci1     : in  std_logic;
                ci2     : in  std_logic;
                addsub  : in  std_logic;
                tc          : in  std_logic;
                sat     : in  std_logic;
                avg     : in  std_logic;
                dplx    : in  std_logic;
                sum     : out std_logic_vector(width-1 downto 0);
                co1     : out std_logic;
                co2     : out std_logic
                );

end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_addsub_dx : component is "weak";

component DW_mult_dx is

        generic ( width : NATURAL ;
               p1_width : NATURAL  );

        port (
                a       : in   std_logic_vector(width-1 downto 0);
                b       : in   std_logic_vector(width-1 downto 0);
                tc      : in   std_logic;
                dplx    : in   std_logic;
                product : out  std_logic_vector(2*width-1 downto 0)
        );


end component;
-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_mult_dx : component is "weak";

component DW_inc_gray

generic (width : positive := 8);

port (a : in std_logic_vector(width-1 downto 0);
ci : in std_logic;
z: out std_logic_vector(width-1 downto 0));

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_inc_gray : component is "weak";



 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_Foundation_comp_arith : package is "weak";

end DW_Foundation_comp_arith;


package body DW_Foundation_comp_arith is 

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

FUNCTION maximum(L, R: INTEGER) return INTEGER is
begin
	if L > R then return L;
	else          return R;
	end if;
end maximum;

function ceillog2 (X : integer ) return integer is
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
end ceillog2;		    	
end  DW_Foundation_comp_arith;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_arith.all;

package Dwpackages is

 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of Dwpackages : package is "weak";

end Dwpackages;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

package DW_Foundation_arith is

 -- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_Foundation_arith : package is "weak";

  --------------------------------------------------------------------------------
--    Function returns the greater of two integers
--------------------------------------------------------------------------------
    function maximum(L, R: INTEGER) return INTEGER;
--------------------------------------------------------------------------------
--    Function returns the minimum of two integers
--------------------------------------------------------------------------------
    function minimum(L, R: INTEGER) return INTEGER;

  -- Content from file, DW_div.vhdpp

  function "/" (A : unsigned; B : unsigned) return unsigned;
  function "/" (A : signed; B : signed) return signed;
  function "/" (A : signed; B : unsigned) return signed;
  function "/" (A : unsigned; B : signed) return signed;
  function "/" (A : unsigned; B : unsigned) return std_logic_vector;
  function "/" (A : signed; B : signed) return std_logic_vector;
  function "/" (A : signed; B : unsigned) return std_logic_vector;
  function "/" (A : unsigned; B : signed) return std_logic_vector;
  function "rem" (A : unsigned; B : unsigned) return unsigned;
  function "rem" (A : signed; B : signed) return signed;
  function "rem" (A : signed; B : unsigned) return signed;
  function "rem" (A : unsigned; B : signed) return signed;
  function "rem" (A : unsigned; B : unsigned) return std_logic_vector;
  function "rem" (A : signed; B : signed) return std_logic_vector;
  function "rem" (A : signed; B : unsigned) return std_logic_vector;
  function "rem" (A : unsigned; B : signed) return std_logic_vector;
  function "mod" (A : unsigned; B : unsigned) return unsigned;
  function "mod" (A : signed; B : signed) return signed;
  function "mod" (A : signed; B : unsigned) return signed;
  function "mod" (A : unsigned; B : signed) return signed;
  function "mod" (A : unsigned; B : unsigned) return std_logic_vector;
  function "mod" (A : signed; B : signed) return std_logic_vector;
  function "mod" (A : signed; B : unsigned) return std_logic_vector;
  function "mod" (A : unsigned; B : signed) return std_logic_vector;
  function DWF_div (A, B : unsigned) return unsigned;
  function DWF_div (A, B : signed) return signed;
  function DWF_rem (A, B : unsigned) return unsigned;
  function DWF_rem (A, B : signed) return signed;
  function DWF_mod (A, B : unsigned) return unsigned;
  function DWF_mod (A, B : signed) return signed;
  function DWF_divide (A, B : unsigned) return unsigned;
  function DWF_divide (A, B : signed) return signed;
  function DW_divide (A, B : unsigned) return unsigned;
  function DW_divide (A, B : signed) return signed;
  function DW_rem (A, B : unsigned) return unsigned;
  function DW_rem (A, B : signed) return signed;
  function DW_mod (A, B : unsigned) return unsigned;
  function DW_mod (A, B : signed) return signed;
  function DWF_vhd_mod (A, B : unsigned) return unsigned;
  function DWF_vhd_mod (A, B : signed) return signed;
  function DW_func_vhd_mod (A, B : unsigned) return unsigned;
  function DW_func_vhd_mod (A, B : signed) return signed;
  function DWF_ver_mod (A, B : unsigned) return unsigned;
  function DWF_ver_mod (A, B : signed) return signed;
  function DW_func_ver_mod (A, B : unsigned) return unsigned;
  function DW_func_ver_mod (A, B : signed) return signed;

  -- Content from file, DW01_binenc.vhdpp

    function DWF_binenc(A: SIGNED; ADDR_width: NATURAL) return SIGNED;
    
    function DWF_binenc(A: UNSIGNED; ADDR_width: NATURAL) 
        return UNSIGNED;

    function DWF_binenc(A: std_logic_vector; ADDR_width: NATURAL) 
        return std_logic_vector;

    function DW_binenc(A: SIGNED; ADDR_width: NATURAL) return SIGNED;

    function DW_binenc(A: UNSIGNED; ADDR_width: NATURAL)
        return UNSIGNED;

    function DW_binenc(A: std_logic_vector; ADDR_width: NATURAL)
        return std_logic_vector;

-- Content from file, DW01_prienc.vhdpp

    function DWF_prienc(A: SIGNED; INDEX_width: NATURAL) return SIGNED;
    
    function DWF_prienc(A: UNSIGNED; INDEX_width: NATURAL) 
        return UNSIGNED;

    function DWF_prienc(A: std_logic_vector; INDEX_width: NATURAL) 
        return std_logic_vector;

    function DW_prienc(A: SIGNED; INDEX_width: NATURAL) return SIGNED;

    function DW_prienc(A: UNSIGNED; INDEX_width: NATURAL)
        return UNSIGNED;

    function DW_prienc(A: std_logic_vector; INDEX_width: NATURAL)
        return std_logic_vector;


  -- Content from file, DW01_decode.vhdpp

    function DWF_decode(A: SIGNED) return SIGNED;
    
    function DWF_decode(A: UNSIGNED) return UNSIGNED;

    function DWF_decode(A: std_logic_vector) return std_logic_vector;
    function DW_decode(A: SIGNED) return SIGNED;

    function DW_decode(A: UNSIGNED) return UNSIGNED;

    function DW_decode(A: std_logic_vector) return std_logic_vector;


end DW_Foundation_arith;

package body DW_Foundation_arith is

	--------------------------------------------------------
	--  This function succesively checks the number       
	--  against powers of 2 to see where it fits.
	--  This is a sequential search of log_base2_ceilings
	--   a binary search using half of max length of integer
	--   is probably faster    (argument is RANGE)
	--------------------------------------------------------
	 FUNCTION bit_width (num : integer) RETURN integer IS
         variable count : integer;
	 Begin
           count := 1;
	   if (num <= 0) then return 0;
	   elsif (num <= 2**10) then
	    for i in 1 to 10 loop
	     if (2**count >= num)  then
	      return i; 
             end if;
             count := count + 1;
	    end loop;
	   elsif (num <= 2**20) then
	    for i in 1 to 20 loop
	     if (2**count >= num)  then
	      return i; 
             end if;
             count := count + 1;
	    end loop;
	   elsif (num <= 2**30) then
	    for i in 1 to 30 loop
	     if (2**count >= num)  then
	      return i; 
             end if;
             count := count + 1;
	    end loop;
           else
	    for i in 1 to num loop
	     if (2**i >= num)  then
	      return i; 
             end if;
	    end loop;
	  end if;
	 end bit_width;
       

        --------------------------------------------------------
        --   similar to above function (BITS FOR REPRESENTING ARG)
        --------------------------------------------------------
         FUNCTION bit_width_1 (num : integer) RETURN integer IS

         Begin
	  if (num < 0) then return 0;
	  elsif (num = 0) then return 1;
	  else
           for i in 1 to num loop
             if (2**i > num) then
                return i;
             end if;
           end loop;
	  end if;
         end bit_width_1;
        
--------------------------------------------------------------------------------
--    Function returns the greater of two integers
--------------------------------------------------------------------------------

    function maximum(L, R: INTEGER) return INTEGER is
    begin
        if L > R then
            return L;
        else
            return R;
        end if;
    end maximum;

--------------------------------------------------------------------------------
--    Function returns the minimum of two integers
--------------------------------------------------------------------------------

    function minimum(L, R: INTEGER) return INTEGER is
    begin
        if L < R then
            return L;
        else
            return R;
        end if;
    end minimum;

  -- Function operator definitions

  function "/" (A : unsigned; B : unsigned) return unsigned is
  begin
    return DWF_div (A, B);
  end;
  
  function "/" (A : signed; B : signed) return signed is
  begin
    return DWF_div (A, B);
  end;

  function "/" (A : signed; B : unsigned) return signed is
  begin
    return DWF_div (A, conv_signed(B, B'length+1));
  end;
  
  function "/" (A : unsigned; B : signed) return signed is
  begin
    return DWF_div (conv_signed(A, A'length+1), B);
  end;
  
  function "/" (A : unsigned; B : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(DWF_div (A, B));
  end;
  
  function "/" (A : signed; B : signed) return std_logic_vector is
  begin
    return std_logic_vector(DWF_div (A, B));
  end;
  
  function "/" (A : signed; B : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(DWF_div (A, conv_signed(B, B'length+1)));
  end;
  
  function "/" (A : unsigned; B : signed) return std_logic_vector is
  begin
    return std_logic_vector(DWF_div (conv_signed(A, A'length+1), B));
  end;

  function "rem" (A : unsigned; B : unsigned) return unsigned is
  begin
    return DWF_rem (A, B);
  end;
  
  function "rem" (A : signed; B : signed) return signed is
  begin
    return DWF_rem (A, B);
  end;

  function "rem" (A : signed; B : unsigned) return signed is
  begin
    return DWF_rem (A, conv_signed(B, B'length+1));
  end;
  
  function "rem" (A : unsigned; B : signed) return signed is
  begin
    return DWF_rem (conv_signed(A, A'length+1), B);
  end;
  
  function "rem" (A : unsigned; B : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(DWF_rem (A, B));
  end;
  
  function "rem" (A : signed; B : signed) return std_logic_vector is
  begin
    return std_logic_vector(DWF_rem (A, B));
  end;
  
  function "rem" (A : signed; B : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(DWF_rem (A, conv_signed(B, B'length+1)));
  end;
  
  function "rem" (A : unsigned; B : signed) return std_logic_vector is
  begin
    return std_logic_vector(DWF_rem (conv_signed(A, A'length+1), B));
  end;

  function "mod" (A : unsigned; B : unsigned) return unsigned is
  begin
    return DWF_mod (A, B);
  end;
  
  function "mod" (A : signed; B : signed) return signed is
  begin
    return DWF_mod (A, B);
  end;

  function "mod" (A : signed; B : unsigned) return signed is
  begin
    return DWF_mod (A, conv_signed(B, B'length+1));
  end;
  
  function "mod" (A : unsigned; B : signed) return signed is
  begin
    return DWF_mod (conv_signed(A, A'length+1), B);
  end;
  
  function "mod" (A : unsigned; B : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(DWF_mod (A, B));
  end;
  
  function "mod" (A : signed; B : signed) return std_logic_vector is
  begin
    return std_logic_vector(DWF_mod (A, B));
  end;
  
  function "mod" (A : signed; B : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(DWF_mod (A, conv_signed(B, B'length+1)));
  end;
  
  function "mod" (A : unsigned; B : signed) return std_logic_vector is
  begin
    return std_logic_vector(DWF_mod (conv_signed(A, A'length+1), B));
  end;


  -- Function definitions
  
  function DWF_div (A, B : unsigned) return unsigned is
    -- pragma map_to_operator DIV_UNS_OP
    -- pragma type_function DIV_UNSIGNED_ARG
    -- pragma return_port_name QUOTIENT
    constant max_uns : unsigned(A'length-1 downto 0) := (others => '1');
    variable quot_uns : unsigned(A'length-1 downto 0);
    variable rem_uns : unsigned(B'length-1 downto 0);
  begin
    -- pragma translate_off
    if B = 0 then
      quot_uns := max_uns;
      assert false report "WARNING: Division by zero" severity warning;
    else
      DIV_REM (A, B, quot_uns, rem_uns);
    end if;
    return quot_uns;
    -- pragma translate_on
  end DWF_div;

  function DWF_div (A, B : signed) return signed is
    -- pragma map_to_operator DIV_TC_OP
    -- pragma type_function DIV_SIGNED_ARG
    -- pragma return_port_name QUOTIENT
    constant min_sgn : signed(A'length-1 downto 0) :=
      '1' & (A'length-2 downto 0 => '0');
    constant max_sgn : signed(A'length-1 downto 0) :=
      '0' & (A'length-2 downto 0 => '1');
    variable A_uns : unsigned(A'length-1 downto 0);
    variable B_uns : unsigned(B'length-1 downto 0);
    variable quot_uns : unsigned(A'length-1 downto 0);
    variable rem_uns : unsigned(B'length-1 downto 0);
    variable quot_sgn : signed(A'length-1 downto 0);
  begin
    -- pragma translate_off
    if B = 0 then
      if A >= 0 then
        quot_sgn := max_sgn;
      else
        quot_sgn := min_sgn;
      end if;
      assert false report "WARNING: Division by zero" severity warning;
    else
      if A(A'left) = '0' then
        A_uns := unsigned(A);
      else
        A_UNS := unsigned(signed'(-A));
      end if;
      if B(B'left) = '0' then
        B_uns := unsigned(B);
      else
        B_uns := unsigned(signed'(-B));
      end if;
      DIV_REM (A_uns, B_uns, quot_uns, rem_uns);
      if A(A'left) = B(B'left) then
        quot_sgn := signed(quot_uns);
      else
        quot_sgn := -signed(quot_uns);
      end if;
    end if;
    return quot_sgn;
    -- pragma translate_on
  end DWF_div;
  
  function DWF_rem (A, B : unsigned) return unsigned is
    -- pragma map_to_operator REM_UNS_OP
    -- pragma type_function REM_UNSIGNED_ARG
    -- pragma return_port_name REMAINDER
    variable quot_uns : unsigned(A'length-1 downto 0);
    variable rem_uns : unsigned(B'length-1 downto 0);
  begin
    -- pragma translate_off
    if B = 0 then
      rem_uns := conv_unsigned(A, B'length);
      assert false report "WARNING: Division by zero" severity warning;
    else
      DIV_REM (A, B, quot_uns, rem_uns);
    end if;
    return rem_uns;
    -- pragma translate_on
  end DWF_rem;

  function DWF_rem (A, B : signed) return signed is
    -- pragma map_to_operator REM_TC_OP
    -- pragma type_function REM_SIGNED_ARG
    -- pragma return_port_name REMAINDER
    constant minus_one : signed(B'length-1 downto 0) := (others => '1');
    variable A_uns : unsigned(A'length-1 downto 0);
    variable B_uns : unsigned(B'length-1 downto 0);
    variable quot_uns : unsigned(A'length-1 downto 0);
    variable rem_uns : unsigned(B'length-1 downto 0);
    variable rem_sgn : signed(B'length-1 downto 0);
  begin
    -- pragma translate_off
    if B = 0 then
      rem_sgn := conv_signed(A, B'length);
      assert false report "WARNING: Division by zero" severity warning;
    else
      if A(A'left) = '0' then
        A_uns := unsigned(A);
      else
        A_uns := unsigned(signed'(-A));
      end if;
      if B(B'left) = '0' then
        B_uns := unsigned(B);
      else
        B_uns := unsigned(signed'(-B));
      end if;
      DIV_REM (A_uns, B_uns, quot_uns, rem_uns);
      if A(A'left) = '0' then
        rem_sgn := signed(rem_uns);
      else
        rem_sgn := -signed(rem_uns);
      end if;
    end if;
    return rem_sgn;
    -- pragma translate_on
  end DWF_rem;
  
  function DWF_mod (A, B : unsigned) return unsigned is
    -- pragma map_to_operator MOD_UNS_OP
    -- pragma type_function MOD_UNSIGNED_ARG
    -- pragma return_port_name REMAINDER
    variable quot_uns : unsigned(A'length-1 downto 0);
    variable rem_uns : unsigned(B'length-1 downto 0);
    variable mod_uns : unsigned(B'length-1 downto 0);
  begin
    -- pragma translate_off
    if B = 0 then
      mod_uns := conv_unsigned(A, B'length);
      assert false report "WARNING: Division by zero" severity warning;
    else
      DIV_REM (A, B, quot_uns, rem_uns);
      mod_uns := rem_uns;
    end if;
    return mod_uns;
    -- pragma translate_on
  end DWF_mod;

  function DWF_mod (A, B : signed) return signed is
    -- pragma map_to_operator MOD_TC_OP
    -- pragma type_function MOD_SIGNED_ARG
    -- pragma return_port_name REMAINDER
    constant minus_one : signed(B'length-1 downto 0) := (others => '1');
    variable A_uns : unsigned(A'length-1 downto 0);
    variable B_uns : unsigned(B'length-1 downto 0);
    variable quot_uns : unsigned(A'length-1 downto 0);
    variable rem_uns : unsigned(B'length-1 downto 0);
    variable mod_sgn : signed(B'length-1 downto 0);
  begin
    -- pragma translate_off
    if B = 0 then
      mod_sgn := conv_signed(A, B'length);
      assert false report "WARNING: Division by zero" severity warning;
    else
      if A(A'left) = '0' then
        A_uns := unsigned(A);
      else
        A_uns := unsigned(signed'(-A));
      end if;
      if B(B'left) = '0' then
        B_uns := unsigned(B);
      else
        B_uns := unsigned(signed'(-B));
      end if;
      DIV_REM (A_uns, B_uns, quot_uns, rem_uns);
      if rem_uns = 0 then
        mod_sgn := signed(rem_uns);
      else
        if A(A'left) = '0' then
          mod_sgn := signed(rem_uns);
        else
          mod_sgn := - signed(rem_uns);
        end if;
        if A(A'left) /= B(B'left) then
          mod_sgn := B + mod_sgn;
        end if;
      end if;
    end if;
    return mod_sgn;
    -- pragma translate_on
  end DWF_mod;
 

  -- Old function definitions
  
  function DWF_divide (A, B : unsigned) return unsigned is
  begin
    return conv_unsigned(DWF_div (conv_unsigned(A, maximum(A'length, B'length)), B), A'length);
  end DWF_divide;

  function DWF_divide (A, B : signed) return signed is
  begin
    return conv_signed(DWF_div (conv_signed(A, maximum(A'length, B'length)), B), A'length);
  end DWF_divide;
  
  function DW_divide (A, B : unsigned) return unsigned is
  begin
    return conv_unsigned(DWF_div (conv_unsigned(A, maximum(A'length, B'length)), B), A'length);
  end DW_divide;

  function DW_divide (A, B : signed) return signed is
  begin
    return conv_signed(DWF_div (conv_signed(A, maximum(A'length, B'length)), B), A'length);
  end DW_divide;
  
  function DW_rem (A, B : unsigned) return unsigned is
  begin
    return DWF_rem (conv_unsigned(A, maximum(A'length, B'length)), B);
  end DW_rem;

  function DW_rem (A, B : signed) return signed is
  begin
    return DWF_rem (conv_signed(A, maximum(A'length, B'length)), B);
  end DW_rem;
  
  function DW_mod (A, B : unsigned) return unsigned is
  begin
    return DWF_mod (conv_unsigned(A, maximum(A'length, B'length)), B);
  end DW_mod;

  function DW_mod (A, B : signed) return signed is
  begin
    return DWF_mod (conv_signed(A, maximum(A'length, B'length)), B);
  end DW_mod;
  
  function DWF_vhd_mod (A, B : unsigned) return unsigned is
  begin
    return DWF_mod (conv_unsigned(A, maximum(A'length, B'length)), B);
  end DWF_vhd_mod;

  function DWF_vhd_mod (A, B : signed) return signed is
  begin
    return DWF_mod (conv_signed(A, maximum(A'length, B'length)), B);
  end DWF_vhd_mod;
  
  function DW_func_vhd_mod (A, B : unsigned) return unsigned is
  begin
    return DWF_mod (conv_unsigned(A, maximum(A'length, B'length)), B);
  end DW_func_vhd_mod;

  function DW_func_vhd_mod (A, B : signed) return signed is
  begin
    return DWF_mod (conv_signed(A, maximum(A'length, B'length)), B);
  end DW_func_vhd_mod;
  
  function DWF_ver_mod (A, B : unsigned) return unsigned is
  begin
    return DWF_rem (conv_unsigned(A, maximum(A'length, B'length)), B);
  end DWF_ver_mod;

  function DWF_ver_mod (A, B : signed) return signed is
  begin
    return DWF_rem (conv_signed(A, maximum(A'length, B'length)), B);
  end DWF_ver_mod;
  
  function DW_func_ver_mod (A, B : unsigned) return unsigned is
  begin
    return DWF_rem (conv_unsigned(A, maximum(A'length, B'length)), B);
  end DW_func_ver_mod;

  function DW_func_ver_mod (A, B : signed) return signed is
  begin
    return DWF_rem (conv_signed(A, maximum(A'length, B'length)), B);
  end DW_func_ver_mod;

  -- Content from file, DW01_binenc.vhdpp

    function BINENC_TC_ARG(A: SIGNED) return SIGNED is
      variable Z: SIGNED(bit_width(A'length) downto 0);
      -- pragma return_port_name Z
    begin
      return(Z);
    end;

    function BINENC_UNS_ARG(A: UNSIGNED) 
        return UNSIGNED is
      variable Z: UNSIGNED(bit_width(A'length) downto 0);
      -- pragma return_port_name Z
    begin
      return(Z);
    end;

    function BINENC_STD_LOGIC_ARG(A: std_logic_vector)
             return  std_logic_vector is
      variable Z: std_logic_vector(bit_width(A'length) downto 0);
      -- pragma return_port_name Z
    begin
      return(Z);
    end;

    function binenc (A: std_logic_vector) return INTEGER is
      constant A_msb: integer := A'length-1;
      variable A_norm: std_logic_vector(A_msb downto 0) := A;
      variable INDEX: integer;
    begin
      for i in 0 to A_msb loop
  	if (To_X01(A_norm(i)) = '1' ) then
      return(i);
	elsif (To_X01(A_norm(i)) /= '0') then
	  return(-2);
	end if;
      end loop;
      return(-1);  -- illegal input - need at least a single '1' bit
    end binenc;

    function binenc_s(A: SIGNED) return SIGNED is
      -- pragma map_to_operator BINENC_TC_OP
      -- pragma type_function BINENC_TC_ARG
      -- pragma return_port_name Z
      constant A_width: NATURAL := A'length;
      constant Z_width: NATURAL := bit_width(A'length)+1;
      variable AV: std_logic_vector(A_width-1 downto 0);
      variable Z: SIGNED(Z_width-1 downto 0);
      variable Y: SIGNED (Z_width-1 downto 0):= (others => 'X');  
      variable addr_int: integer;  
    begin
      -- pragma translate_off
      AV := std_logic_vector(A);
      addr_int := binenc(AV);
      if (addr_int < -1) then
        Z := Y;
      else
        Z := CONV_SIGNED(addr_int, Z_width);
      end if;  
      -- pragma translate_on
      return(Z);
    end;    

    function binenc_u(A: UNSIGNED) return UNSIGNED is
      -- pragma map_to_operator BINENC_UNS_OP
      -- pragma type_function BINENC_UNS_ARG
      -- pragma return_port_name Z
      constant A_width: NATURAL := A'length;
      constant Z_width: NATURAL := bit_width(A'length)+1;
      variable AV: std_logic_vector(A_width-1 downto 0);
      variable Z: UNSIGNED(Z_width-1 downto 0);
      variable Y: UNSIGNED (Z_width-1 downto 0):= (others => 'X');  
      variable addr_int: integer;  
    begin
      -- pragma translate_off
      AV := std_logic_vector(A);
      addr_int := binenc(AV);
      if (addr_int < -1) then
        Z := Y;
      else
        Z := UNSIGNED(CONV_SIGNED(addr_int, Z_width));
      end if;  
      -- pragma translate_on
      return(Z);
    end;    

    function binenc_v(A: std_logic_vector) return std_logic_vector is
      -- pragma map_to_operator BINENC_STD_LOGIC_OP
      -- pragma type_function BINENC_STD_LOGIC_ARG
      -- pragma return_port_name Z
      constant Z_width: NATURAL := bit_width(A'length)+1;
      variable Z: std_logic_vector(Z_width-1 downto 0);
      variable Y: std_logic_vector (Z_width-1 downto 0):= (others => 'X');  
      variable addr_int: integer;  
    begin
      -- pragma translate_off
      addr_int := binenc(A);
      if (addr_int < -1) then
        Z := Y;
      else
        Z := std_logic_vector(CONV_SIGNED(addr_int, Z_width));
      end if;  
      -- pragma translate_on
      return(Z);
    end;    

    function DWF_binenc(A: SIGNED; ADDR_width: NATURAL) return SIGNED is
      constant Z_prime_width : NATURAL := bit_width(A'length)+1;
      variable Z: SIGNED(ADDR_width-1 downto 0);
      variable Z_prime: SIGNED(Z_prime_width-1 downto 0);
    begin
      Z_prime := binenc_s(A);
      if (ADDR_width > Z_prime_width ) then
        Z(Z_prime_width-1 downto 0) := Z_prime;
        Z(ADDR_width-1 downto Z_prime_width) := (others => Z_prime(Z_prime_width-1));
      else
        Z := Z_prime(ADDR_width-1 downto 0);
      end if;
      return(Z);
    end;
    
    
    function DWF_binenc(A: UNSIGNED; ADDR_width: NATURAL) 
        return UNSIGNED is
      constant Z_prime_width : NATURAL := bit_width(A'length)+1;
      variable Z: UNSIGNED(ADDR_width-1 downto 0);
      variable Z_prime: UNSIGNED(Z_prime_width-1 downto 0);
    begin
      Z_prime := binenc_u(A);
      if (ADDR_width > Z_prime_width ) then
        Z(Z_prime_width-1 downto 0) := Z_prime;
        Z(ADDR_width-1 downto Z_prime_width) := (others => Z_prime(Z_prime_width-1));
      else
        Z := Z_prime(ADDR_width-1 downto 0);
      end if;
      return(Z);
    end;
    

    function DWF_binenc(A: std_logic_vector; ADDR_width: NATURAL) 
        return std_logic_vector is
      constant Z_prime_width : NATURAL := bit_width(A'length)+1;
      variable Z: std_logic_vector(ADDR_width-1 downto 0);
      variable Z_prime: std_logic_vector(Z_prime_width-1 downto 0);
    begin
      Z_prime := binenc_v(A);
      if (ADDR_width > Z_prime_width ) then
        Z(Z_prime_width-1 downto 0) := Z_prime;
        Z(ADDR_width-1 downto Z_prime_width) := (others => Z_prime(Z_prime_width-1));
      else
        Z := Z_prime(ADDR_width-1 downto 0);
      end if;
      return(Z);
    end;
    

    function DW_binenc(A: SIGNED; ADDR_width: NATURAL) return SIGNED is
      variable Z: SIGNED(ADDR_width-1 downto 0);
    begin
      Z := DWF_binenc(A, ADDR_width);
      return(Z);
    end;

    function DW_binenc(A: UNSIGNED; ADDR_width: NATURAL)
        return UNSIGNED is
      variable Z: UNSIGNED(ADDR_width-1 downto 0);
    begin
      Z := DWF_binenc(A, ADDR_width);
      return(Z);
    end;

    function DW_binenc(A: std_logic_vector; ADDR_width: NATURAL)
        return std_logic_vector is
      variable Z: std_logic_vector(ADDR_width-1 downto 0);
    begin
      Z := DWF_binenc(A, ADDR_width);
      return(Z);
    end;

  -- Content from file, DW01_prienc.vhdpp

    function PRIENC_TC_ARG(A: SIGNED) 
             return SIGNED is
      variable Z: SIGNED(bit_width(A'length+1)-1 downto 0);
      -- pragma return_port_name Z
    begin
      return(Z);
    end;

    function PRIENC_UNS_ARG(A: UNSIGNED) 
        return UNSIGNED is
      variable Z: UNSIGNED(bit_width(A'length+1)-1 downto 0);
      -- pragma return_port_name Z
    begin
      return(Z);
    end;

    function PRIENC_STD_LOGIC_ARG(A: std_logic_vector)
             return  std_logic_vector is
      variable Z: std_logic_vector(bit_width(A'length+1)-1 downto 0);
      -- pragma return_port_name Z
    begin
      return(Z);
    end;

    function prienc (A: std_logic_vector) return INTEGER is
      constant A_msb: integer := A'length-1;
      variable A_norm: std_logic_vector(A_msb downto 0) := A;
      variable INDEX: integer;
    begin
      for i in A_msb downto 0 loop
   if (A_norm(i) = '1' ) then
	   return(i+1);
	elsif (A_norm(i) /= '0') then
      return(-(i+1));
	end if;
      end loop;
      return(0);  
    end prienc;

    function prienc_s(A: SIGNED) return SIGNED is
      -- pragma map_to_operator PRIENC_TC_OP
      -- pragma type_function PRIENC_TC_ARG
      -- pragma return_port_name Z
      constant A_width: NATURAL := A'length;
      constant Z_width: NATURAL := bit_width(A'length+1);
      variable AV: std_logic_vector(A_width-1 downto 0);
      variable Z: SIGNED(Z_width-1 downto 0);
      variable Y: SIGNED (Z_width-1 downto 0):= (others => 'X');  
      variable addr_int: integer;  
    begin
      -- pragma translate_off
      AV := std_logic_vector(A);
      addr_int := prienc(AV);
      if (addr_int < -1) then
        Z := Y;
      else
        Z := CONV_SIGNED(addr_int, Z_width);
      end if;  
      -- pragma translate_on
      return(Z);
    end;    

    function prienc_u(A: UNSIGNED) return UNSIGNED is
      -- pragma map_to_operator PRIENC_UNS_OP
      -- pragma type_function PRIENC_UNS_ARG
      -- pragma return_port_name Z
      constant A_width: NATURAL := A'length;
      constant Z_width: NATURAL := bit_width(A'length+1);
      variable AV: std_logic_vector(A_width-1 downto 0);
      variable Z: UNSIGNED(Z_width-1 downto 0);
      variable Y: UNSIGNED (Z_width-1 downto 0):= (others => 'X');  
      variable addr_int: integer;  
    begin
      -- pragma translate_off
      AV := std_logic_vector(A);
      addr_int := prienc(AV);
      if (addr_int < -1) then
        Z := Y;
      else
        Z := UNSIGNED(CONV_SIGNED(addr_int, Z_width));
      end if;  
      -- pragma translate_on
      return(Z);
    end;    

    function prienc_v(A: std_logic_vector) return std_logic_vector is
      -- pragma map_to_operator PRIENC_STD_LOGIC_OP
      -- pragma type_function PRIENC_STD_LOGIC_ARG
      -- pragma return_port_name Z
      constant Z_width: NATURAL := bit_width(A'length+1);
      variable Z: std_logic_vector(Z_width-1 downto 0);
      variable Y: std_logic_vector (Z_width-1 downto 0):= (others => 'X');  
      variable addr_int: integer;  
    begin
      -- pragma translate_off
      addr_int := prienc(A);
      if (addr_int < -1) then
        Z := Y;
      else
        Z := std_logic_vector(CONV_SIGNED(addr_int, Z_width));
      end if;  
      -- pragma translate_on
      return(Z);
    end;    

    function DWF_prienc(A: SIGNED; INDEX_width: NATURAL) return SIGNED is
      constant Z_prime_width : NATURAL := bit_width(A'length+1);
      variable Z: SIGNED(INDEX_width-1 downto 0);
      variable Z_prime: SIGNED(Z_prime_width-1 downto 0);
    begin
      Z_prime := prienc_s(A);
      if (INDEX_width > Z_prime_width ) then
        Z(Z_prime_width-1 downto 0) := Z_prime;
        Z(INDEX_width-1 downto Z_prime_width) := (others => '0');
      else
        Z := Z_prime(INDEX_width-1 downto 0);
      end if;
      return(Z);
    end;
    
    
    function DWF_prienc(A: UNSIGNED; INDEX_width: NATURAL) 
        return UNSIGNED is
      constant Z_prime_width : NATURAL := bit_width(A'length+1);
      variable Z: UNSIGNED(INDEX_width-1 downto 0);
      variable Z_prime: UNSIGNED(Z_prime_width-1 downto 0);
    begin
      Z_prime := prienc_u(A);
      if (INDEX_width > Z_prime_width ) then
        Z(Z_prime_width-1 downto 0) := Z_prime;
        Z(INDEX_width-1 downto Z_prime_width) := (others => '0');
      else
        Z := Z_prime(INDEX_width-1 downto 0);
      end if;
      return(Z);
    end;
    

    function DWF_prienc(A: std_logic_vector; INDEX_width: NATURAL) 
        return std_logic_vector is
      constant Z_prime_width : NATURAL := bit_width(A'length+1);
      variable Z: std_logic_vector(INDEX_width-1 downto 0);
      variable Z_prime: std_logic_vector(Z_prime_width-1 downto 0);
    begin
      Z_prime := prienc_v(A);
      if (INDEX_width > Z_prime_width ) then
        Z(Z_prime_width-1 downto 0) := Z_prime;
        Z(INDEX_width-1 downto Z_prime_width) := (others => '0');
      else
        Z := Z_prime(INDEX_width-1 downto 0);
      end if;
      return(Z);
    end;
    

    function DW_prienc(A: SIGNED; INDEX_width: NATURAL) return SIGNED is
      variable Z: SIGNED(INDEX_width-1 downto 0);
    begin
      Z := DWF_prienc(A, INDEX_width);
      return(Z);
    end;

    function DW_prienc(A: UNSIGNED; INDEX_width: NATURAL)
        return UNSIGNED is
      variable Z: UNSIGNED(INDEX_width-1 downto 0);
    begin
      Z := DWF_prienc(A, INDEX_width);
      return(Z);
    end;

    function DW_prienc(A: std_logic_vector; INDEX_width: NATURAL)
        return std_logic_vector is
      variable Z: std_logic_vector(INDEX_width-1 downto 0);
    begin
      Z := DWF_prienc(A, INDEX_width);
      return(Z);
    end;



  -- Content from file, DW01_decode.vhdpp

    function BINDEC_TC_ARG(A: SIGNED) return SIGNED is
      variable Z: SIGNED((2**A'length-1) downto 0);
      -- pragma return_port_name Z
    begin
      return(Z);
    end;

    function BINDEC_UNS_ARG(A: UNSIGNED) return UNSIGNED is
      variable Z: UNSIGNED((2**A'length-1) downto 0);
      -- pragma return_port_name Z
    begin
      return(Z);
    end;

    function BINDEC_STD_LOGIC_ARG(A: std_logic_vector) 
             return  std_logic_vector is
      variable Z: std_logic_vector((2**A'length-1) downto 0);
      -- pragma return_port_name Z
    begin
      return(Z);
    end;

    procedure bin_decode(A: in std_logic_vector; B: out std_logic_vector) is
      constant A_msb : NATURAL := A'length-1;
      variable A_norm : std_logic_vector(A_msb downto 0) := A;
      constant B_msb: NATURAL := 2**(A'length)-1;
      variable and_acc: std_logic;
      variable and_out: std_logic_vector(B_msb downto 0);
      type and_array is array(B_msb downto 0) of 
                        std_logic_vector(A_msb downto 0);
      variable and_in : and_array;
    begin
      for j in 0 to A_msb loop
	for k in 0 to B_msb loop
	  if (k mod 2**(j+1)) < 2**(j) then
	    and_in(k)(j) := not A_norm(j);
	  else
	    and_in(k)(j) := A_norm(j);
	  end if;
	end loop;
      end loop;
      for i in 0 to B_msb loop
	and_acc := '1';
	for j in 0 to A_msb loop
	  and_acc := and_acc and and_in(i)(j);
	end loop;
	and_out(i) := and_acc;
      end loop;
      for i in 0 to B_msb loop
	B(i) := and_out(i);
      end loop;
    end bin_decode;    

    function DWF_decode(A: SIGNED) return SIGNED is
      -- pragma map_to_operator BINDEC_TC_OP
      -- pragma type_function BINDEC_TC_ARG
      -- pragma return_port_name Z
      constant arg_width: NATURAL := A'length;
      constant output_width: NATURAL := 2**A'length;
      variable A1: std_logic_vector(arg_width-1 downto 0);
      variable B: std_logic_vector(output_width-1 downto 0);      
      variable Z: SIGNED(output_width-1 downto 0);
    begin
      A1 := std_logic_vector(A);
      bin_decode(A1,B);
      return(SIGNED(B));
    end;    
    
    function DWF_decode(A: UNSIGNED) return UNSIGNED is
      -- pragma map_to_operator BINDEC_UNS_OP
      -- pragma type_function BINDEC_UNS_ARG
      -- pragma return_port_name Z
      constant arg_width: NATURAL := A'length;
      constant output_width: NATURAL := 2**A'length;
      variable A1: std_logic_vector(arg_width-1 downto 0);      
      variable B: std_logic_vector(output_width-1 downto 0);      
      variable Z: UNSIGNED(output_width-1 downto 0);      
    begin
      A1 := std_logic_vector(A);
      bin_decode(A1,B);
      return(UNSIGNED(B));
    end;    

    function DWF_decode(A: std_logic_vector) return std_logic_vector is
      -- pragma map_to_operator BINDEC_STD_LOGIC_OP
      -- pragma type_function BINDEC_STD_LOGIC_ARG
      -- pragma return_port_name Z
      constant output_width: NATURAL := 2**A'length;
      variable B: std_logic_vector(output_width-1 downto 0);      
    begin
      bin_decode(A,B);  
      return(B);
    end;

    function DW_decode(A: SIGNED) return SIGNED is
      -- pragma map_to_operator BINDEC_TC_OP
      -- pragma type_function BINDEC_TC_ARG
      -- pragma return_port_name Z
    begin
      return(DWF_decode(A));
    end;

    function DW_decode(A: UNSIGNED) return UNSIGNED is
      -- pragma map_to_operator BINDEC_UNS_OP
      -- pragma type_function BINDEC_UNS_ARG
      -- pragma return_port_name Z
    begin
      return(DWF_decode(A));
    end;

    function DW_decode(A: std_logic_vector) return std_logic_vector is
      -- pragma map_to_operator BINDEC_STD_LOGIC_OP
      -- pragma type_function BINDEC_STD_LOGIC_ARG
      -- pragma return_port_name Z
    begin
      return(DWF_decode(A));
    end;


end package body DW_Foundation_arith;


library IEEE;
library DWARE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use DWARE.DW_Foundation_comp_arith.all;

package dw_foundation_comp is

function bit_width(X : integer)return integer;


component DW_fp_addsub 

generic (
sig_width : POSITIVE := 23;
exp_width : POSITIVE := 8;
ieee_compliance : INTEGER := 0
);

port (
a : in std_logic_vector(sig_width + exp_width downto 0);
b : in std_logic_vector(sig_width + exp_width downto 0);
rnd : in std_logic_vector(2 downto 0);
op : in std_logic;
z: out std_logic_vector(sig_width + exp_width downto 0);
status : out std_logic_vector(7 downto 0)
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fp_addsub : component is "weak";


component DW_fp_div 

generic (
sig_width : POSITIVE := 23;
exp_width : POSITIVE := 8;
ieee_compliance : INTEGER := 0;
faithful_round : INTEGER := 0
);

port (
a : in std_logic_vector(sig_width + exp_width downto 0);
b : in std_logic_vector(sig_width + exp_width downto 0);
rnd : in std_logic_vector(2 downto 0);
z: out std_logic_vector(sig_width + exp_width downto 0);
status: out std_logic_vector(7 downto 0)
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fp_div : component is "weak";

component DW_fp_flt2i 

generic (
sig_width : POSITIVE := 23;
exp_width : POSITIVE := 8;
isize : INTEGER := 32
);

port (
a : in std_logic_vector(sig_width +  exp_width downto 0);
rnd : in std_logic_vector(2 downto 0);
z: out std_logic_vector(isize-1 downto 0);
status: out std_logic_vector(7 downto 0)
);


end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fp_flt2i : component is "weak";


component DW_fp_i2flt 

generic (
sig_width : POSITIVE := 23;
exp_width : POSITIVE := 8;
isize : POSITIVE := 32;
isign : INTEGER := 1
);

port (
a : in std_logic_vector(isize-1 downto 0);
rnd : in std_logic_vector(2 downto 0);
z: out std_logic_vector(sig_width + exp_width downto 0);
status: out std_logic_vector(7 downto 0)
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fp_i2flt : component is "weak";


component DW_fp_mult

generic (
sig_width : POSITIVE := 23;
exp_width : POSITIVE := 8;
ieee_compliance : INTEGER := 0
);

port (
a : in std_logic_vector(sig_width + exp_width downto 0);
b : in std_logic_vector(sig_width + exp_width downto 0);
rnd : in std_logic_vector(2 downto 0);
z: out std_logic_vector(sig_width + exp_width downto 0);
status: out std_logic_vector(7 downto 0)
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_fp_mult : component is "weak";




component DW_lbsh

generic (
A_width : POSITIVE := 8;
SH_width : POSITIVE := 3
);

port (
A : in std_logic_vector(A_width-1 downto 0);
SH : in std_logic_vector(SH_width-1 downto 0);
SH_TC : in std_logic;
B: out std_logic_vector(A_width-1 downto 0)
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_lbsh : component is "weak";


component DW_lzd 

generic (
a_width : POSITIVE := 8
);

port (
a : in std_logic_vector(a_width-1 downto 0);
dec : out std_logic_vector(a_width-1 downto 0);
enc : out std_logic_vector(bit_width(a_width) downto 0)
);

end component ;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_lzd : component is "weak";


component DW_rash is

generic (
A_width : POSITIVE := 8;
SH_width : POSITIVE := 3
);

port (
A : in std_logic_vector(A_width-1 downto 0);
DATA_TC : in std_logic;
SH : in std_logic_vector(SH_width-1 downto 0);
SH_TC : in std_logic;
B : out std_logic_vector(A_width-1 downto 0)
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_rash : component is "weak";



component DW_rbsh is

generic (
A_width : POSITIVE := 8;
SH_width : POSITIVE := 3
);

port (
A : in std_logic_vector(A_width-1 downto 0);
SH : in std_logic_vector(SH_width-1 downto 0);
SH_TC : in std_logic;
B: out std_logic_vector(A_width-1 downto 0)
);

end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_rbsh : component is "weak";

component DW_piped_mac is

generic (
a_width : POSITIVE := 8;
b_width : POSITIVE := 8;
acc_width : POSITIVE := 16;
tc : NATURAL := 0;
pipe_reg : NATURAL := 0;
id_width : POSITIVE := 8;
no_pm : NATURAL := 0
);

port (
clk : in std_logic;
rst_n : in std_logic;
init_n : in std_logic;
clr_acc_n : in std_logic;
a : in std_logic_vector(a_width-1 downto 0);
b : in std_logic_vector(b_width-1 downto 0);
acc : out std_logic_vector(acc_width-1 downto 0);
launch : in std_logic;
launch_id : in std_logic_vector(id_width-1 downto 0);
pipe_full : out std_logic;
pipe_ovf : out std_logic;
accept_n : in std_logic;
arrive : out std_logic;
arrive_id : out std_logic_vector(id_width-1 downto 0);
push_out_n : out std_logic;
pipe_census : out std_logic_vector(2 downto 0)
);
end component;

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of DW_piped_mac : component is "weak";

-- attribute declaration for single source designware
        attribute syn_builtin_du : string;
        attribute syn_builtin_du of dw_foundation_comp : package is "weak";

end dw_foundation_comp;

package body dw_foundation_comp is

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

end dw_foundation_comp;	
