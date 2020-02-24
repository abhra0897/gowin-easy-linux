# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
# $Header: //synplicity/map200rc/misc/vif2formality.tcl#3 $
# Created by Synopsys SBG CAEs
# $Name: s901 $
proc vif2formality {f {mode "map"} {opts "-noconst"}} {

# Flag for converting constant information. Turned OFF by default
global V2C_CONST
if { $opts=="-const" } {
set V2C_CONST 1
} else {
set V2C_CONST 0
}
global exten
if { $mode=="compile" } {
set exten "_compile"
} else {
set exten ""
}
	
# Declare global variables
global f_name
global TECH
global vtc
global mytcl
global usermatch
global merge_v  [list]
global merge_v_inv  [list]
global my_lib
global in_file
global rtl
global netlist
global rtl_ver
global netlist_ver
global netlist_name
global rtl_vhd
global netlist_vhd
global top_golden
global top_revised
global fsm_list
global include_path
global inc_var
global bb_modules
global gated_clocks
		#Use vlc_file_flag to execute the gen_vlc routine only once
global vlc_file_flag
		#Flag to delimit block-ram memory annotations
		#Currently inferred block memories are not supported in FV flow
		#Inferred memory annotations can be large in number depending on size of memory
		#This flag is used to by-pass conversion of the vif_set_map_point annotations for block mem
		#Xilinx mapper de-limits these annotations with a "# Block ram points" comment.
global block_mem_flag
global a
global b
global cs
global h
global g
global j

set cs ""
set h ""
set include_path "+incdir"
set inc_var ""
		
# initialize all variables
set rtl ""
set netlist ""
set rtl_ver ""
set netlist_ver ""
set netlist_name ""
set rtl_vhd ""
set netlist_vhd ""
set top_golden ""
set top_revised ""
set fsm_list ""
set TECH ""
set my_lib ""
set my_lib ""
set in_file [open $f]
set f_name [file tail [file rootname $f]]
set bb_modules ""
set block_mem_flag 0
set gated_clocks 0
set vlc_file_flag 0

set vtc [open temp.svf w]
set mytcl [open temp.tcl w]
set usermatch [open usermatch.txt w]
close $vtc
close $mytcl
close $usermatch
# Open vlc file Handle
set vlc [open temp.svf a]
# Open vsc file Handle
set vsc [open temp.svf a]
# Open vmc file Handle
set vmc [open temp.svf a]
 puts $vmc "//Map Points\n"
# Open vsq file Handle
set vsq [open temp.svf a]
# Open vcn file Handle
set vcn [open temp.svf a]
	puts $vcn "//Register Constant information\n"
# Open vtc file Handle
global vtc
set vtc [open temp.svf a]
set mytcl [open temp.tcl a]
set usermatch [open usermatch.txt a]
puts $mytcl "set synopsys_auto_setup true"
#puts $mytcl "set XILINX \[get_unix_variable \"XILINX\"\]"
#puts $mytcl "set QUARTUS_ROOTDIR \[get_unix_variable \"QUARTUS_ROOTDIR\"\]"
#puts $mytcl "set hdlin_library_directory \$XILINX\/verilog\/verplex\/unisims"
#puts $mytcl "set hdlin_verilog_directive_prefixes \" synthesis \" "
#puts $mytcl "set hdlin_vhdl_directive_prefixes \" synthesis \" "
#puts $mytcl "set hdlin_clock_gate_hold_mode  \" any \" "
puts $mytcl "set_svf $f_name.svf"
#puts $vtc "get_unix_variable \"QUARTUS_ROOTDIR\""
# Open gcc file Handle
set gcc [open temp.svf a]
	puts $gcc "//Gated Clock Conversion annotations\n"

puts $vtc "guide"
puts $vtc "guide_environment \\"
puts $vtc "\{ \{ bus_dimension_separator_style \]\[ \} \\"
puts $vtc "\{ bus_extraction_style \%s\\\[\%d\:\%d\\\] \} \\"
puts $vtc "\{ bus_naming_style \%s\[\%d\] \} \\"
puts $vtc "\}"

# Close vlc file handle
close $vlc
# Close vsc file handle
close $vsc
# Close vmc file handle
close $vmc
# Close vsq file handle
close $vsq
# Close gcc file handle
close $gcc
# Close vcn file handle
close $vcn


while {[gets $in_file line] >= 0} {
# "a" is a temp variable to store the string following the
# vif_[set/add]* commands which is passed to the
# appropriate procedures to write Conformal side files 
	switch -regexp $line {
		{^ *# *Block ram points.*} {
			# Mark the begining of block mem annotations
			set block_mem_flag 1			}
		{^ *#.*$} {
			# Mark end of block mem annotations
			if { $block_mem_flag == 1} { set block_mem_flag 0 }
			}
		{^ *vif_add_library.*\-translated.*} { 
			regsub {^.*vif_set_library } $line "" a
			#execute gen_vlc routine only once. Flag set to 1 inside routine
			if { $vlc_file_flag == 0 } {
			gen_vlc $f_name $a }
		}
		#vif_add_library.*\-original.* { 
		#	regsub {^.*vif_set_library } $line "" a
		#	gen_vlc $f_name $a	}
		{^ *vif_set_merge.*\-original.*}	{
			regsub {^.*vif_set_merge } $line "" b
                        regsub -all {_Z} $b {} cs

                      if {[regexp {\/} [lindex $cs 1]] == 1 } {
                         set lst [split [lindex $cs 1] / ] 
                         set rep [lindex $lst end]
                          if {[regexp {\[} $rep] == 0 } {
                            set n_rep [lindex $rep 0]_reg
                            } else {
                            regsub {\[} $rep {_reg[} n_rep 
                          }
                           set g [join [lreplace $lst end end $n_rep] /]
                          } else {
                            if {[regexp {\[} [lindex $cs 1]] == 0 } {
                               set g [lindex $cs 1]_reg 
                             } else {
                              regsub {\[} [lindex $cs 1] {_reg[} g 
                             }
                          }


                      if {[regexp {\/} [lindex $cs 2]] == 1 } {
                         set lsth [split [lindex $cs 2] / ] 
                         set reph [lindex $lsth end]
                          if {[regexp {\[} $reph] == 0 } {
                            set n_reph [lindex $reph 0]_reg
                            } else {
                            regsub {\[} $reph {_reg[} n_reph 
                          }
                           set h [join [lreplace $lsth end end $n_reph] /]
                          } else {
                        if {[regexp {\[} [lindex $cs 2]] == 0 } {
                         set h [lindex $cs 2]_reg 
                         } else {
                         regsub {\[} [lindex $cs 2] {_reg[} h 
                         }                    
                       }
                       set a [lreplace $cs 1 2 $g $h]
  			gen_vsc_merge $f_name $a	}
		{^ *vif_set_equiv.*\-translated.*}	{
			regsub {^.*vif_set_equiv } $line "" b
			if {[regexp {\-inverted} $b] == 0 } { 
                           set n [lindex $b 1]
                           regsub {_Z} $b {} b
                           regsub {\[} $b {_reg[} cs
                           if {[regexp {\[} [lindex $cs 1]] == 0 } {
                            set g [lindex $cs 1]_reg 
                            } else {
                            set g [lindex $cs 1]                     
                            }
                           if {[regexp {\[} [lindex $cs 2]] == 0 } {
                            set h [lindex $cs 2] 
                            } else {
                            set h [lindex $cs 2] 
                            }                    
                            set a [lreplace $cs 1 2 $g $h]
			   gen_vsc_equiv $f_name $n $a	
                          } else {
                           set n [lindex $b 2]
                           regsub {_Z} $b {} b
                           regsub {\[} $b {_reg[} cs
                           if {[regexp {\[} [lindex $cs 2]] == 0 } {
                            set g [lindex $cs 2]_reg 
                            } else {
                            set g [lindex $cs 2]                     
                            }
                           if {[regexp {\[} [lindex $cs 3]] == 0 } {
                            set h [lindex $cs 3] 
                            } else {
                            set h [lindex $cs 3] 
                            }                    
                            set a [lreplace $cs 2 3 $g $h]
			   gen_vsc_equiv $f_name $n $a	
                         }
                         }
		{^ *vif_set_map_point.*}	{
			# Convert vif_set_map_point annotations only when they are NOT block memory related
			if {$block_mem_flag == 0} {
			regsub {^.*vif_set_map_point } $line "" b
                        if [regexp inverted $b] {
                          regsub {_Z} [lindex $b 3] {} [lindex $b 3]
                          if [regexp {\[} [lindex $b 3] ] {
                          regsub {\[} $b {[} cs
                          } else { 
                          regsub  [lindex $b 3] $b [lindex $b 3] cs
                           }
                          if [regexp {\[} [lindex $cs 5] ] {
                          regsub {\[} $cs {\[} a
                          } else {
                          regsub  [lindex $b 5] $cs [lindex $b 5]_reg a
                          }
                        } else {
                          regsub {_Z} [lindex $b 2] {} [lindex $b 2]
                          if [regexp {\[} [lindex $b 2] ] {
                      if {[regexp {\/} [lindex $b 2]] == 1 } {
                         set lst [split [lindex $b 2] / ] 
                         set rep [lindex $lst end]
                          if {[regexp {\[} $rep] == 0 } {
                            set n_rep [lindex $rep 0]_reg
                            } else {
                            regsub {\[} $rep {_reg[} n_rep 
                          }
                           set [lindex $b 2] [join [lreplace $lst end end $n_rep] /]
}
                          set cs $b 
                          } else { 
                          regsub  [lindex $b 2] $b [lindex $b 2]_reg cs
                           }
                          if [regexp {\[} [lindex $cs 4] ] {
                          regsub {\[} $cs {\[} a
                          } else {
                          regsub  [lindex $b 4] $cs [lindex $b 4]_reg a
                          }
                        }
			gen_vmc $f_name $a 
						}
						}
		{^ *vif_set_fsm \-fsm.*} 	{
			regsub {^.*vif_set_fsm } $line "" a
			gen_vfc $f_name $a 	}
		{^ *vif_set_constant.*} 	{
			#if { $V2C_CONST == 1 } {
			regsub {^.*vif_set_constant } $line "" b
                        regsub -all {_Z} $b {} b
                        regsub -all {\[} $b {_reg[} cs
                        if {[regexp {\[} [lindex $cs 2]] == 0 } {
                         set g [lindex $cs 2]_reg 
                         } else {
                         set g [lindex $cs 2]                     
                         }
                       set a [lreplace $cs 1 2 [lindex $cs 1] $g ]
				gen_vsq $f_name $a
			#}
								}
		{^ *vif_set_transparent.*} 	{
			#regsub {^.*vif_set_transparent } $line "" a
			#gen_vsq $f_name $a 	}
		{^ *vif_set_black_box.*} {
			regsub {^.*vif_set_black_box } $line "" a
			gen_bbox $f_name $a }		
		{^ *vif_add_file.*} 	{
			regsub {^.*vif_add_file } $line "" a
			rec_rtl_files $a 	}
		{^ *vif_set_top_module.*} 	{
			regsub {^.*vif_set_top_module } $line "" a
			rec_top $a 	}
		{^ *vif_set_result_file.*} {
			set log_file [lindex $line 1] }
		{^ *vif_set_port_dir.*} {
			regsub {^.*vif_set_port_dir } $line "" a
			gen_port_dirs $f_name $a }		
		{^ *rtl include.*} {
			regsub {^.*rtl include } $line "" a
			gen_include_path $a
		#	set search_path [lindex $line 2]
				}
		{^ *vif_include_path.*} {
			regsub {^.*vif_include_path } $line "" a
			gen_include_path $a
		#	set search_path [lindex $line 2]
				}
		{^ *vif_set_fixed_gated_clock.*} {
			regsub {^.*vif_set_fixed_gated_clock } $line "" a
			gen_gated_clocks $f_name $a	
				}
		default { }
}

}


	if {[get_option -tech]=="VIRTEX"} {
  #puts $vtc "set fpga technology VIRTEX" 
	} elseif {[get_option -tech]=="VIRTEX2"} {
  #puts $vtc "set fpga technology VIRTEX2" 
	} elseif {[get_option -tech]=="VIRTEX2P"} {
  #puts $vtc "set fpga technology VIRTEX2" 
	} elseif {[get_option -tech]=="VIRTEX4"} {
  #puts $vtc "set fpga technology VIRTEX2" 
	} else {
  #puts $vtc "set fpga technology VIRTEX2" 
	}  	

# If project is not loaded error message will be generated and search path will
# not be added in the .vtc file
if {[catch {set foo [get_option -include_path]} msg] == 0} {
if {$foo != ""} {
set foo1 [split $foo \;]
foreach i $foo1 {
	# Determine if the include path is absolute like:
	# D:/test or /home/test (without the preceeding ../ or ./)
if {[regexp {^ *\.+} $i]} {
		# For relative include paths add relative direction ../	
			if {[get_option -project_relative_includes] == 1} {
		#	puts $vtc "add search path ../../$i -design -golden"
		} else {
		#	puts $vtc "add search path ../$i -design -golden"
		}
        } else {
		#For absolute paths do not add relative direction ../
#	puts $vtc "add search path $i -design -golden"
	}
	#end of if-else
	}
       #end of for-each	
} 
} else {
puts $msg
puts "Include path will not be added, please add it manually"

	 }

## Extract define parameters from the UI 
# This routine is used to populate a hash ui_defines_hash with
#"param value" pairs. e.g $ui_defines_hash(WIDTH) --> 4
if {[catch {set ui_defines [hdl_define -list]} msg] == 0} {
	#puts "Found define: $ui_defines"
	if {$ui_defines != ""} {
	set ui_defines_list [split $ui_defines ]
	#set ui_defines_param_val [split $ui_defines_list = ]
	#puts $ui_defines_list
		foreach i $ui_defines_list {
			if { [regexp {=} $i] } { 
					set voo [split $i =]
					#	puts [lindex $voo 0]
					#	puts [lindex $voo 1]
					set ui_defines_hash([lindex $voo 0]) [lindex $voo 1]
					} else {
						set ui_defines_hash($i) ""
					}
		}
	}
 } else {
	puts "Error: $msg"
}	
## end of define parameter extraction
#	foreach j [array names ui_defines_hash] {puts "XXX:  $j $ui_defines_hash($j)" }
##
set ui_defines_hash(synthesis) ""
set ui_defines_hash(SYNTHESIS) ""
	 
#if {[llength $bb_modules] > 0} {
##	puts $vtc "add notranslate module \\"
#foreach i $bb_modules {puts $mytcl "set_black_box ref:\/WORK\/$i \\"} 
#puts $mytcl ""
#    #	puts $vtc "\-both"
#}
	 
# Code to generate read design annotations.
# If VHDL design files exist, read in unisim libraries firstand Bbox Block-Rams (Xilinx only).
if {[llength $rtl_vhd] > 0} {
	if {$TECH=="XILINX"} {
	      
#puts $vtc {add notranslate module RAMB* -both}
# Read the unisim libraries before parsing RTL
#puts $vtc "read library \$XILINX/verilog/verplex/unisims/*.v -verilog2k -nosens" 
#puts $vtc {//read library -golden $XILINX/verilog/verplex/unisims/*.v \ }
}}

## begin Project file management
#Execute this block only if no vhdl files were found in the vif file.
#In future this block can replace the original rtl file extraction routine.

if {[llength $rtl_vhd] == 0} {
set result_dir [get_option -result_file]
set result_dir [split $result_dir "/"]
set verif_dir [lreplace $result_dir end end "verif"]
#puts "Step1"
if {[catch {set fvhdl [project -filelist -type vhdl]} msg]==0} {
		if {$TECH=="XILINX"} {
			#puts $vtc {add notranslate module RAMB* -both}
			# Read the unisim libraries before parsing RTL
			#puts $vtc "read library \$XILINX/verilog/verplex/unisims/*.v -verilog2k -nosens" 
			#puts $vtc {//read library -golden $XILINX/verilog/verplex/unisims/*.v \ }
			}

# Fix for vif2formality due to change in UI call for the 
# "project -filelist -type" command
			
	#foreach {sw lib i} $fvhdl {
# } this is just to balance the brace in the comment above. Remove while uncommenting
	foreach {i} $fvhdl {
		#puts "Sptep2"
		#if path relative (starts with ./ or ../) then do not compute relative path)
			set vhdl_fname $i
			if {[regexp {^ *\.+} $i]} { 
			lappend rtl_vhd $relative_path
			lappend rtl_vhd $lib
		} else { 
		#puts "Sptep3"
		set curr_file_path [split $i "/"] 
		set curr_file [lrange $curr_file_path end end]
		set common_match [common_match_index $curr_file_path $verif_dir]
				#for debugging
				#puts $curr_file_path
				#puts $verif_dir
				#puts $common_match
			set back_ref [expr [llength $verif_dir] - $common_match ]
			set part_file_path [lrange $curr_file_path $common_match end]
			set back_ref_path ""
				for {set i 0} {$i < $back_ref} {incr i} { lappend back_ref_path {..} }
			set relative_path [concat $back_ref_path $part_file_path]
			set relative_path [join $relative_path "/"]
			lappend rtl_vhd $relative_path

			## newly added per fix requirement stated above
			set lib [project_file -lib $vhdl_fname] 
			
			lappend rtl_vhd $lib
			}
			# end of inner else block	
	}
	# end of foreach	
} else {
	puts $msg
	puts "No VHDL files found in current project"
}
##end of else block

}
#end of if  {[llength $rtl_vhd] == 0}
## end Project file management
	 
puts $mytcl "set hdlin_interface_only \"$bb_modules\""


if {[llength $rtl_ver] > 0} {	
puts -nonewline $mytcl "read_verilog -r -vcs $my_lib $include_path$inc_var\" -09 "
puts -nonewline $mytcl "\""
foreach i $rtl_ver {puts $mytcl "$i \\"}
puts $mytcl "\" \\"
	# If the design is mixed hdl, add the -noelab switch while reading verilog design files.
if {[llength $rtl_vhd] > 0 } {
	if {[array size ui_defines_hash] > 0 } { 
                        puts -nonewline $mytcl "\-define \"";
				foreach j [array names ui_defines_hash] {
			# Fix per Bug #207369
			#puts $vtc "\-define $j \\"
                         if {($ui_defines_hash($j) != "")} {
			    puts -nonewline $mytcl " \{$j\=$ui_defines_hash($j) \}" 
                          } else {
			    puts -nonewline $mytcl " \{$j\}" 
                          }
			}			
			    puts -nonewline $mytcl " \""; 
		}
#puts $mytcl "set_top $top_golden"
set v_top "set_top $top_golden"
if {[llength $bb_modules] > 0} {
#	puts $vtc "add notranslate module \\"
#puts $mytcl "set hdlin_interface_only \"$bb_modules\""
#foreach i $bb_modules {puts $mytcl "set_black_box $i"} 
puts $mytcl ""
    #	puts $vtc "\-both"
}
} else {
	#puts "array size: [array size ui_defines_hash]"
	if {[array size ui_defines_hash] > 0 } { 
                        puts -nonewline $mytcl "\-define \{ "
				foreach j [array names ui_defines_hash] {
			# Fix per Bug #207369
			#puts $vtc "\-define $j \\"		
			#puts -nonewline $mytcl "\-define \{ $j\=$ui_defines_hash($j) \}"
                         if {($ui_defines_hash($j) != "")} {
			    puts -nonewline $mytcl " $j\=$ui_defines_hash($j) " 
                          } else {
			    puts -nonewline $mytcl " $j " 
                          }
			}			
			    puts -nonewline $mytcl " \} " 
		}
puts $mytcl ""
#puts $mytcl "set_top $top_golden"
set v_top "set_top $top_golden"
if {[llength $bb_modules] > 0} {
#	puts $vtc "add notranslate module \\"
#puts $mytcl "set hdlin_interface_only \"$bb_modules\""
#foreach i $bb_modules {puts $mytcl "set_black_box $i"} 
puts $mytcl ""
    #	puts $vtc "\-both"
}
	}
}

if {[llength $rtl_vhd] > 0} {
	# the rtl_vhd list is stored as (file_1 library file_2 library ....)
foreach {i j} $rtl_vhd { if {$j != "work" && $j != "WORK"} { puts $mytcl "read_vhdl -r -93 -work_library $j $i " 
	 } else { }}
puts -nonewline $mytcl "read_vhdl -r -93 "
#foreach {i j k l m n} $rtl_vhd {puts $vtc "$i $k $m \\"}
#foreach {i j} $rtl_vhd {puts $vtc "-mapfile $j $i \\"}
#BUG 155482
puts -nonewline $mytcl "\""
foreach {i j} $rtl_vhd { if {$j == "work" || $j == "WORK"} { puts $mytcl "$i \\" 
	 } else { }}
puts $mytcl "\""
#puts $mytcl "set_top $top_golden"
set v_top "set_top $top_golden"
if {[llength $bb_modules] > 0} {
#	puts $vtc "add notranslate module \\"
#puts $mytcl "set hdlin_interface_only \"$bb_modules\""
#foreach i $bb_modules {puts $mytcl "set_black_box $i"} 
puts $mytcl ""
    #	puts $vtc "\-both"
}
}

if {[llength $bb_modules] > 0} {
	#puts $vtc "\/\/write design ${f_name}_bb.v -bbox -replace"
}
puts $mytcl $v_top
if {[llength $netlist_ver] > 0} {	 
puts -nonewline $mytcl "read_verilog -i -vcs $my_lib\" -09 "
puts -nonewline $mytcl "\""
set netlist_name [file rootname $netlist_ver]
set name_bb [lindex [split $netlist_name $f_name] 0]${f_name}${exten}_bb.v 
if {[llength $bb_modules] > 0} {puts -nonewline $mytcl "${f_name}${exten}_bb.v "}
#set netlist_name [get_option -result_base]
#foreach i $netlist_ver {puts -nonewline $mytcl " $i "}
puts -nonewline $mytcl " ${netlist_name}$exten.vm "
#puts $vtc "-revised -root $top_revised"
puts $mytcl "\""
puts $mytcl "set_top $top_revised"
}

if {[llength $netlist_vhd] > 0} {
puts -nonewline $mytcl "read_vhdl -i -93 "
puts -nonewline $mytcl "\""
if {[llength $bb_modules] > 0} {puts -nonewline $mytcl "${f_name}${exten}_bb.v \\"}
set netlist_name [get_option -result_base]
#foreach i $netlist_ver {puts -nonewline $mytcl " $i "}
puts -nonewline $mytcl " ../${netlist_name}$exten.vhm "
#foreach i $netlist_vhd {puts -nonewline $mytcl "$i \\"}
puts $mytcl "\""
puts $mytcl "set_top $top_revised"
}

####

# Code to generate read design file annotations for order independence (temporarily disabled)  
#   puts $vtc "read design -file $f_name.vlc -verilog2k -golden -root $top_golden -noelab"

#	set rtl_length [llength $rtl]
#	set rtl_last [incr rtl_length -1]
#	set last_rtl_file [lindex $rtl $rtl_last]
#		foreach i $rtl { if {$i == $last_rtl_file} { set elaboration ""} else {set elaboration "-noelab"}
#	puts $vtc "read design $i -golden -root $top_golden $elaboration"}

#  puts $vtc "read design -file $f_name.vlc -verilog2k -revised -root $top_revised -noelab"	

#	set netlist_length [llength $netlist]
#	set netlist_last [incr netlist_length -1]
#	set last_netlist_file [lindex $netlist $netlist_last]
# 		foreach i $netlist { if {$i == $last_netlist_file} { set elaboration ""} else {set elaboration "-noelab"}
#	puts $vtc "read design $i -revised -root $top_revised $elaboration"}
 

 # puts $vtc "//Generate parsing report"
 # puts $vtc "report messages"
 # puts $vtc "report black box"
 # puts $vtc "report design data"
 # puts $vtc "report floating signals"
 # puts $vtc "//Read FSM encoding"
  
  #foreach i $fsm_list {puts $vtc "read fsm encoding $i"}

  #puts $vtc "//Read setup constraints"
 # if {$gated_clocks == 1} {puts $vtc "dofile $f_name.gcc"}
 # puts $vtc "dofile $f_name.vsc"

# Read Register Constant file .vcn
	if { $V2C_CONST == 1 } {
  #puts $vtc "dofile $f_name.vcn"
  } else {
  #puts $vtc "// dofile $f_name.vcn"
	}   

  
  #puts $vtc "//Set mapping options"
  #puts $vtc "add renaming rule rulerr \"\\\/Q_r_e_g\" \"\" \-revised"
  #puts $vtc "add renaming rule rulegh \"\_Z\\\[\%d\\\]\\\[\%d\\\]\" \"\_\@1__Z\[\@2\]\" \-golden"
  #puts $vtc "add renaming rule rulegt \"\_Z\\\[\%d\\\]\$\" \"\[\@1\]\" \-type DFF \-type DLAT \-golden"
  #puts $vtc "add renaming rule rulert \"\_Z\\\[\%d\\\]\$\" \"\[\@1\]\" \-type DFF \-type DLAT \-revised"
  #puts $vtc "add renaming rule rulego \"\_Z\$\" \"\" \-type DFF \-type DLAT \-golden"
  #puts $vtc "add renaming rule rulero \"\_Z\$\" \"\" \-type DFF \-type DLAT \-revised"
  #puts $vtc {add renaming rule rulegp "\[%d\]\[%d\]" "_@1\[@2]" -type DFF -golden}
 # puts $vtc "//set flatten model \-seq\_constant"
#  puts $vtc "// set flatten model \-mux\_loop\_to\_dlat"
#  puts $vtc "// set flatten model \-all\_seq\_merge"
#  puts $vtc "// set flatten model \-self\_seq\_merge"
#  puts $vtc "// set flatten model \-loop\_as\_dlat"
#  puts $vtc "// set flatten model \-nodff\_to\_dlat\_feedback"
  if {$gated_clocks == 1} {
#	puts $vtc "set flatten model \-gated\_clock"
	} else  { 
	#puts $vtc "// set flatten model \-gated\_clock" }
#  puts $vtc "set flatten model \-seq_constant \-seq_constant_feedback"
#  puts $vtc "set mapping method \-name first"
#  puts $vtc "\/\/set mapping method \-nobbox_name_match"
#  puts $vtc "//Run equivalence checker"
#  puts $vtc "//add module attribute \* \-compare_effort high"
#  puts $vtc "//add module attribute \* \-compare_effort super"
#  puts $vtc "set sys mode lec -nomap"
#  puts $vtc "read map point $f_name.vmc"
#  puts $vtc "map key point"
  # Comment the reading of the sequential constants to speedup runtime
  # Users can read the .vsq file if they have to, later.
 # if { $V2C_CONST == 1 } {
#  puts $vtc "dofile $f_name.vsq"
#  } else {
#  puts $vtc "// dofile $f_name.vsq"
#	} 
  #Added -repeat as per request from Cadence
  #puts $vtc "remodel -seq_constant -repeat" 
  #puts $vtc "add compare point \-all"
  #puts $vtc "compare -report_single_line_summary"
  #puts $vtc "//analyze abort -compare"
  #puts $vtc "usage"
########### end generating vtc ###########
# Close vtc file handle
foreach i [array names merge_v] {
         puts $vtc "guide_reg_duplication -design $top_golden -from \{ $i \} -to \{ $i $merge_v($i) \}"
}
foreach i [array names merge_v_inv] {
         puts $vtc "guide_reg_duplication -design $top_golden -inverted  -from \{ $i \} -to \{ $i $merge_v_inv($i) \}"
}
if {[info exists merge_v]} {
unset merge_v
} else {
}
if {[info exists merge_v_inv]} {
unset merge_v_inv
} else {
}
puts $vtc "setup"
close $vtc	
close $usermatch

puts $mytcl "current_design \$ref"
puts $mytcl "ungroup -all -flatten"
puts $mytcl "#set_parameters -retimed \$ref"
puts $mytcl "#set_compare_rule \$ref -from {\\(.*\\)_reg\\\[\\(\[0-9\]*\\)\\\]} -to {\\1_Z\\\[\\2\\\]} -type cell"
puts $mytcl "#set_compare_rule \$ref -from {\\(.*\\)_reg} -to {\\1_Z} -type cell"
puts $mytcl "set signature_analysis_match_compare_points false"
puts $mytcl "match"
puts $mytcl "set signature_analysis_match_compare_points true"
puts $mytcl "match"
set usermatch [open usermatch.txt]
while {[gets $usermatch line] >= 0} {
 puts $mytcl "$line"
}
puts $mytcl "verify"
close $mytcl	
close $usermatch

global new_svf
global new_tcl
global re_svf
global re_tcl

set new_svf [open $f_name.svf w]
set new_tcl [open $f_name.tcl w]
set re_svf [open temp.svf r]
set re_tcl [open temp.tcl r]
close $new_svf
close $new_tcl


set new_svf [open $f_name.svf a]
set new_tcl [open $f_name.tcl a]

while {[gets $re_svf line_s] >= 0} {

set new_ind2 ""
if {[regexp {i\:.*_Z_reg} $line_s] == 1} {
   set tp2 [split $line_s Z ]
    foreach k $tp2 {
     regsub {^_reg} $k { } nx
   lappend new_ind2 $nx
}
set line_s [join $new_ind2 Z] 
}

set indx [split $line_s \]]
set new_indx ""
foreach i $indx {
  if {[regexp -nocase {\[[a-z]} $i] == 1} {
   regsub {\[} $i {\\[} ne
   lappend new_indx $ne
} else {
  lappend new_indx $i
}
}
set line_s [join $new_indx \]] 
puts $new_svf $line_s
}

while {[gets $re_tcl line_t] >= 0} {
if {[regexp XILINX $line_t] == 0} {

set new_ind1 ""
if {[regexp {i\:.*_Z_reg} $line_t] == 1} {
   set tp1 [split $line_t Z ]
    foreach j $tp1 {
     regsub {^_reg} $j { } nw
   lappend new_ind1 $nw
}
set line_t [join $new_ind1 Z] 
}
 
######################
set new_ind12 ""
if {[regexp {r\:.*_reg} $line_t] == 0} {
 if {[regexp {set_user_match -type} $line_t] == 1} {
  set it1 [lindex $line_t 3]
  if {[regexp {_reg} $it1] == 0} {
   set kt [split $it1 \[]
   set first_t [lindex $kt 0]
   set kt [lreplace $kt 0 1  ${first_t}_reg\[[lindex $kt 1]]
  set kt_f [join $kt \[]
  set line_t [lreplace $line_t 3 3 $kt_f]
  }
  }
}


#####################

set indx [split $line_t \]]
set new_indx ""
foreach i $indx {
  if {[regexp -nocase {\[[a-z]} $i] == 1} {
   regsub {\[} $i {\\[} ne
   lappend new_indx $ne
} else {
  lappend new_indx $i
}
}
set line_t [join $new_indx \]] 
puts $new_tcl $line_t
} else {
puts $new_tcl $line_t
}
}

close $new_svf
close $new_tcl
close $re_svf
close $re_tcl
exec rm temp.tcl
exec rm temp.svf
exec rm usermatch.txt

#end of proc vif2formality
}
	
##### proc to generate the vlc file ####
	proc gen_vlc {loc_f_name loc_a} {
		global vlc_file_flag
		set vlc_file_flag 1

		global mytcl
		global TECH
		global my_lib
#set vlc [open $loc_f_name.vlc a]

	regsub {.*[\-translated \-original] } $loc_a "" a
		if {[regexp {\$env} $a ]} {
			set TECH ALTERA

                puts $mytcl "set QUARTUS_ROOTDIR \[ get_unix_variable \"QUARTUS_ROOTDIR\"\]"
		set my_lib {"-y $QUARTUS_ROOTDIR/eda/fv_lib/verilog +libext+.v}
		
	} elseif {[regexp {\$XILINX} $a ]} {
			set TECH XILINX
	
	 	# hack
	#regsub {verification} $a "verplex" a
		# end hack
	#	puts $vlc "-y $a"
#		puts $vlc {"-y $XILINX/verilog/verplex/unisims -y $XILINX/verilog/verplex/simprims -y $XILINX/verilog/xeclib/unisims -y $XILINX/verilog/xeclib/simprims +libext+.v"}	
                puts $mytcl "set XILINX \[get_unix_variable \"XILINX\"\]"
                puts $mytcl "set hdlin_library_directory \$XILINX\/verilog\/xeclib\/unisims"
		puts $mytcl "set hdlin_verilog_directive_prefixes \"synopsys synthesis pragma\" "
		puts $mytcl "set hdlin_vhdl_directive_prefixes \"synopsys synthesis pragma\" "
		puts $mytcl "set hdlin_sv_port_name_style vector"
		puts $mytcl "set hdlin_dyn_array_bnd_check \"None\" "
		puts $mytcl "set verification_set_undriven_signals \"x\" "
		puts $mytcl "#set verification_clock_gate_hold_mode  \"low\" "
		puts $mytcl "#set verification_clock_gate_hold_mode  \"high\" "
		puts $mytcl "#set verification_clock_gate_hold_mode  \"any\" "
		puts $mytcl "#set verification_clock_gate_hold_mode  \"collapse_all_cg_cells\" "
		set my_lib {"-y $XILINX/verilog/xeclib/unisims -y $XILINX/verilog/xeclib/simprims +libext+.v}	
		
	} else {
#		puts $vlc "## Could not determine the Technology ##"
	}
 #close $vlc
 }
 ###end of proc gen_vlc ###

#### proc to generate the vsc file -- register merge annotations ####
	proc gen_vsc_merge {loc_f_name loc_a} {
        global vtc
        global top_golden
        global top_revised
        global usermatch
        global f_name
#set vsc [open $loc_f_name.vsc a]
	regsub {.*\-original } $loc_a "" a
		set rev {-golden} 

			if {[regexp {\-fsmopt} $a]} { 
			set flat {-flatten}
			regsub {.*\-fsmopt } $a "" a
		} else {
			set flat ""
		}

			if {[regexp {\-inverted} $a]} {
			set inv { -invert}
			regsub {.*\-inverted } $a "" 
		puts $usermatch "set_user_match -inverted r:\/WORK\/$f_name\/[lindex $a 0] i:\/WORK\/$f_name\/[lindex $a 1]"
		} else {
			set inv ""
			regsub {.*\-inverted } $a "" a
		}
					
		puts $vtc "guide_reg_merging -design $top_golden -from \{ [lindex $a 0] [lindex $a 1] \} -to \{ [lindex $a 0] \}"

#close $vsc		
}     	
### end of proc gen_vsc_merge file ###

#### proc to generate the vsc file -- register replication annotations ####
	proc gen_vsc_equiv {loc_f_name loc_n loc_a} {
		global vtc
		global merge_v 
		global merge_v_inv 
        global top_golden
        global top_revised
                global usermatch
                global f_name
            set a $loc_a
            regsub {\-translated} $loc_a {} a_a
	#set vsc [open $loc_f_name.vsc a]
			if {[regexp {\-inverted} $a_a]} {
lappend merge_v_inv([lindex $a 2]) $loc_n 
lappend merge_v_inv([lindex $a 2]) [lindex $a 3]
		} else {
#lappend merge_v([lindex $a 1]) [lindex $a 1] 
lappend merge_v([lindex $a 1]) [lindex $a 2]
		}
	regsub {.*\-translated } $loc_a "" a
		set rev {-revised} 
			if {[regexp {\-fsmopt} $a]} { 
			set flat {-flatten}
			regsub {.*[\-fsmopt] } $a "" a
		} else {
			set flat ""
		}
#lappend  merge_var([lindex $a 0]) $loc_n 
#lappend  merge_var([lindex $a 0]) [lindex $a 1]
#close $vsc		
}     	
### end of proc gen_vsc_equiv file ###

#### proc to generate the vmc file ####
proc gen_vmc {loc_f_name loc_a} {
	global TECH
	global vtc
	global usermatch
        global type
        global top_golden
        global top_revised
	global f_name
        set extra 0
	set iomaps 0
	set isblackbox 0
#	set vmc [open $loc_f_name.vmc a]
	
	if {[regexp {\-pi} $loc_a]} {
		set pin_dir {-input_pin}
		set iomaps 1
	} elseif {[regexp {\-po} $loc_a]} {
	       	set pin_dir {-output_pin}
	       	set iomaps 1   
	} elseif {[regexp {\-latch} $loc_a]} {
		set lat_or_dff {DLAT}
	} elseif {[regexp {\-blackbox} $loc_a]} { 
		set isblackbox 1 
	} elseif {[regexp {\-register} $loc_a]} {
                set extra 1
	       	set type {cell}   
	} else 	{
		set lat_or_dff {DFF} 
	}
	
######################	
	if {[regexp {\-inverted} $loc_a]} {
		set inv { -inverted}
	} else {
		set inv ""
	}

if {$iomaps == 1} {
puts $usermatch "set_user_match r:\/WORK\/$f_name\/[lindex $loc_a 1] i:\/WORK\/$f_name\/[lindex $loc_a 2] -noninverted"
#close $vmc


} elseif {$isblackbox == 1} {
	#Fix for bug #157340. Disable conversion of vif_set_map_point for black_boxes
	#puts $vmc "add mapped points [lindex $loc_a 2] [lindex $loc_a 4]"
	#close $vmc

} else {
	regsub {.*\-original } $loc_a "" a
	regsub {\-translated } $a "" a
if {$extra == 1} {
    if {$TECH=="ALTERA"} {
	puts $usermatch "set_user_match -type $type r:\/WORK\/$top_golden\/[lindex $a 0] i:\/WORK\/$top_revised\/[lindex $a 1]/lc_ff$inv"
} else {
	puts $usermatch "set_user_match -type $type $inv r:\/WORK\/$top_golden\/[lindex $a 0] i:\/WORK\/$top_revised\/[lindex $a 1]"
	}
} else {
if {$TECH=="ALTERA"} {
	puts $usermatch "set_user_match r:\/WORK\/$top_golden\/[lindex $a 0] i:\/WORK\/$top_revised\/[lindex $a 1]/lc_ff$inv"
} else {
	puts $usermatch "set_user_match r:\/WORK\/$top_golden\/[lindex $a 0] i:\/WORK\/$top_revised\/[lindex $a 1]"
	}
 }
#close $vmc
}

} 
# end of iomaps if - blackbox -else
### end of proc gen_vmc file ###

#### Procedure to write sequential constant annotations (.vsq file) #####
proc gen_vsq {loc_f_name loc_a} {
global top_golden
global usermatch
global vtc
#	set vsq [open $loc_f_name.vsq a]
#	set vcn [open $loc_f_name.vcn a]
	if {[regexp {\-original} $loc_a]} {
		set rev {-golden}
	} elseif  {[regexp {\-translated} $loc_a]} {
		set rev {-revised}
	} else {
		set rev {-both}
	}
#puts "LOC_A: $loc_a"
	set const_val [lindex $loc_a 1]
#puts "Const_VAL: $const_val"
	if { $const_val == 0 } {
		puts  $vtc "guide_reg_constant -design $top_golden {[lindex $loc_a 2]} 0"
		} elseif {$const_val == 1} {
		puts  $vtc "guide_reg_constant -design $top_golden {[lindex $loc_a 2]} 1"
		} elseif {$const_val == -1} {
		puts $vtc "guide_reg_constant -design $top_golden {[lindex $loc_a 2]} 0"
		} else {
		}
#close $vcn
#close $vsq	
}
## end of proc gen_vsq ###

#### Proc to generate finite state achine vfc file #### 
proc gen_vfc {loc_f_name loc_a} {
	global in_file
	global vtc
        global j
        global top_golden
	global fsm_list
	regsub {.*\-fsm } $loc_a "" fsm_name
	lappend fsm_list ${loc_f_name}_${fsm_name}.vfc
	#set vfc [open $loc_f_name.vfc a]
	#set vfc [open $loc_f_name.xx a]
# Deal with the "from state" registers
	gets $in_file loc_line
	regsub "vif_set_fsmreg.*$fsm_name " $loc_line "" f_regs
	regexp {(^.*)\[} $f_regs mv f_statename
        regsub $ $f_statename _reg new
	# Bit blast "from registers" for printing in vfc
        regexp {\[([-+]?[0-9]+):([-+]?[0-9]+)\]} $f_regs mv lb rb
	if {$lb > $rb} {
		set regcnt $lb
        puts $vtc "guide_fsm_reencoding -design \{ $top_golden \} \\"
        puts -nonewline $vtc "-previous_state_vector \{"
	#puts -nonewline $vtc ".fromstates "
	#for {set i $lb} {$i >= 0} {incr i -1} 
	for {set i $lb} {$i >= $rb} {incr i -1} {
		puts -nonewline $vtc "$new\[$i\] "
	}
		} else {
         puts $vtc "guide_fsm_reencoding -design \{ $top_golden \} \\"
			puts -nonewline $vtc "-previous_state_vector \{"
	for {set i $lb} {$i <= $rb} {incr i 1} {
		puts -nonewline $vtc "$new\[$i\] "
	}
}
	puts $vtc "\} \\"

# Deal with the "to state" registers
	gets $in_file loc_line
	regsub "vif_set_fsmreg.*$fsm_name " $loc_line "" t_regs
	regexp {(^.*)\[} $t_regs mv t_statename
        regsub $ $t_statename _reg newt
# temp work around to handle already bit blasted registers	
#	puts $vtc ".tostates $t_regs"
	
#	 Bit blast "to registers" for printing in vfc
	regexp {\[([0-9]+):([0-9]+)\]} $t_regs mv lb rb

	if {$lb > $rb} {
		set regcnt $lb
	puts -nonewline $vtc "-current_state_vector \{ "
	for {set i $lb} {$i >= 0} {incr i -1} {
		puts -nonewline $vtc "$newt\[$i\] "
	}
		} else {
		puts -nonewline $vtc "-current_state_vector \{ "
	for {set i $lb} {$i <= $rb} {incr i 1} {
		puts -nonewline $vtc "$newt\[$i\] "
	}
}
	puts $vtc "\} \\"

# Print state maps	
	puts $vtc "-state_reencoding \{ \\"
        set j 0
	while {1} {
	# Record the current access position
	set curr_pos [tell $in_file]
	gets $in_file loc_line
	# if end of state maps or end of file end the while loop
	if {(![regexp {vif_set_state_map.*} $loc_line]) || ([eof $in_file]) } {
	puts $vtc "\}"
	break	
	} else {
		#print state maps in the vfc file
		puts $vtc "\{ S$j 2#[lindex $loc_line 4] 2#[lindex $loc_line 6] \} \\"
                set j [incr j]
		}
	}
	# Adjust the access pointer so that the main procedure can start where
	# gen_vfc left off.
	seek $in_file $curr_pos
	
#close $vfc
}
#### end of vfc proc ###

#### Procedure to record rtl file names ######
proc rec_rtl_files {loc_a} {
#set netlist_vhd ""
#set netlist_ver ""
#set rtl_vhd ""
#set rtl_ver ""
global rtl_ver
global rtl_vhd
global netlist_ver
global netlist_vhd
global rtl
global netlist

if {[regexp {\-vhdl} $loc_a]} {
	if {[regexp {\-original} $loc_a]} {
			if {[regexp {\-lib} $loc_a]} {
		# Append the .vhd file name
                if {[regexp {^\.} [lindex $loc_a 4]] == 1} {
		   lappend rtl_vhd "[lindex $loc_a 4]"
                } else {
		   lappend rtl_vhd "[lindex $loc_a 4]"
                }
		# Append the library name, specified by -lib option
		lappend rtl_vhd "[lindex $loc_a 3]"
			} else {		
                if {[regexp {^\.} [lindex $loc_a 2]] == 1} {
		   lappend rtl_vhd "[lindex $loc_a 2] -vhdl"
                } else {
		   lappend rtl_vhd "[lindex $loc_a 2] -vhdl"
                }
                 }
		} elseif {[regexp {\-translated} $loc_a]} {
                 if {[regexp {^\.} [lindex $loc_a 2]] == 1} {
			lappend netlist_vhd "[lindex $loc_a 2] -vhdl 93"
                  } else {
			lappend netlist_vhd "[lindex $loc_a 2] -vhdl 93"
                  }
		} 
	}

if {[regexp {\-verilog} $loc_a]} {
	if {[regexp {\-original} $loc_a]} {
                if {[regexp {^\.} [lindex $loc_a 2]] == 1} {
	        	lappend rtl_ver "[lindex $loc_a 2]"
                } else {
	        	lappend rtl_ver "[lindex $loc_a 2]"
                }
		} elseif {[regexp {\-translated} $loc_a]} {
                 if {[regexp {^\.} [lindex $loc_a 2]] == 1} {
			lappend netlist_ver "[lindex $loc_a 2]"
                  } else {
			lappend netlist_ver "[lindex $loc_a 2]"
                  }
		} 
	}

set rtl [concat $rtl_ver $rtl_vhd]
set netlist [concat $netlist_ver $netlist_vhd]

# end of procedure rec_rtl_files
}

#### Procedure to set top module #####
proc rec_top {loc_a} {
global top_golden
global top_revised
	if {[regexp {\-original} $loc_a]} {
		set top_golden [lindex $loc_a 2]
		} elseif {[regexp {\-translated} $loc_a]} {
			set top_revised [lindex $loc_a 2]
		} else {
			set top_golden ""
			set top_revised ""
		}
		
# end of rec_top procedure
 }

#### Procedure to write port directions #####
proc gen_port_dirs {loc_f_name loc_a} {
	global vtc
	#set vsc [open $loc_f_name.vsc a]
		if {[regexp {\-original} $loc_a]} {
		set rev {-golden}
		
		#regsub {\-original } $loc_a "" a
		regsub {^.*\-translated } $loc_a "" a
		#The above is a hack for change in annotation starting in syn9.0
		#e.g original annotation
		#vif_set_port_dir -original IN reg_fdre d*
		#syn9.0 annotation
		#vif_set_port_dir -original INOUT -translated reg_fdre d*
		
	} elseif {[regexp {\-translated} $loc_a]} {
		set rev {-revised}
		regsub {\-translated } $loc_a "" a
	}
	#puts $vtc "assign pin direction $a $rev"

#close $vsc	
} 
### end of procedure gen_port_dirs ###

#### Procedure to generate Black Box Annotations ####
proc gen_bbox {loc_f_name loc_a} {
	global bb_modules
	global vtc
	#set vsc [open $loc_f_name.vsc a]
	#if {[regexp {\-original} $loc_a]} {
	#	set rev {-golden}
	#	regsub {\-original } $loc_a "" a
	#} elseif {[regexp {\-translated} $loc_a]} {
	#	set rev {-revised}
	#	regsub {\-translated } $loc_a "" a
	#}

	# the following two lines set "a" to the last object in the string
	#vif_set_black_box -translated my_ram (will work)
	#vif_set_black_box my_ram (will work)
	set last_index [llength $loc_a]
	set a [lindex $loc_a [incr last_index -1]]	
	lappend bb_modules $a
	#puts $vsc "add black box $a -module $rev"
	#puts $bb_modules
#close $vsc
}
### end of procedure gen_bbox ####

#### Procedure to handle include path ####
proc gen_include_path {loc_a} {
global inc_var
set inc2 +$loc_a
set inc_var $inc_var$inc2
}
### End of procedure gen_include_path ###

#### Procedure to get a common match point given two lists ####
proc common_match_index {loc_list1 loc_list2} {
#set match_flag 0
set match_index 0
	foreach i $loc_list1 {
		#puts "Element: $i"
		if {[string match $i [lindex $loc_list2 $match_index]]} {
#			set match_flag 1 
			incr match_index
		} else {
			break
		}
	}
	# end of foreach block
	incr match_index -1
return $match_index
}
### end of procedure common_match_point ####

#### Procedure gen_gated_clocks ####
proc gen_gated_clocks {loc_f_name loc_a} {
global gated_clocks
global vtc
set gated_clocks 1
#set gcc [open $loc_f_name.gcc a]
	set clk [lindex $loc_a 1]
	set clk [split $clk :]
	set clk_1 [lindex $clk 1]
	if {[regexp {\-clock} $loc_a]} {
		puts $vtc "add clock 0 $clk_1 -golden"
	} elseif {[regexp {\-net} $loc_a]} { 
		puts $vtc "add primary input -net $clk_1 -cut -both"
		puts $vtc "add clock 0 $clk_1 -golden"
		#puts $gcc "add clock 0 $clk_1 -module XYZ"
	} else {
	}
#close $gcc
}
### end of procedure gen_gated_clocks


####################################################################################################

#This tcl procedure is  shortcut method to invoke vif2formality
proc v2f {{mode "map"} {opts "-noconst"}} {
	set filename [glob *.vif]
		if { [llength $filename] == 1 } {
				vif2formality [glob *.vif] $mode $opts
			} elseif {[llength $filename] == 0} {
				puts "Error: No VIF file found"
				puts "Cannot execute vif2formality, please provide a VIF file"
			} else {
				puts "Error: Found too many VIF files: $filename"
				puts "Cannot execute vif2formality, please specify file name"
				puts "vif2formality <filename.vif> [<-const>]"
			}
}
#end of procedure
