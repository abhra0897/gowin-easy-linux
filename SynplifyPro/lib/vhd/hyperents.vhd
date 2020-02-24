--
-- This file contains entity used for SRS instrumentation
-- Specific to Synopsys. 
-- Copyright (c) 2011, Synopsys, Inc. All rights reserved

-- syn_hyper_source
-- connect to a signal you want to export

library ieee ;
use ieee.std_logic_1164.all;

entity syn_hyper_source is
	generic (
		w : integer := 1;	
		tag : string := "tag_name"
	);
	port (
		in1 : in std_logic_vector(w - 1 downto 0)
	);
end entity syn_hyper_source;

architecture beh of syn_hyper_source is
attribute syn_noprune : boolean;
attribute syn_noprune of beh : architecture is true;
begin
end architecture beh;

-- syn_hyper_connect
-- use to access hyper_source and drive a local signal or port

library ieee ;
use ieee.std_logic_1164.all;

entity syn_hyper_connect is
	generic (
		w : integer := 1;	
		tag : string := "tag_name";
		dflt : integer := 5;
		mustconnect : std_logic := '1'
	);
	port (
		out1 : out std_logic_vector(w - 1 downto 0)
	);
end entity syn_hyper_connect;

architecture beh of syn_hyper_connect is
attribute syn_noprune : boolean;
attribute syn_noprune of beh : architecture is true;
begin
end architecture beh;

----------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;

-- This entity is for internal use of the tool. Behavior is undefined, if this entity is instantiated in RTL.
entity syn_hyper_source_internal is
	generic (
		w : integer := 1
	);
	port (
		in1 : in std_logic_vector(w - 1 downto 0)
	);
end entity syn_hyper_source_internal;

architecture beh of syn_hyper_source_internal is
attribute syn_noprune : boolean;
attribute syn_noprune of beh : architecture is true;
begin
end architecture beh;

library ieee ;
use ieee.std_logic_1164.all;

-- This entity is for internal use of the tool. Behavior is undefined, if this entity is instantiated in RTL.
entity syn_hyper_connect_internal is
	generic (
		w : integer := 1
	);
	port (
		out1 : out std_logic_vector(w - 1 downto 0)
	);
end entity syn_hyper_connect_internal;

architecture beh of syn_hyper_connect_internal is
attribute syn_noprune : boolean;
attribute syn_noprune of beh : architecture is true;
attribute mustconnect : std_logic;
attribute mustconnect of beh : architecture is 1;
attribute dflt : integer;
attribute dflt of beh : architecture is 5;
begin
end architecture beh;
