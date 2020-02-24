# $Header: //synplicity/ui2019q3p1/uitools/pm/tclpkg/netlist_utils.tcl#1 $
# general netlist utils
package provide netlistutils 15.03
namespace eval netlistutils {

namespace export bitblast intersect

proc bitblast {inp} {
  # returns a list of the passed value bit blasted if bus is passed
  # v 1.49 - Allowed for comma separated indices
  # v 1.48 - fixed issue with empty input
  # v 1.46 - now accepts a list as input
  if {[llength $inp] == 0} {
    return ""
  }
  foreach inp_elem $inp {
    # let's process commas in the indices here if needed
    set commacheck [regexp {^([^\[]+)\[.+,} $inp_elem all busname]
    if {$commacheck} {
      regsub -all { } $inp_elem {} inp_elem
      regsub -all {,} $inp_elem "\] $busname\[" commalist
    } else {
      set commalist $inp_elem
    }
    foreach commaval $commalist {      
      set rtnval [regexp {\[([0-9]+):([0-9]+)\]$} $commaval all lindex rindex]
      if {$rtnval} {
        set subst_string "$lindex:$rindex\]"
        if {$lindex < $rindex} {
          for {set i $lindex} {$i <= $rindex} {incr i +1} {
            regsub "$subst_string$" $commaval $i\] bitblast
            lappend rtnlist $bitblast
          }
        } else {
          for {set i $lindex} {$i >= $rindex} {incr i -1} {
            regsub "$subst_string$" $commaval $i\] bitblast
            lappend rtnlist $bitblast
          }
        }
      } else {
        lappend  rtnlist $commaval
      }
    }
  }
  return $rtnlist
}

if {[llength [info command install_command_help]] > 0} {
  install_command_help bitblast "bitblast <list> - returns a list of elements with arrays split into individual bits"
}

proc intersect {lista listb} {
  ## returns a list of elements common to both lists
  set rtnlist {}
  ## loop through shortest list
  if {[llength $lista] < [llength $listb]} {
    set baselist $listb
    set forlist  $lista
  } else {
    set baselist $lista
    set forlist  $listb
  }
  foreach elem $forlist {
    # strip any duplicates from rtnlist while processing
    if {[lsearch -exact $baselist $elem] > -1 && [lsearch -exact $rtnlist $elem] == -1} {
      lappend rtnlist $elem
    }
  }
  return $rtnlist
}
if {[llength [info command install_command_help]] > 0} {
  install_command_help intersect "intersect <lista> <listb> - returns a list of elements contained in both lists, removing duplicates"
}

if { [shellname] == "protobatch" || [shellname] == "protocompiler" } {
	# because the other tools import it at startup, so message only useful in pc
	puts "netlistutils imported as namespace netlistutils::. Try \"info commands netlistutils::*\""
}
# end namespace:
}
