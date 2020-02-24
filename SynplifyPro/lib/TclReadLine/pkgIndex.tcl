global tcl_library

set _PACKAGENAME "TclReadLine"
set _LIBFILE     [file join $tcl_library "../${_PACKAGENAME}/${_PACKAGENAME}.tcl"]

package ifneeded $_PACKAGENAME 1.1 [list source ${_LIBFILE}]
