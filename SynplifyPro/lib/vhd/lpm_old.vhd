--
-- This version of the LPM_COMPONENTS package is specific to Synplify 
-- and should only be used for synthesis.
-- Copyright (c) 1998, Synplicity, Inc. All rights reserved
--
-- $Header: //synplicity/comp2019q3p1/compilers/vhdl/vhd/lpm_old.vhd#1 $
--
library ieee;
use ieee.std_logic_1164.all;
package LPM_OLD_COMPONENTS is

--------------LPM_CLSHIFT Components----------------------------------

COMPONENT lpm_clshift
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_WIDTHDIST: POSITIVE;
      LPM_TYPE: STRING := "L_CLSHIFT";
      LPM_SHIFTTYPE: STRING := "LOGICAL";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      distance: IN STD_LOGIC_VECTOR(LPM_WIDTHDIST-1 DOWNTO 0);
      direction: IN STD_LOGIC := '0';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      underflow, overflow: OUT STD_LOGIC);
END COMPONENT;

--------------LPM_DECODE Components-----------------------------------

COMPONENT synplicity_lpm_decode_clk
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_DECODE";
      LPM_PIPELINE: INTEGER := 0;
      LPM_DECODES: NATURAL;
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      enable: IN STD_LOGIC := '1';
      eq: OUT STD_LOGIC_VECTOR(LPM_DECODES-1 DOWNTO 0));
END COMPONENT;

COMPONENT synplicity_lpm_decode
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_DECODE";
      LPM_PIPELINE: INTEGER := 0;
      LPM_DECODES: NATURAL;
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      enable: IN STD_LOGIC := '1';
      eq: OUT STD_LOGIC_VECTOR(LPM_DECODES-1 DOWNTO 0));
END COMPONENT;

COMPONENT lpm_decode
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_DECODE";
      LPM_PIPELINE: INTEGER := 0;
      LPM_DECODES: NATURAL;
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      enable: IN STD_LOGIC := '1';
      eq: OUT STD_LOGIC_VECTOR(LPM_DECODES-1 DOWNTO 0));
END COMPONENT;

--------------LPM_FF Components---------------------------------------

COMPONENT synplicity_lpm_ff_sload
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_AVALUE: STRING := "UNUSED";
      LPM_FFTYPE: STRING := "DFF";
      LPM_TYPE: STRING := "LPM_FF";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC;
      enable: IN STD_LOGIC := '1';
      sload: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
COMPONENT synplicity_lpm_ff
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_AVALUE: STRING := "UNUSED";
      LPM_FFTYPE: STRING := "DFF";
      LPM_TYPE: STRING := "LPM_FF";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC;
      enable: IN STD_LOGIC := '1';
      sclr: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
COMPONENT lpm_ff
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_AVALUE: STRING := "UNUSED";
      LPM_FFTYPE: STRING := "DFF";
      LPM_TYPE: STRING := "LPM_FF";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC;
      enable: IN STD_LOGIC := '1';
      sload: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

--------------LPM_LATCH Components------------------------------------

COMPONENT lpm_latch
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_LATCH";
      LPM_AVALUE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      gate: IN STD_LOGIC;
      aset: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

--------------LPM_SHIFTREG Components---------------------------------

COMPONENT lpm_shiftreg
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_AVALUE: STRING := "UNUSED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_TYPE: STRING := "LPM_SHIFTREG";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC;
      enable: IN STD_LOGIC := '1';
      shiftin: IN STD_LOGIC := '1';
      load: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      shiftout: OUT STD_LOGIC);
END COMPONENT;

--------------LPM_RAM_DQ Components-----------------------------------

COMPONENT synplicity_lpm_ram_dq_reg_in_reg_out
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
COMPONENT synplicity_lpm_ram_dq_reg_in
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
COMPONENT synplicity_lpm_ram_dq_reg_out
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
COMPONENT synplicity_lpm_ram_dq
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
COMPONENT lpm_ram_dq
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

--------------LPM_RAM_IO Components-----------------------------------

COMPONENT synplicity_lpm_ram_io_reg_in_reg_out
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_IO";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      outenab: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      dio: INOUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
COMPONENT synplicity_lpm_ram_io_reg_in
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_IO";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      outenab: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      dio: INOUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
COMPONENT synplicity_lpm_ram_io_reg_out
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_IO";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      outenab: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      dio: INOUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
COMPONENT synplicity_lpm_ram_io
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_IO";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      outenab: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      dio: INOUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
COMPONENT lpm_ram_io
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_IO";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      outenab: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      dio: INOUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

--------------LPM_ROM Components-----------------------------------

COMPONENT synplicity_lpm_rom_reg_in_reg_out
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

COMPONENT synplicity_lpm_rom_reg_in
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      inclock: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

COMPONENT synplicity_lpm_rom_reg_out
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      outclock: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

COMPONENT synplicity_lpm_rom
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      memenab: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

COMPONENT lpm_rom
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

--------------LPM_ABS Components------------------------------------

COMPONENT lpm_abs
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ABS";
      LPM_HINT : STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      overflow: out STD_LOGIC);
END COMPONENT;

--------------LPM_ADD_SUB Components--------------------------------

COMPONENT synplicity_lpm_add_sub_clk_dir
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_ADD_SUB";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      cin: IN STD_LOGIC := '0';
      add_sub: IN STD_LOGIC := '1';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cout: OUT STD_LOGIC;
      overflow: OUT STD_LOGIC);
END COMPONENT;

COMPONENT synplicity_lpm_add_sub_clk
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_ADD_SUB";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      cin: IN STD_LOGIC := '0';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cout: OUT STD_LOGIC;
      overflow: OUT STD_LOGIC);
END COMPONENT;

COMPONENT synplicity_lpm_add_sub_dir
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_ADD_SUB";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cin: IN STD_LOGIC := '0';
      add_sub: IN STD_LOGIC := '1';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cout: OUT STD_LOGIC;
      overflow: OUT STD_LOGIC);
END COMPONENT;

COMPONENT synplicity_lpm_add_sub
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_ADD_SUB";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cin: IN STD_LOGIC := '0';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cout: OUT STD_LOGIC;
      overflow: OUT STD_LOGIC);
END COMPONENT;

COMPONENT lpm_add_sub
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_ADD_SUB";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      cin: IN STD_LOGIC := '0';
      add_sub: IN STD_LOGIC := '1';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cout: OUT STD_LOGIC;
      overflow: OUT STD_LOGIC);
END COMPONENT;

--------------LPM_COMPARE Components--------------------------------

COMPONENT synplicity_lpm_compare_clk
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_COMPARE";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      agb: out STD_LOGIC;
      ageb : out STD_LOGIC;
      aeb: out STD_LOGIC;
      aneb : out STD_LOGIC;
      alb: out STD_LOGIC;
      aleb : out STD_LOGIC);
END COMPONENT;

COMPONENT synplicity_lpm_compare
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_COMPARE";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      agb: out STD_LOGIC;
      ageb : out STD_LOGIC;
      aeb: out STD_LOGIC;
      aneb : out STD_LOGIC;
      alb: out STD_LOGIC;
      aleb : out STD_LOGIC);
END COMPONENT;

COMPONENT lpm_compare
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_COMPARE";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      agb: out STD_LOGIC;
      ageb : out STD_LOGIC;
      aeb: out STD_LOGIC;
      aneb : out STD_LOGIC;
      alb: out STD_LOGIC;
      aleb : out STD_LOGIC);
END COMPONENT;

--------------LPM_COUNTER Components--------------------------------

COMPONENT synplicity_lpm_counter_ud
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_MODULUS: STRING := "UNUSED";
      LPM_AVALUE: STRING := "UNUSED";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_TYPE: STRING := "LPM_COUNTER";
      LPM_HINT : STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
      clock: IN STD_LOGIC;
      clk_en: IN STD_LOGIC := '1';
      cnt_en: IN STD_LOGIC := '1';
      updown: IN STD_LOGIC := '1';
      sload: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      eq: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

COMPONENT synplicity_lpm_counter
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_MODULUS: STRING := "UNUSED";
      LPM_AVALUE: STRING := "UNUSED";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_TYPE: STRING := "LPM_COUNTER";
      LPM_HINT : STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
      clock: IN STD_LOGIC;
      clk_en: IN STD_LOGIC := '1';
      cnt_en: IN STD_LOGIC := '1';
      sload: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      eq: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

COMPONENT lpm_counter
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_MODULUS: STRING := "UNUSED";
      LPM_AVALUE: STRING := "UNUSED";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_TYPE: STRING := "LPM_COUNTER";
      LPM_HINT : STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
      clock: IN STD_LOGIC;
      clk_en: IN STD_LOGIC := '1';
      cnt_en: IN STD_LOGIC := '1';
      updown: IN STD_LOGIC := '1';
      sload: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      eq: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;

--------------LPM_MULT Components-----------------------------------

COMPONENT synplicity_lpm_mult_clk
   GENERIC (LPM_WIDTHA: POSITIVE;
      LPM_WIDTHB: POSITIVE;
      LPM_WIDTHS: POSITIVE;
      LPM_WIDTHP: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_MULT";
      LPM_HINT : STRING := "UNUSED";
      MAXIMIZE_SPEED :INTEGER := 5);
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTHA-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTHB-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      sum: IN STD_LOGIC_VECTOR(LPM_WIDTHS-1 DOWNTO 0) := (OTHERS => '0');
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTHP-1 DOWNTO 0));
END COMPONENT;
COMPONENT synplicity_lpm_mult
   GENERIC (LPM_WIDTHA: POSITIVE;
      LPM_WIDTHB: POSITIVE;
      LPM_WIDTHS: POSITIVE;
      LPM_WIDTHP: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_MULT";
      LPM_HINT : STRING := "UNUSED";
      MAXIMIZE_SPEED :INTEGER := 5);
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTHA-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTHB-1 DOWNTO 0);
      sum: IN STD_LOGIC_VECTOR(LPM_WIDTHS-1 DOWNTO 0) := (OTHERS => '0');
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTHP-1 DOWNTO 0));
END COMPONENT;
COMPONENT lpm_mult
   GENERIC (LPM_WIDTHA: POSITIVE;
      LPM_WIDTHB: POSITIVE;
      LPM_WIDTHS: POSITIVE;
      LPM_WIDTHP: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_MULT";
      LPM_HINT : STRING := "UNUSED";
      MAXIMIZE_SPEED :INTEGER := 5);
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTHA-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTHB-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      sum: IN STD_LOGIC_VECTOR(LPM_WIDTHS-1 DOWNTO 0) := (OTHERS => '0');
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTHP-1 DOWNTO 0));
END COMPONENT;

-------------LPM_RAM_DP_COMPONENTS-----------------------------------
component synplicity_lpm_ram_dp_reg_in_reg_out is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_WIDTHAD: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DP";
      LPM_NUMWORDS: POSITIVE;
      LPM_INDATA: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_RDADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_WRADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_FILE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      rdaddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      wraddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      rdclken: IN STD_LOGIC := '1';
      wrclken: IN STD_LOGIC := '1';
      rden: IN STD_LOGIC;
      wren: IN STD_LOGIC;
      rdclock: IN STD_LOGIC := '0';
      wrclock: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end component;
component synplicity_lpm_ram_dp_reg_in is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_WIDTHAD: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DP";
      LPM_NUMWORDS: POSITIVE;
      LPM_INDATA: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_RDADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_WRADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_FILE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      wraddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
	  rdaddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      rden :IN STD_LOGIC;
      wrclken: IN STD_LOGIC := '1';
      wren: IN STD_LOGIC;
      wrclock: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end component;
component synplicity_lpm_ram_dp_reg_out is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_WIDTHAD: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DP";
      LPM_NUMWORDS: POSITIVE;
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_RDADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_WRADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_FILE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      rdaddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
	  wraddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      rdclken: IN STD_LOGIC := '1';
      rden: IN STD_LOGIC;
	  wren: IN STD_LOGIC;
      rdclock: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));   
end component;
component synplicity_lpm_ram_dp is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_WIDTHAD: POSITIVE;
     LPM_TYPE: STRING := "LPM_RAM_DP";
      LPM_NUMWORDS: POSITIVE;
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_RDADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_WRADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_FILE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      rdaddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      wraddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      rden: IN STD_LOGIC;
      wren: IN STD_LOGIC;
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end component;
component lpm_ram_dp is
   GENERIC ( LPM_WIDTH: POSITIVE;
      LPM_WIDTHAD: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DP";
      LPM_NUMWORDS: POSITIVE;
      LPM_INDATA: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_RDADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_WRADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_FILE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      rdaddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      wraddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      rdclken: IN STD_LOGIC := '1';
      wrclken: IN STD_LOGIC := '1';
      rden: IN STD_LOGIC;
      wren: IN STD_LOGIC;
      rdclock: IN STD_LOGIC := '0';
      wrclock: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end component;
-------------LPM_FIFO_DC-------------------------------------------------
component LPM_FIFO_DC is 
 GENERIC (LPM_WIDTH: POSITIVE;
 		  LPM_WIDTHU: POSITIVE;
		  LPM_NUMWORDS: POSITIVE;
		  LPM_SHOWAHEAD: STRING := "OFF";
		  LPM_TYPE : STRING := "LPM_FIFO_DC";
		  LPM_HINT : STRING := "UNUSED";
		  OVERFLOW_CHECKING: STRING := "ON";
		  UNDERFLOW_CHECKING: STRING := "ON";
		  DELAY_RDUSEDW :POSITIVE := 1;
		  DELAY_WRUSEDW : POSITIVE := 1;
		  RDSYNC_DELAYPIPE : POSITIVE := 3;
		  WRSYNC_DELAYPIPE : POSITIVE := 3);
  PORT ( data : in std_logic_vector (LPM_WIDTH-1 downto 0);
  		 rdclock, wrclock, wrreq, rdreq, aclr: in std_logic;
		 rdfull, wrfull, wrempty, rdempty : out std_logic;
		 q :out std_logic_vector (LPM_WIDTH-1 downto 0);
		 rdusedw, wrusedw : out std_logic_vector (LPM_WIDTHU-1 downto 0)
   );
end component;
end package LPM_OLD_COMPONENTS;

--------------LPM_CLSHIFT Entities----------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity lpm_clshift is
   GENERIC (LPM_WIDTH: POSITIVE := 1;
      LPM_WIDTHDIST: POSITIVE;
      LPM_TYPE: STRING := "LPM_CLSHIFT";
      LPM_SHIFTTYPE: STRING := "LOGICAL";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      distance: IN STD_LOGIC_VECTOR(LPM_WIDTHDIST-1 DOWNTO 0);
      direction: IN STD_LOGIC := '0';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      underflow, overflow: OUT STD_LOGIC);
end entity lpm_clshift;
architecture bb of lpm_clshift is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHDIST\ : POSITIVE;
attribute \LPM_WIDTHDIST\ of all : architecture is LPM_WIDTHDIST;
attribute \LPM_SHIFTTYPE\ : STRING;
attribute \LPM_SHIFTTYPE\ of all : architecture is LPM_SHIFTTYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is (8 * LPM_WIDTH);
begin
end architecture bb;

--------------LPM_DECODE Entities------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_decode_clk is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_DECODE";
      LPM_PIPELINE: INTEGER := 0;
      LPM_DECODES: NATURAL;
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      enable: IN STD_LOGIC := '1';
      eq: OUT STD_LOGIC_VECTOR(LPM_DECODES-1 DOWNTO 0));
end entity synplicity_lpm_decode_clk;
architecture bb of synplicity_lpm_decode_clk is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_PIPELINE\ : INTEGER;
attribute \LPM_PIPELINE\ of all : architecture is LPM_PIPELINE;
attribute \LPM_DECODES\ : NATURAL;
attribute \LPM_DECODES\ of all : architecture is LPM_DECODES;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_DECODES;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_decode is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_DECODE";
      LPM_PIPELINE: INTEGER := 0;
      LPM_DECODES: NATURAL;
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      enable: IN STD_LOGIC := '1';
      eq: OUT STD_LOGIC_VECTOR(LPM_DECODES-1 DOWNTO 0));
end entity synplicity_lpm_decode;
architecture bb of synplicity_lpm_decode is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_PIPELINE\ : INTEGER;
attribute \LPM_PIPELINE\ of all : architecture is LPM_PIPELINE;
attribute \LPM_DECODES\ : NATURAL;
attribute \LPM_DECODES\ of all : architecture is LPM_DECODES;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_DECODES;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library lpm_old;
use lpm_old.lpm_old_components.all;
entity lpm_decode is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_DECODE";
      LPM_PIPELINE: INTEGER := 0;
      LPM_DECODES: NATURAL;
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      enable: IN STD_LOGIC := '1';
      eq: OUT STD_LOGIC_VECTOR(LPM_DECODES-1 DOWNTO 0));
end entity lpm_decode;
architecture bb of lpm_decode is
begin
   U1 : if (LPM_PIPELINE = 0) generate
      ULPM : synplicity_lpm_decode
            generic map (LPM_WIDTH => LPM_WIDTH, LPM_DECODES => LPM_DECODES, LPM_PIPELINE => LPM_PIPELINE, 
                         LPM_TYPE => LPM_TYPE, LPM_HINT => LPM_HINT)
            port map (data => data, enable => enable, eq => eq);
   end generate U1;
   U2 : if (LPM_PIPELINE > 0) generate
      ULPM : synplicity_lpm_decode_clk
            generic map (LPM_WIDTH => LPM_WIDTH, LPM_DECODES => LPM_DECODES, LPM_PIPELINE => LPM_PIPELINE, 
                         LPM_TYPE => LPM_TYPE, LPM_HINT => LPM_HINT)
            port map (data => data, clock => clock, aclr => aclr, enable => enable, eq => eq);
   end generate U2;
end architecture bb;

--------------LPM_FF Entities---------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ff_sload is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_AVALUE: STRING := "UNUSED";
      LPM_FFTYPE: STRING := "FDFF";
      LPM_TYPE: STRING := "LPM_FF";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC;
      enable: IN STD_LOGIC := '1';
      sload: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ff_sload;
architecture bb of synplicity_lpm_ff_sload is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_AVALUE\ : STRING;
attribute \LPM_AVALUE\ of all : architecture is LPM_AVALUE;
attribute \LPM_FFTYPE\ : STRING;
attribute \LPM_FFTYPE\ of all : architecture is LPM_FFTYPE;
attribute \LPM_SVALUE\ : STRING;
attribute \LPM_SVALUE\ of all : architecture is LPM_SVALUE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ff is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_AVALUE: STRING := "UNUSED";
      LPM_FFTYPE: STRING := "DFF";
      LPM_TYPE: STRING := "LPM_FF";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC;
      enable: IN STD_LOGIC := '1';
      sclr: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ff;
architecture bb of synplicity_lpm_ff is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_AVALUE\ : STRING;
attribute \LPM_AVALUE\ of all : architecture is LPM_AVALUE;
attribute \LPM_FFTYPE\ : STRING;
attribute \LPM_FFTYPE\ of all : architecture is LPM_FFTYPE;
attribute \LPM_SVALUE\ : STRING;
attribute \LPM_SVALUE\ of all : architecture is LPM_SVALUE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library lpm_old;
use lpm_old.lpm_old_components.all;
entity lpm_ff is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_AVALUE: STRING := "UNUSED";
      LPM_FFTYPE: STRING := "DFF";
      LPM_TYPE: STRING := "LPM_FF";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC;
      enable: IN STD_LOGIC := '1';
      sload: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity lpm_ff;
architecture bb of lpm_ff is
begin
   U1 : if ((LPM_FFTYPE(LPM_FFTYPE'left) = 'T') or (LPM_FFTYPE(LPM_FFTYPE'left) = 't')) generate
      ULPM : synplicity_lpm_ff_sload
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_AVALUE => LPM_AVALUE, LPM_FFTYPE => LPM_FFTYPE, 
                      LPM_TYPE => LPM_TYPE, LPM_SVALUE => LPM_SVALUE, LPM_HINT => LPM_HINT)
         port map (data => data, clock => clock, enable => enable, sload => sload, sclr => sclr,
                   sset => sset, aload => aload, aclr => aclr, aset => aset, q => q);
   end generate U1;
   U2 : if (((LPM_FFTYPE(LPM_FFTYPE'left) = 'D') or (LPM_FFTYPE(LPM_FFTYPE'left) = 'd')) or 
            ((LPM_FFTYPE(LPM_FFTYPE'left) = 'U') or (LPM_FFTYPE(LPM_FFTYPE'left) = 'u'))) generate
      ULPM : synplicity_lpm_ff
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_AVALUE => LPM_AVALUE, LPM_FFTYPE => LPM_FFTYPE, 
                      LPM_TYPE => LPM_TYPE, LPM_SVALUE => LPM_SVALUE, LPM_HINT => LPM_HINT)
         port map (data => data, clock => clock, enable => enable, sclr => sclr,
                   sset => sset, aload => aload, aclr => aclr, aset => aset, q => q);
   end generate U2;
end bb;

--------------LPM_LATCH Entities------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity lpm_latch is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_LATCH";
      LPM_AVALUE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      gate: IN STD_LOGIC;
      aset: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity lpm_latch;
architecture bb of lpm_latch is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_AVALUE\ : STRING;
attribute \LPM_AVALUE\ of all : architecture is LPM_AVALUE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

--------------LPM_SHIFTREG Entities--------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity lpm_shiftreg is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_AVALUE: STRING := "UNUSED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_TYPE: STRING := "LPM_SHIFTREG";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock: IN STD_LOGIC;
      enable: IN STD_LOGIC := '1';
      shiftin: IN STD_LOGIC := '1';
      load: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      shiftout: OUT STD_LOGIC);
end entity lpm_shiftreg;
architecture bb of lpm_shiftreg is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_AVALUE\ : STRING;
attribute \LPM_AVALUE\ of all : architecture is LPM_AVALUE;
attribute \LPM_DIRECTION\ : STRING;
attribute \LPM_DIRECTION\ of all : architecture is LPM_DIRECTION;
attribute \LPM_SVALUE\ : STRING;
attribute \LPM_SVALUE\ of all : architecture is LPM_SVALUE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

--------------LPM_RAM_DQ Entities-----------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_dq_reg_in_reg_out is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_dq_reg_in_reg_out;
architecture bb of synplicity_lpm_ram_dq_reg_in_reg_out is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_dq_reg_in is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_dq_reg_in;
architecture bb of synplicity_lpm_ram_dq_reg_in is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_dq_reg_out is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_dq_reg_out;
architecture bb of synplicity_lpm_ram_dq_reg_out is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_dq is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_dq;
architecture bb of synplicity_lpm_ram_dq is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library lpm_old;
use lpm_old.lpm_old_components.all;
entity lpm_ram_dq is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DQ";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE := 99999999;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity lpm_ram_dq;
architecture bb of lpm_ram_dq is
type pos_arr is array (0 to 1) of positive;
constant numword_arr : pos_arr := (LPM_NUMWORDS, 2**LPM_WIDTHAD);
constant numword_index : integer := (LPM_NUMWORDS / 99999999);
constant numwords : positive := numword_arr(numword_index);
begin
   U1 : if ((((LPM_INDATA(LPM_INDATA'left) = 'R') or (LPM_INDATA(LPM_INDATA'left) = 'r')) or
             ((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'R') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'r'))) and
             ((LPM_OUTDATA(LPM_OUTDATA'left) = 'R') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'r'))) generate
      ULPM : synplicity_lpm_ram_dq_reg_in_reg_out
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA,
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (data => data, address => address,
                   we => we, inclock => inclock, outclock => outclock, q => q);
   end generate U1;
   U2 : if ((((LPM_INDATA(LPM_INDATA'left) = 'R') or (LPM_INDATA(LPM_INDATA'left) = 'r')) or
             ((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'R') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'r'))) and
            ((LPM_OUTDATA(LPM_OUTDATA'left) = 'U') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'u'))) generate
      ULPM : synplicity_lpm_ram_dq_reg_in
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA, 
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (data => data, address => address,
                   we => we, inclock => inclock, q => q);
   end generate U2;
   U3 : if (((LPM_INDATA(LPM_INDATA'left) = 'U') or (LPM_INDATA(LPM_INDATA'left) = 'u')) and
            ((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'U') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'u')) and
            ((LPM_OUTDATA(LPM_OUTDATA'left) = 'R') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'r'))) generate
      ULPM : synplicity_lpm_ram_dq_reg_out
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA, 
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (data => data, address => address,
                   we => we, outclock => outclock, q => q);
   end generate U3;
   U4 : if (((LPM_INDATA(LPM_INDATA'left) = 'U') or (LPM_INDATA(LPM_INDATA'left) = 'u')) and
            ((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'U') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'u')) and
            ((LPM_OUTDATA(LPM_OUTDATA'left) = 'U') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'u'))) generate
      ULPM : synplicity_lpm_ram_dq
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA, 
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (data => data, address => address,
                   we => we, q => q);
   end generate U4;
end bb;

--------------LPM_RAM_IO Entities-----------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_io_reg_in_reg_out is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_IO";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      outenab: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      dio: INOUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_io_reg_in_reg_out;
architecture bb of synplicity_lpm_ram_io_reg_in_reg_out is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_io_reg_in is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_IO";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      outenab: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      dio: INOUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_io_reg_in;
architecture bb of synplicity_lpm_ram_io_reg_in is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_io_reg_out is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_IO";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      outenab: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      dio: INOUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_io_reg_out;
architecture bb of synplicity_lpm_ram_io_reg_out is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_io is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_IO";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      outenab: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      dio: INOUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_io;
architecture bb of synplicity_lpm_ram_io is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library lpm_old;
use lpm_old.lpm_old_components.all;
entity lpm_ram_io is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_IO";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE := 99999999;
      LPM_FILE: STRING := "UNUSED";
      LPM_INDATA: STRING := "REGISTERED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      we: IN STD_LOGIC := '1';
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      outenab: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      dio: INOUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity lpm_ram_io;
architecture bb of lpm_ram_io is
type pos_arr is array (0 to 1) of positive;
constant numword_arr : pos_arr := (LPM_NUMWORDS, 2**LPM_WIDTHAD);
constant numword_index : integer := (LPM_NUMWORDS / 99999999);
constant numwords : positive := numword_arr(numword_index);
begin
   U1 : if ((((LPM_INDATA(LPM_INDATA'left) = 'R') or (LPM_INDATA(LPM_INDATA'left) = 'r')) or
             ((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'R') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'r'))) and
             ((LPM_OUTDATA(LPM_OUTDATA'left) = 'R') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'r'))) generate
      ULPM : synplicity_lpm_ram_io_reg_in_reg_out
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA,
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (address => address, we => we, inclock => inclock, outclock => outclock, outenab => outenab,
                      memenab => memenab, dio => dio);
   end generate U1;
   U2 : if ((((LPM_INDATA(LPM_INDATA'left) = 'R') or (LPM_INDATA(LPM_INDATA'left) = 'r')) or
             ((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'R') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'r'))) and
            ((LPM_OUTDATA(LPM_OUTDATA'left) = 'U') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'u'))) generate
      ULPM : synplicity_lpm_ram_io_reg_in
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA, 
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (address => address, we => we, inclock => inclock, outenab => outenab,
                      memenab => memenab, dio => dio);
   end generate U2;
   U3 : if (((LPM_INDATA(LPM_INDATA'left) = 'U') or (LPM_INDATA(LPM_INDATA'left) = 'u')) and
            ((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'U') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'u')) and
            ((LPM_OUTDATA(LPM_OUTDATA'left) = 'R') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'r'))) generate
      ULPM : synplicity_lpm_ram_io_reg_out
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA, 
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (address => address, we => we, outclock => outclock, outenab => outenab,
                      memenab => memenab, dio => dio);
   end generate U3;
   U4 : if (((LPM_INDATA(LPM_INDATA'left) = 'U') or (LPM_INDATA(LPM_INDATA'left) = 'u')) and
            ((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'U') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'u')) and
            ((LPM_OUTDATA(LPM_OUTDATA'left) = 'U') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'u'))) generate
      ULPM : synplicity_lpm_ram_io
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA, 
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (address => address, we => we, outenab => outenab,
                      memenab => memenab, dio => dio);
   end generate U4;
end bb;

--------------LPM_ROM Entities-----------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_rom_reg_in_reg_out is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_rom_reg_in_reg_out;
architecture bb of synplicity_lpm_rom_reg_in_reg_out is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_rom_reg_in is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      inclock: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_rom_reg_in;
architecture bb of synplicity_lpm_rom_reg_in is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_rom_reg_out is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      outclock: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_rom_reg_out;
architecture bb of synplicity_lpm_rom_reg_out is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_rom is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE;
      LPM_FILE: STRING := "UNUSED";
      LPM_ADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      memenab: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_rom;
architecture bb of synplicity_lpm_rom is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_ADDRESS_CONTROL\ : STRING;
attribute \LPM_ADDRESS_CONTROL\ of all : architecture is LPM_ADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library lpm_old;
use lpm_old.lpm_old_components.all;
entity lpm_rom is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: POSITIVE := 99999999;
      LPM_FILE: STRING := "UNUSED";
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity lpm_rom;
architecture bb of lpm_rom is
type pos_arr is array (0 to 1) of positive;
constant numword_arr : pos_arr := (LPM_NUMWORDS, 2**LPM_WIDTHAD);
constant numword_index : integer := (LPM_NUMWORDS / 99999999);
constant numwords : positive := numword_arr(numword_index);
begin
   U1 : if (((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'R') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'r')) and
             ((LPM_OUTDATA(LPM_OUTDATA'left) = 'R') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'r'))) generate
      ULPM : synplicity_lpm_rom_reg_in_reg_out
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, 
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (address => address, inclock => inclock, outclock => outclock, memenab => memenab, q => q);
   end generate U1;
   U2 : if (((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'R') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'r')) and
             ((LPM_OUTDATA(LPM_OUTDATA'left) = 'U') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'u'))) generate
      ULPM : synplicity_lpm_rom_reg_in
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, 
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (address => address, inclock => inclock, memenab => memenab, q => q);
   end generate U2;
   U3 : if (((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'U') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'u')) and
             ((LPM_OUTDATA(LPM_OUTDATA'left) = 'R') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'r'))) generate
      ULPM : synplicity_lpm_rom_reg_out
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, 
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (address => address, outclock => outclock, memenab => memenab, q => q);
   end generate U3;
   U4 : if (((LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'U') or (LPM_ADDRESS_CONTROL(LPM_ADDRESS_CONTROL'left) = 'u')) and
             ((LPM_OUTDATA(LPM_OUTDATA'left) = 'U') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'u'))) generate
      ULPM : synplicity_lpm_rom
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, 
                      LPM_ADDRESS_CONTROL => LPM_ADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (address => address, memenab => memenab, q => q);
   end generate U4;
end bb;

--------------LPM_ABS Entities------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity lpm_abs is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "LPM_ABS";
      LPM_HINT : STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      overflow: out STD_LOGIC);
end entity lpm_abs;
architecture bb of lpm_abs is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

--------------LPM_ADD_SUB Entities--------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_add_sub_clk_dir is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_ADD_SUB";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      cin: IN STD_LOGIC := '0';
      add_sub: IN STD_LOGIC := '1';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cout: OUT STD_LOGIC;
      overflow: OUT STD_LOGIC);
end entity synplicity_lpm_add_sub_clk_dir;
architecture bb of synplicity_lpm_add_sub_clk_dir is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_REPRESENTATION\ : STRING;
attribute \LPM_REPRESENTATION\ of all : architecture is LPM_REPRESENTATION;
attribute \LPM_DIRECTION\ : STRING;
attribute \LPM_DIRECTION\ of all : architecture is LPM_DIRECTION;
attribute \LPM_PIPELINE\ : INTEGER;
attribute \LPM_PIPELINE\ of all : architecture is LPM_PIPELINE;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_add_sub_clk is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_ADD_SUB";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      cin: IN STD_LOGIC := '0';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cout: OUT STD_LOGIC;
      overflow: OUT STD_LOGIC);
end entity synplicity_lpm_add_sub_clk;
architecture bb of synplicity_lpm_add_sub_clk is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_REPRESENTATION\ : STRING;
attribute \LPM_REPRESENTATION\ of all : architecture is LPM_REPRESENTATION;
attribute \LPM_DIRECTION\ : STRING;
attribute \LPM_DIRECTION\ of all : architecture is LPM_DIRECTION;
attribute \LPM_PIPELINE\ : INTEGER;
attribute \LPM_PIPELINE\ of all : architecture is LPM_PIPELINE;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_add_sub_dir is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_ADD_SUB";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cin: IN STD_LOGIC := '0';
      add_sub: IN STD_LOGIC := '1';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cout: OUT STD_LOGIC;
      overflow: OUT STD_LOGIC);
end entity synplicity_lpm_add_sub_dir;
architecture bb of synplicity_lpm_add_sub_dir is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_REPRESENTATION\ : STRING;
attribute \LPM_REPRESENTATION\ of all : architecture is LPM_REPRESENTATION;
attribute \LPM_DIRECTION\ : STRING;
attribute \LPM_DIRECTION\ of all : architecture is LPM_DIRECTION;
attribute \LPM_PIPELINE\ : INTEGER;
attribute \LPM_PIPELINE\ of all : architecture is LPM_PIPELINE;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_add_sub is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_ADD_SUB";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cin: IN STD_LOGIC := '0';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cout: OUT STD_LOGIC;
      overflow: OUT STD_LOGIC);
end entity synplicity_lpm_add_sub;
architecture bb of synplicity_lpm_add_sub is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_REPRESENTATION\ : STRING;
attribute \LPM_REPRESENTATION\ of all : architecture is LPM_REPRESENTATION;
attribute \LPM_DIRECTION\ : STRING;
attribute \LPM_DIRECTION\ of all : architecture is LPM_DIRECTION;
attribute \LPM_PIPELINE\ : INTEGER;
attribute \LPM_PIPELINE\ of all : architecture is LPM_PIPELINE;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library lpm_old;
use lpm_old.lpm_old_components.all;
entity lpm_add_sub is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_ADD_SUB";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      cin: IN STD_LOGIC := '0';
      add_sub: IN STD_LOGIC := '1';
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      cout: OUT STD_LOGIC;
      overflow: OUT STD_LOGIC);
end entity lpm_add_sub;
architecture bb of lpm_add_sub is
begin
   U1 : if (((LPM_DIRECTION(LPM_DIRECTION'left) = 'U') or (LPM_DIRECTION(LPM_DIRECTION'left) = 'u') or 
             (LPM_DIRECTION(LPM_DIRECTION'left) = 'D') or (LPM_DIRECTION(LPM_DIRECTION'left) = 'd')) and
             ((LPM_PIPELINE > 0))) generate
      ULPM : synplicity_lpm_add_sub_clk_dir
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_REPRESENTATION => LPM_REPRESENTATION, 
                      LPM_DIRECTION => LPM_DIRECTION, LPM_PIPELINE => LPM_PIPELINE, 
                      LPM_TYPE => LPM_TYPE, LPM_HINT => LPM_HINT)
         port map (dataa => dataa, datab => datab, aclr => aclr, clock => clock, cin => cin, 
                   add_sub => add_sub, result => result, cout => cout, overflow => overflow);
   end generate U1;
   U2 : if (((LPM_DIRECTION(LPM_DIRECTION'left) = 'A') or (LPM_DIRECTION(LPM_DIRECTION'left) = 'a') or 
             (LPM_DIRECTION(LPM_DIRECTION'left) = 'S') or (LPM_DIRECTION(LPM_DIRECTION'left) = 's')) and
             ((LPM_PIPELINE > 0))) generate
      ULPM : synplicity_lpm_add_sub_clk
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_REPRESENTATION => LPM_REPRESENTATION, 
                      LPM_DIRECTION => LPM_DIRECTION, LPM_PIPELINE => LPM_PIPELINE, 
                      LPM_TYPE => LPM_TYPE, LPM_HINT => LPM_HINT)
         port map (dataa => dataa, datab => datab, aclr => aclr, clock => clock, cin => cin, 
                   result => result, cout => cout, overflow => overflow);
   end generate U2;
   U3 : if (((LPM_DIRECTION(LPM_DIRECTION'left) = 'U') or (LPM_DIRECTION(LPM_DIRECTION'left) = 'u') or 
             (LPM_DIRECTION(LPM_DIRECTION'left) = 'D') or (LPM_DIRECTION(LPM_DIRECTION'left) = 'd')) and
             ((LPM_PIPELINE = 0))) generate
      ULPM : synplicity_lpm_add_sub_dir
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_REPRESENTATION => LPM_REPRESENTATION, 
                      LPM_DIRECTION => LPM_DIRECTION, LPM_PIPELINE => LPM_PIPELINE, 
                      LPM_TYPE => LPM_TYPE, LPM_HINT => LPM_HINT)
         port map (dataa => dataa, datab => datab, cin => cin, 
                   add_sub => add_sub, result => result, cout => cout, overflow => overflow);
   end generate U3;
   U4 : if (((LPM_DIRECTION(LPM_DIRECTION'left) = 'A') or (LPM_DIRECTION(LPM_DIRECTION'left) = 'a') or 
             (LPM_DIRECTION(LPM_DIRECTION'left) = 'S') or (LPM_DIRECTION(LPM_DIRECTION'left) = 's')) and
             ((LPM_PIPELINE = 0))) generate
      ULPM : synplicity_lpm_add_sub
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_REPRESENTATION => LPM_REPRESENTATION, 
                      LPM_DIRECTION => LPM_DIRECTION, LPM_PIPELINE => LPM_PIPELINE, 
                      LPM_TYPE => LPM_TYPE, LPM_HINT => LPM_HINT)
         port map (dataa => dataa, datab => datab, cin => cin, 
                   result => result, cout => cout, overflow => overflow);
   end generate U4;
end architecture bb;

--------------LPM_COMPARE Entities--------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_compare_clk is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_COMPARE";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      agb: out STD_LOGIC;
      ageb : out STD_LOGIC;
      aeb: out STD_LOGIC;
      aneb : out STD_LOGIC;
      alb: out STD_LOGIC;
      aleb : out STD_LOGIC);
end entity synplicity_lpm_compare_clk;
architecture bb of synplicity_lpm_compare_clk is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_REPRESENTATION\ : STRING;
attribute \LPM_REPRESENTATION\ of all : architecture is LPM_REPRESENTATION;
attribute \LPM_PIPELINE\ : INTEGER;
attribute \LPM_PIPELINE\ of all : architecture is LPM_PIPELINE;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_compare is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_COMPARE";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      agb: out STD_LOGIC;
      ageb : out STD_LOGIC;
      aeb: out STD_LOGIC;
      aneb : out STD_LOGIC;
      alb: out STD_LOGIC;
      aleb : out STD_LOGIC);
end entity synplicity_lpm_compare;
architecture bb of synplicity_lpm_compare is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_REPRESENTATION\ : STRING;
attribute \LPM_REPRESENTATION\ of all : architecture is LPM_REPRESENTATION;
attribute \LPM_PIPELINE\ : INTEGER;
attribute \LPM_PIPELINE\ of all : architecture is LPM_PIPELINE;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is LPM_WIDTH;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library lpm_old;
use lpm_old.lpm_old_components.all;
entity lpm_compare is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_COMPARE";
      LPM_HINT : STRING := "UNUSED");
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      agb: out STD_LOGIC;
      ageb : out STD_LOGIC;
      aeb: out STD_LOGIC;
      aneb : out STD_LOGIC;
      alb: out STD_LOGIC;
      aleb : out STD_LOGIC);
end entity lpm_compare;
architecture bb of lpm_compare is
begin
   U1 : if (LPM_PIPELINE = 0) generate
      ULPM : synplicity_lpm_compare
            generic map (LPM_WIDTH => LPM_WIDTH, LPM_REPRESENTATION => LPM_REPRESENTATION, 
                         LPM_PIPELINE => LPM_PIPELINE, LPM_TYPE => LPM_TYPE, LPM_HINT => LPM_HINT)
            port map (dataa => dataa, datab => datab, agb => agb, ageb => ageb, aeb => aeb,
                      aneb => aneb, alb => alb, aleb => aleb);
   end generate U1;
   U2 : if (LPM_PIPELINE > 0) generate
      ULPM : synplicity_lpm_compare_clk
            generic map (LPM_WIDTH => LPM_WIDTH, LPM_REPRESENTATION => LPM_REPRESENTATION, 
                         LPM_PIPELINE => LPM_PIPELINE, LPM_TYPE => LPM_TYPE, LPM_HINT => LPM_HINT)
            port map (dataa => dataa, datab => datab, aclr => aclr, clock => clock, agb => agb, 
                      ageb => ageb, aeb => aeb, aneb => aneb, alb => alb, aleb => aleb);
   end generate U2;
end architecture bb;

--------------LPM_COUNTER Entities--------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_counter_ud is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_MODULUS: STRING := "UNUSED";
      LPM_AVALUE: STRING := "UNUSED";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_TYPE: STRING := "LPM_COUNTER";
      LPM_HINT : STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
      clock: IN STD_LOGIC;
      clk_en: IN STD_LOGIC := '1';
      cnt_en: IN STD_LOGIC := '1';
      updown: IN STD_LOGIC := '1';
      sload: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      eq: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_counter_ud;
architecture bb of synplicity_lpm_counter_ud is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_MODULUS\ : STRING;
attribute \LPM_MODULUS\ of all : architecture is LPM_MODULUS;
attribute \LPM_AVALUE\ : STRING;
attribute \LPM_AVALUE\ of all : architecture is LPM_AVALUE;
attribute \LPM_SVALUE\ : STRING;
attribute \LPM_SVALUE\ of all : architecture is LPM_SVALUE;
attribute \LPM_DIRECTION\ : STRING;
attribute \LPM_DIRECTION\ of all : architecture is LPM_DIRECTION;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is (2 * LPM_WIDTH);
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_counter is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_MODULUS: STRING := "UNUSED";
      LPM_AVALUE: STRING := "UNUSED";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_TYPE: STRING := "LPM_COUNTER";
      LPM_HINT : STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
      clock: IN STD_LOGIC;
      clk_en: IN STD_LOGIC := '1';
      cnt_en: IN STD_LOGIC := '1';
      sload: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      eq: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_counter;
architecture bb of synplicity_lpm_counter is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_MODULUS\ : STRING;
attribute \LPM_MODULUS\ of all : architecture is LPM_MODULUS;
attribute \LPM_AVALUE\ : STRING;
attribute \LPM_AVALUE\ of all : architecture is LPM_AVALUE;
attribute \LPM_SVALUE\ : STRING;
attribute \LPM_SVALUE\ of all : architecture is LPM_SVALUE;
attribute \LPM_DIRECTION\ : STRING;
attribute \LPM_DIRECTION\ of all : architecture is LPM_DIRECTION;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is (2 * LPM_WIDTH);
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library lpm_old;
use lpm_old.lpm_old_components.all;
entity lpm_counter is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_MODULUS: STRING := "UNUSED";
      LPM_AVALUE: STRING := "UNUSED";
      LPM_SVALUE: STRING := "UNUSED";
      LPM_DIRECTION: STRING := "UNUSED";
      LPM_TYPE: STRING := "LPM_COUNTER";
      LPM_HINT : STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
      clock: IN STD_LOGIC;
      clk_en: IN STD_LOGIC := '1';
      cnt_en: IN STD_LOGIC := '1';
      updown: IN STD_LOGIC := '1';
      sload: IN STD_LOGIC := '0';
      sset: IN STD_LOGIC := '0';
      sclr: IN STD_LOGIC := '0';
      aload: IN STD_LOGIC := '0';
      aset: IN STD_LOGIC := '0';
      aclr: IN STD_LOGIC := '0';
      eq: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity lpm_counter;
architecture bb of lpm_counter is
begin
   U1 : if ((LPM_DIRECTION(LPM_DIRECTION'left + 1) = 'N') or (LPM_DIRECTION(LPM_DIRECTION'left + 1) = 'n')) generate
      ULPM : synplicity_lpm_counter_ud
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_MODULUS => LPM_MODULUS, LPM_AVALUE => LPM_AVALUE, 
                      LPM_SVALUE => LPM_SVALUE, LPM_DIRECTION => LPM_DIRECTION, LPM_TYPE => LPM_TYPE, 
                      LPM_HINT => LPM_HINT)
         port map (data => data, clock => clock, clk_en => clk_en, cnt_en => cnt_en, updown => updown, 
                   sload => sload, sset => sset, sclr => sclr, aload => aload, aset => aset, 
                   aclr => aclr, eq => eq, q => q);
   end generate U1;
   U2 : if (((LPM_DIRECTION(LPM_DIRECTION'left + 1) = 'P') or (LPM_DIRECTION(LPM_DIRECTION'left + 1) = 'p') or 
             (LPM_DIRECTION(LPM_DIRECTION'left + 1) = 'O') or (LPM_DIRECTION(LPM_DIRECTION'left + 1) = 'o'))) generate
      ULPM : synplicity_lpm_counter
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_MODULUS => LPM_MODULUS, LPM_AVALUE => LPM_AVALUE, 
                      LPM_SVALUE => LPM_SVALUE, LPM_DIRECTION => LPM_DIRECTION, LPM_TYPE => LPM_TYPE, 
                      LPM_HINT => LPM_HINT)
         port map (data => data, clock => clock, clk_en => clk_en, cnt_en => cnt_en,
                   sload => sload, sset => sset, sclr => sclr, aload => aload, aset => aset, 
                   aclr => aclr, eq => eq, q => q);
   end generate U2;
end architecture bb;

--------------LPM_MULT Entities-----------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_mult_clk is
   GENERIC (LPM_WIDTHA: POSITIVE;
      LPM_WIDTHB: POSITIVE;
      LPM_WIDTHS: POSITIVE;
      LPM_WIDTHP: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_MULT";
      LPM_HINT : STRING := "UNUSED";
      MAXIMIZE_SPEED :INTEGER := 5);
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTHA-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTHB-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      sum: IN STD_LOGIC_VECTOR(LPM_WIDTHS-1 DOWNTO 0) := (OTHERS => '0');
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTHP-1 DOWNTO 0));
end entity synplicity_lpm_mult_clk;
architecture bb of synplicity_lpm_mult_clk is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTHA\ : POSITIVE;
attribute \LPM_WIDTHA\ of all : architecture is LPM_WIDTHA;
attribute \LPM_WIDTHB\ : POSITIVE;
attribute \LPM_WIDTHB\ of all : architecture is LPM_WIDTHB;
attribute \LPM_WIDTHS\ : POSITIVE;
attribute \LPM_WIDTHS\ of all : architecture is LPM_WIDTHS;
attribute \LPM_WIDTHP\ : POSITIVE;
attribute \LPM_WIDTHP\ of all : architecture is LPM_WIDTHP;
attribute \LPM_REPRESENTATION\ : STRING;
attribute \LPM_REPRESENTATION\ of all : architecture is LPM_REPRESENTATION;
attribute \LPM_PIPELINE\ : INTEGER;
attribute \LPM_PIPELINE\ of all : architecture is LPM_PIPELINE;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute \MAXIMIZE_SPEED\ : INTEGER;
attribute \MAXIMIZE_SPEED\ of all : architecture is MAXIMIZE_SPEED;
attribute altera_area : integer;
attribute altera_area of all : architecture is ((LPM_WIDTHP**2)/2);
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_mult is
   GENERIC (LPM_WIDTHA: POSITIVE;
      LPM_WIDTHB: POSITIVE;
      LPM_WIDTHS: POSITIVE;
      LPM_WIDTHP: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_MULT";
      LPM_HINT : STRING := "UNUSED";
      MAXIMIZE_SPEED :INTEGER := 5);
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTHA-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTHB-1 DOWNTO 0);
      sum: IN STD_LOGIC_VECTOR(LPM_WIDTHS-1 DOWNTO 0) := (OTHERS => '0');
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTHP-1 DOWNTO 0));
end entity synplicity_lpm_mult;
architecture bb of synplicity_lpm_mult is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTHA\ : POSITIVE;
attribute \LPM_WIDTHA\ of all : architecture is LPM_WIDTHA;
attribute \LPM_WIDTHB\ : POSITIVE;
attribute \LPM_WIDTHB\ of all : architecture is LPM_WIDTHB;
attribute \LPM_WIDTHS\ : POSITIVE;
attribute \LPM_WIDTHS\ of all : architecture is LPM_WIDTHS;
attribute \LPM_WIDTHP\ : POSITIVE;
attribute \LPM_WIDTHP\ of all : architecture is LPM_WIDTHP;
attribute \LPM_REPRESENTATION\ : STRING;
attribute \LPM_REPRESENTATION\ of all : architecture is LPM_REPRESENTATION;
attribute \LPM_PIPELINE\ : INTEGER;
attribute \LPM_PIPELINE\ of all : architecture is LPM_PIPELINE;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute \MAXIMIZE_SPEED\ : INTEGER;
attribute \MAXIMIZE_SPEED\ of all : architecture is MAXIMIZE_SPEED;
attribute altera_area : integer;
attribute altera_area of all : architecture is ((LPM_WIDTHP**2)/2);
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library lpm_old;
use lpm_old.lpm_old_components.all;
entity lpm_mult is
   GENERIC (LPM_WIDTHA: POSITIVE;
      LPM_WIDTHB: POSITIVE;
      LPM_WIDTHS: POSITIVE;
      LPM_WIDTHP: POSITIVE;
      LPM_REPRESENTATION: STRING := "UNSIGNED";
      LPM_PIPELINE: INTEGER := 0;
      LPM_TYPE: STRING := "LPM_MULT";
      LPM_HINT : STRING := "UNUSED";
      MAXIMIZE_SPEED :INTEGER := 5);
   PORT (dataa: IN STD_LOGIC_VECTOR(LPM_WIDTHA-1 DOWNTO 0);
      datab: IN STD_LOGIC_VECTOR(LPM_WIDTHB-1 DOWNTO 0);
      aclr: IN STD_LOGIC := '0';
      clock: IN STD_LOGIC := '0';
      sum: IN STD_LOGIC_VECTOR(LPM_WIDTHS-1 DOWNTO 0) := (OTHERS => '0');
      result: OUT STD_LOGIC_VECTOR(LPM_WIDTHP-1 DOWNTO 0));
end entity lpm_mult;
architecture bb of lpm_mult is
begin
   U1 : if (LPM_PIPELINE = 0) generate
      ULPM : synplicity_lpm_mult
            generic map (LPM_WIDTHA => LPM_WIDTHA, LPM_WIDTHB => LPM_WIDTHB, LPM_WIDTHS => LPM_WIDTHS,
                         LPM_WIDTHP => LPM_WIDTHP, LPM_REPRESENTATION => LPM_REPRESENTATION, 
						 LPM_PIPELINE => LPM_PIPELINE, LPM_TYPE => LPM_TYPE, LPM_HINT => LPM_HINT, MAXIMIZE_SPEED => MAXIMIZE_SPEED)
            port map (dataa => dataa, datab => datab, sum => sum, result => result);
   end generate U1;
   U2 : if (LPM_PIPELINE > 0) generate
      ULPM : synplicity_lpm_mult_clk
            generic map (LPM_WIDTHA => LPM_WIDTHA, LPM_WIDTHB => LPM_WIDTHB, LPM_WIDTHS => LPM_WIDTHS,
                         LPM_WIDTHP => LPM_WIDTHP, LPM_REPRESENTATION => LPM_REPRESENTATION, 
						 LPM_PIPELINE => LPM_PIPELINE, LPM_TYPE => LPM_TYPE, LPM_HINT => LPM_HINT, MAXIMIZE_SPEED => MAXIMIZE_SPEED )
            port map (dataa => dataa, datab => datab, aclr => aclr, clock => clock, sum => sum, result => result);
   end generate U2;
end architecture bb;

--------------LPM_RAM_DP Entities-----------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_dp_reg_in_reg_out is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_WIDTHAD: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DP";
      LPM_NUMWORDS: POSITIVE;
      LPM_INDATA: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_RDADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_WRADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_FILE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      rdaddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      wraddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      rdclken: IN STD_LOGIC := '1';
      wrclken: IN STD_LOGIC := '1';
      rden: IN STD_LOGIC;
      wren: IN STD_LOGIC;
      rdclock: IN STD_LOGIC := '0';
      wrclock: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_dp_reg_in_reg_out;
architecture bb of synplicity_lpm_ram_dp_reg_in_reg_out is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_RDADDRESS_CONTROL\ : STRING;
attribute \LPM_RDADDRESS_CONTROL\ of all : architecture is LPM_RDADDRESS_CONTROL;
attribute \LPM_WRADDRESS_CONTROL\ : STRING;
attribute \LPM_WRADDRESS_CONTROL\ of all : architecture is LPM_WRADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_dp_reg_in is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_WIDTHAD: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DP";
      LPM_NUMWORDS: POSITIVE;
      LPM_INDATA: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_RDADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_WRADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_FILE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      wraddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
	  rdaddress:IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 downto 0);
	  rden : IN STD_LOGIC;
      wrclken: IN STD_LOGIC := '1';
      wren: IN STD_LOGIC;
      wrclock: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_dp_reg_in;
architecture bb of synplicity_lpm_ram_dp_reg_in is
attribute syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_RDADDRESS_CONTROL\ : STRING;
attribute \LPM_RDADDRESS_CONTROL\ of all : architecture is LPM_RDADDRESS_CONTROL;
attribute \LPM_WRADDRESS_CONTROL\ : STRING;
attribute \LPM_WRADDRESS_CONTROL\ of all : architecture is LPM_WRADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_dp_reg_out is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_WIDTHAD: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DP";
      LPM_NUMWORDS: POSITIVE;
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_RDADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_WRADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_FILE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      rdaddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
	  wraddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      rdclken: IN STD_LOGIC := '1';
      rden: IN STD_LOGIC;
	  wren: IN STD_LOGIC;
      rdclock: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));   
end entity synplicity_lpm_ram_dp_reg_out;
architecture bb of synplicity_lpm_ram_dp_reg_out is
attribute syn_syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_RDADDRESS_CONTROL\ : STRING;
attribute \LPM_RDADDRESS_CONTROL\ of all : architecture is LPM_RDADDRESS_CONTROL;
attribute \LPM_WRADDRESS_CONTROL\ : STRING;
attribute \LPM_WRADDRESS_CONTROL\ of all : architecture is LPM_WRADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity synplicity_lpm_ram_dp is
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_WIDTHAD: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DP";
      LPM_NUMWORDS: POSITIVE;
      LPM_INDATA: STRING := "UNREGISTERED";
      LPM_OUTDATA: STRING := "UNREGISTERED";
      LPM_RDADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_WRADDRESS_CONTROL: STRING := "UNREGISTERED";
      LPM_FILE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
     	rdaddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      	wraddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      	rden: IN STD_LOGIC;
      	wren: IN STD_LOGIC;
      	q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity synplicity_lpm_ram_dp;
architecture bb of synplicity_lpm_ram_dp is
attribute syn_syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_TYPE\ : STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_WIDTHAD\ : POSITIVE;
attribute \LPM_WIDTHAD\ of all : architecture is LPM_WIDTHAD;
attribute \LPM_NUMWORDS\ : POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_FILE\ : STRING;
attribute \LPM_FILE\ of all : architecture is LPM_FILE;
attribute \LPM_INDATA\ : STRING;
attribute \LPM_INDATA\ of all : architecture is LPM_INDATA;
attribute \LPM_RDADDRESS_CONTROL\ : STRING;
attribute \LPM_RDADDRESS_CONTROL\ of all : architecture is LPM_RDADDRESS_CONTROL;
attribute \LPM_WRADDRESS_CONTROL\ : STRING;
attribute \LPM_WRADDRESS_CONTROL\ of all : architecture is LPM_WRADDRESS_CONTROL;
attribute \LPM_OUTDATA\ : STRING;
attribute \LPM_OUTDATA\ of all : architecture is LPM_OUTDATA;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute altera_area : integer;
attribute altera_area of all : architecture is 0;
begin
end architecture bb;

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
library lpm_old;
use lpm_old.lpm_old_components.all;
entity lpm_ram_dp is
   GENERIC ( LPM_WIDTH: POSITIVE;
      LPM_WIDTHAD: POSITIVE;
      LPM_TYPE: STRING := "LPM_RAM_DP";
      LPM_NUMWORDS: POSITIVE := 99999999;
      LPM_INDATA: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_RDADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_WRADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_FILE: STRING := "UNUSED";
      LPM_HINT: STRING := "UNUSED");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      rdaddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      wraddress: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      rdclken: IN STD_LOGIC := '1';
      wrclken: IN STD_LOGIC := '1';
      rden: IN STD_LOGIC;
      wren: IN STD_LOGIC;
      rdclock: IN STD_LOGIC := '0';
      wrclock: IN STD_LOGIC := '0';
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
end entity lpm_ram_dp;
architecture bb of lpm_ram_dp is
type pos_arr is array (0 to 1) of positive;
constant numword_arr : pos_arr := (LPM_NUMWORDS, 2**LPM_WIDTHAD);
constant numword_index : integer := (LPM_NUMWORDS / 99999999);
constant numwords : positive := numword_arr(numword_index);
begin
   U1 : if (
   			 (LPM_INDATA(LPM_INDATA'left) = 'R') or (LPM_INDATA(LPM_INDATA'left) = 'r') or
             (LPM_WRADDRESS_CONTROL(LPM_WRADDRESS_CONTROL'left) = 'R') or (LPM_WRADDRESS_CONTROL(LPM_WRADDRESS_CONTROL'left) = 'r')) and
             ((LPM_OUTDATA(LPM_OUTDATA'left) = 'R') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'r') or 
	     	 (LPM_RDADDRESS_CONTROL(LPM_RDADDRESS_CONTROL'left) = 'R') or 
	     	 (LPM_RDADDRESS_CONTROL(LPM_RDADDRESS_CONTROL'left) = 'r'))
			 generate

      ULPM : synplicity_lpm_ram_dp_reg_in_reg_out
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA,
                      LPM_WRADDRESS_CONTROL => LPM_WRADDRESS_CONTROL, LPM_OUTDATA => LPM_OUTDATA, 
		       LPM_RDADDRESS_CONTROL => LPM_RDADDRESS_CONTROL,  LPM_HINT => LPM_HINT)
         port map (data => data, wraddress =>wraddress, rdaddress => rdaddress,
                   rdclken => rdclken, wrclken => wrclken, rden => rden, wren => wren,
		   	 rdclock => rdclock, wrclock => wrclock, q => q);
   end generate U1;
   
 

U2:	if (
   			 (LPM_INDATA(LPM_INDATA'left) = 'R') or (LPM_INDATA(LPM_INDATA'left) = 'r') or
             (LPM_WRADDRESS_CONTROL(LPM_WRADDRESS_CONTROL'left) = 'R') or (LPM_WRADDRESS_CONTROL(LPM_WRADDRESS_CONTROL'left) = 'r')) and
             ((LPM_OUTDATA(LPM_OUTDATA'left) = 'U') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'u') or 
	     	 (LPM_RDADDRESS_CONTROL(LPM_RDADDRESS_CONTROL'left) = 'U') or 
	     	 (LPM_RDADDRESS_CONTROL(LPM_RDADDRESS_CONTROL'left) = 'u'))
			 generate
      ULPM : synplicity_lpm_ram_dp_reg_in

        generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA, 
                     LPM_WRADDRESS_CONTROL => LPM_WRADDRESS_CONTROL, LPM_RDADDRESS_CONTROL => LPM_RDADDRESS_CONTROL, 
			    LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (data => data, wraddress => wraddress, rdaddress => rdaddress, rden => rden,
                wren => wren, wrclock => wrclock, wrclken => wrclken, q => q);
   end generate U2;

   
U3:	  if (
   			 (LPM_INDATA(LPM_INDATA'left) = 'U') or (LPM_INDATA(LPM_INDATA'left) = 'u') or
             (LPM_WRADDRESS_CONTROL(LPM_WRADDRESS_CONTROL'left) = 'U') or (LPM_WRADDRESS_CONTROL(LPM_WRADDRESS_CONTROL'left) = 'u')) and
             ((LPM_OUTDATA(LPM_OUTDATA'left) = 'R') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'r') or 
	     	 (LPM_RDADDRESS_CONTROL(LPM_RDADDRESS_CONTROL'left) = 'R') or 
	     	 (LPM_RDADDRESS_CONTROL(LPM_RDADDRESS_CONTROL'left) = 'r'))
			 generate
      ULPM : synplicity_lpm_ram_dp_reg_out

         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                     LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA, 
                      LPM_WRADDRESS_CONTROL => LPM_WRADDRESS_CONTROL, LPM_RDADDRESS_CONTROL => LPM_RDADDRESS_CONTROL, 
	      LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
       port map (data => data, rdaddress => rdaddress, wraddress => wraddress , wren => wren, 
                  rden => rden, rdclock => rdclock, rdclken=> rdclken,  q => q);
   end generate U3;
   


 U4:  if (
   			 (LPM_INDATA(LPM_INDATA'left) = 'U') or (LPM_INDATA(LPM_INDATA'left) = 'u') or
             (LPM_WRADDRESS_CONTROL(LPM_WRADDRESS_CONTROL'left) = 'U') or (LPM_WRADDRESS_CONTROL(LPM_WRADDRESS_CONTROL'left) = 'u')) and
             ((LPM_OUTDATA(LPM_OUTDATA'left) = 'U') or (LPM_OUTDATA(LPM_OUTDATA'left) = 'u') or 
	     	 (LPM_RDADDRESS_CONTROL(LPM_RDADDRESS_CONTROL'left) = 'U') or 
	     	 (LPM_RDADDRESS_CONTROL(LPM_RDADDRESS_CONTROL'left) = 'u'))
			 generate
    ULPM : synplicity_lpm_ram_dp
         generic map (LPM_WIDTH => LPM_WIDTH, LPM_TYPE => LPM_TYPE, LPM_WIDTHAD => LPM_WIDTHAD,
                      LPM_NUMWORDS => numwords, LPM_FILE => LPM_FILE, LPM_INDATA => LPM_INDATA, 
                      LPM_WRADDRESS_CONTROL => LPM_WRADDRESS_CONTROL, LPM_RDADDRESS_CONTROL => LPM_RDADDRESS_CONTROL,
		     LPM_OUTDATA => LPM_OUTDATA, LPM_HINT => LPM_HINT)
         port map (data => data, wraddress => wraddress, rdaddress => rdaddress,
                   wren => wren, rden => rden, q => q);
   end generate U4;
end bb;

--------------LPM_FIFO_DC ENTITIES-------------------------------

library ieee;
use ieee.std_logic_1164.all;
library synplify;
use synplify.attributes.all;
entity LPM_FIFO_DC is 
 GENERIC (LPM_WIDTH: POSITIVE;
 		  LPM_WIDTHU: POSITIVE:= 1;
		  LPM_NUMWORDS: POSITIVE;
		  LPM_SHOWAHEAD: STRING := "OFF";
		  LPM_TYPE : STRING := "LPM_FIFO_DC";
		  LPM_HINT : STRING := "UNUSED";
		  OVERFLOW_CHECKING: STRING := "ON";
		  UNDERFLOW_CHECKING: STRING := "ON";
		  DELAY_RDUSEDW :POSITIVE := 1;
		  DELAY_WRUSEDW : POSITIVE := 1;
		  RDSYNC_DELAYPIPE : POSITIVE := 3;
		  WRSYNC_DELAYPIPE : POSITIVE := 3);
  PORT ( data : in std_logic_vector (LPM_WIDTH-1 downto 0);
  		 rdclock, wrclock, wrreq, rdreq, aclr: in std_logic;
		 rdfull, wrfull, wrempty, rdempty : out std_logic;
		 q :out std_logic_vector (LPM_WIDTH-1 downto 0);
		 rdusedw, wrusedw : out std_logic_vector (LPM_WIDTHU-1 downto 0));
   
end LPM_FIFO_DC;
architecture bb of LPM_FIFO_DC is 
attribute syn_syn_black_box of all : architecture is true;
attribute \LPM_WIDTH\ : POSITIVE;
attribute \LPM_WIDTH\ of all : architecture is LPM_WIDTH;
attribute \LPM_WIDTHU\ : POSITIVE;
attribute \LPM_WIDTHU\ of all : architecture is LPM_WIDTHU;
attribute \LPM_NUMWORDS\ :POSITIVE;
attribute \LPM_NUMWORDS\ of all : architecture is LPM_NUMWORDS;
attribute \LPM_SHOWAHEAD\ : STRING;
attribute \LPM_SHOWAHEAD\ of all : architecture is LPM_SHOWAHEAD;
attribute \LPM_TYPE\ :STRING;
attribute \LPM_TYPE\ of all : architecture is LPM_TYPE;
attribute \LPM_HINT\ : STRING;
attribute \LPM_HINT\ of all : architecture is LPM_HINT;
attribute \OVERFLOW_CHECKING\ : STRING;
attribute \OVERFLOW_CHECKING\ of all : architecture is OVERFLOW_CHECKING;
attribute \UNDERFLOW_CHECKING\ : STRING;
attribute \UNDERFLOW_CHECKING\ of all : architecture is UNDERFLOW_CHECKING;
attribute \DELAY_RDUSEDW\ :POSITIVE ;
attribute \DELAY_RDUSEDW\ of all : architecture is DELAY_RDUSEDW;
attribute \DELAY_WRUSEDW\ : POSITIVE;
attribute \DELAY_WRUSEDW\ of all : architecture is DELAY_WRUSEDW;
attribute \RDSYNC_DELAYPIPE\ : POSITIVE;
attribute \RDSYNC_DELAYPIPE\ of all : architecture is RDSYNC_DELAYPIPE;
attribute \WRSYNC_DELAYPIPE\ : POSITIVE;
attribute \WRSYNC_DELAYPIPE\ of all : architecture is WRSYNC_DELAYPIPE;
begin
end bb;