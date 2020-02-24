# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
# $Header: //synplicity/compdevb/misc/directives.tcl $

# TCL commands to implement constraints
#
# #puts "Loading .../synplcty/lib/directives.tcl"

# Return current version of this file
# See constdoc.cpp::constraint_init()
# Versions of SCOPE >=520 do version checking

proc get_directivetcl_version { } {
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

# In the compiler or linker, this command calls mlog_puts to print the
# argument string to the log file. In SCOPE this command does nothing.
proc comp_log_puts { args } {
     global _lib_

     if [expr [llength $args] < 1] {
         error "Usage: log_puts {string}"
     }

     if {$_lib_ == "SYNPLIFY"} {
        mlog_puts [lindex $args 0]
     }
}

proc comp_warning {arg} {
	comp_log_puts "$arg"
}

#
# set up global variable _lib_
#
set _lib_ "SYNPLIFY"

#
# General attribute mechanism
#
# args: [-disable] object propname str
#
proc define_directive {args} {
	 global _lib_

	if {[lindex $args 1] == "syn_compile_point"} {	
		set args_copy [lindex $args 3]
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
	set object [lindex $args 0]
	set args [lrange $args 1 end]

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
				synplify_write_directives define_directive $object $propname $str
		}
	}
}

#
# General attribute mechanism
#
# args: [-disable] object propname str
#
proc define_attribute {args} {
	comp_warning {@W: Please use define_directive instead of define_attribute.} 
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
	set args [lrange $args 1 end]

	set propname [lindex $args 0]
	if { [ string length "$propname" ] == 0 } {
		# propname is NIL
		return
	}
	set args [lrange $args 1 end]

	set str [lindex $args 0]
	define_directive $object $propname $str
}

#
# General attribute mechanism
#
# args: [-disable] object propname str
#
proc set_attribute {args} {
	comp_warning {@W: Please use define_directive instead of define_attribute.} 
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
	set args [lrange $args 1 end]

	set propname [lindex $args 0]
	if { [ string length "$propname" ] == 0 } {
		# propname is NIL
		return
	}
	set args [lrange $args 1 end]

	set str [lindex $args 0]
	define_directive $object $propname $str
}
