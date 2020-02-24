
--
--  Copyright (c) 2000 Synplicity, Inc.
--  All rights reserved.
--
-- $Header: //synplicity/comp2019q3p1/compilers/vhdl/vhd/cp_lpmpkg.vhd#1 $
--

--     cp_lpmpkg.vhd							      --
--									      --
--      Copyright Cypress Semiconductor Corporation, 2000
--        as an unpublished work.					      --
--									      --
--------------------------------------------------------------------------------
--			LPM Component Declarations			      --
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package lpmpkg is

--
--	LPM types
--

    type Shift_Type	is (LPM_LOGICAL, LPM_ROTATE, LPM_ARITHMETIC);
    type Repre_Type	is (LPM_SIGNED, LPM_UNSIGNED, LPM_GRAY);
    type Truth_Type	is (LPM_F, LPM_FD, LPM_FR, LPM_FDR);
    type CtDir_Type	is (LPM_NO_DIR, LPM_UP, LPM_DOWN);
    type Arith_Type	is (LPM_NO_TYP, LPM_ADD, LPM_SUB);
    type Fflop_Type	is (LPM_DFF,LPM_TFF);
    type ShDir_Type	is (LPM_LEFT,LPM_RIGHT);
    type Regis_Type	is (LPM_REGISTERED,LPM_UNREGISTERED);
    type Stgth_Type	is (LPM_NO_STRENGTH,LPM_WEAK);
    type goal_type	is (SPEED,AREA,COMBINATORIAL,MEMORY);

--
--	LPM Components
--

    component mbuf
	generic(lpm_width	: positive;
			lpm_type	: string := "mbuf";
		lpm_hint	: goal_type  := SPEED);
	port   (data		: in  std_logic_vector(lpm_width-1 downto 0);
		result		: out std_logic_vector(lpm_width-1 downto 0));
    end component;

    component madd_sub
	generic(lpm_width	: positive;
		lpm_representation : repre_type := LPM_UNSIGNED;
		lpm_direction	: arith_type := LPM_NO_TYP;
		lpm_type	: string := "madd_sub";
		lpm_hint	: goal_type  := SPEED);
	port   (dataa		: in  std_logic_vector(lpm_width-1 downto 0);
		datab		: in  std_logic_vector(lpm_width-1 downto 0);
		cin		: in  std_logic := '0';
		add_sub		: in  std_logic := '1';
		result		: out std_logic_vector(lpm_width-1 downto 0);
		cout		: out std_logic;
		overflow	: out std_logic);
    end component;

    component mcompare
	generic(lpm_width	: positive;
		lpm_representation : repre_type := LPM_UNSIGNED;
		lpm_type	: string := "mcompare";
		lpm_hint	: goal_type  := SPEED);
	port  ( dataa		: in  std_logic_vector(lpm_width-1 downto 0);
		datab		: in  std_logic_vector(lpm_width-1 downto 0);
		alb		: out std_logic;
		aeb		: out std_logic;
		agb		: out std_logic;
		ageb		: out std_logic;
		aleb		: out std_logic;
		aneb		: out std_logic);
    end component;

    component mmult
	generic(lpm_widtha	: positive;
		lpm_widthb	: positive;
		lpm_widths	: natural := 0;
		lpm_widthp	: positive ;
		lpm_representation : repre_type := LPM_UNSIGNED;
		lpm_hint	: goal_type := SPEED;
		lpm_type	: string := "mmult";
		lpm_avalue	: std_logic_vector := "");
	port   (dataa		: in  std_logic_vector(lpm_widtha-1 downto 0);
		datab		: in  std_logic_vector(lpm_widthb-1 downto 0);
		sum		: in  std_logic_vector(lpm_widths-1 downto 0);
		result		: out std_logic_vector(lpm_widthp-1 downto 0));
    end component;

    component mcounter
	generic(lpm_width	: positive;
		lpm_direction	: ctdir_type := LPM_NO_DIR;
		lpm_avalue	: std_logic_vector := "";
		lpm_svalue	: std_logic_vector := "";
		lpm_pvalue	: std_logic_vector := "";
		lpm_hint	: goal_type := SPEED;
		lpm_type	: string := "mcounter";
		lpm_modulus	: positive := 1);
	port   (data		: in  std_logic_vector(lpm_width-1 downto 0);
		clock		: in  std_logic;
		clk_en		: in  std_logic := '1';
		cnt_en		: in  std_logic := '1';
		updown		: in  std_logic := '1';
		q		: out std_logic_vector(lpm_width-1 downto 0);
		aset		: in  std_logic := '0';
		aclr		: in  std_logic := '0';
		aload		: in  std_logic := '0';
		sset		: in  std_logic := '0';
		sclr		: in  std_logic := '0';
		sload		: in  std_logic := '0';
		testenab	: in  std_logic := '0';
		testin		: in  std_logic := '0';
		testout		: out std_logic);
    end component;

    component mclshift
	generic(lpm_width	: positive;
		lpm_widthdist	: positive;
		lpm_shifttype	: shift_type := LPM_LOGICAL;
		lpm_type	: string := "mclshift";
		lpm_hint	: goal_type := SPEED);
	port   (data		: in  std_logic_vector(lpm_width-1 downto 0);
		distance	: in  std_logic_vector(lpm_widthdist-1 downto 0);
		direction 	: in  std_logic := '0';
		result		: out std_logic_vector(lpm_width-1 downto 0);
		overflow	: out std_logic;
		underflow	: out std_logic);
    end component;

    component mram_dq
	generic(lpm_width	: positive;
		lpm_widthad	: positive;
		lpm_numwords	: natural := 0;
		lpm_indata	: regis_type := LPM_REGISTERED;
		lpm_address_control : regis_type := LPM_REGISTERED;
		lpm_outdata	: regis_type := LPM_REGISTERED;
		lpm_file	: string := "";
		lpm_type	: string := "mram_dq";
		lpm_hint	: goal_type := SPEED);
	port   (data		: in  std_logic_vector(lpm_width-1   downto 0);
		address		: in  std_logic_vector(lpm_widthad-1 downto 0);
		q		: out std_logic_vector(lpm_width-1   downto 0);
		inclock		: in  std_logic := '0';
		outclock	: in  std_logic := '0';
		we		: in  std_logic;
		outreg_ar	: in  std_logic := '0');
    end component;

    component cy_ram_dp
	generic(lpm_width	: positive;
		lpm_widthad	: positive;
		lpm_numwords	: natural := 0;
		lpm_indata	: regis_type := LPM_REGISTERED;
		lpm_address_control : regis_type := LPM_REGISTERED;
		lpm_outdata_a	: regis_type := LPM_REGISTERED;
		lpm_outdata_b	: regis_type := LPM_REGISTERED;
		lpm_file	: string := "";
		lpm_type	: string := "cy_ram_dp";
		lpm_hint	: goal_type := SPEED);
	port   (data_a		: in  std_logic_vector(lpm_width-1   downto 0);
		data_b		: in  std_logic_vector(lpm_width-1   downto 0);
		address_a	: in  std_logic_vector(lpm_widthad-1 downto 0);
		address_b	: in  std_logic_vector(lpm_widthad-1 downto 0);
		q_a		: out std_logic_vector(lpm_width-1   downto 0);
		q_b		: out std_logic_vector(lpm_width-1   downto 0);
		addr_matchb	: out std_logic;
		wea		: in  std_logic;
		web		: in  std_logic;
		inclock_a	: in  std_logic := '0';
		inclock_b	: in  std_logic := '0';
		outclock_a	: in  std_logic := '0';
		outclock_b	: in  std_logic := '0';
		outrega_ar	: in  std_logic := '0';
		outregb_ar	: in  std_logic := '0');
    end component;
    
    component mrom
	generic(lpm_width	:positive;
		lpm_widthad	:positive;
		lpm_numwords	:natural := 0;
		lpm_address_control :regis_type := LPM_UNREGISTERED;
		lpm_file	:string := "init";
		lpm_type	: string := "mrom";
		lpm_outdata	:regis_type := LPM_UNREGISTERED);
	port (address	: in  std_logic_vector(lpm_widthad-1 downto 0);
	      q		: out std_logic_vector(lpm_width-1   downto 0);
	      memenab 	: in  std_logic := '1');
    end component;


end lpmpkg;

--
--	LPM Entity/Architecture pairs
--

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library cypress;
use cypress.lpmpkg.all;

entity mbuf is
    generic(lpm_width	: positive;
			lpm_type 	: string := "mbuf";
	    lpm_hint	: goal_type  := SPEED);
    port   (data	: in	std_logic_vector(lpm_width-1 downto 0);
	    result	: out	std_logic_vector(lpm_width-1 downto 0));
end mbuf;

architecture bb of mbuf is
    attribute syn_black_box			: boolean;
    attribute \lpm_width\		: positive;
    attribute \lpm_hint\		: goal_type;
	attribute \lpm_type\		: string;
    attribute syn_black_box of bb		: architecture is true;
    attribute \lpm_width\ of bb		: architecture is lpm_width;
    attribute \lpm_hint\ of bb		: architecture is lpm_hint;
	attribute \lpm_type\ of bb		: architecture is lpm_type;
begin
end bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library cypress;
use cypress.lpmpkg.all;

entity madd_sub is
    generic(lpm_width	: positive;
	    lpm_representation : repre_type := LPM_UNSIGNED;
	    lpm_direction : arith_type := LPM_NO_TYP;
		lpm_type 	: string := "madd_sub";
	    lpm_hint	: goal_type  := SPEED);
    port   (dataa	: in	std_logic_vector(lpm_width-1 downto 0);
	    datab	: in	std_logic_vector(lpm_width-1 downto 0);
	    cin		: in	std_logic := '0';
	    add_sub	: in	std_logic := '1';
	    result	: out	std_logic_vector(lpm_width-1 downto 0);
	    cout	: out	std_logic;
	    overflow	: out   std_logic);
end madd_sub;

architecture bb of madd_sub is
    attribute syn_black_box			: boolean;
    attribute \lpm_width\		: positive;
    attribute \lpm_representation\	: repre_type;
    attribute \lpm_direction\		: arith_type;
    attribute \lpm_hint\		: goal_type;
	attribute \lpm_type\		: string;
    attribute syn_black_box of bb		: architecture is true;
    attribute \lpm_width\ of bb		: architecture is lpm_width;
    attribute \lpm_representation\ of bb: architecture is lpm_representation;
    attribute \lpm_direction\ of bb	: architecture is lpm_direction;
    attribute \lpm_hint\ of bb		: architecture is lpm_hint;
	attribute \lpm_type\ of bb		: architecture is lpm_type;
begin
end bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library cypress;
use cypress.lpmpkg.all;

entity mcompare is
    generic(lpm_width	: positive;
	    lpm_representation : repre_type := LPM_UNSIGNED;
		lpm_type 	: string := "mcompare";
	    lpm_hint	: goal_type  := SPEED);
    port  ( dataa	: in	std_logic_vector(lpm_width-1 downto 0);
	    datab	: in	std_logic_vector(lpm_width-1 downto 0);
	    alb		: out	std_logic;
	    aeb		: out	std_logic;
	    agb		: out	std_logic;
	    ageb	: out   std_logic;
	    aleb	: out   std_logic;
	    aneb	: out   std_logic);
end mcompare;

architecture bb of mcompare is
    attribute syn_black_box			: boolean;
    attribute \lpm_width\		: positive;
    attribute \lpm_representation\	: repre_type;
    attribute \lpm_hint\		: goal_type;
	attribute \lpm_type\		: string;
    attribute syn_black_box of bb		: architecture is true;
    attribute \lpm_width\ of bb		: architecture is lpm_width;
    attribute \lpm_representation\ of bb: architecture is lpm_representation;
    attribute \lpm_hint\ of bb		: architecture is lpm_hint;
	attribute \lpm_type\ of bb		: architecture is lpm_type;
begin
end bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library cypress;
use cypress.lpmpkg.all;

entity mmult is
    generic(lpm_widtha	: positive;
	    lpm_widthb	: positive;
	    lpm_widths	: natural := 0;
	    lpm_widthp	: positive ;
	    lpm_representation : repre_type := LPM_UNSIGNED;
	    lpm_hint	: goal_type := SPEED;
		lpm_type 	: string := "mmult";
	    lpm_avalue	: std_logic_vector := "");
    port   (dataa	: in	std_logic_vector(lpm_widtha-1 downto 0);
	    datab	: in	std_logic_vector(lpm_widthb-1 downto 0);
	    result	: out	std_logic_vector(lpm_widthp-1 downto 0));
end mmult;

architecture bb of mmult is
    attribute syn_black_box			: boolean;
    attribute \lpm_widtha\		: positive;
    attribute \lpm_widthb\		: positive;
    attribute \lpm_widths\		: natural;
    attribute \lpm_widthp\		: positive;
    attribute \lpm_representation\	: repre_type;
    attribute \lpm_hint\		: goal_type;
    attribute \lpm_avalue\		: std_logic_vector;
	attribute \lpm_type\		: string;
    attribute syn_black_box of bb		: architecture is true;
    attribute \lpm_widtha\ of bb	: architecture is lpm_widtha;
    attribute \lpm_widthb\ of bb	: architecture is lpm_widthb;
    attribute \lpm_widths\ of bb	: architecture is lpm_widths;
    attribute \lpm_widthp\ of bb	: architecture is lpm_widthp;
    attribute \lpm_representation\ of bb: architecture is lpm_representation;
    attribute \lpm_hint\ of bb		: architecture is lpm_hint;
    attribute \lpm_avalue\ of bb	: architecture is lpm_avalue;
	attribute \lpm_type\ of bb		: architecture is lpm_type;
begin
end bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library cypress;
use cypress.lpmpkg.all;

entity mcounter is
    generic(lpm_width	: positive :=1;
	    lpm_direction : ctdir_type := LPM_NO_DIR;
	    lpm_avalue	: std_logic_vector := "";
	    lpm_svalue	: std_logic_vector := "";
	    lpm_pvalue	: std_logic_vector := "";
	    lpm_hint	: goal_type := SPEED;
		lpm_type 	: string := "mcounter";
	    lpm_modulus	: positive := 1);
    port   (data	: in	std_logic_vector(lpm_width-1 downto 0);
	    clock	: in	std_logic;
	    clk_en	: in	std_logic := '1';
	    cnt_en	: in	std_logic := '1';
	    updown	: in	std_logic := '1';
	    q		: out	std_logic_vector(lpm_width-1 downto 0);
	    aset	: in	std_logic := '0';
	    aclr	: in	std_logic := '0';
	    aload	: in	std_logic := '0';
	    sset	: in	std_logic := '0';
	    sclr	: in	std_logic := '0';
	    sload	: in	std_logic := '0';
	    testenab	: in	std_logic := '0';
	    testin	: in	std_logic := '0';
	    testout	: out	std_logic);
end mcounter;

architecture bb of mcounter is
    attribute syn_black_box			: boolean;
    attribute \lpm_width\		: positive;
    attribute \lpm_direction\		: ctdir_type;
    attribute \lpm_avalue\		: std_logic_vector;
    attribute \lpm_svalue\		: std_logic_vector;
    attribute \lpm_pvalue\		: std_logic_vector;
    attribute \lpm_hint\		: goal_type;
    attribute \lpm_modulus\		: positive;
	attribute \lpm_type\		: string;
    attribute syn_black_box of bb		: architecture is true;
    attribute \lpm_width\ of bb		: architecture is lpm_width;
    attribute \lpm_direction\ of bb	: architecture is lpm_direction;
    attribute \lpm_avalue\ of bb	: architecture is lpm_avalue;
    attribute \lpm_svalue\ of bb	: architecture is lpm_svalue;
    attribute \lpm_pvalue\ of bb	: architecture is lpm_pvalue;
    attribute \lpm_hint\ of bb		: architecture is lpm_hint;
    attribute \lpm_modulus\ of bb	: architecture is lpm_modulus;
	attribute \lpm_type\ of bb		: architecture is lpm_type;
begin
end bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library cypress;
use cypress.lpmpkg.all;

entity mclshift is
    generic(lpm_width	: positive := 1;
	    lpm_widthdist : positive := 1;
	    lpm_shifttype : shift_type := LPM_LOGICAL;
		lpm_type 	: string := "mclshift";
	    lpm_hint	: goal_type := SPEED);
    port   (data	: in	std_logic_vector(lpm_width-1 downto 0);
	    distance	: in	std_logic_vector(lpm_widthdist-1 downto 0);
	    direction 	: in	std_logic := '0';
	    result	: out	std_logic_vector(lpm_width-1 downto 0);
	    overflow	: out	std_logic;
	    underflow	: out	std_logic);
end mclshift;

architecture bb of mclshift is
    attribute syn_black_box			: boolean;
    attribute \lpm_width\		: positive;
    attribute \lpm_widthdist\		: positive;
    attribute \lpm_shifttype\		: shift_type;
    attribute \lpm_hint\		: goal_type;
	attribute \lpm_type\		: string;
    attribute syn_black_box of bb		: architecture is true;
    attribute \lpm_width\ of bb		: architecture is lpm_width;
    attribute \lpm_widthdist\ of bb	: architecture is lpm_widthdist;
    attribute \lpm_shifttype\ of bb	: architecture is lpm_shifttype;
    attribute \lpm_hint\ of bb		: architecture is lpm_hint;
	attribute \lpm_type\ of bb		: architecture is lpm_type;
begin
end bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library cypress;
use cypress.lpmpkg.all;

entity mram_dq is
    generic(lpm_width	: positive := 1;
	    lpm_widthad	: positive := 1;
	    lpm_numwords: natural := 0;
	    lpm_indata	: regis_type := LPM_REGISTERED;
	    lpm_address_control : regis_type := LPM_REGISTERED;
	    lpm_outdata : regis_type := LPM_REGISTERED;
	    lpm_file	: string := "";
		lpm_type 	: string := "mram_dq";
	    lpm_hint	: goal_type := SPEED);
    port   (data	: in  std_logic_vector(lpm_width-1 downto 0);
	    address	: in  std_logic_vector(lpm_widthad-1 downto 0);
	    q		: out std_logic_vector(lpm_width-1 downto 0);
	    inclock	: in  std_logic := '0';
	    outclock	: in  std_logic := '0';
	    we		: in  std_logic;
	    outreg_ar	: in  std_logic := '0');
end mram_dq;

architecture bb of mram_dq is
    attribute syn_black_box			: boolean;
    attribute \lpm_width\		: positive;
    attribute \lpm_widthad\		: positive;
    attribute \lpm_numwords\		: natural;
    attribute \lpm_indata\		: regis_type;
    attribute \lpm_address_control\	: regis_type;
    attribute \lpm_outdata\		: regis_type;
    attribute \lpm_file\		: string;
    attribute \lpm_hint\		: goal_type;
	attribute \lpm_type\		: string;
    attribute syn_black_box of bb		: architecture is true;
    attribute \lpm_width\ of bb		: architecture is lpm_width;
    attribute \lpm_widthad\ of bb	: architecture is lpm_widthad;
    attribute \lpm_numwords\ of bb	: architecture is lpm_numwords;
    attribute \lpm_indata\ of bb	: architecture is lpm_indata;
    attribute \lpm_address_control\ of bb:architecture is lpm_address_control;
    attribute \lpm_outdata\ of bb	: architecture is lpm_outdata;
    attribute \lpm_file\ of bb		: architecture is lpm_file;
    attribute \lpm_hint\ of bb		: architecture is lpm_hint;
	attribute \lpm_type\ of bb		: architecture is lpm_type;
begin
end bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library cypress;
use cypress.lpmpkg.all;

entity cy_ram_dp is
    generic(lpm_width	: positive := 1;
	    lpm_widthad	: positive := 1;
	    lpm_numwords: natural := 0;
	    lpm_indata	: regis_type := LPM_REGISTERED;
	    lpm_address_control : regis_type := LPM_REGISTERED;
	    lpm_outdata_a : regis_type := LPM_REGISTERED;
	    lpm_outdata_b : regis_type := LPM_REGISTERED;
	    lpm_file	: string := "";
		lpm_type 	: string := "cy_ram_dp";
	    lpm_hint	: goal_type := SPEED);
    port   (data_a	: in  std_logic_vector(lpm_width-1 downto 0);
	    data_b	: in  std_logic_vector(lpm_width-1 downto 0);
	    address_a	: in  std_logic_vector(lpm_widthad-1 downto 0);
	    address_b	: in  std_logic_vector(lpm_widthad-1 downto 0);
	    q_a		: out std_logic_vector(lpm_width-1 downto 0);
	    q_b		: out std_logic_vector(lpm_width-1 downto 0);
	    addr_matchb	: out std_logic;
	    wea		: in  std_logic;
	    web		: in  std_logic;
	    inclock_a	: in  std_logic := '0';
	    inclock_b	: in  std_logic := '0';
	    outclock_a	: in  std_logic := '0';
	    outclock_b	: in  std_logic := '0';
	    outrega_ar	: in  std_logic := '0';
	    outregb_ar	: in  std_logic := '0');
end cy_ram_dp;

architecture bb of cy_ram_dp is
    attribute syn_black_box			: boolean;
    attribute \lpm_width\		: positive;
    attribute \lpm_widthad\		: positive;
    attribute \lpm_numwords\		: natural;
    attribute \lpm_indata\		: regis_type;
    attribute \lpm_address_control\	: regis_type;
    attribute \lpm_outdata_a\		: regis_type;
    attribute \lpm_outdata_b\		: regis_type;
    attribute \lpm_file\		: string;
    attribute \lpm_hint\		: goal_type;
	attribute \lpm_type\		: string;
    attribute syn_black_box of bb		: architecture is true;
    attribute \lpm_width\ of bb		: architecture is lpm_width;
    attribute \lpm_widthad\ of bb	: architecture is lpm_widthad;
    attribute \lpm_numwords\ of bb	: architecture is lpm_numwords;
    attribute \lpm_indata\ of bb	: architecture is lpm_indata;
    attribute \lpm_address_control\ of bb:architecture is lpm_address_control;
    attribute \lpm_outdata_a\ of bb	: architecture is lpm_outdata_a;
    attribute \lpm_outdata_b\ of bb	: architecture is lpm_outdata_b;
    attribute \lpm_file\ of bb		: architecture is lpm_file;
    attribute \lpm_hint\ of bb		: architecture is lpm_hint;
	attribute \lpm_type\ of bb		: architecture is lpm_type;
begin
end bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library cypress;
use cypress.lpmpkg.all;

entity mrom is
   	generic(lpm_width	:positive;
		lpm_widthad	:positive;
		lpm_numwords	:natural := 0;
		lpm_address_control :regis_type := LPM_UNREGISTERED;
		lpm_file	:string := "init";
		lpm_type 	: string := "mrom";
		lpm_outdata	:regis_type := LPM_UNREGISTERED);
	port (address	: in  std_logic_vector(lpm_widthad-1 downto 0);
	      q		: out std_logic_vector(lpm_width-1   downto 0);
	      memenab 	: in  std_logic := '1');
end mrom;

architecture bb of mrom is
    attribute syn_black_box			: boolean;
    attribute \lpm_width\		: positive;
    attribute \lpm_widthad\		: positive;
    attribute \lpm_numwords\		: natural;
    attribute \lpm_address_control\	: regis_type;
    attribute \lpm_file\		: string;
    attribute \lpm_outdata\		: regis_type;
	attribute \lpm_type\		: string;
    attribute syn_black_box of bb		: architecture is true;
    attribute \lpm_width\ of bb		: architecture is lpm_width;
    attribute \lpm_widthad\ of bb	: architecture is lpm_widthad;
    attribute \lpm_numwords\ of bb	: architecture is lpm_numwords;
    attribute \lpm_address_control\ of bb:architecture is lpm_address_control;
    attribute \lpm_file\ of bb		: architecture is lpm_file;
    attribute \lpm_outdata\ of bb	: architecture is lpm_outdata;
	attribute \lpm_type\ of bb		: architecture is lpm_type;
begin
end bb;

