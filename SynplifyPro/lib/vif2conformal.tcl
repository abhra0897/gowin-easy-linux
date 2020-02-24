# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
# $Header: //synplicity/mapgw/misc/vif2conformal.tcl#2 $
# $Name: s901 $
proc vif2conformal {f {opts "-noconst"}} {

# Flag for converting constant information. Turned OFF by default
global V2C_CONST
if { $opts=="-const" } {
set V2C_CONST 1
} else {
set V2C_CONST 0
}
	
# Declare global variables
global TECH
global in_file
global rtl
global netlist
global rtl_ver
global netlist_ver
global rtl_vhd
global netlist_vhd
global top_golden
global top_revised
global fsm_list
global include_path
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
		
# initialize all variables
set rtl ""
set netlist ""
set rtl_ver ""
set netlist_ver ""
set rtl_vhd ""
set netlist_vhd ""
set top_golden ""
set top_revised ""
set fsm_list ""
set TECH ""
set in_file [open $f]
set f_name [file tail [file rootname $f]]
set include_path ""
set bb_modules ""
set block_mem_flag 0
set gated_clocks 0
set vlc_file_flag 0

# Open vlc file Handle
set vlc [open $f_name.vlc w]
# Open vsc file Handle
set vsc [open $f_name.vsc w]
# Open vmc file Handle
set vmc [open $f_name.vmc w]
 puts $vmc "//Map Points\n"
# Open vsq file Handle
set vsq [open $f_name.vsq w]
# Open vcn file Handle
set vcn [open $f_name.vcn w]
	puts $vcn "//Register Constant information\n"
# Open vtc file Handle
set vtc [open $f_name.vtc w]
# Open gcc file Handle
set gcc [open $f_name.gcc w]
	puts $gcc "//Gated Clock Conversion annotations\n"




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
			regsub {^.*vif_set_merge } $line "" a
			gen_vsc_merge $f_name $a	}
		{^ *vif_set_equiv.*\-translated.*}	{
			regsub {^.*vif_set_equiv } $line "" a
			gen_vsc_equiv $f_name $a	}
		{^ *vif_set_map_point.*}	{
			# Convert vif_set_map_point annotations only when they are NOT block memory related
			if {$block_mem_flag == 0} {
			regsub {^.*vif_set_map_point } $line "" a
			gen_vmc $f_name $a 
						}
						}
		{^ *vif_set_fsm \-fsm.*} 	{
			regsub {^.*vif_set_fsm } $line "" a
			gen_vfc $f_name $a 	}
		{^ *vif_set_constant.*} 	{
			#if { $V2C_CONST == 1 } {
				regsub {^.*vif_set_constant } $line "" a
				gen_vsq $f_name $a
			#}
								}
		{^ *vif_set_transparent.*} 	{
			#regsub {^.*vif_set_transparent } $line "" a
			#gen_vsq $f_name $a 	}
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
		{^ *vif_set_black_box.*} {
			regsub {^.*vif_set_black_box } $line "" a
			gen_bbox $f_name $a }		
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
#end of switch statement

}
#end of main while loop	


##### Generate the .vtc file last ######
  puts $vtc "//"
  puts $vtc "// Conformal autogenerated dofile"
  #puts $vtc "// Conformal side file"
  #puts $vtc "// Generated using Synplify\-pro"
  #puts $vtc "//"
  #puts $vtc "// All rights reserved"
  puts $vtc "//"
  puts $vtc "// Set parsing options"
  puts $vtc "set log file $log_file -replace"
  puts $vtc "set naming rule \"\%s\" \-register \-golden" 
  puts $vtc "set naming rule \"\%s\" \-register \-revised" 
  puts $vtc "set naming rule \"\%L\.\%s\" \"\%s\" \"\%s\" \-variable \-golden" 
  puts $vtc "// set naming rule \"\%L\.\%s\" \"\%s\" \"\%s\" \-instance \-golden" 
  puts $vtc "set case sensitivity off"
  puts $vtc "// set undriven signal 0 -golden"
  puts $vtc "// set undefined cell black_box -noascend"
  puts $vtc "// Read golden and revised designs"
 
#### START FIX FOR BUG ID #198316 ####
	#if {$TECH=="XILINX"} {
  #puts $vtc "set fpga technology VIRTEX2" 
#	}
#### OR ####
	if {[get_option -tech]=="VIRTEX"} {
  puts $vtc "set fpga technology VIRTEX" 
	} elseif {[get_option -tech]=="VIRTEX2"} {
  puts $vtc "set fpga technology VIRTEX2" 
	} elseif {[get_option -tech]=="VIRTEX2P"} {
  puts $vtc "set fpga technology VIRTEX2" 
	} elseif {[get_option -tech]=="VIRTEX4"} {
  puts $vtc "set fpga technology VIRTEX2" 
	} 

#### END FIX FOR BUG ID #198316 ####
  
# if {$include_path != ""} {
#	foreach i $include_path {
#puts $vtc "add search path ../$i -design -golden" }
#	 }

# Get include path information from the Synplify internal tcl command "Get_option"
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
			puts $vtc "add search path ../../$i -design -golden"
		} else {
			puts $vtc "add search path ../$i -design -golden"
		}
        } else {
		#For absolute paths do not add relative direction ../
	puts $vtc "add search path $i -design -golden"
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
	 
if {[llength $bb_modules] > 0} {
	puts $vtc "add notranslate module \\"
foreach i $bb_modules {puts $vtc "$i \\"} 
	puts $vtc "\-both"
}
	 
# Code to generate read design annotations.
# If VHDL design files exist, read in unisim libraries firstand Bbox Block-Rams (Xilinx only).
if {[llength $rtl_vhd] > 0} {
	if {$TECH=="XILINX"} {
	      
puts $vtc {add notranslate module RAMB* -both}
# Read the unisim libraries before parsing RTL
puts $vtc "read library \$XILINX/verilog/verplex/unisims/*.v -verilog2k -nosens" 
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
			puts $vtc {add notranslate module RAMB* -both}
			# Read the unisim libraries before parsing RTL
			puts $vtc "read library \$XILINX/verilog/verplex/unisims/*.v -verilog2k -nosens" 
			#puts $vtc {//read library -golden $XILINX/verilog/verplex/unisims/*.v \ }
			}

# Fix for vif2conformal due to change in UI call for the 
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
	 


if {[llength $rtl_ver] > 0} {	
puts $vtc "read design -file $f_name.vlc -verilog2k \\"
foreach i $rtl_ver {puts $vtc "$i \\"}
	# If the design is mixed hdl, add the -noelab switch while reading verilog design files.
if {[llength $rtl_vhd] > 0 } {
	if {[array size ui_defines_hash] > 0 } { 
				foreach j [array names ui_defines_hash] {
			# Fix per Bug #207369
			#puts $vtc "\-define $j \\"
			puts $vtc "\-define $j\=$ui_defines_hash($j) \\"
			}			
		}
	puts $vtc "-noelab -golden -root $top_golden"
} else {
	#puts "array size: [array size ui_defines_hash]"
	if {[array size ui_defines_hash] > 0 } { 
				foreach j [array names ui_defines_hash] {
			# Fix per Bug #207369
			#puts $vtc "\-define $j \\"		
			puts $vtc "\-define $j\=$ui_defines_hash($j) \\"
			}			
		}
puts $vtc "-golden -root $top_golden"
	}
}

if {[llength $rtl_vhd] > 0} {
	# the rtl_vhd list is stored as (file_1 library file_2 library ....)
puts $vtc "read design  \\"
#foreach {i j k l m n} $rtl_vhd {puts $vtc "$i $k $m \\"}
#foreach {i j} $rtl_vhd {puts $vtc "-mapfile $j $i \\"}
#BUG 155482
foreach {i j} $rtl_vhd { if {$j == "work" || $j == "WORK"} { puts $vtc "$i \\" 
	 } else { puts $vtc "-mapfile $j $i \\"}}
	
#foreach {i j} $rtl_vhd {if {$j != "work" && $j != "WORK"} { puts $vtc "-mapfile $j $i \\"}}


puts $vtc "-golden -vhdl -root $top_golden"
}

if {[llength $bb_modules] > 0} {
	#puts $vtc "\/\/write design ${f_name}_bb.v -bbox -replace"
}

if {[llength $netlist_ver] > 0} {	 
puts $vtc "read design -file $f_name.vlc -verilog2k \\"
if {[llength $bb_modules] > 0} {puts $vtc "${f_name}_bb.v \\"}
foreach i $netlist_ver {puts $vtc "$i \\"}
puts $vtc "-revised -root $top_revised"
}

if {[llength $netlist_vhd] > 0} {
puts $vtc "read design -vhdl \\"
if {[llength $bb_modules] > 0} {puts $vtc "${f_name}_bb.v \\"}
foreach i $netlist_vhd {puts $vtc "$i \\"}
puts $vtc "-revised -root $top_revised"
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
 

  puts $vtc "//Generate parsing report"
  puts $vtc "report messages"
  puts $vtc "report black box"
  puts $vtc "report design data"
  puts $vtc "report floating signals"
  puts $vtc "//Read FSM encoding"
  
  foreach i $fsm_list {puts $vtc "read fsm encoding $i"}

  puts $vtc "//Read setup constraints"
  if {$gated_clocks == 1} {puts $vtc "dofile $f_name.gcc"}
  puts $vtc "dofile $f_name.vsc"

# Read Register Constant file .vcn
	if { $V2C_CONST == 1 } {
  puts $vtc "dofile $f_name.vcn"
  } else {
  puts $vtc "// dofile $f_name.vcn"
	}   

  
  puts $vtc "//Set mapping options"
  puts $vtc "add renaming rule rulerr \"\\\/Q_r_e_g\" \"\" \-revised"
  #puts $vtc "add renaming rule rulegh \"\_Z\\\[\%d\\\]\\\[\%d\\\]\" \"\_\@1__Z\[\@2\]\" \-golden"
  #puts $vtc "add renaming rule rulegt \"\_Z\\\[\%d\\\]\$\" \"\[\@1\]\" \-type DFF \-type DLAT \-golden"
  puts $vtc "add renaming rule rulert \"\_Z\\\[\%d\\\]\$\" \"\[\@1\]\" \-type DFF \-type DLAT \-revised"
  puts $vtc "add renaming rule rulego \"\_Z\$\" \"\" \-type DFF \-type DLAT \-golden"
  puts $vtc "add renaming rule rulero \"\_Z\$\" \"\" \-type DFF \-type DLAT \-revised"
  puts $vtc {add renaming rule rulegp "\[%d\]\[%d\]" "_@1\[@2]" -type DFF -golden}
  puts $vtc "//set flatten model \-seq\_constant"
  puts $vtc "// set flatten model \-mux\_loop\_to\_dlat"
  puts $vtc "// set flatten model \-all\_seq\_merge"
  puts $vtc "// set flatten model \-self\_seq\_merge"
  puts $vtc "// set flatten model \-loop\_as\_dlat"
  puts $vtc "// set flatten model \-nodff\_to\_dlat\_feedback"
  if {$gated_clocks == 1} {
	puts $vtc "set flatten model \-gated\_clock"
	} else { puts $vtc "// set flatten model \-gated\_clock" }
  puts $vtc "set flatten model \-seq_constant \-seq_constant_feedback"
  puts $vtc "set mapping method \-name first"
  puts $vtc "\/\/set mapping method \-nobbox_name_match"
  puts $vtc "//Run equivalence checker"
  puts $vtc "//add module attribute \* \-compare_effort high"
  puts $vtc "//add module attribute \* \-compare_effort super"
  puts $vtc "set sys mode lec -nomap"
  puts $vtc "read map point $f_name.vmc"
  puts $vtc "map key point"
  # Comment the reading of the sequential constants to speedup runtime
  # Users can read the .vsq file if they have to, later.
  if { $V2C_CONST == 1 } {
  puts $vtc "dofile $f_name.vsq"
  } else {
  puts $vtc "// dofile $f_name.vsq"
	} 
  #Added -repeat as per request from Cadence
  puts $vtc "remodel -seq_constant -repeat" 
  puts $vtc "add compare point \-all"
  puts $vtc "compare -report_single_line_summary"
  puts $vtc "//analyze abort -compare"

#### new stuff ###
  #puts $vtc "report unmap point \-summary"
  #puts $vtc "tclmode"
  #puts $vtc "if \{\[get_exit_code\] \=\= 0\} \{vpx set screen display on; puts \"\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\\nVerification passed\\n\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\"\} else \{vpx set screen display on; puts \"\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\\nVerification FAILED\\n\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\"\}"
  #puts $vtc "vpxmode"
### end new stuff ###  

  puts $vtc "usage"
########### end generating vtc ###########
# Close vtc file handle
close $vtc


	
} 
#end of proc vif2conformal

	
##### proc to generate the vlc file ####
	proc gen_vlc {loc_f_name loc_a} {
		global vlc_file_flag
		set vlc_file_flag 1

		global TECH
set vlc [open $loc_f_name.vlc a]

	regsub {.*[\-translated \-original] } $loc_a "" a
		if {[regexp {\$env} $a ]} {
			set TECH ALTERA

################### Temp USE_TRI fix ##################

# Open var file for Verilog Variables 
set var [open ${loc_f_name}_var.v w]

puts $var {`define USE_TRI}

# Close var file handle
close $var

puts $vlc "${loc_f_name}_var.v"
##########################################################
			
		puts $vlc {-y $QUARTUS_ROOTDIR/eda/fv_lib/verilog}
		
	} elseif {[regexp {\$XILINX} $a ]} {
			set TECH XILINX
	
	 	# hack
	#regsub {verification} $a "verplex" a
		# end hack
	#	puts $vlc "-y $a"
		puts $vlc {-y $XILINX/verilog/verplex/unisims}	
		puts $vlc {-y $XILINX/verilog/verplex/simprims}	
		puts $vlc {-y $XILINX/verilog/xeclib/unisims}	
		puts $vlc {-y $XILINX/verilog/xeclib/simprims}	
		
	} else {
		puts $vlc "## Could not determine the Technology ##"
	}
 close $vlc
 }
 ###end of proc gen_vlc ###

#### proc to generate the vsc file -- register merge annotations ####
	proc gen_vsc_merge {loc_f_name loc_a} {
set vsc [open $loc_f_name.vsc a]
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
			regsub {.*\-inverted } $a "" a
		} else {
			set inv ""
			regsub {.*\-inverted } $a "" a
		}
					
		puts $vsc "add instance equivalences [lindex $a 0]${inv} [lindex $a 1] $rev $flat"

close $vsc		
}     	
### end of proc gen_vsc_merge file ###

#### proc to generate the vsc file -- register replication annotations ####
	proc gen_vsc_equiv {loc_f_name loc_a} {
	set vsc [open $loc_f_name.vsc a]
			if {[regexp {\-inverted} $loc_a]} {
			set inv { -invert}
		} else {
			set inv ""
		}
	regsub {.*\-translated } $loc_a "" a
		set rev {-revised} 
			if {[regexp {\-fsmopt} $a]} { 
			set flat {-flatten}
			regsub {.*[\-fsmopt] } $a "" a
		} else {
			set flat ""
		}
			
		puts $vsc "add instance equivalences [lindex $a 0]$inv [lindex $a 1] $rev $flat"

close $vsc		
}     	
### end of proc gen_vsc_equiv file ###

#### proc to generate the vmc file ####
proc gen_vmc {loc_f_name loc_a} {
	global TECH
	set iomaps 0
	set isblackbox 0
	set vmc [open $loc_f_name.vmc a]
	
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
	} else 	{
		set lat_or_dff {DFF} 
	}
	
######################	
	if {[regexp {\-inverted} $loc_a]} {
		set inv { -invert}
	} else {
		set inv ""
	}

if {$iomaps == 1} {
puts $vmc "add mapped points [lindex $loc_a 1] [lindex $loc_a 2] -noinvert"
close $vmc


} elseif {$isblackbox == 1} {
	#Fix for bug #157340. Disable conversion of vif_set_map_point for black_boxes
	#puts $vmc "add mapped points [lindex $loc_a 2] [lindex $loc_a 4]"
	close $vmc

} else {
	
	regsub {.*\-original } $loc_a "" a
	regsub {\-translated } $a "" a
if {$TECH=="ALTERA"} {
	#puts $vmc "add mapped points [lindex $a 0] [lindex $a 1]/lc_ff$inv -type $lat_or_dff $lat_or_dff"
	puts $vmc "add mapped points [lindex $a 0] [lindex $a 1]$inv -type $lat_or_dff $lat_or_dff"
} else {
	puts $vmc "add mapped points [lindex $a 0] [lindex $a 1]$inv -type $lat_or_dff $lat_or_dff"
	}
close $vmc
}

} 
# end of iomaps if - blackbox -else
### end of proc gen_vmc file ###

#### Procedure to write sequential constant annotations (.vsq file) #####
proc gen_vsq {loc_f_name loc_a} {
	set vsq [open $loc_f_name.vsq a]
	set vcn [open $loc_f_name.vcn a]
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
		puts $vcn "add instance constraint 0 [lindex $loc_a 2] $rev"
		} elseif { $const_val == 1 } {
		puts $vcn "add instance constraint 1 [lindex $loc_a 2] $rev"
		} else {
	 #puts $vsc "\/\/add instance constraint 0 [lindex $loc_a 2] $rev"
	puts $vsq "remodel -seq_constant [lindex $loc_a 2] $rev"
		}
close $vcn
close $vsq	
}
## end of proc gen_vsq ###

#### Proc to generate finite state achine vfc file #### 
proc gen_vfc {loc_f_name loc_a} {
	global in_file
	global fsm_list
	regsub {.*\-fsm } $loc_a "" fsm_name
	lappend fsm_list ${loc_f_name}_${fsm_name}.vfc
	set vfc [open ${loc_f_name}_${fsm_name}.vfc w]
# Deal with the "from state" registers
	gets $in_file loc_line
	regsub "vif_set_fsmreg.*$fsm_name " $loc_line "" f_regs
	regexp {(^.*)\[} $f_regs mv f_statename

	# Bit blast "from registers" for printing in vfc
	regexp {\[([0-9]+):([0-9]+)\]} $f_regs mv lb rb

	if {$lb > $rb} {
		set regcnt $lb
	puts -nonewline $vfc ".fromstates "
	#for {set i $lb} {$i >= 0} {incr i -1} 
	for {set i $lb} {$i >= $rb} {incr i -1} {
		puts -nonewline $vfc "$f_statename\[$i\] "
	}
		} else {
			puts -nonewline $vfc ".fromstates "
	for {set i $lb} {$i <= $rb} {incr i 1} {
		puts -nonewline $vfc "$f_statename\[$i\] "
	}
}
	puts $vfc ""

# Deal with the "to state" registers
	gets $in_file loc_line
	regsub "vif_set_fsmreg.*$fsm_name " $loc_line "" t_regs
	regexp {(^.*)\[} $t_regs mv t_statename

# temp work around to handle already bit blasted registers	
#	puts $vfc ".tostates $t_regs"
	
#	 Bit blast "to registers" for printing in vfc
	regexp {\[([0-9]+):([0-9]+)\]} $t_regs mv lb rb

	if {$lb > $rb} {
		set regcnt $lb
	puts -nonewline $vfc ".tostates "
	for {set i $lb} {$i >= 0} {incr i -1} {
		puts -nonewline $vfc "$t_statename\[$i\] "
	}
		} else {
			puts -nonewline $vfc ".tostates "
	for {set i $lb} {$i <= $rb} {incr i 1} {
		puts -nonewline $vfc "$t_statename\[$i\] "
	}
}
	puts $vfc ""

# Print state maps	
	puts $vfc ".begin"
	while {1} {
	# Record the current access position
	set curr_pos [tell $in_file]
	gets $in_file loc_line
	# if end of state maps or end of file end the while loop
	if {(![regexp {vif_set_state_map.*} $loc_line]) || ([eof $in_file]) } {
	puts $vfc ".end"
	break	
	} else {
		#print state maps in the vfc file
		puts $vfc "[lindex $loc_line 4] [lindex $loc_line 6]"
		}
	}
	# Adjust the access pointer so that the main procedure can start where
	# gen_vfc left off.
	seek $in_file $curr_pos
	
close $vfc
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
		lappend rtl_vhd "../[lindex $loc_a 4]"
		# Append the library name, specified by -lib option
		lappend rtl_vhd "[lindex $loc_a 3]"
			} else {		
		lappend rtl_vhd "../[lindex $loc_a 2] -vhdl" }
		} elseif {[regexp {\-translated} $loc_a]} {
			lappend netlist_vhd "../[lindex $loc_a 2] -vhdl 93"
		} 
	}

if {[regexp {\-verilog} $loc_a]} {
	if {[regexp {\-original} $loc_a]} {
		lappend rtl_ver "../[lindex $loc_a 2] -verilog2k"
		} elseif {[regexp {\-translated} $loc_a]} {
			lappend netlist_ver "../[lindex $loc_a 2] -verilog2k"
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
	set vsc [open $loc_f_name.vsc a]
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
	puts $vsc "assign pin direction $a $rev"

close $vsc	
} 
### end of procedure gen_port_dirs ###

#### Procedure to generate Black Box Annotations ####
proc gen_bbox {loc_f_name loc_a} {
	global bb_modules
	set vsc [open $loc_f_name.vsc a]
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
close $vsc
}
### end of procedure gen_bbox ####

#### Procedure to handle include path ####
proc gen_include_path {loc_a} {
	global include_path
lappend include_path $loc_a
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
set gated_clocks 1
set gcc [open $loc_f_name.gcc a]
	set clk [lindex $loc_a 1]
	set clk [split $clk :]
	set clk_1 [lindex $clk 1]
	if {[regexp {\-clock} $loc_a]} {
		puts $gcc "add clock 0 $clk_1 -golden"
	} elseif {[regexp {\-net} $loc_a]} { 
		puts $gcc "add primary input -net $clk_1 -cut -both"
		puts $gcc "add clock 0 $clk_1 -golden"
		#puts $gcc "add clock 0 $clk_1 -module XYZ"
	} else {
	}
close $gcc
}
### end of procedure gen_gated_clocks


####################################################################################################

#This tcl procedure is  shortcut method to invoke vif2conformal
proc v2c {{opts "-noconst"}} {
	set filename [glob *.vif]
		if { [llength $filename] == 1 } {
				vif2conformal [glob *.vif] $opts
			} elseif {[llength $filename] == 0} {
				puts "Error: No VIF file found"
				puts "Cannot execute vif2conformal, please provide a VIF file"
			} else {
				puts "Error: Found too many VIF files: $filename"
				puts "Cannot execute vif2conformal, please specify file name"
				puts "vif2conformal <filename.vif> [<-const>]"
			}
}
#end of procedure



