# utilities for Internal testing in Tcl
# much of this is based on googletest APIs. see https://code.google.com/p/googletest/

# $Header: //synplicity/ui2019q3p1/uitools/pm/tclpkg/testutils.tcl#1 $
package provide testutils 15.04

namespace eval testutils {
	# you can try this by issuing the commands:
	#   package require testutils
	#   eval $testutils::example
	set example {
		package require testutils
		namespace path testutils
		set mylist "a b c"
		EXPECT_EQ 3 [llength $mylist]
		EXPECT_LIST_CONTAINS b $mylist
		# with custom message:
		EXPECT_EQ 3 [llength $mylist] "mylist was $mylist"
		proc methrowerror {args} {
			puts $args
			return -code error "I threw an error"
		}
		set v 4.5
		EXPECT_TRUE [expr $v < 5 && $v > 4 && $v != 4.4 ] "complex test failed"
		EXPECT_RANGE 4.4 $v 4.6 "range test failed"
		ASSERT_RANGE 4.4 $v 4.6 "range test failed"
		EXPECT_FAIL_MSG {methrowerror a b c} "*an error*"
		if {1} {
			ADD_FAILURE "standard error message for custom condition"
		}
	}
}

#
# by default, proc's go into the pw namespace so they can be versioned.
# without the namespace, there is no way to "unload" them.
namespace eval testutils {
	namespace export FullFrameInfo GetScriptLine GetScriptLineVerbose PrintStack
	namespace export EXPECT_EQ ASSERT_EQ EXPECT_NE ASSERT_NE EXPECT_TRUE ASSERT_TRUE
	namespace export EXPECT_LT ASSERT_LT EXPECT_LTE ASSERT_LTE
		# looking for EXPECT_FALSE? only "0" is FALSE in Tcl, use ASSERT_EQ(0,val)
	namespace export EXPECT_FAIL EXPECT_FAIL_MSG ASSERT_FAIL
	namespace export EXPECT_LIST_CONTAINS ASSERT_LIST_CONTAINS
	namespace export EXPECT_STRING_MATCH ASSERT_STRING_MATCH
	namespace export EXPECT_STRING_NO_MATCH ASSERT_STRING_NO_MATCH
	# For standard error messages in custom conditions:
	namespace export ADD_FAILURE FAIL
	# there is no reason to call this now. legacy test only:
	namespace export EXIT
	namespace export selftest numerrors showfullpath showstack showfailmsgs

	# numerrors tracks number of EXPECTS that failed (or ASSERTS that were caught)
	set numerrors 0
	# print full path to script in stacks
	set showfullpath 0
	# show full stack on error. Useful for debugging. Leave it off normally
	set showstack 0
	# print error message from EXPECT_FAIL or ASSERT_FAIL:
	set showfailmsgs 1
	# this is the standard return code form Tclsh when there was an error:
	set TCL_ERROR_CODE 9

	proc GetProc {frameinfo} {
		set procidx [lsearch $frameinfo proc]
		if { $procidx >=0 } { return [lindex $frameinfo [incr procidx]] }
		return ""
	}
	proc GetCmd {frameinfo} {
		set cmdidx [lsearch $frameinfo cmd]
		if { $cmdidx >=0 } { return [lindex $frameinfo [incr cmdidx]] }
		return ""
	}

	# print a human readable frameinfo for the Tcl line N levels above the caller
	proc GetScriptLine {numlevelup} {
		global testutils::showfullpath
		incr numlevelup
		set frameinfo [info frame -$numlevelup]
		set tt [lindex $frameinfo 1]
		if { $tt == "source" } {
			set line [lindex $frameinfo 3]
			set fn [lindex $frameinfo 5]
			if { "$testutils::showfullpath" == 0 } {
				set fn [file tail $fn]
			}
			return "$fn:$line"
		}
		if { $tt == "eval" } {
			# eval might mean we are inside a loop or if statement
			set line [lindex $frameinfo 3]
			incr numlevelup
			if { $numlevelup < [info frame] } {
				set callerinfo [GetScriptLine $numlevelup]
				set fileline [split $callerinfo :]
				if { [llength $fileline] == 2 } {
					set line [expr $line + [lindex $fileline 1] - 1]
					set fn [lindex $fileline 0]
					return "$fn:$line"
				}
				return "line $line inside condition at $callerinfo"
			}
			return "eval at top level"
		}
		return "$tt"
	}
	# like GetScriptLine, but also prints any proc we were in
	proc GetScriptLineProc {numlevelup} {
		incr numlevelup
		set sl [GetScriptLine $numlevelup]
		set frameinfo [info frame -$numlevelup]
		set procstr [GetProc $frameinfo]
		return "$sl $procstr"
	}
	# like GetScriptLine, but also prints contents of line and any proc we were in
	proc GetScriptLineVerbose {numlevelup} {
		incr numlevelup
		set sl [GetScriptLine $numlevelup]
		set frameinfo [info frame -$numlevelup]
		set cmdstr [GetCmd $frameinfo]
		set procstr [GetProc $frameinfo]
		return "$sl $cmdstr $procstr"
	}

	# print a Tcl stack trace
	proc PrintStack {} {
		set fnum [info frame]
		puts "Tcl Stack:"
		for {set d 1} {[ expr $fnum - $d] > 0 } {incr d 1} {
			puts "[expr $fnum - $d - 1]: [GetScriptLine $d]"
		}
		return
	}
	proc FullFrameInfo {numlevelup} {
		# level 0 means this proc, so we always want the one above this at least
		incr numlevelup
		return [info frame -$numlevelup]
	}

	# EXPECTS check for errors, but don't stop the tests
	proc EXPECT_EQ {args} {
		set expected [lindex $args 0]
		set actual [lindex $args 1]
		set msg [lrange $args 2 end]
		if { "$expected" == "$actual" } {
			puts "OK: Got \"$expected\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: expected \"$expected\" but got \"$actual\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors 
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}
	proc EXPECT_LT {args} {
		set expected [lindex $args 0]
		set actual [lindex $args 1]
		set msg [lrange $args 2 end]
		if { "$expected" < "$actual" } {
			puts "OK: Got \"$expected\" < \"$actual\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$expected\" was not less than \"$actual\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors 
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}
	proc EXPECT_LTE {args} {
		set expected [lindex $args 0]
		set actual [lindex $args 1]
		set msg [lrange $args 2 end]
		if { "$expected" <= "$actual" } {
			puts "OK: Got \"$expected\" <= \"$actual\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$expected\" was not <= \"$actual\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors 
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}
	proc EXPECT_RANGE {args} {
		set lowerlimit [lindex $args 0]
		set actual [lindex $args 1]
		set upperlimit [lindex $args 2]
		set msg [lrange $args 2 end]
		if { "$lowerlimit" <= "$actual" && "$actual" <= "$upperlimit" } {
			puts "OK: Got \"$lowerlimit\" <= \"$actual\" <= \"$upperlimit\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$actual\" was not in the range \[$lowerlimit, $upperlimit\] on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors 
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}
	proc EXPECT_LIST_CONTAINS {args} {
		set expected [lindex $args 0]
		set mylist [lindex $args 1]
		set msg [lrange $args 2 end]
		if { [ lsearch $mylist $expected] >= 0 } {
			puts "OK: Found \"$expected\" in list on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$expected\" not found in \"$mylist\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}
	proc EXPECT_STRING_MATCH {args} {
		set pattern [lindex $args 0]
		set mystring [lindex $args 1]
		set msg [lrange $args 2 end]
		if { [ string match $pattern $mystring] } {
			puts "OK: Found pattern \"$pattern\" in string on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$pattern\" not found in \"$mystring\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}
	proc EXPECT_STRING_NO_MATCH {args} {
		set pattern [lindex $args 0]
		set mystring [lindex $args 1]
		set msg [lrange $args 2 end]
		if { ! [ string match $pattern $mystring] } {
			puts "OK: no \"$pattern\" found in string on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$pattern\" was found in \"$mystring\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}

	proc EXPECT_NE {args} {
		set expected [lindex $args 0]
		set actual [lindex $args 1]
		set msg [lrange $args 2 end]
		if { "$expected" != "$actual" } {
			puts "OK: \"$expected\" != \"$actual\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: got \"$expected\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}
	proc EXPECT_FAIL {args} {
		set code [set_exit_code]
		set cmd [lindex $args 0]
		set msg [lrange $args 1 end]
		puts -nonewline "Expecting exception:"
		if { [catch { uplevel eval $cmd } errmsg ] } {
			puts "OK: \"$cmd\" threw an exception on [GetScriptLine 1]"
			if {$testutils::showfailmsgs} { puts $errmsg }
			# restore the exit code from before this. A failure was expected.
			set_exit_code $code
			return
		}
		puts "ERROR: \"$cmd\" succeeded on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}
	proc EXPECT_FAIL_MSG {args} {
		set code [set_exit_code]
		set cmd [lindex $args 0]
		set pattern [lindex $args 1]
		set msg [lrange $args 2 end]
		puts -nonewline "Expecting exception:"
		if { [catch { uplevel eval $cmd } errmsg ] } {
			if { [ string match $pattern $errmsg ] } {
				puts "OK: \"$cmd\" threw an exception that matched pattern \"$pattern\" [GetScriptLine 1]"
				if {$testutils::showfailmsgs} { puts $errmsg }
				# restore the exit code from before this. A failure was expected.
				set_exit_code $code
				return
			}
			puts "ERROR: \"$cmd\" threw an exception but the expected error message wasn't found in \"$errmsg\" [GetScriptLine 1]"
		} else {
			puts "ERROR: \"$cmd\" succeeded on [GetScriptLineVerbose 1] $msg"
		}
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}
	proc EXPECT_TRUE {args} {
		set val [lindex $args 0]
		set msg [lrange $args 1 end]
		if { "$val" } {
			puts "OK: \"$val\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: got \"$val\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}
	# looking for EXPECT_FALSE? only "0" is FALSE in Tcl, use ASSERT_EQ(0,val)

	# This generates a non-fatal error message. See FAIL for fatal error message.
	proc ADD_FAILURE {msg} {
		puts "ERROR: on [GetScriptLineProc 1] $msg"
		global testutils::numerrors testutils::showstack testutils::TCL_ERROR_CODE
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors 
		set_exit_code $testutils::TCL_ERROR_CODE
		return
	}

	# ASSERT's stop the test by throwing and error if they fail
	proc ASSERT_EQ {args} {
		set expected [lindex $args 0]
		set actual [lindex $args 1]
		set msg [lrange $args 2 end]
		if { "$expected" == "$actual" } {
			puts "OK: Got \"$expected\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: expected \"$expected\" but got \"$actual\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		return -code error "expected \"$expected\" but got \"$actual\""
	}
	proc ASSERT_LT {args} {
		set expected [lindex $args 0]
		set actual [lindex $args 1]
		set msg [lrange $args 2 end]
		if { "$expected" < "$actual" } {
			puts "OK: Got \"$expected\" < \"$actual\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$expected\" was not less than \"$actual\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		return -code error "expected \"$expected\" < \"$actual\""
	}
	proc ASSERT_LTE {args} {
		set expected [lindex $args 0]
		set actual [lindex $args 1]
		set msg [lrange $args 2 end]
		if { "$expected" <= "$actual" } {
			puts "OK: Got \"$expected\" <= \"$actual\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$expected\" was not <= \"$actual\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		return -code error "expected \"$expected\" < \"$actual\""
	}
	proc ASSERT_RANGE {args} {
		set lowerlimit [lindex $args 0]
		set actual [lindex $args 1]
		set upperlimit [lindex $args 2]
		set msg [lrange $args 2 end]
		if { "$lowerlimit" <= "$actual" && "$actual" <= "$upperlimit" } {
			puts "OK: Got \"$lowerlimit\" <= \"$actual\" <= \"$upperlimit\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$actual\" was not in the range \[$lowerlimit, $upperlimit\] on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors 
		return -code error "value \"$actual\" not withing \[$lowerlimit, $upperlimit\]"
	}

	proc ASSERT_LIST_CONTAINS {args} {
		set expected [lindex $args 0]
		set mylist [lindex $args 1]
		set msg [lrange $args 2 end]
		if { [ lsearch $mylist $expected] >= 0 } {
			puts "OK: Found \"$expected\" in list on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$expected\" not found in \"$mylist\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		return -code error "\"$expected\" not found in list"
	}
	proc ASSERT_STRING_MATCH {args} {
		set pattern [lindex $args 0]
		set mystring [lindex $args 1]
		set msg [lrange $args 2 end]
		if { [ string match $pattern $mystring] } {
			puts "OK: Found pattern \"$pattern\" in string on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$pattern\" not found in \"$mystring\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		return -code error "\"$pattern\" not found in string"
	}
	proc ASSERT_STRING_NO_MATCH {args} {
		set pattern [lindex $args 0]
		set mystring [lindex $args 1]
		set msg [lrange $args 2 end]
		if { ! [ string match $pattern $mystring] } {
			puts "OK: no \"$pattern\" found in string on [GetScriptLine 1]"
			return
		}
		puts "ERROR: \"$pattern\" was found in \"$mystring\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		return -code error "\"$pattern\" was found in string"
	}

	proc ASSERT_NE {args} {
		set expected [lindex $args 0]
		set actual [lindex $args 1]
		set msg [lrange $args 2 end]
		if { "$expected" != "$actual" } {
			puts "OK: \"$expected\" != \"$actual\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: got \"$expected\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		return -code error "got \"$expected\""
	}
	# TODO: ASSERT_FAIL_MSG
	proc ASSERT_FAIL {args} {
		set code [set_exit_code]
		set cmd [lindex $args 0]
		set msg [lrange $args 1 end]
		puts -nonewline "Expecting exception:"
		if { [catch { uplevel eval $cmd } errmsg ] } {
			puts "OK: \"$cmd\" threw an exception on [GetScriptLine 1]"
			if {$testutils::showfailmsgs} { puts $errmsg }
			set_exit_code $code
			return
		}
		puts "ERROR: \"$cmd\" succeeded on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		return -code error "\"$cmd\" succeeded"
	}
	proc ASSERT_TRUE {args} {
		set val [lindex $args 0]
		set msg [lrange $args 1 end]
		if { "$val" } {
			puts "OK: \"$val\" on [GetScriptLine 1]"
			return
		}
		puts "ERROR: got \"$val\" on [GetScriptLineVerbose 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		return -code error "got \"$val\""
	}
	# looking for EXPECT_FALSE? only "0" is FALSE in Tcl, use ASSERT_EQ(0,val)

	# Generate a fatal error message
	proc FAIL {msg} {
		puts "ERROR: on [GetScriptLineProc 1] $msg"
		global testutils::numerrors testutils::showstack
		if {$testutils::showstack} PrintStack 
		incr testutils::numerrors
		return -code error "ERROR: FAIL"
	}

	# call this at the end of the test script to give an appropriate return code
	proc EXIT {} {
		if {$testutils::numerrors > 0 } {
			return -code error "$testutils::numerrors errors found"
		}
		set_exit_code 0
		return
	}
		

	proc selftest {} {
		set testutils::numerrors 0
		set a "a list"
		EXPECT_EQ "a list" $a
		ASSERT_EQ $a {a list}
		EXPECT_LT 12 13
		ASSERT_LT abc abd
		EXPECT_LTE -1 -1
		ASSERT_LTE -2 0
		EXPECT_NE "bbb" "bbb ccc"
		ASSERT_NE 22 55
		EXPECT_TRUE [ catch { set } ]
		ASSERT_TRUE [ catch { set } ]
		EXPECT_LIST_CONTAINS "bob" "billy bob thorton"
		ASSERT_LIST_CONTAINS 0 {0 1 2}
		EXPECT_STRING_MATCH "*abc*" "abcdefghij"
		ASSERT_STRING_MATCH "*fg*" "abcdefghij"
		EXPECT_STRING_NO_MATCH "*bad*" "good"
		ASSERT_STRING_NO_MATCH "*bad*" "good"
		EXPECT_FAIL { set }
		EXPECT_FAIL_MSG { set } "*wrong # args:*"
		ASSERT_FAIL { set a b c }
		global testutils::numerrors
		if {$testutils::numerrors > 0} {
			return -code error "self test failed: $testutils::numerrors errors"
		}
		set_exit_code 0
		set negerrs 0
		puts ""
		puts "checking negative tests... seeing \"ERROR\" is expected. selftest will throw an error if it fails:"
		puts ""
		EXPECT_EQ "at" $a
		if {$testutils::numerrors != 1} { puts "EXPECT_EQ negative test failed"; incr negerrs }
		if { [set_exit_code] == 0} {puts "EXPECT_EQ did not set an error exit code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		catch {ASSERT_EQ $a {ast}}
		if {$testutils::numerrors != 1} { puts "ASSERT_EQ negative test failed"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		EXPECT_LT 13 0
		if {$testutils::numerrors != 1} { puts "EXPECT_LT negative test failed"; incr negerrs }
		if { [set_exit_code] == 0} {puts "EXPECT_LT did not set an error exit code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		catch {ASSERT_LT abc abc}
		if {$testutils::numerrors != 1} { puts "ASSERT_LT negative test failed"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		EXPECT_LTE 13 0
		if {$testutils::numerrors != 1} { puts "EXPECT_LTE negative test failed"; incr negerrs }
		if { [set_exit_code] == 0} {puts "EXPECT_LTE did not set an error exit code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		catch {ASSERT_LTE abd abc}
		if {$testutils::numerrors != 1} { puts "ASSERT_LT negative test failed"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		EXPECT_NE "bbb" "bbb"
		if {$testutils::numerrors != 1} { puts "EXPECT_NE negative test failed"; incr negerrs }
		if { [set_exit_code] == 0} {puts "EXPECT_NE did not set an error exit code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		catch {ASSERT_NE 22 22} ]
		if {$testutils::numerrors != 1} { puts "ASSERT_NE negative test failed"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		EXPECT_TRUE [ catch { set var 10} ]
		if {$testutils::numerrors != 1} { puts "EXPECT_TRUE negative test failed"; incr negerrs }
		if { [set_exit_code] == 0} {puts "EXPECT_TRUE did not set an error exit code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		catch {ASSERT_TRUE [ catch { set andy 10 } ] }
		if {$testutils::numerrors != 1} { puts "ASSERT_TRUE negative test failed"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		EXPECT_LIST_CONTAINS "bob" "billy b thorton"
		if {$testutils::numerrors != 1} { puts "EXPECT_LIST_CONTAINS negative test failed"; incr negerrs }
		if { [set_exit_code] == 0} {puts "EXPECT_LIST_CONTAINS did not set an error exit code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		catch { ASSERT_LIST_CONTAINS 0 {1 2 3} }
		if {$testutils::numerrors != 1} { puts "ASSERT_LIST_CONTAINS negative test failed"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		EXPECT_STRING_MATCH "*bbb*" "abcdefghij"
		if {$testutils::numerrors != 1} { puts "EXPECT_STRING_MATCH negative test failed"; incr negerrs }
		if { [set_exit_code] == 0} {puts "EXPECT_STRING_MATCH did not set an error exit code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		catch { ASSERT_STRING_MATCH "123" "abcdefghij" }
		if {$testutils::numerrors != 1} { puts "ASSERT_STRING_MATCH negative test failed"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		EXPECT_STRING_NO_MATCH "goo*" "good"
		if {$testutils::numerrors != 1} { puts "EXPECT_STRING_NO_MATCH negative test failed"; incr negerrs }
		if { [set_exit_code] == 0} {puts "EXPECT_STRING_NO_MATCH did not set an error exit code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		catch { ASSERT_STRING_NO_MATCH "*oo*" "good" }
		if {$testutils::numerrors != 1} { puts "ASSERT_STRING_NO_MATCH negative test failed"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		EXPECT_FAIL {set dummy value}
		if {$testutils::numerrors != 1} { puts "EXPECT_FAIL negative test failed"; incr negerrs }
		if { [set_exit_code] == 0} {puts "EXPORT_FAIL did not correctly set an error exit code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		EXPECT_FAIL_MSG { set dummy value } "*wrong # args:*"
		if {$testutils::numerrors != 1} { puts "EXPECT_FAIL_MSG negative test failed"; incr negerrs }
		if { [set_exit_code] == 0} {puts "EXPORT_FAIL_MSG did not correctly set an error exit code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0
		catch {ASSERT_FAIL {set a b}}
		if {$testutils::numerrors != 1} { puts "ASSERT_FAIL negative test failed"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0

		puts ""
		puts "Checking that EXPECT_FAIL does not erase an existing error code:"
		set_exit_code 99
		EXPECT_FAIL {blah}
		if { [set_exit_code] != 99} {puts "EXPORT_FAIL failed to restore the error code"; incr negerrs }
		set testutils::numerrors 0; set_exit_code 0

		puts ""
		if {$negerrs>0} {
			return -code error "self test failed: $negerrs negative tests failed"
		}
		puts "Self test passed"
	}
}
