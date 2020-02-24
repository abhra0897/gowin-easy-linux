-------------------------------------------------------------------------------
-- Copyright (C) 2001-2013 Synopsys, Inc.
-- This IP and the associated doutcumentation are confidential and
-- proprietary to Synopsys, Inc. Your use or disclosure of this IP is 
-- subject to the terms and conditions of a written license agreement 
-- between you, or your company, and Synopsys, Inc.
-------------------------------------------------------------------------------
-- Title      : CAPIM for UmrBus
-- Project    : UMRBus
-------------------------------------------------------------------------------
-- Description: CAPIM with umrbus_valid signal (see new specification)
-------------------------------------------------------------------------------
-- File       : capim.vhd
-- Author     : Rene Richter
-- Created    : 02/27/2001
-- Version    : 2.9
-------------------------------------------------------------------------------
--         $Id: //chipit/chipit/main/dev/umrbus/hw/capim/version.2/src/capim.vhd#9 $ $Author: slasch $ $DateTime: 2011/09/19 01:41:20 $
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY capim IS

    GENERIC (
      UMR_CAPIM_ADDRESS :     INTEGER RANGE 1 TO 63; 
      UMR_CAPIM_TYPE    :     INTEGER RANGE 1 TO 65535; -- User Valid 32768 to 65535; range 1 to 32767 reserved 
      UMR_DATA_BITWIDTH :     INTEGER RANGE 1 TO 32 := 8; -- 8 for HAPS-60; 32 for HAPS-50
      UMR_CAPIM_COMMENT_STRING : string := "NA" --Allow user to specify the use of capim 
	);

    PORT (
      clk               : IN  STD_LOGIC;
      reset             : IN  STD_LOGIC;
      umr_in_dat        : IN  STD_LOGIC_VECTOR(UMR_DATA_BITWIDTH-1 DOWNTO 0);
      umr_in_en         : IN  STD_LOGIC;
      umr_in_valid      : IN  STD_LOGIC;
      umr_out_dat       : OUT STD_LOGIC_VECTOR(UMR_DATA_BITWIDTH-1 DOWNTO 0);
      umr_out_en        : OUT STD_LOGIC;
      umr_out_valid     : OUT STD_LOGIC;
      wr                : OUT STD_LOGIC;
      dout              : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rd                : OUT STD_LOGIC;
      din               : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      intr              : IN  STD_LOGIC;
      inta              : OUT STD_LOGIC;
      inttype           : IN  STD_LOGIC_VECTOR(15 DOWNTO 0));

END capim;

ARCHITECTURE A_capim OF capim IS

  SIGNAL inreg_data   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL inreg_en     : STD_LOGIC_VECTOR((32/UMR_DATA_BITWIDTH-1) DOWNTO 0);
  SIGNAL inreg_valid  : STD_LOGIC_VECTOR((32/UMR_DATA_BITWIDTH-1) DOWNTO 0);
  SIGNAL valid        : STD_LOGIC;
  SIGNAL outreg_data  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL outreg_din   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL scan_data    : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL int_data     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL add_data     : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL outreg_en    : STD_LOGIC;
  SIGNAL outreg_valid : STD_LOGIC;
  SIGNAL outreg_snl   : STD_LOGIC;
  SIGNAL rd_int       : STD_LOGIC;
  SIGNAL wr_int       : STD_LOGIC;
  SIGNAL frmdata      : STD_LOGIC;
  SIGNAL frmdataval   : STD_LOGIC;
  SIGNAL scanintsel   : STD_LOGIC;
  SIGNAL scanintrd    : STD_LOGIC;
  SIGNAL int_aktiv    : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL capim_aktiv  : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL datval       : STD_LOGIC;
  SIGNAL datvalcnt    : INTEGER RANGE 0 TO 31;
  SIGNAL wordcnt      : INTEGER RANGE 0 TO 65;
  SIGNAL wordval      : STD_LOGIC;
  SIGNAL out_data     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL out_en       : STD_LOGIC;
  SIGNAL out_valid    : STD_LOGIC;
  SIGNAL out_snl      : STD_LOGIC;
  SIGNAL rd_valid     : STD_LOGIC;
  
  CONSTANT outreg_data_zero : STD_LOGIC_VECTOR(31 DOWNTO 32-UMR_DATA_BITWIDTH) := (OTHERS => '0');

  ATTRIBUTE \.syn_hypernoprune\ : INTEGER ;
  ATTRIBUTE \.syn_hypernoprune\ of all : architecture is 1;
  ATTRIBUTE \.syn_builtin_du\ : STRING ;
  ATTRIBUTE \.syn_builtin_du\ of all : architecture is "weak";
  ATTRIBUTE syn_noprune : INTEGER ;
  ATTRIBUTE \.syn_builtin_allow_modgen\ : INTEGER;
  ATTRIBUTE \.syn_builtin_allow_modgen\ of all : architecture is 1; 
  ATTRIBUTE syn_hier : STRING ;
  ATTRIBUTE syn_hier of all : architecture is "fixed";
  ATTRIBUTE syn_noprune of all : architecture is 1;
  ATTRIBUTE rbp_donotdissolve : INTEGER ;
  ATTRIBUTE rbp_donotdissolve of all : architecture is 1;
  ATTRIBUTE \.certify_slp_dont_write_view\ : INTEGER ;
  ATTRIBUTE \.certify_slp_dont_write_view\ of all : architecture is 1;

  ATTRIBUTE syn_srlstyle                 : STRING;
  ATTRIBUTE syn_srlstyle of inreg_en     : SIGNAL IS "registers";
  ATTRIBUTE syn_srlstyle of inreg_valid  : SIGNAL IS "registers";
  ATTRIBUTE syn_srlstyle of inreg_data   : SIGNAL IS "registers";
  ATTRIBUTE syn_srlstyle of outreg_en    : SIGNAL IS "registers";
  ATTRIBUTE syn_srlstyle of outreg_valid : SIGNAL IS "registers";
  ATTRIBUTE syn_srlstyle of outreg_data  : SIGNAL IS "registers";
  ATTRIBUTE syn_srlstyle of out_en       : SIGNAL IS "registers";
  ATTRIBUTE syn_srlstyle of out_valid    : SIGNAL IS "registers";
  ATTRIBUTE syn_srlstyle of out_data     : SIGNAL IS "registers";

BEGIN

  p_inreg : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      inreg_data                                 <= (OTHERS => '0');
      inreg_en                                   <= (OTHERS => '0');
      inreg_valid                                <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      inreg_data(31 DOWNTO 32-UMR_DATA_BITWIDTH)       <= umr_in_dat;
      inreg_en(32/UMR_DATA_BITWIDTH-1)                 <= umr_in_en;
      inreg_valid(32/UMR_DATA_BITWIDTH-1)              <= umr_in_valid;
      IF UMR_DATA_BITWIDTH < 32 THEN
        inreg_data(31-UMR_DATA_BITWIDTH DOWNTO 0)      <= inreg_data(31 DOWNTO UMR_DATA_BITWIDTH);
        inreg_en((32/UMR_DATA_BITWIDTH-2) DOWNTO 0)    <= inreg_en((32/UMR_DATA_BITWIDTH-1) DOWNTO 1);
        inreg_valid((32/UMR_DATA_BITWIDTH-2) DOWNTO 0) <= inreg_valid((32/UMR_DATA_BITWIDTH-1) DOWNTO 1);
      END IF;
    END IF;
  END PROCESS p_inreg;

  valid <= '1' WHEN inreg_valid((32/UMR_DATA_BITWIDTH-1)) = '1' ELSE '0';
 
  p_outreg : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      outreg_data                            <= (OTHERS => '0');
      outreg_en                              <= '0';
      outreg_valid                           <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      outreg_data                            <= outreg_din;
      outreg_en                              <= inreg_en(0);
      outreg_valid                           <= inreg_valid(0);
    END IF;
  END PROCESS p_outreg;

  -- data sources
  add_data                <= inreg_data(6 DOWNTO 0) + 1;
  scan_data(31 DOWNTO 16) <= conv_std_logic_vector(conv_unsigned(UMR_CAPIM_TYPE, 16), 16);
  scan_data(15 DOWNTO 7)  <= inreg_data(15 DOWNTO 7);
  scan_data(6 DOWNTO 0)   <= add_data;
  int_data(31 DOWNTO 16)  <= inttype;
  int_data(15 DOWNTO 7)   <= inreg_data(15 DOWNTO 7);
  int_data(6 DOWNTO 0)    <= add_data;
  data(31 DOWNTO 1)       <= inreg_data(31 DOWNTO 1);
  data(0)                 <= '1' WHEN int_aktiv(1) = '0' AND intr = '1' AND inreg_en(0) = '0' ELSE inreg_data(0);

  p_datasrc : PROCESS (capim_aktiv, data, din, int_aktiv, int_data, rd_int,
                       scan_data, wordval)
  BEGIN
    IF capim_aktiv(3) = '1' AND wordval = '1' AND int_aktiv(0) = '1' THEN  -- int
      outreg_din <= int_data;
    ELSIF capim_aktiv(4) = '1' AND wordval = '1' THEN  -- scan
      outreg_din <= scan_data;
    ELSE
      outreg_din <= data;
    END IF;
  END PROCESS p_datasrc;

  p_outreg_snl : PROCESS (capim_aktiv, datval, frmdataval, inreg_en, int_aktiv,
                          scanintrd)
  BEGIN
    IF capim_aktiv(2) = '1' AND datval = '0' AND frmdataval = '1' AND inreg_en(0) = '1' THEN  -- read
      outreg_snl <= '1';
    ELSIF capim_aktiv(3) = '1' AND datval = '0' AND scanintrd = '1' AND int_aktiv(0) = '1' AND inreg_en(0) = '1' THEN  -- int
      outreg_snl <= '1';
    ELSIF capim_aktiv(4) = '1' AND datval = '0' AND scanintrd = '1' AND inreg_en(0) = '1' THEN  -- scan
      outreg_snl <= '1';
    ELSE
      outreg_snl <= '0';
    END IF;
  END PROCESS p_outreg_snl;

  P_out: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      out_data  <= (OTHERS => '0'); 
      out_en    <= '0';
      out_valid <= '0';
      out_snl   <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF out_snl = '0' THEN
        IF rd_valid = '1' THEN
          out_data                            <= din;
        ELSE
          out_data                            <= outreg_data;
        END IF;
      ELSE
        IF UMR_DATA_BITWIDTH < 32 THEN
          out_data(31-UMR_DATA_BITWIDTH DOWNTO 0) <= out_data(31 DOWNTO UMR_DATA_BITWIDTH);
        END IF;
      END IF;
      out_en    <= outreg_en;
      out_valid <= outreg_valid;
      out_snl   <= outreg_snl;
    END IF;
  END PROCESS P_out;
  
  umr_out_dat   <= out_data(UMR_DATA_BITWIDTH-1 DOWNTO 0);
  umr_out_en    <= out_en;
  umr_out_valid <= out_valid;

  p_aktivate : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      capim_aktiv       <= "000001";    -- wait for operation
    ELSIF clk'EVENT AND clk = '1' THEN
      IF inreg_en(0) = '1' AND capim_aktiv(0) = '1' AND valid = '1' THEN
        IF inreg_data(13 DOWNTO 8) = conv_std_logic_vector(conv_unsigned(UMR_CAPIM_ADDRESS, 6), 6) THEN
          IF inreg_data(7 DOWNTO 4) = "0001" THEN
            capim_aktiv <= "000010";    -- write frame operation
          ELSIF inreg_data(7 DOWNTO 4) = "0010" THEN
            capim_aktiv <= "000100";    -- read frame operation
          ELSE
            capim_aktiv <= "100000";    -- idle
          END IF;
        ELSIF inreg_data(13 DOWNTO 8) = "000000" THEN
          IF inreg_data(7 DOWNTO 4) = "0110" THEN
            capim_aktiv <= "010000";    -- scan frame operation
          ELSIF inreg_data(7 DOWNTO 4) = "1010" THEN
            capim_aktiv <= "001000";    -- int frame operation
          ELSE
            capim_aktiv <= "100000";    -- idle
          END IF;
        ELSE
          capim_aktiv   <= "100000";    -- idle
        END IF;
      ELSIF inreg_en(0) = '0' THEN
        capim_aktiv     <= "000001";    -- wait for operation
      END IF;
    END IF;
  END PROCESS p_aktivate;

  p_interrupt : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      int_aktiv   <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF int_aktiv = "00" AND intr = '1' AND scanintrd = '0' THEN
        int_aktiv <= "01";
      ELSIF int_aktiv = "01" AND capim_aktiv(3) = '1' AND scanintrd = '1' THEN
        int_aktiv <= "11";
      ELSIF int_aktiv = "11" AND scanintrd = '0' THEN
        int_aktiv <= "10";
      ELSIF int_aktiv = "10" AND intr = '0' THEN
        int_aktiv <= "00";
      END IF;
    END IF;
  END PROCESS p_interrupt;

  inta <= '1' WHEN int_aktiv = "10" ELSE '0';

  p_datvalid : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      datvalcnt   <= 0;
    ELSIF clk'EVENT AND clk = '1' THEN
      IF capim_aktiv(0) = '1' OR datval = '1' THEN
        datvalcnt <= 0;
      ELSIF valid = '1' THEN
        datvalcnt <= datvalcnt + 1;
      END IF;
    END IF;
  END PROCESS p_datvalid;

  datval <= '1' WHEN datvalcnt = (32/UMR_DATA_BITWIDTH-1) AND inreg_valid(0) = '1' ELSE '0';

  p_frmdata : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      frmdata   <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF capim_aktiv(0) = '1' THEN
        frmdata <= '0';
      ELSIF frmdataval = '1' THEN
        frmdata <= '1';
      END IF;
    END IF;
  END PROCESS p_frmdata;

  frmdataval <= '1' WHEN datvalcnt = (32/UMR_DATA_BITWIDTH-1) OR frmdata = '1' ELSE '0';

  -- write data
  P_write_data: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dout <= (OTHERS => '0');
      wr <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF wr_int = '1' THEN
        dout <= inreg_data;
      END IF;
      wr <= wr_int;
    END IF;
  END PROCESS P_write_data;

  wr_int <= '1' WHEN capim_aktiv(1) = '1' AND datval = '1' AND inreg_en(0) = '1' ELSE '0';

  -- read data
  P_read_data: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      rd <= '0';
      rd_valid <= '0';
    ELSIF clk'event AND clk = '1' THEN
      rd <= rd_int;
      rd_valid <= capim_aktiv(2) AND rd_int;
    END IF;
  END PROCESS P_read_data;

  rd_int <= '1' WHEN capim_aktiv(2) = '1' AND datval = '1' AND inreg_en(0) = '1' ELSE '0';

  p_wordcnt : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      wordcnt   <= 0;
    ELSIF clk'EVENT AND clk = '1' THEN
      IF capim_aktiv(0) = '1' THEN
        wordcnt <= 0;
      ELSIF datval = '1' AND (capim_aktiv(3) = '1' OR capim_aktiv(4) = '1') THEN
        wordcnt <= wordcnt + 1;
      END IF;
    END IF;
  END PROCESS p_wordcnt;

  p_scanintsel : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      scanintsel   <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF capim_aktiv(0) = '1' OR scanintrd = '0' THEN
        scanintsel <= '0';
      ELSIF wordval = '1' THEN
        scanintsel <= '1';
      END IF;
    END IF;
  END PROCESS p_scanintsel;

  scanintrd <= '1' WHEN wordval = '1' OR (scanintsel = '1' AND datval = '0') ELSE '0';
  wordval   <= '1' WHEN wordcnt = UMR_CAPIM_ADDRESS AND datval = '1'                   ELSE '0';

END A_capim;


library ieee ;
use ieee.std_logic_1164.all;
entity syn_hyper_connect_umr_vhd is
	generic (
		tag : string := "tag_name"
	);
	port (
		out1 : out std_logic
	);
end entity syn_hyper_connect_umr_vhd ;

architecture beh of syn_hyper_connect_umr_vhd is
        attribute syn_black_box : boolean;
        attribute syn_black_box of  beh : architecture is true;
        attribute syn_noprune : boolean;
        attribute syn_noprune of  beh : architecture is true;
        attribute \.syn_hypernoprune\ : boolean;
        attribute \.syn_hypernoprune\ of  beh : architecture is true;
begin
end architecture beh;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
entity umr_clk_reset IS PORT (
  umr_clk_out : OUT STD_LOGIC;
  umr_reset_out : OUT STD_LOGIC
);
end umr_clk_reset;

architecture A_umr_clk_reset of  umr_clk_reset is
begin

clk_src : entity snps_haps.syn_hyper_connect_umr_vhd(beh) 
				 generic map (tag => "umr_clk" )
      			 port map ( out1 => umr_clk_out );
  
reset_src : entity snps_haps.syn_hyper_connect_umr_vhd(beh) 
				 generic map (tag => "umr_reset" )
      			 port map ( out1 => umr_reset_out );
    
      
end A_umr_clk_reset;

