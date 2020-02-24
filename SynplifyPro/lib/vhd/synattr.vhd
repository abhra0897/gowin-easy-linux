-- $Header: //synplicity/mapgw/misc/synattr.vhd#30 $
-- $Name: s901 $
-----------------------------------------------------------------------------
--                                                                         --
-- Copyright (c) 1997-2006 by Synplicity, Inc.  All rights reserved.       --
--                                                                         --
-- This source file may be used and distributed without restriction        --
-- provided that this copyright statement is not removed from the file     --
-- and that any derivative work contains this copyright notice.            --
--                                                                         --
--                                                                         --
--  Library name: synplify                                                 --
--  Package name: attributes                                               --
--                                                                         --
--  Description:  This package contains declarations for Synplify          --
--                attributes                                               --
--                                                                         --
--                                                                         --
--                                                                         --
---------------------------------------------------------------syn+--------------
--

 -- Definitions used for Scope Integration ----------------
 --{tcl set actel "act* 40* 42* 32* 54* ex* ax*"}
 --{tcl set actel_srl "IGLOO2 RTG4 SmartFusion2 IGLOO5 PolarFire"}
 --{tcl set actel_ram "Axcelerator* 500K* PA* ProASIC3* IGLOO* Fusion* SmartFusion* RTG4*"}
 --{tcl set microsemi "G5*"}
 --{tcl set actel_retiming "500K* PA* ax* IGLOO* Fusion* RTG4*"}
 --{tcl set achronix "achronix*"}
 --{tcl set pango "Titan Logos"}
 --{tcl set titan "Titan"}
 --{tcl set achronix_srl "AchronixSpeedster22iHD"}
 --{tcl set siliconblue "SBTiCE65* SBTiCE40* SBTiCE5*"}
 --{tcl set gowin "GOWIN-GW2A GOWIN-GW2AR GOWIN-GW3AT GOWIN-GW1N GOWIN-GW1NR GOWIN-GW1NS GOWIN-GW1NSE GOWIN-GW1NSR GOWIN-GW1NZ GOWIN-GW1NRF"}
 --{tcl set proasic "ProASIC* IGLOO* Fusion* SmartFusion*"}
 --{tcl set proasic_radhardlevel "ProASIC3* IGLOO* Fusion* SmartFusion*"}
 --{tcl set altera "max* flex* acex*"}
 --{tcl set altera_retiming "stratix* agilex* flex* acex* apex* mercury* excalibur* arria*"}
 --{tcl set apex "apex20k apexii excalibur*"}
 --{tcl set apexe "apex20kc apex20ke mercury* stratix* agilex* cyclone* arria*"}
 --{tcl set apex20k "apex20k*"}
 --{tcl set lattice "pLSI*"}
 --{tcl set mach "mach* isp* gal*"}
 --{tcl set quicklogic "pasic* quick* eclipse*"}
 --{tcl set lattice1 "Lattice-* ispXPLD* MachXO*"}
 --{tcl set lattice_srl "Lattice-EC Lattice-ECP* Lattice-XP* Lattice-SC* MACHXO* orca* ECP5U*"}
 --{tcl set lattice_srl_new "Lattice-EC Lattice-ECP Lattice-ECP2 Lattice-ECP2S Lattice-ECP2M Lattice-ECP2M Lattice-ECP3 Lattice-XP Lattice-SC Lattice-SCM MACHXO MACHXO2 ECP5U ECP5UM"}
 --{tcl set lucent "Lattice-* orca* ECP5U*"}
 --{tcl set xilinx "xc* *vir* *spart* *artix* *kintex* *defense* *zynq* *qpro*"}
 --{tcl set xilinx_cplds "coolrunner* xc9500*"}
 --{tcl set xilinx_ecc "AARTIX7 ARTIX7-LOW-VOLTAGE DEFENSE-GRADE-ARTIX7 DEFENSE-GRADE-KINTEX-ULTRASCALE-FPGAS DEFENSE-GRADE-KINTEX7 DEFENSE-GRADE-KINTEX7-LOW-VOLTAGE QPROVIRTEX6 QPROVIRTEX6-LOWER-POWER DEFENSE-GRADE-VIRTEX7 KINTEX7-LOWER-POWER  VIRTEX6-LOWER-POWER KINTEX-ULTRASCALE-FPGAS VIRTEX-ULTRASCALE-FPGAS AZYNQ"}
 --{tcl set xilinx_US "KINTEX-ULTRASCALEPLUS-FPGAS QVIRTEX-ULTRASCALEPLUS QZYNQ-ULTRASCALEPLUS QZYNQ-ULTRASCALEPLUS-RFSOC-FPGAS VIRTEX-ULTRASCALEPLUS-FPGAS VIRTEX-ULTRASCALEPLUS-HBM-FPGAS AZYNQ-ULTRASCALEPLUS-FPGAS ZYNQ-ULTRASCALEPLUS-FPGAS ZYNQ-ULTRASCALEPLUS-RFSOC-FPGAS"}
 --{tcl set virtex "vir* spartan* artix* kintex*"}
 --{tcl set virtex2 "virtex2*"}
 --{tcl set phys "vir* spartan3"}
 --{tcl set stratix "stratix* agilex* arria*"}
 --{tcl set triscend "triscend*" }
 --{tcl set asic "asic*" }
 --{tcl set atmel "AT40K* atfpslic" }
 --{tcl set cp_only "apex20k* excalibur* mercury apexii stratix* agilex* cyclone* spartan* virtex* Lattice-ECP* ECP5*" }
 --{tcl set synloc_only "act* 40* 42* 32* 54* ex* ax* Axcelerator* 500K* PA* ProASIC3*
 --IGLOO* Fusion* SmartFusion* RTG4* achronix* Titan ProASIC* max* flex* acex* stratix* agilex* flex* acex* apex* mercury*
 --excalibur* apex20k apexii apex20kc apex20ke mercury* cyclone pLSI mach* isp*
 --gal* pasic* quick* eclipse* Lattice-* ispXPLD* MachXO* orca* xc* vir* spart*
 --coolrunner* triscend* asic* AT40K* atfpslic }
  -------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package attributes is
    
 -- Compiler attributes

  -- {family *}
 attribute phys_pin_loc : string; -- pin loacatin {objtype port} {desc Define the side and slot number for the pin} {physattr 1}
 attribute phys_pin_hslots : string; -- pin loacatin {objtype module} {desc Define the number of pin slots on the top and bottom sides} {physattr 1}
 attribute phys_pin_vslots : string; -- pin loacatin {objtype module} {desc Define the number of pin slots on the right and left sides} {physattr 1}
 attribute phys_halo : string; -- pin loacatin {objtype module cell } {desc Define the size of the halo in microns around the macro} {physattr 1}

 -- syn_enum_encoding specifies the encoding for an enumeration type
 attribute syn_enum_encoding : string;  -- "onehot", "sequential", "gray" {noscope}

 -- syn_encoding specifies the encoding for a state register
 attribute syn_encoding : string;       -- "onehot", "sequential", "gray", "original", "safe" {objtype fsm} {desc Finite State Machine (FSM) encoding} {default gray}  {enum onehot sequential safe safe,onehot safe,gray safe,sequential safe,original gray default}

 -- syn_shift_resetphase Removes additional pipeline on the inactive edge of the clock for FSMs
 attribute syn_shift_resetphase : integer; -- {objtype global fsm} {desc Remove additional pipeline on the inactive edge of the clock for FSMs} {default 1} {enum 0 1}

 -- syn_safefsm_pipe Removes additional pipeline on the error recovery path for FSMs
 -- { family $actel $actel_ram $microsemi $actel_retiming $achronix $siliconblue $achronix_srl $proasic $proasic_radhardlevel $altera $altera_retiming $apex $apexe $apex20k $lattice $lattice1 $mach $quicklogic $lattice_srl $lattice_srl_new $lucent $xilinx $xilinx_cplds $virtex $virtex2 $phys $stratix $triscend $asic $atmel $cp_only}
 attribute syn_safefsm_pipe : integer; -- {objtype global fsm} {desc Removes the pipeline register on the error recovery path} {default 1} {enum 0 1}

-- syn_allow_retiming specifies if the register can be moved for retiming purpose
-- {family $altera_retiming $virtex $virtex2 $stratix $actel_retiming $siliconblue $gowin}
 attribute syn_allow_retiming : boolean;    -- {objtype register} {desc Enable register retiming} {default 0}

 -- syn_keep is used on signals keep the signal through optimization
 -- so that timing constraints can be placed on the signal later.
 -- The timing constraints can be multi-cycle path and clock.
 attribute syn_keep : boolean; -- {noscope}

 -- syn_looplimit my be attached to a loop label.   It represents the maximum
 -- number of loop iterations that are allowed.   Use this attribute when
 -- Synplify errors out after reaching the maximum loop limit.
 attribute syn_looplimit : integer;    -- the maximum loop count allowed  {noscope}

 -- {family 40mx act1 $siliconblue $gowin}
 --
 -- syn_preserve prevents optimization across registers it is
 -- applied to.  syn_preserve on a module/arch is applied to all
 -- registers in the module/arch.  syn_preserve on a register
 -- will preserve redundant copies.
 -- Can also be used to preserve redundant copies of instantiated
 -- combinational cells.
 attribute syn_preserve : boolean; -- {noscope}

 attribute syn_state_machine : boolean; -- marks reg for SM extraction {noscope}

 attribute syn_isclock : boolean; -- {noscope}


 -- {family 40mx act1 }
 --
 -- syn_preserve_sr_priority is used if you want to preserve
 -- reset over set priority for DFFRS.  Actel FF models produce
 -- an X for set and reset active.  This attribute costs gates and delay.
 attribute syn_preserve_sr_priority : boolean;    -- {objtype register} {desc Enable reset when set and reset both active} {default 0}

 --
 attribute syn_sharing : string;        -- "off" or "on" {noscope}

 -- syn_evaleffort is used on modules to define the effort to be used in
 -- evaluating conditions for control structures.  This is useful for 
 -- those modules that contain while loop or if-then-else conditions 
 -- that may evaluate to a constant if more effort is applied.
 -- The higher this number, the higher the evaluation effort,
 -- and consequently the memory requirement and CPU time.  The default
 -- value is 4.
 -- This attribute is not recommended!
 attribute syn_evaleffort : integer;    -- an integer between 0 and 100 {noscope}

 -- syn_cpueffort is used on modules to define the cpu effort to be used in
 -- various optimizations (such as BDDs).  It may take a value from 1 to 10,
 -- with the default being 5.   A value of 1 to 4 would result in less CPU
 -- time and most likely less optimization, while a value of 6 to 10 would
 -- result in longer CPU time and possibly more optimization.
 --
 -- This attribute is not recommended!
 attribute syn_cpueffort : integer;    -- an integer between 1 and 10  {noscope}



 -- the syn_pmux_slice attribute is used to enable the pmux optimization
 -- code on/off. If on at the last architecture, it is carried on the 
 -- hierarcy chain until it finds an architecture in which the attribute
 -- is expicitly set to off.
 attribute syn_pmux_slice : boolean; -- a boolean value {noscope}
 
-- turn on or off priority mux code
 attribute syn_primux : boolean; -- {noscope}

 -- General mapping attributes

 -- inst/module/arch
 -- { family $actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $gowin}
 attribute syn_resources : string; -- spec resources used by module {noscope} {objtype cell} {desc Specify resources used by module/architecture}

 attribute syn_area : integer; -- spec resources used by module {noscope}

 attribute syn_probe : string; -- {objtype signal} {app ~synplify_asic} {desc Send a signal to output port for testing} {enum 0 1}

 attribute syn_direct_enable : boolean; -- {objtype signal} {app ~synplify_asic} {desc Mark signal as a clock enable} {default 1} {enum 1}

 -- { family $actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds}
 
 -- registers
 attribute syn_reference_clock : string; -- set to the name of the reference clock {objtype register fsm} {desc Override the default clock with the given clock }
 
 -- {family *} 
 -- registers
 attribute syn_useenables : boolean; -- set to false to disable enable use {objtype register} {app ~synplify_asic} {desc Generate with clock enable pin}
 
 -- {family $gowin}
 attribute syn_use_set : boolean; -- set to false to disable set use on registers with no initial value {objtype global register} {default 1} {enum 1 0} 

 attribute syn_noprune : boolean; -- keep object even if outputs unused {noscope} {objtype cell} {desc Retain instance when outputs are unused}



 -- I/O registers
  -- {family $lucent $apex $apexe $xilinx $quicklogic $stratix $siliconblue $pango $achronix}
attribute syn_useioff : boolean; -- {objtype port} {default 0} {enum 0 1}{desc Embed registers in the I/O ring}

  -- {family $xilinx $apex $apexe}
 attribute syn_forward_io_constraints : boolean; -- set to true to forward annotate IO constraints {objtype global} {desc Forward-annotate I/O constraints}

 -- used to specify implementations for dff in actel for now

 -- {family $actel}
 attribute syn_implement : string;      -- "dff", "dffr", "dffs", "dffrs" {noscope}
 
 -- {family $actel $proasic_radhardlevel $xilinx $altera $apex $apexe}
  attribute syn_radhardlevel : string;   -- "none", "cc", "tmr", "tmr_cc", "distributed_tmr" "block_tmr" "duplicate_with_compare" {objtype register module cell} {desc Radiation-hardened implementation style} {enum default (none cc tmr tmr_cc) ProASIC3 ProASIC3E ProASIC3L IGLOO IGLOOE IGLOO+ Fusion (distributed_tmr block_tmr duplicate_with_compare tmr none) SmartFusion2 (none tmr) IGLOO2 RTG4 (none tmr) Virtex virtex-E spartan2 spartan2e spartan3 spartan3e virtex2 virtex2p virtex4 virtex5 virtex6 virtex7 (distributed_tmr block_tmr duplicate_with_compare tmr none) xilinx_default (distributed_tmr block_tmr duplicate_with_compare tmr none) altera_default (distributed_tmr block_tmr duplicate_with_compare tmr none)}
  
  -- {family $xilinx $altera $apex $apexe}
  attribute syn_vote_loops : string;   -- "True" {objtype module} {desc Radiation-hardened fault retention paths} { enum Virtex virtex-E spartan2 spartan2e spartan3 spartan3e virtex2 virtex2p virtex4 virtex5 virtex6 virtex7 (True False) altera_default (True False)}

  -- {family $xilinx $altera}
  attribute syn_vote_register : string;   -- "none", "all" {objtype global register module cell} {desc Radiation-hardened implementation style for flushable circuits} {enum default (none all)}

  -- {family $xilinx $altera $apex $apexe}
  attribute syn_highrel_ioconnector : integer; -- {objtype cell module} {desc Define an I/O connector for high reliability} {default 0}
    
 -- {family asic}
 attribute syn_ideal_net : string; -- {objtype signal} {desc Do not buffer this net during optimization} {enum 1}

 -- {family asic}
 attribute syn_ideal_network : string; -- {objtype signal} {desc Do not buffer this network during optimization} {enum 1}

 -- {family asic}
 attribute syn_no_reopt : boolean; -- {objtype module} {desc Do not resize during reoptimization} {enum 1}

 -- {family asic}
 attribute syn_wire_load : string; -- {objtype module} {desc Set the wire load model to use for this module} {enum -read-wireloads-}

 -- { family $actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $gowin}
 -- black box attributes
 attribute syn_black_box : boolean;         -- disables automatic black box warning {noscope}
 attribute syn_xilinx_xpm : boolean;         -- marks xpm module {noscope}

-- gated clock properties
attribute syn_gatedclk_clock_en : string;  -- gated clk attribute {noscope}
attribute syn_gatedclk_clock_en_polarity : boolean;  -- gated clock attribute {noscope}
 attribute syn_force_seq_prim : boolean;  -- gated clock attribute {noscope}

 -- OLD black box attributes
  -- { family $actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $siliconblue $gowin}
 -- black box attributes
 attribute black_box : boolean;         -- disables automatic black box warning {noscope}
 attribute black_box_pad_pin : string;  -- names of I/O pad connections {noscope}
  -- { family $actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds }
 -- black box attributes
 attribute black_box_tri_pins : string; -- names of tristate ports {noscope}

 -- Black box timing attributes
 -- tpd : timing propagation delay
 -- tsu : timing setup delay
 -- tco : timing clock to output delay
 attribute syn_tpd1 : string; -- {noscope}
 attribute syn_tpd2 : string; -- {noscope}
 attribute syn_tpd3 : string; -- {noscope}
 attribute syn_tpd4 : string; -- {noscope}
 attribute syn_tpd5 : string; -- {noscope}
 attribute syn_tpd6 : string; -- {noscope}
 attribute syn_tpd7 : string; -- {noscope}
 attribute syn_tpd8 : string; -- {noscope}
 attribute syn_tpd9 : string; -- {noscope}
 attribute syn_tpd10 : string; -- {noscope}
 attribute syn_tsu1 : string; -- {noscope}
 attribute syn_tsu2 : string; -- {noscope}
 attribute syn_tsu3 : string; -- {noscope}
 attribute syn_tsu4 : string; -- {noscope}
 attribute syn_tsu5 : string; -- {noscope}
 attribute syn_tsu6 : string; -- {noscope}
 attribute syn_tsu7 : string; -- {noscope}
 attribute syn_tsu8 : string; -- {noscope}
 attribute syn_tsu9 : string; -- {noscope}
 attribute syn_tsu10 : string; -- {noscope}
 attribute syn_tco1 : string; -- {noscope}
 attribute syn_tco2 : string; -- {noscope}
 attribute syn_tco3 : string; -- {noscope}
 attribute syn_tco4 : string; -- {noscope}
 attribute syn_tco5 : string; -- {noscope}
 attribute syn_tco6 : string; -- {noscope}
 attribute syn_tco7 : string; -- {noscope}
 attribute syn_tco8 : string; -- {noscope}
 attribute syn_tco9 : string; -- {noscope}
 attribute syn_tco10 : string; -- {noscope}


-- Certify slp output specific attributes
 attribute syn_partition : string; -- {noscope}
 attribute syn_speedgrade : string; -- {noscope}
 attribute syn_fsm_id : string; -- {noscope}
 attribute syn_padtype : string; -- {noscope}
 attribute procname : string; -- {noscope}
 attribute min_row: integer; -- {noscope}
 attribute min_col: integer; -- {noscope}
 attribute max_row: integer; -- {noscope}
 attribute max_col: integer; -- {noscope}     
 
 attribute syn_cpm_srcontrol : boolean; -- {noscope}
 attribute syn_cpm_type: string; -- {noscope}
 attribute syn_asynchronous_cpm : boolean; -- {noscope}

 -- Mapping attributes

-- set syn_loc to a string which designs a location on the die.
-- {family synloc_only}
 attribute syn_loc : string;    -- {objtype global cell port}{desc Assign a physical location}

 -- set PAP_IO_LOC to a string which designs a location on the die.
-- {family $pango}
 attribute PAP_IO_LOC : string;    -- {objtype global cell port}{desc Assign the object location}

 -- {family $atmel $proasic 500* PA* $actel $xilinx $lucent $quicklogic $altera $apex $apexe $gowin}
 attribute syn_maxfan : integer;     -- {objtype input_port register_output cell} {desc Set the maximum fanout size}

 
-- { family $actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $siliconblue}
 attribute syn_noclockbuf : boolean; -- {objtype global cell input_port module} {app ~synplify_asic} {desc Use a normal input buffer}

-- { family $siliconblue }
 attribute syn_noclockpad : boolean; -- {objtype global cell input_port module} {app ~synplify_asic} {desc Convert SB_GB_IO to SB_IO and SB_GB}

-- {family $xilinx apexii mercury* stratix* agilex* cyclone*}
-- attribute syn_resources : string;    -- {objtype module} {desc  Resources used inside a black box} 

-- {family $virtex $virtex2 stratix* agilex* cyclone* $lattice_srl $achronix $actel_srl $gowin}
attribute syn_srlstyle : string;    -- {objtype cell global module} {desc Inferred SRL implementation style} {default registers} {enum Virtex virtex-E spartan2 spartan2e spartan3e spartan3 spartan3a virtex2 virtex2p virtex4 virtex5 virtex6 virtex7 aritx7 kintex7 (select_srl registers noextractff_srl) $lattice_srl_new (registers distributed block_ram)  $achronix_srl (registers logic_ram) stratixIII stratixIV stratixV (altshift_tap registers block_ram MLAB)stratix stratixII stratixII-GX stratix-GX cyclone* (altshift_tap registers block_ram) $actel_srl (registers uram) $gowin (registers block_ram distributed_ram)}  

-- set syn_ramstyle to a value of "registers" to force the ram
 -- to be implemented with registers.
 
-- {family $achronix $pango $atmel $altera $apex $apexe $xilinx $xilinx_ecc $xilinx_US $lattice1 $lucent $quicklogic $actel_ram $siliconblue $gowin} 
attribute syn_ramstyle : string;    -- {objtype cell global module}  {default registers} {desc Inferred RAM implementation style} {enum Virtex virtex-E spartan2 spartan2e spartan3e spartan3 spartan3a virtex2 virtex2p virtex4 (registers block_ram no_rw_check rw_check area select_ram tmr) virtex5 virtex6 aritx7 kintex7 virtex7 $xilinx_ecc zynq (registers block_ram no_rw_check rw_check area select_ram ecc tmr) $xilinx_US (registers block_ram no_rw_check rw_check area select_ram ecc tmr uram) xilinx_default (registers select_ram block_ram no_rw_check rw_check area tmr) $achronix_srl (registers logic_ram block_ram no_rw_check rw_check) Axcelerator 500K PA ProASIC3 ProASIC3E (registers block_ram no_rw_check rw_check) IGLOO2 SmartFusion2 (registers lsram uram no_rw_check rw_check lsram,rw_check lsram,no_rw_check uram,rw_check uram,no_rw_check) RTG4 (registers lsram uram no_rw_check rw_check lsram,rw_check lsram,no_rw_check uram,rw_check uram,no_rw_check ecc ecc,set uram,ecc lsram,ecc uram,ecc,set lsram,ecc,set) $lattice1 Lattice-EC $lattice1 Lattice-ECP Lattice-ECP2 $lattice1 Lattice-SC $lattice1 Lattice-XP $lattice1 Lattice-MachXO(registers distributed block_ram) $siliconblue SBTiCE65 $siliconblue SBTiCE40(registers block_ram no_rw_check rw_check area) $siliconblue SBTiCE5(registers block_ram no_rw_check rw_check area) $gowin (registers block_ram no_rw_check rw_check distributed_ram) stratix stratixII stratixII-GX stratix-GX(registers block_ram block_ram,no_rw_check M512 M512,no_rw_check M4K M4K,no_rw_check M-RAM M-RAM,no_rw_check, rw_check M512 M512, rw_check M4K M4K, rw_check M-RAM M-RAM, rw_check) cycloneIII stratixIII stratixIV (tmr registers MLAB block_ram block_ram,no_rw_check M9K M9K,no_rw_check M144K M144K,no_rw_check,rw_check M9K M9K,rw_check M144K M144K,rw_check) stratixV(registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) arria10(registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) stratix10 agilex (registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) altera_default (registers block_ram tmr) default (registers) all_enums (registers block_ram no_rw_check rw_check select_ram)}

-- {family $xilinx}
  attribute syn_corrupt_pd : string;   -- "none", "all1s", "all0s", "random" {objtype global cell} {default none} {desc Power domain corruption type} {enum xilinx_default (none all1s all0s random) }

-- {family $virtex $achronix $pango $gowin  SmartFusion2 IGLOO2 RTG4 SBTiCE40*}
attribute syn_insert_pad : boolean; -- {objtype port signal} {default 1 0} {desc Add or remove a pad from a port.} 

-- {family $virtex $virtex2 $pango $altera $apex $apexe $apex20k $lucent $lattice $mach excalibur* spartan3 Axcelerator IGLOO2 RTG4 SmartFusion2 arriaV arria10 stratix10 agilex cycloneV SBTiCE40UP}
attribute syn_multstyle : string;    -- {objtype cell global module} {default block_mult} {desc Inferred multiplier implementation style} {enum Virtex virtex-E spartan2 spartan2e spartan3 spartan3e virtex2 virtex2p virtex4 virtex5(logic block_mult)arriaV cycloneV arria10 stratix10 agilex (logic lpm_mult altmult_add block_mult simd) stratix(logic lpm_mult altmult_add block_mult) altera_default (logic lpm_mult altmult_add block_mult) Axcelerator IGLOO2 RTG4 SmartFusion2 (logic DSP) actel_default (logic DSP) $lattice_srl_new (block_mult logic) all_enums (logic block_mult lpm_mult simd) SBTiCE40UP (DSP logic)}

-- {family $lattice1 $siliconblue}
 attribute syn_use_carry_chain : integer;    -- {objtype cell global module} {desc Infer a carry chain} 


-- {family $virtex $virtex2}
 attribute syn_tops_region_size : integer; -- {objtype global} {desc max. size of valid TOPS region in LUTs} {app amplify}

-- set syn_romstyle to a value of "logic" to force the rom
-- to be implemented with logic, select_rom/block_rom
-- {family $altera $pango $apex $apexe $lattice1 $xilinx $siliconblue $gowin}
attribute syn_romstyle : string;    -- {objtype cell global module} {desc Inferred ROM implementation style} {default logic} {desc Inferred ROM implementation style} {enum Virtex virtex-E spartan2 spartan2e spartan3 Spartan3A Spartan-3A-DSP spartan3e virtex2 virtex2p virtex4 virtex5(logic block_rom select_rom) xilinx_default (logic block_rom select_rom) $achronix_srl (logic block_rom) $lattice1 Lattice-EC $lattice1 Lattice-ECP $lattice1 Lattice-SC $lattice1 Lattice-XP $lattice1 Lattice-MachXO(logic distributed block_rom) $siliconblue SBTiCE65 $siliconblue SBTiCE40(logic block_rom) $siliconblue SBTiCE5(logic block_rom) $gowin GoWin(logic block_rom distributed_rom) stratix stratixII stratix-GX(logic block_rom) stratixIII stratixIV stratixV(logic block_rom MLAB) altera_default(logic block_rom lpm_rom) default(logic) all_enums (logic select_rom block_rom) }

-- set syn_pipeline to a value 1 to pipeline the module front of it
-- {family $altera $apex $apexe $xilinx $gowin}
 attribute syn_pipeline : boolean;    -- {objtype register} {desc Allow register pipelining} {default 1} {desc Allow module pipelining}
-- {family $altera $apex $apexe $xilinx} 
 attribute syn_no_compile_point : boolean; -- {objtype module} {desc Do not use this view as a Compile Point} {default 1} {enum 1}
 attribute syn_cp_use_fast_synthesis : boolean; -- {objtype module} {app amplify} {desc Use Fast Synthesis to map this Compile Point} {default 1} {enum 1}
-- {family $altera $apex $apexe $xilinx $gowin}
 -- controls EDIF format.  Set true on top level to disable array ports
 -- { family $actel $actel_ram $achronix $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds }
 attribute syn_noarrayports : boolean; -- {objtype global} {app ~synplify_asic} {desc Disable array ports}

 -- controls EDIF port name length. Currently used in Altera
 -- {family $altera}
 attribute syn_edif_name_length : string;  -- {enum Restricted Unrestricted} {default Restricted} {objtype global} {desc Use Restricted for MAXII; Unrestricted for Quartus}

  -- {family *}

 -- controls reconstruction of hierarchy.  Set false on top level
 -- to disable hierarchy reconstruction.
 attribute syn_netlist_hierarchy : boolean; -- {objtype global} {app ~synplify_asic} {desc Enable hierarchy reconstruction}

 -- { family $actel $actel_ram $achronix $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds }
 -- Minimizes changes to an output netlist following incremental changes to the design

 --
 -- syn_hier on an instance/module/architecture can be used
 -- to control treatment of the level of hierarchy.
 -- "macro" - preserve instantiated netlist
 -- "hard" - preserves the interface of the design unit with no exceptions.
 -- "remove"- removes level of hierarchy
 -- "soft"  - managed by Synplify (default)
 -- "firm"  - preserve during opt, but allow mapping across boundary
 --

  -- { family $actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $siliconblue $gowin}
 
 attribute syn_hier: string; -- {objtype module} {desc Control hierarchy flattening} {enum proASIC (soft remove flatten firm fixed) xilinx_default(hard soft remove flatten firm fixed) gowin_default actel_default altera_default all_enums(hard soft macro remove flatten firm fixed) lucent_default (soft macro remove flatten firm fixed) quicklogic_default(soft macro remove flatten firm fixed) default(soft remove flatten firm fixed)}
 -- syn_flatten on a module/architecture will flatten out the
 -- module all the way down to primitives.
 attribute syn_flatten : boolean; -- {noscope}

 -- {family $cp_only }
 attribute syn_allowed_resources : string; -- {objtype module} {desc Set available resources in a Compile Point}
 
 -- Architecture specific attributes
 -- Actel
  -- {family $actel}

 --
 
 attribute alspin : string ; --{objtype port} {desc Pin locations for I/Os}
 attribute alspreserve : boolean ; --{objtype signal} {desc Preserve a net}
 attribute alsfc : string ; --{noscope}
 attribute alsdc : string ; --{noscope}
 attribute alsloc : string ; --{noscope}
 attribute alscrt : string ; --{noscope}

-- {family $proasic $xilinx $siliconblue}
attribute syn_global_buffers : integer; -- {objtype global} {desc Set available number of global buffers}

-- {family $actel $proasic $pango $siliconblue RTG4}
attribute syn_insert_buffer : string; -- {objtype port signal} {desc Insert a buffer on a signal} {enum ProASIC3 ProASIC3E ProASIC3L IGLOO IGLOOE IGLOO+ (CLKINT HCLKINT CLKBUF HCLKBUF) IGLOO2 RTG4 SmartFusion2 (CLKINT RCLKINT CLKBUF CLKBIBUF)}

-- {family $xilinx}
-- attribute syn_insert_buffer : string; -- {objtype port cell signal} {desc Insert a buffer on a signal} {enum BUFG BUFGMUX BUFH BUFR}
 
 -- Altera
 -- {family $altera $apex $apexe}
 
 attribute altera_implement_style : string; -- placement {noscope}
 attribute altera_clique : string; -- placement {noscope}
 attribute altera_chip_pin_lc : string; -- placement {objtype port} {desc Set I/O pin location}
 -- inst/module/arch:  put comb logic into rom
 attribute altera_implement_in_eab : boolean; -- {objtype cell} {desc Implement in Altera EABs, apply to module/component instance name only} {default 1}
 attribute altera_lcell: string; -- arch attribute with values of "lut" and "car" {noscope}
 								 -- for lcell config
 attribute altera_auto_use_eab : boolean; -- {objtype global} {desc Use EABs automatically} {default 1}
 attribute altera_auto_use_esb : boolean; -- {objtype global} {desc Use ESBs automatically} {default 1}

 -- Apex  
 -- {family $apex $apexe}

 attribute altera_implement_in_esb : boolean; -- {objtype cell} {desc Implement in Altera ESBs, apply to module/component instance name only} {default 1}

 -- Apex  
 -- {family $apex $apexe}

 attribute altera_logiclock_location : string; -- {objtype module} {desc Specify the location of LogicLock region} {default floating} 


-- Apex  
 -- {family $apex $apexe}

 attribute altera_logiclock_size : string; -- {objtype module} {desc Specify the size of LogicLock region} {default auto} 


 -- {family apex20kc apex20ke excalibur* mercury* cyclone* stratix* agilex* acex* flex10k* }
 attribute altera_io_opendrain : boolean; -- set to true to get opendrain port in APEX {objtype port} {desc Use opendrain capability on port or bit-port.}

 -- {family $altera_retiming}
 attribute altera_io_powerup : string; -- set to high to get IO FF to powerup high in APEX {objtype port} {desc Powerup high or low on port or bit-port in APEX20KE.}

 -- {family $apex $apexe $altera}
 attribute syn_altera_model : string; -- {objtype module} {desc Call clearbox on Altera Megafunctions instantiated in this view} {default on} {enum on off}

 -- Lattice
 -- {family $lattice $quicklogic}
 
 attribute lock: string; -- pin placement {objtype port} {desc Set pin locations for Lattice I/Os}
 
 -- Lucent
 -- {family $lucent}
 
 attribute din : string; -- orca2 FF placement attribute, use value "" {objtype input_port} {desc Input register goes next to I/O pad}
 attribute dout : string; -- orca2 FF placement attribute, use value "" {objtype output_port} {desc Output register goes next to I/O pad}
 attribute orca_padtype : string; -- value selects synth pad type {objtype port} {desc Pad type for I/O}
 attribute orca_props : string; -- attributes to pass for instance {objtype cell port} {desc Forward annotate attributes to ORCA back-end}

 -- Both Lucent and Mach
 -- {family $lucent $mach}
 attribute loc : string;  -- placment attribute {objtype port} {desc Set pin location}


 -- Quicklogic
  -- {family $quicklogic}
 
 -- I/O attributes
 attribute ql_padtype : string; -- {objtype port} {desc Override default pad types (use BIDIR, INPUT, CLOCK)} {enum BIDIR INPUT CLOCK}
 attribute ql_placement : string; -- {objtype port cell} {desc Placement location}
 

 -- Both Xilinx FPGAs and CPLDS
 -- {family $xilinx $xilinx_cplds}
 attribute xc_loc : string; -- placement (pads) {objtype port} {desc Set port placement}
 
 -- Xilinx
 -- {family $xilinx}

 -- Instance Placement attributes
 attribute xc_rloc : string; -- see RPMs in xilinx doc {objtype cell} {desc Specify relative placement; use with xc_uset}
 attribute xc_uset : string; -- see RPMs in xilinx doc {objtype cell} {desc Assign group name for placement; use with xc_rloc}

 -- I/O attributes
 attribute xc_fast : boolean; -- {objtype output_port} {desc Fast transition time}
 attribute xc_ioff : boolean; -- {noscope}
 attribute xc_nodelay : boolean; -- {objtype input_port} {desc Remove input delay}
 attribute xc_slow : boolean; -- {objtype output_port} {desc Slow transition time}
 attribute xc_ttl : boolean; -- {noscope}
 attribute xc_cmos : boolean; -- {noscope}
 attribute xc_pullup : boolean;   -- add a pullup to I/O {objtype port} {desc Add a pull-up}
 attribute xc_pulldown : boolean; -- add a pulldown to I/O {objtype port} {desc Add a pull-down}
 attribute xc_clockbuftype : string; -- {objtype input_port} {default BUFGDLL} {desc Use the Xilinx BUFGDLL clock buffer}
 attribute xc_padtype : string; -- {objtype port} {desc Set an I/O standard for an I/O buffer}
 
 -- Top level architecture attributes
 -- number of global buffers, used only for XC4000, XC4000E
 attribute xc_global_buffers : integer; -- {objtype global} {desc Number of global buffers}
 attribute xc_use_timespec_for_io : boolean; -- {objtype global} {desc Enable use of from-to timepsec instead of offset for I/O constraint} {default 0}

 -- Xilinx Modular Design Flow --
 attribute xc_pseudo_pin_loc : string; -- {objtype signal} {default CLB_RrrCcc:CLB_RrrCcc} {desc Pseudo pin location on place and route block }
 attribute xc_modular_design : boolean; -- {objtype global } {default 1} {desc Enable modular design flow }
 attribute xc_modular_region : string; -- {objtype cell } {default rr#cc#rr#cc} {desc Specify the number of CLB's for a modular region}

 -- Xilinx Incremental Design Flow --
  attribute xc_area_group : string; -- {objtype cell } {default rr#cc#rr#cc} {desc Specify region where instance should be placed}

 -- Black box attributes
 -- {family $xilinx}
 attribute xc_alias : string; -- cell name change in XNF writer {noscope}
 attribute xc_props : string; -- extra XNF attributes to pass for instance {objtype cell} {desc Extra XNF attributes to pass for instance}
 attribute xc_map : string;   -- used to map entity to fmap/hmap/lut {objtype module} {desc Map entity to fmap/hmap/lut} {enum fmap hmap lut}
 attribute xc_isgsr : boolean; -- used to mark port of core with built in GSR {noscope}
-- {family $xilinx}
 attribute syn_tristatetomux : integer ; -- {objtype module global} {desc Threshold for converting tristates to MUX}
 attribute syn_edif_bit_format  : string ; -- {objtype global} {desc Format bus names in EDIF} {enum %u<%i> %u[%i] %u(%i) %u_%i %u%i %d<%i> %d[%i] %d(%i) %d_%i %d%i %n<%i> %n[%i] %n(%i) %n_%i %n%i}

 attribute syn_edif_scalar_format : string; -- {objtype global} {desc Format scalar names in EDIF} {enum %u %n %d}

 attribute xc_fast_auto : boolean; -- {objtype global} {desc Enable automatic fast output buffer use}


-- Xilinx usage of RPMs
 -- {family $phys}
 attribute xc_use_rpms :boolean; -- {objtype global} {desc Allow use of Relatively Placed Macros (RPM)} {default 0}

 -- Triscend
 -- {family $triscend}

 attribute tr_map : string;   -- used to map entity to LUT {objtype module} {desc Map entity to LUT}

 attribute syn_props : string; -- extra attributes to pass to EDIF for instance {objtype cell} {desc Extra attributes to pass to EDIF for instance}

-- syn_replicate controls replication of registers
-- {family $proasic 500k* PA* $virtex $virtex2 $altera $apex $apexe $apex20k $siliconblue $gowin}
attribute syn_replicate : boolean; -- {objtype global register} {desc Controls replication of registers} {default 0}

-- {family $achronix}
-- attribute syn_dspstyle : string;    -- {objtype cell module global} {default dsp} {desc Inferred DSP implementation style} {enum $achronix_srl (logic dsp) all_enums (logic dsp)}

-- {family virtex4 virtex5 virtex6 virtex7 $siliconblue $gowin $titan}
attribute syn_dspstyle : string;    -- {objtype cell module global} {default dsp48} {desc Inferred DSP implementation style} {enum virtex4(logic dsp48) virtex5 virtex6 virtex7(logic dsp48 simd) $siliconblue SBTiCE40(logic dsp) $gowin GoWin(logic dsp) $siliconblue SBTiCE5(logic dsp) $titan (logic DSP) all_enums (logic dsp48)}

-- {family virtex4 virtex5} 
attribute syn_clean_reset : string; -- {objtype global} {default dsp48_no_simulate,one_flop} {desc Convert asynchronous reset to synchronous reset to enable packing of registers into a DSP block} {enum virtex4 virtex5(dsp48_no_simulate,one_flop} all_enums (dsp48_no_simulate,one_flop)}

-- {family $xilinx}
attribute syn_diff_io : boolean; -- {objtype port } {desc Infer Differential I/O pads}
attribute syn_clock_priority : integer; -- {objtype port signal} {desc Set clock priority to be forward annotated to the Xilinx UCF file} {default 1}

 -- syn_set_value on an top level ports/nets can be used to set a probable value on these objects
 -- Pseudo constant propagation.
 -- {family $asic}
 attribute syn_set_value: boolean; -- {objtype port signal} {app synplify_asic} {desc Optimize with object set to given value} 
 attribute syn_modgen_style : string; -- "small", "fast" {objtype global} {app synplify_asic} {desc Set the operator implementation} {enum small fast}

 attribute  syn_scan_enable: boolean; -- {objtype module cell port signal} {app synplify_asic} {desc Enable scan for test} {default 1}
 attribute syn_clockgating_threshold : integer; -- {objtype global} {app synplify_asic amplify_asic} {desc Set the minimum number of registers (with common clock and enable signals) to convert to a gated clock}
 attribute syn_clockgating_max_sinks : integer; -- {objtype global} {app synplify_asic amplify_asic} {desc Set the maximum number of registers connected to a clock gating cell}
 attribute syn_timing_mode : string; -- {objtype cell} {app synplify_asic amplify_asic} {desc Set the mode for timing analysis}

 -- {family issp}
 attribute syn_ects_output_clock_tree : boolean; -- {objtype global} {default 1} {desc Insert and output embedded clock tree in def and vma} {physattr 1}
 attribute syn_embedded_clock_type : string; -- {objtype cell} {enum main local none} {default main} {desc Assign user clock to given value} {physattr 1}

 -- {family $xilinx}
 attribute xc_ncf_auto_relax : boolean; -- {objtype global} {desc Set automatic relaxation of constraints forward-annotated to the NCF file } {default 0}
 attribute xc_use_xmodule : boolean; -- {objtype module} {desc Mark a hierarchical block or Compile Point as a module that can be implemented independently by the P&R tool}{default 0}
 attribute xc_use_keep_hierarchy : boolean; -- {objtype module} {desc Preserve the hierarchy of the module for diagnostics and timing simulation}{default 0}

 -- {family $achronix  $pango}
 attribute syn_unconnected_inputs : string; -- {objtype cell module} {desc Leave a pin unconnected on an instance}
 attribute syn_max_memsize_reg : integer; -- {objtype global} {default 128} {desc Define the maximum allowed memory size for memory to be mapped to registers}
 attribute syn_reduce_controlset_size : integer; -- {objtype global} {default 32} {desc Define the minimum fanout for control signals}

 -- {family $microsemi}
 attribute syn_g5_cfg_inference : integer; -- {objtype global} {desc Set the maximum size of CFG inputs} {default 6} {enum 4 5 6}

 -- {family $microsemi}
 attribute syn_g5_cfg4_areacost : string; -- {objtype global} {desc Set the area cost of CFG4} {default 1} 

 -- {family $microsemi}
 attribute syn_g5_cfg5_areacost : string; -- {objtype global} {desc Set the area cost of CFG5} {default 1.25}

 -- {family $microsemi}
 attribute syn_g5_cfg6_areacost : string; -- {objtype global} {desc Set the area cost of CFG6} {default 1.5}

 -- {family $microsemi}
 attribute syn_g5_route_delay_scale : string; -- {objtype global} {desc Set the route delay scaling factor} {default 1.0}

 -- {family $microsemi}
 attribute syn_g5_cfg_pindelay_ay : integer; -- {objtype global} {desc Set the CFG pin delay from A to Y in ps} {default 58}

 -- {family $microsemi}
 attribute syn_g5_cfg_pindelay_by : integer; -- {objtype global} {desc Set the CFG pin delay from B to Y in ps} {default 124}

 -- {family $microsemi}
 attribute syn_g5_cfg_pindelay_cy : integer; -- {objtype global} {desc Set the CFG pin delay from C to Y in ps} {default 157}

 -- {family $microsemi}
 attribute syn_g5_cfg_pindelay_dy : integer; -- {objtype global} {desc Set the CFG pin delay from D to Y in ps} {default 223}

 -- {family $microsemi}
 attribute syn_g5_cfg_pindelay_ey : integer; -- {objtype global} {desc Set the CFG pin delay from E to Y in ps} {default 256}

 -- {family $microsemi}
 attribute syn_g5_cfg_pindelay_fy : integer; -- {objtype global} {desc Set the CFG pin delay from F to Y in ps} {default 372}

 -- {family $gowin}
 attribute syn_direct_reset : integer; -- {objtype port} {default 0}
 
 attribute syn_direct_set : integer; -- {objtype port} {default 0}
 
 attribute syn_io_type : string; -- {objtype port} {default LVDS25} {enum LVDS25 RSDS MINILVDS PPLVDS LVDS25E BLVDS25 MLVDS25 RSDS25E LVPECL33 HSTL15_I HSTL15D_I HSTL18_I HSTL18_II HSTL18D_I HSTL18D_II SSTL15 SSTL15D SSTL18_I SSTL18_II SSTL18D_I SSTL18D_II SSTL25_I SSTL25_II SSTL25D_I SSTL25D_II SSTL33_I SSTL33_II SSTL33D_I SSTL33D_II LVTTL33 LVCMOS33 LVCMOS33D LVCMOS25 LVCMOS25D LVCMOS18 LVCMOS18D LVCMOS15 LVCMOS15D LVCMOS12 LVCMOS12D PCI33} 

 attribute syn_pullup : boolean; -- {objtype port} {default 0} {desc Add a pull-up}

 attribute syn_pulldown : boolean; -- {objtype port} {default 0} {desc Add a pull-down}

 attribute syn_pad_type : string; -- {objtype port}

 attribute syn_tlvds_io : boolean; -- {objtype port} {default 0} {desc Infer Differential I/O pads}

 attribute syn_elvds_io : boolean; -- {objtype port} {default 0} {desc Infer Differential I/O pads}

 attribute syn_area_group : string; -- {objtype module} {default rr#cc#:rr#cc#} {desc Specify region where instance should be placed} 

end attributes
;
