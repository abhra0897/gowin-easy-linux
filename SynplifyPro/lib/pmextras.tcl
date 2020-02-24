# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
# $Header: //synplicity/ui2019q3p1/uitools/pm/pmextras.tcl#1 $ 

# Add commands for loading other tcl files here..

proc syn_load_tcl tclfile {
	set loadfile [file join [installinfo libdir] $tclfile ]

	if {[file exists $loadfile]} {
		if {[catch { source $loadfile } errmsg]} {
			message "Error loading $loadfile: $errmsg"
		}
	}
}

syn_load_tcl tclpkg/toolver.tcl
syn_load_tcl pkgIndex.tcl
set shellflavor [ shellname ]
if { $shellflavor == "certify" || $shellflavor == "certbatch" || $shellflavor == "hcprocess" } {
	package require certifyutils
	namespace path "[namespace path] certifyutils"
}
if { $shellflavor == "protobatch" || $shellflavor == "protocompiler" } {
	package require protocompilerutils
	package require conspeed_hstdm
	# User should explicitly load other packages
} else {
	# legacy behavior: in other products, this was previously available in top namespace
	package require netlistutils
	namespace path "[namespace path] netlistutils"
}
