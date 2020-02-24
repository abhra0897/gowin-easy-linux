--
-- This version of the LPM_COMPONENTS package is specific to Synplify 
-- and should only be used for synthesis.
-- Copyright (c) 1998, Synplicity, Inc. All rights reserved
--
-- $Header: //synplicity/comp2019q3p1/compilers/vhdl/vhd/lpm.vhd#1 $
--

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;

package LPM_COMPONENTS is

attribute syn_black_box of LPM_COMPONENTS : package is true;

type STD_LOGIC_2D is array (NATURAL RANGE <>, NATURAL RANGE <>) of STD_LOGIC;

----------------Gates--------------------------------------------------

component LPM_CONSTANT
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_CVALUE : natural;
		LPM_STRENGTH : string := "UNUSED";
		LPM_TYPE : string := "LPM_CONSTANT";
		LPM_HINT : string := "UNUSED");
	port (
		RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_CONSTANT : component is true;

component LPM_INV
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_TYPE : string := "LPM_INV";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_INV : component is true;

component LPM_AND
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_SIZE : natural;    -- MUST be greater than 0
		LPM_TYPE : string := "LPM_AND";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_2D(LPM_SIZE-1 downto 0, LPM_WIDTH-1 downto 0); 
		RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0)); 
end component; 
attribute syn_black_box of LPM_AND : component is true;
 
component LPM_OR 
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0 
		LPM_SIZE : natural;    -- MUST be greater than 0 
		LPM_TYPE : string := "LPM_OR";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_2D(LPM_SIZE-1 downto 0, LPM_WIDTH-1 downto 0); 
		RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0)); 
end component; 
attribute syn_black_box of LPM_OR : component is true;

component LPM_XOR 
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0 
		LPM_SIZE : natural;    -- MUST be greater than 0 
		LPM_TYPE : string := "LPM_XOR";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_2D(LPM_SIZE-1 downto 0, LPM_WIDTH-1 downto 0); 
		RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0)); 
end component; 
attribute syn_black_box of LPM_XOR : component is true;
 
component LPM_BUSTRI 
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_TYPE : string := "LPM_BUSTRI";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		ENABLEDT : in std_logic := '0';
		ENABLETR : in std_logic := '0';
		RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0);
		TRIDATA : inout std_logic_vector(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_BUSTRI : component is true;
attribute black_box_tri_pins of LPM_BUSTRI : component is "TRIDATA";

component LPM_MUX 
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0 
		LPM_SIZE : natural;    -- MUST be greater than 0 
		LPM_WIDTHS : natural;    -- MUST be greater than 0 
		LPM_PIPELINE : natural := 0;
		LPM_TYPE : string := "LPM_MUX";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_2D(LPM_SIZE-1 downto 0, LPM_WIDTH-1 downto 0);
		ACLR : in std_logic := '0';
		CLOCK : in std_logic := '0';
		CLKEN : in std_logic := '1';
		SEL : in std_logic_vector(LPM_WIDTHS-1 downto 0); 
		RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_MUX : component is true;

component LPM_DECODE
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_DECODES : natural;    -- MUST be greater than 0
		LPM_PIPELINE : natural := 0;
		LPM_TYPE : string := "LPM_DECODE";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		CLOCK : in std_logic := '0';
		CLKEN : in std_logic := '1';
		ACLR : in std_logic := '0';
		ENABLE : in std_logic := '1';
		EQ : out std_logic_vector(LPM_DECODES-1 downto 0));
end component;
attribute syn_black_box of LPM_DECODE : component is true;

 -- component LPM_CLSHIFT
 -- 	generic (
 -- 		LPM_WIDTH : natural;    -- MUST be greater than 0
 -- 		LPM_WIDTHDIST : natural;    -- MUST be greater than 0
 -- 		LPM_SHIFTTYPE : string := "LOGICAL";
 -- 		LPM_TYPE : string := "LPM_CLSHIFT";
 -- 		LPM_HINT : string := "UNUSED");
 -- 	port (
 -- 		DATA : in STD_LOGIC_VECTOR(LPM_WIDTH-1 downto 0); 
 -- 		DISTANCE : in STD_LOGIC_VECTOR(LPM_WIDTHDIST-1 downto 0); 
 -- 		DIRECTION : in STD_LOGIC := '0';
 -- 		RESULT : out STD_LOGIC_VECTOR(LPM_WIDTH-1 downto 0);
 -- 		UNDERFLOW : out STD_LOGIC;
 -- 		OVERFLOW : out STD_LOGIC);
 -- end component;

component LPM_CLSHIFT 
        generic (
                lpm_pipeline    :       natural := 0;
                lpm_shifttype   :       string := "LOGICAL";
                LPM_WIDTH	:       natural;
                LPM_WIDTHDIST	:       natural;
                lpm_hint        :       string := "UNUSED";
                lpm_type        :       string := "LPM_CLSHIFT"
        );
        port(
                aclr    :       in std_logic := '0';
                clken   :       in std_logic := '1';
                clock   :       in std_logic := '0';
                data    :       in std_logic_vector(LPM_WIDTH-1 downto 0);
                direction       :       in std_logic := '0';
                distance        :       in std_logic_vector(LPM_WIDTHDIST-1 downto 0);
                overflow        :       out std_logic;
                result  :       out std_logic_vector(LPM_WIDTH-1 downto 0);
                underflow       :       out std_logic
        );
end component;


attribute syn_black_box of LPM_CLSHIFT : component is true;


----------------Arithmetic Components------------------------------------

component LPM_ADD_SUB
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_DIRECTION : string := "UNUSED";
		LPM_REPRESENTATION: string := "SIGNED";
		LPM_PIPELINE : natural := 0;
		LPM_TYPE : string := "LPM_ADD_SUB";
		LPM_HINT : string := "UNUSED");
	port (
		DATAA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		DATAB : in std_logic_vector(LPM_WIDTH-1 downto 0);
		ACLR : in std_logic := '0';
		CLOCK : in std_logic := '0';
		CLKEN : in std_logic := '1';
		CIN : in std_logic := 'Z';
		ADD_SUB : in std_logic := '1';
		RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0);
		COUT : out std_logic;
		OVERFLOW : out std_logic);
end component;
attribute syn_black_box of LPM_ADD_SUB : component is true;

component LPM_COMPARE
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_REPRESENTATION : string := "UNSIGNED";
		LPM_PIPELINE : natural := 0;
		LPM_TYPE: string := "LPM_COMPARE";
		LPM_HINT : string := "UNUSED");
	port (
		DATAA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		DATAB : in std_logic_vector(LPM_WIDTH-1 downto 0);
		ACLR : in std_logic := '0';
		CLOCK : in std_logic := '0';
		CLKEN : in std_logic := '1';
		AGB : out std_logic;
		AGEB : out std_logic;
		AEB : out std_logic;
		ANEB : out std_logic;
		ALB : out std_logic;
		ALEB : out std_logic);
end component;
attribute syn_black_box of LPM_COMPARE : component is true;

component LPM_MULT
	generic (
		LPM_WIDTHA : natural;    -- MUST be greater than 0
		LPM_WIDTHB : natural;    -- MUST be greater than 0
		LPM_WIDTHS : natural := 0;
		LPM_WIDTHP : natural;    -- MUST be greater than 0
		LPM_REPRESENTATION : string := "UNSIGNED";
		LPM_PIPELINE : natural := 0;
		LPM_TYPE : string := "LPM_MULT";
		LPM_HINT : string := "UNUSED";
		INPUT_A_IS_CONSTANT : string := "NO";
		INPUT_B_IS_CONSTANT : string := "NO";
		USE_EAB : string := "OFF";
		MAXIMIZE_SPEED : integer := 5);
	port (
		DATAA : in std_logic_vector(LPM_WIDTHA-1 downto 0);
		DATAB : in std_logic_vector(LPM_WIDTHB-1 downto 0);
		ACLR : in std_logic := '0';
		CLOCK : in std_logic := '0';
		CLKEN : in std_logic := '1';
		SUM : in std_logic_vector(LPM_WIDTHS-1 downto 0) := (OTHERS => '0');
		RESULT : out std_logic_vector(LPM_WIDTHP-1 downto 0));
end component;
attribute syn_black_box of LPM_MULT : component is true;
	
component LPM_DIVIDE
	generic (
		LPM_WIDTHN : natural;    -- MUST be greater than 0
		LPM_WIDTHD : natural;    -- MUST be greater than 0
		LPM_NREPRESENTATION : string := "UNSIGNED";
		LPM_DREPRESENTATION : string := "UNSIGNED";
		LPM_REMAINDERPOSITIVE : string := "TRUE";
		LPM_PIPELINE : natural := 0;
		LPM_TYPE : string := "LPM_DIVIDE";
		LPM_HINT : string := "UNUSED");
	port (
		NUMER : in std_logic_vector(LPM_WIDTHN-1 downto 0);
		DENOM : in std_logic_vector(LPM_WIDTHD-1 downto 0);
		ACLR : in std_logic := '0';
		CLOCK : in std_logic := '0';
		CLKEN : in std_logic := '1';
		QUOTIENT : out std_logic_vector(LPM_WIDTHN-1 downto 0);
		REMAIN : out std_logic_vector(LPM_WIDTHD-1 downto 0));
end component;
attribute syn_black_box of LPM_DIVIDE : component is true;
				
component LPM_ABS
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_TYPE: string := "LPM_ABS";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0);
		OVERFLOW : out std_logic);
end component;
attribute syn_black_box of LPM_ABS : component is true;

component LPM_COUNTER
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_MODULUS : natural := 0;
		LPM_DIRECTION : string := "UNUSED";
		LPM_AVALUE : string := "UNUSED";
		LPM_SVALUE : string := "UNUSED";
		LPM_PVALUE : string := "UNUSED";
		LPM_TYPE: string := "LPM_COUNTER";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0):= (OTHERS => '0');
		CLOCK : in std_logic ;
		CLK_EN : in std_logic := '1';
		CNT_EN : in std_logic := '1';
		UPDOWN : in std_logic := '1';
		SLOAD : in std_logic := '0';
		SSET : in std_logic := '0';
		SCLR : in std_logic := '0';
		ALOAD : in std_logic := '0';
		ASET : in std_logic := '0';
		ACLR : in std_logic := '0';
		CIN : in std_logic := '1';
		COUT : out std_logic;
		Q : out std_logic_vector(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_COUNTER : component is true;

component LPM_LATCH
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_AVALUE : string := "UNUSED";
		LPM_PVALUE : string := "UNUSED";
		LPM_TYPE: string := "LPM_LATCH";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0) := (OTHERS => '0');
		GATE : in std_logic;
		ASET : in std_logic := '0';
		ACLR : in std_logic := '0';
		Q : out std_logic_vector(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_LATCH : component is true;

component LPM_FF
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_AVALUE : string := "UNUSED";
		LPM_SVALUE : string := "UNUSED";
		LPM_PVALUE : string := "UNUSED";
		LPM_FFTYPE: string := "DFF";
		LPM_TYPE: string := "LPM_FF";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		CLOCK : in std_logic;
		ENABLE : in std_logic := '1';
		SLOAD : in std_logic := '0';
		SCLR : in std_logic := '0';
		SSET : in std_logic := '0';
		ALOAD : in std_logic := '0';
		ACLR : in std_logic := '0';
		ASET : in std_logic := '0';
		Q : out std_logic_vector(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_FF : component is true;

component LPM_SHIFTREG
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_AVALUE : string := "UNUSED";
		LPM_SVALUE : string := "UNUSED";
		LPM_PVALUE : string := "UNUSED";
		LPM_DIRECTION: string := "UNUSED";
		LPM_TYPE: string := "LPM_SHIFTREG";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0) := (OTHERS => '0');
		CLOCK : in std_logic;
		ENABLE : in std_logic := '1';
		SHIFTIN : in std_logic := '1';
		LOAD : in std_logic := '0';
		SCLR : in std_logic := '0';
		SSET : in std_logic := '0';
		ACLR : in std_logic := '0';
		ASET : in std_logic := '0';
		Q : out std_logic_vector(LPM_WIDTH-1 downto 0);
		SHIFTOUT : out std_logic);
end component;
attribute syn_black_box of LPM_SHIFTREG : component is true;

component LPM_RAM_DQ
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_WIDTHAD : natural;    -- MUST be greater than 0
		LPM_NUMWORDS : natural := 999999;
		LPM_INDATA : string := "REGISTERED";
		LPM_ADDRESS_CONTROL: string := "REGISTERED";
		LPM_OUTDATA : string := "REGISTERED";
		LPM_FILE : string := "UNUSED";
		LPM_TYPE : string := "LPM_RAM_DQ";
		LPM_HINT : string := "UNUSED");
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		ADDRESS : in std_logic_vector(LPM_WIDTHAD-1 downto 0);
		INCLOCK : in std_logic := '0';
		OUTCLOCK : in std_logic := '0';
		WE : in std_logic;
		Q : out std_logic_vector(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_RAM_DQ : component is true;

component LPM_RAM_DP
	generic (
		LPM_WIDTH : natural := 2;    -- MUST be greater than 0
		LPM_WIDTHAD : natural := 2;    -- MUST be greater than 0
		LPM_NUMWORDS : natural := 999999;
		LPM_INDATA : string := "REGISTERED";
		LPM_OUTDATA : string := "REGISTERED";
		LPM_RDADDRESS_CONTROL : string := "REGISTERED";
		LPM_WRADDRESS_CONTROL : string := "REGISTERED";
		LPM_FILE : string := "UNUSED";
		LPM_TYPE : string := "LPM_RAM_DP";
		LPM_HINT : string := "UNUSED");
	port (
		RDCLOCK : in std_logic := '0';
		RDCLKEN : in std_logic := '1';
		RDADDRESS : in std_logic_vector(LPM_WIDTHad-1 downto 0);
		RDEN : in std_logic := '1';
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		WRADDRESS : in std_logic_vector(LPM_WIDTHad-1 downto 0);
		WREN : in std_logic;
		WRCLOCK : in std_logic := '0';
		WRCLKEN : in std_logic := '1';
		Q : out std_logic_vector(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_RAM_DP : component is true;

component LPM_RAM_IO
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_WIDTHAD : natural;    -- MUST be greater than 0
		LPM_NUMWORDS : natural := 999999;
		LPM_INDATA : string := "REGISTERED";
		LPM_ADDRESS_CONTROL : string := "REGISTERED";
		LPM_OUTDATA : string := "REGISTERED";
		LPM_FILE : string := "UNUSED";
		LPM_TYPE : string := "LPM_RAM_IO";
		LPM_HINT : string := "UNUSED");
	port (
		ADDRESS : in STD_LOGIC_VECTOR(LPM_WIDTHAD-1 downto 0);
		INCLOCK : in STD_LOGIC := '0';
		OUTCLOCK : in STD_LOGIC := '0';
		MEMENAB : in STD_LOGIC := '1';
		OUTENAB : in STD_LOGIC := 'Z';
		WE : in STD_LOGIC := 'Z';
		DIO : inout STD_LOGIC_VECTOR(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_RAM_IO : component is true;
attribute black_box_tri_pins of LPM_RAM_IO : component is "DIO";

component LPM_ROM
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_WIDTHAD : natural;    -- MUST be greater than 0
		LPM_NUMWORDS : natural := 999999;
		LPM_ADDRESS_CONTROL : string := "REGISTERED";
		LPM_OUTDATA : string := "REGISTERED";
		LPM_FILE : string;
		LPM_TYPE : string := "LPM_ROM";
		LPM_HINT : string := "UNUSED");
	port (
		ADDRESS : in STD_LOGIC_VECTOR(LPM_WIDTHAD-1 downto 0);
		INCLOCK : in STD_LOGIC := '0';
		OUTCLOCK : in STD_LOGIC := '0';
		MEMENAB : in STD_LOGIC := '1';
		Q : out STD_LOGIC_VECTOR(LPM_WIDTH-1 downto 0));
end component;
attribute syn_black_box of LPM_ROM : component is true;

component LPM_FIFO
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_WIDTHU : natural := 1;    -- MUST be greater than 0
		LPM_NUMWORDS : natural;    -- MUST be greater than 0
		LPM_SHOWAHEAD : string := "OFF";
		LPM_TYPE : string := "LPM_FIFO";
		LPM_HINT : string := "UNUSED";
		OVERFLOW_CHECKING: string := "ON";
		UNDERFLOW_CHECKING: string := "ON";
		ALLOW_RWCYCLE_WHEN_FULL : string := "OFF");
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		CLOCK : in std_logic;
		WRREQ : in std_logic;
		RDREQ : in std_logic;
		ACLR : in std_logic := '0';
		SCLR : in std_logic := '0';
		Q : out std_logic_vector(LPM_WIDTH-1 downto 0);
		USEDW : out std_logic_vector(LPM_WIDTHU-1 downto 0);
		FULL : out std_logic;
		EMPTY : out std_logic);
end component;
attribute syn_black_box of LPM_FIFO : component is true;

component LPM_FIFO_DC
	generic (
		LPM_WIDTH : natural;    -- MUST be greater than 0
		LPM_WIDTHU : natural := 1;    -- MUST be greater than 0
		LPM_NUMWORDS : natural;    -- MUST be greater than 0
		LPM_SHOWAHEAD : string := "OFF";
		LPM_TYPE : string := "LPM_FIFO_DC";
		LPM_HINT : string := "UNUSED";
		OVERFLOW_CHECKING: STRING := "ON";
		UNDERFLOW_CHECKING: STRING := "ON";
		DELAY_RDUSEDW :POSITIVE := 1;
		DELAY_WRUSEDW : POSITIVE := 1;
		RDSYNC_DELAYPIPE : POSITIVE := 3;
		WRSYNC_DELAYPIPE : POSITIVE := 3);
	port (
		DATA : in std_logic_vector(LPM_WIDTH-1 downto 0);
		WRCLOCK : in std_logic;
		RDCLOCK : in std_logic;
		WRREQ : in std_logic;
		RDREQ : in std_logic;
		ACLR : in std_logic := '0';
		Q : out std_logic_vector(LPM_WIDTH-1 downto 0);
		WRUSEDW : out std_logic_vector(LPM_WIDTHU-1 downto 0);
		RDUSEDW : out std_logic_vector(LPM_WIDTHU-1 downto 0);
		WRFULL : out std_logic;
		RDFULL : out std_logic;
		WREMPTY : out std_logic;
		RDEMPTY : out std_logic);
end component;
attribute syn_black_box of LPM_FIFO_DC : component is true;

end package LPM_COMPONENTS;
