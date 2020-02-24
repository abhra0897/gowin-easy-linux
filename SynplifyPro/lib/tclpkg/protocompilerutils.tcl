# ProtoCompiler utility proc's
# $Header: //synplicity/ui2019q3p1/uitools/pm/tclpkg/protocompilerutils.tcl#1 $
package provide protocompilerutils 14.03

# by default, proc's go into the pc namespace so they can be versioned.
# without the namespace, there is no way to "unload" them.
namespace eval pc {
	namespace export option_set_default option_restore_defaults
}

#########################################################################
# commands not in the namespace:
# by default, proc's go into the pc namespace so they can be versioned.

set pc::import_help {import [vivado <par_result_directory>] [quartus <par_result_directory>]
	vivado: alias for database apply_state -import_vivado <par_result_directory>
	quartus: alias for database apply_state -import_quartus <par_result_directory> }
set pc::import_vivado_help "import vivado <par_result_directory>: alias for database apply_state -import_vivado <par_result_directory>"
set pc::import_quartus_help "import quartus <par_result_directory>: alias for database apply_state -import_quartus <par_result_directory>"

proc import {mode {args} } {
	if { $mode == "-help" } {
		puts $::pc::import_help
		return	
	} elseif { $mode == "vivado" } {
		if { $args == "-help" } {
			puts $::pc::import_vivado_help
			return	
		} else {
			return [eval "database apply_state -import_vivado $args"]
		}
	} elseif { $mode == "quartus" } {
		if { $args == "-help" } {
			puts $::pc::import_quartus_help
			return	
		} else {
			return [eval "database apply_state -import_quartus $args"]
		}
	}	
	puts "Unrecognized mode for import: \"$mode\""
}
if {[llength [info command install_command_help]] > 0} {
	install_command_help import $pc::import_help
	install_command_help import vivado $pc::import_vivado_help
	install_command_help import quartus $pc::import_quartus_help
}



# Arg parsing utility from wiki
# usage example:
#proc foo {s args} {
#	named_args $args {-a 0 -b 3 -c "def"}
#	puts "s=$s"
#	puts "a=$(-a)"
#	puts "b=$(-b)"
#	puts "c=$(-c)"
#}
# % foo blah -a 44 -c xx
# s=blah
# a=44
# b=3
# c=xx#
#
proc named_args {args defaults} {
    upvar 1 "" ""
    array set "" $defaults
    foreach {key value} $args {
      if {![info exists ($key)]} {
         error "bad option '$key', should be one of: [lsort [array names {}]]"
      }
      set ($key) $value
    }
}

# rerun current state.
# if -out <state> is not specified, rerun back to itself
#
set pc::rerun_help "Description: regenerate the current state using the original input state and command\nValid usages:\n   rerun \[-out <state>\]\n"
proc rerun { args } {
	if { [lindex $args 0]=="-help"} {
		puts $::pc::rerun_help
		return
	}
	# Arg parsing utility from wiki
	# usage example:
	#proc foo {s args} {
	#	named_args $args {-a 0 -b 3 -c "def"}
	#	puts "s=$s"
	#	puts "a=$(-a)"
	#	puts "b=$(-b)"
	#	puts "c=$(-c)"
	#}
	# % foo blah -a 44 -c xx
	# s=blah
	# a=44
	# b=3
	# c=xx#
	#
	proc named_args {args defaults} {
		upvar 1 "" ""
		array set "" $defaults
		foreach {key value} $args {
		  if {![info exists ($key)]} {
			 error "bad option '$key', should be one of: [lsort [array names {}]]"
		  }
		  set ($key) $value
		}
	}
	named_args $args {-out ""}
	rename named_args ""

	catch { set cmd [database query_state -command] }
	if { "$cmd" == "" } {
		error "Rerun could not be done. Failed to find the Tcl command that generated current state [database get_state]"
	}

	set outstate $(-out)
	if { $outstate=="" } {
		set curstate [database get_state]
		set dot [ expr  1 + [string first . $curstate]]
		if { $dot >= 0 } { set curstate [string range $curstate $dot 999] }

		set outstate $curstate
	}

	# if -out was not given in $cmd, add it
	set idx [lsearch $cmd "-out"]
	if { $idx< 0} {
		lappend cmd -out $outstate
	} else {
		# if -out specified, then replace -out <s> in $cmd with -out <outstate>
		set cmd [lreplace $cmd $idx+1 $idx+1 $outstate]
	}

	if [catch {database set_state [database get_state -previous]} ] {
		error "Rerun could not be done. Failed to set_state to the input state"
	}
	return [eval $cmd]
}

if {[llength [info command install_command_help]] > 0} {
	install_command_help rerun $pc::rerun_help
}

#########################################################################
# Tcl proc called by \"option reset\" defined in protocompilerutils Tcl package"
proc pc::option_set_default opt {
	set dflt [option get_default $opt]
	if { [option get $opt] != $dflt } {
		option set $opt $dflt
		return $dflt
	}
}


# Tcl proc called by \"option reset -all\" defined in protocompilerutils Tcl package
proc pc::option_restore_defaults args {
	set cmd "option list $args"
	set allopts [eval $cmd]
	set modopts {}
	foreach opt $allopts {
		set dflt [::pc::option_set_default $opt]
		if { $dflt != "" } {
			lappend modopts $opt
			#puts "Restoring $opt to $dflt"
		}
	}
	# heuristic: repeat once because some can only be changed based on value of other opts
	foreach opt $modopts {
		set dflt [::pc::option_set_default $opt]
	}
	puts "Restored [llength $modopts] of [llength $allopts] options to default value"
}

proc pc::compare_state_start_time {s1 s2} {
	set s2st 0
	set s1st 0
	catch { set s1st [ database query_state -start_time -state $s1 ] }
	catch { set s2st [ database query_state -start_time -state $s2 ] }
	# latest first, since this is most likely the error of interest
	return [ expr $s2st - $s1st ]
}

# Tcl proc called by \"database list -error_states\" defined in protocompilerutils Tcl package
proc pc::database_list_error_states {} {
	set states [database list]
	set errorstates {}
	foreach s $states {
		catch {
			if { [database query_state -status -state $s]==0 } {
			lappend errorstates $s
		}
	}
	}
	set errorstates [lsort -command ::pc::compare_state_start_time $errorstates]
	return $errorstates
}
	

# convert prt format to pcf format
# usage: $ prt2pcf <input file> <output file>
#
# currently supported Certify commands:
#    logic_place -assign
#    logic_place -replicate
#    board_configure -hstdm_bit_rate
#    board_configure -global_reset
#
proc pc::prt2pcf {inputf outputf {board_srs ""} {netlist_srs ""}} {
    puts "prt2pcf working directory: [pwd]"
    ::pc::convert_cleared_prt2pcf $inputf $outputf
    puts "prt2pcf done."
    return
}
if {[llength [info command install_command_help]] > 0} {
	install_command_help pc::prt2pcf "usage: ::pc::prt2pcf <input file> <output file>. convert prt format (certify) to pcf format (protocompiler)"
}

proc getPureName {var} {
	#removes any curlybraces and returns only the name
	set d [regexp {\{*([^\}]+)\}*} $var dummy e]
	return $e

}

proc getArgValue {line arg} {
	#returns the string following the specified argument
    set i [lsearch $line $arg]
    if {$i>=0} {
        set temp [lindex $line [expr {$i+1}]]		
        set d [getPureName $temp]
	    return $d
    }
    return ""
}

proc isParentCell {parent child} {
    # {a.b} is parent of {a.b.c}
    if {[string length $child]<[string length $parent]} {
        return 0
    }
    set rt [expr {[string range $child 0 [string length $parent]-1]==$parent}]
    return $rt
}

proc pc::convert_cleared_prt2pcf {inputf outputf} {
    if {$inputf=="" || $outputf==""} {
         error "No input or output file name specified."
         return
    }
    #puts "prt2pcf input prt file  = $inputf"
    #puts "prt2pcf output pcf file = $outputf"
    
    if {[catch {set inf [open $inputf r]} err]!=0} {
        error "Unable to open input file $inputf.\n$err"
    }
    if {[catch {set ouf [open $outputf w]} err]!=0} {
        error "Unable to open output file $outputf.\n$err"
    }
    
    # build a dictionary for "logic_place -replcate"
    # for protocompiler, we use one command for both "logic_place -assign" and "logic_place -replicate"
    while {![eof $inf]} {
        set line [gets $inf]
        if {[regexp {^ *logic_place} $line dummy]} {
            set rep_cell_list [getArgValue $line "-replicate"]
            set device [getArgValue $line "-device"]
            # do not translate "\[" to "["
            set rep_cell_list [string map {"\\" "\\\\"} $rep_cell_list]
            if {[llength $rep_cell_list]>0} {
                foreach cell $rep_cell_list {
                    lappend logic_place_replicate_dict($cell) $device
                }
            }
        }
    }
    foreach rep_cell_par [array names logic_place_replicate_dict] {
        # to handle following case:
        # parent is replicated to A (some of its children are only replicated to A)
        # some of its children are replicated to B as well as A
        # in prt it is like:
        #   logic_place -assign {u1ar1} -device {FB1.uA}
        #   logic_place -replicate {u1ar1.ulfsr} -device {FB1.uB}
        #   logic_place -replicate {u1ar1.ulfsr.un4_dataOut} -device {FB2.uA}
        #   logic_place -replicate {u1ar1.ulfsr.dataOut_2[0]} -device {FB2.uA}        
        foreach rep_cell_chi [array names logic_place_replicate_dict] {
            if {$rep_cell_par==$rep_cell_chi} {continue}
            if {[isParentCell $rep_cell_par $rep_cell_chi]} {
                set logic_place_replicate_dict($rep_cell_chi) [concat [getPureName $logic_place_replicate_dict($rep_cell_par)] [getPureName $logic_place_replicate_dict($rep_cell_chi)]]
            }
        }
    }
    seek $inf 0 start
    set printedBoardConstrainComments 0
    set printedBoardLayoutComments 0
    while {![eof $inf]} {
        set line [gets $inf]
        if {[regexp {^ *board_constrain} $line dummy]} {
            # what to do with board constrain? bin_attribute (not work yet)?
            if {$printedBoardConstrainComments==0} {
                set printedBoardConstrainComments 1
                puts $ouf "# @N: board_constrain is to provide board constraint information and guidance to automated partitioning."
            }
            puts $ouf "# $line"
        } elseif {[regexp {^ *logic_place} $line dummy]} {
            # logic_place -assign {io_flops0} -device {mb.uA} -> assign_cell {io_flops0} {mb.uA}
            set cell_list [getArgValue $line "-assign"]
            set rep_cell_list [getArgValue $line "-replicate"]
            set device [getArgValue $line "-device"]
            # do not translate "\[" to "["
            set cell_list [string map {"\\" "\\\\"} $cell_list]
            set rep_cell_list [string map {"\\" "\\\\"} $rep_cell_list]
            if {[llength $cell_list]>0} {
                foreach cell $cell_list {
                    if {"[array names logic_place_replicate_dict $cell]"=="$cell"} {
                        # exactly same
                        puts $ouf "replicate_cell \{$cell\} \{[concat [getPureName $device] [getPureName $logic_place_replicate_dict($cell)]]\}"
                        unset logic_place_replicate_dict($cell)
                    } else {
                        puts $ouf "assign_cell \{$cell\} \{$device\}"
                        # cehck if common parent
                        foreach rep_cell [array names logic_place_replicate_dict] {
                            if {[isParentCell $cell $rep_cell]} {
                                puts $ouf "replicate_cell \{$rep_cell\} \{[concat [getPureName $device] [getPureName $logic_place_replicate_dict($rep_cell)]]\}"
                                unset logic_place_replicate_dict($rep_cell)
                            }
                        }
                    } 
                }
            }
            if {[llength $cell_list]==0 && [llength $rep_cell_list]==0} {
                puts $ouf "# unsupported command"
                puts $ouf "# $line"
            }
        } elseif {[regexp {^ *board_configure} $line dummy]} {
            set hstdm_bit_rate [getArgValue $line "-hstdm_bit_rate"]
            if {[llength $hstdm_bit_rate]>0} {
                puts $ouf "tdm_control -hstdm_bit_rate $hstdm_bit_rate"
            }
            set global_reset [getArgValue $line "-global_reset"]
            if {[llength $global_reset]>0} {
                puts $ouf "tdm_control -hstdm_reset_trace \{$global_reset\}"
            }
            if {[llength $hstdm_bit_rate]==0 && [llength $global_reset]==0} {
                puts $ouf "# unsupported command"
                puts $ouf "# $line"
            }
        } elseif {[regexp {^ *board_layout} $line dummy]} {
            if {$printedBoardLayoutComments==0} {
                set printedBoardLayoutComments 1
                puts $ouf "# @N: board_layout is to stores manual changes to the board layout as viewed by the partition file GUI."
                puts $ouf "#     unsupported in ProtoCompiler."
            }
            puts $ouf "# $line"
        } else {
            if {[llength $line]>0} {
            # unsupported commands
                puts $ouf "# unsupported command"
                puts $ouf "# $line"
            } else {
            # else empty line
                puts $ouf $line
            }
        }
    }
    if {[array size logic_place_replicate_dict]>0} {
        puts $ouf "# Did not find the original assigned FPGA for following cells, please check"
        foreach rep_cell [array names logic_place_replicate_dict] {
            puts $ouf "replicate_cell \{$rep_cell\} \{[getPureName $logic_place_replicate_dict($rep_cell)]\}"
        }
    }
    if {[catch {close $inf} err]!=0} {
        error "Unable to close input file $inputf.\n$err"
    }
    if {[catch {close $ouf} err]!=0} {
        error "Unable to close output file $outputf.\n$err"
    }
    return
}

proc pc::is_help_command line {
	return [regexp {^[a-z_A-Z]+$} $line]
}

proc pc::parse_help_command_list helptext {
	array set cmdhelp {}
	set cmd {}
	set txt {}
	foreach line [split $helptext "\n"] {
		if {[is_help_command $line] } {
			if { $cmd != "" } {
				set cmdhelp($cmd) $txt
			}
			set cmd $line
			set txt ""
		}
		set txt "$txt$line\n"
	}
	# register the final command
	if { $cmd != "" } { set cmdhelp($cmd) $txt }
	return [array get cmdhelp]
}

if {[llength [info command install_command_help]] > 0} {
	if [ catch {
		set pcf_syntax_help_file [format %s/rlwrap/helppcf.txt [installinfo libdir]]
		set fp [open $pcf_syntax_help_file r]
		set pcf_syntax_help [read $fp]
		close $fp
		array set commands [::pc::parse_help_command_list $pcf_syntax_help]
		set cmdnames [lsort [array names commands]]
		foreach cmd $cmdnames {
			install_command_help pcf_syntax $cmd $commands($cmd)
		}
		set sep "\n  "
		install_command_help pcf_syntax "PCF commands: (try \"help pcf_syntax <command>\")$sep[join $cmdnames $sep]"
		} ] {
		install_command_help pcf_syntax "error reading lib/rlwrap/helppcf.txt"
	}
}

namespace eval  pc {
	namespace export design_intent
	set didir "[installinfo libdir]/design_intent/[product_type]"
	set difiles ""
	catch {set difiles [lsort [glob -tails -directory $didir *.tcl]]}

	proc find_design_intent difile {
		global ::pc::didir
		if { [file readable ${::pc::didir}/$difile] } {
			return "$::pc::didir/$difile"
		}
		if { [file readable ${::pc::didir}/${difile}.tcl] } {
			return "${::pc::didir}/${difile}.tcl"
		}
		return -code error "Design intent Tcl file '$difile' not found. Directories searched are $::pc::didir"
	}

	set design_intent_help "Usage: design_intent \[-list\] \[-custom \[<template.tcl>\]\] \[<design_intent.tcl>\]
	-list : list available design_intent option files in the installation
	-custom : create a custom option file using <template.tcl> from the $::pc::didir as template
	    if template is not specified, uses [lindex $::pc::difiles 0]
	<design_intent.tcl> : source this tcl file from $::pc::didir

Description: design_intent assists managing option settings that control optimization of the design
Examples:
  Set \"timing_qor\" as the design intent:
    design_intent timing_qor
  Open \"[lindex $pc::difiles 0]\" design_intent in the editor for customization
  	design_intent -custom"

	if {[llength [info command install_command_help]] > 0} {
		install_command_help design_intent $::pc::design_intent_help
	}
		
	proc design_intent args {
		if { [llength $args] == 0 } {
			return -code error "No arguments given. Try -help option."
		}
		set cmd [lindex $args 0]
		if {"$cmd" == "-help"} { puts $::pc::design_intent_help; return }
		if {"$cmd" == "-list"} {
			return $::pc::difiles
		}
		if {"$cmd" == "-custom"} {
			if { [ llength $args ] > 1 } {
				set t [lindex $args 1]
			} else {
				set t [lindex $::pc::difiles 0]
			}
			set template [find_design_intent $t]
			puts "Using $template as template for custom design_intent file. Save the file locally after modifying"
			edit $template
			return
		}
		set difile [find_design_intent $args]
		set saveopts "opts_[clock seconds].tcl"
		puts "Saving current options as $saveopts"
		export options -path $saveopts
		puts "Sourcing [file tail $difile]"
		source $difile
		return $difile
	}
}
# make design_intent global
namespace import pc::design_intent

