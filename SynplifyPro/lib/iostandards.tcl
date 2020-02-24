# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
# iostandards.tcl file is used to configure the io standards tab and 
# to define the valid io standards.
# $Header: //synplicity/ui2019q3p1/misc/iostandards.tcl#1 $

set pa3e "proasic3e*"
set pa3l "proasic3l*"
set pa3 "proasic3"
set pa "pa pa4m*"
set ax "axcelerator"
set fusion "fusion smartfusion*"
set actel "500k"
set microsemi "500k"
set igloo "igloo*"
set altera "max* flex* acex*"
set altera_retiming "flex* acex* apex* mercury* excalibur*"
set apex "apex20k apexii excalibur*"
set apexe "apex20kc apex20ke mercury* stratix* cyclone"
set apex20k "apex20k*"
set lattice "pLSI*"
set mach "mach* isp* gal*"
set quicklogic "pasic* quick* eclipse*"
set lucent "orca*"
set xilinx "xc* vir* spart*"
set virtex "vir* spartan*"
set virtex2 "virtex2*"
set virtex4 "virtex4*"
set virtex5 "virtex5* haps-5*"
set virtex6 "virtex6* spartan6* haps-6*"
set virtex7 "virtex7* haps-7* haps-dx"
set stratix "stratix"
set stratixii "stratixii"
set stratixgx "stratix-gx*"
set stratixiigx "stratixii-gx*"
set stratixiii "stratixiii"
set stratixiv "stratixiv"
set stratixv "stratixv"
set cyclone "cyclone"
set cycloneii "cycloneii"
set cycloneiii "cycloneiii"
set cycloneiv "cycloneiv*"
set cyclonev "cyclonev"
set arriav "arriav"
set arriagx "arria-gx"
set arriaii "arriaii*"
set arriaiigz "arriaii-gz*"
set max10 "max10"
set triscend "triscend*" 
set asic "asic*" 
set atmel "fpslic"
set sbt "sbtice65"
set arria10 "arria10"
set arriavgz "arriav-gz"
set stratix10 "stratix10"
set stratix20 "stratix20"
set cyclone10lp "cyclone10-lp"
set cyclone10gx "cyclone10-gx"
# set_col   <column tcl name> <choice list separated by spaces> 
# add_default_io_choices  {family} 



add_default_io_choices {actel}
    set_col {syn_io_slew} {low normal high}
    set_col {syn_io_drive} {low high pci}
    set_col {syn_io_termination} {pullup}
    set_col {syn_io_power} {low}
    set_col {syn_io_schmitt} {1}

add_default_io_choices {microsemi}
    set_col {syn_io_slew} {low normal high}
    set_col {syn_io_drive} {low high pci}
    set_col {syn_io_termination} {pullup}
    set_col {syn_io_power} {low}
    set_col {syn_io_schmitt} {1}

add_default_io_choices {pa}
    set_col {syn_io_slew} {low normal high}
    set_col {syn_io_drive} {low high pci}
    set_col {syn_io_termination} {pullup}
    set_col {syn_io_power} {low}
    set_col {syn_io_schmitt} {1}

add_default_io_choices {fusion}
    set_col {syn_io_slew} {low normal high}
    set_col {syn_io_drive} {low high pci}
    set_col {syn_io_termination} {pullup}
    set_col {syn_io_power} {low}
    set_col {syn_io_schmitt} {1}

add_default_io_choices {ax}
    set_col {syn_io_slew} {low normal high}
    set_col {syn_io_drive} {low high pci}
    set_col {syn_io_termination} {pullup}
    set_col {syn_io_power} {low}
    set_col {syn_io_schmitt} {1}

add_default_io_choices {igloo}
     set_col {syn_io_termination} {pullup pulldown}
     set_col {syn_io_slew} {low high}
     set_col {syn_io_drive} {2 4 6 8 12}
     set_col {syn_io_schmitt} {1}

add_default_io_choices {pa3e}
     set_col {syn_io_termination} {pullup pulldown}
     set_col {syn_io_slew} {low high}
     set_col {syn_io_drive} {2 4 6 8 12 24 36}
     
add_default_io_choices {pa3l}
     set_col {syn_io_termination} {pullup pulldown}
     set_col {syn_io_slew} {low high}
     set_col {syn_io_drive} {2 4 6 8 12 24 36}

add_default_io_choices {pa3}
     set_col {syn_io_termination} {pullup pulldown}
     set_col {syn_io_slew} {low high}
     set_col {syn_io_drive} {2 4 6 8 12}
     set_col {syn_io_schmitt} {1}
     
add_default_io_choices {xilinx}
    set_col {syn_io_slew} {slow fast}
    set_col {syn_io_drive} {2 4 6 8 12 16 24}
    set_col {syn_io_termination} {keeper pullup pulldown Thevenin}
    set_col {syn_io_dci} {DCI}
    set_col {syn_io_dv2} {DV2}
    
     
# add_io_standard  <I/O standard name > "family" <category> <Description of I/O standard>

# category 2

add_io_standard	{AGP1X} "$xilinx $stratix $stratixgx" {2} {Intel Corporation Accelerated Graphics Port}
add_io_standard	{AGP2X} "$xilinx $stratix $stratixgx" {2} {Intel Corporation Accelerated Graphics Port}

add_io_standard	{BLVDS_25} "$virtex4 $virtex2" {2} {Bus Differential transceiver}

add_io_standard	{CTT} "$xilinx $stratix $stratixgx" {2} {Center Tap Terminated - EIA/JEDEC Standard JESD8-4}
add_io_standard {DIFF_HSUL_12} "$virtex7" {2} {1.2 volt  - Differential High Speed Unterminated Logic - EIA/JEDEC Standard JESD8-22B}
add_io_standard	{DIFF_SSTL_2_Class_I} "$arriaiigz  $arriaii $cyclone $cycloneii $cycloneiii $cycloneiv $stratixii $stratixiigx $stratixgx $stratixiii $stratixiv $stratixv $arriav $cyclonev" {2} {2.5 volt - Pseudo Differential Stub Series Terminated Logic - EIA/JEDEC Standard JESD8-9A}
add_io_standard	{DIFF_SSTL_2_Class_II} "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratix $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev $virtex2 $virtex4 $virtex5 $virtex6 $virtex7" {2} {2.5 volt - Pseudo Differential Stub Series Terminated Logic - EIA/JEDEC Standard JESD8-9A}
add_io_standard {DIFF_SSTL_15} "$stratixv $arriav $virtex6 $virtex7 $max10 arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {Differential 1.5-V SSTL}

add_io_standard {DIFF_SSTL_18_Class_I}  "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev" {2} {1.8 volt - Differential Stub Series Terminated Logic - EIA/JEDEC Standard JESD8-6}
add_io_standard	{DIFF_SSTL_18_Class_II} "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev $virtex2 $virtex4 $virtex5 $virtex6 $virtex7" {2} {1.8 volt - Differential Stub Series Terminated Logic - EIA/JEDEC Standard JESD8-6}

add_io_standard {DIFF_HSTL_15_Class_I}  "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratix $stratixii  $stratixiigx $stratixgx $stratixiii $stratixiv $stratixv $arriav $cyclonev" {2} {1.5 volt - Differential High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}
add_io_standard	{DIFF_HSTL_15_Class_II} "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev $virtex2 $virtex4 $virtex6 $virtex7" {2} {1.5 volt  - Differential High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}

add_io_standard {DIFF_HSTL_18_Class_I}  "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev" {2} {1.8 volt - Differential High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-9A}
add_io_standard	{DIFF_HSTL_18_Class_II} "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev $virtex2 $virtex4 $virtex5 $virtex6 $virtex7" {2} {1.8 volt - Differential High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-9A}

add_io_standard	{GTL} "$xilinx $stratix $stratixgx" {2} {Gunning Transceiver Logic - EIA/JEDEC Standard JESD8-3}
add_io_standard	{GTL+} "$xilinx $stratix $stratixgx" {2} {Gunning Transceiver Logic Plus}
add_io_standard	{GTL+33} "$ax $igloo $fusion $pa3e $pa3l" {2} {Gunning Transceiver Logic Plus}
add_io_standard	{GTL+25} "$ax $igloo $fusion $pa3e $pa3l" {2} {Gunning Transceiver Logic Plus}
add_io_standard	{GTL25} "$pa3e $igloo $fusion $pa3l" {2} {Gunning Transceiver Logic - EIA/JEDEC Standard JESD8-3}
add_io_standard	{GTL33} "$pa3e $igloo $fusion $pa3l" {2} {Gunning Transceiver Logic - EIA/JEDEC Standard JESD8-3}


add_io_standard {HSTL_12}  "$stratixii" {2} {1.2 volt  - High Speed Transceiver Logic EIA/JEDEC Standard JESD8-6}
add_io_standard {HSTL_Class_I_12}  "$ax $igloo $fusion $pa3e $pa3l $stratixgx $stratixii $xilinx" {2} {1.5 volt - High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}
add_io_standard	{HSTL_Class_II} " $igloo $fusion $pa3e $pa3l $stratixgx $stratixii $xilinx" {2} {1.5 volt - High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}
add_io_standard	{HSTL_Class_III} "$xilinx" {2} {1.5 volt  - High Speed Transceiver Logic EIA/JEDEC Standard JESD8-6}
add_io_standard	{HSTL_Class_IV} "$xilinx" {2} {1.5 volt  - High Speed Transceiver Logic EIA/JEDEC Standard JESD8-6}
add_io_standard {HSTL_15_Class_I}  "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev" {2} {1.8 volt - High Speed Transceiver Logic }
add_io_standard	{HSTL_15_Class_II} "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev" {2} {1.8 volt - High Speed Transceiver Logic }
add_io_standard {HSTL_18_Class_I}  "$$arriaiigz arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev" {2} {1.8 volt  - High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}
add_io_standard	{HSTL_18_Class_II} "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev" {2} {1.8 volt  - High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}
#add_io_standard	{HSTL_18_Class_III}   "$xilinx" {2} {1.8 volt  - High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}
#add_io_standard	{HSTL_18_Class_IV} "$xilinx" {2} {1.8 volt  - High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}
add_io_standard {HSUL_12} "$virtex7" {2} {1.2 volt  - High Speed Unterminated Logic - EIA/JEDEC Standard JESD8-22B}

add_io_standard {HSTL_Class_I_18} "$xilinx" {2} {1.8 volt  - High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}
add_io_standard {HSTL_Class_II_18} "$xilinx" {2} {1.8 volt  - High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}
add_io_standard {HSTL_Class_III_18} "$xilinx" {2} {1.8 volt  - High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}
add_io_standard {HSTL_Class_IV_18} "$xilinx" {2} {1.8 volt  - High Speed Transceiver Logic - EIA/JEDEC Standard JESD8-6}


add_io_standard	{HyperTransport} "$arriagx $virtex4 $stratix $stratixgx $stratixii" {2} {2.5 volt - Hypertransport - HyperTransport Consortium}

add_io_standard	{LVDS} "$arriaiigz $arriaii $igloo $fusion $pa3 $pa3e $pa3l $ax $xilinx $cyclone $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev $virtex2 $virtex4 $virtex5 $virtex6 $virtex7" {2} {Differential transceiver - ANSI/TIA/EIA-644-95}
add_io_standard {LVDS_18} "$virtex7" {2} {Xilinx 1.8 volt Differential Signaling EIA/TIA}
add_io_standard {LVDS_25} "$virtex5 $virtex6 $virtex7" {2} {Xilinx 2.5 volt Differential Signaling EIA/TIA}

add_io_standard	{LVPECL} "$arriaiigz $arriaii $igloo $fusion $pa3 $pa3e $pa3l $xilinx $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiv $stratixv $arriav $virtex2 $virtex4" {2} {Differential transceiver - EIA/JEDEC Standard JESD8-2}

add_io_standard	{LVDSEXT_25} "$virtex4 $virtex2 $virtex5 $virtex6 $virtex7" {2} {Differential transceiver}

# category 1
add_io_standard {LVCMOS_5} "$igloo $fusion $pa3 $pa3e $pa3l" {1} {5.0 volt - CMOS}
add_io_standard {LVCMOS_33} "$arriaiigz $arriagx $igloo $fusion $pa3 $pa3e $pa3l $pa $actel $microsemi $cyclone $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiv $stratixv $arriav $cyclonev $xilinx $arriaii" {1} {3.3 volt - CMOS - EIA/JEDEC Standard JESD8-B}
add_io_standard	{LVCMOS_25} "$igloo $fusion $ax $pa3e $pa3l $pa $actel $microsemi $cyclone $cycloneii $stratix $stratixgx $stratixii $stratixiigx $xilinx" {1} {2.5 volt - CMOS - EIA/JEDEC Standard JESD8-5}
add_io_standard	{LVCMOS_18} "$igloo $fusion $ax $pa3 $pa3e $pa3l $actel $microsemi $cyclone $cycloneii $stratix $stratixgx $stratixii $stratixiigx $xilinx " {1} {1.8 volt - CMOS - EIA/JEDEC Standard JESD8-7}
add_io_standard	{LVCMOS_15} "$igloo $fusion $ax $pa3 $pa3e $pa3l $cyclone $cycloneii $stratix $stratixgx $stratixii  $stratixiigx $xilinx" {1} {1.5 volt - CMOS - EIA/JEDEC Standard JESD8-7}
add_io_standard	{LVCMOS_12} " $igloo $fusion $pa3l" {1} {1.2 volt - CMOS }
add_io_standard {LVTTL} "$igloo $fusion $pa $actel $microsemi $pa3 $pa3e $pa3l $cyclone $cycloneii $stratix $stratixgx $stratixii $xilinx" {1} {LVTTL - EIA/JEDEC Standard JESD8-B}

add_io_standard	{MINI_LVDS} "$arriaiigz $arriaii $stratixiv $stratixv $arriav $cyclonev $cycloneii $cycloneiii $cycloneiv" {2} {Mini Differential Transceiver}

add_io_standard	{PCI33}	"$arriagx $ax $igloo $fusion $pa $pa3 $pa3e $pa3l $xilinx $cyclone $cycloneii $stratix $stratixii $stratixgx  $stratixiigx $pa3e"	{2} {3.3 volt - PCI 33Mhz - PCI Local Bus Spec. Rev. 3.0 (PCI Special Interest Group)}

add_io_standard	{PCI66}	"$xilinx"	{2} {3.3 volt PCI 66Mhz}
add_io_standard	{PCI-X_133}	"$arriagx $ax $igloo $fusion $pa3 $pa3e $pa3l $xilinx $cycloneii $stratix $stratixii $stratixgx  $stratixiigx  $pa3e" {2} {3.3 volt - PCI-X Local Bus Spec. Rev. 1.0 (PCI Special Interest Group)}
add_io_standard	{PCML}	"$arriagx $stratix $stratixgx" {2} {3.3 volt - PCML}

add_io_standard {SSTL_3_Class_I} "$ax $igloo $fusion $pa3e $pa3l $cyclone $stratix $stratixgx $xilinx " {2} {3.3 volt - Stub Series Terminated Logic - EIA/JEDEC Standard JESD8-8}
add_io_standard	{SSTL_3_Class_II} "$ax $igloo $fusion $pa3e $pa3l $cyclone $stratix $stratixgx $xilinx " {2} {3.3 volt - Stub Series Terminated Logic - EIA/JEDEC Standard JESD8-8} 
add_io_standard	{SSTL_2_Class_I} "$arriaiigz $arriagx $arriaii $ax $igloo $fusion $pa3e $pa3l $cyclone $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev $xilinx " {2} {2.5 volt - Stub Series Terminated Logic - EIA/JEDEC Standard JESD8-9B}
add_io_standard	{SSTL_2_Class_II} "$arriaiigz $arriagx $arriaii $ax $igloo $fusion $pa3e $pa3l $cyclone $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev $xilinx " {2} {2.5 volt - Stub Series Terminated Logic - EIA/JEDEC Standard JESD8-9B} 
add_io_standard {SSTL_15} "$stratixv $arriav $cyclonev $virtex6 $virtex7 $max10 arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {SSTL-15}
add_io_standard	{SSTL_18_Class_I} "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev $xilinx " {2} {1.8 volt - Stub Series Terminated Logic - EIA/JEDEC Standard JESD8-15} 
add_io_standard	{SSTL_18_Class_II} "$arriaiigz $arriagx $arriaii $cycloneii $cycloneiii $cycloneiv $stratix $stratixgx $stratixii $stratixiigx $stratixiii $stratixiv $stratixv $arriav $cyclonev $xilinx " {2} {1.8 volt - Stub Series Terminated Logic - EIA/JEDEC Standard JESD8-15}
add_io_standard	{RSDS} "$arriaiigz $stratixiv $stratixv $arriav $cyclonev $cyclone $cycloneii $cycloneiii $cycloneiv $cyclone10lp" {2} {2.5 volt - Reduced Swing Differential Signalling}

add_io_standard	{ULVDS_25} "$virtex4 $virtex2" {2} {Differential transceiver}

add_io_standard {LVCMOS_12} "$arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {1} {1.2 V}
add_io_standard {HSTL_12_I} "$arriaiigz $arriagx $arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {1.2-V HSTL Class I}
add_io_standard {HSTL_12_II} "$arriaiigz $arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {1.2-V HSTL Class II}
add_io_standard {LVCMOS_15} "$arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {1.5 V}
add_io_standard {LVCMOS_18} "$arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {1.8 V}
add_io_standard {LVCMOS_25} "$arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arria10 arriavgz $cyclone10lp $cyclone10gx" {2} {2.5 V}
add_io_standard {LVCMOS} "$arriaii $stratixiii $cycloneiii $cycloneiv $arriav $max10 arria10 stratix10 stratix20 $cyclone10lp $cyclone10gx" {2} {3.0-V LVCMOS}
add_io_standard {LVTTL} "$arriaii $stratixiii $cycloneiii $cycloneiv $arriav $cyclonev $max10 arria10 stratix10 stratix20 $cyclone10lp $cyclone10gx" {2} {3.0-V LVTTL}
add_io_standard {PCI} "$arriaiigz $arriaii $stratixiii $stratixiv $cycloneiii $cycloneiv $arriav $cyclonev $max10 $cyclone10lp" {2} {3.0-V PCI}
add_io_standard {PCI_X} "$arriaiigz $arriaii $stratixiii $stratixiv $cycloneiii $cycloneiv $arriav $cyclonev $cyclone10lp" {2} {3.0-V PCI-X}
add_io_standard {DIFF_HSTL_12_I} "$arriaiigz $arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {Differential 1.2-V HSTL Class I}
add_io_standard {DIFF_HSTL_12_II} "$arriaiigz $arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {Differential 1.2-V HSTL Class II}
add_io_standard {DIFF_SSTL_15_I} "$arriaiigz $arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $max10 arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {Differential 1.5-V SSTL Class I}
add_io_standard {DIFF_SSTL_15_II} "$arriaiigz $stratixiii $stratixiv $stratixv $arriav $max10 arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {Differential 1.5-V SSTL Class II}
add_io_standard {LVDS_E_1R} "$arriaiigz $stratixiii $stratixiv $arriav $cyclonev $cyclone10lp" {2} {LVDS_E_1R}
add_io_standard {LVDS_E_3R} "$arriaiigz $arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arriavgz" {2} {LVDS_E_3R}
add_io_standard {RSDS_E_1R} "$arriaiigz $arriaii $stratixiii $stratixiv $cycloneiii $cycloneiv $arriav $cyclonev $max10 $cyclone10lp" {2} {RSDS_E_1R}
add_io_standard {RSDS_E_3R} "$arriaiigz $arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arriavgz $cyclone10lp" {2} {RSDS_E_3R}
add_io_standard {SSTL_15_I} "$arriaiigz $arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $max10 arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {SSTL-15 Class I}
add_io_standard {SSTL_15_II} "$arriaiigz $stratixiii $stratixiv $stratixv $arriav $cyclonev $max10 arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {SSTL-15 Class II}
add_io_standard {MINI_LVDS_1R} "$arriaiigz $stratixiii $stratixiv $arriav $cyclonev $cyclone10lp" {2} {mini-LVDS_E_1R}
add_io_standard {MINI_LVDS_3R} "$arriaiigz $arriaii $stratixiii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arriavgz" {2} {mini-LVDS_E_3R}
add_io_standard {HCSL} "$arriagx $arriaii $stratixiv $stratixv $arriav $cyclonev arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {HCSL}
add_io_standard {PCML_12} "$arriaiigz $arriaiigz $arriagx $arriaii $stratixiv $stratixv $arriav $cyclonev arriavgz" {2} {1.2-V PCML}
add_io_standard {PCML_14} "$arriaiigz $arriaii $stratixiv $stratixv $arriav $cyclonev arriavgz" {2} {1.4-V PCML}
add_io_standard {PCML_15} "$arriaiigz $arriagx $arriaii $stratixiv $stratixv $arriav $cyclonev arriavgz" {2} {1.5-V PCML}
add_io_standard {PCML_25} "$arriaiigz $stratixiv $stratixv $arriav $cyclonev arriavgz" {2} {2.5-V PCML}
add_io_standard {LVTTL_33} "$arriaiigz $arriagx $arriaii $stratixiv $stratixv $arriav $cyclonev $cycloneiii $cycloneiv $max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp" {2} {3.3-V LVTTL}
add_io_standard {BUS_LVDS} "$arriaii $cycloneiii $cycloneiv $max10 $cyclone10lp" {2} {Bus LVDS}
add_io_standard {PPDS} "$cycloneiii $cycloneiv $max10 $cyclone10lp" {2} {PPDS}
add_io_standard {PPDS_E_3R} "$cycloneiii $cycloneiv $max10 $cyclone10lp" {2} {PPDS_E_3R}
add_io_standard {HSUL_12} "$stratixv $arriav $cyclonev $max10 arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {1.2-V HSUL}
add_io_standard {DIFF_HSUL_12} "$stratixv $arriav $cyclonev $max10 arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {Differential 1.2-V HSUL}
add_io_standard {DIFF_SSTL_12} "$stratixv arria10 arriavgz $cyclone10gx" {2} {Differential 1.2-V SSTL}
add_io_standard {DIFF_SSTL_125} "$stratixv $arriav $cyclonev arria10 arriavgz $cyclone10gx" {2} {Differential 1.25-V SSTL}
add_io_standard {DIFF_SSTL_135} "$stratixv $arriav $max10 arria10 arriavgz $cyclone10gx" {2} {Differential 1.35-V SSTL}
add_io_standard {SSTL_125} "$stratixv $arriav $cyclonev arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {SSTL-125}
add_io_standard {SSTL_125_I} "arria10 stratix10i $cyclone10gx" {2} {SSTL-125 Class I}
add_io_standard {SSTL_125_II} "arria10 stratix10 stratix20 $cyclone10gx" {2} {SSTL-125 Class II}
add_io_standard {DIFF_SSTL_125_I} "arria10 $cyclone10gx" {2} {Differential 1.25-V SSTL Class I}
add_io_standard {DIFF_SSTL_125_II} "arria10 $cyclone10gx" {2} {Differential 1.25-V SSTL Class II}
add_io_standard {SSTL_12} "$stratixv arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {SSTL-12}
add_io_standard {SSTL_12_I} "arria10 stratix10 stratix20 $cyclone10gx" {2} {SSTL-12 Class I}
add_io_standard {SSTL_12_II} "arria10 stratix10 stratix20 $cyclone10gx" {2} {SSTL-12 Class II}
add_io_standard {DIFF_SSTL_12_I} "arria10 $cyclone10gx" {2} {Differential 1.2-V SSTL Class I}
add_io_standard {DIFF_SSTL_12_II} "arria10 $cyclone10gx" {2} {Differential 1.2-V SSTL Class II}
add_io_standard {SSTL_135} "$stratixv $arriav $cyclonev $max10 arria10 stratix10 stratix20 arriavgz $cyclone10gx" {2} {SSTL-135}
add_io_standard {SSTL_135_I} "arria10 stratix10 stratix20 $cyclone10gx" {2} {SSTL-135 Class I}
add_io_standard {SSTL_135_II} "arria10 stratix10 stratix20 $cyclone10gx" {2} {SSTL-135 Class II}
add_io_standard {DIFF_SSTL_135_I} "arria10 $cyclone10gx" {2} {Differential 1.35-V SSTL Class I}
add_io_standard {DIFF_SSTL_135_II} "arria10 $cyclone10gx" {2} {Differential 1.35-V SSTL Class II}

# added extra for Altera MAX10
add_io_standard {SLVS} "$max10" {2} {SLVS}
add_io_standard {RSDS} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {RSDS}
add_io_standard {LVDS} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {LVDS}
add_io_standard {Differential_18_V_SSTL_Class_II} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {Differential 1.8-V SSTL Class II}
add_io_standard {Differential_LVPECL} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {Differential LVPECL}
add_io_standard {15_V_HSTL_Class_I} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {1.5-V HSTL Class I}
add_io_standard {18_V_HSTL_Class_II} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {1.8-V HSTL Class II}
add_io_standard {Sub_LVDS} "$max10" {2} {Sub-LVDS}
add_io_standard {Differential_25_V_SSTL_Class_I} "$max10 arriavgz $cyclone10lp" {2} {Differential 2.5-V SSTL Class I}
add_io_standard {SSTL_2_Class_I} "$max10 arriavgz $cyclone10lp" {2} {SSTL-2 Class I}
add_io_standard {HiSpi} "$max10" {2} {HiSpi}
add_io_standard {TMDS} "$max10" {2} {TMDS}
add_io_standard {Differential_18_V_HSTL_Class_II} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {Differential 1.8-V HSTL Class II}
add_io_standard {Differential_18_V_HSTL_Class_I} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {Differential 1.8-V HSTL Class I}
add_io_standard {Differential_15_V_HSTL_Class_I} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {Differential 1.5-V HSTL Class I}
add_io_standard {SSTL_2_Class_II} "$max10 arriavgz $cyclone10lp" {2} {SSTL-2 Class II}
add_io_standard {15_V_HSTL_Class_II} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {1.5-V HSTL Class II}
add_io_standard {18_V_HSTL_Class_I} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {1.8-V HSTL Class I}
add_io_standard {25_V_Schmitt_Trigger} "$max10" {2} {2.5 V Schmitt Trigger}
add_io_standard {33_V_Schmitt_Trigger} "$max10" {2} {3.3 V Schmitt Trigger}
add_io_standard {mini_LVDS} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {mini-LVDS}
add_io_standard {SSTL_18_Class_II} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {SSTL-18 Class II}
add_io_standard {Differential_15_V_HSTL_Class_II} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {Differential 1.5-V HSTL Class II}
add_io_standard {SSTL_18_Class_I} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {SSTL-18 Class I}
add_io_standard {18_V_Schmitt_Trigger} "$max10" {2} {1.8 V Schmitt Trigger}
add_io_standard {15_V_Schmitt_Trigger} "$max10" {2} {1.5 V Schmitt Trigger}
add_io_standard {Differential_18_V_SSTL_Class_I} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp $cyclone10gx" {2} {Differential 1.8-V SSTL Class I}
add_io_standard {33_V_LVCMOS} "$max10 arria10 stratix10 stratix20 arriavgz $cyclone10lp" {2} {3.3-V LVCMOS}
add_io_standard {Differential_25_V_SSTL_Class_II} "$max10 arriavgz $cyclone10lp" {2} {Differential 2.5-V SSTL Class II}


add_io_standard {SB_LVCMOS} "$sbt" {2}   {LVCMOS}
add_io_standard {SB_LVCMOS33_8} "$sbt" {2}  {LVCMOS -3.3V Supply Voltage and +/- 8mA Drive Current}
add_io_standard {SB_LVCMOS25_16} "$sbt" {2} {LVCMOS -2.5V Supply Voltage and +/- 16mA Drive Current}
add_io_standard {SB_LVCMOS25_12} "$sbt" {2} {LVCMOS -2.5V Supply Voltage and +/- 12mA Drive Current}
add_io_standard {SB_LVCMOS25_8} "$sbt" {2} {LVCMOS -2.5V Supply Voltage and +/- 8mA Drive Current}
add_io_standard {SB_LVCMOS25_4} "$sbt" {2} {LVCMOS -2.5V Supply Voltage and +/- 4mA Drive Current}
add_io_standard {SB_LVCMOS18_10} "$sbt" {2} {LVCMOS -1.8V Supply Voltage and +/- 10mA Drive Current}
add_io_standard {SB_LVCMOS18_8} "$sbt" {2} {LVCMOS -1.8V Supply Voltage and +/- 8mA Drive Current}
add_io_standard {SB_LVCMOS18_4} "$sbt" {2} {LVCMOS -1.8V Supply Voltage and +/- 4mA Drive Current}
add_io_standard {SB_LVCMOS18_2} "$sbt" {2} {LVCMOS -1.8V Supply Voltage and +/- 3mA Drive Current}
add_io_standard {SB_LVCMOS15_4} "$sbt" {2} {LVCMOS -1.5V Supply Voltage and +/- 4mA Drive Current}
add_io_standard {SB_LVCMOS15_2} "$sbt" {2} {LVCMOS -1.5V Supply Voltage and +/- 2mA Drive Current}
add_io_standard {SB_SSTL2_CLASS_2} "$sbt" {2} {SSTL2_II -2.5V Supply Voltage and +/- 16.2mA Drive Current}
add_io_standard {SB_SSTL2_CLASS_1} "$sbt" {2} {SSTL2_I -2.5V Supply Voltage and +/- 8.1mA Drive Current}
add_io_standard {SB_SSTL18_FULL} "$sbt" {2} {SSTL18_II -1.8V Supply Voltage and +/- 13.4mA Drive Current}
add_io_standard {SB_SSTL18_HALF} "$sbt" {2} {SSTL18_I -1.8V Supply Voltage and +/- 6.7mA Drive Current}
add_io_standard {SB_MDDR10} "$sbt" {2} {MDDR -1.8V Supply Voltage and +/- 10mA Drive Current}
add_io_standard {SB_MDDR8} "$sbt" {2} {MDDR -1.8V Supply Voltage and +/- 8mA Drive Current}
add_io_standard {SB_MDDR4} "$sbt" {2} {MDDR -1.8V Supply Voltage and +/- 4mA Drive Current}
add_io_standard {SB_MDDR2} "$sbt" {2} {MDDR -1.8V Supply Voltage and +/- 2mA Drive Current}
add_io_standard {SB_LVDS_INPUT} "$sbt" {2} {LVDS -2.5V Supply Voltage}
add_io_standard {SB_SUBLVDS_INPUT} "$sbt" {2} {LVDS -1.8V Supply Voltage}


# add_iostd_column <column heading> <column tcl name> <save to sdc file> <families>
# do NOT add "port"/object column and "Port Type"/Object columns here
add_iostd_column {DCI} {syn_io_dci} {1} "$xilinx"
add_iostd_column {DV2} {syn_io_dv2} {1} "$xilinx"
add_iostd_column {Slew Rate} {syn_io_slew} {1} "$pa $actel $microsemi $fusion $ax $igloo $pa3 $pa3e $pa3l $xilinx"
add_iostd_column {Drive Strength} {syn_io_drive} {1} "$pa $actel $microsemi $fusion $ax $igloo $pa3 $pa3e $pa3l $xilinx"
add_iostd_column {Termination} {syn_io_termination} {1} "$pa $actel $microsemi $fusion $ax $igloo $pa3 $pa3e $pa3l $xilinx"
add_iostd_column {Power} {syn_io_power} {1} "$pa $actel $microsemi $fusion $ax $igloo $pa3 $pa3e $pa3l"
add_iostd_column {Schmitt} {syn_io_schmitt} {1} "$pa $actel $microsemi $fusion $ax $igloo $pa3 $pa3e $pa3l"
add_io_standard {Differential_12_V_POD} "arria10 stratix10 stratix20 $cyclone10gx" {2} {Differential 1.2-V POD}
add_io_standard {Current_Mode_Logic_(CML)} "arria10 stratix10" {2} {Current Mode Logic (CML)}
add_io_standard {12_V_POD} "arria10 stratix10 stratix20 $cyclone10gx" {2} {1.2-V POD}
add_io_standard {High_Speed_Differential_I/O} "arria10 stratix10 stratix20 $cyclone10gx" {2} {High Speed Differential I/O}
