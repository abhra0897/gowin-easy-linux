# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
# TCL commands to load mapper constraints into SCOPE editor in UI
#

# timing exceptions
#
proc set_false_path { args } {
	eval [concat add_fdc_constraint set_false_path $args];
}
proc set_max_delay { args } {
	eval [concat add_fdc_constraint set_max_delay $args];
}
proc set_min_delay { args } {
	eval [concat add_fdc_constraint set_min_delay $args];
}
proc set_multicycle_path { args } {
	eval [concat add_fdc_constraint set_multicycle_path $args];
}

proc set_input_delay { args } {
	eval [concat add_fdc_constraint set_input_delay $args];
}

proc set_output_delay { args } {
	eval [concat add_fdc_constraint set_output_delay $args];
}

# clocks
#
proc create_clock { args } {
	eval [concat add_fdc_constraint create_clock $args];
}

proc set_clock_groups { args } {
	eval [concat add_fdc_constraint set_clock_groups $args];
}

# reset_path call
#
proc reset_path {args} {
	eval [concat add_fdc_constraint reset_path $args];
}

# Defines collection for SCOPE
# define_scope_collection [-disable] [-comment <comment>] <collection_name> {<coll_tcl_cmd>}
#
proc define_scope_collection { args } {
	eval [concat add_fdc_constraint define_scope_collection $args];
}

# General attribute mechanism
#
# args: [-disable] object propname str
#
proc define_attribute {args} {
	eval [concat add_fdc_constraint define_attribute $args];
}

#
# Define a module as a compile point. 
# Set a syn_compile_point and syn_hier property on the object
# args: [-disable] [-comment <comment>] <objname> [-type <type>] [-cpfile <CP SDC file>] 
#
proc define_compile_point {args} {
	eval [concat add_fdc_constraint define_compile_point $args];
}


####################################
# TODO: implement these if needed


#
# clock commands
#
#proc derive_clocks { args } {
#	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
#}
#proc derive_pll_clocks { args } {
#	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
#}

#proc set_datapathonly_delay { args } {
#}

#proc create_generated_clock { args } {
#}

# define_reset_path call
#
#proc define_reset_path {args} {
#}

# Set the current design which is the default place to begin object
# path searches from.
# args: [-disable] object
#
#proc define_current_design {args} {
#}

# top level attribute
# args: [-disable] propname str
# This one works just like define_attribute, it has a loop to handle multiple "prop value" pairs.
#proc define_global_attribute {args} {
#}

# Set io standards
# args:[-disable] [-comment <comment> ] <objname>  [-iostandard <iostandard>]
# If the object is -default_input/output/bidir, then set a different sets of 
# properties for each type globally.
#
#proc define_io_standard {args} {
#}

# Define a module as a compile point. 
# Set a syn_compile_point and syn_hier property on the object
# args: [-disable] [-comment <comment>] <objname> [-type <type>] [-cpfile <CP SDC file>] 
#
#proc define_compile_point {args} {
#}

# User timing constraints
#
#proc define_clock {args} {
#}

# Procedure for defining waveform order for waveform viewer.
#
# Definition strorder = {{0:clk1}{1:input1}{0:clk3}}
# define_waveform_order <strorder> 
#

#proc define_waveform_order { clocks} {
#}

# Procedure for defining reference clocks.
#
# Definition
# define_reference_clock [-disable] [-comment <comment>] -name <name> [-rise <rise>]
#						 [-fall <fall>] -period <period> | -freq <freq> [-domain domain]
#
# name and period/frequency are mandatory requirements.
#

#proc define_reference_clock {args} {
#}

#proc define_clock_delay_usage {args} {
#	 error {define_clock_delay usage: [-rise|-fall] <clock1> [-rise|-fall] <clock2> <delay>}
#}

#
# Define delay between clocks edges.
#
#proc define_clock_delay {args} {
#}


#proc define_delay_prop {propbase alist} {
#}

# The delay constraint commands
# Args: [-disable] <object> [ [ , -improve, -route] <delay>, -clock <clockname>]*
#
#proc define_input_delay {args} {
#}

#proc define_output_delay {args} {
#}


#proc set_reg_input_delay {args} {
#}

#proc set_reg_output_delay {args} {
#}

#proc define_reg_input_delay {args} {
#}

#proc define_reg_output_delay {args} {
#}

#proc define_multicycle_path {args} {
#}

#proc define_false_path {args} {
#}

# Implementation for floorplanning region to region constraint
#proc define_region_delay { args } {
#}

# base implementation for tpd tco tsu timing arcs
#proc _define_timing_arc { cmd base alist } {
#}

# define timing arc from input pin to output pin.
#proc define_tpd {args} {
#	 _define_timing_arc define_tpd syn_tpd $args
#}

# define setup arc from input pin to clock pin
#proc define_tsu {args} {
#	 _define_timing_arc define_tsu syn_tsu $args
#}

#define clock to output arc
#proc define_tco {args} {
#	 _define_timing_arc define_tco syn_tco $args
#}

# Defines net delay in Certify and Floorplanner
# define_route_delay netname rgn value
#
#proc define_route_delay { args } {
#}

# Definition
# define_load [-disable] [-comment <comment>] [-pin_load value] [-wire_load value] port
# At least one among pin_load and wire_load should be present
#
#proc define_load { args } {
#}

# Definition
# define_driving_cell [-disable] [-comment <comment>] port [-library value] -lib_cell cellname [-pin pinname]
# The -lib_cell must be given
#
#proc define_driving_cell { args } {
#}
# equivalent of define_path_delay -max
#proc define_max_delay { args } {
#}

# equivalent of define_path_delay -min
#proc define_min_delay { args } {
#}

# Definition
# define_path_delay [-disable] [-comment <comment>] [-from from_inst] [-through thro_inst] [-to to_inst] -max max_dly -min min_dly
# through is not a documented option and cant be handled in the timing engine. Through handling is a place holder for future.
# Similar scheme as multi/false path handling. Set a global attribute on the top level which has details and set an id on objects.

#proc define_path_delay { args } {
#}

# Definition
# define_report_path [-disable] [-comment <comment>] [-from from_inst] [-through thro_inst] [-to to_inst]
# 
# This constraint is used for marking paths that should be reported.
#proc define_report_path {args} {
#}

# Definition
# define_watch_path [-disable] [-comment <comment>] [-from from_inst] [-to to_inst]
# 
# This constraint is used for marking paths that should be reported.

#proc define_watch_path {args} {
#}

# Define the netlist used for module constraint file
#
#proc define_module_netlist {args} {
#}

#proc define_generated_clock_en { args } {
#}

#proc define_clock_uncertainty {args} {
#	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
#}

#proc set_clock_uncertainty {args} {
#}

#proc define_clock_latency {args} {
#	addConstraint2Database [lindex [info level 0] 0] [lrange [info level 0] 1 end]
#}
