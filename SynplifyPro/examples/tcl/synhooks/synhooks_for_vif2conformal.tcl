#$Header: //synplicity/mapgw/examples/synhooks_for_vif2conformal.tcl#1 $

# The following script is useful to setup automatic conversion of Synplify Pro generated 
# <design>.vif file to Conformal specific side files.

# To setup automatic vif2conformal conversion at the end of each Synthesis run
# set the environment variable SYN_TCL_HOOKS to point to this file.
# e.g
# SYN_TCL_HOOKS=<your path>/synhooks_for_vif2conformal.tcl
# 
# Alternatively you can source this file in the Synplify Pro tcl window to setup automatic conversion.
# Note: If you are using the alternative method, you will have to source this file in every instance
# of Synplify Pro. The automatic conversion setup will be lost once you close that particular Synplify Pro
# window. If you restart Synplify Pro, you will have to re-source this file to setup automatic conversion.

proc syn_on_end_run {runName run_dir implName} {

# runName:      Name of the run Ex: compile, synthesis 
# run_dir:      Current run directory.
# implName:     Implementation Name Ex:rev_1

 puts "*** syn_on_end_run called. Options: $runName, $run_dir $implName"
# TODO: Add your custom code here

# Set environment Variables
global env
global LIB
 
# Check if the vif file was created
cd $run_dir
if {[catch {set v [glob verif/*.vif]} msg]} {
	puts "Error: No vif file found"
	} else { puts "Found vif file: $v"}

# Commands to convert vif to conformal specific files
puts "** Start of vif2conformal conversion **"
	cd $run_dir/verif
	source $LIB/vif2conformal.tcl
	set vif_file [glob *.vif]
puts "Converting file: $vif_file"
vif2conformal $vif_file
puts "** End of vif2conformal conversion **"
cd ../
}
