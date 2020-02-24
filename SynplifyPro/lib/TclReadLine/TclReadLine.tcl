package provide TclReadLine 1.1

  #! /usr/bin/env tclsh
  # tclline: An attempt at a pure tcl readline.

  # Use Tclx if available:
  catch {
	  package require Tclx

	  # Prevent sigint from killing our shell:
	  signal ignore SIGINT
  }

  namespace eval TclReadLine {

	  namespace export interact

	# Initialise our own env variables:
	  variable PROMPT ">"
	  #variable HISTORY ""
	  variable HISTORY_LEVEL 0
	  variable HISTORY_BUFFER 100
	  variable COMPLETION_MATCH ""

	  variable CMDLINE ""
    variable CMDLINE_LENGTH 0
	  variable CMDLINE_CURSOR 0
	  variable CMDLINE_LINES 0
	  variable CMDPRINT ""
	  variable CMDWHICH ""
	  variable CMD_CTRL_INDEX -1
	  variable CMD_CMD ""
	  variable ALIASES
	  array set ALIASES {}
    #variable KEYBUFFER {}
	  variable forever 0

  }
  proc GetHistFile {} {
	  global env
	  global tcl_platform
	  if {"$tcl_platform(platform)" == "windows"} {
		  return "$env(USERPROFILE)/chipit/cmprosh_history"
	  }
	  return "$env(HOME)/.chipit/cmprosh_history"
  }
  proc TclReadLine::ESC {} {
	  return "\033"
  }

  proc TclReadLine::shift {ls} {
	  upvar 1 $ls LIST
	  set ret [lindex $LIST 0]
	  set LIST [lrange $LIST 1 end]
	  return $ret
  }

#  proc TclReadLine::readbuf {} {
#    global KEYBUFFER
#
#	  set ret [string index $KEYBUFFER 0]
#	  set KEYBUFFER [string range $KEYBUFFER 1 end]
#	  return $ret
#  }

  proc TclReadLine::goto {row {col 1}} {
	  switch -- $row {
		  "home" {set row 1}
	  }
	  print "[ESC]\[${row};${col}H" nowait
  }

  proc TclReadLine::gotocol {col} {
	  print "\r" nowait
	  if {$col > 0} {
		  print "[ESC]\[${col}C" nowait
	  }
  }

  proc TclReadLine::clear {} {
	  print "[ESC]\[2J" nowait
	  goto home
  }

  proc TclReadLine::clearline {} {
	  print "[ESC]\[2K\r" nowait
  }

  proc TclReadLine::getColumns {} {
	  set cols 0
	  if {![catch {exec stty -a} err]} {
		  regexp {rows (= )?(\d+); columns (= )?(\d+)} $err junk i1 rows i2 cols
	  }
	  return $cols
  }

  proc TclReadLine::localInfo {args} {
	  set v [uplevel _info $args]
	  if { [string equal "script" [lindex $args 0]] } {
		  if { [string equal $v $TclReadLine::ThisScript] } {
			  return ""
		  }
	  }
	  return $v
  }

  proc TclReadLine::localPuts {args} {

	  set l [llength $args]
	  if { 3 < $l } {
		  return -code error "Error: wrong \# args"
	  }

	  if { 1 < $l } {
		  if { [string equal "-nonewline" [lindex $args 0]] } {
			  if { 2 < $l } {
				  # we don't send to channel...
				  eval _origPuts $args
			  } else {
				  set str [lindex $args 1]
				  append TclReadLine::putsString $str ;# no newline...
			  }
		  } else {
			  # must be a channel
			  eval _origPuts $args
		  }
	  } else {
		  append TclReadLine::putsString [lindex $args 0] "\n"
	  }
  }

  proc TclReadLine::prompt {{txt ""}} {
	  global CMPROGUI
	  if {$CMPROGUI == 1} return
	  if { "" != [info var ::tcl_prompt1] } {
		  rename ::puts ::_origPuts
		  rename TclReadLine::localPuts ::puts
		  variable putsString
		  set putsString ""
		  eval [set ::tcl_prompt1]
		  set prompt $putsString
		  rename ::puts TclReadLine::localPuts
		  rename ::_origPuts ::puts
	  } else {
		  variable PROMPT
		  set prompt [subst $PROMPT]
	  }
	  set txt "$prompt$txt"
	  variable CMDLINE_LINES
	  variable CMDLINE_CURSOR
	  variable COLUMNS
	  foreach {end mid} $CMDLINE_LINES break
	  # Calculate how many extra lines we need to display.
	  # Also calculate cursor position:
	  set n -1
	  set totalLen 0
	  set cursorLen [expr {$CMDLINE_CURSOR+[string length $prompt]}]
	  set row 0
	  set col 0

	  # Render output line-by-line to $out then copy back to $txt:
	  set found 0
	  set out [list]
	  foreach line [split $txt "\n"] {
		  set len [expr {[string length $line]+1}]
		  incr totalLen $len
		  if {$found == 0 && $totalLen >= $cursorLen} {
			  set cursorLen [expr {$cursorLen - ($totalLen - $len)}]
			  set col [expr {$cursorLen % $COLUMNS}]
			  set row [expr {$n + ($cursorLen / $COLUMNS) + 1}]

			  if {$cursorLen >= $len} {
				  set col 0
				  incr row
			  }
			  set found 1
		  }
		  incr n [expr {int(ceil(double($len)/$COLUMNS))}]
		  while {$len > 0} {
			  lappend out [string range $line 0 [expr {$COLUMNS-1}]]
			  set line [string range $line $COLUMNS end]
			  set len [expr {$len-$COLUMNS}]
		  }
	  }
	  set txt [join $out "\n"]
	  set row [expr {$n-$row}]

	  # Reserve spaces for display:
	  if {$end} {
		  if {$mid} {
			  print "[ESC]\[${mid}B" nowait
		  }
		  for {set x 0} {$x < $end} {incr x} {
			  clearline
			  print "[ESC]\[1A" nowait
		  }
	  }
	  clearline
	  set CMDLINE_LINES $n
	  # Output line(s):
	  print "\r$txt"
	  if {$row} {
		  print "[ESC]\[${row}A" nowait
	  }
	  gotocol $col
	  lappend CMDLINE_LINES $row
	}

  proc TclReadLine::print {txt {wait wait}} {
	  global CMPROGUI
	  # Sends output to stdout chunks at a time.
	  # This is to prevent the terminal from
	  # hanging if we output too much:
	  if {$CMPROGUI == 1} return
	  while {[string length $txt]} {
		  puts -nonewline [string range $txt 0 2047]
	 	  set txt [string range $txt 2048 end]
	  }
  }

  proc TclReadLine::unknown {args} {

	  set name [lindex $args 0]
	  set TclReadLine_cmdline $TclReadLine::CMDLINE
	  set TclReadLine_cmd [string trim [regexp -inline {^\s*[^\s]+} $TclReadLine_cmdline]]
	  if {[info exists TclReadLine::ALIASES($TclReadLine_cmd)]} {
		  set TclReadLine_cmd [regexp -inline {^\s*[^\s]+} $TclReadLine::ALIASES($TclReadLine_cmd)]
	  }

	  set new [auto_execok $name]
	  if {$new != ""} {
		  set redir ""
		  if {$name == $TclReadLine_cmd && [info command $TclReadLine_cmd] == ""} {
			  set redir ">&@ stdout <@ stdin"
		  }
		  if {[catch {
			  uplevel 1 exec $redir $new [lrange $args 1 end]} ret]
		  } {
			  return
		  }
		  return $ret
	  }

	  uplevel _unknown $args
  }

  proc TclReadLine::alias {word command} {
	  variable ALIASES
	  set ALIASES($word) $command
  }

  proc TclReadLine::unalias {word} {
	  variable ALIASES
	  array unset ALIASES $word
  }

  ################################
  # Key bindings
  ################################
  proc TclReadLine::handleEscapes {} {

	  variable CMDLINE
    variable CMDLINE_LENGTH
	  variable CMDLINE_CURSOR
    #global KEYBUFFER
	  #upvar 1 keybuffer keybuffer
	  set seq ""
	  set found 0
	  while {[set ch [read stdin]] != ""} {
		  append seq $ch
		  switch -exact -- $seq {
			  "\[A" { ;# Cursor Up (cuu1,up)
				  handleHistory -1
				  break
			  }
			  "\[B" { ;# Cursor Down
				  handleHistory 1
				  break
			  }
			  "\[C" { ;# Cursor Right (cuf1,nd)
				  if {$CMDLINE_CURSOR < $CMDLINE_LENGTH} {
					  incr CMDLINE_CURSOR
				  }
				  break
			  }
			  "\[D" { ;# Cursor Left
				  if {$CMDLINE_CURSOR > 0} {
					  incr CMDLINE_CURSOR -1
				  }
				  break
			  }
			  "\[H" -
			  "\[7~" -
			  "\[1~" { ;# home
				  set CMDLINE_CURSOR 0
				  break
			  }
			  "\[3~" { ;# delete
				  if {$CMDLINE_CURSOR < $CMDLINE_LENGTH} {
					  set CMDLINE [string replace $CMDLINE \
									   $CMDLINE_CURSOR $CMDLINE_CURSOR]
            incr CMDLINE_LENGTH -1
				  }
				  break
			  }
			  "\[F" -
			  "\[K" -
			  "\[8~" -
			  "\[4~" { ;# end
				  set CMDLINE_CURSOR $CMDLINE_LENGTH 
				  break
			  }
			  "\[5~" { ;# Page Up
			  }
			  "\[6~" { ;# Page Down
			  }
		  }
		  set found 1
	  }
	  return $found
	}

  proc TclReadLine::handleControls {} {

	  variable CMDLINE
    variable CMDLINE_LENGTH
	  variable CMDLINE_CURSOR
    #global KEYBUFFER
	  upvar 1 char char
	  #upvar 1 keybuffer keybuffer

	  # Control chars start at a == \u0001 and count up.
	  set leave_search 1
	  switch -exact -- $char {
		  \u0001 { ;# ^a
			  set CMDLINE_CURSOR 0
		  }
		  \u0002 { ;# ^b
			  if { $CMDLINE_CURSOR > 0 } {
				  incr CMDLINE_CURSOR -1
			  }
		  }
		  \u0004 { ;# ^d
			  # should exit - if this is the EOF char, and the
			  #   cursor is at the end-of-input
			  if { 0 == $CMDLINE_LENGTH } {
				  doExit
			  }
			  set CMDLINE [string replace $CMDLINE \
							   $CMDLINE_CURSOR $CMDLINE_CURSOR]
        incr CMDLINE_LENGTH -1
		  }
		  \u0005 { ;# ^e
			  set CMDLINE_CURSOR $CMDLINE_LENGTH
		  }
		  \u0006 { ;# ^f
			  if {$CMDLINE_CURSOR < $CMDLINE_LENGTH} {
				  incr CMDLINE_CURSOR
			  }
		  }
		  \u0007 { ;# ^g
			  set CMDLINE ""
			  set CMDLINE_CURSOR 0
        set CMDLINE_LENGTH 0
		  }
		  \u0012 { ;# ^r
			  set leave_search 0
			  ::TclReadLine::handleCtrR 1
		  }
		  \u000b { ;# ^k
			  variable YANK
			  set YANK  [string range $CMDLINE [expr {$CMDLINE_CURSOR  } ] end ]
			  set CMDLINE [string range $CMDLINE 0 [expr {$CMDLINE_CURSOR - 1 } ]]
        set CMDLINE_LENGTH [string length $CMDLINE]
		  }
		  \u0019 { ;# ^y
			  variable YANK
			  if { [ info exists YANK ] } {
				  set CMDLINE \
					  "[string range $CMDLINE 0 [expr {$CMDLINE_CURSOR - 1 }]]$YANK[string range $CMDLINE $CMDLINE_CURSOR end]"
          set CMDLINE_LENGTH [string length $CMDLINE]
			  }
		  }
		  \u000e { ;# ^n
			  handleHistory 1
		  }
		  \u0010 { ;# ^p
			  handleHistory -1
		  }
		  \u0003 { ;# ^c
			  # clear line
			  set CMDLINE ""
			  set CMDLINE_CURSOR 0
        set CMDLINE_LENGTH 0
		  }
		  \u0008 -
		  \u007f { ;# ^h && backspace ?
			  if {$CMDLINE_CURSOR > 0} {
				  incr CMDLINE_CURSOR -1
				  set CMDLINE [string replace $CMDLINE \
										$CMDLINE_CURSOR $CMDLINE_CURSOR]
          incr CMDLINE_LENGTH -1
			  }
		  }
		  \u001b { ;# ESC - handle escape sequences
			  if {![handleEscapes]} {;#if not found must be a normal escape char
			  }
		  }
	  }
	  if {$::TclReadLine::CMD_CTRL_INDEX != -1 && $leave_search == 1} { 
		  set TclReadLine::CMD_CTRL_INDEX -1
		  set TclReadLine::CMD_CMD ""
		  set TclReadLine::PROMPT ">"
		  set TclReadLine::HISTORY_LEVEL [history nextid]
	  }
	  
		# Rate limiter:
	  #set KEYBUFFER ""
  }

  proc TclReadLine::shortMatch {maybe} {
	  # Find the shortest matching substring:
	  set maybe [lsort $maybe]
	  set shortest [lindex $maybe 0]
	  foreach x $maybe {
		  while {![string match $shortest* $x]} {
			  set shortest [string range $shortest 0 end-1]
		  }
	  }
	  return $shortest
  }
  proc TclReadLine::handleCtrR {incr_history} {
	  variable CMDLINE
	  variable CMDLINE_CURSOR
	  variable CMD_CTRL_INDEX
	  variable CMD_CMD
    variable CMDLINE_LENGTH

    #dosn't work right now
    #return 
#	  ::TclReadLine::print "\nTclReadLine::handleCtrR $incr_history $CMD_CTRL_INDEX $CMDLINE_CURSOR $CMDLINE\n"
    set TclReadLine::PROMPT "(search)"
	  if {$CMD_CTRL_INDEX == -1} {
		  set CMD_CTRL_INDEX $CMDLINE_CURSOR
      set CMD_CMD ""
		  return
	  }
    #handle backspace
    if {$CMD_CTRL_INDEX >= $CMDLINE_CURSOR} {
      set l [string length $CMD_CMD]
      if {[catch {set CMD_CMD [string range $CMD_CMD 0 [expr $l - $CMD_CTRL_INDEX - $CMDLINE_CURSOR - 1]]} err]} {
        set CMD_CMD ""
      }
    }
    #set new CMD_... vars
    set CMD_CTRL_INDEX $CMDLINE_CURSOR
    if {$incr_history == 0} {
      set CMD_CMD "$CMD_CMD[string index $CMDLINE [expr $CMDLINE_CURSOR - 1]]"
    }
#	  ::TclReadLine::print "\n-$CMD_CMD-\n"
	  
    set len [expr {[history nextid] -1}]
  	set TclReadLine::PROMPT "(search)'$CMD_CMD':"
	  # search from current history level
	  for {set i [expr $TclReadLine::HISTORY_LEVEL - $incr_history - 1]} {$i > 0} {incr i -1} {
#      ::TclReadLine::print "\n-$i-\n"
		  if {![catch {set TclReadLine_cmd [history event $i]} err]} {
#        ::TclReadLine::print "\n-$TclReadLine_cmd-\n"
                
			  set matchPos [string first $CMD_CMD $TclReadLine_cmd]
			  if {$matchPos != -1} {
				  if {$incr_history == 1} {set TclReadLine::HISTORY_LEVEL $i}
                            set CMDLINE $TclReadLine_cmd
          set CMDLINE_LENGTH [string length $CMDLINE]
				  set CMDLINE_CURSOR [expr [string length $CMD_CMD] + $matchPos]
          set CMD_CTRL_INDEX [expr $CMDLINE_CURSOR - 1]
          return 
			  }
		  } else {
			  break;
		  }
	  }
    #set history to begin
    set TclReadLine::HISTORY_LEVEL [history nextid]
    set CMD_CTRL_INDEX [expr $CMDLINE_CURSOR - 1]
  }
  proc TclReadLine::handleCompletion {} {
	  variable CMDLINE
    variable CMDLINE_LENGTH
	  variable CMDLINE_CURSOR
	  global env
	  variable CMDPRINT [list]
	  variable CMDWHICH [list]
	  global CMPROGUI
    variable COMPLETION_MATCH

	  set vars ""
	  set cmds ""
	  set execs ""
	  set files ""

	  # First find out what kind of word we need to complete:
	  set wordstart [string last " " $CMDLINE [expr {$CMDLINE_CURSOR-1}]]
	  incr wordstart
	  set wordend [string first " " $CMDLINE $wordstart]
	  if {$wordend == -1} {
		  set wordend end
	  } else {
		  incr wordend -1
	  }
	  set word [string range $CMDLINE $wordstart $wordend]

	  if {[string trim $word] == ""} {
      set cmds [string trim $CMDLINE]
      if {$cmds != $COMPLETION_MATCH} {
        if {![catch {set help [get_help $cmds]} err]} {
          if {$CMPROGUI == 0} {clearline;print "\n[ESC]\[34m${help}[ESC]\[0m\n"} else {lappend CMDWHICH help;lappend CMDPRINT "\n${help}\n"}
          set COMPLETION_MATCH $cmds
        }
      }
      return
    }

	  set firstchar [string index $word 0]

	  # Check if word is a variable:
	  if {$firstchar == "\$"} {
		  set word [string range $word 1 end]
		  incr wordstart

		  # Check if it is an array key:proc

		  set x [string first "(" $word]
		  if {$x != -1} {
			  set v [string range $word 0 [expr {$x-1}]]
			  incr x
			  set word [string range $word $x end]
			  incr wordstart $x
			  if {[uplevel \#0 "array exists $v"]} {
				  set vars [uplevel \#0 "array names $v $word*"]
			  }
		  } else {
			  foreach x [uplevel \#0 {info vars}] {
				  if {[string match $word* $x]} {
					  lappend vars $x
				  }
			  }
		  }
	  } else {
		  # Check if word is possibly a path:
		  if {$firstchar == "/" || $firstchar == "." || $wordstart != 0} {
			  set files [glob -nocomplain -- $word*]
		  }
		  if {$files == ""} {
			  # Not a path then get all possibilities:
			  if {$firstchar == "\[" || $wordstart == 0} {
				  if {$firstchar == "\["} {
					  set word [string range $word 1 end]
					  incr wordstart
				  }
				  # Check executables: 
				  # NOTE: dosn't work for the moment
#				  foreach dir [split $env(PATH)] {
#					  foreach f [glob -nocomplain -directory $dir -- $word*] {
#						  set exe [string trimleft [string range $f \
#								[string length $dir] end] "/"]
#
#						  if {[lsearch -exact $execs $exe] == -1} {
#							  lappend execs $exe
#						  }
#					  }
#				  }
				  # Check commands:
				  foreach x [info commands ::$word*] {
						lappend cmds [string trimleft $x ":"]
				  }
				  foreach x [namespace children :: ::$word*] {
						lappend cmds [string trimleft $x ":"]
				  }
			  } else {
				  # Check commands anyway:
				  foreach x [info commands ::$word*] {
						lappend cmds [string trimleft $x ":"]
				  }
				  foreach x [namespace children :: ::$word*] {
						lappend cmds [string trimleft $x ":"]
				  }
			  }
		  }
		  if {$wordstart != 0} {
			  # Check variables anyway:
			  set x [string first "(" $word]
			  if {$x != -1} {
				  set v [string range $word 0 [expr {$x-1}]]
				  incr x
				  set word [string range $word $x end]
				  incr wordstart $x
				  if {[uplevel \#0 "array exists $v"]} {
					  set vars [uplevel \#0 "array names $v $word*"]
				  }
			  } else {
				  foreach x [uplevel \#0 {info vars}] {
					  if {[string match $word* $x]} {
						  lappend vars $x
					  }
				  }
			  }
		  }
	  }

	  set maybe [concat $vars $cmds $execs $files]
	  set shortest [shortMatch $maybe]
	  if {"$word" == "$shortest"} {
		  if {[llength $maybe] > 1 && $COMPLETION_MATCH != $maybe} {
			  set COMPLETION_MATCH $maybe
			  clearline
			  set temp ""
			  if {$CMPROGUI == 1} {
				  foreach {match} {
					  vars 
					  cmds 
					  execs
					  files
				  } {
					  if {[llength [set $match]]} {
						  set temp ""
						  lappend CMDWHICH $match
						  foreach x [set $match] {
							  append temp "[file tail $x] "
						  }
						  lappend CMDPRINT "\n$temp\n"
					  }
				  }
			  } else {
				  foreach {match format} {
					  vars  "1;35"
					  cmds  "1;34"
					  execs "32"
					  files "1;32"
				  } {
					  if {[llength [set $match]]} {
						  append temp "[ESC]\[${format}m"
						  foreach x [set $match] {
							  append temp "[file tail $x] "
						  }
						  append temp "[ESC]\[0m"
					  }
				  }
				  print "\n$temp\n"
			  }
		  } elseif {[llength $cmds] == 1} {
        if {$cmds != $COMPLETION_MATCH} {
          if {![catch {set help [get_help [string trim $CMDLINE]]} err]} {
			if {$CMPROGUI == 0} {clearline;print "\n[ESC]\[34m${help}[ESC]\[0m\n"} else {lappend CMDWHICH help;lappend CMDPRINT "\n${help}\n"}
            set COMPLETION_MATCH $cmds
          }
        }
      }
	  } else {
		  if {[file isdirectory $shortest] &&
			  [string index $shortest end] != "/"} {
			  append shortest "/"
		  }
		  if {$shortest != ""} {
			  set CMDLINE \
				  [string replace $CMDLINE $wordstart $wordend $shortest]
        set CMDLINE_LENGTH [string length $CMDLINE]
			  set CMDLINE_CURSOR \
				  [expr {$wordstart+[string length $shortest]}]
		  } elseif { $COMPLETION_MATCH != " not found "} {
			  set COMPLETION_MATCH " not found "
			  print "\nNo match found.\n"
		  } 
	  }
  } 

  proc TclReadLine::handleHistory {x} {
	  #variable HISTORY_LEVEL
	  variable CMDLINE
    variable CMDLINE_LENGTH
	  variable CMDLINE_CURSOR

	  set len [expr {[history nextid] -1}]
	  if { $len > 0 } {
		  set level $TclReadLine::HISTORY_LEVEL
		  incr level $x
		  if {0<$level&&$level<=$len} {
			  if {![catch {set TclReadLine_cmd [history event $level]} err]} {
				  set TclReadLine::HISTORY_LEVEL $level
				  set CMDLINE $TclReadLine_cmd
          set CMDLINE_LENGTH [string length $CMDLINE]
				  set CMDLINE_CURSOR $CMDLINE_LENGTH
			  }
		  }
#		  if { [catch {incr TclReadLine::HISTORY_LEVEL $x} index] } {
#			  set index [expr { $x==1 ? 0 : $len-1 }]
#			  set TclReadLine::HISTORY_LEVEL $index
#		  }
#		  if { $len == 1 } {
#			  set TclReadLine_cmd [history event 1]
#		  } else {
#			  set index [expr { int(fmod( $index, $len)) }]
#			  set id [expr {$len - $index}]
#			  set TclReadLine::HISTORY_LEVEL $id
#			  set TclReadLine_cmd [history event $id]
#		  }
		  
	  }
  }

  ################################
  # History handling functions
  ################################

  proc TclReadLine::getHistory {} {
	  set hlist [list]
	  set e [history nextid]
	  for { set i [expr [history nextid] -1] } {$i != 0} {incr i -1} {
		  if {![catch {set TclReadLine_cmd [history event $i]} err]} {
			  lappend hlist $TclReadLine_cmd
		  } else {
			  break
		  }
	  }
	  if {[llength $hlist] > 0} {
          set HISTFILE [GetHistFile]
          if {[file exists [file dirname $HISTFILE]] == 0} {
              file mkdir [file dirname $HISTFILE]
          }
          if {[catch {open $HISTFILE w} f] == 0} {
              foreach x $hlist {
                  # Escape newlines:
                  puts $f [string map {
                      \n "\\n"
                      "\\" "\\b"
                  } $x]
              }
              close $f
          }
      }
  }

  proc TclReadLine::setHistory {} {
	  set HISTFILE [GetHistFile]
	  if {[file exists $HISTFILE]} {
		  set f [open $HISTFILE r]
		  set hlist [list]
		  foreach x [split [read $f] "\n"] {
			  if {$x != ""} {
				  # Undo newline escapes:
				  lappend hlist [string map {
					  "\\n" \n
					  "\\\\" "\\"
					  "\\b" "\\"
				  } $x]
			  }
		  }
          set len [llength $hlist]
          if {$len > 0} {
              for {set i [expr $len - 1 ]} {1} {incr i -1} {
                  set h [lindex $hlist $i]
                  history add $h
                  if {$i == 0} break
              }
          }
		  set TclReadLine::HISTORY_LEVEL [history nextid]
		  unset hlist
		  close $f
	  }
  }
#  proc TclReadLine::appendHistory {cmdline} {
#	  global HISTORY
#		set old [lsearch -exact $HISTORY $cmdline]
#		if {$old != -1} {
#			set HISTORY [lreplace $HISTORY $old $old]
#		}
#		lappend HISTORY $cmdline
#		set HISTORY \
#			[lrange $HISTORY end-$TclReadLine::HISTORY_BUFFER end]
#	  
#  }

  ################################
  # main()
  ################################

  proc TclReadLine::rawInput {} {
	  exec stty raw -echo
  }

  proc TclReadLine::lineInput {} {
	  fconfigure stdin -buffering line -blocking 1
	  fconfigure stdout -buffering line
	  exec stty -raw echo
    fconfigure stdin -buffering none -blocking 0
    fconfigure stdout -buffering none -translation crlf
  }

  proc TclReadLine::doExit {{code 0}} {

	  # Reset terminal:
	  #print "[ESC]c[ESC]\[2J" nowait

	  restore ;# restore "info' command -
	  lineInput

	  getHistory

	  exit $code
  }

  proc TclReadLine::restore {} {
	  lineInput
	  rename ::unknown TclReadLine::unknown
	  rename ::_unknown ::unknown
  }
  proc TclReadLine::interact {} {

	  rename ::unknown ::_unknown
	  rename TclReadLine::unknown ::unknown

	  # remember the last 100 commands
	  history keep 100 

	  # Load history if available:
	  setHistory

    fconfigure stdin -buffering none -blocking 0
    fconfigure stdout -buffering none -translation crlf
	  rawInput

	  # This is to restore the environment on exit:
	  # Do not unalias this!
	  alias exit TclReadLine::doExit

	  variable ThisScript [info script]

	  tclline ;# emit the first prompt

	  fileevent stdin readable TclReadLine::tclline
	  variable forever
	  vwait TclReadLine::forever

	  restore
  }

  proc TclReadLine::tclline {} {
	  variable COLUMNS
	  variable CMDLINE_CURSOR
	  variable CMDLINE
    variable CMDLINE_LENGTH
    #global KEYBUFFER
	  set char ""
	  #set KEYBUFFER [read stdin]
	  set COLUMNS [getColumns]

	  while {![eof stdin]} {
		  
		  #if {[eof stdin]} return
		  set char [read stdin 1]
      if {$char == ""} break

		  if {[string is print $char]} {
			  if {$CMDLINE_CURSOR < 1 && [string trim $char] == ""} continue

        if {$CMDLINE_LENGTH != $CMDLINE_CURSOR} {
	        set trailing [string range $CMDLINE $CMDLINE_CURSOR end]
	        set CMDLINE [string replace $CMDLINE $CMDLINE_CURSOR end]
	        append CMDLINE $char
	        append CMDLINE $trailing
        } else {
          append CMDLINE $char
        }
        incr CMDLINE_CURSOR
        incr CMDLINE_LENGTH
			  
			  if {$::TclReadLine::CMD_CTRL_INDEX != -1} {
				  TclReadLine::handleCtrR 0
			  }
			  
		  } elseif {$char == "\t"} {
			  handleCompletion
		  } elseif {$char == "\n" || $char == "\r"} {
			  if {[info complete $CMDLINE] &&
				  [string index $CMDLINE end] != "\\"} {
				  lineInput
				  print "\n" nowait
				  uplevel \#0 {

					  # Handle aliases:
					  set TclReadLine_cmdline $TclReadLine::CMDLINE
					  set TclReadLine_cmd [string trim [regexp -inline {^\s*[^\s]+} $TclReadLine_cmdline]]
					  if {[info exists TclReadLine::ALIASES($TclReadLine_cmd)]} {
						  regsub -- "(?q)$TclReadLine_cmd" $TclReadLine_cmdline $TclReadLine::ALIASES($TclReadLine_cmd) TclReadLine_cmdline
					  }

					  # Perform glob substitutions:
            # doesn't work if there is a file with '~' into the directory then it will go into a infinite loop! :(
            if {0} {
					  set TclReadLine_cmdline [string map {
						  "\\*" \0
						  "\\~" \1
					  } $TclReadLine_cmdline]
					  while {[regexp -indices \
								  {([\w/\.]*(?:~|\*)[\w/\.]*)+} $TclReadLine_cmdline x]
						 } {
						  foreach {i n} $x break
						  set s [string range $TclReadLine_cmdline $i $n]
						  set x [glob -nocomplain -- $s]
                puts "x:$x s:$s i:$i n:$n TclReadLine_cmdline:$TclReadLine_cmdline"

						  # If glob can't find anything then don't do
						  # glob substitution, pass * or ~ as literals:
						  if {$x == ""} {
							  set x [string map {
								  "*" \0
								  "~" \1
							  } $s]
						  }
						  set TclReadLine_cmdline [string replace $TclReadLine_cmdline $i $n $x]
					  }
					  set TclReadLine_cmdline [string map {
						  \0 "*"
						  \1 "~"
					  } $TclReadLine_cmdline]
            }
					  rename ::info ::_info
					  rename TclReadLine::localInfo ::info
					  # Run the command and append HISTORY:
					  catch {history add $TclReadLine_cmdline exec} res
					  set TclReadLine::HISTORY_LEVEL [history nextid]
					  rename ::info TclReadLine::localInfo
					  rename ::_info ::info
					  if {$res != ""} {
						  TclReadLine::print "$res\n"
					  }

					  set TclReadLine::CMDLINE ""
					  set TclReadLine::CMDLINE_CURSOR 0
            set TclReadLine::CMDLINE_LENGTH 0
					  set TclReadLine::CMDLINE_LINES {0 0}
					  set TclReadLine::CMD_CTRL_INDEX -1
					  set TclReadLine::CMD_CMD ""
					  set TclReadLine::PROMPT ">"
				  } ;# end uplevel
				  rawInput
			  } else {
	        if {$CMDLINE_CURSOR < 1 && [string trim $char] == ""} continue
	
	        if {$CMDLINE_LENGTH != $CMDLINE_CURSOR} {
	          set trailing [string range $CMDLINE $CMDLINE_CURSOR end]
	          set CMDLINE [string replace $CMDLINE $CMDLINE_CURSOR end]
	          append CMDLINE $char
	          append CMDLINE $trailing
	        } else {
	          append CMDLINE $char
	        }
	        incr CMDLINE_CURSOR
	        incr CMDLINE_LENGTH
			  }
		  } else {
			  handleControls
		  }
	  }
	  prompt $CMDLINE
  }
  global CMPROGUI
  if {$CMPROGUI == 0 && "$tcl_platform(platform)" != "windows"} {
	  TclReadLine::interact
  }
