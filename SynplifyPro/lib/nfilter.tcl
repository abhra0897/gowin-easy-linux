# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
#
#  Utility procs to be used during netlist editing by nfilter
#

#-------------------------------------------------------------------------
# NLE::Help consists of utilities for proc argument definition and parsing
#-------------------------------------------------------------------------
namespace eval NLE::Help {

	namespace export define_proc_attributes parse_proc_arguments help
	variable arguments
	variable arg_options
	variable proc_info


	proc def_proc_args { procname args } {
		variable arguments
		variable arg_options

		foreach arg $args {

			set llen [llength $arg]
			if { $llen < 3 } {
				error "At least three arguments expected for -define_args sublist: $arg"
			}
			set arg_name    [lindex $arg 0]
			set option_help [lindex $arg 1]
			set value_help  [lindex $arg 2]
			set data_type "string"
			set attributes "required"
			if { $llen > 3 } {
				set data_type [lindex $arg 3]
				if {$llen > 4} {
					set attributes [lindex $arg 4]
				}
			}

			lappend arguments($procname) $arg_name
			set arg_options($procname,$arg_name) [list $option_help $value_help $data_type $attributes]
		}
	}

	proc init { } {
		def_proc_args define_proc_attributes \
			{-info Info Info} \
			{-define_args "Arguments list" ""}
		
	}

#-------------------------------------------------------------------------
#  TCL implementation of define_proc_attributes (dc/pt/ etc.)
#  only supports "-info" and "-define_args"
#-------------------------------------------------------------------------
	proc define_proc_attributes { procname args } {

		variable proc_info

		parse_proc_arguments -args $args results

		if { [info exists results(-define_args)] } {
			foreach subarg $results(-define_args) {
				def_proc_args $procname $subarg 
			}
		}
		if { [info exists results(-info)]} {
			set proc_info($procname) $results(-info)
		}

	}

#-------------------------------------------------------------------------
#  parser for the proc arguments
#  must be called in the proc as "parse_proc_arguments -args $args <options>"
#  the options will be saved in the array <options>
#-------------------------------------------------------------------------
	proc parse_proc_arguments { dasharg arglist results } {
		variable arguments
		variable arg_options
		# get calling proc name
		set caller [lindex [info level -1] 0]
		upvar $results rresults
		set cargs $arguments($caller)
		set nextarg ""

		set len [llength $arglist]
		for {set index 0} {$index < $len} {incr index} {
			set arg [lindex $arglist $index]
			if { [string index $arg 0] == "-" } {
				if { ![info exists arg_options($caller,$arg)] } {
					return -code error "Unknown arg: $arg for caller: $caller"
				}
				# type of this arg
				foreach {option_help value_help data_type attrs} $arg_options($caller,$arg) {}
				if { $data_type == "boolean" } {
					set rresults($arg) 1
					continue
				}
				# except boolean all ther args expect the next item in the list
				incr index
				if { $index >= $len } {
					return -code error "Expecting a value for arg: $arg for caller: $caller"
				}
				set value [lindex $arglist $index]
				if { $data_type == "one_of_string" } {
					# check if it's in the list of accepted strings
					set accepted_values ""
					foreach attr $attrs {
						if {[lindex $attr 0] == "values" } {
							set accepted_values [lindex $attr 1]
							break
						}
					}
					if { [lsearch -exact $accepted_values $value] < 0} {
						return -code error "$arg should be one of: $accepted_values, for caller: $caller"
					}
				} elseif { $data_type == "int" } {
					if { ![string is integer -strict $value] } {
						return -code error "Integer value expected for $arg for caller: $caller (instead of $value)"
					}
				} elseif { $data_type == "float" } {
					if { ![string is double -strict $value] } {
						return -code error "Float value expected for $arg for caller: $caller (instead of $value)"
					}
				}
				set rresults($arg) $value
			} 
		}
		# check for required args
		foreach arg $cargs {
			foreach {option_help value_help data_type attrs} $arg_options($caller,$arg) {}
			if {[lsearch -exact $attrs "required"] >= 0 && ![info exists rresults($arg)]} {
				return -code error "Required option $arg for caller: $caller not defined"
			}
		}
	}

#-------------------------------------------------------------------------
# Usage: "help <procname>" : Displays info and arguments of the proc
#-------------------------------------------------------------------------
	proc help { procname } {
		variable arguments
		variable arg_options
		variable proc_info

		if { ![info exists proc_info($procname)] && ![info exists arguments($procname)] } {
			puts_log "No info found for $procname"
			return
		}
		
		if { [info exists proc_info($procname)] } {
			puts_log "$procname: $proc_info($procname)"
		}
		if { [info exists arguments($procname)] } {
			foreach arg $arguments($procname) {
				puts_log "    $arg: $arg_options($procname,$arg)"
			}
		}
	}

	init
}

if { [info commands help] != "" } {
	rename help {}
}
namespace import NLE::Help::*

#-------------------------------------------------------------------------
# Create an empty blackbox with the view name syn_edge_detect
# to be used during insert_gcc command.
#-------------------------------------------------------------------------
proc create_edge_det_cell { } {

	set edgedetcell "syn_edge_detect"

	create_bbox_view $edgedetcell {mas_clk delayed_gen_clk gen_clk} {ena_rise ena_fall}

	set_property -type string v:$edgedetcell syn_edge_detect 1
	set_property -type string v:$edgedetcell ".certify_slp_dont_write_view" 1 ;#Mark as our IP so we dont write it in SLP
}

#-------------------------------------------------------------------------
#  Inserts an edge detection blackbox into the circuit.
#-------------------------------------------------------------------------
proc insert_gcc { args } { 

	global __insert_gcc_count


#
#
# 12.03 removing insert-gcc from product, cleanupi code in 12.09 branch
	return -code error "insert_gcc is no longer supported, please contact Synopsys support for alternatives."
#
	if { [catch _check_gcc] } {
			return -code error "beta_insert_oversample_gcc already used, cannot use insert_gcc with beta_insert_oversample_gcc."
	}
	set options(-div_ratio) 1
	parse_proc_arguments -args $args options
	
	if { ![info exists __insert_gcc_count] } {
		set __insert_gcc_count 0
		create_edge_det_cell
	}

	set m_clk_net [c_list [find -net $options(-master_clk)]]
	
	if { $m_clk_net == "" } {
		return -code error "Master clock net not found: $options(-master_clk)"
	}

	set g_clk_net [c_list [find -net $options(-gen_clk)]]
	
	if { $g_clk_net == "" } {
		return -code error "Generated clock net not found: $options(-gen_clk)"
	}

	if { [info exists options(-delayed_clk)] } {
		set del_clk_net  [c_list [find -net $options(-delayed_clk)]]
		if { $del_clk_net == "" } {
			return -code error "Generated clock net (Delayed) not found: $options(-delayed_clk)"
		}
	} else {
		set del_clk_net $g_clk_net
	}

	set instance inst_edge_det$__insert_gcc_count
	create_instance $instance syn_edge_detect

	set_property -type string i:$instance syn_noprune 1
	set_property -type string i:$instance syn_clock_divide_ratio $options(-div_ratio)
	set_property -type string i:$instance syn_master_edge $options(-direction)

	connect_net $m_clk_net t:${instance}.mas_clk
	connect_net $g_clk_net t:${instance}.gen_clk
	connect_net $del_clk_net t:${instance}.delayed_gen_clk

	incr __insert_gcc_count
}

define_proc_attributes insert_gcc \
	-info "Insert Edge Detection Cell (syn_edge_detect) Instance into the netlist" \
	-define_args {
		{"-master_clk" "Master clock" "Net name" string "required"}
		{"-gen_clk" "Generated clock" "Net name" string "required"}
		{"-direction" "Direction" "" one_of_string {"required" "" {values {"rising" "falling"}}}}
		{"-div_ratio" "Clk divide ratio" "" int optional}
		{"-delayed_clk" "Delayed generated clock" "Net name" string optional}
	}



#---------------------------------------------------------------------
# Wrapper for insert_instance to be used during CGM instantiation
# Creates an instance if the cgmview on the top level netlist
# connecting the ports to the matching nets.
# By default, if a port is not matched to a top level net (by name)
# it will error out. If warnonly arg is set to 1, then it will print
# out a warning instead.
#---------------------------------------------------------------------
proc create_cgm { args } { 
	set errorstyle "error"
	parse_proc_arguments -args $args options
	if { [info exists options(-warnonly)] } {
		set errorstyle "warning"
	}
	insert_instance $options(-inst) $options(-view) $errorstyle
	set_property -type integer i:$options(-inst) syn_noprune 1
}

define_proc_attributes create_cgm \
	-info "Insert a CGM instance to the netlist" \
	-define_args {
		{"-inst" "Instance name" "" string "required"}
		{"-view" "View name" "" string "required"}
		{"-warnonly" "Do not error out for mismatched port/nets" "" boolean "optional"}
	}

#---------------------------------------------------------------------
# creates a new dummy net in the current context and returns the name
#---------------------------------------------------------------------
proc create_dummy_net { {prefix N} } {
	set index 1
	while { [catch "create_net ${prefix}$index"] } {
		incr index
	}
	return n:${prefix}$index
}


#---------------------------------------------------------------------
# disconnects the port from the net it is currently connected to
#---------------------------------------------------------------------
proc disconnect_port { port } {
	disconnect_connector $port
	# we need to create a dummy net to connect the dangling port
	# o.w. it won't actually be disconnected
	connect_net [create_dummy_net] $port
}	

#---------------------------------------------------------------------
# finds all the pins connected on this net
# disconnects them from the net if they are drivers.
#---------------------------------------------------------------------
proc disconnect_driver { net } {
	set pins [c_list [expand -pin -to $net]]

	foreach pin $pins {
		if { [get_prop -prop direction $pin] == "output" } {
			puts_log "Info: Disconnecting driver pin $pin on net $net."
			disconnect_connector $pin
		}
	}

	set ports [c_list [expand -port -to $net]] 

	foreach port $ports {
		if { [get_prop -prop direction $port] == "input" } {
			puts_log "Info: Disconnecting driver port $port on net $net."
			disconnect_port $port
		}
	}
}


#---------------------------------------------------------------------
# The view is instantiated with this command
# The port names must match the top level net names in the design
# The matching nets of the output ports are disconnected from their existing drivers
# Note that these drivers are not deleted here
# If the errortype is other than "error" it will just warn if a matching
# toplevel net not found (e.g.: insert_instance $instname $viewname warning)
#---------------------------------------------------------------------
proc insert_instance { instanceName viewName {errortype "error"} } {

	create_instance $instanceName $viewName

	set instPorts  [c_list [find -pin ${instanceName}.*] ]

	foreach port $instPorts {
		set dotindex [string last . $port]
		incr dotindex
		set netName [string range $port $dotindex end]

		set net [c_list [find -net $netName]]
		if { $net == "" } {
			set msg "Top level net $netName not found." 
			if { $errortype == "error" } {
				remove_instance $instanceName
				return -code error $msg
			} 
			puts_log "Warning: $msg. The port $port is left unconnected."
			continue
		}
		if { [get_prop -prop direction $port] == "output" } {
			disconnect_driver $net
		}

		connect_net $net $port
	}
}


#---------------------------------------------------------------------
#  create a black box view with the name viewName 
#---------------------------------------------------------------------
proc create_bbox_view { viewName inPorts outPorts } {

	# TODO: check for existance of the view
	set cur_view [get_current_view]

	create_cell $viewName

	define_current_view $viewName

	foreach iport $inPorts {
		create_port $iport -direction in
		create_net $iport
		connect_net n:$iport p:$iport
	}
	foreach oport $outPorts {
		create_port $oport -direction out
		create_net $oport
		connect_net n:$oport p:$oport
	}
	define_current_view $cur_view

	set_property -type integer v:$viewName syn_black_box 1
	set_property -type string v:$viewName syn_hier "hard"
}


set nfilter_rcfile [file normalize ~/.nfilterrc]
if { [file exists $nfilter_rcfile] } {
	if { [catch "source $nfilter_rcfile" msg] } {
		puts_log "Ignoring error sourcing $nfilter_rcfile : $msg"
	}
}
