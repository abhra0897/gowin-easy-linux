
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE snps_haps_pkg IS

  -- UMR capim
  COMPONENT capim
    GENERIC (
      UMR_CAPIM_ADDRESS :     INTEGER RANGE 1 TO 63; 
      UMR_CAPIM_TYPE    :     INTEGER RANGE 1 TO 65535; -- User Valid 32768 to 65535; range 1 to 32767 reserved 
      UMR_DATA_BITWIDTH :     INTEGER RANGE 1 TO 32 := 8; -- 8 for HAPS-60; 32 for HAPS-50
      UMR_CAPIM_COMMENT_STRING : string := "-" --Allow user to specify the use of capim 
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
      inttype           : IN  STD_LOGIC_VECTOR(15 DOWNTO 0)
	 );
  END COMPONENT;

 -- UMR capim wrapper, with only user side ports
  COMPONENT capim_ez
    GENERIC (
      UMR_CAPIM_ADDRESS :     INTEGER RANGE 1 TO 63; 
      UMR_CAPIM_TYPE    :     INTEGER RANGE 1 TO 65535; -- User Valid 32768 to 65535; range 1 to 32767 reserved 
      UMR_DATA_BITWIDTH :     INTEGER RANGE 1 TO 32 := 8; -- 8 for HAPS-60; 32 for HAPS-50
      UMR_CAPIM_COMMENT_STRING : string := "-" --Allow user to specify the use of capim 
	);
    PORT (
      wr                : OUT STD_LOGIC;
      dout              : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rd                : OUT STD_LOGIC;
      din               : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      intr              : IN  STD_LOGIC;
      inta              : OUT STD_LOGIC;
      inttype           : IN  STD_LOGIC_VECTOR(15 DOWNTO 0)
	 );
  END COMPONENT;

-- Hyper Connects to drive UMR clock and reset
 COMPONENT umr_clk_reset IS PORT (
	umr_clk_out : OUT STD_LOGIC;
 	umr_reset_out : OUT STD_LOGIC
	);
 END COMPONENT;

  -- SCEMI Related Components
  COMPONENT SceMiClockControl
    GENERIC(
      ClockNum               :     INTEGER := 1
      );
    PORT(
      Uclock                 : OUT STD_LOGIC;
      Ureset                 : OUT STD_LOGIC;
      ReadyForCclock         : IN  STD_LOGIC;
      CclockEnabled          : OUT STD_LOGIC;
      ReadyForCclockNegEdge  : IN  STD_LOGIC;
      CclockNegEdgeEnabled   : OUT STD_LOGIC;
      IS_CclockControl_in    : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
      IS_CclockControl_out   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
      );
  END COMPONENT;
  
  COMPONENT SceMiClockPort
    GENERIC(
      ClockNum               :     INTEGER := 1;
      RatioNumerator         :     INTEGER := 1;
      RatioDenominator       :     INTEGER := 1;
      DutyHi                 :     INTEGER := 0;
      DutyLo                 :     INTEGER := 100;
      Phase                  :     INTEGER := 0;
      ResetCycles            :     INTEGER := 8
      );
    PORT(
      Cclock                 : OUT STD_LOGIC;
      Creset                 : OUT STD_LOGIC;
      IS_CclockCReset_in     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0)
      );
  END COMPONENT;
    COMPONENT SceMiClockPortP
    GENERIC(
      ClockNum               :     INTEGER := 1;
      ClockPeriod         :     STRING := "100 ns";
      DutyHi                 :     INTEGER := 0;
      DutyLo                 :     INTEGER := 100;
      Phase                  :     INTEGER := 0;
      ResetCycles            :     INTEGER := 8
      );
    PORT(
      Cclock                 : OUT STD_LOGIC;
      Creset                 : OUT STD_LOGIC;
      IS_CclockCReset_in     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0)
      );
  END COMPONENT;
  
  COMPONENT SceMiMessageInPort
    GENERIC(
      PortWidth : integer := 0;
      PortAddr  : integer range 0 to 65535 := 0);
    PORT(
      ReceiveReady  : in  std_logic;
      TransmitReady : out std_logic;
      Message       : out std_logic_vector(PortWidth - 1 downto 0);
      umr_clock     : in  std_logic;
      UReset        : in  std_logic;
      UClock        : in  std_logic;
      IS_Bus_in     : in  std_logic_vector(51 downto 0);
      IS_Bus_out    : out std_logic_vector(51 downto 0));
  END COMPONENT;
  
  COMPONENT SceMiMessageOutPort
  generic (
    PortWidth : positive                 := 1;
    PortAddr  : integer range 0 to 65535 := 0);
  port (
    ReceiveReady  : out std_logic;
    TransmitReady : in  std_logic;
    Message       : in  std_logic_vector(PortWidth - 1 downto 0);
    UReset        : in  std_logic;
    UClock        : in  std_logic;
    CReset        : in  std_logic;
    CClock        : in  std_logic;
    umr_clock     : in  std_logic;
    IS_Bus_in     : in  std_logic_vector(51 downto 0);
    IS_Bus_out    : out std_logic_vector(51 downto 0));
  END COMPONENT;

END snps_haps_pkg;

