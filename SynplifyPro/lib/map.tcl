# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.

# $Header: //synplicity/mapgw/misc/map.tcl#15 $

# TCL commands to implement constraints
#
# #puts "Loading .../synplcty/lib/map.tcl"

# Return current version of this file
# See constdoc.cpp::constraint_init()
# Versions of SCOPE >=520 do version checking

proc get_maptcl_version { } {
	return 730
}

global scriptPath
set scriptPath [file dirname [info script]]
global loadedScopeAttr
set loadedScopeAttr 0
global currentFile
set currentFile ""
global currentLine
set currentLine 1

global fdc_file
set fdc_file ""
global fdc_line
set fdc_line 1

# procedure to set current line and file
proc synplify_set_sdc_where { args } {
        global fdc_line
        global fdc_file
	# get frame number for commands in this proc
	if { [catch {info frame} i ] } {
		# 'info frame' not supported in this version of TCL 
	} else {
		# get file name for this proc, i.e., this file
		set f [info frame -1]
		set here [dict get $f file]
		for { incr i -1 } { $i > 0 } { incr i -1 } {
			set f [info frame $i]
			set ft [dict get $f type]
        	if { $ft != "source"} {
            	# e.g. commands evaluted by uplevel have no file
        	} else {
				set file [dict get $f file]
				if { $file != $here } {
					# report file lowest on stack that is not this file
					# this is user's command
					set line [dict get $f line]
					if {[llength $args] == 0} {
				  		synplify_push_nwhere $file $line
					}
                    set fdc_file $file
                    set fdc_line $line
					return
				}
			}
		}

		# this is top file ?
	}
} 

# Set up global g_clk. Used for some acf stuff.
global g_clk
set g_clk ""

#
# set up global variable _lib_
#
set _lib_ "SYNPLIFY"

#
# Set up global _ScopeVer_ (Scope version)
# init for compatitiliby with older Scope versions
set _ScopeVer_ 508

# Set up global variable _RefClkId_
set _RefClkId_ 1
set _ClkDomainId_ 0

# Set up global variable for input/output delays
set _iodelayid_ 1

# Set up global variable for define_clock_delay
set _ClockDelayId 1

# Set up global variable _DefaultDomain_
# The default domain name is default_clkgroup.
set _DefaultDomain_ "default_clkgroup"
set _DefaultDomainId_ 1

# Set up two new flags. NewTiming is set to true with the new timing engine. Default is true.
# AsicMapper is set to true in case of asic. Default should be false,
# but this is the asic branch so it is allright.
set _AsicMapper_ "FALSE"
set _SupportCP_ "TRUE" ;# should be set/reset by mappers to indicate support for CPs

set _IsPc_ "FALSE" ;# should be set/reset by mappers to indicate protocompiler mode
set _IsPro_ "TRUE" ;# should be set/reset by mappers to indicate Pro mode
set _CertifyEst_ "FALSE";# should be set/reset by mappers to determine Certify estimation mode

#to print warning message in the log file after checking the preferred severity of that message
proc process_warning {args} {
	global _lib_

     if [expr [llength $args] < 2] {
         error {process_warning Usage in map.tcl: process_warning [msg id] [msg]}
     }

     if {$_lib_ == "SYNPLIFY"} {
     	put_warning_message [lindex [info level 0] 1] [lrange [info level 0] 2 end]        
     }
}

proc set_bus_skew { args } {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		eval [concat add_fdc_constraint set_bus_skew $args];
    }
}

# to tell scope if the file is converted from ASIC
set converted_asci2fpga 0
proc get_converted_asci2fpga { } {
	global converted_asci2fpga 
	return $converted_asci2fpga
}
proc set_converted_asci2fpga { } {
	global converted_asci2fpga 
	set converted_asci2fpga 1
}

# to tell scope if the file is converted from old timing engine
set converted_old2newta 0
proc get_converted_old2newta { } {
	global converted_old2newta 
	return $converted_old2newta
}
proc set_converted_old2newta { } {
	global converted_old2newta 
	set converted_old2newta 1
}

#
#  Print the FDC Query request
#
set fdc_query 0
set use_fdc_query 0
set fdc_entry 1
set col_per 1

proc print_fdc_query {cmd line col} {
  global use_fdc_query
  global coll_array
  global fdc_line

#  log_puts "@N: : $cmd $line"
#  log_puts "==> $col :"
#  foreach_in_collection x $col {
#    log_puts "    [get_object_name $x]"
#  }
  synplify_set_sdc_where 1

  if {[catch {set foo $coll_array($col,line)}]} {
    set coll_array($col,val) "\[$cmd $line \]"
    set coll_array($col,line) $fdc_line
  }
  set use_fdc_query 1
}

proc write_fdc_query_db {line1 line2} {
  global fdc_entry
  global fdc_array
  global fdc_error
  global col_per
  global coll_array
  set fdc_query_db_file [pwd]/fdc_query_db.tcl
  if {[catch {open $fdc_query_db_file a} fpo]} {
    if {!$fdc_error} {
      log_puts "@E: : Cannot open $fdc_query_db_file for writing"
    }
    set fdc_error 1
    return 1
  }
  for {set x 0} {$x<$col_per} {incr x} {
    set all_coll [array names coll_array]
    puts $fpo "set fdc_array($fdc_entry,line1) \{$line1\}"
    puts $fpo "set fdc_array($fdc_entry,line2) \{$line2\}"
    set all_coll [lsort $all_coll]
    foreach {l y} $all_coll {
      set val $coll_array($y)
      catch {unset coll_array($y)}
      catch {unset coll_array($l)}
      regsub -all {(\s+\])} $val "]" val
#      if {[string first $val $line1] != -1} {
        regsub -all {(^\[|\]$)} $val "" val
        puts $fpo "set fdc_array($fdc_entry,col) \{$val\}"
        break
#      }
    }
    if {[llength $all_coll] == 0} {
      puts $fpo "set fdc_array($fdc_entry,col) \{<null>\}"
    }
    incr fdc_entry
  }
  close $fpo
  catch {unset coll_array}
  return 0
}

proc unwind_fdc {line} {
  global coll_array
  global col_per
  set init 1
  set prev_val ""
  set prev_i ""
  set col_list {}

  set inx [lsearch -all -regexp $line  {^s:}]
  if {$inx eq ""} {
    return [regsub -all {\s+\]} [join $line] {]}]
  }
  set col_per [llength $inx]
  foreach x $inx {
    set col_list [linsert $col_list 0 [lindex $line $x]]
  }
  set line [join $line]
  foreach col $col_list {
    if {[catch {set val $coll_array($col,val)}]} {
      return "[regsub -all {\s+\]} $line {]}]  ***** @W: check_fdc_query :  The parent collection command is not currently supported *****"
    }
    while {1} {
      if {[regexp {s:[0-9]+} $val foo]} {
        if {![catch {set bar $coll_array($foo,val)}]} {
          set val [string map "$foo [regsub -all {(\s)} $bar {\\\1}]" $val]
          catch {unset coll_array($foo,val)}
          catch {unset coll_array($foo,line)}
        } else {
          return "[regsub -all {\s+\]} $line {]}]  ***** @W: check_fdc_query :  This collection command is not currently supported in check_fdc_query *****"
        }
      } else {
        break
      }
    }
    set coll_array($col,val) $val
    set line [string map "$col [regsub -all {(\s)} $val {\\\1}]" $line]
  }
  return [regsub -all {\s+\]} $line {]}]
}

### remove collections from any past, unrelated, calls to the query commands
#
proc clean_col_array {a_line} {
  global coll_array

  set all_coll [array names coll_array]
  set all_coll [lsort $all_coll]
  foreach {l v} $all_coll {
    if {$coll_array($l) < $a_line} {
      catch {unset coll_array($l)}
      catch {unset coll_array($v)}
    }
  }
}

#
#  If we're not using the default hierarchy separator {.}, escape dots (.) and square brackets
#  if they are not already escaped.
#
proc escape_chars {strg} {
  global HierSeparator
  set h $HierSeparator
  set strg [clean_line_fdc $strg]
  set strg_org $strg
  regsub -all {\\\.} $strg {@} strg
  regsub -all {\\\[} $strg {#} strg
  regsub -all {\\\]} $strg {%} strg
  regsub -all {\.} $strg {\.}  strg
#  regsub -all {\[|\]} $strg {\\&} strg
  eval "regexp \{\\$h\[^\\$h\]+\$\} \{$strg\} foo"
  if {[catch {set foo $foo}]} {
    return $strg_org
  }
  eval "regsub \{\\$h\[^\\$h\]+\$\} \{$strg\} \"\" strg1"
  regsub -all {\\\[} $foo {[} foo
  regsub -all {\\\]} $foo {]} foo
  set strg ${strg1}$foo
  regsub -all {@} $strg {\.} strg
  regsub -all {#} $strg {\[} strg
  regsub -all {%} $strg {\]} strg
  return $strg
}

#
#  Add a constraint to the database
#
proc addConstraint2Database { constraintName constraintArgs } {
	global _lib_
	global cdb_id
        global fdc_query
        global use_fdc_query
        global fdc_line
        global fdc_file
        global coll_array
	
	if { [expr [llength $constraintArgs] == 1] } {
#		warning "length is equal to 1: $constraintArgs"
		set constraintArgs [lindex $constraintArgs 0]
#		warning "new args are $constraintArgs"
	}

    if {$_lib_ == "SYNPLIFY"} {
       synplify_set_sdc_where
       incr cdb_id
       # NB: synplify_add_constraint_2_db sets global cdb_id 
       synplify_add_constraint_2_db $constraintName $constraintArgs -1
       if {$fdc_query && $use_fdc_query && [lsearch -exact $constraintArgs "-disable"] == -1} {
         set cmd_expr {(create_clock|set_input_delay|set_output_delay|set_false_path|set_clock_groups|create_generated_clock|create_generated_budget_clock|set_clock_latency|set_clock_uncertainty|set_max_delay|set_multicycle_path|reset_path|set_datapathonly_delay|set_clock_route_delay|set_reg_input_delay|set_reg_output_delay|define_attribute){1}}
         set match [regexp $cmd_expr $constraintName]
         if {$match} {
           clean_col_array $fdc_line
           set new_args [unwind_fdc $constraintArgs]
           write_fdc_query_db "# $cdb_id : $constraintName $new_args" "# line $fdc_line in  : $fdc_file"
#           log_puts "# $cdb_id : $constraintName $new_args"
#           log_puts "# line $fdc_line in  : $fdc_file"
#           log_puts "############################### "
         }
       }
       catch {unset coll_array}
       set use_fdc_query 0
    } elseif {$_lib_ == "SETCONST"} {
    }
}

#
# This procedure (prepend) is used implement commands like get_clocks e.g.:
# given a prefix "c:" and an argument list "A { B C } D"
# return a string "c:A c:B c:D". These commands should really be doing netlist 
# searches to get collections of objects instead of calling this procedure.
# 
# If a name is in curly braces, we need to preserve escapes and special characters.
# If a name already has a qualifier, do not add another one.
#
#
proc prepend { pretext strings } {

	set output ""
    regsub -all {\{\s+} $strings "{" strings
    regsub -all {\s+\}} $strings "}" strings

	# each argument is one or more names

	# for each argument
	while { [expr [llength $strings] > 0] } {
		set substring [lindex $strings 0]
		set strings [lrange $strings 1 end]

		# for convenience,
		# replace any spaces and tabs with exactly one space before each name
		set substring " $substring"
		set substring [regsub -all {\s\s*} $substring " " ]
		set substring [string trimright  $substring ]

		# for each name in the argument
		for {set i 0 } { $i >= 0 } { set i [string first " " $substring $i ] } {
			if { [regexp -start $i {\A\s[abpivtncs]:} $substring] } {
				# already has a prefix
			} elseif { [regexp -start $i {\A\s\S*\|[abpivtncs]:} $substring] } {
				# already has a prefix (ugly version)
			} else {
				# prepend name with qualifier
				set substring [string replace $substring $i $i " $pretext" ] 
			}
			incr i
		}
                regsub -all " ${pretext}\{" $substring " \{${pretext}" substring
		# add the results for this argument to that for other arguments
		set output "$output $substring"
	}

	# remove extra spaces
	set output [regsub -all {\s\s*} $output " " ]
	return [string trim $output]

}
#
# clock commands
#
proc derive_clocks { args } {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
}
proc derive_pll_clocks { args } {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
}


#
# proc to handle args to the get_* and all_* for display in SCOPE
#
proc args_to_strg {l_args} {
        set q_exp  {((^\[\s*(get_cells|get_clocks|get_nets|get_pins|get_ports|get_keepers|all_clocks|all_inputs|all_outputs|all_registers|all_keepers))|(^-)){1}}
        set q_exp1 {(^(get_cells|get_clocks|get_nets|get_pins|get_ports|get_keepers|all_clocks|all_inputs|all_outputs|all_registers|all_keepers)$){1}}
        set str ""
        foreach x $l_args {
          if {[regexp $q_exp $x]} {
            set str "$str $x"
          } elseif {[regexp $q_exp1 $x]} {
            set str "$str \[$x"
          } else {
            set str "$str \{$x\}"
          }
        }
        return $str
}

set HierSeparator {.}
#
# calls for qualifying objects as a specific type
#
proc get_cells { args } {
    global _lib_
    global fdc_query
    global HierSeparator
    if {$_lib_ == "SYNPLIFY"} {
        if {$HierSeparator ne "."} {
          set new_args {}
          set abort 0
          foreach a $args {
            if {[regexp {^-} $a]} {set abort 1; break}
            set new_args [linsert $new_args end [escape_chars $a]]
          }
          if {!$abort} {set args $new_args}
        }
        set val [eval synplify_get_cells $args]
        if {$fdc_query} {
          print_fdc_query "get_cells" $args $val
        }
	return $val
    } else {
        set args [args_to_strg $args]
        return "\[get_cells $args\]"
    }

}

proc get_clocks { args } {
    global _lib_
    global fdc_query
    global HierSeparator
    if {$_lib_ == "SYNPLIFY"} {
          set val [eval synplify_get_clocks $args]
          if {$fdc_query} {
            print_fdc_query "get_clocks" $args $val
          }
 	  return $val
    } else {
        set args [args_to_strg $args]
        return "\[get_clocks $args\]"
    }
}

proc get_nets { args } {
        global _lib_
        global fdc_query
        global HierSeparator
        if {$_lib_ == "SYNPLIFY"} {
          if {$HierSeparator ne "."} {
            set new_args {}
            set abort 0
            foreach a $args {
              if {[regexp {^-} $a]} {set abort 1; break}
              set new_args [linsert $new_args end [escape_chars $a]]
            }
            if {!$abort} {set args $new_args}
          }
          set val [eval synplify_get_nets $args]
          if {$fdc_query} {
            print_fdc_query "get_nets" $args $val
          }
          return $val
        } else {
          set args [args_to_strg $args]
          return "\[get_nets $args\]"
        }
}

proc get_pins { args } {
        global _lib_
        global fdc_query
        global HierSeparator
    if {$_lib_ == "SYNPLIFY"} {
          if {$HierSeparator ne "."} {
            set new_args {}
            set abort 0
            foreach a $args {
              if {[regexp {^-} $a]} {set abort 1; break}
              set new_args [linsert $new_args end [escape_chars $a]]
            }
            if {!$abort} {set args $new_args}
          }
          set val [eval synplify_get_pins $args]
          if {$fdc_query} {
            print_fdc_query "get_pins" $args $val
          }
          return $val
    } else {
        set args [args_to_strg $args]
        return "\[get_pins $args\]"
    }
}

proc get_ports { args } {
        global _lib_
        global fdc_query
        global HierSeparator
     if {$_lib_ == "SYNPLIFY"} {
          set val [eval synplify_get_ports $args]
          if {$fdc_query} {
            print_fdc_query "get_ports" $args $val
          }
          return $val
     } else {
        set args [args_to_strg $args]
        return "\[get_ports $args\]"
     }
}

proc get_keepers { args } {
        global _lib_
        global fdc_query
     if {$_lib_ == "SYNPLIFY"} {
          set val [eval synplify_get_keepers $args]
          if {$fdc_query} {
            print_fdc_query "get_keepers" $args $val
          }
          return $val
     } else {
        set args [args_to_strg $args]
        return "\[get_keepers $args\]"
     }
}

proc get_registers { args } {
        global _lib_
        global fdc_query
        global HierSeparator
     if {$_lib_ == "SYNPLIFY"} {
          if {$HierSeparator ne "."} {
            set new_args {}
            set abort 0
            foreach a $args {
              if {[regexp {^-} $a]} {set abort 1; break}
              set new_args [linsert $new_args end [escape_chars $a]]
            }
            if {!$abort} {set args $new_args}
          }
          set val [eval synplify_get_registers $args]
          if {$fdc_query} {
            print_fdc_query "get_registers" $args $val
          }
          return $val
     } else {
        set args [args_to_strg $args]
        return "\[get_registers $args\]"
     }
}

#
# get collections of objects
#
proc all_clocks { args } {
        global _lib_
        global fdc_query
     if {$_lib_ == "SYNPLIFY"} {
          set val [eval synplify_all_clocks $args]
          if {$fdc_query} {
            print_fdc_query "all_clocks" $args $val
          }
          return $val
     } else {
        set args [args_to_strg $args]
        return "\[all_clocks $args\]"
     }
}
proc all_inputs { args } {
        global _lib_
        global fdc_query
     if {$_lib_ == "SYNPLIFY"} {
          set val [eval synplify_all_inputs $args]
          if {$fdc_query} {
            print_fdc_query "all_inputs" $args $val
          }
          return $val
     } else {
        set args [args_to_strg $args]
        return "\[all_inputs $args\]"
     }
}
proc all_outputs { args } {
        global _lib_
        global fdc_query
     if {$_lib_ == "SYNPLIFY"} {
          set val [eval synplify_all_outputs $args]
          if {$fdc_query} {
            print_fdc_query "all_outputs" $args $val
          }
          return $val
     } else {
        set args [args_to_strg $args]
        return "\[all_outputs $args\]"
     }
}
proc all_registers { args } {
        global _lib_
        global fdc_query
     if {$_lib_ == "SYNPLIFY"} {
          set val [eval synplify_all_registers $args]
          if {$fdc_query} {
            print_fdc_query "all_registers" $args $val
          }
          return $val
     } else {
        set args [args_to_strg $args]
        return "\[all_registers $args\]"
     }
}
proc all_keepers { args } {
        global _lib_
        global fdc_query
     if {$_lib_ == "SYNPLIFY"} {
          set val [eval synplify_all_keepers $args]
          if {$fdc_query} {
            print_fdc_query "all_keepers" $args $val
          }
          return $val
     } else {
        set args [args_to_strg $args]
        return "\[all_keepers $args\]"
     }
}

#
# timing exceptions
#
proc set_false_path { args } {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		eval [concat add_fdc_constraint set_false_path $args];
    }
}
proc set_max_delay { args } {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		eval [concat add_fdc_constraint set_max_delay $args];
    }
}
proc set_max_time_borrow { args } {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		eval [concat add_fdc_constraint set_max_time_borrow $args];
    }
}
proc set_datapathonly_delay { args } {
    global _lib_
	global _ScopeVer_

    if {$_lib_ == "SYNPLIFY"} {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 201209 } {
			set disable 0
			set comment *
			set fromList {} 
			set toList {}
			set delay {}
			while { [expr [llength $args] > 0] } {
				set param [lindex $args 0]
				if {$param == "-disable"} {
					set disable 1
					set args [lrange $args 1 end]
				} elseif {$param == "-comment"} {
	  				set comment [lindex $args 1]
					set args [lrange $args 2 end]
				} elseif {$param == "-from"} {
					lappend fromList [lindex $args 1] 
					set args [lrange $args 2 end]
				} elseif {$param == "-rise_from"} {
					lappend fromList [lindex $args 1]  
					append fromList ":r" 
					set args [lrange $args 2 end]
				} elseif {$param == "-fall_from"} {
					lappend fromList [lindex $args 1]
					append fromList ":f"  
					set args [lrange $args 2 end]
				} elseif {$param == "-to"} {
					lappend toList [lindex $args 1]  
					set args [lrange $args 2 end]
				} elseif {$param == "-rise_to"} {
					lappend toList [lindex $args 1]  
					append toList ":r"  
					set args [lrange $args 2 end]
				} elseif {$param == "-fall_to"} {
					lappend toList [lindex $args 1]  
					append toList ":f"  
					set args [lrange $args 2 end]
				} else {
					set delay $param
					set args [lrange $args 1 end]
				}
			}
			add_datapathonly_delay_constraint $disable $comment $fromList $toList $delay
		} else {
			eval [concat add_fdc_constraint set_datapathonly_delay $args];
		}
    }
}
proc set_min_delay { args } {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		eval [concat add_fdc_constraint set_min_delay $args];
    }
}

proc set_min_pulse_width { args } {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
        syn_wrong_sdc_format
    }
}

proc set_multicycle_path { args } {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		eval [concat add_fdc_constraint set_multicycle_path $args];
    }
}

#
# io delay
#
proc set_input_delay { args } {
    global _lib_
	global _ScopeVer_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 201209 } {
		set commandname "set_input_delay"
		set delaytype "input"
		set rise *
		set fall *
		set max *  
		set min *
		set clock *
		set clock_fall *
		set add_delay *
		set val *
		set objname ""
		set arglist ""
		set enable 1
		set comment ""
		while { [expr [llength $args] >0] } {
			set sw [lindex $args 0]
			set args [lrange $args 1 end]
			if { [string range $sw 0 0] != {-} } {
				set arglist [concat $arglist $sw]
				set objname $sw
			} else {  
				  set value [ lindex $args 0 ]
				  set args [lrange $args 1 end]
				  switch -- $sw {
				  "-rise" {
						set rise $value
				  }
				  "-fall" {
						set fall $value
				  }
				  "-max" {
						set max $value
				  }
				  "-min" {
						set min $value
				  }
				  "-clock" {
						set clock $value
				  }
				  "-clock_fall" {
						set clock_fall $value
				  }
				  "-add_delay" {
						set add_delay $value
				  }
				  "-value" {
						set val $value
				  }
				  "-disable" {
						set enable 0
						set args [concat $value $args]
				  }
				  "-comment" {
	        	        set comment $value
				  }
				  default {
						error [format "set_input_delay: unknown switch %s" $sw]
				  }
				} ;# switch
			} ;# else
		 }; #while
		add_fdc_io_constraint $commandname $enable $delaytype $rise $fall $max $min $clock $clock_fall $add_delay $val $objname $comment
		} else {
			eval [concat add_fdc_constraint set_input_delay $args];
		}
    }
}

proc set_output_delay { args } {
    global _lib_
	global _ScopeVer_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 201209 } {
		set commandname "set_output_delay"
		set delaytype "output"
		set rise *
		set fall *
		set max *  
		set min *
		set clock *
		set clock_fall *
		set add_delay *
		set val *
		set objname ""
		set arglist ""
		set enable 1
		set comment ""
		while { [expr [llength $args] >0] } {
			set sw [lindex $args 0]
			set args [lrange $args 1 end]
			if { [string range $sw 0 0] != {-} } {
				set arglist [concat $arglist $sw]
				set objname $sw
			} else {  
				  set value [ lindex $args 0 ]
				  set args [lrange $args 1 end]
				  switch -- $sw {
				  "-rise" {
						set rise $value
				  }
				  "-fall" {
						set fall $value
				  }
				  "-max" {
						set max $value
				  }
				  "-min" {
						set min $value
				  }
				  "-clock" {
						set clock $value
				  }
				  "-clock_fall" {
						set clock_fall $value
				  }
				  "-add_delay" {
						set add_delay $value
				  }
				  "-value" {
						set val $value
				  }
				  "-disable" {
						set enable 0
						set args [concat $value $args]
				  }
				  "-comment" {
	        	        set comment $value
				  }
				  default {
						error [format "set_input_delay: unknown switch %s" $sw]
				  }
				} ;# switch
			} ;# else
		 }; #while
		add_fdc_io_constraint $commandname $enable $delaytype $rise $fall $max $min $clock $clock_fall $add_delay $val $objname $comment
		} else {
			eval [concat add_fdc_constraint set_output_delay $args];
		}
    }
}

#
# clocks
#
proc create_clock { args } {
    global _lib_
	global _ScopeVer_;

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 201209 } {
		set commandname "create_clock"
		set enable 1
		set add 0
		set name *
		set period *
		set waveform *
		set objname *
		set comment ""
		set arglist *
		while { [expr [llength $args] >0] } {
			set sw [lindex $args 0]
			set args [lrange $args 1 end]
			if { [string range $sw 0 0] != {-} } {
				set arglist [concat $arglist $sw]
				set objname $sw
			} else {  
				  set value [ lindex $args 0 ]
				  set args [lrange $args 1 end]
				  switch -- $sw {
				  "-disable" {
						set enable 0
						set args [concat $value $args]
				  }
				  "-add" {
						set add 1
						set args [concat $value $args]
				  }
				  "-name" {
						set name $value
				  }
				  "-period" {
						set period $value
				  }
				  "-waveform" {
						set waveform $value
				  }
				  "-comment" {
	        	        set comment $value
				  }
				  default {
						error [format "create_clock: unknown switch %s" $sw]
				  }
				} ;# switch
			} ;# else
		 }; #while
		add_fdc_clock_constraint $commandname $enable $add $name $period $waveform $objname $comment
		} else {
			eval [concat add_fdc_constraint create_clock $args];
		}
    }
}

proc create_generated_clock { args } {
    global _lib_
	global _ScopeVer_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 201209 } {
		set commandname "create_generated_clock"
		set enable 1
		set name *
		set comment ""
		set source "*"
		set master_clock "*"
		set invert 0
		set combinational 0
		set add 0
		set val *
		set objname ""
		set arglist ""
		set generate_type "*"
		set generate_params "*"
		set generate_modifier "*"
		set generate_modifier_params "*"
		while { [expr [llength $args] >0] } {
			set sw [lindex $args 0]
			set args [lrange $args 1 end]
			if { [string range $sw 0 0] != {-} } {
				set arglist [concat $arglist $sw]
				set objname $sw
			} else {  
				  set value [ lindex $args 0 ]
				  set args [lrange $args 1 end]
				  switch -- $sw {
				  "-disable" {
						set enable 0
						set args [concat $value $args]
				  }
				  "-comment" {
	        	        set comment $value
				  }
				  "-name" {
						set name $value
				  }
				  "-source" {
						set source $value
				  }
				  "-master_clock" {
						set master_clock $value
				  }
				  "-invert" {
						set invert 1
				  }
				  "-combinational" {
						set combinational 1
				  }
				  "-add" {
						set add 1
				  }
				  "-edges" {
						set generate_type "edges"
						set generate_params $value
				  }
				  "-divide_by" {
						set generate_type "divide_by"
						set generate_params $value
				  }
				  "-multiply_by" {
				  		set generate_type "multiply_by"
						set generate_params $value
				  }
				  "-edge_shift" {
						set generate_modifier "edge_shift"
						set generate_modifier_params $value
				  }
				  "-duty_cycle" {
						set generate_modifier "duty_cycle"
						set generate_modifier_params $value
				  }
				  default {
						error [format "create_generated_clock: unknown switch %s" $sw]
				  }
				} ;# switch
			} ;# else
		 }; #while
		add_fdc_generated_clock_constraint $commandname $enable $name $source $master_clock $invert $combinational $add $generate_type $generate_params $generate_modifier $generate_modifier_params $objname $comment
		} else {
			eval [concat add_fdc_constraint create_generated_clock $args];
		}
    }
}

proc create_generated_budget_clock { args } {
    global _lib_
	global _ScopeVer_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 201209 } {
		set commandname "create_generated_budget_clock"
		set enable 1
		set name *
		set comment ""
		set source "*"
		set master_clock "*"
		set invert 0
		set combinational 0
		set add 0
		set val *
		set objname ""
		set arglist ""
		set generate_type "*"
		set generate_params "*"
		set generate_modifier "*"
		set generate_modifier_params "*"
		while { [expr [llength $args] >0] } {
			set sw [lindex $args 0]
			set args [lrange $args 1 end]
			if { [string range $sw 0 0] != {-} } {
				set arglist [concat $arglist $sw]
				set objname $sw
			} else {  
				  set value [ lindex $args 0 ]
				  set args [lrange $args 1 end]
				  switch -- $sw {
				  "-disable" {
						set enable 0
						set args [concat $value $args]
				  }
				  "-comment" {
	        	        set comment $value
				  }
				  "-name" {
						set name $value
				  }
				  "-source" {
						set source $value
				  }
				  "-master_clock" {
						set master_clock $value
				  }
				  "-invert" {
						set invert 1
				  }
				  "-combinational" {
						set combinational 1
				  }
				  "-add" {
						set add 1
				  }
				  "-edges" {
						set generate_type "edges"
						set generate_params $value
				  }
				  "-divide_by" {
						set generate_type "divide_by"
						set generate_params $value
				  }
				  "-multiply_by" {
				  		set generate_type "multiply_by"
						set generate_params $value
				  }
				  "-edge_shift" {
						set generate_modifier "edge_shift"
						set generate_modifier_params $value
				  }
				  "-duty_cycle" {
						set generate_modifier "duty_cycle"
						set generate_modifier_params $value
				  }
				  default {
						error [format "create_generated_budget_clock: unknown switch %s" $sw]
				  }
				} ;# switch
			} ;# else
		 }; #while
		add_fdc_generated_clock_constraint $commandname $enable $name $source $master_clock $invert $combinational $add $generate_type $generate_params $generate_modifier $generate_modifier_params $objname $comment
		} else {
			eval [concat add_fdc_constraint create_generated_budget_clock $args];
		}
    }
}

proc set_clock_groups { args } {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
		eval [concat add_fdc_constraint set_clock_groups $args];
    }
}

#
# other
#
proc set_view_separator { args } {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
}
proc set_hierarchy_separator { args } {
	global HierSeparator
	global _lib_
	if { $_lib_=="SETCONST"} {
        syn_wrong_sdc_format
    } else {
		catch [eval synplify_set_hierarchy_separator $args]
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
		set HierSeparator [lindex $args 0]
	}
}
proc set_rtl_ff_names { args } {
	global _lib_
	if { $_lib_=="SETCONST"} {
        syn_wrong_sdc_format
    } else {
		catch [eval synplify_set_rtl_ff_names $args]
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	}
}
proc bus_dimension_separator_style { args } {
    global _lib_
    if {$_lib_ == "SYNPLIFY"} {
		catch [eval synplify_bus_dimension_separator_style $args]
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
        syn_wrong_sdc_format
    }
}

proc bus_naming_style { args } {
    global _lib_
    if {$_lib_ == "SYNPLIFY"} {
		catch [eval synplify_bus_naming_style $args]
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
        syn_wrong_sdc_format
    }
}



#
# Check to see if a property is allowed.
#
proc isAllowedHiddenAttribProp {propname} {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {

       if {[synplify_isAllowedHiddenAttribProp $propname]} {
           return 1
       } 

    } elseif {$_lib_ == "SETCONST"} {
       return 0
    }
    return 0
}

#
# define_reset_path call
#
proc define_reset_path {args} {
	global _lib_

	# open in UI
	if {$_lib_ == "SETCONST"} {
		set disable 0
		set comment *
		while { [expr [llength $args] > 0] } {
			set param [lindex $args 0]
			switch -- $param {
				"-disable" {
					set $disable 1
					set args [lrange $args 1 end]
				}
    	        "-comment" {
        	        set $comment [lindex $args 1]
					set args [lrange $args 2 end]
	            }
				default {
					set args [lrange $args 1 end]
				}
			}
		}

		add_path_delay_constraint $disable $comment
		
	} else {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	}
}

#
# reset_path call
#
proc reset_path {args} {
	global _lib_
	global _ScopeVer_

	# open in UI
	if {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 201209 } {
		set disable 0
		set comment *
		while { [expr [llength $args] > 0] } {
			set param [lindex $args 0]
			switch -- $param {
				"-disable" {
					set $disable 1
					set args [lrange $args 1 end]
				}
    			"-comment" {
        			set $comment [lindex $args 1]
					set args [lrange $args 2 end]
				}
				default {
					set args [lrange $args 1 end]
				}
			}
		}

		add_path_delay_constraint $disable $comment
		} else {
			eval [concat add_fdc_constraint reset_path $args];
		}		
	} else {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	}
}

#
# Defines collection for SCOPE
# define_scope_collection [-disable] [-comment <comment>] <collection_name> {<coll_tcl_cmd>}
#
proc define_scope_collection { args } {
	global _lib_

	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	if {$_lib_ == "SYNPLIFY"} {
    	eval synplify_define_collection $args
	 } elseif {$_lib_ == "SETCONST"} {

		global _ScopeVer_

		set oldargs $args
		set comment *
		set disabled 0

		while { [expr [llength $args] >0] } {
			set sw [lindex $args 0]
			set args [lrange $args 1 end]
			if { $sw == "-disable" } {
				set disabled 1		
			} elseif { $sw == "-comment" } {
				set comment  [lindex $args 0]
				set args [lrange $args 1 end]
			} else {
				set coll_name $sw
				set tcl_cmd [lindex $args 0]
				set args [lrange $args 1 end]
			}
		}

		
		if { $_ScopeVer_ < 201209 } {
			add_collection $disabled $comment $coll_name $tcl_cmd
		} else {
			eval [concat add_fdc_constraint define_scope_collection $oldargs];
		}

	}
}

#
# Set the current design which is the default place to begin object
# path searches from.
# args: [-disable] object
#
proc define_current_design {args} {

	global _lib_

	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	if {$_lib_ == "SYNPLIFY"} {
		eval synplify_define_current_design $args
	} elseif {$_lib_ == "SETACF"} {
		#puts {oops}
	} elseif {$_lib_ == "SETCONST"} {

		set disable 0
		if {[lindex $args 0] == "-disable"} {
			set disable 1
			set args [lrange $args 1 end]
		}

		set comment *
		if {[lindex $args 0] == "-comment"} {
			set comment  [lindex $args 1]
			set args [lrange $args 2 end]
		}

		set object [lindex $args 0]

		if {$disable == 1} {
			# disabled 
		} else {
			scope_define_current_design $object
		}
	}

}

#
# Get the current design (set by define_current_design, top design if not set)
# args: [-disable]
#
proc get_current_design {args} {

	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	global _lib_

	if {$_lib_ == "SYNPLIFY"} {
		return [eval synplify_get_current_design $args]
	} elseif {$_lib_ == "SETACF"} {
		#puts {oops}
	} elseif {$_lib_ == "SETCONST"} {
		#puts {oops}
	}
}

#
# Set the current instance which is the default place to begin object
# path searches from.
# args: [-disable] object
#
proc define_current_instance {args} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	 global _lib_

	if {$_lib_ == "SYNPLIFY"} {
		eval synplify_define_current_instance $args
	} elseif {$_lib_ == "SETACF"} {
		#puts {oops}
	} elseif {$_lib_ == "SETCONST"} {
		#puts {oops}
	}
}

#
# Get the current instance (set by define_current_instancet)
# args: [-disable]
#
proc get_current_instance {args} {

	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	global _lib_

	if {$_lib_ == "SYNPLIFY"} {
		return [eval synplify_get_current_instance $args]
	} elseif {$_lib_ == "SETACF"} {
		#puts {oops}
	} elseif {$_lib_ == "SETCONST"} {
		#puts {oops}
	}
}

#
# General attribute mechanism
#
# args: [-disable] object propname str
#
proc define_attribute {args} {

	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	 global _lib_
	 global _ScopeVer_

	if {[lindex $args 1] == "syn_compile_point"} {	
		set args_copy [lindex $args 3]
	} else {
		set args_copy "define_attribute $args"
	}
	if {$_lib_ == "SETCONST"} {
		set args_copy_ui $args
	}
	
	set comment *
	set disable 0

	while { [expr [llength $args] >0] } {
		set sw [lindex $args 0]
		set args [lrange $args 1 end]
		if { $sw == "-disable" } {
			set disable 1		
		} elseif { $sw == "-comment" } {
			set comment  [lindex $args 0]
			set args [lrange $args 1 end]
		} else {
			set object $sw
			
			set propname [lindex $args 0]
			if { [ string length "$propname" ] == 0 } {
				# propname is NIL
				return
			}
			set args [lrange $args 1 end]
			set str [lindex $args 0]

			set args [lrange $args 1 end]
		}

	}
	if {$_lib_ == "SYNPLIFY"} {
		if {$disable == 0} {
				set str [synplify_clean_spaces $str]
				set propname [synplify_clean_spaces $propname]
				set object [synplify_clean_spaces $object] ;# because of -find only leading & trailing sapces can be removed
				synplify_define_attribute $object $propname $str $args_copy
		}
	} elseif {$_lib_ == "SETACF"} {
		if {$disable == 0} {
			global acf
			switch -exact -- $propname {
				 altera_implement_in_eab {
					  acf_set_eabize $acf $object $str
				 }

				 altera_chip_pin_lc {
					  acf_set_pin $acf $object $str
				 }
			}
		}
	} elseif {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 520 } {
			add_attr_constraint $disable $object $propname $str
		} else {
			if { $_ScopeVer_ < 201209 } {
			add_attr_constraint $disable $comment $object $propname $str
			} else {
				eval [concat add_fdc_constraint define_attribute $args_copy_ui];
			}
		}
	}
}

# top level attribute
# args: [-disable] propname str
# This one works just like define_attribute, it has a loop to handle multiple "prop value" pairs.
proc define_global_attribute {args} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	global _lib_
	global _ScopeVer_

	set args_copy "define_global_attribute $args"
	if {$_lib_ == "SETCONST"} {
		set args_copy_ui $args
	}
	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}
	set propname [lindex $args 0]
	if { [ string length "$propname" ] == 0 } {
		# propname is NIL
		return
	}
	set args [lrange $args 1 end]

	set str [lindex $args 0]
	set args [lrange $args 1 end]
	if {$_lib_ == "SYNPLIFY"} {
		  if {$disable == 0} {
				synplify_define_attribute {t:} $propname $str $args_copy
		}
	} elseif {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 520 } {
			add_attr_constraint $disable "<global>" $propname $str
		} else {
			if { $_ScopeVer_ < 201209 } {
			add_attr_constraint $disable $comment "<global>" $propname $str
			} else {
				eval [concat add_fdc_constraint define_global_attribute $args_copy_ui];
			}
		}
	}
}

# Set haps_io standards
# args:define_haps_io {p:portname} –haps_io {J1A[0]} [–add_clock_deskew PLL|MMCM] –comment {“xxx”}
#
proc define_haps_io {args} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	global _lib_
	global _ScopeVer_
	global _IsPc_
	global _AllowHapsIo_
	set args_copy "define_haps_io $args"
	set args_copy_ui $args
	set comment ""
	if [expr [llength $args] < 1] {
		error {define_haps_io usage: define_haps_io <portname> –haps_io <haps pin name> [-comment <comment>]}
	}

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	
	set objname [lindex $args 0]
	set args [lrange $args 1 end]
    set scope_objname $objname


    set isglobal 0

	#set defaults
    # UI uses dynamic column names and tcls need to update this when we add new columns
    set hapsIoTcl ".haps_pin_loc"
    set commentTcl "-comment"

    set haps_io ""
    
	# Options after obj name assume -<option> <value
	while { [expr [llength $args] >0] } {

		set sw [lindex $args 0]

		set args [lrange $args 1 end]
		set value [ lindex $args 0 ]
		
		# puts "args=$args. sw= $sw." 
		switch -- $sw {
			"-haps_io" {
				set haps_io $value
			}
            "-comment" {
                set comment $value
            }

			default {
				error [format "define_haps_io: unknown switch %s" $sw]
			}
		}
		set args [lrange $args 1 end]
	}


	 if {$_lib_ == "SYNPLIFY"} {
		  if {$disable == 0} {
			if {$_AllowHapsIo_ != "TRUE"}  {
				error	 "define_haps_io command in ProtoCompiler is not supported for this family, please use TSS flow"
			} else {
				set objname [synplify_clean_spaces $objname] ;
				set haps_io [synplify_clean_spaces $haps_io]
				if {[string compare $haps_io ""] != 0} {
					synplify_define_attribute $objname $hapsIoTcl $haps_io $args_copy
				}
				set comment [synplify_clean_spaces $comment]
				if {[string compare $comment ""] != 0} {
					synplify_define_attribute $objname $commentTcl $comment $args_copy
				}
			}
		  }
	 } elseif {$_lib_ == "SETACF"} {
		puts {oops}
     } elseif {$_lib_ == "SETCONST"} {
		eval [concat add_fdc_constraint define_haps_io $args_copy_ui];
	 }
}

# Set define_haps_fpga
# args:define_haps_fpga  -type {HAPS-XX}  -location {FB[1-8]_[A-D]}
#
proc define_haps_fpga {args} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	global _lib_
	global _ScopeVer_
	global _IsPc_
	global _AllowHapsIo_
	set args_copy "define_haps_fpga_location $args"
	set args_copy_ui $args
	set type ""
	set fpga ""
	if [expr [llength $args] < 1] {
		error {define_haps_fpga usage: define_haps_fpga  -type <haps board type>  -location {fpga location as FB[1-8]_[A-D]}}  
	}

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	
	set args [lrange $args 0 end]
    set isglobal 0

	#set defaults
    # UI uses dynamic column names and tcls need to update this when we add new columns
    set hapsFpgaLocTcl ".haps_fpga_location"
    set cdeOrderTcl ".haps_cde_chain_order"
	set boardTypeTcl ".haps_board_type"
	set UmrBusTcl ".umr_capim_bus"
    
    
	# Options after obj name assume -<option> <value
	while { [expr [llength $args] >0] } {

		set sw [lindex $args 0]
        set args [lrange $args 1 end]
		set value [ lindex $args 0 ]
		
		# puts "args=$args. sw= $sw." 
		switch -- $sw {
			"-type" {
			    set type $value
			}
            "-location" {
                set fpgaloc $value
            }		
  			default {
				error [format "define_haps_fpga: unknown switch %s" $sw]
			}
		}
		set args [lrange $args 1 end]
	}


	 if {$_lib_ == "SYNPLIFY"} {
		  if {$disable == 0} {
			  if {$_AllowHapsIo_ != "TRUE"}  {
					error	 "define_haps_fpga command is supported only in ProtoCompiler; please remove this command."
			  } else {		
					#puts "Setting HAPS FPGA type=$type location=$fpgaloc"							
					set type [synplify_clean_spaces $type] ;# TODO check if prop already set so we can warn
					if {[string compare $type ""] != 0} {
						define_global_attribute $boardTypeTcl $type $args_copy
					}
					#set fpgaloc [synplify_clean_spaces $fpgaloc]
					if {[regexp {^FB([0-9]+)_([A-D]+)} $fpgaloc dummy cde_order chiploc]} {
						if {$cde_order >= 0 && $cde_order <= 8} {
								set umrbus [format "%d" [expr {(($cde_order-1)%4)*2+1}]]
								puts "@N define_haps_fpga used to specifiy HAPS FPGA location as $fpgaloc UMR Bus Id $umrbus"
								define_global_attribute $hapsFpgaLocTcl $chiploc $args_copy
								define_global_attribute $cdeOrderTcl $cde_order $args_copy
								define_global_attribute $UmrBusTcl $umrbus $args_copy
							} else {
								error "define_haps_fpga : Invalid CDE order of $cde_order specified; should be 1..8 "
							}
					} else {
							error "Illegal location $fpga specified in define_haps_fpga" 
					}
				}
		  }
	 }
}
#
# Set io standards
# args:[-disable] [-comment <comment> ] <objname>  [-iostandard <iostandard>]
# If the object is -default_input/output/bidir, then set a different sets of 
# properties for each type globally.
#
proc define_io_standard {args} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	global _lib_
	global _ScopeVer_

	set args_copy "define_io_standard $args"
	set args_copy_ui $args

	if [expr [llength $args] < 1] {
		error {define_io_standard usage: [-disable] [-comment <comment> ] <objname>  [-syn_pad_type <iostandard>] }
	}

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}

	set objname [lindex $args 0]
	set args [lrange $args 1 end]
    set scope_objname $objname


    set isglobal 1
	if {[string compare $objname "-default_input"] == 0} {
		set objname {t:}
	} elseif {[string compare $objname "-default_bidir"] == 0} {
		set objname {t:}
	} elseif {[string compare $objname "-default_output"] == 0} {
		set objname {t:}
	} else {
	    set isglobal 0
	}

	#set defaults
    # UI uses dynamic column names and tcls need to update this when we add new columns
    set iostandardTcl "syn_pad_type"
    set slewTcl "syn_io_slew"
    set driveTcl "syn_io_drive"
    set terminationTcl "syn_io_termination"
    set schmittTcl "syn_io_schmitt"
    set powerTcl "syn_io_power"
    set dciTcl "syn_io_dci"
    set dv2Tcl "syn_io_dv2"

    set iostandardTclInput "syn_pad_type_input"
    set slewTclInput "syn_io_slew_input"
    set driveTclInput "syn_io_drive_input"
    set terminationTclInput "syn_io_termination_input"
    set schmittTclInput "syn_io_schmitt_input"
    set powerTclInput "syn_io_power_input"
    set dciTclInput "syn_io_dci_input"
    set dv2TclInput "syn_io_dv2_input"

    set iostandardTclOutput "syn_pad_type_output"
    set slewTclOutput "syn_io_slew_output"
    set driveTclOutput "syn_io_drive_output"
    set terminationTclOutput "syn_io_termination_output"
    set schmittTclOutput "syn_io_schmitt_output"
    set powerTclOutput "syn_io_power_output"
    set dciTclOutput "syn_io_dci_output"
    set dv2TclOutput "syn_io_dv2_output"

    set iostandardTclBidir "syn_pad_type_bidir"
    set slewTclBidir "syn_io_slew_bidir"
    set driveTclBidir "syn_io_drive_bidir"
    set terminationTclBidir "syn_io_termination_bidir"
    set schmittTclBidir "syn_io_schmitt_bidir"
    set powerTclBidir "syn_io_power_bidir"
    set dciTclBidir "syn_io_dci_bidir"
    set dv2TclBidir "syn_io_dv2_bidir"

    set iostandard ""
    set slew ""
    set drive ""
    set termination ""
    set schmitt ""
    set power ""
    set dci ""
    set dv2 ""
    set delay_type ""

	# Options after obj name assume -<option> <value
	while { [expr [llength $args] >0] } {

		set sw [lindex $args 0]

		set args [lrange $args 1 end]
		set value [ lindex $args 0 ]
		
		# puts "args=$args. sw= $sw." 
		switch -- $sw {
			"syn_pad_type" {
				set iostandard $value
			}
            "syn_io_slew" {
                set slew $value
            }
            "syn_io_drive" {
                set drive $value
            }
            "syn_io_termination" {
                 set termination $value
            }
            "syn_io_schmitt" {
                set schmitt $value
            }
            "syn_io_power" {
                set power $value
            }
            "syn_io_dci" {
                set dci $value
            }
            "syn_io_dv2" {
                set dv2 $value
            }
            "-delay_type" {
                set delay_type $value
            }

			default {
				error [format "define_io_standard: unknown switch %s" $sw]
			}
		}
		set args [lrange $args 1 end]
	}


	 if {$_lib_ == "SYNPLIFY"} {
		  if {$disable == 0} {
				set objname [synplify_clean_spaces $objname] ;
				set iostandard [synplify_clean_spaces $iostandard]
				set iostandardTcl [synplify_clean_spaces $iostandardTcl]
				if {[string compare $iostandard ""] != 0} {
					if {$isglobal == 1} {
						if {[string compare $delay_type "input"] == 0} {
							synplify_define_attribute $objname $iostandardTclInput $iostandard $args_copy
						} elseif {[string compare $delay_type "bidir"] == 0} {
							synplify_define_attribute $objname $iostandardTclBidir $iostandard $args_copy
						} elseif {[string compare $delay_type "output"] == 0} {
							synplify_define_attribute $objname $iostandardTclOutput $iostandard $args_copy
						}
					} else {
						synplify_define_attribute $objname $iostandardTcl $iostandard $args_copy
					}
				}
				set slew [synplify_clean_spaces $slew]
				set slewTcl [synplify_clean_spaces $slewTcl]
				if {[string compare $slew ""] != 0} {
					if {$isglobal == 1} {
						if {[string compare $delay_type "input"] == 0} {
							synplify_define_attribute $objname $slewTclInput $slew $args_copy
						} elseif {[string compare $delay_type "bidir"] == 0} {
							synplify_define_attribute $objname $slewTclBidir $slew $args_copy
						} elseif {[string compare $delay_type "output"] == 0} {
							synplify_define_attribute $objname $slewTclOutput $slew $args_copy
						}
					} else {
						synplify_define_attribute $objname $slewTcl $slew $args_copy
					}
				}
				set drive [synplify_clean_spaces $drive]
				set driveTcl [synplify_clean_spaces $driveTcl]
				if {[string compare $drive ""] != 0} {
					if {$isglobal == 1} {
						if {[string compare $delay_type "input"] == 0} {
							synplify_define_attribute $objname $driveTclInput $drive $args_copy
						} elseif {[string compare $delay_type "bidir"] == 0} {
							synplify_define_attribute $objname $driveTclBidir $drive $args_copy
						} elseif {[string compare $delay_type "output"] == 0} {
							synplify_define_attribute $objname $driveTclOutput $drive $args_copy
						}
					} else {
						synplify_define_attribute $objname $driveTcl $drive $args_copy
					}
				}
				set termination [synplify_clean_spaces $termination]
				set terminationTcl [synplify_clean_spaces $terminationTcl]
				if {[string compare $termination ""] != 0} {
					if {$isglobal == 1} {
						if {[string compare $delay_type "input"] == 0} {
							synplify_define_attribute $objname $terminationTclInput $termination $args_copy
						} elseif {[string compare $delay_type "bidir"] == 0} {
							synplify_define_attribute $objname $terminationTclBidir $termination $args_copy
						} elseif {[string compare $delay_type "output"] == 0} {
							synplify_define_attribute $objname $terminationTclOutput $termination $args_copy
						}
					} else {
						synplify_define_attribute $objname $terminationTcl $termination $args_copy
					}
				}
				set schmitt [synplify_clean_spaces $schmitt]
				set schmittTcl [synplify_clean_spaces $schmittTcl]
				if {[string compare $schmitt ""] != 0} {
					if {$isglobal == 1} {
						if {[string compare $delay_type "input"] == 0} {
							synplify_define_attribute $objname $schmittTclInput $schmitt $args_copy
						} elseif {[string compare $delay_type "bidir"] == 0} {
							synplify_define_attribute $objname $schmittTclBidir $schmitt $args_copy
						} elseif {[string compare $delay_type "output"] == 0} {
							synplify_define_attribute $objname $schmittTclOutput $schmitt $args_copy
						}
					} else {
						synplify_define_attribute $objname $schmittTcl $schmitt $args_copy
					}
				}
				set power [synplify_clean_spaces $power]
				set powerTcl [synplify_clean_spaces $powerTcl]
				if {[string compare $power ""] != 0} {
					if {$isglobal == 1} {
						if {[string compare $delay_type "input"] == 0} {
							synplify_define_attribute $objname $powerTclInput $power $args_copy
						} elseif {[string compare $delay_type "bidir"] == 0} {
							synplify_define_attribute $objname $powerTclBidir $power $args_copy
						} elseif {[string compare $delay_type "output"] == 0} {
							synplify_define_attribute $objname $powerTclOutput $power $args_copy
						}
					} else {
						synplify_define_attribute $objname $powerTcl $power $args_copy
					}
				}
				set dci [synplify_clean_spaces $dci]
				set dciTcl [synplify_clean_spaces $dciTcl]
				if {[string compare $dci ""] != 0} {
					if {$isglobal == 1} {
						if {[string compare $delay_type "input"] == 0} {
							synplify_define_attribute $objname $dciTclInput $dci $args_copy
						} elseif {[string compare $delay_type "bidir"] == 0} {
							synplify_define_attribute $objname $dciTclBidir $dci $args_copy
						} elseif {[string compare $delay_type "output"] == 0} {
							synplify_define_attribute $objname $dciTclOutput $dci $args_copy
						}
					} else {
						synplify_define_attribute $objname $dciTcl $dci $args_copy
					}
				}
				set dv2 [synplify_clean_spaces $dv2]
				set dv2Tcl [synplify_clean_spaces $dv2Tcl]
				if {[string compare $dv2 ""] != 0} {
					if {$isglobal == 1} {
						if {[string compare $delay_type "input"] == 0} {
							synplify_define_attribute $objname $dv2TclInput $dv2 $args_copy
						} elseif {[string compare $delay_type "bidir"] == 0} {
							synplify_define_attribute $objname $dv2TclBidir $dv2 $args_copy
						} elseif {[string compare $delay_type "output"] == 0} {
							synplify_define_attribute $objname $dv2TclOutput $dv2 $args_copy
						}
					} else {
						synplify_define_attribute $objname $dv2Tcl $dv2 $args_copy
					}
				}
		  }
	 } elseif {$_lib_ == "SETACF"} {
		puts {oops}
     } elseif {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 201209 } {
		scope_define_io_standard $disable $comment $scope_objname $delay_type $iostandardTcl $iostandard $slewTcl $slew $driveTcl $drive $terminationTcl $termination $schmittTcl $schmitt $powerTcl $power $dciTcl $dci $dv2Tcl $dv2
		} else {
			eval [concat add_fdc_constraint define_io_standard $args_copy_ui];
		}
	 }
}

# supported compile point types
proc cp_type_is_valid {type} {
	if { $type != "locked" \
	  && $type != "hard" \
	  && $type != "soft" \
	  && $type != "black_box" \
	  && $type != "locked,physical" \
	  && $type != "physical,locked" \
	  && $type != "partition,locked" \
	  && $type != "locked,partition" } {
		return 0
	}
	return 1
}

#
# Define a module as a compile point. 
# Set a syn_compile_point and syn_hier property on the object
# args: [-disable] [-comment <comment>] <objname> [-type <type>] [-cpfile <CP SDC file>] 
#
proc define_compile_point {args} {
	global _lib_
	global _ScopeVer_
	if {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ < 201209 } {
			set disable 0
			if {[lindex $args 0] == "-disable"} {
				set disable 1
				set args [lrange $args 1 end]
			}
			set comment *
			if {[lindex $args 0] == "-comment"} {
				set comment  [lindex $args 1]
				set args [lrange $args 2 end]
			}

			set objname [lindex $args 0]
			set args [lrange $args 1 end]

			#set defaults
			set type "soft" 
			set cpfile ""

			# Options after obj name assume -<option> <value
			while { [expr [llength $args] >0] } {
				set sw [lindex $args 0]
				set args [lrange $args 1 end]
				set value [ lindex $args 0 ]
				set args [lrange $args 1 end]
				switch -- $sw {
					"-type" {
						set type $value
					}

					"-cpfile" {
						set cpfile $value
					}

					"-disable"  {
						set disable 1
					}

					default {
						error [format "define_compile_point: unknown switch %s" $sw]
					}
				}
			}
			# Callback to SCOPE
			scope_define_compile_point $disable $comment $objname $type $cpfile
		} else {
			eval [concat add_fdc_constraint define_compile_point $args];
		}
	} else {
	    addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
		define_CP $args
	}
}


proc define_CP {myargs} {
	global _lib_
	global _ScopeVer_
	global _SupportCP_
	 global _AsicMapper_
	 global _IsPro_
	global _CertifyEst_

	# for debug only
	# puts "define_CP begin!"

	set args_copy "define_compile_point $myargs"
	set args $myargs

	if [expr [llength $args] < 1] {
		error {define_compile_point usage: [-disable] [-comment <comment> ] <objname>  [-type <type>] [-cpfile <cp SDC file>] }
	}

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}

	set objname [lindex $args 0]
	set args [lrange $args 1 end]

	#set defaults
	set type "soft" 
	set cpfile ""

	# Options after obj name assume -<option> <value
	while { [expr [llength $args] >0] } {
		set sw [lindex $args 0]
		set args [lrange $args 1 end]
		set value [ lindex $args 0 ]
		set args [lrange $args 1 end]
		switch -- $sw {
			"-type" {
				set type $value
			}

			"-cpfile" {
				set cpfile $value
			}

			"-comment" {
				set comment $value
			}

			"-disable"  {
				set disable 1
			}

			default {
				error [format "define_compile_point: unknown switch %s" $sw]
			}
		}
	}

	# for debugging only
	# puts "Retrieved Type: $type Object: $objname"

	if {$_lib_ == "SYNPLIFY"} {
		if {$disable == 0} {			
			if {$_IsPro_ != "TRUE" && $_CertifyEst_ != "TRUE"} {
				warning	 "Compile Points are not supported in Synplify; ignoring define_compile_point command"
			} elseif {$_SupportCP_ == "TRUE" } {	
				if { [regexp {\*|\?} $objname]} {
					set a "BM104"
					set b "Wildcards not supported for Compile Points; ignoring define_compile_point $objname. Use a complete module name."
					# 'a' represents the id for the msg format. 'b' represents the msg format
					process_warning $a $b 					
				} else {
					define_attribute $objname syn_compile_point 1
					# remove spaces
					regsub -all " " $type "" type
					if [expr {$_AsicMapper_ == "FALSE"} && ! [ cp_type_is_valid $type ] ] {
						set a "BM103"
						set b "Compile point <$objname> has Invalid type <$type>; changed to locked"
						# 'a' represents the id for the msg format. 'b' represents the msg format
						process_warning $a $b 
						set type  "locked"
					}
					if {$type != "NONE"} {
						define_attribute $objname syn_cptype $type
					}
				}
			} else {
				set a "BM105"
				set b "Compile points not supported for this technology, ignoring define_compile_point command"
				# 'a' represents the id for the msg format. 'b' represents the msg format
				process_warning $a $b 
			}
		}
	 } elseif {$_lib_ == "SETACF"} {
		puts {oops}
	 } elseif {$_lib_ == "SETCONST"} {
		# Callback to SCOPE
		if { $_ScopeVer_ < 201209 } {
		scope_define_compile_point $disable $comment $objname $type $cpfile
		} else {
			eval [concat add_fdc_constraint $args_copy];
		}
	 } elseif {$_lib_ == "PROJCPLIST"} {
		# Callback to Project compile point list dialog
		projcplist_define_compile_point $disable $comment $objname $type $cpfile
	 }
}

#
# set_io custom func
#
proc set_io {args} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
}

#
# User timing constraints
#
proc define_clock {args} {
	global _lib_
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		return
	}
	
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	 if {$_lib_ == "SYNPLIFY"} {
		# mapper does its own parsing, from constraint database
		return
	}

	define_clock_newtiming $args
}

proc set_timing_derate {args} {
     addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
}

#
# Procedure for defining waveform order for waveform viewer.
#
# Definition strorder = {{0:clk1}{1:input1}{0:clk3}}
# define_waveform_order <strorder> 
#

proc define_waveform_order { clocks} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    
	global _lib_

   if {$_lib_ == "SETCONST"} {
		scope_waveform_order $clocks
	}
}

proc warning {arg} {
	log_puts "$arg"
}

proc fpga_warning {args} {
	set_converted_asci2fpga
	warning $args
}

proc define_new_clock {args} {
	define_clock_newtiming $args
}

proc synplify_expand_collection {args} {
	#
	# if our input argument looks like '$name' and variable 'name' 
	# contains a collection, then return the collection as
	# a list of strings. If not, just return the input argument
	#

	if { [llength args] != 1 } {
		return $args
	}

	set name [lindex $args 0]

	if { ! [regexp {^[$]} $name] } {
		return $args
	}

	set vname [string trimleft $name {$}]

	if { ! [info exists vname] } {
		return $args
	}

	global $vname

	if { ! [regexp {^s:[0-9][0-9]*} [expr $name] ] } {
		# does not look like the handle of a collection
		return $args
	}

	return [c_list [expr $name] ]

}

proc define_clock_newtiming {myargs} {
	 global _lib_
	 global _ScopeVer_
	 global _DefaultDomain_
	 global _DefaultDomainId_
	 global _RefClkId_
	 global _AsicMapper_
	 global _ClkDomainId_

	set args $myargs
	set args_copy "define_clock $args"
	set freq_defined 0
	incr _ClkDomainId_
	set _DefaultDomain_ default_clkgroup$_ClkDomainId_

	 if [expr [llength $args] < 2] {
		if { $_AsicMapper_ == "TRUE" } {
		  	error {define_clock usage: [-disable] [-comment <comment> ] -name <object> [-period <period>] [-clockgroup domain] [-uncertainty uncertainty] [-rise rise] [-fall fall] [-ref_rise ref_rise] [-ref_fall ref_fall] }
		} else {
		  	error {define_clock usage: [-disable] [-comment <comment> ] <object> [-freq <freq>]|[-period <period>] [-clockgroup domain] [-rise rise] [-fall fall] [-improve improve] [-route route]}
		}
	 }
	 # Defaults
	set disable 0
	set clocksw "-period"
	set domain $_DefaultDomain_  
	set domain_set *  
	set period *
    set scope_period *
    set scope_freq *
	set uncertainty *
	set rise *
	set fall *
	set ref_rise *
	set ref_fall *
	set improve *
	set route *
	set objname ""
	set refclkname ""
	set namelist [list]
	set arglist [list]
	set dutyvalue ""
	set dutypct *
	set virtual *
	set dutysw "-duty_ns"
	set comment *

	 while { [expr [llength $args] >0] } {
		  set sw [lindex $args 0]
		  set args [lrange $args 1 end]
		if { [string range $sw 0 0] != {-} } {
			set arglist [concat $arglist $sw]
			set objname $sw
			if { $refclkname == "" } {
				set refclkname $sw
			}
		} elseif { $sw == "-virtual" } {
			set virtual "-virtual"
		} elseif { $sw == "-disable" } {
			set disable 1
		} else {  ;# other arguments also take in a value arg
			  set value [ lindex $args 0 ]
			  set args [lrange $args 1 end]
			  switch -- $sw {
			  "-comment" {
					set comment $value
			  }
			  "-name" {
					set namelist [concat $namelist $value]
					set refclkname $value
					if { $objname == "" } {
						set objname $value
					}
			  }
			  "-period" {
					set clocksw $sw
					set period $value
                    set scope_period $value
					if { $period > 1000 } {
		  				if {$disable == 0} {
							set a "BM101"
							set b "Clock $objname too slow at $period ns, resetting it to 1000ns(1Mhz)"
							# 'a' represents the id for the msg format. 'b' represents the msg format
							process_warning $a $b
						}
						set period 1000
					}
			  }
			  "-freq" {
					set freq_defined 1
					set clocksw $sw
					set freq $value
                    set scope_freq $value
				if { [expr $freq> 0] } {
					if { $freq < 1 } {
		  				if {$disable == 0} {
		  					set a "BM100"
							set b  "Clock $objname too slow at $freq Mhz, resetting it to 1MHz(1000ns)"
		  					# 'a' represents the id for the msg format. 'b' represents the msg format
							process_warning $a $b
						}
						set freq 1
					}
					set clocksw "-period"
					set period [expr 1000.0 / $freq]
				} else {
		  			if {$disable == 0} {
		  				set a "BM102"
						set b "Invalid frequency of $freq specified for clock $objname  resetting it to 1Mhz(1000ns)"
		  				# 'a' represents the id for the msg format. 'b' represents the msg format
						process_warning $a $b
					}
					set period 1000
				}
			  }
			  "-clockgroup" {
					set domain $value
					set domain_set "true"
			  }
			  "-domain" {
					set domain $value
					set domain_set "true"
			  }
	      		"-virtual" {
					set virtual "-virtual"
			  }
			  "-uncertainty" {
				if { $_AsicMapper_ == "TRUE" } {
		  			 set uncertainty $value
				} else {
					fpga_warning "-uncertainty argument in define_clock is not supported in FPGA Mappers"
		  			 set uncertainty 0
				}
			  }
			  "-rise" {
					set rise $value
			  }
			  "-fall" {
					set fall $value
			  }
			  "-ref_rise" {
					if { $_AsicMapper_ == "TRUE" } {
			  			 set ref_rise $value
					} else {
						fpga_warning "-ref_rise argument in define_clock is not supported in FPGA Mappers"
					}
			  }
			  "-ref_fall" {
					if { $_AsicMapper_ == "TRUE" } {
			 			  set ref_fall $value
					} else {
						fpga_warning "-ref_fall argument in define_clock is not supported in FPGA Mappers"
					}
			  }
			  "-duty_pct" {
					set dutyvalue $value
					set dutypct 1
					set dutysw $sw
					set_converted_old2newta
			  }
			  "-duty_ns" {
					set dutyvalue $value
					set dutypct 0
					set dutysw $sw
					set_converted_old2newta
			  }
			  "-improve" {
				if { $_AsicMapper_ == "TRUE" } {
					warning "-improve argument in define_clock is not supported in the Asic Mapper"
				} else {
						set improve $value
				}
			  }
			  "-route" {
				if { $_AsicMapper_ == "TRUE" } {
					warning "-route argument in define_clock is not supported in the Asic Mapper"
				} else {
						set route $value
				}
			  }
			  default {
					error [format "define_clock: unknown switch %s" $sw]
			  }
			} ;# switch
		} ;# else
	 }; #while

	if { $domain ==  $_DefaultDomain_ } {
		if { $domain_set == "*" } {
			append domain "__$_DefaultDomainId_"
			incr _DefaultDomainId_
		}
	}
	if { $period == "*" } {
		set period 1000.0
	}
	if { $dutypct == 1 } {
		set rise 0.0
		set fall [expr $period * $dutyvalue / 100.0]
	} elseif { $dutypct == 0 } {
		set rise 0.0
		set fall $dutyvalue
	}

	 if {$_lib_ == "SYNPLIFY"} {
		# should not happen
	 } elseif {$_lib_ == "SETACF"} {
		  if {$disable == 0} {
				global acf
				acf_set_period $acf $objname $period
		  }
	 } elseif {$_lib_ == "SETCONST"} {
		if { $_AsicMapper_ == "TRUE" } {
		  	add_new_clock_constraint $disable $comment $virtual $objname $clocksw $scope_period $domain $uncertainty $rise $fall $ref_rise $ref_fall
		} else {
			if { $freq_defined == 1 } {
				add_70_clock_constraint $disable $comment $objname $refclkname "-freq" $scope_freq $domain $rise $fall $improve $route $virtual
			} else {
				add_70_clock_constraint $disable $comment $objname $refclkname $clocksw $scope_period $domain $rise $fall $improve $route $virtual
			}
		}
	 }
}

#
# Procedure for defining reference clocks.
#
# Definition
# define_reference_clock [-disable] [-comment <comment>] -name <name> [-rise <rise>]
#						 [-fall <fall>] -period <period> | -freq <freq> [-domain domain]
#
# name and period/frequency are mandatory requirements.
#

proc define_reference_clock {args} {
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	}
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	global _lib_
	global _RefClkId_
	if [expr [llength $args] < 6] {
		error {define_reference_clock [-disable] [-comment <comment>] -name <name> -period <period> | -freq <freq> [-rise <rise>] [-fall <fall>] [-uncertainty uncertainty] [-domain domain]}
	}

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment	 [lindex $args 1]
		set args [lrange $args 2 end]
	}

	# Defaults
	set clocksw "-period"
	set clockvalue 0.0
	set period 1000.0
	set rise 0.0
	set fall -1.0
	set uncertainty 0.0
	set objname ""

	while { [expr [llength $args] >0] } {
	        set sw [lindex $args 0]
	        set args [lrange $args 1 end]
	        set value [ lindex $args 0 ]
	        set args [lrange $args 1 end]
	        switch -- $sw {
	        "-period" {
	                set clockvalue $value
	                set clocksw $sw
	                set period $value
	        }
	        "-freq" {
	                set clockvalue $value
	                set clocksw $sw
	                set freq $value
	                if { [expr $freq> 0] } {
	                set period [expr 1000.0 / $freq]
	                }
	        }
	        "-rise" {
	                set rise $value
	        }
	        "-fall" {
	                set fall $value
	        }
	        "-uncertainty" {
	                set uncertainty $value
	        }
	        "-name" {
	                set objname $value
	        }
	        "-domain" {
	                set domain $value
	        }
	        default {
	                error [format "define_reference_clock: unknown switch %s" $sw]
	                }
	        }
	}

	# if fall is -1.0, then fall is uninitialized.
	if { $fall == -1.0 } {
		set fall [expr $period / 2.0]
	}

	if {$_lib_ == "SYNPLIFY"} {
		if {$disable == 0} {
			synplify_define_attribute {t:} syn_reference_clock$_RefClkId_ "$refclkname,r=$ref_rise,f=$ref_fall,u=$uncertainty,p=$period,clockgroup=$domain,rd=0.000,fd=0.000,v=1" $args_copy
			incr _RefClkId_
		}
	} elseif {$_lib_ == "SETCONST"} {
            add_ref_clock_constraint $disable $comment $objname $clocksw $clockvalue $rise $fall $uncertainty $domain
	}
}

proc define_clock_delay_usage {args} {
	 error {define_clock_delay usage: [-rise|-fall] <clock1> [-rise|-fall] <clock2> <delay>}
}

#
# Define delay between clocks edges.
#
proc define_clock_delay {args} {
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	}
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	global _lib_
	global _ScopeVer_
	global _ClockDelayId

	if [expr [llength $args] < 3] {
		define_clock_delay_usage
	}

	set args_copy "define_clock_delay $args"

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}

	 set a [lindex $args 0]
	 set args [lrange $args 1 end]

	 if {$a == "-rise"} {
		  set clock1dir ""
	 } elseif {$a == "-fall"} {
		  set clock1dir "!"
	 } else {
		  define_clock_delay_usage
	 }
	 set e1 $a
	 set clock1 [lindex $args 0]
	 set args [lrange $args 1 end]
	 set a [lindex $args 0]
	 set args [lrange $args 1 end]
	 if {$a == "-rise"} {
		  set clock2dir ""
	 } elseif {$a == "-fall"} {
		  set clock2dir "!"
	 } else {
		  define_clock_delay_usage
	 }
	 set e2 $a
	 set clock2 [lindex $args 0]
	 set args [lrange $args 1 end]
	 set delay [lindex $args 0]
	 set args [lrange $args 1 end]
	 if {$_lib_ == "SYNPLIFY"} {
		  if {$disable == 0} {
				set clock1 [synplify_clean_spaces $clock1]
				set clock2 [synplify_clean_spaces $clock2]
				if {$delay == "-false"} {
					 set delay false
				}
	 			if { [string range $clock1 1 1] == {:} } { ;# drop any n:/ b: etc
					set clock1 [string range $clock1 2 end]
				}
	 			if { [string range $clock2 1 1] == {:} } {
					set clock2 [string range $clock2 2 end]
				}

				set clock1 "$clock1dir$clock1"
				set clock2 "$clock2dir$clock2"
				#synplify_define_edge_edge_delay $clock1 $clock2 $delay $args_copy
			    synplify_define_attribute {t:} define_clock_delay$_ClockDelayId "fclk=$clock1,tclk=$clock2,delay=$delay"
				incr _ClockDelayId
		  }
	 } elseif {$_lib_ == "SETCONST"} {
		  if { $_ScopeVer_ < 510 } {
				error {define_clock_delay not supported by SCOPE}
		 } elseif {$_ScopeVer_ < 520} {
				add_clock_delay_constraint $disable $e1 $clock1 $e2 $clock2 $delay
		  } else {
				add_clock_delay_constraint $disable $comment $e1 $clock1 $e2 $clock2 $delay
		  }
	 }
}

#
# Helper functions for defining delay constraints
#
proc define_delay_prop_error {propbase} {
	error "define_${propbase}_delay: <portname> <delay> -improve <delay> -route <delay>"
}

proc define_delay_prop {propbase alist} {
	 global _lib_ g_clk
	 set clock ""
	 global _ScopeVer_
	set args_copy "define_${propbase}_delay $alist"
	 
	# Flag as unspecified rather than 0
	set improve *
	set route *
	set delay *
	set ref *
	set comment *
	set disable 0
	set foundobj 0
	set objname *

	set len [llength $alist]

	 while 1 {
		  if [expr $len <= 0] { break }
		  set sw [lindex $alist 0]
		  set alist [lrange $alist 1 end]
		  set len [expr $len - 1]
		  if {$sw == "-default"} {
				set objname "t:"
				set foundobj 1
		  }	elseif {$sw == "-disable"} {
				set disable 1
		  } elseif [string match {-[a-z]*} $sw] {
				set value [lindex $alist 0]
				set alist [lrange $alist 1 end]
				set len [expr $len - 1]
				switch -- $sw {
				"-ref" {
					set ref $value
				}
				"-improve" {
					 set prop "syn_${propbase}_delay_improve"
					 set improve $value
				  }
				"-route" {
					 set prop "syn_${propbase}_delay_route"
					 set route $value
				  }
				"-clock" {
					 set prop "syn_${propbase}_clock"
					 set clock $value
				  }
				"-comment" {
					 set comment $value
				  }
				default {
					 #puts "unknown switch $sw"
					 define_delay_prop_error $propbase
				  }
				}
		  } else {
			if {$foundobj==0} { ;# first non - argument is obj name, second is value
				set objname $sw
				set prop "syn_${propbase}_delay"
				set value 0
				set foundobj 1
			} else {
				set prop "syn_${propbase}_delay"
				set value $sw
				set delay $value
			}
		  }
	 } ; # end of while

	 if {$objname == "*"} {
	 	error " No ObjectName found in define_${propbase}_delay $alist"
	 } elseif {$_lib_ == "SYNPLIFY"} {
           if {$disable == 0} {
             set objname [synplify_clean_spaces $objname]
             synplify_define_attribute $objname $prop $value $args_copy
             #puts "synplify_define_attribute <$objname> <$prop> <$value>"
           }
	 } elseif {$_lib_ == "SETACF"} {
		  if { $disable == 0 } {
				global acf
				switch -exact -- $propbase {
					 input {
						  if {[string compare $clock ""] == 0} {
						  acf_set_tsu $acf $g_clk $objname $delay
						  } else {
						  acf_set_tsu $acf $clock $objname $delay
					 }
							}

					 output {
							if {[string compare $clock ""] == 0} {
							acf_set_tco $acf $g_clk $objname $delay
							} else {
						  acf_set_tco $acf $clock $objname $delay
						  }
					 }
				}
		  }
	 } elseif {$_lib_ == "SETCONST"} {
		  set prop "syn_${propbase}_clock"
			if { $ref == "*" } {
				set ref ""
			}
			if { $_ScopeVer_ < 201209 } {
				add_delay_constraint $disable $comment "${propbase}" $objname $delay $improve $route $clock $ref
			} else {
				eval [concat add_fdc_constraint $args_copy];
			}
	 }
}

proc define_io_delay_newtiming {type myargs} {
	global _lib_
	global g_clk
	global _AsicMapper_
	global _iodelayid_
#
# New format
# define_input_new_delay | define_output_new_delay {obj} <-rise rise> <-fall fall> <-rslope rslope> <-fslope fslope> <-ref refclk:r|f>
#
 	set args $myargs
	set args_copy "define_$type\_delay $args"

	set len [llength $args]
 	set typeStr [format "syn_%s_delay$_iodelayid_" $type]
	incr _iodelayid_

	if [expr [llength $args] < 1] {
		if { $_AsicMapper_ == "TRUE" } {
			if { $type == "input" } {
				error  {define_input_delay usage: {obj} <-rise rise> <-fall fall> <-rslope rslope> <-fslope fslope> <-ref refclk:r|f>}
			} else {
				error  {define_output_delay usage: {obj} <-rise rise> <-fall fall> <-rslope rslope> <-fslope fslope> <-ref refclk:r|f>}
			}
		} else {
			if { $type == "input" } {
				error {define_input_delay usage: {obj}  <-ref refclk:r|f> <-improve improve> <-route route> value}
			} else {
				error {define_output_delay usage: {obj}  <-ref refclk:r|f> <-improve improve> <-route route> value}
			}
		}
	}

	set disable 0
	set comment *
	set improve 0
	set route 0
	if {$_lib_ == "SETACF"} {
	    set clock ""
	} else {
	    set clock *
	}

	# Defaults
	set rise *
	set fall *
	set min_rise *
	set min_fall *
	set rslope *
	set fslope *
	set min_rslope *
	set min_fslope *
	set ref *
	set delay * 
	set foundobj 0


	while { [expr [llength $args] >0] } {
		set sw [lindex $args 0]
		set args [lrange $args 1 end]
		if [string match {-[a-z]*} $sw] {
			if { $sw == "-disable" } {
				set disable 1
			} elseif { $sw == "-default" } {
				set objname $sw
				set foundobj 1
			} else  { ;# all other - options take a value as well
				set value [ lindex $args 0 ]
				set args [lrange $args 1 end]
				switch -- $sw {
				"-rise" {
					if { $_AsicMapper_ == "TRUE" } {
						set rise $value
					} else {
						fpga_warning "-rise argument in ${typeStr} not supported in FPGA Mappers"
					}
				}
				"-fall" {
					if { $_AsicMapper_ == "TRUE" } {
						set fall $value
					} else {
						fpga_warning "-fall argument in ${typeStr} not supported in FPGA Mappers"
					}
				}
				"-min_rise" {
					if { $_AsicMapper_ == "TRUE" } {
						set min_rise $value
					} else {
						fpga_warning "-min_rise argument in ${typeStr} not supported in FPGA Mappers"
					}
				}
				"-min_fall" {
					if { $_AsicMapper_ == "TRUE" } {
						set min_fall $value
					} else {
						fpga_warning "-min_fall argument in ${typeStr} not supported in FPGA Mappers"
					}
				}
				"-rslope" {
					if { $_AsicMapper_ == "TRUE" } {
						set rslope $value
					} else {
						fpga_warning "-rslope argument in ${typeStr} not supported in FPGA Mappers"
					}
				}
				"-fslope" {
					if { $_AsicMapper_ == "TRUE" } {
						set fslope $value
					} else {
						fpga_warning "-fslope argument in ${typeStr} not supported in FPGA Mappers"
					}
				}
				"-min_rslope" {
					if { $_AsicMapper_ == "TRUE" } {
						set min_rslope $value
					} else {
						fpga_warning "-min_rslope argument in ${typeStr} not supported in FPGA Mappers"
					}
				}
				"-min_fslope" {
					if { $_AsicMapper_ == "TRUE" } {
						set min_fslope $value
					} else {
						fpga_warning "-min_fslope argument in ${typeStr} not supported in FPGA Mappers"
					}
				}
				"-ref" {
					set ref $value
				}
				"-improve" {
					if { $_AsicMapper_ == "TRUE" } {
						warning "-improve argument in ${typeStr} not supported in the Asic Mapper"
					} else {
						set improve $value
					}
				}
				"-route" {
					if { $_AsicMapper_ == "TRUE" } {
						warning "-route argument in ${typeStr} not supported in the Asic Mapper"
					} else {
						set route $value
					}
				}
				"-clock" {
					if { $_AsicMapper_ == "TRUE" } {
						warning "-clock argument in ${typeStr} not supported in the Asic Mapper"
					} else {
						set clock $value
					}
				}
				"-comment" {
					set comment $value
				}
				default {
					error [format "$type: unknown switch %s" $sw]
				}
				} ;# end of switch
			} ;# end of args with value
		} else {
			if {$foundobj==0} { ;# first non - argument is obj name, second is value
				set objname $sw
				set foundobj 1
			} else {
				set rise $sw
				set fall $sw
				set delay $sw
			}
		}
	}

	if {$_lib_ == "SYNPLIFY"} {
		if {$disable == 0} {
			if { $rise == "*" } {
				set rise 0.0
			}
			if { $fall == "*" } {
				set fall 0.0
			}
			if { $rslope == "*" } {
				set rslope 0.0
			}
			if { $fslope == "*" } {
				set fslope 0.0
			}
			if [string match "-default" $objname] {
				set objname {t:}
			}

			# remove any object type qualifier
			# check for two colons
			# otherwise clk with single letter name will have wrong ref
			# bug 116280 "ref = g:r"
            if { [regexp {^[abpivtncs]:.*:} $ref] } {
                set ref [string range $ref 2 end]
            }

			set ref [synplify_clean_spaces $ref]
			set objname [synplify_clean_spaces $objname]
			synplify_define_attribute \{$objname\} $typeStr "r=$rise,f=$fall,rs=$rslope,fs=$fslope,improve=$improve,route=$route,ref=$ref" $args_copy
			if { $_AsicMapper_ == "TRUE" } {
				set min_atrb "FALSE"
				if { $min_rise == "*" } {
					set min_rise 0.0
				} else {
 					set typeStr [format "syn_%s_delay_min" $type]
					set min_atrb "TRUE"
				}
				if { $min_fall == "*" } {
					set min_fall 0.0
				} else {
 					set typeStr [format "syn_%s_delay_min" $type]
					set min_atrb "TRUE"
				}
				if { $min_atrb == "TRUE" } {
					if { $min_rslope == "*" } {
						set min_rslope 0.0
					}
					if { $min_fslope == "*" } {
						set min_fslope 0.0
					}
					synplify_define_attribute \{$objname\} $typeStr "r=$min_rise,f=$min_fall,rs=$min_rslope,fs=$min_fslope,improve=$improve,route=$route,ref=$ref" $args_copy
				}
				if { $clock != "*" } {
					set prop "syn_${type}_delay_clock"
					synplify_define_attribute \{$objname\} $prop $clock
				}
			}
		}
	} elseif {$_lib_ == "SETACF"} {
		if { $disable == 0 } {
			global acf
			switch -exact -- $type {
				input {
					if { [string compare $clock ""] == 0 } {
						acf_set_tsu $acf $g_clk $objname $rise
					} else {
						acf_set_tsu $acf $clock $objname $rise
					}
				}

				output {
					if { [string compare $clock ""] == 0 } {
						acf_set_tco $acf $g_clk $objname $delay
					} else {
						acf_set_tco $acf $clock $objname $delay
					}
				}
			}
		}
	} elseif {$_lib_ == "SETCONST"} {
		if { $objname == "-default" } {
			if { $type == "input" } {
				set objname "<input default>"
			} else {
				set objname "<output default>"
			}
		}
		if { $_AsicMapper_ == "TRUE" } {
			add_new_delay_constraint $disable $comment "${type}" $objname $rise $fall $rslope $fslope $ref
		} else {
			if { $ref == "*" } {
				set ref ""
			}
			  add_delay_constraint $disable $comment "${type}" $objname $delay $improve $route $clock $ref
		}
	}
}


#
# The delay constraint commands
# Args: [-disable] <object> [ [ , -improve, -route] <delay>, -clock <clockname>]*
#
proc define_input_delay {args} {
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	}
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	define_io_delay_newtiming input $args
}

proc define_output_delay {args} {
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	}
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	define_io_delay_newtiming output $args
}

#
# define_input_delay | define_output_delay {obj} <-rise rise> <-fall fall> <-rslope rslope> <-fslope fslope> <-ref refclk:r|f>
#
proc define_input_new_delay {args} {
	define_io_delay_newtiming input $args
}

proc define_output_new_delay {args} {
	define_io_delay_newtiming output $args
}

proc set_reg_input_delay {args} {
	global _CertifyEst_
    global _lib_
	global _ScopeVer_

	if { $_CertifyEst_ == "TRUE"} {
		 return
    }
    if {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ >= 201209 } {
			eval [concat add_fdc_constraint set_reg_input_delay $args];
		} else {
			addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
			define_delay_prop reg_input $args
		}
    } else {
        addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
		define_delay_prop reg_input $args
	}
}

proc set_reg_output_delay {args} {
	global _CertifyEst_
    global _lib_
	global _ScopeVer_

	if { $_CertifyEst_ == "TRUE"} {
		 return
    }
    if {$_lib_ == "SETCONST"} {
		if { $_ScopeVer_ >= 201209 } {
			eval [concat add_fdc_constraint set_reg_output_delay $args];
		} else {
			addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
			define_delay_prop reg_output $args
		}
    } else {
        addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
		define_delay_prop reg_output $args
	}
}

proc define_reg_input_delay {args} {
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	 }
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	define_delay_prop reg_input $args
}

proc define_reg_output_delay {args} {
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	 }
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	 define_delay_prop reg_output $args
}

# define multi cycle constraint id
set syn_mid 1000


proc define_multicycle_path {args} {
	global _lib_
	global _CertifyEst_

	if { $_CertifyEst_ == "TRUE"} {
		 return
	}

	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	# for scope; the mapper doesn't need to make this call
	if {$_lib_ == "SETCONST"} {
		define_multicycle_path_newtiming $args
	}
}


# define false/multicycle path constraint id
set cdb_id 1000

proc reset_globals { } {
	global syn_mid
	global _RefClkId_ 
	global _ClkDomainId_ 
	global cdb_id

	set cdb_id 1000
	set _RefClkId_ 1
	set _iodelayid_ 1
	set _ClkDomainId_ 0
}

proc define_new_multicycle_path {args} {
	define_multicycle_path_newtiming $args
}

#proc set_multicycle_path {args} {
#	define_multicycle_path_newtiming $args
#}

proc define_multicycle_path_newtiming {myargs} {
	set args $myargs
	set args_copy "define_multicycle_path $args"

    #log_puts ">>>Initial args: $args"

	 if [expr [llength $args] < 3] {
		error "define_multicycle_path usage: [-disable] [-comment <comment>] [-from <start>] [-through <through> [-through <through> ... ] ] [-to <end>] [-start | -end]" cycles
	 }
	 global _lib_
	 global _ScopeVer_
	global cdb_id
     global _AsicMapper_

	 set relclk ""
	 set foundstart 0
	 set foundend 0
	 set foundfrom 0
	 set foundto 0
	 set foundthrough 0
	set firstthrough 0
	if {[info exists cycles]} { 
		unset cycles 
	}
	set from *
	set to *
	set through *
	set pos 0
	 set disable 0
	 if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
        #log_puts ">>>Here new args: $args "
	 }
	 set comment *
	 if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
        #log_puts ">>>Here new args: $args "
	 }

	 while { [expr [llength $args] >0] } {
		  set sw [lindex $args 0]
		  set args [lrange $args 1 end]
        #log_puts ">>>Switch: $sw "
        #log_puts ">>>new args: $args "
	 	if {$sw == "-start" || $sw == "-end"} {
			#no value for this option
		} elseif { ! [string is double -strict $sw] && [regexp {^[-]} $sw] } {
            if { [expr [llength $args] > 0] } {
		  	set value [ lindex $args 0 ]
                #log_puts ">>>NoStart and NoEnd argument to option: $value "
				if {([expr [llength $value] == 1]) && !([regexp {\{} $value]) && ([regexp {\\} $value])} {
					set value "\{$value\}"
				}
        	if { [string range $value 0 0] == {-} } {
					error "define_multicycle_path: Illegal use of -from, -to, -through"
            }

		  	set args [lrange $args 1 end]
				#log_puts ">>>new args reset: $args "
			} else {
				error "define_multicycle_path: Missing argument to option $sw"
			}
		}
		  switch -- $sw {
	 		"-start" {
				set foundstart 1
				set relclk " -start"
			}
	 		"-end" {
				set foundend 1
				set relclk " -end"
	 		}
	 		"-from" {
		  		if {$value != "*" } { ;# ignore just a * 
					set foundfrom 1
		  			set from $value
				}
	 		}
	 		"-through" {
				if $foundthrough {
					set pos 1
					set through "$through through $value"
				} else {
			  		set foundthrough 1
			  		set through $value
				}
			}
	 		"-to" {
		  		if {$value != "*" } {  ;#ignore just a * 
			  		set foundto 1
			  		set to $value
				}
	 		}
			"-pos" {
				if !$foundthrough {
					error "unsupported format for multicycle path POS"
				}
				set pos 1
				set through "$through through $value"
			}
			default {
				if [string match {-[a-z]*} $sw] {
					error "define_multicycle_path: Unknown switch $sw"
				}
				set cycles $sw
			}
		}
	}
	if {$foundstart && $foundend} {
		error "define_multicycle_path: Illegal use of both -start, -end"
	}

		if {$_lib_ == "SETCONST"} {
	 		if {$foundfrom == 0} {		
                set from ""
            }
            if {$foundto == 0} {
                set to ""
            }
            if {$foundthrough == 0} {
                set through ""
            }
            if {$relclk == "" || $relclk == " -start" || $relclk == " -end"} {
                
                if {$relclk == " -start"} {
                    set relclk "Start"
                }
                if {$relclk == " -end"} {
                    set relclk "End"
                }
            } else {
                #open as text mode for unknown options
                error "define_multicycle_path: Unknown option $relclk"
            }
			add_new_multi_constraint $disable $comment $from $through 0 $pos $to $relclk $cycles
	 	}
}

proc define_new_false_path {args} {
	define_false_path_newtiming $args
}

#proc set_false_path {args} {
#	define_false_path_newtiming $args
#}

proc define_false_path_newtiming {myargs} {
	set args $myargs
	set args_copy "define_false_path $args"

	if [expr [llength $args] < 2] {
		error "define_false_path usage: [-disable] [-comment <comment>] [-from <start>] [-through <through> [-through <through> ... ] ] [-to <end>]"
	}
	 global _lib_
	 global _ScopeVer_
	 global cdb_id
     global _AsicMapper_
	 set foundfrom 0
	 set foundto 0
	 set foundthrough 0
	 set firstthrough 0
# false path is also treated as a multicycle path of 1000 cycles
	 set cycles 1000
	 set pos 0
	 set disable 0
	 if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	 }
	 set comment *
	 if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	 }
	set from *
	set to *
	set through *

	 while { [expr [llength $args] >0] } {
		  set sw [lindex $args 0]
		  set args [lrange $args 1 end]
		  set value [lindex $args 0]
		  if {([expr [llength $value] == 1]) && !([regexp {\{} $value]) && ([regexp {\\} $value])} {
			set value "\{$value\}"
		  }

          if { [string range $value 0 0] == {-} } {

		    error "define_false_path: Illegal use of -from, -to, -through"
          }

		  set args [lrange $args 1 end]

		  switch -- $sw {
	 		"-from" {
		  		if {$value != "*" } {  ;#ignore just a * 
		  			set foundfrom 1
		  			set from $value
				}
	 		}
	 		"-through" {
				if $foundthrough {
					set pos 1
					set through "$through through $value"
				} else {
			  		set foundthrough 1
			  		set through $value
				}
			}
	 		"-to" {
		  		if {$value != "*" } {  ;#ignore just a * 
		  			set foundto 1
		  			set to $value
				}
	 		}
			"-pos" {
				if !$foundthrough {
					error "unsupported format for false path POS"
				}
				set pos 1
				set through "$through through $value"
			}
			default {
				if [string match {-[a-z]*} $sw] {
					error "define_false_path: Unknown switch $sw"
				}
			}
		}
	}

	 if {[expr $foundfrom || $foundthrough || $foundto] == 0} {
	 	error "define_false_path: Illegal use of no -from, -to, -through"
	 } else {
	 	if {$_lib_ == "SYNPLIFY"} {
		  	if { $disable == 0 } {
				set prop "syn_false_path$cdb_id"
		  		if $foundfrom {
					set l $from
					while {[expr [llength $l] > 0]} {
						if {[lindex $l 0] != ""} {
							# synplify_define_attribute [lindex $l 0] ".falsef$syn_fmid" $prop $args_copy
						}
						set l [lrange $l 1 end]
					}
		  		} else {
					set from ""
		  		}
				if $foundthrough {
					set throughprop ".falsenordth"
					if $pos {
						set posindex 0
					}				
					set l [ synplify_expand_list $through]
					set through [lindex $l 0]
					while {[expr [llength $l] > 0]} {
						if {[lindex $l 0] == ""} {
							set l [lrange $l 1 end]
							continue
						}
						if {$firstthrough == 0} {
							set through [lindex $l 0]
							set firstthrough 1
						}
						if $pos {
							# synplify_define_attribute [lindex $l 0] "$throughprop$syn_fmid...$posindex" $prop $args_copy
							if {[lindex $l 1] == "through"} {
								incr posindex
								set through "$through through [lindex $l 2]"
								set l [lrange $l 2 end]
							} else {
							set through "$through [lindex $l 1]"
							set l [lrange $l 1 end]
							}
						} else {
							# synplify_define_attribute [lindex $l 0] $throughprop$syn_fmid $prop $args_copy
							set through "$through [lindex $l 1]"
							set l [lrange $l 1 end]
						}
					}
		  		} else {
					set through ""
				}
				if $foundto {
					set l $to
					while {[expr [llength $l] > 0]} {
						if {[lindex $l 0] != ""} {
							# synplify_define_attribute [lindex $l 0] ".falset$syn_fmid" $prop $args_copy
						}
						set l [lrange $l 1 end]
					}
		  		} else {
					set to ""
		  		}
				
				# place real data as global attribute
				# synplify_define_attribute {g:} $prop "# from $from through $through to $to" $args_copy
	 		 }
		  } elseif {$_lib_ == "SETCONST"} {
            if {$foundfrom == 0} {
                set from ""
            }
            if {$foundto == 0} {
                set to ""
            }
            if {$foundthrough == 0} {
                set through ""
            }
            #add_new_false_constraint $disable $comment $from $through $to
            add_new_false_constraint $disable $comment $from $through 0 $pos $to
	 	}
	 }
}

proc define_false_path {args} {
	global _lib_
	global _CertifyEst_

	if { $_CertifyEst_ == "TRUE"} {
		 return
	}
	
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]

	# for scope; the mapper doesn't need to make this call
	if {$_lib_ == "SETCONST"} {
		define_false_path_newtiming $args
	}
}


# Implementation for floorplanning region to region constraint
proc define_region_delay { args } {
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	}	
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	global _lib_
	set cmd define_region_delay
	set alist $args
	set disable 0
	if {[lindex $alist 0] == "-disable"} {
		set disable 1
		set alist [lrange $alist 1 end]
	}
	set comment *
	if {[lindex $alist 0] == "-comment"} {
		set comment  [lindex $alist 1]
		set alist [lrange $alist 2 end]
	}
	 if [expr [llength $alist] < 3] {
		  error [format "%s: wrong number of arguments" $cmd]
	 }
	set r1 [lindex $alist 0]
	set r2 [lindex $alist 1]
	set delay [lindex $alist 2]
	 if {$_lib_ == "SYNPLIFY"} {
		  if {$disable == 0} {
			synplify_define_region_region_delay $r1 $r2 $delay
		  }
	 } elseif {$_lib_ == "SETCONST"} {
		add_unknown_constraint $disable $comment $cmd $r1 $r2 $delay
	 }
}

# counter to make unique ids for attributes
set syn_tid 1000

proc fix_view_name {view} {
	 if { [string range $view 0 1] != {v:} } {
		  set view "v:$view"
	 }
	 return $view
}

# base implementation for tpd tco tsu timing arcs
proc _define_timing_arc { cmd base alist } {
	 global _lib_
	 global syn_tid
	 global _ScopeVer_

	set disable 0
	if {[lindex $alist 0] == "-disable"} {
		set disable 1
		set alist [lrange $alist 1 end]
	}
	set comment *
	if {[lindex $alist 0] == "-comment"} {
		set comment  [lindex $alist 1]
		set alist [lrange $alist 2 end]
	}

	 if [expr [llength $alist] < 2] {
		  error [format "%s:/ wrong number of arguments" $cmd]
	 }
	 set view [lindex $alist 0]
	 set alist [lrange $alist 1 end]
	 set view [fix_view_name $view]
	 set arcstr [lindex $alist 0]
	 if {$_lib_ == "SYNPLIFY"} {
		  if {$disable == 0} {
				synplify_define_attribute $view "$base$syn_tid" $arcstr
				incr syn_tid
		  }
	 } elseif {$_lib_ == "SETCONST"} {
		if {$_ScopeVer_ < 520} {
			  add_unknown_constraint $cmd $disable $view $arcstr
		} else {
			  add_unknown_constraint $disable $comment $cmd $view $arcstr
		}
	 }
}

# define timing arc from input pin to output pin.
proc define_tpd {args} {
	 _define_timing_arc define_tpd syn_tpd $args
}

# define setup arc from input pin to clock pin
proc define_tsu {args} {
	 _define_timing_arc define_tsu syn_tsu $args
}

#define clock to output arc
proc define_tco {args} {
	 _define_timing_arc define_tco syn_tco $args
}

# Template for adding a constraint not supported by SCOPE
# Use this as a template for enabling SCOPE to display the constraint
# "unsupported_const" in the "other" pane
# In this example, the function has 5 arguments

proc unsupported_const { args } {
	 global _ScopeVer_
	 global _lib_

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}

	 if {$_lib_ == "SYNPLIFY"} {
		# .... code to call into mapper ... #
	 } elseif {$_lib_ == "SETCONST"} {
		if {$_ScopeVer_ < 520} {
	 		add_unknown_constraint "unsupported_const" $disable [lindex $args 0] [lindex $args 1] [lindex $args 2] [lindex $args 3] [lindex $args 4]
		} else {
 			add_unknown_constraint $disable $comment "unsupported_const" [lindex $args 0] [lindex $args 1] [lindex $args 2] [lindex $args 3] [lindex $args 4]
		}
	}
}

#
# Defines net delay in Certify and Floorplanner
# define_route_delay netname rgn value
#
proc define_route_delay { args } {
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	}
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	 global _ScopeVer_
	 global _lib_

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}
	set object [lindex $args 0]
	set rgn [lindex $args 1]
	set value [lindex $args 2]

	 if {$_lib_ == "SYNPLIFY"} {
		if {$disable == 0} {
			# .... code to call into mapper ... #
			synplify_define_route_delay $object $rgn $value
		}
	 } elseif {$_lib_ == "SETCONST"} {
		add_unknown_constraint $disable $comment "define_route_delay" $object $rgn $value
	}
}

# Definition
# define_load [-disable] [-comment <comment>] [-pin_load value] [-wire_load value] port
# At least one among pin_load and wire_load should be present
#
proc define_load { args } {
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	}
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	 global _lib_

	set args_copy "define_load $args"

	if [expr [llength $args] < 1] {
		error "define_load usage: [-disable] [-comment <comment>] [-pin_load value] [-wire_load value] <port>"
	}

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}
	set objname [lindex $args 0]
	set args [lrange $args 1 end]

	# Defaults
	set wireload *
	set pinload *
	set load *
	set min_wireload *
	set min_pinload *
	set min_load *

	while { [expr [llength $args] > 0] } {
		set sw [lindex $args 0]
		set args [lrange $args 1 end]
		set value [ lindex $args 0 ]
		set args [lrange $args 1 end]
		switch -- $sw {
			"-wire_load" {
				set wireload $value
			}
			"-pin_load" {
				set pinload $value
				set load $value
			}
			"-load" {
				set pinload $value
				set load $value
			}
			"-min_wireload" {
				set min_wireload $value
			}
			"-min_pinload" {
				set min_pinload $value
				set min_load $value
			}
			"-min_load" {
				set min_pinload $value
				set min_load $value
			}
			default {
				error [format "define_load: unknown switch %s" $sw]
			}
		}
	}

	if {$_lib_ == "SYNPLIFY"} {
		if {$disable == 0} {
			#if { $wireload == "*" } {
				#set wireload 0.0
			#}
			#if { $pinload == "*" } {
				#set pinload 0.0
			#}
			set loadpropname "define_load"
			set minloadpropname "define_min_load"
			if [string match "-default" $objname] {
				set objname {t:}
				set loadpropname "define_load"
				set minloadpropname "define_min_load"
			} elseif [string match "-output_default" $objname] {
				set objname {t:}
				set loadpropname "define_load_outputs"
				set minloadpropname "define_min_load_outputs"
			} elseif [string match "-input_default" $objname] {
				set objname {t:}
				set loadpropname "define_load_inputs"
				set minloadpropname "define_min_load_inputs"
			}
			if {$pinload != "*" } {
				if { $wireload == "*" } {
					set wireload 0.0
				}
				synplify_define_attribute \{$objname\} $loadpropname "wl=$wireload,pl=$pinload" $args_copy
			}
			if { $min_pinload != "*" } {
				#set loadpropname "define_min_load"
				#if [string match "-default" $objname] {
					#set objname {t:}
					#set loadpropname "define_min_load"
				#} elseif [string match "-output_default" $objname] {
					#set objname {t:}
					#set loadpropname "define_min_load_outputs"
				#} elseif [string match "-input_default" $objname] {
					#set objname {t:}
					#set loadpropname "define_min_load_inputs"
				#}
				if { $min_wireload == "*" } {
					set min_wireload 0.0
				}
				synplify_define_attribute \{$objname\} $minloadpropname "wl=$min_wireload,pl=$min_pinload" $args_copy
			}
		}
	} elseif {$_lib_ == "SETCONST"} {
#		add_load_constraint $disable $comment \{$objname\} $wireload
		if { $objname == "-default" } {
			set objname "<output default>"
		} elseif { $objname == "-output_default" } {
			set objname "<output default>"
		} elseif { $objname == "-input_default" } {
			set objname "<input default>"
		}
		add_load_constraint $disable $comment $objname $load
	}
}

# Definition
# define_driving_cell [-disable] [-comment <comment>] port [-library value] -lib_cell cellname [-pin pinname]
# The -lib_cell must be given
#
proc define_driving_cell { args } {
	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	}
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    global _lib_
	
	set args_copy "define_driving_cell $args"

	if [expr [llength $args] < 1] {
		error "define_driving_cell usage: [-disable] [-comment <comment>] <port> [-library value] -lib_cell cellname [-pin pinname]"
	}

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
        set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
        set args [lrange $args 2 end]
	}
	set objname [lindex $args 0]
	set args [lrange $args 1 end]

	# Defaults
	set library *
	set libcell *
	set pinname *

	while { [expr [llength $args] > 0] } {
		set sw [lindex $args 0]
		set args [lrange $args 1 end]
		set value [ lindex $args 0 ]
		set args [lrange $args 1 end]
		switch -- $sw {
			"-library" {
				set library $value
			}
			"-lib_cell" {
				set libcell $value
			}
			"-pin" {
				set pinname $value
			}
			default {
				error [format "define_driving_cell: unknown switch %s" $sw]
			}
		}
	}

	if {$_lib_ == "SYNPLIFY"} {
		if {$disable == 0} {
			if { $library == "*" } {
				set library ""
			}
			if { $pinname == "*" } {
				set pinname ""
			}
			if [string match "-default" $objname] {
				set objname {t:}
			}
			if { $libcell == "*" } {
				error "define_driving_cell: -lib_cell switch is required and was not given"
			}
			synplify_define_attribute \{$objname\} syn_driving_cell "$library.$libcell.$pinname" $args_copy
		}
	} elseif {$_lib_ == "SETCONST"} {
		if { $objname == "-default" } {
			set objname "<input default>"
		}
		add_driver_constraint $disable $comment $objname "$library.$libcell.$pinname"
	}
}

# equivalent of define_path_delay -max
proc define_max_delay { args } {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
}

# equivalent of define_path_delay -min
proc define_min_delay { args } {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
}


# Definition
# define_path_delay [-disable] [-comment <comment>] [-from from_inst] [-through thro_inst] [-to to_inst] -max max_dly -min min_dly
# through is not a documented option and cant be handled in the timing engine. Through handling is a place holder for future.
# Similar scheme as multi/false path handling. Set a global attribute on the top level which has details and set an id on objects.

proc define_path_delay { args } {
	global _lib_
	 global cdb_id

	global _CertifyEst_
	if { $_CertifyEst_ == "TRUE"} {
		 return
	}

	set args_bak $args
	set args_copy "define_path_delay $args"

	if [expr [llength $args] < 1] {
		error "define_path_delay usage: [-disable] [-comment <comment>] [-from <start>] [-through <through> [-through <through> ... ] ] [-to <end>] [-max <max_dly>] [-min <min_dly]"
	}

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}

	# Defaults
	set from *
	set foundfrom 0
	set to *
	set foundto 0
	set through *
	set firstthrough 0
	set foundthrough 0
	set pos 0
	set max_dly *
	set min_dly *

	while { [expr [llength $args] > 0] } {
		set sw [lindex $args 0]
		set args [lrange $args 1 end]
		set value [ lindex $args 0 ]
		if {([expr [llength $value] == 1]) && !([regexp {\{} $value]) && ([regexp {\\} $value])} {
			set value "\{$value\}"
		}
		set args [lrange $args 1 end]
		switch -- $sw {
			"-from" {
		  		if {$value != "*" } {  ;#ignore just a * 
					set from $value
					set foundfrom 1
				}
			}
			"-to" {
		  		if {$value != "*" } {  ;#ignore just a * 
					set to $value
					set foundto 1
				}				
			}
	 		"-through" {
				if $foundthrough {
					set pos 1
					set through "$through through $value"
				} else {
			  		set foundthrough 1
			  		set through $value
				}
			}
			"-pos" {
				if !$foundthrough {
					error "unsupported format for max/min delay path POS"
				}
				set pos 1
				set through "$through through $value"
			}
			"-max" {
				set max_dly $value
			}
			"-min" {
				set min_dly $value
			}
			default {
				error [format "define_path_delay: unknown switch %s" $sw]
			}
		}
	}

	if {$_lib_ == "SYNPLIFY"} {
		set max 0
		set min 0

		set tmp $args_bak
		set i 0
		set iMax [llength $tmp]
		
		while { $i < $iMax } {
			switch -- [lindex $tmp $i] {
				"-max" {
					set max 1
					set tmp [lreplace $tmp $i $i]
					incr i
				}
				"-min" {
					set min 1
					set tmp [lreplace $tmp $i $i]
					incr i
				}
			}
			incr i
		}

#		warning "tmp: $tmp"

		if { $max == 1 } {
			define_max_delay $tmp
		}
		if { $min == 1 } {
			define_min_delay $tmp
		}
	} elseif {$_lib_ == "SETCONST"} {
        if {$foundfrom == 0} {
            set from ""
        }
        if {$foundto == 0} {
            set to ""
        }
        if {$foundthrough == 0} {
            set through ""
        }
        add_path_delay_constraint $disable $comment $from $through 0 $pos $to $max_dly $min_dly
	}
}

# Definition
# define_report_path [-disable] [-comment <comment>] [-from from_inst] [-through thro_inst] [-to to_inst]
# 
# This constraint is used for marking paths that should be reported.

proc define_report_path {args} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	global _lib_
	global cdb_id

	if [expr [llength $args] < 1] {
		error "define_report_path usage: [-disable] [-comment <comment>] [-from <start>] [-through <through> [-through <through> ... ] ] [-to <end>]"
	}

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}

	# Defaults
	set from *
	set foundfrom 0
	set to *
	set foundto 0
	set through *
	set foundthrough 0
	set pos 0

	while {[expr [llength $args] > 0]} {
		set sw [lindex $args 0]
		set args [lrange $args 1 end]
		set value [ lindex $args 0 ]
		if {([expr [llength $value] == 1]) && !([regexp {\{} $value]) && ([regexp {\\} $value])} {
			set value "\{$value\}"
		}
		set args [lrange $args 1 end]
		switch -- $sw {
			"-from" {
				set from $value
				set foundfrom 1
			}
			"-to" {
				set to $value
				set foundto 1				
			}
	 		"-through" {
				if $foundthrough {
					set pos 1
					set through "$through through $value"
				} else {
			  		set foundthrough 1
			  		set through $value
				}
			}
			"-pos" {
				if !$foundthrough {
					error "unsupported format for report path POS"
				}
				set pos 1
				set through "$through through $value"
			}
			default {
				error [format "define_report_path: unknown switch %s" $sw]
			}
		}
	}

	if {$_lib_ == "SYNPLIFY"} {
		if {$disable == 0} {
			set prop "syn_report_path$cdb_id"
			if $foundfrom {
				set l $from
				while {[expr [llength $l] > 0]} {
					if {[lindex $l 0] != ""} {
						# synplify_define_attribute [lindex $l 0] ".reportf$syn_fmid" $prop
					}
					set l [lrange $l 1 end]
				}
			} else {
				set from ""
			}
			if $foundthrough {
					set throughprop ".reportnordth"
				if $pos {
					set posindex 0
				}
				set l [ synplify_expand_list $through]
				set through [lindex $l 0]
				while {[expr [llength $l] > 0]} {
					if {[lindex $l 0] == ""} {
						set l [lrange $l 1 end]
						continue
					}
					if $pos {
						# synplify_define_attribute [lindex $l 0] "$throughprop$syn_fmid...$posindex" $prop
						if {[lindex $l 1] == "through"} {
							incr posindex
							set through "$through [lindex $l 2]"
							set l [lrange $l 2 end]
						} else {
							set through "$through [lindex $l 1]"
							set l [lrange $l 1 end]
						}
					} else {
						# synplify_define_attribute [lindex $l 0] $throughprop$syn_fmid $prop
						set through "$through [lindex $l 1]"
						set l [lrange $l 1 end]
					}
				}
	  		} else {
				set through ""
			}
			if $foundto {
				set l $to
				while {[expr [llength $l] > 0]} {
					if {[lindex $l 0] != ""} {
						# synplify_define_attribute [lindex $l 0] ".reportt$syn_fmid" $prop
					}
					set l [lrange $l 1 end]
				}
			} else {
				set to ""
			}
			# synplify_define_attribute {g:} $prop "# from $from through $through to $to"
		}
	} elseif {$_lib_ == "SETCONST"} {
        if {$foundfrom == 0} {
            set from ""
        }
        if {$foundto == 0} {
            set to ""
        }
        if {$foundthrough == 0} {
            set through ""
        }
        add_report_constraint $disable $comment $from $through 0 0 $pos $to
	}
}

# Definition
# define_watch_path [-disable] [-comment <comment>] [-from from_inst] [-to to_inst]
# 
# This constraint is used for marking paths that should be reported.

proc define_watch_path {args} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	global _lib_
	global cdb_id

	if [expr [llength $args] < 1] {
		error "define_watch_path usage: [-disable] [-comment <comment>] [-from <start>] [-to <end>]"
	}

	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}

	# Defaults
	set from *
	set foundfrom 0
	set to *
	set foundto 0

	while {[expr [llength $args] > 0]} {
		set sw [lindex $args 0]
		set args [lrange $args 1 end]
		set value [ lindex $args 0 ]
		if {([expr [llength $value] == 1]) && !([regexp {\{} $value]) && ([regexp {\\} $value])} {
			set value "\{$value\}"
		}
		set args [lrange $args 1 end]
		switch -- $sw {
			"-from" {
				set from $value
				set foundfrom 1
			}
			"-to" {
				set to $value
				set foundto 1				
			}
			default {
				error [format "define_report_path: unknown switch %s" $sw]
			}
		}
	}

	if {$_lib_ == "SYNPLIFY"} {
		if {$disable == 0} {
			set prop "syn_report_path$cdb_id"
			if $foundfrom {
				set l $from
				while {[expr [llength $l] > 0]} {
					if {[lindex $l 0] != ""} {
						# synplify_define_attribute [lindex $l 0] ".reportf$syn_fmid" $prop
					}
					set l [lrange $l 1 end]
				}
			} else {
				set from ""
			}
			if $foundto {
				set l $to
				while {[expr [llength $l] > 0]} {
					if {[lindex $l 0] != ""} {
						# synplify_define_attribute [lindex $l 0] ".reportt$syn_fmid" $prop
					}
					set l [lrange $l 1 end]
				}
			} else {
				set to ""
			}
			# synplify_define_attribute {g:} $prop "# from $from to $to"
		}
	} elseif {$_lib_ == "SETCONST"} {
        if {$foundfrom == 0} {
            set from ""
        }
        if {$foundto == 0} {
            set to ""
        }
        add_report_constraint $disable $comment $from 0 0 $to
	}
}

# In the mapper this command calls mlog_puts to print the argument string
# to the log file. In SCOPE this command does nothing.
proc log_puts { args } {
     global _lib_

     if [expr [llength $args] < 1] {
         error "Usage: log_puts {string}"
     }

     if {$_lib_ == "SYNPLIFY"} {
        mlog_puts [lindex $args 0]
     }
}

#
# Sets mapper arguments for superflow mappers
#
#
#
proc set_map_arg {args} {
    global _lib_
    global _ScopeVer_

    set object [lindex $args 0]
    set arg  [lindex $args 1]
    set value  [lindex $args 2]

    if {$_lib_ == "SYNPLIFY"} {
        synplify_set_map_arg $object $arg $value
    }
}

#
# Define the netlist used for module constraint file
#
proc define_module_netlist {args} {
    global _lib_
    global _ScopeVer_

    set object [lindex $args 0]

    if {$_lib_ == "SETCONST"} {
		if {$_ScopeVer_ >= 620} {
			scope_define_module_netlist $object
		}
    }
}

proc define_generated_clock_en { args } {
    global _lib_
	set cmd "define_generated_clock_en"

	puts $args
	set disable 0
	if {[lindex $args 0] == "-disable"} {
		set disable 1
		set args [lrange $args 1 end]
	}
	set comment *
	if {[lindex $args 0] == "-comment"} {
		set comment  [lindex $args 1]
		set args [lrange $args 2 end]
	}

	set view [lindex $args 0]
	set gclk_pin [lindex $args 1]
	set mclk_pin [lindex $args 2]
	set pen [lindex $args 3]
	set nen [lindex $args 4]

	if {$_lib_ == "SYNPLIFY"} {
		if {$disable == 0} {
			set bport $view|b:$gclk_pin

			#synplify_define_attribute $object $propname        $str

			#synplify_define_attribute $bport  syn_gen_clock_pin $gclk_pin
			synplify_define_attribute  $bport syn_master_clock_pin $mclk_pin
			synplify_define_attribute  $bport syn_pos_enable_pin  $pen
			synplify_define_attribute  $bport syn_neg_enable_pin  $nen
		}
	} elseif {$_lib_ == "SETCONST"} {
 		add_unknown_constraint $disable $comment $cmd $view $gclk_pin $mclk_pin $pen $nen
	}
}

proc define_clock_uncertainty {args} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
}

proc set_clock_uncertainty {args} {
	global _lib_
	if { $_lib_=="SETCONST"} {
		set commandname "set_clock_uncertainty"
		set uncertainty *
		set arglist ""
		while { [expr [llength $args] >0] } {
			set sw [lindex $args 0]
			set args [lrange $args 1 end]
			if { [string range $sw 0 0] != {-} } {
				set arglist [concat $arglist $sw]
				if { $uncertainty=="*" } {
					set uncertainty $sw
				} else {
					set objname $sw
				}
			} else {  
				set value [ lindex $args 0 ]
				set args [lrange $args 1 end]
				switch -- $sw {
					default {
						error [format "set_clock_uncertainty: unknown switch %s" $sw]
					}
				} ;# switch
			} ;# else
		}; #while
	add_fdc_clock_uncertainty_constraint $commandname $uncertainty $objname
    } else {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	}
}

proc define_clock_latency {args} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
}

proc set_clock_latency {args} {
	global _lib_
	if { $_lib_=="SETCONST"} {
		set commandname "set_clock_latency -source"
		set latency *
		set arglist ""
		while { [expr [llength $args] >0] } {
			set sw [lindex $args 0]
			set args [lrange $args 1 end]
			if { [string range $sw 0 0] != {-} } {
				set arglist [concat $arglist $sw]
				set objname $sw
			} else {  
				  set value [ lindex $args 0 ]
				  set args [lrange $args 1 end]
				  switch -- $sw {
				  "-source" {
						set latency $value
				  }
				  "-clock" {
				  }
				  "-rise" {
				  }
				  "-fall" {
				  }
				  default {
						error [format "set_clock_latency: unknown switch %s" $sw]
				  }
				} ;# switch
			} ;# else
		 }; #while
		add_fdc_clock_latency_constraint $commandname $latency $objname
    } else {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
	}
}


proc read_sdc { args } { 
	global _lib_

	set syntax_only 0
	if {$_lib_ == "SYNPLIFY"} {
		set files ""
		while { [expr [llength $args] > 0] } {
			set param [lindex $args 0]
			if { [regexp {^[-]} $param] } {
				switch -- $param {
    	        	"-echo" {
						warning {@W: option -echo not yet supported for command read_sdc, it will be ignored.} 
	            	}
					"-syntax_only" {
						set syntax_only 1
					}
					"-version" {
						warning {@W: option -version not yet supported for command read_sdc, it will be ignored.} 
						set args [lrange $args 1 end]
					}
					default {
						warning "@W: option $param not recognized for command read_sdc, it will be ignored." 
					}
				}
			} else {
				set files "$files $param"
			}
			# this works even if args is now empty
			set args [lrange $args 1 end]
		}
		while { [expr [llength $files] > 0] } {
			set param [lindex $files 0]
			if { $syntax_only != 0 } {
				warning "@W: option -syntax_only not yet supported for command read_sdc, skipping constraint file $param"
			} else {
				warning "read_sdc: reading constraint file $param"
				# source command will give an intelligible error message for bad file name
				uplevel 1 source $param
			}
			set files [lrange $files 1 end]
		}
	} elseif {$_lib_ == "SETCONST"} {
        syn_wrong_sdc_format
	}
}



proc set_disable_timing { args } {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
        syn_wrong_sdc_format
    }
}

proc set_dont_touch { args } {
    global _lib_

	warning {@W: set_dont_touch not supported.}

    if {$_lib_ == "SYNPLIFY"} {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
        syn_wrong_sdc_format
    }
}

proc set_case_analysis { args } {
    global _lib_

#	warning {@W: set_case_analysis not supported.}

    if {$_lib_ == "SYNPLIFY"} {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
        syn_wrong_sdc_format
    }
}

proc set_logic_one { args } {
    global _lib_

	warning {@W: set_logic_one not supported.}

    if {$_lib_ == "SYNPLIFY"} {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
        syn_wrong_sdc_format
    }
}

proc set_logic_zero { args } {
    global _lib_

	warning {@W: set_logic_zero not supported.}

    if {$_lib_ == "SYNPLIFY"} {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
        syn_wrong_sdc_format
    }
}

proc set_logic_dc { args } {
    global _lib_

	warning {@W: set_logic_dc not supported.}

    if {$_lib_ == "SYNPLIFY"} {
		addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    } elseif {$_lib_ == "SETCONST"} {
        syn_wrong_sdc_format
    }
}

set unsupportedCmds {
	acs_check_directories
	acs_compile_design
	acs_create_directories
	acs_customize_directory_structure
	add_domain_elements
	acs_get_parent_partition
	acs_get_path
	acs_merge_design
	acs_read_hdl
	acs_recompile_design
	acs_refine_design
	acs_remove_dont_touch
	acs_report_attribute
	acs_report_directories
	acs_report_user_messages
	acs_reset_directory_structure
	acs_set_attribute
	acs_submit
	acs_submit_large
	acs_write_html
	add_distributed_hosts
	add_module
	add_pg_pin_to_db
	add_pg_pin_to_lib
	add_port_state
	add_power_state
	add_pst_state
	add_row
	add_to_collection
	add_to_rp_group
	add_variation
	alias
	alib_analyze_libs
	align_objects
	all_active_scenarios
	all_bounds_of_cell
	all_cells_in_bound
	all_clock_gates
	all_cluster_cells
	all_clusters
	all_connected
	all_correlations
	all_critical_cells
	all_critical_pins
	all_designs
	all_dont_touch
	all_drc_violated_nets
	all_fixed_placement
	all_high_fanout
	all_ideal_nets
	all_instances
	all_isolation_cells
	all_level_shifters
	all_macro_cells
	all_objects_in_bounding_box
	all_operand_isolators
	all_physical_only_cells
	all_physical_only_nets
	all_physical_only_ports
	all_rp_groups
	all_rp_hierarchicals
	all_rp_inclusions
	all_rp_instantiations
	all_rp_references
	all_scenarios
	all_spare_cells
	all_threestate
	all_tieoff_cells
	all_variations
	allocate_partition_budgets
	analyze
	analyze_mv_design
	append_to_collection
	apply_clock_gate_latency
	apropos
	associate_mv_cells
	attach_bounds
	attach_region
	balance_buffer
	balance_registers
	bc_check_design
	bc_dont_register_input_port
	bc_dont_ungroup
	bc_group_process
	bc_margin
	bc_report_arrays
	bc_report_memories
	bc_set_implementation
	bc_set_margin
	bc_time_design
	begin_group_undo
	bind_checker
	calculate_rtl_load
	can_redo
	can_undo
	cell_of
	chain_operations
	change_histogram
	change_link
	change_macro_view
	change_names
	change_selection
	change_site_name
	characterize
	characterize_context
	characterize_physical
	check_bindings
	check_block_scope
	check_bsd
	check_budget
	check_ccs_lib
	check_constraints
	check_design
	check_dft
	check_error
	check_implementations
	check_isolation_cells
	check_legality
	check_level_shifter
	check_level_shifters
	check_library
	check_license
	check_mpc
	check_mv_design
	check_noise
	check_physical_constraints
	check_power
	check_rp_groups
	check_scan
	check_scan_def
	check_scenarios
	check_synlib
	check_target_library_subset
	check_test
	check_timing
	check_tlu_plus_files
	check_unmapped
	clean_buffer_tree
	close_mw_lib
	compare_collections
	compare_delay_calculation
	compare_design
	compare_fsm
	compare_interface_timing
	compare_lib
	compare_rc
	compile
	compile_clock_tree
	compile_partitions
	compile_physical
	compile_preserved_functions
	compile_ultra
	complete_net_parasitics
	connect_logic_net
	connect_logic_one
	connect_logic_zero
	connect_net
	connect_pin
	connect_power_domain
	connect_power_net_info
	connect_supply_net
	connect_supply_set
	context_check
	convert_placement_keepout
	copy_collection
	copy_design
	copy_mw_lib
	cputime
	create_activity_waveforms
	create_bounds
	create_bsd_patterns
	create_buffer_tree
	create_bus
	create_cache
	create_cell
	create_cluster
	create_command_group
	create_composite_domain
	create_core_area
	create_correlation
	create_default_region
	create_design
	create_die_area
	create_distributed_farm
	create_eco_astro_constraints
	create_hdl2upf_vct
	create_ilm
	create_logic_net
	create_logic_port
	create_multibit
	create_mw_design
	create_mw_lib
	create_net
	create_net_shape
	create_obstruction
	create_operating_conditions
	create_pass_directories
	create_placement
	create_placement_blockage
	create_placement_keepouts
	create_port	
	create_power_group
	create_power_net_info
	create_power_rail_mapping
	create_power_switch
	create_pst
	create_qtm_constraint_arc
	create_qtm_delay_arc
	create_qtm_drive_type
	create_qtm_generated_clock
	create_qtm_load_type
	create_qtm_model
	create_qtm_path_type
	create_qtm_port
	create_region
	create_route_guide
	create_routing_path
	create_rp_group
	create_scenario
	create_schematic
	create_si_context
	create_site_row
	create_supply_net
	create_supply_port
	create_supply_set
	create_terminal
	create_test_clock
	create_test_patterns
	create_test_protocol
	create_test_schedule
	create_track
	create_variation
	create_via
	create_voltage_area
	create_wire_load
	create_wiring_keepouts
	current_design
	current_design_name
	current_dft_partition
	current_instance
	current_mw_lib
	current_power_rail
	current_scenario
	current_session
	current_test_mode
	cut_row
	date
	dc_allocate_budgets
	define_design_lib
	define_design_mode_group
	define_dft_design
	define_dft_partition
	define_name_rules
	define_qtm_attribute
	define_routing_rule
	define_scaling_lib_group
	define_test_mode
	define_user_attribute
	define_via
	delete_operating_conditions
	derive_clock_uncertainty
	derive_clocks
	derive_constraints
	derive_mpc_macro_options
	derive_mpc_options
	derive_mpc_port_options
	derive_net_routing_layer_constraints
	derive_regions
	derive_timing_constraints
	describe_state_transition
	detach_bounds
	detach_region
	dft_drc
	disable_undo
	disconnect_net
	disconnect_power_net_info
	disconnect_scan_chains
	distance
	dont_chain_operations
	dont_touch
	dont_touch_network
	dont_use
	drive_of
	echo
	eco_align_design
	eco_analyze_design
	eco_current_design_pair
	eco_implement
	eco_netlist_diff
	eco_recycle
	eco_report_cell
	eco_reset_directives
	elaborate
	enable_undo
	encrypt_lib
	end_group_undo
	enter_visual_mode
	error_info
	estimate_clock_network_power
	estimate_eco
	estimate_rc
	estimate_test_coverage
	execute
	exit_visual_mode
	externalize_cell
	extract
	extract_ilm
	extract_model
	extract_physical_constraints
	extract_rc
	filter
	filter_collection
	find_objects
	fix_eco_drc
	fix_eco_timing
	fix_hold
	fix_routing_fat_contacts
	format_lib
	get_alternative_lib_cells
	get_always_on_logic
	get_attribute
	get_attribute_physical
	get_bounds
	get_buffers
	get_clock_network_objects
	get_clock_tree_attributes
	get_clock_tree_delays
	get_clock_tree_objects
	get_clusters
	get_command_option_values
	get_congested_regions
	get_correlations
	get_cts_scenario
	get_current_power_domain
	get_current_power_net
	get_design_lib_path
	get_design_parameter
	get_designs
	get_die_area
	get_distributed_variables
	get_drc_violated_nets
	get_generated_clocks
	get_gui_stroke_bindings
	get_ilm_objects
	get_ilms
	get_lib_attribute
	get_lib_cells
	get_lib_cells
	get_lib_pins
	get_lib_timing_arcs
	get_libs
	get_license
	get_location
	get_magnet_cells
	get_message_info
	get_multibits
	get_noise_violation_sources
	get_path_groups
	get_physical_hierarchy
	get_placement_area
	get_placement_keepouts
	get_pnet
	get_power_domains
	get_power_group_objects
	get_power_switches
	get_qtm_ports
	get_random_numbers
	get_references
	get_regions
	get_related_supply_net
	get_rp_groups
	get_scan_cells_of_chain
	get_scan_chains
	get_selection
	get_si_bottleneck_nets
	get_site_row
	get_special_collection
	get_supply_nets
	get_supply_ports
	get_supply_sets
	get_switching_activity
	get_terminals
	get_timing_arcs
	get_timing_paths
	get_unix_variable
	get_variation_attribute
	get_variations
	get_wiring_keepouts
	get_zero_interconnect_delay_mode
	getenv
	gets_dialog
	group
	group_path
	group_variable
	gui_add_annotation
	gui_add_menu
	gui_add_ruler_point
	gui_add_toolbar_item
	gui_bin
	gui_create_attrdef
	gui_create_attrgroup
	gui_create_pref_category
	gui_create_pref_key
	gui_create_toolbar
	gui_create_var
	gui_create_vm
	gui_create_vmbucket
	gui_delete_attrdef
	gui_delete_attrgroup
	gui_eval_cmd
	gui_exist_pref_category
	gui_exist_pref_key
	gui_exist_var
	gui_get_attribute
	gui_get_bucket_option
	gui_get_bucket_option_list
	gui_get_map_list
	gui_get_map_option
	gui_get_map_option_list
	gui_get_pref_categories
	gui_get_pref_keys
	gui_get_pref_value
	gui_get_pref_value_type
	gui_get_region
	gui_get_toolbar_names
	gui_get_var
	gui_get_vm
	gui_get_vmbucket
	gui_hide_toolbar
	gui_list_attrdefs
	gui_list_attrgroup
	gui_list_vm
	gui_log_cmd
	gui_new_ruler
	gui_remove_all_annotations
	gui_remove_all_rulers
	gui_remove_pref_key
	gui_remove_toolbar
	gui_remove_toolbar_item
	gui_remove_var
	gui_remove_vm
	gui_remove_vmbucket
	gui_select_by_name
	gui_select_vmbucket
	gui_set_attribute
	gui_set_bucket_option
	gui_set_layout_visual_mode
	gui_set_map_option
	gui_set_pref_value
	gui_set_region
	gui_set_var
	gui_set_vm
	gui_set_vmbucket
	gui_show_man_page
	gui_show_map
	gui_show_toolbar
	gui_start
	gui_stop
	gui_update_attrdef
	gui_update_attrgroup
	gui_update_physical_model
	gui_update_pref_file
	gui_update_vm
	gui_view_port_history
	gui_write_window_image
	gui_zoom
	highlight_path
	history
	hookup_power_gating_ports
	hookup_retention_register
	hookup_testports
	identify_clock_gating
	identify_interface_logic
	ignore_array_loop_precedences
	ignore_array_precedences
	ignore_memory_loop_precedences
	ignore_memory_precedences
	ignore_site_row
	index_collection
	infer_power_domains
	infer_test_protocol
	insert_bsd
	insert_buffer
	insert_clock_gating
	insert_dft
	insert_filler
	insert_isolation_cell
	insert_level_shifters
	insert_mv_cells
	insert_pads
	insert_scan
	insert_spare_cells
	insert_tap
	invalidate_undo
	is_false
	is_true
	last_redo_cmd_name
	last_undo_cmd_name
	legalize_placement
	lib2saif
	license_users
	link
	link_design
	link_physical_library
	list_attributes
	list_designs
	list_duplicate_designs
	list_files
	list_gw_preferences
	list_instances
	list_key_bindings
	list_libraries
	list_libs
	list_licenses
	list_test_models
	list_test_modes
	lminus
	load_of	
	load_simstate_behavior
	load_upf_protected
	ls
	lsi_readlef
	magnet_placement
	man
	map_design_mode
	map_isolation_cell
	map_level_shifter_cell
	map_power_switch
	map_retention_cell
	max_area
	max_delay
	max_variation
	mem
	merge_models
	merge_power_domains
	merge_saif
	min_delay
	min_variation
	minimize_fsm
	move_objects
	mw_cel_collection	
	open_mw_lib
	optimize_bsd
	optimize_congestion
	optimize_placement
	optimize_registers
	parallel_execute
	parent_cluster
	partition_dp
	physopt
	pipeline_design
	pipeline_loop
	plot
	post_message
	prefer
	preschedule
	preview_bsd
	preview_dft
	preview_scan
	print
	print_message_info
	print_proc_new_vars
	print_suppressed_messages
	print_variable_group
	printenv
	printvar
	proc_args
	proc_body
	propagate_annotated_delay_up
	propagate_constraints
	propagate_ilm
	propagate_placement
	propagate_placement_up
	propagate_switching_activity
	push_down_model
	query_objects
	query_upf
	query_associate_supply_set
	query_bind_checker
	query_cell_instances
	query_cell_mapped
	query_composite_domain
	query_design_attributes
	query_hdl2upf_vct
	query_isolation
	query_isolation_control
	query_level_shifter
	query_map_isolation_cell
	query_map_level_shifter_cell
	query_map_power_switch
	query_map_retention_cell
	query_name_format
	query_net_ports
	query_partial_on_translation
	query_pin_related_supply
	query_port_attributes
	query_port_direction
	query_port_net
	query_port_state
	query_power_domain
	query_power_domain_element
	query_power_state
	query_power_switch
	query_pst
	query_pst_state
	query_retention
	query_retention_control
	query_retention_elements
	query_simstate_behavior
	query_state_transition
	query_supply_net
	query_supply_port
	query_supply_set
	query_upf2hdl_vct
	query_use_interface_cell
	quit
	read_aocvm
	read_bsd_init_protocol
	read_bsd_protocol
	read_bsdl
	read_clusters
	read_db
	read_ddc
	read_def
	read_edif
	read_file
	read_floorplan
	read_init_protocol
	read_lib
	read_mdb
	read_milkyway
	read_parasitics
	read_partition
	read_pattern_info
	read_pdef
	read_pin_map
	read_preserved_function_netlist
	read_saif
	read_sdf
	read_sverilog
	read_tdf_ports
	read_test_model
	read_test_protocol
	read_timing
	read_trc_file
	read_vcd
	read_verilog
	read_vhdl
	rebuild_mw_lib
	redirect
	redo
	reduce_fsm
	register_control
	remote_execute
	remove_analysis_info
	remove_annotated_check
	remove_annotated_clock_network_power
	remove_annotated_delay
	remove_annotated_parasitics
	remove_annotated_power
	remove_annotated_transition
	remove_annotations
	remove_aocvm
	remove_attribute
	remove_boundary_cell
	remove_boundary_cell_io
	remove_bounds
	remove_bsd_compliance
	remove_bsd_instruction
	remove_bsd_linkage_port
	remove_bsd_port
	remove_bsd_power_up_reset
	remove_bsd_signal
	remove_bsd_specification
	remove_bsr_cell_type
	remove_buffer
	remove_buffer_tree
	remove_bus
	remove_cache
	remove_capacitance
	remove_case_analysis
	remove_cell
	remove_cell_degradation
	remove_clock
	remove_clock_gating
	remove_clock_gating_check
	remove_clock_groups
	remove_clock_latency
	remove_clock_sense
	remove_clock_transition
	remove_clock_tree
	remove_clock_tree_balance_group
	remove_clock_tree_exceptions
	remove_clock_tree_options
	remove_clock_tree_root_delay
	remove_clock_uncertainty
	remove_clusters
	remove_congestion_options
	remove_connection_class
	remove_constraint
	remove_context
	remove_core_area
	remove_core_integration_configuration
	remove_core_wrapper_configuration
	remove_core_wrapper_specification
	remove_coupling_separation
	remove_cts_scenario
	remove_current_session
	remove_data_check
	remove_design
	remove_design_mode
	remove_dft_configuration
	remove_dft_connect
	remove_dft_design
	remove_dft_equivalent_signals
	remove_dft_location
	remove_dft_partition
	remove_dft_signal
	remove_die_area
	remove_disable_clock_gating_check
	remove_disable_orientation_optimization
	remove_disable_timing
	remove_distributed_hosts
	remove_dont_touch_placement
	remove_dp_int_round
	remove_drive_resistance
	remove_driving_cell
	remove_fanout_load
	remove_filler
	remove_from_collection
	remove_from_rp_group
	remove_generated_clock
	remove_highlighting
	remove_host_options
	remove_ideal_latency
	remove_ideal_net
	remove_ideal_network
	remove_ideal_transition
	remove_ignored_layers
	remove_input_delay
	remove_input_noise
	remove_isolate_ports
	remove_isolation_cell
	remove_keepout_margin
	remove_level_shifters
	remove_lib
	remove_license
	remove_max_area
	remove_max_capacitance
	remove_max_fanout
	remove_max_time_borrow
	remove_max_transition
	remove_mbist_configuration
	remove_min_capacitance
	remove_min_pulse_width
	remove_multi_scenario_design
	remove_multibit
	remove_net
	remove_net_isolations
	remove_net_routing_layer_constraints
	remove_net_shape
	remove_net_shielding
	remove_noise_immunity_curve
	remove_noise_lib_pin
	remove_noise_margin
	remove_obstruction
	remove_operand_isolation
	remove_operating_conditions
	remove_output_delay
	remove_package
	remove_pads
	remove_parasitic_corner
	remove_pass_directories
	remove_path_group
	remove_pin_map
	remove_pin_name_synonym
	remove_placement_blockage
	remove_placement_keepout
	remove_pnet_options
	remove_port
	remove_port_configuration
	remove_port_fanout_number
	remove_power_domain
	remove_power_groups
	remove_power_net_info
	remove_preferred_routing_direction
	remove_preroute_check
	remove_propagated_clock
	remove_pulse_clock_max_transition
	remove_pulse_clock_max_width
	remove_pulse_clock_min_transition
	remove_pulse_clock_min_width
	remove_qtm_attribute
	remove_rail_voltage
	remove_region
	remove_resistance
	remove_route_guide
	remove_routing_rules
	remove_routing_wire_models
	remove_rp_group_options
	remove_rp_groups
	remove_rtl_load
	remove_scaling_lib_group
	remove_scan_group
	remove_scan_link
	remove_scan_path
	remove_scan_register_type
	remove_scan_replacement
	remove_scan_specification
	remove_scan_suppress_toggling
	remove_scenario
	remove_scheduling_constraints
	remove_sdc
	remove_setup_hold_pessimism_reduction
	remove_si_aggressor_exclusion
	remove_si_delay_analysis
	remove_si_delay_disable_statistical
	remove_si_noise_analysis
	remove_si_noise_disable_statistical
	remove_site_row
	remove_steady_state_resistance
	remove_target_library_subset
	remove_terminal
	remove_test_mode
	remove_test_model
	remove_test_point_element
	remove_test_protocol
	remove_track
	remove_unconnected_ports
	remove_upf
	remove_user_attribute
	remove_user_sensitization
	remove_variable
	remove_variation
	remove_verification_priority
	remove_via
	remove_voltage_area
	remove_wire_load_min_block_size
	remove_wire_load_model
	remove_wire_load_selection_group
	remove_wiring_keepout
	remove_wiring_keepout_options
	remove_wrapper_element
	rename_cell
	rename_design
	rename_mw_lib
	rename_net
	reoptimize_design
	replace_clock_gates
	replace_synthetic
	report
	report_activity_file_check
	report_activity_waveforms
	report_ahfs_options
	report_alternative_lib_cells
	report_analysis_coverage
	report_annotated_check
	report_annotated_delay
	report_annotated_parasitics
	report_annotated_power
	report_annotated_transition
	report_antenna
	report_aocvm
	report_area
	report_attribute
	report_auto_ungroup
	report_autofix_configuration
	report_autofix_element
	report_bottleneck
	report_boundary_cell
	report_boundary_cell_io
	report_bounds
	report_bsd_compliance
	report_bsd_instruction
	report_bsd_linkage_port
	report_bsd_power_up_reset
	report_buffer_tree
	report_buffer_tree_qor
	report_bus
	report_cache
	report_case_analysis
	report_cell
	report_cell_displacement
	report_change_list
	report_check_library_options
	report_clock
	report_clock_gate_savings
	report_clock_gating
	report_clock_gating_check
	report_clock_timing
	report_clock_tree
	report_clock_tree_power
	report_clusters
	report_compile_options
	report_congestion
	report_congestion_options
	report_constraint
	report_context
	report_crpr
	report_delay_calculation
	report_delay_estimation_options
	report_design
	report_design_lib
	report_dft_configuration
	report_dft_connect
	report_dft_design
	report_dft_drc_rules
	report_dft_equivalent_signals
	report_dft_insertion_configuration
	report_dft_location
	report_dft_partition
	report_dft_signal
	report_direct_power_rail_tie
	report_disable_timing
	report_distributed_hosts
	report_dp_smartgen_options
	report_driver_model
	report_etm_arc
	report_exceptions
	report_extraction_options
	report_fat_contact_options
	report_fault
	report_filler
	report_floorplan_macro_array
	report_floorplan_macro_options
	report_floorplan_options
	report_floorplan_pnet_options
	report_floorplan_port_options
	report_fsm
	report_global_slack
	report_gui_stroke_bindings
	report_gui_stroke_builtins
	report_hierarchy
	report_host_options
	report_host_usage
	report_icc_dp_options
	report_ideal_network
	report_ignored_layers
	report_ilm
	report_interclock_relation
	report_internal_loads
	report_isolate_ports
	report_isolation_cell
	report_keepout_margin
	report_level_shifter
	report_lib
	report_lib_groups
	report_logicbist_configuration
	report_min_pulse_width
	report_mode
	report_mpc_macro_array
	report_mpc_macro_options
	report_mpc_options
	report_mpc_pnet_options
	report_mpc_port_options
	report_mpc_ring_options
	report_multi_scenario_design
	report_multibit
	report_multicycles
	report_mv_library_cells
	report_mw_lib
	report_name_mapping
	report_name_rules
	report_names
	report_net
	report_net_changes
	report_net_fanout
	report_net_isolations
	report_net_routing_layer_constraints
	report_net_routing_rules
	report_net_shielding
	report_net_shielding
	report_net_statistics
	report_noise
	report_noise_calculation
	report_noise_parameters
	report_noise_violation_sources
	report_obstruction
	report_operand_isolation
	report_operating_conditions
	report_packages
	report_partitions
	report_pass_data
	report_path_budget
	report_path_group
	report_peak_noise
	report_physical_constraints
	report_pin_map
	report_pin_name_synonym
	report_placement_keepout
	report_pnet_options
	report_port
	report_power
	report_power_analysis_options
	report_power_calculation
	report_power_derate
	report_power_domain
	report_power_gating
	report_power_gating_style
	report_power_groups
	report_power_net_info
	report_power_network
	report_power_pin_info
	report_power_rail_mapping
	report_power_switch
	report_preferred_routing_direction
	report_preroute_check
	report_pst
	report_pulse_clock_max_transition
	report_pulse_clock_max_width
	report_pulse_clock_min_transition
	report_pulse_clock_min_width
	report_qor
	report_qtm_model
	report_reference
	report_region
	report_register
	report_resource_estimates
	report_resources
	report_retention_cell
	report_routability
	report_routing_constraint_violations
	report_routing_layer_constraint
	report_routing_min_area_rule
	report_routing_options
	report_routing_rules
	report_routing_weights
	report_routing_wire_models
	report_rp_group_options
	report_rtc_routing_options
	report_rtl_power
	report_saif
	report_scale_parasitics
	report_scan_chain
	report_scan_compression_configuration
	report_scan_configuration
	report_scan_group
	report_scan_link
	report_scan_path
	report_scan_register_type
	report_scan_replacement
	report_scan_state
	report_scan_suppress_toggling
	report_scenario_options
	report_scenarios
	report_schedule
	report_scope_data
	report_si_aggressor_exclusion
	report_si_bottleneck
	report_si_delay_analysis
	report_si_double_switching
	report_si_noise_analysis
	report_supply_net
	report_supply_port
	report_supply_set
	report_switching_activity
	report_synlib
	report_target_library_subset
	report_test
	report_test_assume
	report_test_mode
	report_test_model
	report_test_point_element
	report_testability_configuration
	report_threshold_voltage_group
	report_timing
	report_timing_derate
	report_timing_requirements
	report_tlu_plus_files
	report_track
	report_transitive_fanin
	report_transitive_fanout
	report_ultra_optimization
	report_units
	report_use_test_model
	report_user_sensitization
	report_variation
	report_vcd_hierarchy
	report_voltage_area
	report_wire_load
	report_wiring_keepout
	report_wiring_keepout_options
	report_wrapper_configuration
	report_xref
	reset_autofix_configuration
	reset_autofix_element
	reset_bsd_configuration
	reset_clock_gate_latency
	reset_clock_tree_references
	reset_compare_design_script
	reset_design
	reset_dft_configuration
	reset_dft_drc_rules
	reset_dft_insertion_configuration
	reset_logicbist_configuration
	reset_mode
	reset_noise_parameters
	reset_physical_constraints
	reset_pipeline_scan_data_configuration
	reset_power_derate
	reset_scale_parasitics
	reset_scan_compression_configuration
	reset_scan_configuration
	reset_switching_activity
	reset_test_mode
	reset_testability_configuration
	reset_timing_derate
	reset_variation
	reset_wrapper_configuration
	reshape_placement_keepout
	reshape_wiring_keepout
	resize_objects
	restore_session
	retime_clock_tree
	rewire_clock_gating
	rotate_objects
	route
	route_power
	route_quick
	rp_group_inclusions
	rp_group_instantiations
	rp_group_references
	rtl2saif
	rtldrc
	run_router
	saif_map
	save_gw_preferences
	save_qtm_model
	save_session
	save_upf
	scale_parasitics
	schedule
	set_active_clocks
	set_active_scenarios
	set_ahfs_options
	set_always_on_cell
	set_always_on_strategy
	set_annotated_check
	set_annotated_clock_network_power
	set_annotated_delay
	set_annotated_power
	set_annotated_transition
	set_aocvm_coefficient
	set_aspect_ratio
	set_attribute
	set_auto_disable_drc_nets
	set_auto_ideal_nets
	set_autofix_async
	set_autofix_clock
	set_autofix_configuration
	set_autofix_element
	set_balance_registers
	set_behavioral_async_reset
	set_behavioral_reset
	set_bist_auto_parameters
	set_bist_configuration
	set_boundary_cell
	set_boundary_cell_io
	set_boundary_optimization
	set_bsd_ac_port
	set_bsd_bsr_element
	set_bsd_compliance
	set_bsd_configuration
	set_bsd_control_cell
	set_bsd_data_cell
	set_bsd_instruction
	set_bsd_intest
	set_bsd_linkage_port
	set_bsd_pad_design
	set_bsd_path
	set_bsd_port
	set_bsd_power_up_reset
	set_bsd_register
	set_bsd_runbist
	set_bsd_signal
	set_bsd_tap_element
	set_bsr_cell_type
	set_cell_degradation
	set_cell_internal_power
	set_cell_location
	set_cell_row_type
	set_cell_type
	set_check_library_options
	set_clock_gate_latency
	set_clock_gating_check
	set_clock_gating_registers
	set_clock_gating_signals
	set_clock_gating_style
	set_clock_sense
	set_clock_skew
	set_clock_transition
	set_clock_tree_balance_group
	set_clock_tree_exceptions
	set_clock_tree_options
	set_clock_tree_references
	set_clock_tree_root_delay
	set_combinational_type
	set_common_resource
	set_compare_design_script
	set_compile_directives
	set_compile_partitions
	set_congestion_options
	set_connection_class
	set_constraint_margin
	set_context_margin
	set_core_integration_configuration
	set_core_wrapper_cell
	set_core_wrapper_cell_design
	set_core_wrapper_configuration
	set_core_wrapper_path
	set_cost_priority
	set_coupling_separation
	set_critical_range
	set_cts_scenario
	set_current_command_mode
	set_current_power_domain
	set_current_power_net
	set_cycles
	set_data_check
	set_datapath_optimization
	set_datapath_optimization_effort
	set_datapathonly_delay
	set_default_drive
	set_default_driving_cell
	set_default_fanout_load
	set_default_input_delay
	set_default_load
	set_default_output_delay
	set_delay_calculation
	set_delay_estimation_options
	set_design_attributes
	set_design_license
	set_design_top
	set_dft_clock_controller
	set_dft_configuration
	set_dft_connect
	set_dft_drc_configuration
	set_dft_drc_rules
	set_dft_equivalent_signals
	set_dft_insertion_configuration
	set_dft_location
	set_dft_optimization_configuration
	set_dft_signal
	set_die_area
	set_direct_power_rail_tie
	set_disable_clock_gating_check
	set_disable_orientation_optimization
	set_distributed_parameters
	set_distributed_variables
	set_domain_supply_net
	set_dont_remap
	set_dont_retime
	set_dont_touch_network
	set_dont_touch_placement
	set_dont_use
	set_dp_int_round
	set_dp_smartgen_options
	set_drive
	set_drive_resistance
	set_driving_cell
	set_eco_align
	set_eco_obsolete
	set_eco_recycle
	set_eco_reuse
	set_eco_target
	set_eco_unique
	set_electromigration_drc
	set_equal
	set_equivalent
	set_exclusive_use
	set_extraction_options
	set_fanout_load
	set_fat_contact_options
	set_fix_hold
	set_fix_multiple_port_nets
	set_flatten
	set_floorplan_macro_array
	set_floorplan_macro_options
	set_floorplan_options
	set_floorplan_pnet_options
	set_floorplan_port_options
	set_fpga
	set_fsm_encoding
	set_fsm_encoding_style
	set_fsm_minimize
	set_fsm_order
	set_fsm_preserve_state
	set_fsm_state_vector
	set_fuzzy_query_options
	set_gui_stroke_binding
	set_gui_stroke_preferences
	set_gw_preference
	set_host_options
	set_icc_dp_options
	set_ideal_latency
	set_ideal_net
	set_ideal_network
	set_ideal_transition
	set_ignored_layers
	set_impl_priority
	set_implementation
	set_input_noise
	set_input_parasitics
	set_input_transition
	set_inverted_placement_keepout
	set_inverted_wiring_keepout
	set_isolate_ports	
	set_isolation_cell	
	set_isolation_operations
	set_keepout_margin
	set_layer
	set_leakage_power_model
	set_level_shifter
	set_level_shifter_cell
	set_level_shifter_strategy
	set_level_shifter_threshold
	set_lib_attribute
	set_lib_rail_connection
	set_libcell_dimensions
	set_libpin_location
	set_library_driver_waveform
	set_load
	set_local_link_library
	set_logicbist_configuration
	set_macro_cell_bound_spot
	set_map_only
	set_margin
	set_max_area
	set_max_capacitance
	set_max_cycles
	set_max_dynamic_power
	set_max_fanout
	set_max_leakage_power
	set_max_lvth_percentage
	set_max_net_length
	set_max_peak_noise
	set_max_time_borrow
	set_max_toggle_rate
	set_max_total_power
	set_max_transition
	set_mbist_configuration
	set_mbist_controller
	set_mbist_element
	set_mbist_run
	set_memory_input_delay
	set_memory_output_delay
	set_message_info
	set_message_severity
	set_min_capacitance
	set_min_cycles
	set_min_library
	set_min_porosity
	set_minimize_tree_delay
	set_mode
	set_model_drive
	set_model_load
	set_model_map_effort
	set_model_scale
	set_module_clock_edges
	set_module_clock_gates
	set_mpc_macro_array
	set_mpc_macro_options
	set_mpc_options
	set_mpc_pnet_options
	set_mpc_port_options
	set_mpc_ring_options
	set_multi_scenario_license_limit
	set_multi_vth_constraint
	set_multibit_options
	set_mw_design
	set_mw_lib_reference
	set_mw_technology_file
	set_net_isolations
	set_net_routing_layer_constraints
	set_net_routing_rule
	set_net_shielding
	set_noise_derate
	set_noise_immunity_curve
	set_noise_lib_pin
	set_noise_margin
	set_noise_parameters
	set_operand_isolation_cell
	set_operand_isolation_scope
	set_operand_isolation_slack
	set_operand_isolation_style
	set_operating_conditions
	set_opposite
	set_optimize_registers
	set_output_clock_port_type
	set_pad_type
	set_parasitic_corner
	set_partial_on_translation
	set_pg_pin_model
	set_physical_hierarchy
	set_physopt_cpulimit_options
	set_pin_model
	set_pin_name_synonym
	set_pin_related_supply
	set_pipeline_scan_data_configuration
	set_pipeline_stages
	set_placement_area
	set_plib_layer_model
	set_pnet_options
	set_port_attributes
	set_port_configuration
	set_port_fanout_number
	set_port_is_pad
	set_port_location
	set_port_side
	set_power_analysis_options
	set_power_clock_scaling
	set_power_derate
	set_power_gating_signal
	set_power_gating_style
	set_power_prediction
	set_power_rail
	set_power_rail_connection
	set_power_switch
	set_power_switch_cell
	set_prefer
	set_preferred_routing_direction
	set_preferred_scenario
	set_preroute_check
	set_program_options
	set_propagated_clock
	set_pulse_clock_cell
	set_pulse_clock_max_transition
	set_pulse_clock_max_width
	set_pulse_clock_min_transition
	set_pulse_clock_min_width
	set_qtm_attribute
	set_qtm_global_parameter
	set_qtm_port_drive
	set_qtm_port_load
	set_qtm_technology
	set_rail_voltage
	set_register_merging
	set_register_replication
	set_register_type
	set_related_supply_net
	set_repeater
	set_relative_always_on
	set_replace_clock_gates
	set_resistance
	set_resource_allocation
	set_resource_implementation	
	set_retention_cell	
	set_retention_control_pins
	set_retention_elements
	set_retiming_bound
	set_routing_layer_constraint
	set_routing_layer_plength_threshold
	set_routing_layer_preferred_direction
	set_routing_min_area_rule
	set_routing_options
	set_routing_weights
	set_routing_wire_model
	set_row_type
	set_rp_group_options
	set_rtc_routing_options
	set_rtl_load
	set_rtl_to_gate_name
	set_scaling_lib_group
	set_scan_bidi
	set_scan_compression_configuration
	set_scan_configuration
	set_scan_element
	set_scan_exclude
	set_scan_group
	set_scan_link
	set_scan_path
	set_scan_register_type
	set_scan_replacement
	set_scan_segment
	set_scan_signal
	set_scan_state
	set_scan_suppress_toggling
	set_scan_transparent
	set_scan_tristate
	set_scenario_options
	set_schematic_preference	
	set_setup_hold_pessimism_reduction
	set_share_cse
	set_shielding_options
	set_si_aggressor_exclusion
	set_si_delay_analysis
	set_si_delay_disable_statistical
	set_simstate_behavior
	set_si_noise_analysis
	set_si_noise_disable_statistical
	set_signal_type
	set_simple_compile_mode
	set_size_only
	set_stall_pin
	set_state_for_retiming
	set_steady_state_resistance
	set_structure
	set_supply_net_probability
	set_svf
	set_switching_activity
	set_synlib_dont_get_license
	set_tap_elements
	set_target_library_subset
	set_temperature
	set_test_assume
	set_test_hold
	set_test_initial
	set_test_isolate
	set_test_model
	set_test_point_element
	set_test_target
	set_testability_configuration
	set_testability_element
	set_time_format
	set_timing_derate
	set_timing_ranges
	set_tlu_plus_files
	set_transform_for_retiming
	set_trc_configuration
	set_true_delay_case_analysis
	set_ultra_mode
	set_ultra_optimization
	set_unconnected
	set_ungroup
	set_units
	set_unix_variable
	set_upf_query_options
	set_use_test_model
	set_user_attribute
	set_user_budget
	set_user_sensitization
	set_utilization
	set_variation
	set_variation_correlation
	set_variation_library
	set_variation_quantile
	set_verification_priority
	set_vh_module_options
	set_vh_physopt_options
	set_voltage
	set_voltage_model
	set_vsdc
	set_wire_load
	set_wire_load_min_block_size
	set_wire_load_mode
	set_wire_load_model
	set_wire_load_selection_group
	set_wired_logic_disable
	set_wiring_keepout_options
	set_wrapper_configuration
	set_wrapper_element
	set_zero_interconnect_delay_mode
	setenv
	sh_list_key_bindings
	shell_is_in_topographical_mode
	shell_is_in_upf_mode
	shell_is_in_xg_mode
	shift_track
	show_end_point_slack_histogram
	show_histogram_generic
	show_net_capacitance_histogram
	show_path_schematic
	show_path_slack_histogram
	show_report_to_window
	simplify_constants
	size_cell
	sort_collection
	start_gui
	start_hosts
	start_icc_dp
	start_profile
	stop_gui
	stop_hosts
	stop_profile
	sub_designs_of
	sub_instances_of
	sub_variation
	suppress_message
	swap_cell
	syntax_check
	tcl_eval
	trace_nets
	transform_csa
	transform_exceptions
	translate
	translate_stamp_model
	unalias
	undo
	ungroup
	uniquify
	unschedule
	unset_fpga
	unset_rtl_to_gate_name
	unset_tlu_plus_files
	unsuppress_message
	untrace_nets
	update_bounds
	update_clusters
	update_floorplan
	update_lib
	update_lib_model
	update_lib_pg_pin_model
	update_lib_pin_model
	update_lib_voltage_model
	update_noise
	update_power
	update_region
	update_scope_data
	update_script
	update_timing
	upf_version
	use_test_model
	use_interface_cell
	variation_correlation
	win_select_objects
	win_set_filter
	win_set_select_class
	write
	write_activity_waveforms
	write_arrival_annotations
	write_astro_changes
	write_binary_aocvm
	write_bsd_protocol
	write_bsd_rtl
	write_bsdl
	write_changes
	write_clusters
	write_compare_design_script
	write_compile_script
	write_constraints
	write_context
	write_def
	write_design_lib_paths
	write_designlist
	write_environment
	write_file
	write_floorplan
	write_gds
	write_ibm_constraints
	write_ilm_netlist
	write_ilm_parasitics
	write_ilm_script
	write_ilm_sdf
	write_interface_timing
	write_layout_scan
	write_lib
	write_lib_specification_model
	write_link_library
	write_makefile
	write_mdb
	write_milkyway
	write_mw_lib_files
	write_parasitics
	write_partition
	write_partition_constraints
	write_pdef
	write_physical_annotations
	write_physical_constraints
	write_physical_script
	write_profile
	write_routing_pairwise_isolations
	write_rp_groups
	write_rtl
	write_rtl_load
	write_saif
	write_scan_def
	write_script
	write_sdc
	write_sdf
	write_sdf_constraints
	write_spice_deck
	write_test
	write_test_model
	write_test_protocol
	write_testsim_lib
	write_timing
}

# create a proc for each of the unsupported commands
foreach nosupportproc $unsupportedCmds {
	# if this command is already defined do not override it.
	if { [info command $nosupportproc] != ""  } continue
	proc $nosupportproc { args } [list warning "@W: $nosupportproc  not supported." ]
}

####  Routine for define_current_reference
####
proc define_current_reference {args} {
  set view_s [lindex $args 0]
  set cmd [lindex $args 1]
  set curr_inst [get_current_instance]
  set curr_design [get_current_design]
  
  if {$view_s eq ""} {
    log_puts " "
    log_puts "@W: : | define_current_reference :  Constraint not honored.  Usage: \"define_current_reference \'rtl_module\' \{sdc_cmd\}\"."
    return
  }
  if {$cmd eq ""} {
###  Next lines so long as we don't support
    log_puts " "
    log_puts "@W: : | define_current_reference $view_s :  No constraint to apply.  Use \"define_current_reference $view_s \{sdc_cmd\}\". "
###  These lines when we do support
#    define_current_design $view_s
#    set instlist [get_current_design -instance]
#    define_current_instance $instlist

    return
  }

  if {[regexp {\[ *find} $cmd] != 0} {
    log_puts " "
    log_puts "@W: : | define_current_reference $view_s \{$cmd\} :  Constraint not applied.  Embedding \"find\" in the constraint is not currently supported."
    return
  }
  set atoms [split $cmd]
  
  foreach y $atoms {
    if {[regsub {^\$} $y "" x]} {
      regsub -all {\{|\}|\[|\]} $x "" x
      upvar $x $x
      set check "set z $y"
      eval $check
      if {[regexp {^s:} $z]} {
        log_puts " "
        log_puts "@W: : | define_current_reference $view_s \{$cmd\} :  Constraint not applied.  Using \"find\" for \'$y\' in the constraint is not currently supported."
        return
      }
    }
  }
  log_puts " "
  log_puts "@N: : | define_current_reference $view_s \{$cmd\}"

  define_current_design $view_s
  set instlist [get_current_design -instance]
#  define_current_design $curr_design 
  define_current_design -top
  if {$instlist eq ""} {
    log_puts " "
    log_puts "@W: : | define_current_reference $view_s \{$cmd\} :  Constraint not applied.  Reference $view_s not found."
    return
  }

  foreach x $instlist {
    define_current_instance $x
    log_puts "@N: : | Applying to instance:  [get_current_instance]"
    eval $cmd
  }
  if {$curr_inst ne ""} {
    define_current_instance $curr_inst
  } else {
    define_current_instance -top
  }
}

####  Routine for generate_context
####
proc generate_timing_budgets {args} {

     if [expr [llength $args] < 1] {
           error {generate_timing_budgets usage: <instname1> <filename1>  [<instname2> <filename2>] […] }
     }

     # Options after command name: pairs of instname and filename
     while { [expr [llength $args] >0] } {
           set instname [lindex $args 0]
           set filename [lindex $args 1]
           synplify_define_attribute $instname syn_timbu_context $filename
           set args [lrange $args 2 end]
     }
}

####  Routine for generate_context
####
proc generate_context {args} {

     if [expr [llength $args] < 1] {
           error {generate_context usage: <instname1> <filename1>  [<instname2> <filename2>] […] }
     }

     # Options after command name: pairs of instname and filename
     while { [expr [llength $args] >0] } {
           set instname [lindex $args 0]
           set filename [lindex $args 1]
           synplify_define_attribute $instname syn_context $filename
           set args [lrange $args 2 end]
     }
}

####  Routine for generate_port_context
####
proc generate_port_context {args} {

     if [expr [llength $args] < 1] {
           error {generate_port_context usage: <instname1> <filename1>  [<instname2> <filename2>] […] }
     }

     # Options after command name: pairs of instname and filename
     while { [expr [llength $args] >0] } {
           set instname [lindex $args 0]
           set filename [lindex $args 1]
           synplify_define_attribute $instname syn_port_context $filename
           set args [lrange $args 2 end]
     }
}

######set_clock_route_delay. Adds route delay to clocks.
######
proc set_clock_route_delay { args } {
    global _lib_

    if {$_lib_ == "SYNPLIFY"} {
	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
    }
}

proc get_object_name c1 {
	global _lib_
	if {$_lib_ == "SYNPLIFY"} {
                set val [c_list -bit_blast $c1]
                set val [join $val]
                if {[regexp {c:} $val]} {
                        regsub -all {(p:|n:)[^\s]+} $val "" val
                        regsub -all {\s{2,}} $val "" val
                        regsub -all {\s{1,}$} $val "" val
                }
                return [split $val]
#  		return [c_list -bit_blast $c1]
	}
  	return [c_list $c1]
}

#####  foreach_in_collection   ####
####   Supported use models given variables "$seqs" & "$ports" :
####
####    set seqs [find -hier -seq *]
####    set ports [find  -port *]
####
####    foreach_in_collection x [find -hier -seq *] {<body>}
####    foreach_in_collection x $ports {<body}
####    foreach_in_collection x [list $seqs $ports] {<body>}
####    foreach_in_collection x {$seqs} {<body>}
####    foreach_in_collection x {$seqs $ports} {<body>}

proc foreach_in_collection {args} {
  set inx [lindex $args 0]
  set col [lindex $args 1]

  set col [clean_line_fdc $col]
  set cols [split $col]
  set num_cols [llength $cols]
  set c_final [lindex $cols 0]
  set c_2 [lindex $cols 0]

  foreach c $cols {
    set var 0
    if {[regsub {^\$} $c "" c_1]} {
      upvar $c_1 $c_1
      set check "set c_2 $c"
      eval $check
      set var 1
    }
    if {$num_cols == 1} {
      set c_final $c_2
      break
    }
    if {$var} {
      set c_final [c_union $c_final $c_2]
    } else {
      set c_final [c_union $c_final $c]
    }
  }
  upvar $inx inx_up
  foreach var [get_object_name $c_final] {
    set inx_up [define_collection $var]
    uplevel [lindex $args end]
  }
}

proc sizeof_collection c1 {
  return [llength [get_object_name $c1]]
#  c_info -array c1_array $c1
#  return $c1_array(total_count)
}


proc clean_line_fdc {curr_line} {
  regsub {^\s*} $curr_line "" curr_line
  regsub -all {\s{2,}} $curr_line " " curr_line
  regsub {\s{1,}$} $curr_line "" curr_line
  return "$curr_line"
}

proc add_to_collection {args} {
  global fdc_query
  if {[lindex $args 0] eq "-unique"} {
    set col [lindex $args 1]
    set obj [lindex $args 2]
  } else {
    set col [lindex $args 0]
    set obj [lindex $args 1]
  }
  if {![regexp {^s:} $col]} {
    log_puts "@E: :Error: $col is not a collection."
    log_puts "Usage:  add_to_collection <col> <object_or_col>"
    return
  }
  set val  [define_collection $col $obj]
#  if {$fdc_query} {
#    print_fdc_query "define_collection" $args $val
#   }
  return $val
}

proc copy_collection {col} {
  if {![regexp {^s:} $col]} {
    log_puts "@E: :Error: $col is not a collection."
    log_puts "Usage:  copy_collection <col>"
    return
  }
  return [define_collection $col]
}

proc append_to_collection {args} {
  if {[lindex $args 0] eq "-unique"} {
    set col [lindex $args 1]
    set obj [lindex $args 2]
  } else {
    set col [lindex $args 0]
    set obj [lindex $args 1]
  }
  if {[regexp {^s:} $col]} {
    log_puts "@E: :Error: Must specify a variable name."
    log_puts "Usage:  append_to_collection <var_name> <object_or_col>"
    return
  }
  set cmd "set $col \[define_collection \$$col $obj\]"
  uplevel $cmd
  return
}

proc index_collection {col index} {
  global fdc_query
  if {![regexp {^s:} $col]} {
    log_puts "@E: :Error: $col is not a collection."
    log_puts "Usage:  index_collection <col> <index>"
    return
  }
  if {$index < 0 || $index >= [sizeof_collection $col]} {
    log_puts "@E: :Error: index_collection: Index $index is out of range"
    return
  }
  set val  [define_collection [lindex [get_object_name $col] $index]]
#  if {$fdc_query} {
#    set args "$col $index"
#    print_fdc_query "define_collection" $args $val
#   }
  return $val
}

proc remove_from_collection {args} {
  global fdc_query
  if {[regexp [lindex $args 0] "-intersect"]} {
    set val [c_intersect [lindex $args 1] [lindex $args 2]]
#    if {$fdc_query} {
#      print_fdc_query "define_collection" $args $val
#    }
    return $val
  } elseif {[regexp {^s:} [lindex $args 0]]} {
    set val [c_diff [lindex $args 0] [lindex $args 1]]
#    if {$fdc_query} {
#      print_fdc_query "define_collection" $args $val
#    }
    return $val
  } else {
    log_puts "@E: :Error: remove_from_collection: [lindex $args 0] is not a collection or valid option."
    log_puts "Usage:  remove_from_collection \[-intersect\] <col> <obj_spec>"
    return
  }
}

############################################
####  all_fanin/all_fanout    ##############

############################################
#### Supported options per command
####
############################################
####  Type <list_c> can be Tcl list or a collection
####  Type <col> can only be a collection
####  Type <list> can only be a Tcl list, not a collection
############################################
proc add_option {strg} {
  return [split [regsub -all {\s{2,}} $strg " "]]
}

set options(all_fanout,-clock_tree)       [add_option "-c.*             excl    {-from}"]
set options(all_fanout,-from)             [add_option "-fr.*            excl    {-clock_tree}   value   <list_c>"]
set options(all_fanout,-endpoints_only)   [add_option "-en.*            plural  {1}"]
set options(all_fanout,-exclude_bboxes)   [add_option "-ex.*            plural  {1}"]
set options(all_fanout,-break_on_bboxes)  [add_option "-b.*             plural  {1}"]
set options(all_fanout,-only_cells)       [add_option "-o.*             plural  {1}"]
set options(all_fanout,-flat)             [add_option "-fl.*            plural  {1}"]
set options(all_fanout,-levels)           [add_option "-l.*             plural  {1}             value   <int>"]
set options(all_fanout,-trace_arcs)       [add_option "-t.*             plural  {1}             value   all timing"]

set options(all_fanin,-to)                [add_option "-to              plural  {1}             value   <list_c>"]
set options(all_fanin,-startpoints_only)  [add_option "-s.*             plural  {1}"]
set options(all_fanin,-exclude_bboxes)    [add_option "-ex.*            plural  {1}"]
set options(all_fanin,-break_on_bboxes)   [add_option "-b.*             plural  {1}"]
set options(all_fanin,-only_cells)        [add_option "-o.*             plural  {1}"]
set options(all_fanin,-flat)              [add_option "-f.*             plural  {1}"]
set options(all_fanin,-levels)            [add_option "-l.*             plural  {1}             value   <int>"]
set options(all_fanin,-trace_arcs)        [add_option "-tr.*            plural  {1}             value   all timing"]


####  Returns a regexp to use for seraching $args for options that require a value
proc get_opts_w_val_exp {cmd} {
  variable options
  set exp "\("
  set opts [array names options "${cmd},*"]
  foreach x $opts {
    if {[lindex $options($x) 3] eq "value"} {
      set exp "${exp}[lindex $options($x) 0]|"
    }
  }
  regsub {\|$} $exp "" exp
  regsub {$} $exp "\)+" exp
  return $exp
}

####  Returns a regexp to use for seraching $args for options without values
proc get_opts_other_exp {cmd} {
  variable options
  set exp "\("
  set opts [array names options "${cmd},*"]
  foreach x $opts {
    if {[lindex $options($x) 3] ne "value" && ![regexp {(ignore|unsup.*)+} [lindex $options($x) 1]] } {
      set exp "${exp}[lindex $options($x) 0]|"
    }
  }
  regsub {\|$} $exp "" exp
  regsub {$} $exp "\)+" exp
  return $exp
}

proc get_exp {cmd opt} {
  variable options
  if {[catch {set val [lindex $options($cmd,$opt) 0]}]} {
    return 0
  } else {
   return $val
  }
}

proc get_type {cmd opt} {
  variable options
  if {[catch {set val [lindex $options($cmd,$opt) 1]}]} {
    return 0
  } else {
    return $val
  }
}

proc get_type_val {cmd opt} {
  variable options
  if {[catch {set val [lindex $options($cmd,$opt) 2]}]} {
    return 0
  } else {
    regsub -all {\{|\}} $val "" val
    return [split $val ,]
  }
}

proc get_unsup_msg {cmd opt} {
  variable options
  if {[catch {set val [lindex $options($cmd,$opt) 1]}]} {
    return 0
  } elseif {$val ne "unsup_msg"} {
    return 0
  } else {
    set msg [lrange $options($cmd,$opt) 2 end]
    return [join $msg]
  }
}

proc get_opt_val {cmd opt} {
  variable options
  if {[catch {set val [lindex $options($cmd,$opt) 4]}]} {
    return 0
  } else {
    set i 5
    while {[lindex $options($cmd,$opt) $i] ne ""} {
      set val [linsert $val end [lindex $options($cmd,$opt) $i]]
      incr i
    }
    return $val
  }
}

####  Check if item is a valid option for the command
####  Return:
####  0:  Undefined or invalid value
####  1:  Valid value for cmd & option
proc check_opt {cmd item} {
  variable options

  set opts [array names options "${cmd},*"]
  foreach x $opts {
    regsub ${cmd}, $x "" x
#    if {[regexp -- $x $item] && [regexp -- ${item}.* $options($cmd,$x)]} {}
    if {[regexp -- [get_exp $cmd $x] $item] && [regexp -- ${item}.* $x]} {
      return 1
    }
  }
  return 0
}

####  Check if item_l are all valid options for the cmd
####  Return:
####  0:  There is an invalid or ambiguous option
####  1:  All options in item_l are valid for cmd
proc check_opt_all {cmd item_l} {
  variable options
  variable fdc_file
  variable fdc_line

  set opts [array names options "${cmd},*"]
  set opt_inx_l [lsearch -all -regexp $item_l {^-}]
  foreach i $opt_inx_l {
    set good 0
    set item [lindex $item_l $i]
    foreach x $opts {
      regsub ${cmd}, $x "" x
#      if {[regexp -- $x $item] && [regexp -- ${item}.* $options($cmd,$x)]} {}
      if {[regexp -- [get_exp $cmd $x] $item] && [regexp -- ${item}.* $x]} {
        set good 1
      }
    }
    if {!$good} {
      log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, $cmd, invalid or ambiguous option: $item"
      return 0
    }
  }
  return 1
}

####  Check if item_l has any (valid) options that will be defaulted
####  to a specific value regardless of the given value
proc check_opt_default {cmd item_l} {
  variable options
  variable fdc_file
  variable fdc_line

  set opts [array names options "${cmd},*"]
  set opt_inx_l [lsearch -all -regexp $item_l {^-}]
  foreach i $opt_inx_l {
    set item [lindex $item_l $i]
    foreach o $opts {
      regsub ${cmd}, $o "" o
      if {[check_opt_is $cmd $o $item] && [get_type $cmd $o] eq "default"} {
        log_puts "@N: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|$cmd, option $o defaults to \"[get_opt_val $cmd $o]\""
      }
    }
  }
}

####  Check if item_l has any (valid) options that will be ignored
proc check_opt_ignore {cmd item_l} {
  variable options
  variable fdc_file
  variable fdc_line

  set opts [array names options "${cmd},*"]
  set opt_inx_l [lsearch -all -regexp $item_l {^-}]
  foreach i $opt_inx_l {
    set item [lindex $item_l $i]
    foreach o $opts {
      regsub ${cmd}, $o "" o
      if {[check_opt_is $cmd $o $item] && [get_type $cmd $o] eq "ignore"} {
        log_puts "@W: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|$cmd, option $o will be ignored"
      }
    }
  }
}

####  Check if item_l has any (valid) options that are not supported
proc check_opt_unsup {cmd item_l} {
  variable options
  variable fdc_file
  variable fdc_line

  set val 0
  set opts [array names options "${cmd},*"]
  set opt_inx_l [lsearch -all -regexp $item_l {^-}]
  foreach i $opt_inx_l {
    set item [lindex $item_l $i]
    foreach o $opts {
      regsub ${cmd}, $o "" o
      if {[check_opt_is $cmd $o $item]} {
        if {[get_type $cmd $o] eq "unsup"} {
          log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|$cmd, option $o is not supported"
          set val 1
        } elseif {[get_type $cmd $o] eq "unsup_msg"} {
          log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|$cmd, option $o is not supported.  [get_unsup_msg $cmd $o]"
          set val 1
        }
      }
    }
  }
  return $val
}

####  Check if item_l has any (valid) options that are mutually exclusive
proc check_opt_excl {cmd item_l} {
  variable options
  variable fdc_file
  variable fdc_line

  set val 0
  set opts [array names options "${cmd},*"]
  set opt_inx_l [lsearch -all -regexp $item_l {^-}]
  foreach i $opt_inx_l {
    set item [lindex $item_l $i]
    foreach o $opts {
      regsub ${cmd}, $o "" o
      if {[check_opt_is $cmd $o $item] && [get_type $cmd $o] eq "excl"} {
        set xopts [get_type_val $cmd $o]
        foreach x $xopts {
          if {[check_opt_l $cmd $x $item_l]} {
            log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|$cmd, option $o and option $x are mutually exclusive"
            set val 1
          }
        }
      }
    }
  }
  return $val
}

####  Check if item is the given valid command & option-expression.
####  This is the check that allows specifying abbreviated options
####  on the command line.
####  Return:
####  0:  Undefined or invalid value
####  1:  Valid value for cmd & option
proc check_opt_is {cmd opt item} {
  variable options

  if {[catch {set foo $options($cmd,$opt)}]} {
    return 0
  }
#  if {[regexp -- $exp $item] && [regexp -- ${item}.* $options($cmd,$exp)]} {}
  if {[regexp -- [get_exp $cmd $opt] $item] && [regexp -- ${item}.* $opt]} {
    return 1
  } else {
    return 0
  }
}

####  Check if item_l contains the given valid command & option-expression
####  Return:
####  0:  Undefined or invalid value
####  1:  Valid value for cmd & option
proc check_opt_l {cmd opt item_l} {
  variable options

  if {[catch {set foo $options($cmd,$opt)}]} {
    return 0
  }
  foreach x $item_l {
#    if {[regexp -- $exp $x] && [regexp -- ${x}.* $options($cmd,$exp)]} {}
    if {[regexp -- [get_exp $cmd $opt] $x] && [regexp -- ${x}.* $opt]} {
      return 1
    }
  }
  return 0
}

####  Check if item is a valid value for the given command & option-expression
####  If checking item for <list>, <list_c>, or <col>, item should come in as a
####  list.  E.g., "check_opt_val all_fanout {-fr.*} [split [join [lindex $args <index>]]]"
####  Return:
####  0:  Undefined or invalid value
####  1:  Valid value for cmd & option
####  2:  Valid collection value for cmd & option
####
proc check_opt_val {cmd opt item} {
#  variable options_val
  variable options

  if {[catch {set val [get_opt_val $cmd $opt]}]} {
    return 0
  }
  if {$val eq "<list>"} {
    if {[lsearch -regexp $item {^s:[0-9]+$}] != -1 || [llength $item] == 0 || [lsearch -regexp $item {-}] != -1} {
      return 0
    } else {
      return 1
    }
  }
  if {$val eq "<list_c>" || $val eq "<col>"} {
    if {[lsearch -regexp $item {^s:[0-9]+$}] != -1} {
      return 2
    } elseif {$val eq "<list_c>" && [llength $item] != 0 && [lsearch -regexp $item {-}] == -1} {
      return 1
    } else {
      return 0
    }
  }
  if {$val eq "<int>"} {
    if {[regexp {^[0-9]+$} $item]} {
      return 1
    } else {
      return 0
    }
  }
  if {$val eq "<float>"} {
    if {[regexp {^[0-9\.]+$} $item]} {
      return 1
    } else {
      return 0
    }
  }
  if {$val eq "<strg>"} {
    if {![regexp {^s:} $item]} {
      return 1
    } else {
      return 0
    }
  }
#### Last option, check a list of explicit values  ####
  foreach x $val {
    if {$item eq $x} {
      return 1
    }
  }
  return 0
}


#############################################################################
##### all_fanout   ####
#############################################################################
proc all_fanout {args} {
  variable port
  variable pin
  variable inst
  variable seq
  variable fdc_file
  variable fdc_line

#  set opts_w_val_exp_s {(-fr.*|-l.*|-t.*)+}
#  set opts_other_exp_s {(-en.*|-ex.*|-b.*|-o.*|-fl.*)+}
  set opts_w_val_exp_s [get_opts_w_val_exp all_fanout]
  set opts_other_exp_s [get_opts_other_exp all_fanout]

  synplify_set_sdc_where 1

#### Check that all in argument list are valid options
  if {![check_opt_all all_fanout $args]} {
    return {}
  }

#### Check for required options and exclusivity, -from and -clock_tree
  if {(![check_opt_l all_fanout {-from} $args] && ![check_opt_l all_fanout {-clock_tree} $args]) || \
       [check_opt_excl all_fanout $args]} {
    log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, all_fanout, must specify one of the following: -clock_tree OR -from <list>"
    return {}
  } 
  set clk_tree [check_opt_l all_fanout {-clock_tree} $args]

#### Assign values to variables while also checking validity of the value types
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set col 0
  set obj_l {} 
  set level 0
  set type "all"
  foreach x $opt_inx_l {
#### -from option
    if {[check_opt_is all_fanout {-from} [lindex $args $x]]} {
      set check [check_opt_val all_fanout {-from} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 2} {
        set col [lindex $args [expr $x + 1]]
      } elseif {$check == 1} {
        set obj_l [split [join [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]]]
        if {[lsearch -all -regexp $obj_l {^[^.:]{2,}}] ne {}} {
          log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, all_fanout, objects require qualifiers {i:, t:, p:, n:}"
          return {}
        }
      } else {
        log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, all_fanout, must be: -from <col or obj_list>"
        return {}
      }
    } 
#### -levels option
    if {[check_opt_is all_fanout {-levels} [lindex $args $x]]} {
      set check [check_opt_val all_fanout {-levels} [lindex $args [expr $x + 1]]]
      if {$check == 1} {
        set level [lindex $args [expr $x + 1]]
      } else {
        log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, all_fanout, must be: -levels <int>"
        return {}
      }
    } 
#### -trace_arcs option
    if {[check_opt_is all_fanout {-trace_arcs} [lindex $args $x]]} {
      set check [check_opt_val all_fanout {-trace_arcs} [lindex $args [expr $x + 1]]]
      if {$check == 1} {
        set type [lindex $args [expr $x + 1]]
        if {$type eq "timing"} {
          log_puts "@W: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Warning, all_fanout, \"-trace_arcs timing\" not supported, defaulting to \"-trace_arcs all\" "
          set type "all"
        }
      } else {
        log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, all_fanout, must be: -trace_arcs <all or timing>"
        return {}
      }
    }
  }
  set end_points ""
  set port "-port"
  set inst ""
  set seq ""
  set pin "-pin"
  set excl_bb 0
  set break_bb 0
  set cells ""
  set flat 0
  set opt_inx_l [lsearch -all -regexp $args $opts_other_exp_s]
  foreach x $opt_inx_l {
    if {[check_opt_is all_fanout {-endpoints_only} [lindex $args $x]]} {
      set end_points "-seq -port"
    }
    if {[check_opt_is all_fanout {-exclude_bboxes} [lindex $args $x]]} {
      set excl_bb 1
      log_puts "@W: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Warning, all_fanout, ignoring option \"-exclude_bboxes\" "
    }
    if {[check_opt_is all_fanout {-break_on_bboxes} [lindex $args $x]]} {
      set break_bb 1
      log_puts "@W: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Warning, all_fanout, ignoring option \"-break_on_bboxes\" "
    }
    if {[check_opt_is all_fanout {-only_cells} [lindex $args $x]]} {
      set cells "-inst"
    }
    if {[check_opt_is all_fanout {-flat} [lindex $args $x]]} {
      set flat 1
    }
  }
  if {$end_points ne "" && $cells ne ""} {
    set end_points "-seq"
    set cells ""
    set port ""
    set pin ""
    set inst ""
    set seq "-seq"
  } elseif {$end_points ne "" && $cells eq ""} {
    set port "-port"
    set pin "-pin"
    set inst ""
    set seq "-seq"
  } elseif {$end_points eq "" && $cells ne ""} {
    set port ""
    set pin ""
    set inst "-inst"
    set seq ""
  } elseif {$end_points eq "" && $cells eq ""} {
    set end_points "-port"
    set cells "-pin"
  }

#### Construct an expand command that will run for every element for -clock_tree or -from <col or obj_list>.
#### The actual expand is always -flat (equivalent to expand -hier), but if -flat is not specified, only objects in the 
#### hierarchy of each start point are returned.  If -only_cells is NOT specified, only pins and ports are 
#### returned; nets are never returned.  If -flat is specified, don't return hierarchical ports.
####

  if {$clk_tree} {
    set obj_l [c_list [find -port * -in [expand -level 1 -port -to [find -net * -filter {@is_clock}]] -filter {@direction == input}]]
#    set obj_l [split [join [timing_corr_aux::all_fanin -flat -start -to [find -pin *.* -filter {@is_clock && @direction == input}]]]]
  } else {
    if {$col ne "0"} {
      set obj_l [c_list $col]
    }
  }
  foreach x $obj_l {
    if {![regexp {^.:} $x]} {
      continue
    }
    if {[regexp {^p:} $x]} {
      if {[sizeof_collection [find -port $x -filter {@direction == output}]]} {
        continue
      }
    }
    set curr_inst $x
    if {[regexp {^p:} $curr_inst] || ![regsub -all {\.} $curr_inst "." foo]} {
      set curr_inst ""
    } else {
      regsub {\.[^\.]+$} $curr_inst "." curr_inst
      if {[regexp {^t:} $curr_inst]} {
        regsub {(.:|\.)[^\.]+.$} $curr_inst "." curr_inst
      }
      regsub {^.:} $curr_inst "" curr_inst
    }
    regsub {^\.$} $curr_inst "" curr_inst
    set exp_hier_p "\[expand -hier -level $level $pin $port -from \{$x\}\]"
    set find_flat_p "\[find $pin $port $curr_inst*.*\]"
    set exp_hier_inst "\[expand -hier -level $level $seq $inst -from \{$x\}\]"
    set find_flat_inst "\[find $seq $inst $curr_inst*\]"
    set filt_seq_pin "-filter {@clock && @direction == input}"
    set filt_no_hier "-filter {!@is_hierarchical}"
    set find_p_in "find $pin $port * -in"
    set find_inst_in "find $seq $inst * -in"
    if {$flat} {
      if {$port eq "-port" && $seq eq "-seq"} {
        set exp_str "$find_p_in $exp_hier_p $filt_seq_pin"
      } elseif {$port eq "-port"} {
        set exp_str "$find_p_in $exp_hier_p"
      } else {
        set exp_str "$find_inst_in $exp_hier_inst $filt_no_hier"
      }
####  For no -flat option, only return where hier and no hier intersect
    } else {
      if {$port eq "-port" && $seq eq "-seq"} {
        set exp_str "$find_p_in \[c_intersect $exp_hier_p $find_flat_p\] $filt_seq_pin"
      } elseif {$port eq "-port"} {
        set exp_str "$find_p_in \[c_intersect $exp_hier_p $find_flat_p\]"
      } else {
        set exp_str "$find_inst_in \[c_intersect $exp_hier_inst $find_flat_inst\] $filt_no_hier"
      }
    } 

    if {![catch {set foo $expd_rslt}]} {
      set expd_rslt [add_to_collection $expd_rslt [eval $exp_str]]
    } else {
      set expd_rslt [eval $exp_str]
    }
#### Process collection (for each iteration) per filter options 
    if {!$clk_tree} {
      set expd_rslt [remove_from_collection $expd_rslt $x]
    }
  }
  if {[catch {set foo $expd_rslt}]} {
    set expd_rslt [find 1]
  }
  return $expd_rslt
}


#######################################################################################
##### all_fanin    ####
#######################################################################################
proc all_fanin {args} {
  variable port
  variable pin
  variable inst
  variable seq
  variable fdc_file
  variable fdc_line

#  set opts_w_val_exp_s {(-to.*|-l.*|-tr.*)+}
#  set opts_other_exp_s {(-s.*|-e.*|-b.*|-o.*|-fl.*)+}
  set opts_w_val_exp_s [get_opts_w_val_exp all_fanin]
  set opts_other_exp_s [get_opts_other_exp all_fanin]
  synplify_set_sdc_where 1

#### Check that all in argument list are valid options
  if {![check_opt_all all_fanin $args]} {
    return {}
  }

#### Check for required options and exclusivity, -from and -clock_tree
  if {![check_opt_l all_fanin {-to} $args]} {
    log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, all_fanin, must specify -to <list>"
    return {}
  }
#### Assign values to variables while also checking validity of the value types
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set col 0
  set obj_l {} 
  set level 0
  set type "all"
  foreach x $opt_inx_l {
#### -to option
    if {[check_opt_is all_fanin {-to} [lindex $args $x]]} {
      set check [check_opt_val all_fanin {-to} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 2} {
        set col [lindex $args [expr $x + 1]]
      } elseif {$check == 1} {
        set obj_l [split [join [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]]]
        if {[lsearch -all -regexp $obj_l {^[^.:]{2,}}] ne {}} {
          log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, all_fanin, objects require qualifiers {i:, t:, p:, n:}"
          return {}
        }
      } else {
        log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, all_fanin, must be: -to <col or obj_list>"
        return {}
      }
    } 
#### -levels option
    if {[check_opt_is all_fanin {-levels} [lindex $args $x]]} {
      set check [check_opt_val all_fanin {-levels} [lindex $args [expr $x + 1]]]
      if {$check == 1} {
        set level [lindex $args [expr $x + 1]]
      } else {
        log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, all_fanin, must be: -levels <int>"
        return {}
      }
    } 
#### -trace_arcs option
    if {[check_opt_is all_fanin {-trace_arcs} [lindex $args $x]]} {
      set check [check_opt_val all_fanin {-trace_arcs} [lindex $args [expr $x + 1]]]
      if {$check == 1} {
        set type [lindex $args [expr $x + 1]]
        if {$type eq "timing"} {
          log_puts "@W: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Warning, all_fanin, \"-trace_arcs timing\" not supported, defaulting to \"-trace_arcs all\" "
          set type "all"
        }
      } else {
        log_puts "@E: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Error, all_fanin, must be: -trace_arcs <all or timing>"
        return {}
      }
    }
  }
  set start_points ""
  set port "-port"
  set inst ""
  set seq ""
  set pin "-pin"
  set excl_bb 0
  set break_bb 0
  set cells ""
  set flat 0
  set opt_inx_l [lsearch -all -regexp $args $opts_other_exp_s]
  foreach x $opt_inx_l {
    if {[check_opt_is all_fanin {-startpoints_only} [lindex $args $x]]} {
      set start_points "-seq -port"
    }
    if {[check_opt_is all_fanin {-exclude_bboxes} [lindex $args $x]]} {
      set excl_bb 1
      log_puts "@W: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Warning, all_fanin, ignoring option \"-exclude_bboxes\" "
    }
    if {[check_opt_is all_fanin {-break_on_bboxes} [lindex $args $x]]} {
      set break_bb 1
      log_puts "@W: :\"$fdc_file\":$fdc_line:0:$fdc_line:0|Warning, all_fanin, ignoring option \"-break_on_bboxes\" "
    }
    if {[check_opt_is all_fanin {-only_cells} [lindex $args $x]]} {
      set cells "-inst"
    }
    if {[check_opt_is all_fanin {-flat} [lindex $args $x]]} {
      set flat 1
    }
  }
  if {$start_points ne "" && $cells ne ""} {
    set start_points "-seq"
    set cells ""
    set port ""
    set pin ""
    set inst ""
    set seq "-seq"
  } elseif {$start_points ne "" && $cells eq ""} {
    set port "-port"
    set pin "-pin"
    set inst ""
    set seq "-seq"
  } elseif {$start_points eq "" && $cells ne ""} {
    set port ""
    set pin ""
    set inst "-inst"
    set seq ""
  } elseif {$start_points eq "" && $cells eq ""} {
    set start_points "-port"
    set cells "-pin"
  }

#### Construct an expand command that will run for every element for -to <col or obj_list>.
#### The actual expand is always -flat (equivalent to expand -hier), but if -flat is not specified, only objects in the 
#### hierarchy of each start point are returned.  If -only_cells is NOT specified, only pins and ports are 
#### returned; nets are never returned.  If -flat is specified, don't return hierarchical ports.
####

  if {$col ne "0"} {
    set obj_l [c_list $col]
  }
  foreach x $obj_l {
    if {![regexp {^.:} $x]} {
      continue
    }
    if {[regexp {^p:} $x]} {
      if {[sizeof_collection [find -port $x -filter {@direction == input}]]} {
        continue
      }
    }
    set curr_inst $x
    if {[regexp {^p:} $curr_inst] || ![regsub -all {\.} $curr_inst "." foo]} {
      set curr_inst ""
    } else {
      regsub {\.[^\.]+$} $curr_inst "." curr_inst
      if {[regexp {^t:} $curr_inst]} {
        regsub {(.:|\.)[^\.]+.$} $curr_inst "." curr_inst
      }
      regsub {^.:} $curr_inst "" curr_inst
    }
    regsub {^\.$} $curr_inst "" curr_inst
    set exp_hier_p "\[expand -hier -level $level $pin $port -to \{$x\}\]"
    set find_flat_p "\[find $pin $port $curr_inst*.*\]"
    set exp_hier_inst "\[expand -hier -level $level $seq $inst -to \{$x\}\]"
    set find_flat_inst "\[find $seq $inst $curr_inst*\]"
    set filt_seq_pin "-filter {@clock && @direction == output}"
    set filt_no_hier "-filter {!@is_hierarchical}"
    set find_p_in "find $pin $port * -in"
    set find_inst_in "find $seq $inst * -in"
    if {$flat} {
      if {$port eq "-port" && $seq eq "-seq"} {
        set exp_str "$find_p_in $exp_hier_p $filt_seq_pin"
      } elseif {$port eq "-port"} {
        set exp_str "$find_p_in $exp_hier_p"
      } else {
        set exp_str "$find_inst_in $exp_hier_inst $filt_no_hier"
      }
####  For no -flat option, only return where hier and no hier intersect
    } else {
      if {$port eq "-port" && $seq eq "-seq"} {
        set exp_str "$find_p_in \[c_intersect $exp_hier_p $find_flat_p\] $filt_seq_pin"
      } elseif {$port eq "-port"} {
        set exp_str "$find_p_in \[c_intersect $exp_hier_p $find_flat_p\]"
      } else {
        set exp_str "$find_inst_in \[c_intersect $exp_hier_inst $find_flat_inst\] $filt_no_hier"
      }
    }
    if {![catch {set foo $expd_rslt}]} {
      set expd_rslt [add_to_collection $expd_rslt [eval $exp_str]]
    } else {
      set expd_rslt [eval $exp_str]
    }
#### Process collection (for each iteration) per filter options 
    set expd_rslt [remove_from_collection $expd_rslt $x]
  }
  if {[catch {set foo $expd_rslt}]} {
    set expd_rslt [find 1]
  }
  return $expd_rslt
}

###-----HIGH RELIABILITY BEGIN ------- ###

## _high_rel_cmd_array: Be an array of array such that for any given string value “n”
## a.	high_rel_cmd_array[n] givens an array such that 
## i.	high_rel_cmd_array[n][0] : Corresponds variables in syn_create_err_net command
## ii.	high_rel_cmd_array[n][1] : Corresponds variables in syn_connect command

##unset ::_high_rel_cmd_array
array set ::_high_rel_cmd_array  {}

## Actual caller to C function hook that passes the arguments
## corresponding to syn_create_err_net and syn-connect commands

## Wrapper over the C function to pass the aruguments of commands
## 1. syn_create_err_net and 
## 2. syn_connect

proc syn_highrel_cmd {netName} {
  
  set list_create_err_net $::_high_rel_cmd_array($netName,0)
  set list_connect_net $::_high_rel_cmd_array($netName,1)

  if {$netName != [lindex $list_create_err_net 0] && 
      $netName != [lindex $list_connect_net 0]} {
        ##puts "Error"
		 error [format "syn_highrel_cmd: Net name %s mismatch for -name of syn_create_err_net and -from of syn_connect commands" $netName]
      } else {
        set instName [lindex $list_create_err_net 1]
			#puts "$instName"
        set numPipeLine [lindex $list_create_err_net 2]
			#puts "$numPipeLine"
        set clockNet [lindex $list_create_err_net 3]
			#puts "$clockNet"
        set resetNet [lindex $list_create_err_net 4]
			#puts "$resetNet"
        set setNet [lindex $list_create_err_net 5]
			#puts "$setNet"
        set enable [lindex $list_create_err_net 6]
			#puts "$enable"
        set sSynch [lindex $list_create_err_net 7]
			#puts "$sSynch"
        set fromNet $netName
			#puts "$fromNet"
		set mode [lindex $list_create_err_net 8]
			#puts "$mode"
        set isExisitingNet [lindex $list_create_err_net 9]
			#puts "$isExisitingNet"
        set toNet [lindex $list_connect_net 1]
			#puts "$toNet"

		 synplify_define_high_rel_args $instName $numPipeLine $clockNet $resetNet $setNet $enable $sSynch $fromNet $mode $isExisitingNet $toNet
      }
}

## Sample Inputs are
## -from {n:TMR0vl_mux_out} <net name>
## -from should match the net name in syn_create_err_net -name option
## -to {n:inst_top.EMIP.err_net}   | (OR) {p:inst_top.outpad[0]} | (OR) {t:inst_top.outpad[0]} 
## in case port(p) or pin (t) is specified in -to option, get the asociated net

proc syn_connect {argv} {
	if {[llength $argv] != 4} {
	  puts "Error [llength $argv]";
	  ##error [format "syn_connect: Wrong number of arguments %s for syn_connect. Please see the user manual for correct usage " expr [llength $argv]]
	}
	
	## remove the {} brackets
	regsub -all "\[\{\}]+" $argv " " argv
	regsub -all {\\} $argv {\\\\} argv
	
	##puts "Inside syn_connect" 
	
	## Array corresponding to high_rel_cmd_array[from][1]
	array set _connect {}
	set _connect(from) ""

	for {set i 0} {$i < [llength $argv]} {incr i} {
	  set option [lindex $argv $i]
	  if {$option eq "-from"} {
		incr i
		## sanity check
		if {![regexp "^n:" [lindex $argv $i]]} {
		 puts "Error Pls specify a net "
		  error [format "syn_connect: A net entry is required for -from argument. Please see the user manual for correct usage.\n" ]
		}
		set field [split [lindex $argv $i] ':']
		set netName [lindex $field 1]
		set _connect(from) $netName
	  }
	  if {$option eq "-to"} {
		incr i
		set field [lindex $argv $i]
		set netName $field
		#if {[regexp {^[tpn]:(.*)} $field status netName]} {	
			#puts "net name is $netName\n" 
		#} else { 
			##puts "ERROR - -to is invalid"
			#error [format "syn_connect: Only -n <net>, -p <port> or -t <pin> supported for -to of syn_connect. Please see the user manual for correct usage " ]
		#}	
		## sanity check
		if {$netName eq ""} {
			puts "Error Pls specify an instance "
			error [format "syn_connect: An existing bit port must be specified for -to argument. Please see the user manual for correct usage.\n" ]
		}
		set _connect(to) $netName
	  }
	}

	#parray _connect
	set name $_connect(from)

	set lList {}
	foreach key {from to} {
	  if {[info exists _connect($key)]} {
		set value $_connect($key) 
		lappend lList $value
	  }
	}
	## remove the {} brackets
	regsub -all "\[\{\}]+" $lList "" lList
	regsub -all {\\} $lList {\\\\} lList        
	if {![info exists ::_high_rel_cmd_array($name,1)]} {
	  set ::_high_rel_cmd_array($name,1) $lList
	} else {
		puts "Error command already entered for netname $name"
		error [format "syn_connect:  %s already specified for for syn_connect. " $name]
	}	

	set list2 $::_high_rel_cmd_array($name,1)

	if {$name ne ""} {
	  if {[info exists ::_high_rel_cmd_array($name,0)] && 
			[info exists ::_high_rel_cmd_array($name,1)]} {		
		syn_highrel_cmd $name
	  }
	}
}

## Sample Inputs are
##-name  { TMR0vl_mux_out }  |(OR) {inst_top.TMR0vl_mux_out}
##-inst {i:inst_top.TMR2}
##-err_pipe_num {10}
##-err_clk {n:inst_top.clk}
##-err_reset { n:inst_top.rs}
##-err_set { n:inst_top.set}
##-err_enable { n:inst_top.en}
##-err_synch {True|False|0|1}
##-single_bit|-double_bit|-single_bit -double_bit
proc syn_create_err_net {argv} {

	##if {[llength $argv] != 16} {
	  ##puts "Error [llength $argv]";
	   ##error [format "syn_create_err_net: Wrong number of arguments %s for syn_create_err_net. Please see the user manual for correct usage " expr [llength $argv]]
	##}
	set name_arg ""
	set inst_arg ""
	set num_pipe_arg ""
	set clk_arg ""
	set reset_arg ""
	set set_arg ""
	set enable_arg ""
	set synch_arg "true"
	## For Actel RAM ECC only, which has both single_bit error signal and double_bit error signal
	## mode=0: OR both single_bit and double_bit; mode=1: OR only single_bit; mode=2: OR only double_bit; mode=3: fault injection
	set mode -1
	set isExisitingNet 0
	

	## Array corresponding to high_rel_cmd_array[from][0]
	array set _create_err_net {};
	set _create_err_net(name) ""
	

	## remove the {} brackets
	regsub -all "\[\{\}]+" $argv " " argv
	regsub -all {\\} $argv {\\\\} argv
	
	for {set i 0} {$i < [llength $argv]} {incr i} {
	  set option [lindex $argv $i]
	  if {$option eq "-name"} {
		incr i		
		set name_arg [lindex $argv $i]
		##puts "name_arg $name_arg"
		## if existing net already given 
		### this should be [a-zA-Z]
		if {[regexp "^n:" $name_arg ]} {
		    set name_arg [syn_check_exisiting_element $name_arg "-net"]
			## sanity check
			if {$name_arg eq ""} {
				##puts "Error Pls specify an instance "
				 error [format "syn_create_err_net: Please specify a net argument for -inst for syn_create_err_net. Please see the user manual for correct usage " ]
			}
			set isExisitingNet 1
		}

	  } elseif {$option eq "-err_pipe_num"} {
		incr i		
		set num_pipe_arg [lindex $argv $i]
		##puts "num_pipe_arg $num_pipe_arg"
				
	  } elseif {$option eq "-inst"} {
		incr i
		
		set inst_arg [syn_check_exisiting_element [lindex $argv $i] "-inst"]
		##puts "inst_arg $inst_arg"
		## sanity check
		if {$inst_arg eq ""} {
			##puts "Error Pls specify an instance "
			error [format "syn_create_err_net: Please specify an instance argument for -inst for syn_create_err_net. Please see the user manual for correct usage " ]
		}		
		
	  } elseif {$option eq "-err_clk"} {
		incr i
		set clk_arg [syn_check_exisiting_element [lindex $argv $i] "-net"]
		##puts "clk_arg $clk_arg"
		## sanity check
		if {$clk_arg eq ""} {
			##puts "Error Pls specify an instance "
			error [format "syn_create_err_net: Please specify a net argument for -err_clk for syn_create_err_net. Please see the user manual for correct usage " ]
		}		
		
	  } elseif {$option eq "-err_reset"} {
		incr i
		set reset_arg [syn_check_exisiting_element [lindex $argv $i] "-net"]
		##puts "reset_arg $reset_arg"
		## sanity check
		if {$reset_arg eq ""} {
			##puts "Error Pls specify an instance "
			error [format "syn_create_err_net: Please specify a net argument for -err_reset for syn_create_err_net. Please see the user manual for correct usage " ]
		}		

	  } elseif {$option eq "-err_set"} {
		incr i
		set set_arg [syn_check_exisiting_element [lindex $argv $i] "-net"]
		##puts "set_arg $set_arg"
		## sanity check
		if {$set_arg eq ""} {
		 ##puts "Error Pls specify an instance "
		 error [format "syn_create_err_net: Please specify a net argument for -err_set for syn_create_err_net. Please see the user manual for correct usage " ]
		}
		
	  } elseif {$option eq "-err_enable"} {
		incr i
		set enable_arg [syn_check_exisiting_element [lindex $argv $i] "-net"]
		##puts "enable_arg $enable_arg"
		## sanity check
		if {$enable_arg eq ""} {
		 ## puts "Error Pls specify an instance "
		 error [format "syn_create_err_net: Please specify a net argument for -err_enable for syn_create_err_net. Please see the user manual for correct usage " ]
		}
		
	  } elseif {$option eq "-err_synch"} {
		incr i
		set status [lindex $argv $i]		
		if {[string is boolean $status]} {		  
		  set synch_arg [lindex $argv $i]
		} else {
		   error [format "syn_create_err_net: Only boolean values expected for -err_synch "]
		}
	  } elseif {$option eq "-single_bit"} {
		if {$mode eq -1} {
			set mode 1
		}
		if {$mode eq 2} {
			set mode 0
		}
	  } elseif {$option eq "-double_bit"} {
	  	if {$mode eq -1} {
			set mode 2
		}
		if {$mode eq 1} {
			set mode 0
		}
	  } else {
	     error [format "syn_create_err_net: Invalid option %s " $option]
	  }
	}
	
	if {$mode eq -1} {
		set mode 0
	}

	if { $clk_arg eq "" && $num_pipe_arg ne "" } {
		if { $num_pipe_arg ne "0"} {
			error [format "syn_create_err_net: Use -err_clk to specify a net argument for pipeline stages. See the user manual for proper usage. " ]
		}		
	}
	
	## populate the array
	set _create_err_net(name) $name_arg
	set _create_err_net(err_pipe_num) $num_pipe_arg
	set _create_err_net(inst) $inst_arg
	set _create_err_net(err_clk) $clk_arg
	set _create_err_net(err_reset) $reset_arg
	set _create_err_net(err_set) $set_arg
	set _create_err_net(err_enable) $enable_arg
	set _create_err_net(err_synch) $synch_arg
	set _create_err_net(mode) $mode

	# Print the array 
	##parray _create_err_net

	set name $_create_err_net(name)
	set lList {}
	foreach key {name inst err_pipe_num err_clk err_reset err_set err_enable err_synch mode } {
	  if {[info exists _create_err_net($key)]} {
		set value $_create_err_net($key) 
		lappend lList $value
	  }
	}
	
	if {$isExisitingNet} {
	  lappend lList 1
	} else {
	  lappend lList 0
	}

	if {![info exists ::_high_rel_cmd_array($name,0)]} {
	  set ::_high_rel_cmd_array($name,0) $lList
	  ##puts "Setting the array ";
	} else {
	  ##puts "Error command already entered for netname $name"
	  error [format "syn_create_err_net:  %s already specified for for syn_create_err_net. " $name]
	}
	set llist1 $::_high_rel_cmd_array($name,0)	
	
	if {$name ne ""} {
	  if {[info exists ::_high_rel_cmd_array($name,0)] && 
			[info exists ::_high_rel_cmd_array($name,1)]} {
		puts "Commands populated, procedding to C hook "
		syn_highrel_cmd $name
	  }
	}

}

proc syn_check_exisiting_element {argv objectType} {
 set object_name ""
 set WARN_ID ""
 set WARN_MESSAGE ""
 set object ""  

 ## argv can have n:GND or n:VCC
 ## prepare a temporary list that takes them out
 # This can contain nets or insatnces
 set list_of_objects {} 

 

 if {$objectType eq "-net"} {
	## Prepare the list of nets first ignoring ground and VCC
	
	for {set i 0} {$i < [llength $argv]} {incr i} {	
	
		set net_object [lindex $argv $i]
	
		if { [expr { [regexp "n:GND" $net_object] || [regexp "n:VCC" $net_object] || [regexp "n:true" $net_object] || [regexp "n:false" $net_object] } ] == 0 } {
			lappend list_of_objects $net_object 
		}
	}
 } elseif {$objectType eq "-inst"} {
	set list_of_objects $argv 
 } else {
	set WARN_ID "DEFAULT_ID"
	set WARN_MESSAGE "Internal error. Only -net and -inst options allowed for syn_check_existing_element procedure."
 }
 regsub -all {\\} $list_of_objects {\\\\} list_of_objects
 

 if {[llength $list_of_objects] > 1} {
	set WARN_ID "DEFAULT_ID"
	set WARN_MESSAGE "Multiple nets or instances are not allowed."
 }

 if {$WARN_ID eq ""} {
	   
	   set option [lindex $list_of_objects 0]
	   if {$objectType eq "-net"}  {
			#puts "OPTION IS $option "
			set option [split $option ':'] 
		   if {[llength $option] != 2} {
			set WARN_ID "DEFAULT_ID"
			set WARN_MESSAGE "Buses not supported. Please see the user manual for correct usage."
			#puts "Buses not supported. Please see the user manual for correct usage."
			#break ;
	
		}
	   }

	   if {$WARN_ID eq ""} {
		  set object [lindex $list_of_objects 0]
		  ## if instance object 
		  if {[regexp "^i:" $object]} {
	  
		   #set object [lindex [c_list [find -inst [lindex $list_of_objects 0] ] ] 0 ]
	   
		  ## if net object 
		  } elseif {[regexp "^n:" [lindex $list_of_objects 0]]} {
			set object [lindex [c_list [find -net [lindex $list_of_objects 0]]] 0 ]		
	
		  } else {
			set WARN_ID "DEFAULT_ID"
			set WARN_MESSAGE "Only nets or instances are supported. Please see the user manual for correct usage."
			unset object
		  }
	  }
  
   

	 if {$WARN_ID ne ""} {
		process_warning $WARN_ID $WARN_MESSAGE 
	 }
	 if {$object ne ""} {
		#set object_list [split $object ':']
		#set object_name [lindex $object_list 1]
		regexp {[in]:(.*)} $object match1 object_name
	 }
 }
  
 return $object_name
}

###-----HIGH RELIABILITY END ------- ###



# #puts "Done loading .../synplcty/lib/map.tcl"
