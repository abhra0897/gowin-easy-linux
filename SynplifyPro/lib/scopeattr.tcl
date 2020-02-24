# # # Created by vhd2attr.pl # # #
set actel "act* 40* 42* 32* 54* ex* ax*"
set actel_srl "IGLOO2 RTG4 SmartFusion2 IGLOO5 PolarFire"
set actel_ram "Axcelerator* 500K* PA* ProASIC3* IGLOO* Fusion* SmartFusion* RTG4*"
set microsemi "G5*"
set actel_retiming "500K* PA* ax* IGLOO* Fusion* RTG4*"
set achronix "achronix*"
set pango "Titan Logos"
set titan "Titan"
set achronix_srl "AchronixSpeedster22iHD"
set siliconblue "SBTiCE65* SBTiCE40* SBTiCE5*"
set gowin "GOWIN-GW2A GOWIN-GW2AR GOWIN-GW3AT GOWIN-GW1N GOWIN-GW1NR GOWIN-GW1NS GOWIN-GW1NSE GOWIN-GW1NSR GOWIN-GW1NZ GOWIN-GW1NRF"
set proasic "ProASIC* IGLOO* Fusion* SmartFusion*"
set proasic_radhardlevel "ProASIC3* IGLOO* Fusion* SmartFusion*"
set altera "max* flex* acex*"
set altera_retiming "stratix* agilex* flex* acex* apex* mercury* excalibur* arria*"
set apex "apex20k apexii excalibur*"
set apexe "apex20kc apex20ke mercury* stratix* agilex* cyclone* arria*"
set apex20k "apex20k*"
set lattice "pLSI*"
set mach "mach* isp* gal*"
set quicklogic "pasic* quick* eclipse*"
set lattice1 "Lattice-* ispXPLD* MachXO*"
set lattice_srl "Lattice-EC Lattice-ECP* Lattice-XP* Lattice-SC* MACHXO* orca* ECP5U*"
set lattice_srl_new "Lattice-EC Lattice-ECP Lattice-ECP2 Lattice-ECP2S Lattice-ECP2M Lattice-ECP2M Lattice-ECP3 Lattice-XP Lattice-SC Lattice-SCM MACHXO MACHXO2 ECP5U ECP5UM"
set lucent "Lattice-* orca* ECP5U*"
set xilinx "xc* *vir* *spart* *artix* *kintex* *defense* *zynq* *qpro*"
set xilinx_cplds "coolrunner* xc9500*"
set xilinx_ecc "AARTIX7 ARTIX7-LOW-VOLTAGE DEFENSE-GRADE-ARTIX7 DEFENSE-GRADE-KINTEX-ULTRASCALE-FPGAS DEFENSE-GRADE-KINTEX7 DEFENSE-GRADE-KINTEX7-LOW-VOLTAGE QPROVIRTEX6 QPROVIRTEX6-LOWER-POWER DEFENSE-GRADE-VIRTEX7 KINTEX7-LOWER-POWER  VIRTEX6-LOWER-POWER KINTEX-ULTRASCALE-FPGAS VIRTEX-ULTRASCALE-FPGAS AZYNQ"
set xilinx_US "KINTEX-ULTRASCALEPLUS-FPGAS QVIRTEX-ULTRASCALEPLUS QZYNQ-ULTRASCALEPLUS QZYNQ-ULTRASCALEPLUS-RFSOC-FPGAS VIRTEX-ULTRASCALEPLUS-FPGAS VIRTEX-ULTRASCALEPLUS-HBM-FPGAS AZYNQ-ULTRASCALEPLUS-FPGAS ZYNQ-ULTRASCALEPLUS-FPGAS ZYNQ-ULTRASCALEPLUS-RFSOC-FPGAS"
set virtex "vir* spartan* artix* kintex*"
set virtex2 "virtex2*"
set phys "vir* spartan3"
set stratix "stratix* agilex* arria*"
set triscend "triscend*" 
set asic "asic*" 
set atmel "AT40K* atfpslic" 
set cp_only "apex20k* excalibur* mercury apexii stratix* agilex* cyclone* spartan* virtex* Lattice-ECP* ECP5*" 
add_scope_attr {phys_pin_loc} {*} {port} {string} {} {Define the side and slot number for the pin} {0} {} {} {1}
add_scope_attr {phys_pin_hslots} {*} {module} {string} {} {Define the number of pin slots on the top and bottom sides} {0} {} {} {1}
add_scope_attr {phys_pin_vslots} {*} {module} {string} {} {Define the number of pin slots on the right and left sides} {0} {} {} {1}
add_scope_attr {phys_halo} {*} {module} {string} {} {Define the size of the halo in microns around the macro} {0} {} {} {1}
add_scope_attr {phys_halo} {*} {cell} {string} {} {Define the size of the halo in microns around the macro} {0} {} {} {1}
add_scope_attr {syn_encoding} {*} {fsm} {string} {gray} {Finite State Machine (FSM) encoding} {0} {onehot sequential safe safe,onehot safe,gray safe,sequential safe,original gray default} {} {0}
add_scope_attr {syn_shift_resetphase} {*} {global} {integer} {1} {Remove additional pipeline on the inactive edge of the clock for FSMs} {0} {0 1} {} {0}
add_scope_attr {syn_shift_resetphase} {*} {fsm} {integer} {1} {Remove additional pipeline on the inactive edge of the clock for FSMs} {0} {0 1} {} {0}
add_scope_attr {syn_safefsm_pipe} "$actel $actel_ram $microsemi $actel_retiming $achronix $siliconblue $achronix_srl $proasic $proasic_radhardlevel $altera $altera_retiming $apex $apexe $apex20k $lattice $lattice1 $mach $quicklogic $lattice_srl $lattice_srl_new $lucent $xilinx $xilinx_cplds $virtex $virtex2 $phys $stratix $triscend $asic $atmel $cp_only" {global} {integer} {1} {Removes the pipeline register on the error recovery path} {0} {0 1} {} {0}
add_scope_attr {syn_safefsm_pipe} "$actel $actel_ram $microsemi $actel_retiming $achronix $siliconblue $achronix_srl $proasic $proasic_radhardlevel $altera $altera_retiming $apex $apexe $apex20k $lattice $lattice1 $mach $quicklogic $lattice_srl $lattice_srl_new $lucent $xilinx $xilinx_cplds $virtex $virtex2 $phys $stratix $triscend $asic $atmel $cp_only" {fsm} {integer} {1} {Removes the pipeline register on the error recovery path} {0} {0 1} {} {0}
add_scope_attr {syn_allow_retiming} "$altera_retiming $virtex $virtex2 $stratix $actel_retiming $siliconblue $gowin" {register} {boolean} {0} {Enable register retiming} {0} {} {} {0}
add_scope_attr {syn_preserve_sr_priority} {40mx act1 } {register} {boolean} {0} {Enable reset when set and reset both active} {0} {} {} {0}
add_scope_attr {syn_probe} "$actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $gowin" {signal} {string} {} {Send a signal to output port for testing} {0} {0 1} {~synplify_asic} {0}
add_scope_attr {syn_direct_enable} "$actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $gowin" {signal} {boolean} {1} {Mark signal as a clock enable} {0} {1} {~synplify_asic} {0}
add_scope_attr {syn_reference_clock} "$actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds" {register} {string} {} {Override the default clock with the given clock } {0} {} {} {0}
add_scope_attr {syn_reference_clock} "$actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds" {fsm} {string} {} {Override the default clock with the given clock } {0} {} {} {0}
add_scope_attr {syn_useenables} {*} {register} {boolean} {} {Generate with clock enable pin} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_use_set} "$gowin" {global} {boolean} {1} {} {0} {1 0} {} {0}
add_scope_attr {syn_use_set} "$gowin" {register} {boolean} {1} {} {0} {1 0} {} {0}
add_scope_attr {syn_useioff} "$lucent $apex $apexe $xilinx $quicklogic $stratix $siliconblue $pango $achronix" {port} {boolean} {0} {Embed registers in the I/O ring} {0} {0 1} {} {0}
add_scope_attr {syn_forward_io_constraints} "$xilinx $apex $apexe" {global} {boolean} {} {Forward-annotate I/O constraints} {0} {} {} {0}
add_scope_attr {syn_radhardlevel} "$actel $proasic_radhardlevel $xilinx $altera $apex $apexe" {register} {string} {} {Radiation-hardened implementation style} {0} {default (none cc tmr tmr_cc) ProASIC3 ProASIC3E ProASIC3L IGLOO IGLOOE IGLOO+ Fusion (distributed_tmr block_tmr duplicate_with_compare tmr none) SmartFusion2 (none tmr) IGLOO2 RTG4 (none tmr) Virtex virtex-E spartan2 spartan2e spartan3 spartan3e virtex2 virtex2p virtex4 virtex5 virtex6 virtex7 (distributed_tmr block_tmr duplicate_with_compare tmr none) xilinx_default (distributed_tmr block_tmr duplicate_with_compare tmr none) altera_default (distributed_tmr block_tmr duplicate_with_compare tmr none)} {} {0}
add_scope_attr {syn_radhardlevel} "$actel $proasic_radhardlevel $xilinx $altera $apex $apexe" {module} {string} {} {Radiation-hardened implementation style} {0} {default (none cc tmr tmr_cc) ProASIC3 ProASIC3E ProASIC3L IGLOO IGLOOE IGLOO+ Fusion (distributed_tmr block_tmr duplicate_with_compare tmr none) SmartFusion2 (none tmr) IGLOO2 RTG4 (none tmr) Virtex virtex-E spartan2 spartan2e spartan3 spartan3e virtex2 virtex2p virtex4 virtex5 virtex6 virtex7 (distributed_tmr block_tmr duplicate_with_compare tmr none) xilinx_default (distributed_tmr block_tmr duplicate_with_compare tmr none) altera_default (distributed_tmr block_tmr duplicate_with_compare tmr none)} {} {0}
add_scope_attr {syn_radhardlevel} "$actel $proasic_radhardlevel $xilinx $altera $apex $apexe" {cell} {string} {} {Radiation-hardened implementation style} {0} {default (none cc tmr tmr_cc) ProASIC3 ProASIC3E ProASIC3L IGLOO IGLOOE IGLOO+ Fusion (distributed_tmr block_tmr duplicate_with_compare tmr none) SmartFusion2 (none tmr) IGLOO2 RTG4 (none tmr) Virtex virtex-E spartan2 spartan2e spartan3 spartan3e virtex2 virtex2p virtex4 virtex5 virtex6 virtex7 (distributed_tmr block_tmr duplicate_with_compare tmr none) xilinx_default (distributed_tmr block_tmr duplicate_with_compare tmr none) altera_default (distributed_tmr block_tmr duplicate_with_compare tmr none)} {} {0}
add_scope_attr {syn_vote_loops} "$xilinx $altera $apex $apexe" {module} {string} {} {Radiation-hardened fault retention paths} {0} {Virtex virtex-E spartan2 spartan2e spartan3 spartan3e virtex2 virtex2p virtex4 virtex5 virtex6 virtex7 (True False) altera_default (True False)} {} {0}
add_scope_attr {syn_vote_register} "$xilinx $altera" {global} {string} {} {Radiation-hardened implementation style for flushable circuits} {0} {default (none all)} {} {0}
add_scope_attr {syn_vote_register} "$xilinx $altera" {register} {string} {} {Radiation-hardened implementation style for flushable circuits} {0} {default (none all)} {} {0}
add_scope_attr {syn_vote_register} "$xilinx $altera" {module} {string} {} {Radiation-hardened implementation style for flushable circuits} {0} {default (none all)} {} {0}
add_scope_attr {syn_vote_register} "$xilinx $altera" {cell} {string} {} {Radiation-hardened implementation style for flushable circuits} {0} {default (none all)} {} {0}
add_scope_attr {syn_highrel_ioconnector} "$xilinx $altera $apex $apexe" {cell} {integer} {0} {Define an I/O connector for high reliability} {0} {} {} {0}
add_scope_attr {syn_highrel_ioconnector} "$xilinx $altera $apex $apexe" {module} {integer} {0} {Define an I/O connector for high reliability} {0} {} {} {0}
add_scope_attr {syn_ideal_net} {asic} {signal} {string} {} {Do not buffer this net during optimization} {0} {1} {} {0}
add_scope_attr {syn_ideal_network} {asic} {signal} {string} {} {Do not buffer this network during optimization} {0} {1} {} {0}
add_scope_attr {syn_no_reopt} {asic} {module} {boolean} {} {Do not resize during reoptimization} {0} {1} {} {0}
add_scope_attr {syn_wire_load} {asic} {module} {string} {} {Set the wire load model to use for this module} {0} {-read-wireloads-} {} {0}
add_scope_attr {syn_loc} {synloc_only} {global} {string} {} {Assign a physical location} {0} {} {} {0}
add_scope_attr {syn_loc} {synloc_only} {cell} {string} {} {Assign a physical location} {0} {} {} {0}
add_scope_attr {syn_loc} {synloc_only} {port} {string} {} {Assign a physical location} {0} {} {} {0}
add_scope_attr {PAP_IO_LOC} "$pango" {global} {string} {} {Assign the object location} {0} {} {} {0}
add_scope_attr {PAP_IO_LOC} "$pango" {cell} {string} {} {Assign the object location} {0} {} {} {0}
add_scope_attr {PAP_IO_LOC} "$pango" {port} {string} {} {Assign the object location} {0} {} {} {0}
add_scope_attr {syn_maxfan} "$atmel $proasic 500* PA* $actel $xilinx $lucent $quicklogic $altera $apex $apexe $gowin" {input_port} {integer} {} {Set the maximum fanout size} {0} {} {} {0}
add_scope_attr {syn_maxfan} "$atmel $proasic 500* PA* $actel $xilinx $lucent $quicklogic $altera $apex $apexe $gowin" {register_output} {integer} {} {Set the maximum fanout size} {0} {} {} {0}
add_scope_attr {syn_maxfan} "$atmel $proasic 500* PA* $actel $xilinx $lucent $quicklogic $altera $apex $apexe $gowin" {cell} {integer} {} {Set the maximum fanout size} {0} {} {} {0}
add_scope_attr {syn_noclockbuf} "$actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $siliconblue" {global} {boolean} {} {Use a normal input buffer} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_noclockbuf} "$actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $siliconblue" {cell} {boolean} {} {Use a normal input buffer} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_noclockbuf} "$actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $siliconblue" {input_port} {boolean} {} {Use a normal input buffer} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_noclockbuf} "$actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $siliconblue" {module} {boolean} {} {Use a normal input buffer} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_noclockpad} "$siliconblue " {global} {boolean} {} {Convert SB_GB_IO to SB_IO and SB_GB} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_noclockpad} "$siliconblue " {cell} {boolean} {} {Convert SB_GB_IO to SB_IO and SB_GB} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_noclockpad} "$siliconblue " {input_port} {boolean} {} {Convert SB_GB_IO to SB_IO and SB_GB} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_noclockpad} "$siliconblue " {module} {boolean} {} {Convert SB_GB_IO to SB_IO and SB_GB} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_resources} "$xilinx apexii mercury* stratix* agilex* cyclone*" {module} {string} {} {Resources used inside a black box} {0} {} {} {0}
add_scope_attr {syn_srlstyle} "$virtex $virtex2 stratix* agilex* cyclone* $lattice_srl $achronix $actel_srl $gowin" {cell} {string} {registers} {Inferred SRL implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3e spartan3 spartan3a virtex2 virtex2p virtex4 virtex5 virtex6 virtex7 aritx7 kintex7 (select_srl registers noextractff_srl) $lattice_srl_new (registers distributed block_ram)  $achronix_srl (registers logic_ram) stratixIII stratixIV stratixV (altshift_tap registers block_ram MLAB)stratix stratixII stratixII-GX stratix-GX cyclone* (altshift_tap registers block_ram) $actel_srl (registers uram) $gowin (registers block_ram distributed_ram)" {} {0}
add_scope_attr {syn_srlstyle} "$virtex $virtex2 stratix* agilex* cyclone* $lattice_srl $achronix $actel_srl $gowin" {global} {string} {registers} {Inferred SRL implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3e spartan3 spartan3a virtex2 virtex2p virtex4 virtex5 virtex6 virtex7 aritx7 kintex7 (select_srl registers noextractff_srl) $lattice_srl_new (registers distributed block_ram)  $achronix_srl (registers logic_ram) stratixIII stratixIV stratixV (altshift_tap registers block_ram MLAB)stratix stratixII stratixII-GX stratix-GX cyclone* (altshift_tap registers block_ram) $actel_srl (registers uram) $gowin (registers block_ram distributed_ram)" {} {0}
add_scope_attr {syn_srlstyle} "$virtex $virtex2 stratix* agilex* cyclone* $lattice_srl $achronix $actel_srl $gowin" {module} {string} {registers} {Inferred SRL implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3e spartan3 spartan3a virtex2 virtex2p virtex4 virtex5 virtex6 virtex7 aritx7 kintex7 (select_srl registers noextractff_srl) $lattice_srl_new (registers distributed block_ram)  $achronix_srl (registers logic_ram) stratixIII stratixIV stratixV (altshift_tap registers block_ram MLAB)stratix stratixII stratixII-GX stratix-GX cyclone* (altshift_tap registers block_ram) $actel_srl (registers uram) $gowin (registers block_ram distributed_ram)" {} {0}
add_scope_attr {syn_ramstyle} "$achronix $pango $atmel $altera $apex $apexe $xilinx $xilinx_ecc $xilinx_US $lattice1 $lucent $quicklogic $actel_ram $siliconblue $gowin" {cell} {string} {registers} {Inferred RAM implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3e spartan3 spartan3a virtex2 virtex2p virtex4 (registers block_ram no_rw_check rw_check area select_ram tmr) virtex5 virtex6 aritx7 kintex7 virtex7 $xilinx_ecc zynq (registers block_ram no_rw_check rw_check area select_ram ecc tmr) $xilinx_US (registers block_ram no_rw_check rw_check area select_ram ecc tmr uram) xilinx_default (registers select_ram block_ram no_rw_check rw_check area tmr) $achronix_srl (registers logic_ram block_ram no_rw_check rw_check) Axcelerator 500K PA ProASIC3 ProASIC3E (registers block_ram no_rw_check rw_check) IGLOO2 SmartFusion2 (registers lsram uram no_rw_check rw_check lsram,rw_check lsram,no_rw_check uram,rw_check uram,no_rw_check) RTG4 (registers lsram uram no_rw_check rw_check lsram,rw_check lsram,no_rw_check uram,rw_check uram,no_rw_check ecc ecc,set uram,ecc lsram,ecc uram,ecc,set lsram,ecc,set) $lattice1 Lattice-EC $lattice1 Lattice-ECP Lattice-ECP2 $lattice1 Lattice-SC $lattice1 Lattice-XP $lattice1 Lattice-MachXO(registers distributed block_ram) $siliconblue SBTiCE65 $siliconblue SBTiCE40(registers block_ram no_rw_check rw_check area) $siliconblue SBTiCE5(registers block_ram no_rw_check rw_check area) $gowin (registers block_ram no_rw_check rw_check distributed_ram) stratix stratixII stratixII-GX stratix-GX(registers block_ram block_ram,no_rw_check M512 M512,no_rw_check M4K M4K,no_rw_check M-RAM M-RAM,no_rw_check, rw_check M512 M512, rw_check M4K M4K, rw_check M-RAM M-RAM, rw_check) cycloneIII stratixIII stratixIV (tmr registers MLAB block_ram block_ram,no_rw_check M9K M9K,no_rw_check M144K M144K,no_rw_check,rw_check M9K M9K,rw_check M144K M144K,rw_check) stratixV(registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) arria10(registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) stratix10 agilex (registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) altera_default (registers block_ram tmr) default (registers) all_enums (registers block_ram no_rw_check rw_check select_ram)" {} {0}
add_scope_attr {syn_ramstyle} "$achronix $pango $atmel $altera $apex $apexe $xilinx $xilinx_ecc $xilinx_US $lattice1 $lucent $quicklogic $actel_ram $siliconblue $gowin" {global} {string} {registers} {Inferred RAM implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3e spartan3 spartan3a virtex2 virtex2p virtex4 (registers block_ram no_rw_check rw_check area select_ram tmr) virtex5 virtex6 aritx7 kintex7 virtex7 $xilinx_ecc zynq (registers block_ram no_rw_check rw_check area select_ram ecc tmr) $xilinx_US (registers block_ram no_rw_check rw_check area select_ram ecc tmr uram) xilinx_default (registers select_ram block_ram no_rw_check rw_check area tmr) $achronix_srl (registers logic_ram block_ram no_rw_check rw_check) Axcelerator 500K PA ProASIC3 ProASIC3E (registers block_ram no_rw_check rw_check) IGLOO2 SmartFusion2 (registers lsram uram no_rw_check rw_check lsram,rw_check lsram,no_rw_check uram,rw_check uram,no_rw_check) RTG4 (registers lsram uram no_rw_check rw_check lsram,rw_check lsram,no_rw_check uram,rw_check uram,no_rw_check ecc ecc,set uram,ecc lsram,ecc uram,ecc,set lsram,ecc,set) $lattice1 Lattice-EC $lattice1 Lattice-ECP Lattice-ECP2 $lattice1 Lattice-SC $lattice1 Lattice-XP $lattice1 Lattice-MachXO(registers distributed block_ram) $siliconblue SBTiCE65 $siliconblue SBTiCE40(registers block_ram no_rw_check rw_check area) $siliconblue SBTiCE5(registers block_ram no_rw_check rw_check area) $gowin (registers block_ram no_rw_check rw_check distributed_ram) stratix stratixII stratixII-GX stratix-GX(registers block_ram block_ram,no_rw_check M512 M512,no_rw_check M4K M4K,no_rw_check M-RAM M-RAM,no_rw_check, rw_check M512 M512, rw_check M4K M4K, rw_check M-RAM M-RAM, rw_check) cycloneIII stratixIII stratixIV (tmr registers MLAB block_ram block_ram,no_rw_check M9K M9K,no_rw_check M144K M144K,no_rw_check,rw_check M9K M9K,rw_check M144K M144K,rw_check) stratixV(registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) arria10(registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) stratix10 agilex (registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) altera_default (registers block_ram tmr) default (registers) all_enums (registers block_ram no_rw_check rw_check select_ram)" {} {0}
add_scope_attr {syn_ramstyle} "$achronix $pango $atmel $altera $apex $apexe $xilinx $xilinx_ecc $xilinx_US $lattice1 $lucent $quicklogic $actel_ram $siliconblue $gowin" {module} {string} {registers} {Inferred RAM implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3e spartan3 spartan3a virtex2 virtex2p virtex4 (registers block_ram no_rw_check rw_check area select_ram tmr) virtex5 virtex6 aritx7 kintex7 virtex7 $xilinx_ecc zynq (registers block_ram no_rw_check rw_check area select_ram ecc tmr) $xilinx_US (registers block_ram no_rw_check rw_check area select_ram ecc tmr uram) xilinx_default (registers select_ram block_ram no_rw_check rw_check area tmr) $achronix_srl (registers logic_ram block_ram no_rw_check rw_check) Axcelerator 500K PA ProASIC3 ProASIC3E (registers block_ram no_rw_check rw_check) IGLOO2 SmartFusion2 (registers lsram uram no_rw_check rw_check lsram,rw_check lsram,no_rw_check uram,rw_check uram,no_rw_check) RTG4 (registers lsram uram no_rw_check rw_check lsram,rw_check lsram,no_rw_check uram,rw_check uram,no_rw_check ecc ecc,set uram,ecc lsram,ecc uram,ecc,set lsram,ecc,set) $lattice1 Lattice-EC $lattice1 Lattice-ECP Lattice-ECP2 $lattice1 Lattice-SC $lattice1 Lattice-XP $lattice1 Lattice-MachXO(registers distributed block_ram) $siliconblue SBTiCE65 $siliconblue SBTiCE40(registers block_ram no_rw_check rw_check area) $siliconblue SBTiCE5(registers block_ram no_rw_check rw_check area) $gowin (registers block_ram no_rw_check rw_check distributed_ram) stratix stratixII stratixII-GX stratix-GX(registers block_ram block_ram,no_rw_check M512 M512,no_rw_check M4K M4K,no_rw_check M-RAM M-RAM,no_rw_check, rw_check M512 M512, rw_check M4K M4K, rw_check M-RAM M-RAM, rw_check) cycloneIII stratixIII stratixIV (tmr registers MLAB block_ram block_ram,no_rw_check M9K M9K,no_rw_check M144K M144K,no_rw_check,rw_check M9K M9K,rw_check M144K M144K,rw_check) stratixV(registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) arria10(registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) stratix10 agilex (registers MLAB block_ram block_ram,no_rw_check, block_ram,rw_check,ecc tmr) altera_default (registers block_ram tmr) default (registers) all_enums (registers block_ram no_rw_check rw_check select_ram)" {} {0}
add_scope_attr {syn_corrupt_pd} "$xilinx" {global} {string} {none} {Power domain corruption type} {0} {xilinx_default (none all1s all0s random) } {} {0}
add_scope_attr {syn_corrupt_pd} "$xilinx" {cell} {string} {none} {Power domain corruption type} {0} {xilinx_default (none all1s all0s random) } {} {0}
add_scope_attr {syn_insert_pad} "$virtex $achronix $pango $gowin  SmartFusion2 IGLOO2 RTG4 SBTiCE40*" {port} {boolean} {1 0} {Add or remove a pad from a port.} {0} {} {} {0}
add_scope_attr {syn_insert_pad} "$virtex $achronix $pango $gowin  SmartFusion2 IGLOO2 RTG4 SBTiCE40*" {signal} {boolean} {1 0} {Add or remove a pad from a port.} {0} {} {} {0}
add_scope_attr {syn_multstyle} "$virtex $virtex2 $pango $altera $apex $apexe $apex20k $lucent $lattice $mach excalibur* spartan3 Axcelerator IGLOO2 RTG4 SmartFusion2 arriaV arria10 stratix10 agilex cycloneV SBTiCE40UP" {cell} {string} {block_mult} {Inferred multiplier implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3 spartan3e virtex2 virtex2p virtex4 virtex5(logic block_mult)arriaV cycloneV arria10 stratix10 agilex (logic lpm_mult altmult_add block_mult simd) stratix(logic lpm_mult altmult_add block_mult) altera_default (logic lpm_mult altmult_add block_mult) Axcelerator IGLOO2 RTG4 SmartFusion2 (logic DSP) actel_default (logic DSP) $lattice_srl_new (block_mult logic) all_enums (logic block_mult lpm_mult simd) SBTiCE40UP (DSP logic)" {} {0}
add_scope_attr {syn_multstyle} "$virtex $virtex2 $pango $altera $apex $apexe $apex20k $lucent $lattice $mach excalibur* spartan3 Axcelerator IGLOO2 RTG4 SmartFusion2 arriaV arria10 stratix10 agilex cycloneV SBTiCE40UP" {global} {string} {block_mult} {Inferred multiplier implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3 spartan3e virtex2 virtex2p virtex4 virtex5(logic block_mult)arriaV cycloneV arria10 stratix10 agilex (logic lpm_mult altmult_add block_mult simd) stratix(logic lpm_mult altmult_add block_mult) altera_default (logic lpm_mult altmult_add block_mult) Axcelerator IGLOO2 RTG4 SmartFusion2 (logic DSP) actel_default (logic DSP) $lattice_srl_new (block_mult logic) all_enums (logic block_mult lpm_mult simd) SBTiCE40UP (DSP logic)" {} {0}
add_scope_attr {syn_multstyle} "$virtex $virtex2 $pango $altera $apex $apexe $apex20k $lucent $lattice $mach excalibur* spartan3 Axcelerator IGLOO2 RTG4 SmartFusion2 arriaV arria10 stratix10 agilex cycloneV SBTiCE40UP" {module} {string} {block_mult} {Inferred multiplier implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3 spartan3e virtex2 virtex2p virtex4 virtex5(logic block_mult)arriaV cycloneV arria10 stratix10 agilex (logic lpm_mult altmult_add block_mult simd) stratix(logic lpm_mult altmult_add block_mult) altera_default (logic lpm_mult altmult_add block_mult) Axcelerator IGLOO2 RTG4 SmartFusion2 (logic DSP) actel_default (logic DSP) $lattice_srl_new (block_mult logic) all_enums (logic block_mult lpm_mult simd) SBTiCE40UP (DSP logic)" {} {0}
add_scope_attr {syn_use_carry_chain} "$lattice1 $siliconblue" {cell} {integer} {} {Infer a carry chain} {0} {} {} {0}
add_scope_attr {syn_use_carry_chain} "$lattice1 $siliconblue" {global} {integer} {} {Infer a carry chain} {0} {} {} {0}
add_scope_attr {syn_use_carry_chain} "$lattice1 $siliconblue" {module} {integer} {} {Infer a carry chain} {0} {} {} {0}
add_scope_attr {syn_tops_region_size} "$virtex $virtex2" {global} {integer} {} {max. size of valid TOPS region in LUTs} {0} {} {amplify} {0}
add_scope_attr {syn_romstyle} "$altera $pango $apex $apexe $lattice1 $xilinx $siliconblue $gowin" {cell} {string} {logic} {Inferred ROM implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3 Spartan3A Spartan-3A-DSP spartan3e virtex2 virtex2p virtex4 virtex5(logic block_rom select_rom) xilinx_default (logic block_rom select_rom) $achronix_srl (logic block_rom) $lattice1 Lattice-EC $lattice1 Lattice-ECP $lattice1 Lattice-SC $lattice1 Lattice-XP $lattice1 Lattice-MachXO(logic distributed block_rom) $siliconblue SBTiCE65 $siliconblue SBTiCE40(logic block_rom) $siliconblue SBTiCE5(logic block_rom) $gowin GoWin(logic block_rom distributed_rom) stratix stratixII stratix-GX(logic block_rom) stratixIII stratixIV stratixV(logic block_rom MLAB) altera_default(logic block_rom lpm_rom) default(logic) all_enums (logic select_rom block_rom) " {} {0}
add_scope_attr {syn_romstyle} "$altera $pango $apex $apexe $lattice1 $xilinx $siliconblue $gowin" {global} {string} {logic} {Inferred ROM implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3 Spartan3A Spartan-3A-DSP spartan3e virtex2 virtex2p virtex4 virtex5(logic block_rom select_rom) xilinx_default (logic block_rom select_rom) $achronix_srl (logic block_rom) $lattice1 Lattice-EC $lattice1 Lattice-ECP $lattice1 Lattice-SC $lattice1 Lattice-XP $lattice1 Lattice-MachXO(logic distributed block_rom) $siliconblue SBTiCE65 $siliconblue SBTiCE40(logic block_rom) $siliconblue SBTiCE5(logic block_rom) $gowin GoWin(logic block_rom distributed_rom) stratix stratixII stratix-GX(logic block_rom) stratixIII stratixIV stratixV(logic block_rom MLAB) altera_default(logic block_rom lpm_rom) default(logic) all_enums (logic select_rom block_rom) " {} {0}
add_scope_attr {syn_romstyle} "$altera $pango $apex $apexe $lattice1 $xilinx $siliconblue $gowin" {module} {string} {logic} {Inferred ROM implementation style} {0} "Virtex virtex-E spartan2 spartan2e spartan3 Spartan3A Spartan-3A-DSP spartan3e virtex2 virtex2p virtex4 virtex5(logic block_rom select_rom) xilinx_default (logic block_rom select_rom) $achronix_srl (logic block_rom) $lattice1 Lattice-EC $lattice1 Lattice-ECP $lattice1 Lattice-SC $lattice1 Lattice-XP $lattice1 Lattice-MachXO(logic distributed block_rom) $siliconblue SBTiCE65 $siliconblue SBTiCE40(logic block_rom) $siliconblue SBTiCE5(logic block_rom) $gowin GoWin(logic block_rom distributed_rom) stratix stratixII stratix-GX(logic block_rom) stratixIII stratixIV stratixV(logic block_rom MLAB) altera_default(logic block_rom lpm_rom) default(logic) all_enums (logic select_rom block_rom) " {} {0}
add_scope_attr {syn_pipeline} "$altera $apex $apexe $xilinx $gowin" {register} {boolean} {1} {Allow register pipelining} {0} {} {} {0}
add_scope_attr {syn_no_compile_point} "$altera $apex $apexe $xilinx" {module} {boolean} {1} {Do not use this view as a Compile Point} {0} {1} {} {0}
add_scope_attr {syn_cp_use_fast_synthesis} "$altera $apex $apexe $xilinx" {module} {boolean} {1} {Use Fast Synthesis to map this Compile Point} {0} {1} {amplify} {0}
add_scope_attr {syn_noarrayports} "$actel $actel_ram $achronix $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds " {global} {boolean} {} {Disable array ports} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_edif_name_length} "$altera" {global} {string} {Restricted} {Use Restricted for MAXII; Unrestricted for Quartus} {0} {Restricted Unrestricted} {} {0}
add_scope_attr {syn_netlist_hierarchy} {*} {global} {boolean} {} {Enable hierarchy reconstruction} {0} {} {~synplify_asic} {0}
add_scope_attr {syn_hier} "$actel $actel_ram $achronix $pango $proasic $altera $altera_retiming $apexe $lattice $mach $quicklogic $lattice_srl $xilinx $xilinx_cplds $siliconblue $gowin" {module} {string} {} {Control hierarchy flattening} {0} {proASIC (soft remove flatten firm fixed) xilinx_default(hard soft remove flatten firm fixed) gowin_default actel_default altera_default all_enums(hard soft macro remove flatten firm fixed) lucent_default (soft macro remove flatten firm fixed) quicklogic_default(soft macro remove flatten firm fixed) default(soft remove flatten firm fixed)} {} {0}
add_scope_attr {syn_allowed_resources} "$cp_only " {module} {string} {} {Set available resources in a Compile Point} {0} {} {} {0}
add_scope_attr {alspin} "$actel" {port} {string} {} {Pin locations for I/Os} {0} {} {} {0}
add_scope_attr {alspreserve} "$actel" {signal} {boolean} {} {Preserve a net} {0} {} {} {0}
add_scope_attr {syn_global_buffers} "$proasic $xilinx $siliconblue" {global} {integer} {} {Set available number of global buffers} {0} {} {} {0}
add_scope_attr {syn_insert_buffer} "$actel $proasic $pango $siliconblue RTG4" {port} {string} {} {Insert a buffer on a signal} {0} {ProASIC3 ProASIC3E ProASIC3L IGLOO IGLOOE IGLOO+ (CLKINT HCLKINT CLKBUF HCLKBUF) IGLOO2 RTG4 SmartFusion2 (CLKINT RCLKINT CLKBUF CLKBIBUF)} {} {0}
add_scope_attr {syn_insert_buffer} "$actel $proasic $pango $siliconblue RTG4" {signal} {string} {} {Insert a buffer on a signal} {0} {ProASIC3 ProASIC3E ProASIC3L IGLOO IGLOOE IGLOO+ (CLKINT HCLKINT CLKBUF HCLKBUF) IGLOO2 RTG4 SmartFusion2 (CLKINT RCLKINT CLKBUF CLKBIBUF)} {} {0}
add_scope_attr {syn_insert_buffer} "$xilinx" {port} {string} {} {Insert a buffer on a signal} {0} {BUFG BUFGMUX BUFH BUFR} {} {0}
add_scope_attr {syn_insert_buffer} "$xilinx" {cell} {string} {} {Insert a buffer on a signal} {0} {BUFG BUFGMUX BUFH BUFR} {} {0}
add_scope_attr {syn_insert_buffer} "$xilinx" {signal} {string} {} {Insert a buffer on a signal} {0} {BUFG BUFGMUX BUFH BUFR} {} {0}
add_scope_attr {altera_chip_pin_lc} "$altera $apex $apexe" {port} {string} {} {Set I/O pin location} {0} {} {} {0}
add_scope_attr {altera_implement_in_eab} "$altera $apex $apexe" {cell} {boolean} {1} {Implement in Altera EABs, apply to module/component instance name only} {0} {} {} {0}
add_scope_attr {altera_auto_use_eab} "$altera $apex $apexe" {global} {boolean} {1} {Use EABs automatically} {0} {} {} {0}
add_scope_attr {altera_auto_use_esb} "$altera $apex $apexe" {global} {boolean} {1} {Use ESBs automatically} {0} {} {} {0}
add_scope_attr {altera_implement_in_esb} "$apex $apexe" {cell} {boolean} {1} {Implement in Altera ESBs, apply to module/component instance name only} {0} {} {} {0}
add_scope_attr {altera_logiclock_location} "$apex $apexe" {module} {string} {floating} {Specify the location of LogicLock region} {0} {} {} {0}
add_scope_attr {altera_logiclock_size} "$apex $apexe" {module} {string} {auto} {Specify the size of LogicLock region} {0} {} {} {0}
add_scope_attr {altera_io_opendrain} {apex20kc apex20ke excalibur* mercury* cyclone* stratix* agilex* acex* flex10k* } {port} {boolean} {} {Use opendrain capability on port or bit-port.} {0} {} {} {0}
add_scope_attr {altera_io_powerup} "$altera_retiming" {port} {string} {} {Powerup high or low on port or bit-port in APEX20KE.} {0} {} {} {0}
add_scope_attr {syn_altera_model} "$apex $apexe $altera" {module} {string} {on} {Call clearbox on Altera Megafunctions instantiated in this view} {0} {on off} {} {0}
add_scope_attr {lock} "$lattice $quicklogic" {port} {string} {} {Set pin locations for Lattice I/Os} {0} {} {} {0}
add_scope_attr {din} "$lucent" {input_port} {string} {} {Input register goes next to I/O pad} {0} {} {} {0}
add_scope_attr {dout} "$lucent" {output_port} {string} {} {Output register goes next to I/O pad} {0} {} {} {0}
add_scope_attr {orca_padtype} "$lucent" {port} {string} {} {Pad type for I/O} {0} {} {} {0}
add_scope_attr {orca_props} "$lucent" {cell} {string} {} {Forward annotate attributes to ORCA back-end} {0} {} {} {0}
add_scope_attr {orca_props} "$lucent" {port} {string} {} {Forward annotate attributes to ORCA back-end} {0} {} {} {0}
add_scope_attr {loc} "$lucent $mach" {port} {string} {} {Set pin location} {0} {} {} {0}
add_scope_attr {ql_padtype} "$quicklogic" {port} {string} {} {Override default pad types (use BIDIR, INPUT, CLOCK)} {0} {BIDIR INPUT CLOCK} {} {0}
add_scope_attr {ql_placement} "$quicklogic" {port} {string} {} {Placement location} {0} {} {} {0}
add_scope_attr {ql_placement} "$quicklogic" {cell} {string} {} {Placement location} {0} {} {} {0}
add_scope_attr {xc_loc} "$xilinx $xilinx_cplds" {port} {string} {} {Set port placement} {0} {} {} {0}
add_scope_attr {xc_rloc} "$xilinx" {cell} {string} {} {Specify relative placement; use with xc_uset} {0} {} {} {0}
add_scope_attr {xc_uset} "$xilinx" {cell} {string} {} {Assign group name for placement; use with xc_rloc} {0} {} {} {0}
add_scope_attr {xc_fast} "$xilinx" {output_port} {boolean} {} {Fast transition time} {0} {} {} {0}
add_scope_attr {xc_nodelay} "$xilinx" {input_port} {boolean} {} {Remove input delay} {0} {} {} {0}
add_scope_attr {xc_slow} "$xilinx" {output_port} {boolean} {} {Slow transition time} {0} {} {} {0}
add_scope_attr {xc_pullup} "$xilinx" {port} {boolean} {} {Add a pull-up} {0} {} {} {0}
add_scope_attr {xc_pulldown} "$xilinx" {port} {boolean} {} {Add a pull-down} {0} {} {} {0}
add_scope_attr {xc_clockbuftype} "$xilinx" {input_port} {string} {BUFGDLL} {Use the Xilinx BUFGDLL clock buffer} {0} {} {} {0}
add_scope_attr {xc_padtype} "$xilinx" {port} {string} {} {Set an I/O standard for an I/O buffer} {0} {} {} {0}
add_scope_attr {xc_global_buffers} "$xilinx" {global} {integer} {} {Number of global buffers} {0} {} {} {0}
add_scope_attr {xc_use_timespec_for_io} "$xilinx" {global} {boolean} {0} {Enable use of from-to timepsec instead of offset for I/O constraint} {0} {} {} {0}
add_scope_attr {xc_pseudo_pin_loc} "$xilinx" {signal} {string} {CLB_RrrCcc:CLB_RrrCcc} {Pseudo pin location on place and route block } {0} {} {} {0}
add_scope_attr {xc_modular_design} "$xilinx" {global} {boolean} {1} {Enable modular design flow } {0} {} {} {0}
add_scope_attr {xc_modular_region} "$xilinx" {cell} {string} {rr#cc#rr#cc} {Specify the number of CLB's for a modular region} {0} {} {} {0}
add_scope_attr {xc_area_group} "$xilinx" {cell} {string} {rr#cc#rr#cc} {Specify region where instance should be placed} {0} {} {} {0}
add_scope_attr {xc_props} "$xilinx" {cell} {string} {} {Extra XNF attributes to pass for instance} {0} {} {} {0}
add_scope_attr {xc_map} "$xilinx" {module} {string} {} {Map entity to fmap/hmap/lut} {0} {fmap hmap lut} {} {0}
add_scope_attr {syn_tristatetomux} "$xilinx" {module} {integer} {} {Threshold for converting tristates to MUX} {0} {} {} {0}
add_scope_attr {syn_tristatetomux} "$xilinx" {global} {integer} {} {Threshold for converting tristates to MUX} {0} {} {} {0}
add_scope_attr {syn_edif_bit_format} "$xilinx" {global} {string} {} {Format bus names in EDIF} {0} {%u<%i> %u[%i] %u(%i) %u_%i %u%i %d<%i> %d[%i] %d(%i) %d_%i %d%i %n<%i> %n[%i] %n(%i) %n_%i %n%i} {} {0}
add_scope_attr {syn_edif_scalar_format} "$xilinx" {global} {string} {} {Format scalar names in EDIF} {0} {%u %n %d} {} {0}
add_scope_attr {xc_fast_auto} "$xilinx" {global} {boolean} {} {Enable automatic fast output buffer use} {0} {} {} {0}
add_scope_attr {xc_use_rpms} "$phys" {global} {boolean} {0} {Allow use of Relatively Placed Macros (RPM)} {0} {} {} {0}
add_scope_attr {tr_map} "$triscend" {module} {string} {} {Map entity to LUT} {0} {} {} {0}
add_scope_attr {syn_props} "$triscend" {cell} {string} {} {Extra attributes to pass to EDIF for instance} {0} {} {} {0}
add_scope_attr {syn_replicate} "$proasic 500k* PA* $virtex $virtex2 $altera $apex $apexe $apex20k $siliconblue $gowin" {global} {boolean} {0} {Controls replication of registers} {0} {} {} {0}
add_scope_attr {syn_replicate} "$proasic 500k* PA* $virtex $virtex2 $altera $apex $apexe $apex20k $siliconblue $gowin" {register} {boolean} {0} {Controls replication of registers} {0} {} {} {0}
add_scope_attr {syn_dspstyle} "$achronix" {cell} {string} {dsp} {Inferred DSP implementation style} {0} "$achronix_srl (logic dsp) all_enums (logic dsp)" {} {0}
add_scope_attr {syn_dspstyle} "$achronix" {module} {string} {dsp} {Inferred DSP implementation style} {0} "$achronix_srl (logic dsp) all_enums (logic dsp)" {} {0}
add_scope_attr {syn_dspstyle} "$achronix" {global} {string} {dsp} {Inferred DSP implementation style} {0} "$achronix_srl (logic dsp) all_enums (logic dsp)" {} {0}
add_scope_attr {syn_dspstyle} "virtex4 virtex5 virtex6 virtex7 $siliconblue $gowin $titan" {cell} {string} {dsp48} {Inferred DSP implementation style} {0} "virtex4(logic dsp48) virtex5 virtex6 virtex7(logic dsp48 simd) $siliconblue SBTiCE40(logic dsp) $gowin GoWin(logic dsp) $siliconblue SBTiCE5(logic dsp) $titan (logic DSP) all_enums (logic dsp48)" {} {0}
add_scope_attr {syn_dspstyle} "virtex4 virtex5 virtex6 virtex7 $siliconblue $gowin $titan" {module} {string} {dsp48} {Inferred DSP implementation style} {0} "virtex4(logic dsp48) virtex5 virtex6 virtex7(logic dsp48 simd) $siliconblue SBTiCE40(logic dsp) $gowin GoWin(logic dsp) $siliconblue SBTiCE5(logic dsp) $titan (logic DSP) all_enums (logic dsp48)" {} {0}
add_scope_attr {syn_dspstyle} "virtex4 virtex5 virtex6 virtex7 $siliconblue $gowin $titan" {global} {string} {dsp48} {Inferred DSP implementation style} {0} "virtex4(logic dsp48) virtex5 virtex6 virtex7(logic dsp48 simd) $siliconblue SBTiCE40(logic dsp) $gowin GoWin(logic dsp) $siliconblue SBTiCE5(logic dsp) $titan (logic DSP) all_enums (logic dsp48)" {} {0}
add_scope_attr {syn_clean_reset} {virtex4 virtex5} {global} {string} {dsp48_no_simulate,one_flop} {Convert asynchronous reset to synchronous reset to enable packing of registers into a DSP block} {0} {virtex4 virtex5(dsp48_no_simulate,one_flop} {} {0}
add_scope_attr {syn_diff_io} "$xilinx" {port} {boolean} {} {Infer Differential I/O pads} {0} {} {} {0}
add_scope_attr {syn_clock_priority} "$xilinx" {port} {integer} {1} {Set clock priority to be forward annotated to the Xilinx UCF file} {0} {} {} {0}
add_scope_attr {syn_clock_priority} "$xilinx" {signal} {integer} {1} {Set clock priority to be forward annotated to the Xilinx UCF file} {0} {} {} {0}
add_scope_attr {syn_set_value} "$asic" {port} {boolean} {} {Optimize with object set to given value} {0} {} {synplify_asic} {0}
add_scope_attr {syn_set_value} "$asic" {signal} {boolean} {} {Optimize with object set to given value} {0} {} {synplify_asic} {0}
add_scope_attr {syn_modgen_style} "$asic" {global} {string} {} {Set the operator implementation} {0} {small fast} {synplify_asic} {0}
add_scope_attr {syn_scan_enable} "$asic" {module} {boolean} {1} {Enable scan for test} {0} {} {synplify_asic} {0}
add_scope_attr {syn_scan_enable} "$asic" {cell} {boolean} {1} {Enable scan for test} {0} {} {synplify_asic} {0}
add_scope_attr {syn_scan_enable} "$asic" {port} {boolean} {1} {Enable scan for test} {0} {} {synplify_asic} {0}
add_scope_attr {syn_scan_enable} "$asic" {signal} {boolean} {1} {Enable scan for test} {0} {} {synplify_asic} {0}
add_scope_attr {syn_clockgating_threshold} "$asic" {global} {integer} {} {Set the minimum number of registers (with common clock and enable signals) to convert to a gated clock} {0} {} {synplify_asic amplify_asic} {0}
add_scope_attr {syn_clockgating_max_sinks} "$asic" {global} {integer} {} {Set the maximum number of registers connected to a clock gating cell} {0} {} {synplify_asic amplify_asic} {0}
add_scope_attr {syn_timing_mode} "$asic" {cell} {string} {} {Set the mode for timing analysis} {0} {} {synplify_asic amplify_asic} {0}
add_scope_attr {syn_ects_output_clock_tree} {issp} {global} {boolean} {1} {Insert and output embedded clock tree in def and vma} {0} {} {} {1}
add_scope_attr {syn_embedded_clock_type} {issp} {cell} {string} {main} {Assign user clock to given value} {0} {main local none} {} {1}
add_scope_attr {xc_ncf_auto_relax} "$xilinx" {global} {boolean} {0} {Set automatic relaxation of constraints forward-annotated to the NCF file } {0} {} {} {0}
add_scope_attr {xc_use_xmodule} "$xilinx" {module} {boolean} {0} {Mark a hierarchical block or Compile Point as a module that can be implemented independently by the P&R tool} {0} {} {} {0}
add_scope_attr {xc_use_keep_hierarchy} "$xilinx" {module} {boolean} {0} {Preserve the hierarchy of the module for diagnostics and timing simulation} {0} {} {} {0}
add_scope_attr {syn_unconnected_inputs} "$achronix  $pango" {cell} {string} {} {Leave a pin unconnected on an instance} {0} {} {} {0}
add_scope_attr {syn_unconnected_inputs} "$achronix  $pango" {module} {string} {} {Leave a pin unconnected on an instance} {0} {} {} {0}
add_scope_attr {syn_max_memsize_reg} "$achronix  $pango" {global} {integer} {128} {Define the maximum allowed memory size for memory to be mapped to registers} {0} {} {} {0}
add_scope_attr {syn_reduce_controlset_size} "$achronix  $pango" {global} {integer} {32} {Define the minimum fanout for control signals} {0} {} {} {0}
add_scope_attr {syn_g5_cfg_inference} "$microsemi" {global} {integer} {6} {Set the maximum size of CFG inputs} {0} {4 5 6} {} {0}
add_scope_attr {syn_g5_cfg4_areacost} "$microsemi" {global} {string} {1} {Set the area cost of CFG4} {0} {} {} {0}
add_scope_attr {syn_g5_cfg5_areacost} "$microsemi" {global} {string} {1.25} {Set the area cost of CFG5} {0} {} {} {0}
add_scope_attr {syn_g5_cfg6_areacost} "$microsemi" {global} {string} {1.5} {Set the area cost of CFG6} {0} {} {} {0}
add_scope_attr {syn_g5_route_delay_scale} "$microsemi" {global} {string} {1.0} {Set the route delay scaling factor} {0} {} {} {0}
add_scope_attr {syn_g5_cfg_pindelay_ay} "$microsemi" {global} {integer} {58} {Set the CFG pin delay from A to Y in ps} {0} {} {} {0}
add_scope_attr {syn_g5_cfg_pindelay_by} "$microsemi" {global} {integer} {124} {Set the CFG pin delay from B to Y in ps} {0} {} {} {0}
add_scope_attr {syn_g5_cfg_pindelay_cy} "$microsemi" {global} {integer} {157} {Set the CFG pin delay from C to Y in ps} {0} {} {} {0}
add_scope_attr {syn_g5_cfg_pindelay_dy} "$microsemi" {global} {integer} {223} {Set the CFG pin delay from D to Y in ps} {0} {} {} {0}
add_scope_attr {syn_g5_cfg_pindelay_ey} "$microsemi" {global} {integer} {256} {Set the CFG pin delay from E to Y in ps} {0} {} {} {0}
add_scope_attr {syn_g5_cfg_pindelay_fy} "$microsemi" {global} {integer} {372} {Set the CFG pin delay from F to Y in ps} {0} {} {} {0}
add_scope_attr {syn_direct_reset} "$gowin" {port} {integer} {0} {} {0} {} {} {0}
add_scope_attr {syn_direct_set} "$gowin" {port} {integer} {0} {} {0} {} {} {0}
add_scope_attr {syn_io_type} "$gowin" {port} {string} {LVDS25} {} {0} {LVDS25 RSDS MINILVDS PPLVDS LVDS25E BLVDS25 MLVDS25 RSDS25E LVPECL33 HSTL15_I HSTL15D_I HSTL18_I HSTL18_II HSTL18D_I HSTL18D_II SSTL15 SSTL15D SSTL18_I SSTL18_II SSTL18D_I SSTL18D_II SSTL25_I SSTL25_II SSTL25D_I SSTL25D_II SSTL33_I SSTL33_II SSTL33D_I SSTL33D_II LVTTL33 LVCMOS33 LVCMOS33D LVCMOS25 LVCMOS25D LVCMOS18 LVCMOS18D LVCMOS15 LVCMOS15D LVCMOS12 LVCMOS12D PCI33} {} {0}
add_scope_attr {syn_pullup} "$gowin" {port} {boolean} {0} {Add a pull-up} {0} {} {} {0}
add_scope_attr {syn_pulldown} "$gowin" {port} {boolean} {0} {Add a pull-down} {0} {} {} {0}
add_scope_attr {syn_pad_type} "$gowin" {port} {string} {} {} {0} {} {} {0}
add_scope_attr {syn_tlvds_io} "$gowin" {port} {boolean} {0} {Infer Differential I/O pads} {0} {} {} {0}
add_scope_attr {syn_elvds_io} "$gowin" {port} {boolean} {0} {Infer Differential I/O pads} {0} {} {} {0}
add_scope_attr {syn_area_group} "$gowin" {module} {string} {rr#cc#:rr#cc#} {Specify region where instance should be placed} {0} {} {} {0}
