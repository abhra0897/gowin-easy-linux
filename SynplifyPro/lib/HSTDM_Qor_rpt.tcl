# Copyright (C) 2014-2017 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
#
# A tcl function running in Vivado to load the checkpoint in a given folder
# and report timing and utilization about HSTDM
#
# used by protocompiler command: report_timing -hstdm_par -par_dir <strg>
#

# return 1 if error
# return 0 if success
proc load_post_route_dcp {{dcp_path "./"}} {
    set dcps ""
    set post_route_dcp ""
    if {![catch {glob -directory "${dcp_path}" *.dcp} dcps]} {
        foreach dcp $dcps {
            if {[regexp "post_place\.dcp" $dcp dummy]} {continue}
            set post_route_dcp $dcp
        }
    }
    if {$post_route_dcp==""} {
        puts "No post route dcp files in $dcp_path"
        return 1
    }
    puts "Opening checkpoint $post_route_dcp"
    # do not forget close the design at the end
    if {[catch {open_checkpoint $post_route_dcp -quiet}]} {
        puts "Fail to load design $post_route_dcp"
        return 1
   }
   puts "Design Properties"
   report_property [current_design]
   return 0
}
proc close_design_with_message {} {
    puts "Closing design"
    close_design
}

# parameters:
#   -dcp_path: vivado implimentation folder
#   -output_path
#   -open_checkpoint: if design is already loaded, set to 0, otherwise set to 1
#   -report_missing_constraints: generate channel-oriented reports (slow)
#   -report_number_slices: reports number of slices used by each hstdm module
proc report_hstdm_qor {args} {
    # default args value
    set dcp_path "[pwd]"
    set output_path ""
    set open_checkpoint 1
    set report_missing_constraints 1
    set report_number_slices 0
    # parse arguments
    set arguments [join $args " "]
    if {[catch  {array set argArray $arguments} dummy]} {
        set procName [lindex [info level 0] 0]
        puts "Error using ${procName}!\nUsage: ${procName} \[-dcp_path <DCP_PATH>\] \[-output_path <OUTPUT_PATH>\] \[-open_checkpoint <0|1>\] \[-report_missing_constraints <0|1>\] \[-report_number_slices <0|1>\]"
        return
    }
    set argNameList "dcp_path output_path open_checkpoint report_missing_constraints report_number_slices"
    foreach argName $argNameList {
        if {[array name argArray "-$argName"]=="-$argName"} {
            set $argName $argArray(-$argName)
            array unset argArray "-$argName"
        }
    }
    foreach errorArgName [array name argArray] {
        puts "Warning! Ignoring parameter \"$errorArgName\" with value \"$argArray($errorArgName)\""
    }

    # assume there are two dcp files. one is post_place.dcp, the other one is <design>.dcp
    set num "[0-9]+"
    set double "-?${num}\.${num}"
    set alpha "\[^ \]+"
    if {${output_path}==""} {
        set output_path $dcp_path
    }
    if {$open_checkpoint==1} {
        if {[load_post_route_dcp $dcp_path]} {
            return
        }
    }
    # functions to get hstdm clocks
    # It is hard to rename clocks like "clkoutphy_DIV" on ultrascale device. 
    # (The nmae clkoutphy_DIV is from the net and there is no reliable way to preserve a net name)
    # But the master clock names should be starting with "hstdm_txclk".
    # Here we add "-include_generated_clocks" to cover all HSTDM clocks.
    proc get_string_get_hstdm_txclk {} {
        return "get_clocks \{hstdm_txclk*\} -include_generated_clocks -quiet"
    }
    proc get_string_get_hstdm_rxclk {} {
        return "get_clocks \{hstdm_rxclk*\} -include_generated_clocks -quiet"
    }
    proc get_string_hstdm_tx_mux_end {{cpm_snd "cpm_snd_*"}} {
        # serdes for haps70
        # SERDES for haps80 component
        # BITSLICE for haps80 native
        return "get_cells -quiet \{${cpm_snd}/*\} -filter \{PRIMITIVE_SUBGROUP==BITSLICE || PRIMITIVE_SUBGROUP==serdes || PRIMITIVE_SUBGROUP==SERDES\}"
    }
    proc get_string_hstdm_rx_mux_start {{cpm_rcv "cpm_rcv_*"}} {
        # serdes for haps70
        # SERDES for haps80 component
        # BITSLICE for haps80 native
        return "get_cells -quiet \{${cpm_rcv}/*\} -filter \{PRIMITIVE_SUBGROUP==BITSLICE || PRIMITIVE_SUBGROUP==serdes || PRIMITIVE_SUBGROUP==SERDES\}"
    }
    proc get_clocks_hstdm_clocks {} {
        return [get_clocks {hstdm_txclk* hstdm_rxclk*} -include_generated_clocks -quiet]
    }
    proc get_clocks_hstdm_txclk {} {
        return [eval get_string_get_hstdm_txclk]
    }
    proc get_clocks_hstdm_rxclk {} {
        return [eval get_string_get_hstdm_rxclk]
    }
    proc get_additional_hstdm_clocks {} {
        # addtional clock that we would like to put HSTDM clock table besides hstdm_txclk and hstdm_rxclk
        set rt ""
        set rt [concat $rt [get_clocks {HAPS_umr_clk* hstdm_refclk*} -quiet]]
        return $rt
    }
    proc get_non_hstdm_clocks {} {
        set all_clocks [get_clocks * -quiet]
        set hstdm_clocks [concat [get_clocks_hstdm_clocks] [get_additional_hstdm_clocks]]
        set rt ""
        foreach clk $all_clocks {
            if {[lsearch -all -inline -exact $hstdm_clocks $clk]==""} {
                lappend rt $clk
            }
        }
        return $rt
    }

    set dir "${output_path}/HSTDM_Qor_rpt"
    file mkdir ${dir}
    # check if design use hstdm
    set hasHSTDM [expr {[get_clocks_hstdm_clocks]!=""}]
    if {$hasHSTDM==0} {
        puts "No HSTDM"
        if {$open_checkpoint==1} {
            close_design_with_message
        }
        return
    }

    set dir_hstdm "${dir}/timing_intra_hstdm"
    set dir_user  "${dir}/timing_from_to_hstdm"
    set dir_constraints "${dir}/HSTDM_constraints"
    file mkdir "$dir_hstdm"
    file mkdir "$dir_user"
    file mkdir "$dir_constraints"
    # Paths from/to HSTDM TX clocks and HSTDM RX clocks
    proc dump_one_timing_file {from_point to_point file_name {delay_type "min_max"}} {
        set rt "NO_PATH"
        set max_paths 100
        set WNS ""
        set WHS ""
        # solve file name problem
        set file_name [string map {"|" "_"} $file_name]
        if {$from_point!=""} {set from "-from $from_point"} else {set from ""}
        if {$to_point!=""} {set to "-to $to_point"} else {set to ""}
        set timing_path [eval "get_timing_paths -quiet $from $to -sort_by slack -delay_type min_max -unique_pins -verbose"]
        if {$timing_path!=""} {
            puts "Checking timing from ${from_point} to ${to_point}"
            set exception [get_property EXCEPTION $timing_path]
            set async_violated 0
            set min_violated 0
            set max_violated 0
            if {[regexp "Asynchronous Clock Groups" $exception dummy]} {
                set rt "ASYNC"
                set violated "_ASYNC"
                set async_violated 1
            } else {
                set violated ""
                if {[regexp "min" $delay_type dummy]} {
                    set timing_path [eval "get_timing_paths -quiet $from $to -sort_by slack -delay_type min -unique_pins -verbose"]
                    if {$timing_path!=""} {
                        set slack [get_property SLACK $timing_path]
                        if {$slack!="" && $slack<0} {
                            set timing_path_delay_type [lindex [get_property DELAY_TYPE $timing_path] 0]
                            lappend violated $timing_path_delay_type
                            set min_violated 1
                        }
                        set WHS $slack
                    }
                }
                if {[regexp "max" $delay_type dummy]} {
                    set timing_path [eval "get_timing_paths -quiet $from $to -sort_by slack -delay_type max -unique_pins -verbose"]
                    if {$timing_path!=""} {
                        set slack [get_property SLACK $timing_path]
                        if {$slack!="" && $slack<0} {
                            set timing_path_delay_type [lindex [get_property DELAY_TYPE $timing_path] 0]
                            lappend violated $timing_path_delay_type
                            set max_violated 1
                        }
                        set WNS $slack
                    }
                }
                set rt [join $violated "_"]
                set violated [join $violated "_"]
                if {$violated!=""} {
                    set violated "_VIOLATED_$violated"
                }
            }
            if {$min_violated==1 && $max_violated==1} {
                # report separately when there are bot min and max violation
                eval "report_timing -quiet $from $to -max_paths $max_paths -nworst $max_paths -sort_by slack -delay_type max -file \"${file_name}_VIOLATED_max.rpt\" -unique_pins -verbose"
                eval "report_timing -quiet $from $to -max_paths $max_paths -nworst $max_paths -sort_by slack -delay_type min -file \"${file_name}_VIOLATED_min.rpt\" -unique_pins -verbose"
            } else {
                eval "report_timing -quiet $from $to -max_paths $max_paths -nworst $max_paths -sort_by slack -delay_type min_max -file \"${file_name}${violated}.rpt\" -unique_pins -verbose"
            }
        }
        return "{$rt} {$WNS} {$WHS}"
    }
    proc dump_all_timing_files {clock_list dir_cur} {
        # from/to hstdm_txclkdiv/hstdm_rxclkdiv
        set return_list ""
        foreach clk $clock_list {
            set rt [dump_one_timing_file "\[[get_string_get_hstdm_txclk]\]" "\[get_clocks \{$clk\}\]" "$dir_cur/timing_hstdm_txclk_to_${clk}"]
            if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
                lappend return_list "{hstdm_txclk*} {$clk} $rt"
            }
            set rt [dump_one_timing_file "\[get_clocks \{$clk\}\]" "\[[get_string_get_hstdm_txclk]\]" "$dir_cur/timing_${clk}_to_hstdm_txclk"]
            if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
                lappend return_list "{$clk} {hstdm_txclk*} $rt"
            }
            set rt [dump_one_timing_file "\[[get_string_get_hstdm_rxclk]\]" "\[get_clocks \{$clk\}\]" "$dir_cur/timing_hstdm_rxclk_to_${clk}"]
            if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
                lappend return_list "{hstdm_rxclk*} {$clk} $rt"
            }
            set rt [dump_one_timing_file "\[get_clocks \{$clk\}\]" "\[[get_string_get_hstdm_rxclk]\]" "$dir_cur/timing_${clk}_to_hstdm_rxclk"]
            if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
                lappend return_list "{$clk} {hstdm_rxclk*} $rt"
            }
        }
        # return list: start_point end_point violation WNS WHS
        return $return_list
    }
    ####################
    # from_to_hstdm
    ##########
    puts "Reporting from/to HSTDM paths timing"
    set non_hstdm_clocks [get_non_hstdm_clocks]
    set inter_hstdm_list [dump_all_timing_files $non_hstdm_clocks $dir_user]
    ####################
    # intra hstdm timing reportre
    ##########
    puts "Reporting intra HSTDM paths timing"
    set intra_hstdm_list [dump_all_timing_files [get_additional_hstdm_clocks] $dir_hstdm]
    set dir_cur $dir_hstdm
    set rt [dump_one_timing_file "\[[get_string_get_hstdm_txclk]\]" "\[[get_string_get_hstdm_txclk]\]" "$dir_cur/timing_hstdm_txclk_to_hstdm_txclk"]
    if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
        lappend intra_hstdm_list "{hstdm_txclk*} {hstdm_txclk*} $rt"
    }
    set rt [dump_one_timing_file "\[[get_string_get_hstdm_txclk]\]" "\[[get_string_get_hstdm_rxclk]\]" "$dir_cur/timing_hstdm_txclk_to_hstdm_rxclk"]
    if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
        lappend intra_hstdm_list "{hstdm_txclk*} {hstdm_rxclk*} $rt"
    }
    set rt [dump_one_timing_file "\[[get_string_get_hstdm_rxclk]\]" "\[[get_string_get_hstdm_txclk]\]" "$dir_cur/timing_hstdm_rxclk_to_hstdm_txclk"]
    if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
        lappend intra_hstdm_list "{hstdm_rxclk*} {hstdm_txclk*} $rt"
    }
    set rt [dump_one_timing_file "\[[get_string_get_hstdm_rxclk]\]" "\[[get_string_get_hstdm_rxclk]\]" "$dir_cur/timing_hstdm_rxclk_to_hstdm_rxclk"]
    if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
        lappend intra_hstdm_list "{hstdm_rxclk*} {hstdm_rxclk*} $rt"
    }
    set rt [dump_one_timing_file "\[[get_string_hstdm_rx_mux_start]\]" "\[[get_string_get_hstdm_rxclk]\]" "$dir_cur/timing_hstdm_mux_from_rcv"]
    if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
        lappend intra_hstdm_list "{hstdm_rcv (mux)} {} $rt"
    }
    set rt [dump_one_timing_file "\[[get_string_get_hstdm_txclk]\]" "\[[get_string_hstdm_tx_mux_end]\]" "$dir_cur/timing_hstdm_mux_to_snd"]
    if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
        lappend intra_hstdm_list "{} {hstdm_snd (mux)} $rt"
    }
    set rt [dump_one_timing_file "\[get_cells \{cpm_rcv_*/*\} -quiet\]" "\[get_cells \{cpm_snd_*/*\} -quiet\]" "$dir_cur/timing_cpm_rcv_to_cpm_snd"]
    if {![regexp "NO_PATH" [lindex $rt 0] dummy]} {
        lappend intra_hstdm_list "{hstdm_rcv} {hstdm_snd (multi hop)} $rt"
    }
    ####################
    # report clock summary
    ##########
    proc get_hstdm_rpt_section_header {header} {
        set rt ""
        append rt [string repeat "=" 50]
        append rt "\n| ${header}\n"
        append rt [string repeat "-" 50]
        return $rt
    }
    proc get_table_column_width {header rows} {
        set numColumn [llength $header]
        set width ""
        foreach headerCol $header {
            lappend width [string length $headerCol]
        }
        # find column width
        foreach row $rows {
            for {set i 0} {$i<$numColumn} {incr i} {
                set col [lindex $row $i]
                set curWidth [lindex $width $i]
                set newWidth [string length $col]
                if {$curWidth<$newWidth} {
                    set width [lreplace $width $i $i $newWidth]
                }
            }
        }
        return $width
    }
    proc get_formated_table {table_header table_entry_list} {
        set rt ""
        set column_width_list [get_table_column_width $table_header $table_entry_list]
        set table_sep ""
        foreach column_width $column_width_list {
            set abs_w [expr {abs($column_width)}]
            lappend table_sep [string repeat "-" ${abs_w}]
        }
        set table_list ""
        lappend table_list $table_header
        lappend table_list $table_sep
        append table_list " $table_entry_list"
        foreach row $table_list {
            for {set i 0} {$i<[llength $row]} {incr i} {
                set col [lindex $row $i]
                set col_w [lindex $column_width_list $i]
                set col_is_num [expr {$col!="" && [catch {expr {abs($col)}}]==0}]
                # number align to right (by using postive number)
                set fmt "%[expr {$col_is_num?"":"-"}][expr {$col_w}]s  "
                append rt "[format $fmt $col]"
            }
            append rt "\n"
        }
        return $rt
    }
    proc get_hstdm_issue_list {hstdm_clock_list {issue_column_idx 2}} {
        # {From_Clock} {To_Clock} {Violation} {WNS} {WHS}
        set rt ""
        if {$hstdm_clock_list!=""} {
            foreach row $hstdm_clock_list {
                set issue [lindex $row $issue_column_idx]
                if {[expr {[join $issue "_"]!=""}]} {
                    lappend rt $row
                }
            }
        }
        return $rt
    }
    proc get_cdc_issue_table {cdc_rpt} {
        # return only issue rows in a cdc table
        set rt_header ""
        set rt_table ""
        set rt ""
        set start 0
        set end 0
        set line_idx 0
        while {$end>=0} {
            set end [string first "\n" $cdc_rpt $start]
            set line [string range $cdc_rpt $start $end]
            if {$line_idx<2} {
                append rt_header $line
            }
            if {[regexp "Asynch Clock Groups" $line dummy]} {
                # first two rows are the table header
                append rt_table $line
            }
            set start [expr {$end+1}]
            incr line_idx
        }
        if {$rt_table!=""} {
            set rt "${rt_header}${rt_table}"
        }
        return $rt
    }
    set timing_table_header "{Start Clocks/Points} {End Clocks/Points} {Violations} {Worst Negative Slack} {Worst Hold Slack}"
    set inter_issue_list ""
    set intra_issue_list ""
    set to_hstdm_cdc_issue_table ""
    set from_hstdm_cdc_issue_table ""
    ####################
    # report summary
    ##########
    if {$inter_hstdm_list!="" || $intra_hstdm_list!=""} {
        puts "Reporting HSTDM timing summary"
        # always create this file as long as HSTDM is used in the design
        set rpt_name "${dir}/clock_summary.rpt"
        set log [open $rpt_name w]
        # Vivado Version
        puts $log [get_hstdm_rpt_section_header "Tool Version"]
        puts $log [version]
        puts $log "\n"
        # Design Property (including vivado version for the design)
        puts $log [get_hstdm_rpt_section_header "Design Properties"]
        puts $log [report_property [current_design] -return_string]
        puts $log "\n"
        # From To HSTDM Clock Table
        puts $log [get_hstdm_rpt_section_header "From To HSTDM Clock Table"]
        puts $log [get_formated_table $timing_table_header $inter_hstdm_list]
        puts $log "\n"
        set inter_issue_list [get_hstdm_issue_list $inter_hstdm_list 2]
        # Intra HSTDM Clock Table
        puts $log [get_hstdm_rpt_section_header "Intra HSTDM Clock Table"]
        puts $log [get_formated_table $timing_table_header $intra_hstdm_list]
        puts $log "\n"
        set intra_issue_list [get_hstdm_issue_list $intra_hstdm_list 2]
        # To HSTDM Clock Domain Crossing Report
        puts "Checking to HSTDM clock domain crossing paths"
        set rt [report_cdc -from [get_clocks $non_hstdm_clocks] -to [get_clocks_hstdm_txclk] -summary -verbose -quiet -no_header -return_string]
        puts $log [get_hstdm_rpt_section_header "To HSTDM Clock Domain Crossing Report"]
        puts $log $rt
        puts $log "\n"
        set to_hstdm_cdc_issue_table [get_cdc_issue_table $rt]
        # From HSTDM Clocl Domain Crossing Report
        puts "Checking from HSTDM clock domain crossing paths"
        set rt [report_cdc -from [get_clocks_hstdm_rxclk] -to [get_clocks $non_hstdm_clocks] -summary -verbose -quiet -no_header -return_string]
        puts $log [get_hstdm_rpt_section_header "From HSTDM Clocl Domain Crossing Report"]
        puts $log $rt
        puts $log "\n"
        set from_hstdm_cdc_issue_table [get_cdc_issue_table $rt]
        # HSTDM Clock Pulse Width Report
        puts "Checking HSTDM clock pulse width"
        puts $log [get_hstdm_rpt_section_header "HSTDM Clock Pulse Width Report"]
        puts $log [report_pulse_width -clocks [get_clocks_hstdm_clocks] -verbose -quiet -no_header -return_string]
        puts $log "\n"
        # End
        puts $log [get_hstdm_rpt_section_header "End of report"]
        close $log
    }
    ####################
    # report issues
    ##########
    if {$inter_issue_list!="" || $to_hstdm_cdc_issue_table!="" || $from_hstdm_cdc_issue_table!=""} {
        puts "Reporting from/to HSTDM paths issues"
        # do not create this file unless there is a problem
        set rpt_name "${dir}/clock_summary_from_to_HSTDM_path_issues.rpt"
        set log [open $rpt_name w]
        if {$inter_issue_list!=""} {
            puts $log [get_hstdm_rpt_section_header "From To HSTDM Clock Issues"]
            puts $log [get_formated_table $timing_table_header $inter_issue_list]
            puts $log "\n"
        }
        if {$to_hstdm_cdc_issue_table!=""} {
            puts $log [get_hstdm_rpt_section_header "To HSTDM Clock Domain Crossing Issues"]
            puts $log $to_hstdm_cdc_issue_table
            puts $log "\n"
        }
        if {$from_hstdm_cdc_issue_table!=""} {
            puts $log [get_hstdm_rpt_section_header "From HSTDM Clock Domain Crossing Issues"]
            puts $log $from_hstdm_cdc_issue_table
            puts $log "\n"
        }
        puts $log [get_hstdm_rpt_section_header "End of report"]
        close $log
        # clock domain crossing issues
        if {$to_hstdm_cdc_issue_table!="" || $from_hstdm_cdc_issue_table!=""} {
            puts "Reporting HSTDM clock domain crossing issues"
            set rpt_name "${dir_constraints}/HSTDM_constraints_async_clk_grp.xdc"
            # do not create this file unless there is a problem
            set log [open "$rpt_name" w]
            puts $log "# following clocks are asynchronous to HSTDM clocks, constraints will not apply."
            puts -nonewline $log "# "
            puts -nonewline $log [string map {"\n" "\n# "} [get_hstdm_rpt_section_header "HSTDM Clock Domain Crossing Issues"]]
            puts -nonewline $log "\n# "
            puts -nonewline $log [string map {"\n" "\n# "} $to_hstdm_cdc_issue_table]
            puts -nonewline $log [string map {"\n" "\n# "} $from_hstdm_cdc_issue_table]
            close $log
        }
    } else {
        puts "Found no from/to HSTDM paths issues"
    }
    set pulse_width_issue_rpt [report_pulse_width -clocks [get_clocks_hstdm_clocks] -verbose -quiet -no_header -all_violators -return_string]
    if {$intra_issue_list!="" || $pulse_width_issue_rpt!=""} {
        puts "Reporting intra HSTDM paths issues"
        # do not create this file unless there is a problem
        set rpt_name "${dir}/clock_summary_intra_HSTDM_path_issues.rpt"
        set log [open $rpt_name w]
        if {$intra_issue_list!=""} {
            puts $log [get_hstdm_rpt_section_header "Intra HSTDM Clock Issues"]
            puts $log [get_formated_table $timing_table_header $intra_issue_list]
            puts $log "\n"
        }
        if {$pulse_width_issue_rpt!=""} {
            puts $log [get_hstdm_rpt_section_header "HSTDM Clock Pulse Width Issues"]
            puts $log $pulse_width_issue_rpt
            puts $log "\n"
        }
        puts $log [get_hstdm_rpt_section_header "End of report"]
        close $log
    } else {
        puts "Found no intra HSTDM paths issues"
    }

    ####################
    # check data path only constraints between user and HSTDM
    ##########
    if {$report_missing_constraints==1} {
        report_hstdm_missing_constraints_wrapper -dcp_path $dir -output_path $dir_constraints -open_checkpoint 0
    }

    ####################
    # utilization of pblocks
    ##########
    puts "Reporting Utilization of pblocks"
    set pblock_util ""
    foreach pblock "[get_pblocks -quiet]" {
        set rt [report_utilization -quiet -pblocks $pblock -return_string -no_primitives]
        set start 0
        set end 0
        while {$end>=0} {
			set GRID_RANGES [get_property GRID_RANGES [get_pblocks $pblock]]
            set end [string first "\n" $rt $start]
            set line [string range $rt $start $end]
            set line [string map {| HHH} $line]
            # it is slice for Virtex7
            if {[regexp "HHH *Slice *HHH *([0-9]+) HHH *([0-9]+) HHH *([0-9]+) HHH *([0-9]+) HHH *([0-9]+) HHH *([0-9]+) HHH *(.*) HHH" $line dummy parent child nonassigned used fixed available util]} {
                lappend pblock_util "$pblock $parent $child $nonassigned $used $fixed $available $util {$GRID_RANGES}"
                break
            }
            # it is CLB for UltraScale
			# for Vivado 2018.1
            if {[regexp "HHH *CLB *HHH *([0-9]+) HHH *([0-9]+) HHH *([0-9]+) HHH *([0-9]+) HHH *([0-9]+) HHH *([0-9]+) HHH *(.*) HHH" $line dummy  parent child nonassigned used fixed available util]} {
                lappend pblock_util "$pblock $parent $child $nonassigned $used $fixed $available $util {$GRID_RANGES}"
                break
            }
            set start [expr {$end+1}]
        }
    }
    if {$pblock_util!=""} {
        set pblock_log "${dir}/pblock_utilization.rpt"
        set pblock_table_header  "{pblock name} {parent} {child} {nonassigned} {used} {fixed} {available} {utilization} {GRID_RANGES}"
        set log [open $pblock_log w]
        puts $log [get_hstdm_rpt_section_header "Pblock Utilization Report"]
        puts $log [get_formated_table $pblock_table_header [lsort -ascii -index 0 $pblock_util]]
        puts $log [get_hstdm_rpt_section_header "End of report"]
        close $log
    } else {
        set pblock_log "${dir}/pblock_utilization_no_pblock.rpt"
        set log [open $pblock_log w]
        close $log
    }
    ####################
    # number of slices of hstdm cells
    ##########
    if {$report_number_slices==1} {
        # this takes long time
        puts "Reporting number of slices of HSTDM cells"
        set cell_util ""
        foreach cell "[get_cells cpm_rcv_* -quiet] [get_cells cpm_snd_* -quiet] [get_cells hstdm_* -quiet]" {
            set rt [report_utilization -quiet -cells $cell -return_string -no_primitives]
            set start 0
            set end 0
            while {$end>=0} {
                set end [string first "\n" $rt $start]
                set line [string range $rt $start $end]
                set line [string map {| HHH} $line]
                # it is slice for Virtex7
                if {[regexp "HHH *Slice *HHH *([0-9]+) HHH *([0-9]+) HHH *([0-9]+) HHH *(.*) HHH" $line dummy used loced available util]} {
                    lappend cell_util "$cell $used"
                    break
                }
                # it is CLB for UltraScale
                if {[regexp "HHH *CLB *HHH *([0-9]+) HHH *([0-9]+) HHH *([0-9]+) HHH *(.*) HHH" $line dummy used loced available util]} {
                    lappend cell_util "$cell $used"
                    break
                }
                set start [expr {$end+1}]
            }
        }
        set cell_log "${dir}/cell_slices.rpt"
        set cell_table_header "{module name} {slices}"
        set log [open $cell_log w]
        puts $log [get_hstdm_rpt_section_header "Number of slices of HSTDM cells"]
        puts $log [get_formated_table $cell_table_header [lsort -ascii -index 0 $cell_util]]
        puts $log [get_hstdm_rpt_section_header "End of report"]
        close $log
    }
    puts "Done reporting HSTDM Qor"
    if {$open_checkpoint==1} {
        close_design_with_message
    }
    return
}

# There is a same proc in haps_drc_vivado.tcl, consider merge them.
# arguments:
# -xdc <output file>
# -log <log file>
# -warning_limit <value>
proc report_hstdm_missing_constraints {args} {
    puts "Reporting constraint problems between HSTDM and user. [clock format [clock seconds] -format %D:%T]"
    # if constraints value is smaller than or equal to this, generate a warning
    set warning_limit 3
    set max_number_path 10000 
    # map logic levels to constraint value
    # if (logic level<key) then the constraint will be set to the value
    # set level_to_value(key) value
    set level_to_value(16) 8
    set level_to_value(32) 12
    set level_to_value(40) 20
    set default_constraint_value 20
    set level_list [lsort -real [array names level_to_value]]
    # default output file name
    set output_file_name "hstdm_missing_constraints.xdc"
    set log_file_name "${output_file_name}.log"
    # get output file name from args
    if {[catch {array set params $args}]} {
    } else {
        if {[info exists params(-xdc)]} {
            set output_file_name [string trim ${params(-xdc)}]
            set log_file_name "${output_file_name}.log"
        }
        if {[info exists params(-log)]} {
            set log_file_name [string trim ${params(-log)}]
        }
        if {[info exists params(-warning_limit)]} {
            set warning_limit_tmp [string trim ${params(-warning_limit)}]
            if {![catch {expr {abs($warning_limit_tmp)}}]} {
                set warning_limit $warning_limit_tmp
            } else {
                puts "Ignore invalid value \"$warning_limit_tmp\" for -warning_limit. It must be a number."
            }
        }
        if {[info exists params(-max_paths)]} {
            set max_paths_tmp [string trim ${params(-max_paths)}]
            if {![catch {expr {abs($max_paths_tmp)}}]} {
                set max_number_path $max_paths_tmp
            } else {
                puts "Ignore invalid value \"$max_paths_tmp\" for -max_paths. It must be a number."
            }
        }
    }
    
    set all_hstdm_snd_pins [get_pins {cpm_snd_*/data*} -quiet]
    set all_hstdm_rcv_pins [get_pins {cpm_rcv_*/data*} -quiet]
    if {$all_hstdm_snd_pins=="" && $all_hstdm_rcv_pins==""} {
        # no HSTDM, return
        puts "Found no HSTDM transmitters or receivers."
        return
    }
    # Depending on the design size, checking missing constraints may take few minutes to finish
    # This proc print progress in format "current index/total number". 
    # It only reports when current index reaches a multiple of "report_point", to avoid a too verbose report.
    # If you set report_point to 1/10 of total_point, there would be only 10 lines messages.
    proc hstdm_report_progress {text current_index report_point total_point} {
        if {$report_point>0} {
            if {[expr {fmod($current_index, $report_point)}]<=0.001} {
                puts "$text: $current_index/$total_point done."
            }
        }
    }
    set msg_collect "Collecting paths between HSTDM and user"
    puts "${msg_collect}."
    set all_hstdm_pins [concat $all_hstdm_snd_pins $all_hstdm_rcv_pins]
    set total_number_of_hstdm_pins [llength $all_hstdm_pins]
    set total_number_of_paths 0
    array set hstdm_path_array ""
    # internal error list
    set error_list ""
    set current_index 0
    set report_progress_number 10
    set report_point 0
    if {$report_progress_number>0} {
        set report_point [expr {$total_number_of_hstdm_pins/$report_progress_number}]
    }
    # collect timing path between user and HSTDM
    foreach hstdm_pin [lsort $all_hstdm_pins] {
        incr current_index
        hstdm_report_progress $msg_collect $current_index $report_point $total_number_of_hstdm_pins
        set start_point_is_user [regexp "^cpm_snd_" $hstdm_pin]
        set error_msg_prefix "At HSTDM pin $hstdm_pin"
        if {$start_point_is_user} {
            # use -only_cells at both start points and end points
            set point_list [all_fanout -endpoints_only -only_cells -flat [get_pins $hstdm_pin] -quiet]
        } else {
            # if we do not add -only_cells option, the start point will be the clock pin
            set point_list [all_fanin -startpoints_only -only_cells -flat [get_pins $hstdm_pin] -quiet]
        }
		set hstdm_point ""
		foreach point $point_list {
			if {[get_cells $point -quiet]==[get_property PARENT_CELL [get_pins $hstdm_pin] -quiet]} {
				# occurs when there is not timing path through hstdm_pin
				continue
			}
			lappend hstdm_point $point
		}
        if {[llength $hstdm_point]==0} {
            # occurs when there is not timing path through hstdm_pin
            # lappend error_list "${error_msg_prefix}: Failed to find hstdm start or end points. ($hstdm_point)"
            continue
        } elseif {[llength $hstdm_point]>1} {
            lappend error_list "${error_msg_prefix}: There are more than one hstdm start or end points. ($hstdm_point)"
        }
        set hstdm_point [lindex $hstdm_point 0]
        if {$start_point_is_user} {
            set hstdm_point_string "-through \[get_pins {$hstdm_pin}\] -to \[get_cells {$hstdm_point}\]"
        } else {
            set hstdm_point_string "-from \[get_cells {$hstdm_point}\] -through \[get_pins {$hstdm_pin}\]"
        }
        
        # There seems a problem of using "all_fanin" "all_fanout" to get user points. They cause hang on some designs.
        set current_timing_path_list ""
        if {[catch {eval "get_timing_paths $hstdm_point_string -sort_by slack -setup -max_paths $max_number_path -unique_pins -quiet"} current_timing_path_list]} {
            lappend error_list "${error_msg_prefix}: Failed to obtain timing paths. ($current_timing_path_list)"
            continue
        }
        set current_number_of_timing_path [llength $current_timing_path_list]
        if {$current_number_of_timing_path>=$max_number_path} {
            # non-critical problem
            lappend error_list "${error_msg_prefix}: Number of timing paths exceeds the limit $max_number_path."
        }
        set hstdm_path_array($hstdm_point_string) $current_timing_path_list
        incr total_number_of_paths $current_number_of_timing_path
    }
    proc hstdm_get_constraint_issue_type {timing_path warning_limit} {
        set start_clk [get_property STARTPOINT_CLOCK $timing_path]
        set end_clk [get_property ENDPOINT_CLOCK $timing_path]
        set exception [get_property EXCEPTION $timing_path]
        set isAsyncGroup [regexp "Asynchronous Clock Groups" $exception dummy]
        set isFalsePath [regexp "False Path" $exception dummy]
        set hasMaxDelay [regexp "MaxDelay Path" $exception dummy]
        set issue "NO_ISSUE"
        if {$isAsyncGroup} {
            set issue "ASYNC CLOCK"
        } elseif {$isFalsePath} {
            set issue "FALSE PATH"
        } elseif {$hasMaxDelay} {
            set constraint 0
            if {[regexp {(-?\d+\.\d+)} $exception constraint]} {
                if {$constraint<=$warning_limit} {
                    set issue "TOO SMALL"
                }
            } else {
                set issue "Failed to find MaxDelay value of from $exception"
            }
        } elseif {$start_clk!=$end_clk} {
            set issue "MISSING CONSTRAINT"
        }
        return $issue
    }
    # @param timing_path
    # @param user_clk_prop : possible values: "STARTPOINT_CLOCK", "ENDPOINT_CLOCK"
    # @param from_or_to_user : possible values: "from", "to"
    # @return a string that can be used in timing constraints commands
    proc hstdm_get_user_clock_string {timing_path user_clk_prop from_or_to_user} {
        if {$user_clk_prop=="STARTPOINT_CLOCK"} {
            set user_point [get_property STARTPOINT_PIN $timing_path]
        } elseif {$user_clk_prop=="ENDPOINT_CLOCK"} {
            set user_point [get_property ENDPOINT_PIN $timing_path]
		} else {
			error "user_clk_prop must be either \"STARTPOINT_CLOCK\" or \"ENDPOINT_CLOCK\". \"$user_clk_prop\" is given."
			return ""
		}
		set user_point_is_port [expr {[get_property CLASS $user_point]=="port"}]
        set get_clocks_str "get_clocks {[get_property $user_clk_prop $timing_path]} -quiet"
        set user_clk [eval $get_clocks_str]
        if {$user_clk==""} {
			if {$user_point_is_port} {
				# user point is a top level port, but no clock is specified
				return "-${from_or_to_user} \[get_ports \{${user_point}\}\]"
			} else {
            	# get_clocks does not generate an error, but a warning if the clock does not exist.
        	    # use -quiet to suppress the warning, but generate an error here. Caller needs catch errors
    	        error "Failed to find $user_clk_prop \"[get_property $user_clk_prop $timing_path]\"."
	            return ""
			}
        }
		# find the clock edge (rising or falling); # set default to rising edge
		set is_inverted 0
		if {$user_point_is_port} {
			# user point is a top level port, and there is a clock associated to it.
			set is_inverted [get_property IS_INVERTED [eval $get_clocks_str] -quiet]
		} else {
        	if {$user_clk_prop=="STARTPOINT_CLOCK"} {
				# Assume that start point is always a clock pin.
				# Check IS_INVERTED on the clock pin of the cell, not on the clock,
				# because the clock may have multiple loads, some are inverted, the others are not.
				set is_inverted [get_property IS_INVERTED [get_pins $user_point] -quiet]
			} elseif {$user_clk_prop=="ENDPOINT_CLOCK"} {
				# End point is not usually not a clock pin, and there could be multiple clock pins on the end cell.
				# We need find the corresponding clock pin of the end point.
				set end_clock_pin ""
				set clock_pins_at_the_end_cell [get_pins -of_objects [get_cells [get_property PARENT_CELL [get_pins $user_point]]] -filter {IS_CLOCK==1 && DIRECTION=="IN"} -quiet]
				foreach clock_pin $clock_pins_at_the_end_cell {
					# Search the results of [get_clocks -of_objects...] as a list, as there could be multiple clocks on the pin.
					# It does not work in following cases:
					# 1. When all pins are associated to the same clock, but some are inverted, the others are not inverted.
					# 2. The clock is generated internally inside the cell, there is no input clock pin.
					if {[lsearch -exact [get_clocks -of_objects [get_pins $clock_pin]] [eval $get_clocks_str]] != -1} {
						set end_clock_pin $clock_pin
						break
					}
				}
				# check IS_INVERTED on the clock pin of the cell, not on the clock,
				# because the clock may have multiple loads, some are inverted, the others are not.
				set is_inverted [get_property IS_INVERTED [get_pins $end_clock_pin -quiet] -quiet]
            	# check if user end point is a latch
	            if {[regexp -nocase {latch} [get_property PRIMITIVE_SUBGROUP [get_cells [get_property PARENT_CELL [get_pins $user_point]]]]] } {
        			#  If the user end point is a latch, the effective clock edge for constraint application is opposite
					if {$is_inverted==0 || $is_inverted==""} {
						set is_inverted 1
					} else {
						set is_inverted 0
					}
        	    }
			} else {
				error "user_clk_prop must be either \"STARTPOINT_CLOCK\" or \"ENDPOINT_CLOCK\". \"$user_clk_prop\" is given."
				return ""
			}
		}
		if {$is_inverted==0 || $is_inverted==""} {
			set edge_string "rise_"
		} else {
			set edge_string "fall_"
		}
        set user_clk_string "-${edge_string}${from_or_to_user} \[get_clocks \{$user_clk\}\]"
        return $user_clk_string
    }
    proc hstdm_get_constraint_minimal_value {clock_array_name clock_string new_value} {
        set value $new_value
        upvar $clock_array_name clock_array
        if {[info exists clock_array($clock_string)]} {
            set old_value $clock_array($clock_string)
            if {$old_value<$new_value} {
                set value $old_value
            }
        }
        return $value
    }
    proc hstdm_write_dpo_constraints {file_pointer clock_array_name hstdm_point} {
        upvar $clock_array_name clock_array
        set clock_string_list [array names clock_array]
        if {$clock_string_list==""} {
            return
        }
        foreach clock_string $clock_string_list {
            # start point is required for "-datapath_only" constraints.
            # "-datapath_only" constraints won't work when "-from" (or "-rise_from") is missing.
            set value $clock_array($clock_string)
            set constraints "set_max_delay -datapath_only $clock_string $hstdm_point $value"
            puts $file_pointer $constraints
        }
        # new line
        puts $file_pointer ""
    }

    set msg_checking "Checking for constraint problems between HSTDM and user"
    puts "${msg_checking}."
    # create temporary files
    set found_hstdm_issues 0
    set issue_list ""
    lappend issue_list "ASYNC CLOCK"
    lappend issue_list "FALSE PATH"
    lappend issue_list "TOO SMALL"
    lappend issue_list "MISSING CONSTRAINT"
    foreach issue $issue_list {
        set tmp_file_name($issue) "${output_file_name}_[join $issue "_"].log"
        set found_issues($issue) 0
        set tmp_fp($issue) [open $tmp_file_name($issue) w]
    }

    set async_clk_list ""
    set hstdm_point_list [lsort [array names hstdm_path_array]]
    set current_index 0
    set report_progress_number 10
    set report_point 0
    if {$report_progress_number>0} {
        set report_point [expr {$total_number_of_paths/$report_progress_number}]
    }
    foreach hstdm_point $hstdm_point_list {
        # it is an hstdm transmitter if hstdm point is the end point, otherwise it is an hstdm receiver
        set start_point_is_user [expr {[string first "-to " $hstdm_point]>=0}]
        if {$start_point_is_user} {
            set user_clk_prop "STARTPOINT_CLOCK"
            set from_or_to_user "from"
        } else {
            set user_clk_prop "ENDPOINT_CLOCK"
            set from_or_to_user "to"
        }
        array set warning_clk_array ""
        array set missing_clk_array ""
        foreach timing_path [lsort $hstdm_path_array($hstdm_point)] {
            incr current_index
            hstdm_report_progress $msg_checking $current_index $report_point $total_number_of_paths
            # get timing path:
            # if both start_point and end_point are specified explictly,
            # then the number of paths between them is not important.
            # we care the clock relationship between them.
            # check issue type
            set issue [hstdm_get_constraint_issue_type $timing_path $warning_limit]
            if {$issue=="NO_ISSUE"} {
                continue
            }
            # found some issues
            incr found_hstdm_issues
            # check user clock name and user clock edge
            set clock_string ""
            if {[catch {hstdm_get_user_clock_string $timing_path $user_clk_prop $from_or_to_user} clock_string]} {
                lappend error_list "Found issue \"$issue\" for path $timing_path, but encounter an error. ($clock_string)"
                continue
            }
            # convert logic levels to constriant value
            set logic_levels [get_property LOGIC_LEVELS $timing_path]
            set path_value $default_constraint_value
            foreach level [lsort -real $level_list] {
                if {$logic_levels<$level} {
                    set path_value $level_to_value($level)
                    break
                }
            }
            switch -- $issue {
                "ASYNC CLOCK" {
                    set clock_name [get_property $user_clk_prop $timing_path]
                    lappend async_clk_list $clock_name
                }
                "FALSE PATH" {
                }
                "TOO SMALL" {
                    set warning_clk_array($clock_string) [hstdm_get_constraint_minimal_value "warning_clk_array" $clock_string $path_value]
                }
                "MISSING CONSTRAINT" {
                    set missing_clk_array($clock_string) [hstdm_get_constraint_minimal_value "missing_clk_array" $clock_string $path_value]
                }
                default {
                    lappend error_list "Found issue \"$issue\" for path $timing_path."
                    continue
                }
            }
            # following apply to all issues
            set start_point [get_property STARTPOINT_PIN $timing_path]
            set end_point [get_property ENDPOINT_PIN $timing_path]
            set path_string "# $issue: $start_point --> $end_point (LOGIC LEVELS: $logic_levels)"
            incr found_issues($issue)
            puts $tmp_fp($issue) $path_string
        }
        # collect from/to clocks for each hstdm end/start point
        hstdm_write_dpo_constraints $tmp_fp(TOO SMALL) "warning_clk_array" $hstdm_point
        hstdm_write_dpo_constraints $tmp_fp(MISSING CONSTRAINT) "missing_clk_array" $hstdm_point
        set async_clk_list [lsort -unique $async_clk_list]
        unset warning_clk_array
        unset missing_clk_array
    }

    foreach issue [array names tmp_fp] {
        close $tmp_fp($issue)
    }

    # generate reports
    proc hstdm_puts_issues_to_log {dest_fp src_fp issue_type issue_number {issue_string ""} {no_issue_string ""}} {
        if {$issue_number<=0} {
            puts $dest_fp "# Found no $issue_type issues."
            foreach line $no_issue_string {
                puts $dest_fp $line
            }
        } else {
            foreach line $issue_string {
                puts $dest_fp $line
            }
            if {$src_fp!=""} {
                fcopy $src_fp $dest_fp
            }
        }
        return
    }
    if {($found_hstdm_issues>0) || ($error_list!="")} {
        puts "Generating reports of constraint problems."
        foreach issue $issue_list {
            set tmp_fp($issue) [open $tmp_file_name($issue) r]
        }

        set section_separator [string repeat "#" 50]
        set header ""
        lappend header $section_separator
        lappend header "# Copyright 2017-2018 Synopsys, Inc."
        lappend header "# Report of constraint problems between HSTDM and user. [clock format [clock seconds] -format %D:%T]"
        lappend header ""
        lappend header $section_separator
        lappend header "# WARNING: The values in following set_max_delay constraints are calculated based on "
        lappend header "#          logic levels of the corresponding path within a single FPGA. They may cause "
        lappend header "#          timing violations at system level. Please run system level timing analysis "
        lappend header "#          to check timing problems at system level."

        set generate_xdc [expr {$found_issues(MISSING CONSTRAINT)>0}]
        if {$generate_xdc} {
            set xdc_fp [open $output_file_name w]
            foreach line $header {
                puts $xdc_fp $line
            }
            set issue "MISSING CONSTRAINT"
            puts $xdc_fp ""
            puts $xdc_fp $section_separator
            puts $xdc_fp "# Constraints \"set_max_delay -datapath_only\" are missing for following paths."
            puts $xdc_fp ""
            hstdm_puts_issues_to_log $xdc_fp $tmp_fp($issue) $issue $found_issues($issue)
            puts $xdc_fp ""
            puts $xdc_fp $section_separator
            puts $xdc_fp "# End of report"
            close $xdc_fp
        } else {
            puts "Found no missing constraints problem. Please check $log_file_name for other issues."
        }

        set log_fp [open $log_file_name w]
        foreach line $header {
            puts $log_fp $line
        }
        ##########
        set issue "ASYNC CLOCK"
        puts $log_fp ""
        puts $log_fp $section_separator
        puts $log_fp "# Following clocks and HSTDM clocks are asynchronous."
        puts $log_fp "# Thus constraints between them are not applied."
        puts $log_fp ""
        set issue_string ""
        if {$async_clk_list!=""} {
            lappend issue_string "# \tCLOCKS ASYNCHRONOUS TO HSTDM"
            lappend issue_string "# \t----------------------------"
            foreach async_clk $async_clk_list {
                lappend issue_string "# \t$async_clk"
            }
            lappend issue_string ""
        }
        lappend issue_string "#"
        lappend issue_string "# Constraints of following paths are not applied due to above issues."
        lappend issue_string "#"
        lappend issue_string ""
        hstdm_puts_issues_to_log $log_fp $tmp_fp($issue) $issue $found_issues($issue) $issue_string
        ##########
        set issue "MISSING CONSTRAINT"
        puts $log_fp ""
        puts $log_fp $section_separator
        puts $log_fp "# Constraints \"set_max_delay -datapath_only\" are missing for following paths."
        puts $log_fp ""
        set no_issue_string ""
        lappend no_issue_string "# Skipped generating $output_file_name."
        set issue_string ""
        lappend issue_string "# ${issue}: Found issues on $found_issues($issue) paths."
        lappend issue_string "# See $output_file_name for more details."
        hstdm_puts_issues_to_log $log_fp {} $issue $found_issues($issue) $issue_string $no_issue_string
        ##########
        set issue "TOO SMALL"
        puts $log_fp ""
        puts $log_fp $section_separator
        puts $log_fp "# Constraint values of following paths are smaller than or equal to $warning_limit."
        puts $log_fp "# There might be timing violations."
        puts $log_fp ""
        hstdm_puts_issues_to_log $log_fp $tmp_fp($issue) $issue $found_issues($issue)
        ##########
        set issue "FALSE PATH"
        puts $log_fp ""
        puts $log_fp $section_separator
        puts $log_fp "# Constraints of following paths are overwritten by false path constraints."
        puts $log_fp ""
        hstdm_puts_issues_to_log $log_fp $tmp_fp($issue) $issue $found_issues($issue)
        ##########
        if {$error_list!=""} {
            puts $log_fp ""
            puts $log_fp $section_separator
            puts $log_fp "# Found following internal errors during generating the report."
            puts $log_fp ""
            foreach err $error_list {
                puts $log_fp "# $err"
            }
        }
        puts $log_fp ""
        puts $log_fp $section_separator
        puts $log_fp "# End of report"
        close $log_fp

        foreach issue [array names tmp_fp] {
            close $tmp_fp($issue)
        }
    } else {
        puts "Found no issues of constraints between HSTDM and user."
    }

    puts "Cleaning up temporary files."
    foreach issue $issue_list {
        catch {file delete $tmp_file_name($issue)}
    }
    
    puts "Reporting constraint problems between HSTDM and user. DONE. [clock format [clock seconds] -format %D:%T]"
}

proc report_hstdm_missing_constraints_wrapper {args} {
    # default args value
    set dcp_path "[pwd]"
    set output_path ""
    set open_checkpoint 1
    # parse arguments
    set arguments [join $args " "]
    if {[catch  {array set argArray $arguments} dummy]} {
        set procName [lindex [info level 0] 0]
        puts "Error using ${procName}!\nUsage: ${procName} \[-dcp_path <DCP_PATH>\] \[-output_path <OUTPUT_PATH>\] \[-open_checkpoint <0|1>\]\n"
        return
    }
    set argNameList "dcp_path output_path open_checkpoint"
    foreach argName $argNameList {
        if {[array name argArray "-$argName"]=="-$argName"} {
            set $argName $argArray(-$argName)
            array unset argArray "-$argName"
        }
    }
    foreach errorArgName [array name argArray] {
        puts "Warning! Ignoring parameter \"$errorArgName\" with value \"$argArray($errorArgName)\""
    }

    if {$open_checkpoint==1} {
        if {[load_post_route_dcp $dcp_path]} {
            return
        }
    }
    if {${output_path}==""} {
        # match what is in HSTDM_Qor_rpt
        set output_path "${dcp_path}/HSTDM_Qor_rpt/HSTDM_constraints" 
    }
    set dir ${output_path}
    file mkdir ${dir}
    set missingfile "${dir}/HSTDM_constraints_missing.xdc"
    set tootightfile "${dir}/HSTDM_constraints_too_tight.xdc"

    report_hstdm_missing_constraints -xdc $missingfile -log $tootightfile

    if {$open_checkpoint==1} {
        close_design_with_message
    }
}
# report_hstdm_qor -dcp_path . -open_checkpoint 1
if {[info exists argv]} {
    set command [join ${argv} " "]
    puts "Command: ${command}"
    catch {eval ${command}} dummy
    puts ${dummy}
}
