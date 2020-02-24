# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
namespace eval xilinx_ip_constraints {
	namespace export ip_xdc2fdc
	variable forward_annotate
	variable quiet_mode
	variable extra_hier
	variable fpo_top_log
	variable fpo_log
	variable os

	####  Main proc: Process all XDC files
	proc ip_xdc2fdc {args} {
		variable forward_annotate 0
		variable quiet_mode 0
		variable extra_hier ""
		variable fpo_top_log
		variable fpo_log
		variable os
		variable top_design
		set top_design ""
		global env
		set os $env(OS)
		set procname [lindex [info level 0] 0]
		
		if {[expr {[lsearch -exact $args "-help"] >= 0}]} {
			usage $procname; return
		}
		if {[expr {[lsearch -exact $args "-quiet"] >= 0}]} {
			set quiet_mode 1
			set index [lsearch $args "-quiet"]
			set args [lreplace $args $index $index]
		}
		
		if {[expr {[llength $args] < 1}]} {
			usage $procname; return
		}

		## If forward annotation is disabled
		set mod_inx [lsearch $args "-top_module"]
		if {$mod_inx != -1} {
			set top_design [lindex $args [expr $mod_inx + 1]]
                }
		if {[expr {[lsearch -exact $args "-disable_fa"] >= 0}]} {
			set forward_annotate 0
			set index [lsearch $args "-quiet"]
		}

		## Identify extra hier specified, if any
		set hier_inx [lsearch -exact $args "-hier"]
		if {[expr {$hier_inx >= 0}]} {
####  This extra_hier option doesn't work; looks like IPs will have -hier in their query commands, so shouldn't be needed
#			set extra_hier [lindex $args $hier_inx+1]
			puts_mode "Info: Switch -hier enabled. Extra hierarchy ($extra_hier) will be added at the begining of each constraint path";
		}
		
		## Identify XDC files to convert
		set project_open 0
		set xdc_inx [lsearch -exact $args "-xdc_file"]
		set xdc_files [lindex $args $xdc_inx+1]
		if {[expr {[lsearch -exact $args "-project"] >= 0}]} {
			set xdc_files [project_xdc_file_list]
			set project_open 1
		}
		if {[regexp NT $os]} {
			set xdc_files [space_clean $xdc_files]
		}

		## Identify output FDC files specified, if any
		set user_fdc_file ""
		if {[expr {[lsearch -exact $args "-project"] < 0}]} {
			set fdc_inx [lsearch -exact $args "-fdc_file"]
			if {[expr {$fdc_inx <= 0}]} { set fdc_inx [expr {$xdc_inx + 1}] }
			set user_fdc_file [lindex $args $fdc_inx+1]
		}
		if {[regexp NT $os]} {
			set user_fdc_file [space_clean $user_fdc_file]
		}

		## Remove double quotes if any around file names
		set xdc_files [string map {"\"" ""} $xdc_files]
		set user_fdc_file [string map {"\"" ""} $user_fdc_file]

		## Error out if no XDC file found
		if {[llength $xdc_files] == 0} {
			puts "ERROR:  No active constraint files. Make sure this project is saved before running constraint translation. Please add/enable one or more XDC constraint files."
			return 1
		}

		## Error out if input XDC file is the same as output FDC file
		if {[expr {$user_fdc_file eq $xdc_files}]} {
			puts "ERROR: Output FDC file specified is the same as the input XDC file. Please specify a different output FDC file."
			return 1
		}

		## Open top level log file (only if more than one file is translated)
		if {[llength $xdc_files] > 1} {
			set log_file [project -dir][project -name]_xdc_translation.log
			puts "Opening top level log file $log_file"
			if {[catch {open $log_file w} fpo_top_log]} {
				puts "ERROR:  Can't open output log file $log_file for writing"
				return
			}
		}

		puts_mode "Translating XDC files (Xilinx constraints files). Found following XDC files:\n$xdc_files"
		puts_mode ""
		## Process XDC files, one at a time
		foreach curr_xdc_file $xdc_files {
			set fdc_out_file $user_fdc_file
			## Extract output FDC file name from XDC file name if not supplied
			if {$user_fdc_file eq ""} {
				set rootdir [project -dir]FDC_constraints/[impl -name]
				set basename [file rootname [file tail $curr_xdc_file]]
				set fdc_out_file $rootdir/${basename}_xdc_translated.fdc
			}
			## Run translation on current XDC file
			if [catch [xdc2fdc_one_file $curr_xdc_file $fdc_out_file]] {
				puts_all "ERROR: Internal error during translation from $curr_xdc_file to $fdc_out_file"
				close_log $fpo_log
			}
			## Add translated FDC to project, Move XDC to par_only
			if {$project_open} {
				puts_mode "\nAdding FDC to project, moving XDC under par-only"
				catch [project -removefile $fdc_out_file]
				catch [project -removefile $curr_xdc_file]
				add_file -constraint "$fdc_out_file"
				add_file -xilinx -job_owner par "$curr_xdc_file"
			}
		}
		puts_mode "Please save your project manually"
		if {[llength $xdc_files] > 1} {
			close_log $fpo_top_log
		}
	}

	####  Translation proc: Translate one file
	proc xdc2fdc_one_file {xdc_in_file fdc_out_file} {
		variable top_design
		variable forward_annotate
		variable fpo_log

		## Check if files exist. Also setup output file names and create output directories
		if {[info exists fdc_out_file] && [expr {$fdc_out_file ne ""}]} {
			set rootdir [file dirname $fdc_out_file]
			set rootname [file rootname $fdc_out_file]
			set log_file $rootname.log
		} else {
			set rootdir [project -dir]FDC_constraints/[impl -name]
			set basename [file rootname [file tail $xdc_in_file]]
			set log_file $rootdir/${basename}_xdc_translate.log
			set fdc_out_file $rootdir/${basename}_xdc_translated.fdc
		}
		file mkdir $rootdir
		if {[catch {open $log_file w} fpo_log]} {
			puts_all "ERROR:  Can't open output log file $log_file for writing"
			return
		}

		puts_mode "Running XDC to FDC translation"
		puts_mode "Input XDC constraints file $xdc_in_file"
		puts_mode "Output FDC constraints file $fdc_out_file"
		puts_mode ""

		## Check if files can be opened for read/write
		if {![file exists $xdc_in_file]} {
			puts_all "ERROR: Input XDC file $xdc_in_file does not exist. Please make sure this file exists and re-run of translation"
			close_log $fpo_log
			return
		}
		if {[expr {$xdc_in_file eq $fdc_out_file}]} {
			puts_all "ERROR:  Cannot translate a translated file; remove/disable $fdc_out_file from the current implementation."
			close_log $fpo_log
			return
		}
		if {[file exists $fdc_out_file]} {
			if {[catch {file delete -force $fdc_out_file}]} {
				puts_all "ERROR:  $fdc_out_file already exists and cannot be deleted.  Please manually delete the file to enable a re-run of translation"
				close_log $fpo_log
				return
			}
		}
		if {[catch {open $fdc_out_file a} fpo_tran]} {
			puts_all "ERROR:  Can't open output FDC file $fdc_out_file for writing"
			close_log $fpo_log
			return
		}

		if {$top_design eq ""} {
			set top_design [lindex [file split [file rootname $fdc_out_file]] end]
		}
		set line_num 0
		set long_line ""
		set trimmed_line ""
		set trimmed_long_line ""
		set printable_long_line ""
		set translated_count 0
		set not_translated_count 0
		set this_is_partial_line 0
		set prev_was_partial_line 0
		set prev_line_was_a_blank_line 0
		set prev_constraint_was_removed 0
		set this_is_the_very_first_constraint 1
		set xdc_file_basename [file tail $xdc_in_file]
		if {![catch {open $xdc_in_file r} fpi]} { 
			while {![eof $fpi]} {
				incr line_num
				gets $fpi line
				set new_line $line
				set trimmed_line [string trim $line]
				## Line is partial if it ends with \ character
				if [regexp {[^#]*\\\s*$} $line] {
					set this_is_partial_line 1
					regsub {\\\s*$} $trimmed_line {} $trimmed_line
				}
				## Append line if this is continuation of previous line
				if {$prev_was_partial_line} {
					set trimmed_long_line "$trimmed_long_line $trimmed_line"
					set printable_long_line "$printable_long_line\n$line"
				} else {
					set trimmed_long_line $trimmed_line
					set printable_long_line $line
					set constraint_begin_line_num $line_num
				}
				## If this line is partial go to next iteration of the loop
				if {$this_is_partial_line} {
					set this_is_partial_line 0
					set prev_was_partial_line 1
					continue
				}
				set translated_exception 0
				#### First filter out known-unsupported constraint options
				#### Then filter out known-unsupported constraints
				#### Then process supported constraints
				#### Finally dump messages for unknown constraints
				regsub -all {\-scoped_to_current_instance} $printable_long_line "" printable_long_line
				regsub -all {\-quiet} $printable_long_line "" printable_long_line
				switch -nocase -regexp -- $trimmed_long_line {
					{^\s*#} {if {[regexp {\{|\}} $trimmed_long_line]} {
							continue
						}
					}
					{^\s*$} {}
					{^.*\[\s*get_iobanks\s+} {
						puts $fpo_tran "## Command get_iobanks is not supported in Synplify. Skipping translation. Originated from XDC file line number $constraint_begin_line_num"
						puts_log "Untranslated constraint at line $constraint_begin_line_num of XDC file. See FDC file."
						puts_log $printable_long_line
						puts_log ""
						set printable_long_line "# $printable_long_line"
						incr not_translated_count
					}
					{^set_property\s+LOC.*} {
						regsub {^set_property\s+(\S+)\s+(\S+)\s+(.*)} $printable_long_line {define_attribute \3 syn_loc {\2}} printable_long_line
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
					}
					{^set_property\s+IOB.*} {
						regsub {^set_property\s+(\S+)\s+(\S+)\s+(.*)} $printable_long_line {define_attribute \3 syn_useioff {\2}} printable_long_line
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
					}
					{^set_property\s+IOSTANDARD.*} {
						regsub {^set_property\s+(\S+)\s+(\S+)\s+(.*)} $printable_long_line {define_io_standard \3 syn_pad_type {\2}} printable_long_line
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
					}
					{^set_property\s+SLEW.*} {
						regsub {^set_property\s+(\S+)\s+(\S+)\s+(.*)} $printable_long_line {define_io_standard \3 syn_io_slew {\2}} printable_long_line
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
					}
					{^set_property\s+PACKAGE_PIN.*} {
						regsub {^set_property\s+(\S+)\s+(\S+)\s+(.*)} $printable_long_line {define_attribute \3 syn_loc {\2}} printable_long_line
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
					}
					{^set_property\s+(\S+)\s+(\S+)\s+(.*)} {
						regsub {^set_property\s+(\S+)\s+(\S+)\s+(.*)} $printable_long_line {define_attribute \3 \1 \2} printable_long_line
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
					}
					{^set_property\s+(.*)} {
						regsub {^set_property\s+(.*)} $printable_long_line {define_attribute \1} printable_long_line
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
					}
					{^create_clock\s+(.*)} {
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
					}
					{^create_generated_clock\s+(.*)} {
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
					}
					{^set_clock_groups\s+(.*)} {
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
					}
					{^current_instance\s+(.*)} {
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
						regsub -all {\.} $printable_long_line {@} printable_long_line
						regsub -all {\/} $printable_long_line {.} printable_long_line
						regsub -all {@} $printable_long_line {\\\.} printable_long_line
						regsub -all {\[|\]} $printable_long_line {\\\\&} printable_long_line
					}
					{^set_false_path\s+(.*)} {
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
						set translated_exception 1
					}
					{^set_multicycle_path\s+(.*)} {
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
						set translated_exception 1
					}
					{^set_max_delay\s+(.*)} {
						set printable_long_line [transform_xdc_constraint_to_fdc -syn_path $printable_long_line]
						incr translated_count
						set translated_exception 1
					}
					{.*} {
						puts $fpo_tran "## Unknown constraint, not translated. Originated from XDC file line number $constraint_begin_line_num"
						puts_log "Untranslated constraint at line $constraint_begin_line_num of XDC file. See FDC file."
						puts_log $printable_long_line
						puts_log ""
						set printable_long_line "# $printable_long_line"
						incr not_translated_count
					}
				}
				set prev_was_partial_line 0
				## Elements that end with _reg may not be found during P&R run with original XDC
				set rtl_ff 0
				if {$rtl_ff && [regexp -nocase {_reg\y[^\\\.]} $printable_long_line]} {
					puts_mode "Warning: The following constraint has an element with a _reg suffix in its name. Synthesis may rename this element, and this can cause the constraint not to work if you use the original Xilinx XDC file for P&R. It is suggested that you edit the XDC file and remove _reg from the element name to avoid this problem."
					puts_mode "Line $line_num: $printable_long_line\n"
				}
				## Remove constraints with '[filter ...]' commands
				if {$translated_exception} {
					if [regexp {\[\s*filter} $printable_long_line] {
						set prev_constraint_was_removed 1
						continue
					} else {
						set prev_constraint_was_removed 0
					}
				}
				## Remove '-hold' constraints
				if {$translated_exception} {
					## Do not print lines with '-hold' constraints
					if [regexp {\-hold} $printable_long_line] {
						set prev_constraint_was_removed 1
						continue
					} else {
						set prev_constraint_was_removed 0
					}
				}
				## Remove one extra blank line at the end of removed '-hold' constraint
				if [regexp {^\s*$} $line] {
					if {$prev_constraint_was_removed} {
						if {$prev_line_was_a_blank_line} {
							continue
						}
					}
					set prev_line_was_a_blank_line 1
				} else {
					set prev_line_was_a_blank_line 0
				}
				## Remove {{...}} from around strings; make it {...}
				regsub -all {\{\{([0-9A-Za-z_]+)\}\}} $printable_long_line {{\1}} printable_long_line
				## Print modified constraint to output FDC
				if {![regexp {^\s*$} $printable_long_line] && ![regexp {^\s*#} $printable_long_line] && $this_is_the_very_first_constraint} {
					puts $fpo_tran "## Translated by Synplify from XDC to FDC format"
					if [expr {$forward_annotate == 0}] { 
					  puts $fpo_tran ""
					  puts $fpo_tran "## Internal use only - turn off forward annotation"
					  puts $fpo_tran "set syn_fa_disable 1" 
					  puts $fpo_tran ""
					}
					puts $fpo_tran "define_current_design \{v:$top_design\}"
					puts $fpo_tran "set inst_list \[get_current_design -instance\]"
				#	puts $fpo_tran "define_current_design -top"
					puts $fpo_tran "foreach i \$inst_list {"  ;#}
					puts $fpo_tran "define_current_instance -top"
					puts $fpo_tran "if {\$i ne {}} {"
					puts $fpo_tran "  set i i:\$i"
					puts $fpo_tran "  define_current_instance \$i"
					puts $fpo_tran "}"
					puts $fpo_tran ""
					puts $fpo_tran "set_hierarchy_separator {/}"
					if {$rtl_ff} {
					  puts $fpo_tran "set_rtl_ff_names {_reg}"
					}
					puts $fpo_tran ""
					set this_is_the_very_first_constraint 0
				}
				## Print XDC line number on top of translated constraints
				if {$translated_exception} {
					puts $fpo_tran "## Translated from XDC file line number $constraint_begin_line_num"
				}
				if {[regexp {define_current_instance} $printable_long_line]} {
					if {![regexp {\-top} $printable_long_line]} {
						regsub {define_current_instance\s+(.*)} $printable_long_line {define_current_instance $i.\1} printable_long_line_new
						regsub {define_current_instance\s+(.*)} $printable_long_line {define_current_instance \1} printable_long_line
						puts $fpo_tran "if {\$i ne {}} {"
						puts $fpo_tran $printable_long_line_new
						puts $fpo_tran "} else {"
						puts $fpo_tran $printable_long_line
						puts $fpo_tran "}"
					} else {
						regsub {\-top} $printable_long_line {$i} printable_long_line
						puts $fpo_tran $printable_long_line
					}
				} else {
					puts $fpo_tran $printable_long_line
				}
			} 
			if {$translated_count > 0} { ;#{
				puts $fpo_tran "}"
			#	puts $fpo_tran "define_current_instance -top"
				puts $fpo_tran "define_current_design -top"
				puts $fpo_tran "set syn_fa_disable 0" 
				puts $fpo_tran "set_hierarchy_separator {.}"
			}
		}
		puts_mode "Constraint translation log file $log_file"
		puts_mode ""
		puts_mode "Constraints translated $translated_count, not translated $not_translated_count"
		puts_mode "Constraint translation completed successfully"
		close $fpi
		close $fpo_tran
		close_log $fpo_log
	}

	proc transform_xdc_constraint_to_fdc {object_path_type printable_long_line} {
		#puts "==$printable_long_line"
		############################### XDC Constraint #################################
		#set_false_path -through [get_pins -filter {NAME =~ */DQSFOUND} -of [get_cells -hier -filter {REF_NAME == PHASER_IN_PHY}]]

		############################### FDC Constraint #################################
		#set_false_path -through [get_pins -hier {*/DQSFOUND} -of_objects [get_cells -hier * -filter {@inst_of == PHASER_IN_PHY}]]

		############################### XDC Constraint #################################
		#set_multicycle_path -from [get_cells -hier -filter {NAME =~ */mc0/mc_read_idle_r_reg}] \
		#                    -to   [get_cells -hier -filter {NAME =~ */input_[?].iserdes_dq_.iserdesdq}] \
		#                    -setup 6

		#set_multicycle_path -from [get_cells -hier -filter {NAME =~ */mc0/mc_read_idle_r_reg}] \
		#                    -to   [get_cells -hier -filter {NAME =~ */input_[?].iserdes_dq_.iserdesdq}] \
		#                    -hold 5

		############################### FDC Constraint #################################
		#set_multicycle_path -from [get_cells -hier {*.mc0.mc_read_idle_r_reg}] \
		#					 -to   [get_cells -hier {*.input_\[?\]\.iserdes_dq_\.iserdesdq}] \
		#					 -setup 6

		############################### XDC Constraint ##################################
		#set_multicycle_path -through [get_pins -filter {NAME =~ */OSERDESRST} -of [get_cells -hier -filter {REF_NAME == PHASER_OUT_PHY}]] -setup 2 -start
		
		############################### FDC Constraint ##################################
		#set_multicycle_path -through [get_pins -hier {*/OSERDESRST} -of_objects [get_cells -hier * -filter {@inst_of == PHASER_OUT_PHY}]] -setup 2 -start

		############################### XDC Constraint ##################################
		#set_multicycle_path -to   [get_cells -hier -filter {NAME =~ *temp_mon_enabled.u_mig_7series_v1_8_tempmon/device_temp_sync_r1*}] \
		#                    -setup 12 -end

		#set_multicycle_path -to   [get_cells -hier -filter {NAME =~ *temp_mon_enabled.u_mig_7series_v1_8_tempmon/device_temp_sync_r1*}] \
		#                    -hold 11 -end

		############################### FDC Constraint ##################################
		#set_multicycle_path -to [get_cells -hier {*temp_mon_enabled\.u_mig_7series_v1_8_tempmon.device_temp_sync_r1*}] \
		#					 -setup 12 -end
		## Escape square brackets ([ to \[ and ] to \]) only if quoted with one of the {"'} character and is not escaped already
#		if {$object_path_type eq "-syn_path" && 0} { ## Disabled, not neccessary to escape [] for Synplify
#			set iterations 0
#			set escaped 0; set brace_open 0;
#			set squote_open 0; set dquote_open 0;
#			set string_length [string length $printable_long_line]
#			for {set i 0} {$i < $string_length} {incr i} {
#				set char [string index $printable_long_line $i]
#				set char_for_newline [format %c 0xa]
#				if {$char eq "\{"} { incr brace_open }
#				if {$char eq "\}"} { incr brace_open -1 }
#				if {$char eq "\""} { if {$dquote_open} { set dquote_open 0 } else {set dquote_open 1} }
#				if {$char eq "\'"} { if {$squote_open} { set squote_open 0 } else {set squote_open 1} }
#				if {$char eq "\\"} { if {$escaped} { set escaped 0 } else {set escaped 1} }
#				if {$char eq $char_for_newline} { set escaped 0 }
#				if {($char eq "\[") && (!$escaped && ($brace_open || $squote_open || $dquote_open))} {
#					set printable_long_line [string replace $printable_long_line $i $i \\\[]
#					incr i; incr string_length
#				}
#				if {($char eq "\]") && (!$escaped && ($brace_open || $squote_open || $dquote_open))} {
#					set printable_long_line [string replace $printable_long_line $i $i \\\]]
#					incr i; incr string_length
#				}
#				## These lines below keep the loop from hanging
#				incr iterations
#				if {$iterations >= 2000} { break }
#			}
#		}
		## Change Xiling path separator (/) to (.) and (.) to (\.)
		#if {[regexp {\-filter} $printable_long_line]} {
			#regsub -all {\.} $printable_long_line {\\.} printable_long_line
			#regsub -all {/} $printable_long_line {.} printable_long_line
		#}
		regsub {^\s*current_instance\s*(-quiet|$)} $printable_long_line {define_current_instance -top} printable_long_line
		regsub {^\s*current_instance\s+} $printable_long_line {define_current_instance } printable_long_line
		regsub -all {\[\s+} $printable_long_line {[} printable_long_line
		## Replace -of by -of_objects
		regsub -all -nocase {\-of([^\w]+)} $printable_long_line {-of_objects\1} printable_long_line
		## Replace -filter {NAME =~ xyz} by {xyz} ## Add -hier if not present
		regsub -all  {\s*-filter\s*(\{)*\s*(REF_PIN_)*NAME(\s*=[~=]\s*)([^\s]+\s*\}*)} $printable_long_line \
					{ -filter \1@name\3\4} printable_long_line 
		#regsub -all -nocase {\s*(\-hier\s+)?\s*\-filter\s*\{\s*NAME\s*=[~=]\s*([^\s]+)\s*\}} $printable_long_line \
		#			{ -hier {\2}} printable_long_line
		## Replace "-filter {REF_NAME == xyz}" by "-hier * -filter {@inst_of == xyz} ## Add -hier if not present
#		regsub -all  {\s*(\-hier(archical)*\s+)?\s*\-filter\s+\{\s*REF_NAME\s*(=[~=]\s*[^\s]+)+} $printable_long_line \
#					{ -hier * -filter {@inst_of \3 } printable_long_line ;#}
		regsub -all  {\s*(\-hier(archical)*\s+)?\s*\-filter\s+\{\s*REF_NAME\s*(=[~=]\s*[^\s]+)+} $printable_long_line \
					{ -hier * -filter \{@inst_of \3 } printable_long_line 
		regsub {\\([^\n]+)} $printable_long_line {\1} printable_long_line
#		regsub -all -nocase {(\{|\(*[^-])name(\s*)} $printable_long_line {\1@name\2} printable_long_line
		regsub -all -nocase {([^-@])name(\s*)} $printable_long_line {\1@name\2} printable_long_line
		regsub -all -nocase  {(\{|\(|\s)ref_name\s*} $printable_long_line {\1@inst_of } printable_long_line
		regsub -all -nocase  {(\{|\(|\s)is_sequential\s*} $printable_long_line {\1@is_sequential } printable_long_line
#		regsub -all {([\s\{]+)([^\s=!]+)([=!~]+)([^\s\]\}]+)} $printable_long_line {\1{\2 \3 \4}} printable_long_line
		if {![regsub -all {([\s.]+)([^\s=!~]+)([=!~]+)([^=!~\s\]\}]+)} $printable_long_line {\1{\2 \3 \4}} printable_long_line]} {
			regsub -all {@([a-z]+)([!=~]+)} $printable_long_line {@\1 \2} printable_long_line
		}
                set skip_clean 0
		if {[regexp {get_pins .*@name } $printable_long_line] || [regexp {get_cells .*@name } $printable_long_line]} {
			set printable_long_line [unwind_pin_cell $printable_long_line]
			set skip_clean 1
		}
		regsub -all {get_ports} $printable_long_line {get_nets} printable_long_line 
		## Add {} around paths. Also add extra hierarchy as *. if requested
		set loop_count 0
		#puts_log "YYY1YYY: $printable_long_line :YYYYYY"
		## Convert object paths to Synplify compatible
		if {!$skip_clean} {
			while {[match_constrained_object -bool $printable_long_line]} {
				incr loop_count
				set printable_long_line [cleanup_paths_inside_constraint $printable_long_line]
				if {$loop_count >= 10000} { break }
			}
		}
		#puts_log "YYY2YYY: $printable_long_line :YYYYYY"
		regsub -all "<<<<" $printable_long_line "{" printable_long_line
		regsub -all ">>>>" $printable_long_line "}" printable_long_line
		regsub -all "<<<" $printable_long_line "" printable_long_line
		regsub -all ">>>" $printable_long_line "" printable_long_line
		
		## Make get_* commands case-insensitive to match with Vivado default get_* behaviour
#		regsub -all {get_pins} $printable_long_line {get_pins -nocase} printable_long_line
#		regsub -all {get_nets} $printable_long_line {get_nets -nocase} printable_long_line
#		regsub -all {get_cells} $printable_long_line {get_cells -nocase} printable_long_line
#		regsub -all {get_ports} $printable_long_line {get_ports -nocase} printable_long_line
#		regsub -all {get_clocks} $printable_long_line {get_clocks -nocase} printable_long_line

		#puts_log "YYY3YYY: $printable_long_line :YYYYYY"
		#if [regexp {/} $printable_long_line] { puts "==*==$printable_long_line==*==" }
		return $printable_long_line
	}

	proc unwind_pin_cell {printable_long_line} {
		variable didit
		set one_pin "<>"
		set two_pin "<>"
		set one_cell "<>"
		set two_cell "<>"
		if {![regexp {\[\s*get_cells.*(\[\s*get_cells.*)} $printable_long_line one_cell two_cell]} {
			regexp {\[\s*get_cells.*} $printable_long_line one_cell
		}
		if {![regexp {\[\s*get_pins.*(\[\s*get_pins.*)} $printable_long_line one_pin two_pin]} {
			regexp {\[\s*get_pins.*} $printable_long_line one_pin
		}
		set one_pin [get_bracketed_sqr $one_pin]
		set two_pin [get_bracketed_sqr $two_pin]
		set one_cell [get_bracketed_sqr $one_cell]
		set two_cell [get_bracketed_sqr $two_cell]

		set one_pin_new [sub_strg $one_cell "<cell1>" $one_pin]
		set p1c1 $didit
		set one_pin_new [sub_strg $two_cell "<cell2>" $one_pin_new]
		set p1c2 $didit

		set two_pin_new [sub_strg $one_cell "<cell1>" $two_pin]
		set p2c1 $didit
		set two_pin_new [sub_strg $two_cell "<cell2>" $two_pin_new]
		set p2c2 $didit

		set one_cell_new [sub_strg $one_pin "<pin1>" $one_cell]
		set c1p1 $didit
		set one_cell_new [sub_strg $two_pin "<pin2>" $one_cell_new]
		set c1p2 $didit

		set two_cell_new [sub_strg $one_pin "<pin1>" $two_cell]
		set c2p1 $didit
		set two_cell_new [sub_strg $two_pin "<pin2>" $two_cell_new]
		set c2p2 $didit
		regsub -all {\.} $one_pin_new {\.} one_pin_new
		#### If there is only leaf pin in the @name string (and no instance name),
		#### use @name, else use instance info directly
		if {![regexp {[A-Za-z0-9_]+\**\/.+} $one_pin_new]} {
			regsub {=~\s*\*D} $one_pin_new {=~ *D*} one_pin_new
			regsub {=~\s*\*PRE} $one_pin_new {=~ *S} one_pin_new
			regsub {=~\s*\*CLR} $one_pin_new {=~ *R} one_pin_new
			regsub {=~\s*\*\/} $one_pin_new {=~ *} one_pin_new
		} else {
		#### escape square brackets where needed.  Note at this time that get_pins works better with "/" instead of "."
			set foo [regsub -all {\-filter[^\[\]]+@name\s*..} $one_pin_new "{" one_pin_new]   ;#}
			set pin_list [get_bracketed_crly $one_pin_new]
			set pin_list_new "\{[slash2dot $pin_list -pin]\}"
			set one_pin_new [sub_strg $pin_list $pin_list_new $one_pin_new]
			if {$foo} {
				regsub -all {(\[get_pins.*)\/\*([^\/\{\[]+)([\s\}\]]+)} $one_pin_new {\1/*/\2\3} one_pin_new
				if {[regsub -all {PRE} $one_pin_new {S} one_pin_new]} {
					set pin_list [get_bracketed_crly $one_pin_new]
					set pin_list_new [linsert $pin_list 0 [lindex $pin_list end]]
					regsub {\/S} $pin_list_new {/PRE} pin_list_new
					regsub -all {\}\s*\{} $pin_list_new { } pin_list_new
					set one_pin_new [sub_strg $pin_list $pin_list_new $one_pin_new]
				}
				regsub -all {CLR} $one_pin_new {R} one_pin_new
			}
		}
		if {[regexp {=~} $one_pin_new] && ![regexp {\-of_objects} $one_pin_new]} {
			regsub {get_pins } $one_pin_new {get_pins *.* } one_pin_new
		}
		regsub -all {\.} $two_pin_new {\.} two_pin_new
		if {![regexp {[A-Za-z0-9_]+\**\/.+} $two_pin_new]} {
			regsub {=~\s*\*D} $two_pin_new {=~ *D*} two_pin_new
			regsub {=~\s*\*PRE} $two_pin_new {=~ *S} two_pin_new
			regsub {=~\s*\*CLR} $two_pin_new {=~ *R} two_pin_new
			regsub {=~\s*\*\/} $two_pin_new {=~ *} two_pin_new
		} else {
			set foo [regsub -all {\-filter[^\[\]]+@name\s*..} $two_pin_new "{" two_pin_new]   ;#}
			set pin_list [get_bracketed_crly $two_pin_new]
			set pin_list_new "\{[slash2dot $pin_list -pin]\}"
			set two_pin_new [sub_strg $pin_list $pin_list_new $two_pin_new]
			if {$foo} {
				regsub -all {(\[get_pins.*)\/\*([^\/\{\[]+)([\s\}\]]+)} $two_pin_new {\1/*/\2\3} two_pin_new
				if {[regsub -all {PRE} $two_pin_new {S} two_pin_new]} {
					set pin_list [get_bracketed_crly $two_pin_new]
					set pin_list_new [linsert $pin_list 0 [lindex $pin_list end]]
					regsub {\/S} $pin_list_new {/PRE} pin_list_new
					regsub -all {\}\s*\{} $pin_list_new { } pin_list_new
					set two_pin_new [sub_strg $pin_list $pin_list_new $two_pin_new]
				}
				regsub -all {CLR} $two_pin_new {R} two_pin_new
			}
		}
		if {[regexp {=~} $two_pin_new] && ![regexp {\-of_objects} $two_pin_new]} {
			regsub {get_pins } $two_pin_new {get_pins *.* } two_pin_new
		}
		if {$one_cell_new ne "<>"} {
			regsub -all {\/} $one_cell_new {#} one_cell_new
			regsub -all {&&} $one_cell {@@} one_cell
			regsub -all {&&} $one_cell_new {@@} one_cell_new
			regsub -all {&&} $printable_long_line {@@} printable_long_line
			regsub {@name} $one_cell_new "@hier_rtl_name" one_cell_new
			set one_cell_crly [get_bracketed_crly $one_cell_new]
			set one_cell_crly_new [slash2dot $one_cell_crly]
			regsub -all {PRIMITIVE_SUBGROUP =~ flop} $one_cell_crly_new {@inst_of =~ FD*} one_cell_crly_new
			regsub -all {PRIMITIVE_SUBGROUP =~ GT} $one_cell_crly_new {@inst_of =~ GT*} one_cell_crly_new
			regsub {^} $one_cell_crly_new "{" one_cell_crly_new
			regsub {$} $one_cell_crly_new "}" one_cell_crly_new
			set one_cell_new [sub_strg $one_cell_crly $one_cell_crly_new $one_cell_new]
		}
		if {$two_cell_new ne "<>"} {
			regsub -all {\/} $two_cell_new {#} two_cell_new
			regsub -all {&&} $two_cell {@@} two_cell
			regsub -all {&&} $two_cell_new {@@} two_cell_new
			regsub -all {&&} $printable_long_line {@@} printable_long_line
			regsub {@name} $two_cell_new "@hier_rtl_name" two_cell_new
			set two_cell_crly [get_bracketed_crly $two_cell_new]
			set two_cell_crly_new [slash2dot $two_cell_crly]
			regsub -all {PRIMITIVE_SUBGROUP =~ flop} $two_cell_crly_new {@inst_of =~ FD*} two_cell_crly_new
			regsub -all {PRIMITIVE_SUBGROUP =~ GT} $two_cell_crly_new {@inst_of =~ GT*} two_cell_crly_new
			regsub {^} $two_cell_crly_new "{" two_cell_crly_new
			regsub {$} $two_cell_crly_new "}" two_cell_crly_new
			set two_cell_new [sub_strg $two_cell_crly $two_cell_crly_new $two_cell_new]
		}
		if {$p1c1} {
			set one_pin_new [sub_strg "<cell1>" $one_cell_new $one_pin_new]
		}
		if {$p1c2} {
			set one_pin_new [sub_strg "<cell2>" $two_cell_new $one_pin_new]
		}
		set printable_long_line [sub_strg $one_pin $one_pin_new $printable_long_line]

		if {$p2c1} {
			set two_pin_new [sub_strg "<cell1>" $one_cell_new $two_pin_new]
		}
		if {$p2c2} {
			set two_pin_new [sub_strg "<cell2>" $two_cell_new $two_pin_new]
		}
		set printable_long_line [sub_strg $two_pin $two_pin_new $printable_long_line]

		if {$c1p1} {
			set one_cell_new [sub_strg "<pin1>" $one_pin_new $one_cell_new]
		}
		if {$c1p2} {
			set one_cell_new [sub_strg "<pin2>" $two_pin_new $one_cell_new]
		}
		set printable_long_line [sub_strg $one_cell $one_cell_new $printable_long_line]

		if {$c2p1} {
			set two_cell_new [sub_strg "<pin1>" $one_pin_new $two_cell_new]
		}
		if {$c2p2} {
			set two_cell_new [sub_strg "<pin2>" $two_pin_new $two_cell_new]
		}
		set printable_long_line [sub_strg $two_cell $two_cell_new $printable_long_line]
		regsub -all {@@} $printable_long_line "\\&\\&" printable_long_line

		regsub -all {([0-9]+)\\\.([0-9]+)} $printable_long_line {\1.\2} printable_long_line ;#{
		regsub -all {\s*IS_SEQUENTIAL\s*\}} $printable_long_line " @is_sequential}" printable_long_line
		return $printable_long_line
	}
	
	## Check by matching pattern if it is a design element
	proc match_constrained_object {mode line} {
		#puts_log "XXXXXXXXXXXX0: mode=$mode, line=$line"
		if [regexp {(\s|\{)((\*|\?)(\/|\.)?)?\y(\S+?)\y(\[[^\]]+\])*[\s\}]} $line matched begin prefix aa bb object suffix] {
			#puts_log "XXXXXXXXXXXX1a: prefix=$prefix, object=$object, suffix=$suffix"
			#puts_log "XXXXXXXXXXXX1b: matched=$matched, begin=$begin, aa=$aa, bb=$bb"
			if {$mode eq "-bool"} { return 1 }
			if {$mode eq "-prefix"} { return $prefix }
			if {$mode eq "-object"} { return $object }
			if {$mode eq "-suffix"} { return $suffix }
			return "$prefix $object $suffix"
		}
		if {$mode eq "-bool"} { return 0 }
		return ""
	}
	
	## Change Xiling path separator (/) to (.) and (.) to (\.). Also apply quotes {} around paths.
	## Also add extra hierarchy in front of the paths if requested.
	proc cleanup_paths_inside_constraint {line} {
		variable extra_hier
		#puts_log "YYYYY0: line=$line"

		## If this is an expression (not a path), return without making changes
		## Quoting with "<<<" and ">>>" ensures this object escapes next iteration
		set object [match_constrained_object -object $line]
		if [is_expression $object] {
			set srch "${object}(\[^>\]+)"
			set repl "<<<$object>>>\\1"
			regsub   $srch $line $repl line
			#regsub "$object" $line "<<<$object>>>" line
			return $line
		}
		#puts_log "YYYYY1: line=$line"
		
		## Add {} around paths. Also add extra hierarchy as *. if requested
		if {[match_constrained_object -bool $line]} {
			##lassign [match_constrained_object -all $line] prefix object suffix
			set prefix [match_constrained_object -prefix $line]
			set object [match_constrained_object -object $line]
			set suffix [match_constrained_object -suffix $line]
			set orig_object $object
			set orig_prefix $prefix
			set orig_suffix $suffix
		#puts_log "YYYYY2: prefix=$prefix, object=$object, suffix=$suffix"
			## Change Xilinx path separators to Synplify's
#			regsub -all {\.} $orig_prefix {\.} orig_prefix
#			regsub -all {\.} $orig_object {\.} orig_object
#			regsub -all {\.} $orig_suffix {\.} orig_suffix
#			regsub -all {/} $orig_prefix {.} orig_prefix
#			regsub -all {/} $orig_object {.} orig_object
#			regsub -all {/} $orig_suffix {.} orig_suffix
			set orig_prefix [slash2dot $orig_prefix]
			set orig_object [slash2dot $orig_object]
#			set orig_suffix [slash2dot $orig_suffix]
			## Escape special characters to search in regexp
			regsub -all {\\} $object {\\\\} object
			regsub -all {\*} $object {\*} object
			regsub -all {\.} $object {\.} object
			regsub -all {\?} $object {\?} object
			regsub -all {\[} $object {\[} object
			regsub -all {\]} $object {\]} object
			regsub -all {\*} $prefix {\*} prefix
			regsub -all {\?} $prefix {\?} prefix
			regsub -all {\.} $prefix {\.} prefix
			regsub -all {\*} $suffix {\*} suffix
			regsub -all {\?} $suffix {\?} suffix
			regsub -all {\.} $suffix {\.} suffix
			regsub -all {\[} $suffix {\[} suffix
			regsub -all {\]} $suffix {\]} suffix
		#puts_log "YYYYY2.1: prefix=$prefix, object=$object, suffix=$suffix"
		#puts_log "YYYYY2.2: orig_prefix=$orig_prefix, orig_object=$orig_object, orig_suffix=$orig_suffix"
			## Update $line to reflect changes, Quoting with "<<<<" and ">>>>" ensures this object escapes next iteration
		#puts_log "YYYYY3: line=$line"
			if {[info exists extra_hier] && ($extra_hier ne "")} {
				if [regexp {^\*} $orig_prefix] {
					#regsub -all "{?$prefix$object$suffix}?" $line "<<<<$orig_prefix$orig_object$orig_suffix>>>>" line
					#regsub -all "$prefix$object$suffix" $line "<<<<$orig_prefix$orig_object$orig_suffix>>>>" line
					set srch "$prefix$object${suffix}(\[^>\]+)"
					set repl "<<<<$orig_prefix$orig_object$orig_suffix>>>>\\1"
					regsub   $srch $line $repl line
		#puts_log "YYYYY3.1: line=$line"
		#puts_log "YYYYY3.1a: from={?$prefix$object$suffix}?, to=<<<<$orig_prefix$orig_object$orig_suffix>>>>"
				} else {
					#regsub -all "{?$prefix$object$suffix}?" $line "<<<<$extra_hier$orig_prefix$orig_object$orig_suffix>>>>" line
					#regsub -all "$prefix$object$suffix" $line "<<<<$extra_hier$orig_prefix$orig_object$orig_suffix>>>>" line
					set srch "$prefix$object${suffix}(\[^>\]+)"
					set repl "<<<<$extra_hier$orig_prefix$orig_object$orig_suffix>>>>\\1"
					regsub   $srch $line $repl line
		#puts_log "YYYYY3.2: line=$line"
		#puts_log "YYYYY3.2a: from={?$prefix$object$suffix}?, to=<<<<$extra_hier$orig_prefix$orig_object$orig_suffix>>>>"
				}
			} else {
		#puts_log "YYYYY3.3: line=$line"
				#regsub -all "{?$prefix$object$suffix}?" $line "<<<<$orig_prefix$orig_object$orig_suffix>>>>" line
				#regsub -all "$prefix$object$suffix" $line "<<<<$orig_prefix$orig_object$orig_suffix>>>>" line
				set srch "$prefix$object${suffix}(\[^>\]+)"
				set repl "<<<<$orig_prefix$orig_object$orig_suffix>>>>\\1"
				regsub   $srch $line $repl line
		#puts_log "YYYYY3.3: line=$line"
		#puts_log "YYYYY3.3a: from={?$prefix$object$suffix}?, to=<<<<$orig_prefix$orig_object$orig_suffix>>>>"
			}
			#if [regexp {/} $line] { puts "==line=$line" }
			#if [regexp {/} $line] { puts "==1== prefix=$prefix, object=$object, suffix=$suffix ==1==" }
			#if [regexp {/} $line] { puts "==2== prefix=$orig_prefix, object=$orig_object, suffix=$orig_suffix ==2==" }
		}
		#puts_log "YYYYY4: line=$line"

		return $line
	}
	
  proc slash2dot {args} {
    set pin 0
    if {[llength $args] > 1} {
      if {[lindex $args [lsearch -regexp $args {^[-]}]] eq "-pin"} {
        set pin 1
      } else {
      puts "ERROR:  Please speficy a single list argument"
      return {}
      }
    }
    set ret_l {}
    set strg_l [lindex $args [lsearch -regexp $args {^[^-]}]]
    if {$strg_l ne {}} {
      foreach strg $strg_l {
#        regsub -all {\)} $strg {]} strg
#        regsub -all {\(} $strg {[} strg
        regsub -all {\>} $strg {]} strg
        regsub -all {\<} $strg {[} strg
        regsub -all {\[|\]} $strg {\\&} strg
        if {![regsub -all {\\\[([0-9\*]+)\\\]\/([A-Z]+)$} $strg {[\1]/\2} strg]} {
          regsub -all {\\\[([0-9\*]+)\\\]$} $strg {[\1]} strg
        }
        if {!$pin} {
          regsub -all {\.} $strg {\.} strg
          regsub -all {\/} $strg {.} strg
        }
        regsub -all {#} $strg {.} strg
#      set ret_l [linsert $ret_l end $strg]
        return $strg
      }
    }
    return ""
#    return $ret_l
  }

	## Check if the string is an expression such as 5.4, 5/4, $a/4 etc
	proc is_expression {expr} {
		if [regexp {^[0-9\/\*\+\-\.]+$} $expr] { return 1 }
		return 0
	}
	
	## Extract all files from the project that match the pattern
	proc project_xdc_file_list {} {
		set filelist ""
		set project_file [project -file]
		if {![catch {open $project_file r} fpi]} { 
			while {![eof $fpi]} {
				gets $fpi line
				set line [string trim $line]
				if [regexp -nocase {\"(.*\.xdc)\"} $line] {
					regexp -nocase {\"(.*\.xdc)\"} $line {\1} file
					lappend filelist $file
				} elseif [regexp -nocase {([^\s]*\.xdc)\y} $line] {
					regexp -nocase {([^\s]*\.xdc)\y} $line {\1} file
					lappend filelist $file
				}
			}
		} else {
			puts "ERROR: Failed to open project file $project_file"
		}
		set filelist [space_clean $filelist]
		return $filelist;
	}
	
	## Extract all files from the project that match the pattern
	## The following proc does not work yet as project -filelist command does not fully work yet
	proc project_file_list_old {} {
		set filelist [project -filelist]
		set xdc_files ""
		#lappend filelist [impl_files -ucf]
		#lappend filelist [impl_files -ncf]
		#lappend filelist [impl_files -constraint]
		#lappend filelist [impl_files -fpga_constraint]
		## Only translate XDC files
		foreach file $filelist {
			if [regexp -nocase {\"(.*\.xdc)\"} $file matched file] {
				lappend xdc_files $file
			}
		}
		return $xdc_files
	}

	proc usage {cmdname} {
		puts "Usage:"
		puts "    Mode 1: Translate all XDC files in current project."
		puts "        $cmdname -project"
		puts ""
		puts "    Mode 2: Translate supplied file. Current project is not affected."
		puts "        $cmdname -xdc_file <file>.xdc -fdc_file <file>.fdc"
		puts ""
		return 1
	}

	proc close_log {fp} {
		variable fpo_log
		variable fpo_top_log
		if {![info exists fp] || [expr {$fp eq ""}]} { puts "ERROR: empty fp"; return }
		if {[info exists fpo_log] && [expr {$fp eq $fpo_log}]} {
			catch [close $fpo_log]; unset fpo_log; return
		}
		if {[info exists fpo_top_log] && [expr {$fp eq $fpo_top_log}]} {
			catch [close $fpo_top_log]; unset fpo_top_log; return
		}
		catch [close $fp]
	}
	
	proc puts_all {message} {
		variable fpo_log
		variable fpo_top_log
		if [info exists fpo_log] { puts $fpo_log $message }
		if [info exists fpo_top_log] { puts $fpo_top_log $message }
		puts $message
	}

	proc puts_log {message} {
		variable fpo_log
		variable fpo_top_log
		if [info exists fpo_log] { puts $fpo_log $message }
		if [info exists fpo_top_log] { puts $fpo_top_log $message }
	}

	proc puts_mode {message} {
		variable fpo_log
		variable fpo_top_log
		variable quiet_mode
		if [info exists fpo_log] { puts $fpo_log $message }
		if [info exists fpo_top_log] { puts $fpo_top_log $message }
		if {!$quiet_mode} { puts $message }
	}
	
	proc space_clean {files} {
		variable os
		if {[llength $files] == 0} { return	}
		if {[regexp NT $os]} {
			regsub -all { (.:)} $files {\" \"\1} files
		} else {
			regsub -all { (\/)} $files {\" \"\1} files
		}
		regsub {^} $files {"} files
		return [regsub {$} $files {"}]
	}

	proc make_exp {item} {
	  return [regsub -all {\\|\.|\(|\)|\||\^|\?|\[|\]|\{|\}|\*} $item {\\&}]
	}

	proc sub_strg {old new strg} {
	  variable didit
          if {$strg eq "<>"} {
	    set didit 0
	    return "<>"
	  }
	  set old [make_exp $old]
          set didit [regsub $old $strg $new strg]
#	  return [regsub $old $strg $new]
	  return $strg
	}
	
	proc get_bracketed_sqr {strg} {
	  set opn "\["
	  set cls "\]"
	  set s_indx [string first $opn $strg]
	  set c_indx [expr $s_indx + 1]
	  set cnt 1
	  set max_indx [expr [string length $strg] - 1]
	  while {$c_indx <= $max_indx} {
	    set c [string index $strg $c_indx]
	    if {$c eq $opn} {incr cnt}
	    if {$c eq $cls} {incr cnt -1}
	    if {$cnt == 0} {
	      return [string range $strg $s_indx $c_indx]
	    }
	    incr c_indx
	  }
	  return $strg
	}

	proc get_bracketed_crly {strg} {
	  set opn "\{"
	  set cls "\}"
	  set s_indx [string first $opn $strg]
          if {$s_indx == -1} {
	    regexp {([^\s]+)\s*\]} $strg dummy foo
	    return $foo
	  }
	  set c_indx [expr $s_indx + 1]
	  set cnt 1
	  set max_indx [expr [string length $strg] - 1]
	  while {$c_indx <= $max_indx} {
	    set c [string index $strg $c_indx]
	    if {$c eq $opn} {incr cnt}
	    if {$c eq $cls} {incr cnt -1}
	    if {$cnt == 0} {
	      return [string range $strg $s_indx $c_indx]
	    }
	    incr c_indx
	  }
	  return $strg
	}
}

if {[info commands ip_xdc2fdc] ne "ip_xdc2fdc"} {
	namespace import xilinx_ip_constraints::ip_xdc2fdc
}
