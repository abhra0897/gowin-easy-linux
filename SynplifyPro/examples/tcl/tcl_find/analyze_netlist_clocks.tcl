#-----------------------------------------------------------------------------
#
# analyze_netlist_clocks.tcl
#
# $Revision: #1 $
#
# This script has three functions:
# 1.  Find every net in the design that is used as a clock signal.
# 2.  Identify sequential instances in the design with the clock tied to 0.
# 3.  Identify places in the design where clock nets are used for logic.
#
# In Synplify Pro, close all analyst views and open a flat technology view.
# Run this script from the Run->TCL Script menu selection.
#
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# 0. Set up log file:
#-----------------------------------------------------------------------------

set logfile [open clock_analysis.txt w]

proc putlog {logfile msgstring} {
  puts $msgstring
  puts $logfile $msgstring
}

putlog $logfile "Analyzing Netlist Clocks [clock format [clock seconds] -gmt 1 -format "%A %Y-%m-%d %H:%M:%S GMT"]\n"

#-----------------------------------------------------------------------------
# 1. Select All Clock Pins On All Sequential Primitives In Design:
#-----------------------------------------------------------------------------

# This script currently identifies "clock" pins by name on Xilinx primitives.
# Future versions of Synplify will have better support for pin attributes, so
# you would be able to identify clock pins by property rather than by name.

# Note that it would really suck if a combinatorial primitive had a pin with
# a name used for a clock on some other sequential primitive.  Fortunately
# it looks ok for now.

set C_pins [find -tech -pin *.C]
set CLK_pins [find -tech -pin *.CLK]
set C0_pins [find -tech -pin *.C0]
set C1_pins [find -tech -pin *.C1]
# 'Gate' inputs on latch primitives:
set G_pins [find -tech -pin *.G]
# Write clocks on distributed latch primitives:
set WCLK_pins [find -tech -pin *.WCLK]
# Clocks for block ram primitives:
set CLKA_pins [find -tech -pin *.CLKA]
set CLKB_pins [find -tech -pin *.CLKB]

set all_clk_pins [c_union $C_pins $CLK_pins]
set all_clk_pins [c_union $all_clk_pins $C0_pins]
set all_clk_pins [c_union $all_clk_pins $C1_pins]
set all_clk_pins [c_union $all_clk_pins $G_pins]
set all_clk_pins [c_union $all_clk_pins $WCLK_pins]
set all_clk_pins [c_union $all_clk_pins $CLKA_pins]
set all_clk_pins [c_union $all_clk_pins $CLKB_pins]

#putlog $logfile "\nDebug: Found the following sequential element clock pins in the design:"
#foreach clk_pin [c_list $all_clk_pins] {
#    putlog $logfile "$clk_pin"
#}

c_info $all_clk_pins -array all_clk_pins_info
#putlog $logfile "\nDebug: c_info statistics from all_clk_pins collection:"
#foreach index [array names all_clk_pins_info] {
#    putlog $logfile "$index $all_clk_pins_info($index)"
#}
set n_clk_pins $all_clk_pins_info(pin_count)
putlog $logfile "\nFound $n_clk_pins sequential element clock pins in design."

#-----------------------------------------------------------------------------
# 2. Select All Nets Which Connect To Clock Pins In Design:
#-----------------------------------------------------------------------------

set all_clk_nets [expand -net -level 1 -to $all_clk_pins]

# Clock pins that are grounded can't be found by tracing forward from any net.
# Instead they are found by subtracting away the pins with real clock nets.
set remaining_clk_pins $all_clk_pins
set n_remaining_clk_pins $n_clk_pins
set grounded_clks_present 0

putlog $logfile "\nFound the following clock nets in the design:"
putlog $logfile "(Note global clock loads include not only gating logic but the loads of derived clocks.)"
foreach clk_net [c_list $all_clk_nets] {
    if {[regexp -nocase {false} $clk_net]} {
	set grounded_clks_present 1
    } else {
	set one_clk_pins [find * -in [expand -pin -level 1 -from $clk_net] -filter {@direction==input}]
	c_info $one_clk_pins -array one_clk_pins_info
	set n_one_clk_pins $one_clk_pins_info(pin_count)
	putlog $logfile "Net $clk_net with $n_one_clk_pins loads";
	set n_remaining_clk_pins [expr {$n_remaining_clk_pins - $n_one_clk_pins}]
	if {$n_remaining_clk_pins > 0} {
	    set remaining_clk_pins [c_diff $remaining_clk_pins $one_clk_pins]
	}
    }
}

if {$grounded_clks_present} {
    putlog $logfile "\nWARNING: There are $n_remaining_clk_pins sequential elements in the design with clock pins tied to zero:"
    set grounded_clk_pins $remaining_clk_pins
    foreach grounded_clk_pin [c_list $grounded_clk_pins] {
	putlog $logfile "$grounded_clk_pin"
    }
}

#-----------------------------------------------------------------------------
# 3. Select All Primitives Which Are Driven By Clock Nets In Design:
#-----------------------------------------------------------------------------

# Note:  The "expand -thru" command picks up the primitives touching the net, 
# and automatically includes input pins of primitives that drive the net, and
# output pins of primitives that are driven by the net -- ie pins that aren't
# connected to the net at all.  Instead, this command uses "expand -from" to
# looks forward from the net to primitives, and then filters by port direction
# to remove output pins from primitives driven by the clock net:

set clk_dst_pins_i  [find * -in [expand -pin -level 1 -from $all_clk_nets] -filter {@direction==input}]
set clk_dst_pins_io [find * -in [expand -pin -level 1 -from $all_clk_nets] -filter {@direction==inout}]
set all_clk_dst_pins [c_union $clk_dst_pins_i $clk_dst_pins_io]

# At this point the collection should contain all of the clock pins originally
# selected by name AND any non-sequential connections for the clock nets.

#putlog $logfile "\nDebug: The following pins receive the clock nets in the design:";
#foreach clk_dst_pin [c_list $all_clk_dst_pins] {
#    putlog $logfile $clk_dst_pin;
#}

#-----------------------------------------------------------------------------
# 4. Determine if any Non-Sequential Primitives are Driven by Clock Nets:
#-----------------------------------------------------------------------------

c_info $all_clk_dst_pins -array all_clk_dst_pins_info
set n_clk_dst_pins $all_clk_dst_pins_info(pin_count)

if {$n_clk_dst_pins > $n_clk_pins} {
    putlog $logfile "\nWARNING: Found the following non-clock connections for clock nets in the design:"; 
    set all_logic_clk_pins [c_diff $all_clk_dst_pins $all_clk_pins]
    foreach logic_clk_pin [c_list $all_logic_clk_pins] {
	putlog $logfile "\nInstance pin $logic_clk_pin receives clock"
	foreach clk_net [c_list [expand -level 1 -net -to $logic_clk_pin]] {
	    putlog $logfile $clk_net
	}
    } 
} else {
    putlog $logfile "\nNo non-clock connections for clock nets in the design."
}

close $logfile 

#-----------------------------------------------------------------------------
# 
# End file analyze_netlist_clocks.tcl
#
#-----------------------------------------------------------------------------
