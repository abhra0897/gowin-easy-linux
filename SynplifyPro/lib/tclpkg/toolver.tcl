# $Header: //synplicity/ui2019q3p1/uitools/pm/tclpkg/toolver.tcl#1 $ 

# toolversion returns the version string for the given tool
proc toolversion {args} {
    if { [llength $args] != 1} {
		message "usage: toolversion <tool name>"
		return
    }
	set cmd [lindex $args 0]
	set toolpath [file join [installinfo platformbindir] $cmd]
	if {!([file exists $toolpath] || [file exists $toolpath.exe])} {
		error "No tool $cmd found"
	}
	if [catch {exec $toolpath -version -log $cmd.log} errmsg ] {
		error "Error getting $cmd version info: $errmsg"
	}
	set fh [open $cmd.log]
	set ver [gets $fh]
	close $fh
	file delete $cmd.log
	return $ver
}

# internal only..  caches version
proc __toolversion {cmd printit} {
	upvar toolversions toolversions
	if {! [catch { set ver [toolversion $cmd] } errmsg]} {
		set toolversions($cmd) $ver
		if {$printit} {
			message "$cmd: $toolversions($cmd)\n"
		}
	}
}

# toolversions takes an array var and adds tool name to version
# map for each.
proc toolversions {args} {
	if {[llength $args] < 1} {
		message -puts "
usage:
toolversions <array name> \[1\]

  toolversions will get the version of all
  registered tools and add an entry into
  the array given by the first argument.

  toolversions will print the version of
  each registered tool unless the second
  argument is 1, in which case, it will
  not print anything.

    e.g.   toolversions va
           message -puts \$va(c_ver)
"
		return
    }
	set versionarray [lindex $args 0]
	if [expr [llength $args] > 1] {
		set printit [expr {! [lindex $args 1]}]
	} else {
		set printit 1
	}
	upvar $versionarray toolversions
	# these tools aren't under job control yet..
	set extratools [ list c_ver c_vhdl p_plan nfilter ta ]

	foreach job [ job_list ] {
		set cmd [job_command $job]
		if [info exists alreadyseen($cmd)] {
			continue
		}
		set alreadyseen($cmd) [__toolversion $cmd $printit]
	}

	foreach cmd $extratools {
		if [info exists alreadyseen($cmd)] {
			continue
		}
		set alreadyseen($cmd) [__toolversion $cmd $printit]
	}
}
# http://wiki.tcl.tk/10081
proc file'readable name {
    set rc [catch {open $name} fp]
    if {$rc==0} {close $fp}
    expr {$rc==0}
}
