# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
foreach name_s {timing_corr timing_corr_aux} {
namespace eval $name_s {
  namespace export sdc2fdc
  namespace export xdc_clock_group
  namespace export all_fanout
  namespace export all_fanin
  namespace export create_fdc_template
  namespace export check_fdc_query
  namespace export report_timing
  namespace export get_cells
  namespace export get_clocks
  namespace export get_pins
  namespace export get_nets
  namespace export get_ports
  namespace export get_registers
  namespace export get_clock_source
  namespace export get_user_clocks
  namespace export all_inputs
  namespace export all_outputs
  namespace export all_registers
  namespace export fix_cgc_xdc
  namespace export all_clocks
  namespace export object_list
  namespace export slash2dot
  namespace export dot2slash
  namespace export start_time
  namespace export end_time
  namespace export proto_correlate
  namespace export set_view
  namespace export clear_view
  namespace export check_hstdm_timing
  namespace export goto_work_dir
  namespace export go_m0

    
  proc add_option {strg} {
    return [split [regsub -all {\s{2,}} $strg " "]]
  }

####
#### Transform incoming object to match Synplify naming style.
#### Hierarchy separator from "/" to ".", add escapes to "." and "[]" 
#### that are part of the instance name (not a separator or bus bit).
####
  proc slash2dot {args} {
    if {[llength $args] > 1} {
      puts "ERROR:  Please speficy a single list argument"
      return {}
    }
    set ret_l {}
    set strg_l [lindex $args [lsearch -regexp $args {^[^-]}]]
    foreach strg $strg_l {
      regsub -all {\)} $strg {]} strg
      regsub -all {\(} $strg {[} strg
      regsub -all {\>} $strg {]} strg
      regsub -all {\<} $strg {[} strg
      regsub -all {\.} $strg {\.} strg
      regsub -all {\[|\]} $strg {\\&} strg
      regsub -all {\\\[([0-9]+)\\\]$} $strg {[\1]} strg
      regsub -all {\/} $strg {.} strg
      set ret_l [linsert $ret_l end $strg]
    }
    return $ret_l
  }

####
#### Transform Synplicity names to better conform to other EDA conventions
#### 
  proc dot2slash {args} {
    if {[llength $args] > 1} {
      puts "ERROR:  Please speficy a single list argument"
      return {}
    }
    set ret_l {}
    set strg [lindex $args [lsearch -regexp $args {^[^-]}]]
    regsub -all {\\\\\\(\[)([0-9]+)\\\\\\(\])} $strg {#\1\2#\3} strg
    regsub -all {\\\\} $strg "@" strg
    regsub -all {(^|\s).:} $strg {\1} strg
    regsub -all {\.} $strg {/} strg
    regsub -all {\\\/} $strg {.} strg
    regsub -all {,} $strg "_" strg
    regsub -all {\\} $strg "" strg
    regsub -all {@} $strg {\\\\} strg
    regsub -all {#} $strg {\\} strg
    set ret_l [linsert $ret_l end $strg]
    return $ret_l
  }

####  Main proc
  proc sdc2fdc {args} {
  
    variable group_array
    variable trans_err
    variable trans_err_msg
    variable root_list
    variable root_files
    variable all_tops
    variable all_stat
    variable batch
    variable cmd_num
    variable fpo_fdc_clock
    variable fpo_fdc_gen_clock
    variable fpo_fdc_col
    variable fpo_fdc_io
    variable fpo_fdc_reg
    variable fpo_fdc_delay
    variable fpo_fdc_attr
    variable fpo_fdc_io_stan
    variable fpo_fdc_cp
    variable all_in
    variable all_out
    variable route_delay
    variable line_num
    variable level
    variable os
    variable fdc_template_file
    variable fdc_template
    global env
    
    catch {unset root_files}
    catch {unset root_list}

    set auto_update -1
    set top_batch -1
    set batch -1       ;#Not in batch mode when $batch == -1
    set cmd_num 0
    if {[catch {set os $env(OS)}]} {
      set os $env(OSTYPE)
    }

    set cp_flow [lsearch -exact $args "-root"]
    set batch [lsearch -exact $args "-batch"]
    if {$cp_flow == -1} {            ;# If true, at the top level
#      set auto_update [lsearch -exact $args "-update_prj"]
      set auto_update 1
      set all_stat 0
      set all_tops {}
      set top_batch $batch
      set root [project -dir]FDC_constraints/[impl -name]/[project -name]
      set sdc_files [impl_files -constraint]
      set sdc_files [space_clean $sdc_files]
      set sdc_files [setup_cps $sdc_files]
      foreach cp_root $root_list {
        if {$batch != -1} {
          set timing_corr::all_stat [expr $timing_corr::all_stat | [timing_corr_aux::sdc2fdc -batch -root $cp_root -sdc_files $root_files($cp_root)]]
        } else {
          set timing_corr::all_stat [expr $timing_corr::all_stat | [timing_corr_aux::sdc2fdc -root $cp_root -sdc_files $root_files($cp_root)]]
        }
      }
    } else {
      set root [project -dir]FDC_constraints/[impl -name]/[lindex $args $cp_flow+1]
      set sdc_inx [lsearch -exact $args "-sdc_files"]
      set sdc_files [lindex $args $sdc_inx+1]
    }
    
    set trans_err 0
    set tcl_expr {^\s*(if |for |foreach |foreach_in_collection |switch |while |return |catch |eval ){1}}
    set cmd_expr {^\s*(define_clock|define_input_delay|define_output_delay|define_false_path|define_multicycle_path|define_path_delay|define_reg_input_delay|define_reg_output_delay){1}}
    set cmd_expr_scope {^\s*(define_scope_collection|define_global_attribute|define_current_design|define_attribute|define_io_standard|define_compile_point){1}}
    set cmd_expr_synop {^\s*(create_clock|set_input_delay|set_output_delay|set_false_path|set_clock_groups|create_generated_clock|create_generated_budget_clock|set_clock_latency|set_clock_uncertainty|set_hierarchy_separator|set_max_delay|set_multicycle_path|reset_path|set_rtl_ff_names|read_sdc|bus_dimension_separator_style|bus_naming_style|set_datapathonly_delay|set ){1}}

    set scck_file [impl -result_file]
    regsub -all {\\} $scck_file {/} scck_file
    regsub {\.[^\/]+$} $scck_file {_scck.rpt} scck_file
    file mkdir  [project -dir]FDC_constraints
    file mkdir  [project -dir]FDC_constraints/[impl -name]

    if {!$fdc_template} {
      set new_fdc_file "${root}_translated.fdc"
    } else {
      set new_fdc_file "${root}_template.fdc"
    }
    set timing_corr::all_tops [linsert $timing_corr::all_tops  end $new_fdc_file]
    set tcl_file ${root}_tcl.sdc
    set tcl_file_fdc ${root}_tcl.fdc
    set tcl_file_dis ${root}_tcl.dis
    set fdc_file ${root}_fdc.fdc
    set fdc_file_header ${root}_fdc_header.fdc
    set fdc_file_clock ${root}_fdc_clock.fdc
    set fdc_file_gen_clock ${root}_fdc_gen_clock.fdc
    set fdc_file_col ${root}_fdc_col.fdc
    set fdc_file_io ${root}_fdc_io.fdc
    set fdc_file_reg ${root}_fdc_reg.fdc
    set fdc_file_delay ${root}_fdc_delay.fdc
    set fdc_file_attr ${root}_fdc_attr.fdc
    set fdc_file_io_stan ${root}_fdc_io_stan.fdc
    set fdc_file_cp ${root}_fdc_cp.fdc
    set log_file ${root}_translate.log
    if {[lsearch -exact [list $sdc_files] $new_fdc_file] != -1} {
      puts "ERROR:  Cannot translate a translated file; remove/disable $new_fdc_file from the current implementation."
      return 1
    }
    if {[file exists $new_fdc_file]} {
      if {[catch {file delete -force $new_fdc_file}]} {
        puts "ERROR:  $new_fdc_file already exists and cannot be deleted.  Please manually delete the file to enable a re-run of translation"
      }
    }
    if {[llength $sdc_files] == 0} {
      puts "ERROR:  No active constraint files.  Please add/enable one or more SDC constraint files."
      return 1
    }
    if {[catch {open $new_fdc_file a} fpo_tran]} {
      puts "ERROR:  Can't open $new_fdc_file for writing"
      return 1
    }
    if {[catch {open $tcl_file w} fpo_tcl]} {
      puts "ERROR:  Can't open $tcl_file for writing"
      close $fpo_tran
      return 1
    } else {
      set fpo_tcl_fdc [open $tcl_file_fdc w]
      set fpo_tcl_dis [open $tcl_file_dis w]
    }
    if {[catch {open $fdc_file w} fpo_fdc]} {
      puts "ERROR:  Can't open $fdc_file for writing"
      close $fpo_tcl
      close $fpo_tran
      return 1
    } else {
      set fpo_fdc_header [open $fdc_file_header w]
      set fpo_fdc_clock [open $fdc_file_clock w]
      set fpo_fdc_gen_clock [open $fdc_file_gen_clock w]
      set fpo_fdc_col [open $fdc_file_col w]
      set fpo_fdc_io [open $fdc_file_io w]
      set fpo_fdc_reg [open $fdc_file_reg w]
      set fpo_fdc_delay [open $fdc_file_delay w]
      set fpo_fdc_attr [open $fdc_file_attr w]
      set fpo_fdc_io_stan [open $fdc_file_io_stan w]
      set fpo_fdc_cp [open $fdc_file_cp w]
    }
    if {[catch {open $log_file w} fpo_log]} {
      puts "ERROR:  Can't open $sdc_log for writing"
      close $fpo_tcl
      close $fpo_tran
      close $fpo_fdc
      return 1
    }
    if {!$fdc_template} {
      puts $fpo_fdc "##############################################################################"
      puts $fpo_fdc "# FDC constraints translated from Synplify Legacy Timing & Design Constraints"
      puts $fpo_fdc "##############################################################################"
    }
    puts $fpo_fdc " "
    puts $fpo_fdc "set_rtl_ff_names {}" 
    puts $fpo_fdc_header "###==== BEGIN Header"
    puts $fpo_fdc_clock "###==== BEGIN Clocks - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_gen_clock "###==== BEGIN \"Generated Clocks\" - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_col "###==== BEGIN Collections - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_io "###==== BEGIN Inputs/Outputs - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_reg "###==== BEGIN Registers - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_delay "###==== BEGIN \"Delay Paths\" - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_attr "###==== BEGIN Attributes - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_io_stan "###==== BEGIN \"I/O Standards\" - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_cp "###==== BEGIN \"Compile Points\" - (Populated from tab in SCOPE, do not edit)"
#    puts $fpo_fdc_col "define_scope_collection all_inputs_fdc {find -port * -filter @direction==input}"
#    puts $fpo_fdc_col "define_scope_collection all_outputs_fdc {find -port * -filter @direction==output}"
#    puts $fpo_fdc_col "define_scope_collection all_clocks_fdc {find -hier  -clock *}"
#    puts $fpo_fdc_col "define_scope_collection all_registers_fdc {find -hier -seq *}"
    set all_in 0
    set all_out 0
    set all_clock 0
    set all_reg 0
    set stat 0
    if {!$fdc_template} {
      top_header $fpo_tran $new_fdc_file $sdc_files
    }
    foreach curr_file $sdc_files {
      set line_num 0
      if {![catch {open $curr_file r} fpi]} { 
        if {!$fdc_template} {
          sub_header $fpo_tcl $curr_file
          dis_header $fpo_tcl_dis $curr_file
        }
        set level 0
        while {![eof $fpi]} {
          incr line_num
          set trans_err_msg ""
          set trans_err 0
          gets $fpi line
          if {[regexp $tcl_expr $line] || $level} {
####  If in Synplicity legacy format, translate
            if {[regexp $cmd_expr $line]} {
              set line [un_wrap $line $fpi]
              set line [clean_line_sdc $line]
#              set line [all_in_out $line]
              if {[get_disable [split $line]]} {
                puts $fpo_tcl $line
                continue
              }
              set line [morph_con $line]
              if {$trans_err} {
                incr stat
                post_error $line $curr_file $fpo_log $fpo_tcl
              } else {
                regsub -all {\\\n} $line "" line
                regsub -all {.$} $line "" line
                set line [clean_line_sdc $line]
                regsub -all {\s\{(\$[^ ]+)\}} $line { \1} line
                puts $fpo_tcl $line
              }
            } else {
              count_levels $line
              puts $fpo_tcl $line
              continue
            }
          }
          if {$level} {
            continue
          }
          if {[regexp $cmd_expr $line]} {
            set line [un_wrap $line $fpi]
            set line [clean_line_sdc $line]
#            set line [all_in_out $line]
            if {[get_disable [split $line]]} {
              puts $fpo_tcl_dis "# $line"
              continue
            }
            set line [extract_col "find" $line $fpo_fdc_col]
            set line [extract_col "expand" $line $fpo_fdc_col]
            set line [morph_con $line]
            if {$trans_err} {
              incr stat
              post_error $line $curr_file $fpo_log $fpo_tcl
            } else {
## good translation
              switch -regexp -- $line {
                {^define_scope_collection} {puts $fpo_fdc_col $line}
                {^create_clock} {puts $fpo_fdc_clock $line}
                {^set_reg_} {puts $fpo_fdc_reg $line}
                {^set_input_delay} {puts $fpo_fdc_io $line}
                {^set_output_delay} {puts $fpo_fdc_io $line}
                {^set_false_path} {puts $fpo_fdc_delay $line}
                {^set_multicycle_path} {puts $fpo_fdc_delay $line}
                {^set_max_delay} {puts $fpo_fdc_delay $line}
              }
              if {$route_delay ne {}} {
                set clk [lindex $route_delay 0]
                set dly [lindex $route_delay 1]
                regsub -all {\{|\}} $dly "" dly
                puts $fpo_tcl_fdc "set_clock_route_delay \[get_clocks {$clk}\] {$dly}"
              }
            }
          } elseif {[regexp $cmd_expr_scope $line]} {
## It is a synplicity design constraint, send to FDC
            while {1} {				;# check for line continuation
              if {[string index $line end] eq "\\"} {
                set line [string replace $line end end]
                set line "$line [gets $fpi]"
                incr line_num
              } else {
                break
              }
            }
            switch -regexp -- $line {
              {^\s*define_current_design} {puts $fpo_fdc_header [regsub {^\s*} $line ""]}
              {^\s*define_scope_collection} {puts $fpo_fdc_col [regsub {^\s*} $line ""]}
              {^\s*define_.*attribute} {puts $fpo_fdc_attr [regsub {^\s*} $line ""]}
              {^\s*define_io_standard} {puts $fpo_fdc_io_stan [regsub {^\s*} $line ""]}
              {^\s*define_compile_point} {puts $fpo_fdc_cp [regsub {^\s*} $line ""]}
            }
          } elseif {[regexp $cmd_expr_synop $line]} {
## Already in Synopsys format or a special case; will either stay as in Tcl tab, or get special handling
            while {1} {				;# check for line continuation
              if {[string index $line end] eq "\\"} {
                set line [string replace $line end end]
                set line "$line [gets $fpi]"
                incr line_num
              } else {
                break
              }
            }
            set line_asis $line
#            set line [all_in_out $line]
            set line [clean_line_sdc $line]
            regsub -all {\s(\$[^ ]+)} $line { {\1}} line
            switch -regexp -- $line {
              {create_clock} {puts $fpo_fdc_clock $line}
              {create_generated_clock} {puts $fpo_fdc_gen_clock $line}
              {create_generated_budget_clock} {puts $fpo_fdc_gen_clock $line}
              {set_input_delay|set_output_delay} {puts $fpo_fdc_io $line}
              {set_reg_input_delay|set_reg_output_delay} {puts $fpo_fdc_reg $line}
              {set_datapathonly_delay|set_false_path|set_multicycle_path|set_max_delay} {puts $fpo_fdc_delay $line}
              {set_clock_uncertainty|set_clock_latency|set_clock_groups} {puts $fpo_tcl_fdc $line}
              default {puts $fpo_tcl $line_asis}
            }
#            if {[regexp {create_generated_clock} $line]} {
#              puts $fpo_fdc_gen_clock $line    ;# generated_clock to FDC
#            } elseif {[regexp {set_datapathonly_delay} $line]} { ;# datapath_only is supported in the delay tab
#              puts $fpo_fdc_delay $line
#            } elseif {[regexp {set_clock_uncertainty|set_clock_latency} $line]} {
#              puts $fpo_tcl_fdc $line     ;# send these to Tcl for now, but after the other tabs
#            } else {
#              puts $fpo_tcl $line    ;# Already a synopsys cmd, but send to Tcl Tab for now
#            }
          } else {
            puts $fpo_tcl $line    ;# It is something else, send to Tcl un changed
          }
        }
      } else {
        puts "ERROR:  Can't open $curr_file"
        close $fpo_tcl
        close $fpo_tcl_fdc
        close $fpo_tcl_dis
        close $fpo_tran
        close $fpo_fdc
        close $fpo_fdc_header
        close $fpo_fdc_clock
        close $fpo_fdc_gen_clock
        close $fpo_fdc_col
        close $fpo_fdc_io
        close $fpo_fdc_reg
        close $fpo_fdc_delay
        close $fpo_fdc_attr
        close $fpo_fdc_io_stan
        close $fpo_fdc_cp
        close $fpo_log
        return 1
      }
      close $fpi
    }
    close $fpo_tcl
    puts $fpo_tcl_dis "################################################################################"
    puts $fpo_tcl_dis " "
    close $fpo_tcl_dis
#### create the clock_group cmds  ######
#    if {![catch {open $scck_file r} fpi_scck]} {
####  For 201203sp2, collect the derived and inferred clocks.
####  For 201209, we use -derive and auto-self grouping of inferred clocks
#      infer_group $fpi_scck
#      seek $fpi_scck 0
#      derive_group $fpi_scck
#      close $fpi_scck
#    } else {
#      puts "WARNING:  Can't read *_scck.rpt file.  Run the compiler phase."
#    }

#################################################################
####  For 2012.09 beta, set_clock_groups to Tcl tab  ############
#    puts $fpo_fdc "###==== END ALL_SCOPE_TABS"
    puts $fpo_fdc_header "###==== END Header"
#    puts $fpo_fdc_clock "###==== END Clocks - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_gen_clock "###==== END \"Generated Clocks\" - (Populated from tab in SCOPE, do not edit)"
#    if {$all_in} {
#      puts $fpo_fdc_col "define_scope_collection all_inputs_fdc {find -port * -filter @direction==input}"
#    } else {
#      puts $fpo_fdc_col "define_scope_collection all_inputs_fdc {find -port * -filter @direction==input} -disable"
#    }
#    if {$all_out} {
#      puts $fpo_fdc_col "define_scope_collection all_outputs_fdc {find -port * -filter @direction==output}"
#    } else {
#      puts $fpo_fdc_col "define_scope_collection all_outputs_fdc {find -port * -filter @direction==output} -disable"
#    }
#    if {$all_clock} {
#      puts $fpo_fdc_col "define_scope_collection all_clocks_fdc {find -hier  -clock *}"
#    } else {
#      puts $fpo_fdc_col "define_scope_collection all_clocks_fdc {find -hier  -clock *} -disable"
#    }
#    if {$all_reg} {
#      puts $fpo_fdc_col "define_scope_collection all_registers_fdc {find -hier -seq *}"
#    } else {
#      puts $fpo_fdc_col "define_scope_collection all_registers_fdc {find -hier -seq *} -disable"
#    }
    puts $fpo_fdc_col "###==== END Collections - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_io "###==== END Inputs/Outputs - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_reg "###==== END Registers - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_delay "###==== END \"Delay Paths\" - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_attr "###==== END Attributes - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_io_stan "###==== END \"I/O Standards\" - (Populated from tab in SCOPE, do not edit)"
    puts $fpo_fdc_cp "###==== END \"Compile Points\" - (Populated from tab in SCOPE, do not edit)"
    close $fpo_fdc
    close $fpo_fdc_header
#    close $fpo_fdc_clock
    close $fpo_fdc_gen_clock
    close $fpo_fdc_col
    close $fpo_fdc_io
    close $fpo_fdc_reg
    close $fpo_fdc_delay
    close $fpo_fdc_attr
    close $fpo_fdc_io_stan
    close $fpo_fdc_cp

    set g_list [array names group_array]
    set g_len [llength $g_list]
    if {$g_len > 1} {
      foreach grp $g_list {
        regsub -all {\{|\}} $group_array($grp) "" clocks
#        puts  $fpo_tcl_fdc "set_clock_groups -derive -asynchronous -name \{$grp\} \\"
#        puts  $fpo_tcl_fdc "	-group \[get_clocks \{$group_array($grp)\}\]"
        puts  $fpo_fdc_clock "set_clock_groups -derive -asynchronous -name \{$grp\} \\"
#        puts  $fpo_fdc_clock "	-group \[get_clocks \{$clocks\}\]"
        puts  $fpo_fdc_clock "	-group \{$clocks\}"
#        puts  $fpo_fdc_clock "	-group \[get_clocks \{$group_array($grp)\}\]"
      }
    }
    close $fpo_tcl_fdc
    puts $fpo_fdc_clock "###==== END Clocks - (Populated from tab in SCOPE, do not edit)"
    close $fpo_fdc_clock
    catch {unset group_array}
#####  Assemble the final file  #############
    set in1 [open $fdc_file_header r]
    set in2 [open $tcl_file r]
    set in3 [open $fdc_file r]
    set in4 [open $fdc_file_col r]
    set in5 [open $fdc_file_clock r]
    set in6 [open $fdc_file_gen_clock r]
    set in7 [open $fdc_file_io r]
    set in7a [open $fdc_file_reg r]
    set in8 [open $fdc_file_delay r]
    set in9 [open $fdc_file_attr r]
    set in10 [open $fdc_file_io_stan r]
    set in11 [open $fdc_file_cp r]
    set in12 [open $tcl_file_fdc r]
    set in13 [open $tcl_file_dis r]
    fcopy $in1 $fpo_tran
    close $in1
    fcopy $in2 $fpo_tran
    close $in2
    fcopy $in13 $fpo_tran
    close $in13
    fcopy $in3 $fpo_tran
    close $in3
    fcopy $in4 $fpo_tran
    close $in4
    fcopy $in5 $fpo_tran
    close $in5
    fcopy $in6 $fpo_tran
    close $in6
    fcopy $in7 $fpo_tran
    close $in7
    fcopy $in7a $fpo_tran
    close $in7a
    fcopy $in8 $fpo_tran
    close $in8
    fcopy $in9 $fpo_tran
    close $in9
    fcopy $in10 $fpo_tran
    close $in10
    fcopy $in11 $fpo_tran
    close $in11
    fcopy $in12 $fpo_tran
    close $in12
    catch {file delete -force $fdc_file_header}
    catch {file delete -force $tcl_file}
    catch {file delete -force $fdc_file}
    catch {file delete -force $fdc_file_col}
    catch {file delete -force $fdc_file_clock}
    catch {file delete -force $fdc_file_gen_clock}
    catch {file delete -force $fdc_file_io}
    catch {file delete -force $fdc_file_reg}
    catch {file delete -force $fdc_file_delay}
    catch {file delete -force $fdc_file_attr}
    catch {file delete -force $fdc_file_io_stan}
    catch {file delete -force $fdc_file_cp}
    catch {file delete -force $tcl_file_fdc}
    catch {file delete -force $tcl_file_dis}
    close $fpo_tran
#    close $fpo_log
    if {!$stat} {
      puts "INFO:  Translation successful."
      puts "       See: \"$new_fdc_file\""
      puts "       Replace your current *.sdc files with this one."
      puts $fpo_log "INFO:  Translation successful."
      puts $fpo_log "       See: \"$new_fdc_file\""
      puts $fpo_log "       Replace your current *.sdc files with this one."
      if {$auto_update != -1} {
        if {!$timing_corr::all_stat} {
          set flist [impl_files -constraint]
          set flist_fdc [impl_files -fpga_constraint]
          set flist [space_clean $flist]
          set flist_fdc [space_clean $flist_fdc]
          set all_tops [space_clean [join $all_tops]]
          puts "INFO:  Automatically updating your project to reflect the new constraint file(s)"
          set_option -constraint -clear
          set all_tops [lreverse $all_tops]
          foreach f $all_tops {
            if {[lsearch -exact [list $flist] $f] == -1} {
              add_file -fpga_constraint $f
              set fdc_template_file $f
            }
          }
#          if {[llength $flist_fdc]} {
#            set all_tops [linsert $all_tops 0 $flist_fdc]
#          }
#          set_option -fpga_constraint $all_tops
          if {$top_batch == -1} {
            puts "       Do \"Ctrl+S\" to save the new settings."
          } else {
            project -save [project -file]
          }
        } else {
          puts "ERROR:  Translation problems were found."
          return 1
        } 
      }
      close $fpo_log
      return 0
    } else {
      close $fpo_log
      puts "ERROR:  Translation problems were found."
      puts "        See:  \"$log_file\""
      puts "        for details."
      open_file $log_file
      return 1
    }
  }
####  End of main proc

proc space_clean {files} {
  variable os
  if {[llength $files] == 0} {
    return
  }
  if {[regexp NT $os]} {
    regsub -all { (.:)} $files {" "\1} files
  } else {
    regsub -all { (\/)} $files {" "\1} files
  }
  regsub {^} $files {"} files
  return [regsub {$} $files {"}]
}


proc post_error {line curr_file fpo_log fpo_tcl} {
  variable line_num
  variable trans_err_msg

  regsub -all {\{{2,}} $line "{" line
  regsub -all {\}{2,}} $line "}" line
  puts $fpo_log "$trans_err_msg"
  puts $fpo_log "\"$line\""
  puts $fpo_log "Synplicity SDC source file: $curr_file.  Line number: $line_num"
  puts $fpo_log " "
  regsub -all {\[|\]} $trans_err_msg {\\&} trans_err_msg
  regsub -all {\[|\]} $line {\\&} line
  puts $fpo_tcl "log_puts \"@E: :\\\"$curr_file\\\":${line_num}:0:${line_num}:0| ${trans_err_msg}  \{ $line \}.  Correct the issue and rerun sdc2fdc from Implementation: [impl -name]\""
}


proc count_levels {line} {
  variable level

  set level [expr $level + [regsub -all {\{} $line {&} line]]
  set level [expr $level - [regsub -all {\}} $line {&} line]]
}

proc un_wrap {line fpi} {
  variable line_num

  while {1} {                         ;# check for line continuation
    if {[string index $line end] eq "\\"} {
      set line [string replace $line end end]
      set line "$line [gets $fpi]"
      incr line_num
    } else {
      break
    }
  }
  return $line
}

####  handle [all_inputs] & [all_outputs] that are in the input SDC
  proc all_in_out {line} {
    variable all_in
    variable all_out
    variable all_clock
    variable all_reg
    if {[regsub -all {\[\s*all_inputs\s*\]} $line {{$all_inputs_fdc}} line] && ![get_disable [split $line]]} {
      set all_in 1
    }
    if {[regsub -all {\[\s*all_outputs\s*\]} $line {{$all_outputs_fdc}} line] && ![get_disable [split $line]]} {
      set all_out 1
    }
    if {[regsub -all {\[\s*all_clocks\s*\]} $line {{$all_clocks_fdc}} line] && ![get_disable [split $line]]} {
      set all_clock 1
    }
    if {[regsub -all {\[\s*all_registers\s*\]} $line {{$all_registers_fdc}} line] && ![get_disable [split $line]]} {
      set all_reg 1
    }
    return $line
  }

####  Setup for the presence of compile ponits.
  proc setup_cps {sdc_files} {
    variable root_files
    variable root_list
    set root_list {}
    set ret_list $sdc_files
    foreach curr_file $sdc_files {
      set line_num 0
      if {![catch {open $curr_file r} fpi]} { 
        while {![eof $fpi]} {
          gets $fpi line
          if {[regexp "define_current_design" $line]} {
            while {1} {				;# check for line continuation
              if {[string index $line end] eq "\\"} {
                set line [string replace $line end end]
                set line "$line [gets $fpi]"
                incr line_num
              } else {
                break
              }
            }
            set line [join [clean_line_sdc $line]]
            set this_root [lindex $line 1]
            regsub {.*(\.[^\s\.\"\}])+} $this_root {\1} this_root
            regsub {\.} $this_root "" this_root
            if {[lsearch -exact $root_list $this_root] == -1} {
              set root_list [linsert $root_list end $this_root]
            }
            if {[catch {set foo $root_files($this_root)}]} {
              set root_files($this_root) [list $curr_file]
            } else {
              set root_files($this_root) [linsert $root_files($this_root) end  $curr_file]
            }
            close $fpi
            set inx [lsearch $ret_list $curr_file]
            set ret_list [lreplace $ret_list $inx $inx]
            break
          } 
        }
      } else {
        puts "ERROR:  Can't open $curr_file"
        return 1
      }
      catch {close $fpi}
    }
    return $ret_list
  }
    
####  Header
  proc top_header {fp this_file all_files} {
    puts $fp "################################################################################"
    puts $fp "####  This file contains constraints from Synplicity SDC files that have been"
    puts $fp "####  translated into Synopsys FPGA Design Constraints (FDC)."
    puts $fp "####  Translated FDC output file:"
    puts $fp "####  $this_file"
    puts $fp "####  Source SDC files to the translation:"
    foreach fl $all_files {
      puts $fp "####  $fl"
    }
    puts $fp "################################################################################"
    puts $fp " "
    puts $fp " "
  }

####  Sub Header
  proc sub_header {fp this_file} {
    puts $fp "################################################################################"
    puts $fp "####  Source SDC file to the translation:"
    puts $fp "####  $this_file"
    puts $fp "################################################################################"
    puts $fp " "
    puts $fp " "
  }

####  Dis Header
  proc dis_header {fp this_file} {
    puts $fp " "
    puts $fp "################################################################################"
    puts $fp "####  The following Synplicity constraints from file:"
    puts $fp "####  $this_file"
    puts $fp "####  are disabled and have not been translated."
    puts $fp "################################################################################"
    puts $fp " "
  }

  proc clean_line_sdc {curr_line} {
    regsub {^\s*} $curr_line "" curr_line
    regsub -all {\s{2,}} $curr_line " " curr_line
    regsub {\s{1,}$} $curr_line "" curr_line
    regsub -all {\{\s{1,}} $curr_line "{" curr_line
    regsub -all {\s{1,}\}} $curr_line "}" curr_line
    return "$curr_line"
  }

  proc get_port_obj {line} {
    set obj [lindex $line 1]
    if {![regexp {^\{\$} $obj] && ![regexp {^\$} $obj]} {
      regsub -all {\{|\}} $obj "" obj
      if {![regexp {^.:} $obj] && ![regexp ^\$ $obj] && ![regexp {^\[} $obj]} {
        regsub {^} $obj "p:" obj
      }
      if {![regexp {^\[} $obj]} {
        regsub {.*} $obj {{&}} obj
      }
    }
    regsub {^\$.*} $obj {{&}} obj
    return $obj
  }

  proc strip_max {line} {
    set s_index [string first -max $line]
    set e_index $s_index
    incr e_index 4
    while {1} {
      if {[regexp {\s} [string index $line $e_index]]} {
        incr e_index
        continue
      } else {
        break
      }
    } 
    while {1} {
      if {![regexp {\s} [string index $line $e_index]] && [string index $line $e_index] ne ""} {
        incr e_index
        continue
      } else {
        break
      }
    } 
    return [string replace $line $s_index $e_index]
  }

#### Return a string that is the -from/-to/-through list
  proc get_obj_list {line type} {
    switch $type {
      "from" {set type1 "-to";set type2 "-through"; set type "-from"}
      "to" {set type1 "-from";set type2 "-through"; set type "-to"}
      "through" {set type1 "-from";set type2 "-to"; set type "-through"}
    }
    set s_index [string first $type $line]
    if {$s_index == -1} {
      return ""
    }
    switch $type {
      "-from" {incr s_index 6}
      "-to" {incr s_index 4}
      "-through" {incr s_index 9}
    }
    while {1} {
      if {[regexp {\s} [string index $line $s_index]]} {
        incr s_index
        continue
      } else {
        break
      }
    }
    set s_char [string index $line $s_index]
    switch -regexp -- $s_char {
      {\{} {set e_char {\}}} 
      {\$} {set e_char " "}
      {\[} {set e_char {\]}}
      default {set e_char " "}
    }
    regsub {\\} $e_char "" e_char
    set cutoff [string first $type1 $line]
    set cutoff1 [string first $type2 $line]

    set cut_out 1
    set e_index "end"
    if {$cutoff > $s_index} {
      set e_index $cutoff
      set cut_out 0
    }
    if {$cutoff1 > $s_index && ($cutoff > $cutoff1 || $cut_out)} {
      set e_index $cutoff1
    }

    if {($e_char eq " " && $e_index eq "end")} {
      set e_index [string last "$e_char" $line $e_index]
      if {$e_index < $s_index} {
        set e_index "end"
      } else {
        set e_index [string first "$e_char" $line $s_index]
      }
    } else {
      set e_index [string last "$e_char" $line $e_index]
    }
    return [string range $line $s_index $e_index]
  }

####  Check that the object list (a string) has qualifiers for each object and
####  that there is no mixing of object types
####  Return: 0 - OK; 1 - missing qualifier; 2 - mixing of objects; 3 - both
  proc check_line {line} {
    set var_cmd 0
    set qual 1
    set port 0
    set net 0
    set pin 0
    set cell 0
    set clock 0
    
    set s_char [string index $line 0]
    switch -regexp -- $s_char {
      {\{} {
        regsub -all {(\{)(\s)+} $line {\1} line
        regsub -all {(\s)+(\})} $line {\2} line
        regsub -all {\{|\}} $line "" line
        regsub -all {\s{2,}} $line " " line
        while {1} {
          if {[regexp {\s} [string index $line 0]]} {
            set line [string replace $line 0 0 ""]
          } else {
            break
          }
        }
        set l_line [split $line]
        foreach x $l_line {
          set qual_type ""
          switch -regexp -- $x {
            {^\$} {set var_cmd 1;continue}
            default {
              if {![regexp {^.:} $x qual_type]} {
                set qual 0
              } else {
                switch -regexp -- $qual_type {
                  {^(p|b){1}:} {set port 1}
                  {^n:} {set net 1}
                  {^t:} {set pin 1}
                  {^c:} {set clock 1}
                  {^(i|r){1}:} {set cell 1}
                }
              }
            }
          }
        }
      }
      {^(\$|\[){1}} {set var_cmd 1}       ; #it is not a list, but a var or a cmd
      default {              ; #it better be a qualified single object if here
        if {![regexp {^.:} $line qual_type]} {
          set qual 0
        } else {
          switch -regexp -- $qual_type {
            {^(p|b){1}:} {set port 1}
            {^n:} {set net 1}
            {^t:} {set pin 1}
            {^c:} {set clock 1}
            {^(i|r){1}:} {set cell 1}
          }
        }
      }
    }
    set obj_check "${port}${net}${pin}${cell}${clock}${var_cmd}"
    set vec ${qual}[regsub -all 1 $obj_check {&} foo]
    switch -regexp -- $vec {
      {11} {return 0}
      {0[^2-5]} {return 1}
      {1[2-5]} {return 2}
      {0[2-5]} {return 3}
      default {return 4}
    }
  }
#### End check_line

  proc get_clk {line} {
    set inx [lsearch -exact $line "-ref"]
    if {$inx == -1} {
      return ""
    }
    set obj [lindex $line $inx+1]
    regsub -all {\{|\}} $obj "" obj
    regsub {^.:} $obj "" obj
    regsub {^} $obj "c:" obj
    return [regsub {.*} $obj {{&}}]
  }

  proc set_clk_obj {line obj} {
    set inx [lsearch -exact $line "-virtual"]
    if {$inx != -1} {
      return ""
    }
    set found 0
    set inx_list [lsearch -all -regexp $line {^[^-]+}]
    foreach x $inx_list {
      if {[regexp {^[^-]+} [lindex $line $x-1]]} {
        set found 1
        break
      }
    }
    if {$found} {
      set obj [lindex $line $x]
      return [regsub -all {\{|\}} $obj ""]
    } else {
      return $obj
    }
  }

#### The incoming line (at inx) is the start of a Tcl command.
#### Extract the full command and return as a string
  proc get_tcl_cmd {line inx} {
    set level 1
    for {set x  [expr $inx + 1]} {1} {incr x} {
      set level [expr $level + [regsub -all {\[} [lindex $line $x] {&} foo]] ;#] [
      set level [expr $level - [regsub -all {\]} [lindex $line $x] {&} foo]]
      if {!$level} {
        break
      }
    }
    return [join [lrange $line $inx $x]]
  }

  proc set_per {line} {
    variable trans_err
    variable trans_err_msg
    set round "::tcl::mathfunc::round"
    set inx [lsearch -all -regexp $line {^-per}]
    if {$inx != -1} {
      foreach x $inx {
        set tmp [lindex $line $x+1]
        regsub -all {\{|\}} $tmp "" tmp
        regsub {^\$} $tmp {\$} tmp
        if {[regexp {^\[} $tmp]} {
          incr x
          set tmp [get_tcl_cmd $line $x]
        }
        return $tmp
      }
    }
    set msg ""
    set inx [lsearch -all -regexp $line {^-freq}]
    if {$inx != -1} {
      foreach x $inx {
        set val [lindex $line $x+1]
        regsub -all {\{|\}} $val "" val
        if {[regexp {^\$} $val]} {
          set msg "Cannot translate -freq $val.  Use -period <value>."
          break
        }
        return [expr [$round [expr {1000.0/($val)*1000}]] / 1000.0] 
      }
    }
    puts "ERROR:  $msg  No period or frequency found.  Default 1000."
    set trans_err_msg "ERROR:  $msg  No period or frequency found.  Default 1000."
    set trans_err 1
    return 1000
  }

  proc set_route {line name} {
    set inx [lsearch -exact $line "-route"]
    if {$inx == -1} {
      return {}
    } elseif {[lindex $line $inx+1] == 0}  {
      return {}
    } else {
      return [list $name [lindex $line $inx+1]]
    }
  }

  proc set_wave {line period} {
    variable trans_err
    variable trans_err_msg
    variable wave_err
    if {[regexp {^\\\$} $period] || [regexp {^\[} $period]} {
      return ""
    }
    set r_inx [lsearch -exact $line "-rise"]
    set f_inx [lsearch -exact $line "-fall"]
    if {($r_inx == -1 && $f_inx != -1) || ($r_inx != -1 && $f_inx == -1)} {
      set trans_err 1
      set wave_err 1
      puts "ERROR:  Must specify both -rise and -fall or neither"
      set trans_err_msg "ERROR:  Must specify both -rise and -fall or neither"
      return ""
    } elseif {$r_inx == -1 && $f_inx == -1} {
      return [list 0 [expr $period/2.0]]
    } else {
      return [list [lindex $line $r_inx+1] [lindex $line $f_inx+1]]
    }
  }

  proc get_disable {line} {
    set inx [lsearch -exact $line "-disable"]
    if {$inx == -1} {
      return 0
    } else {
      return 1
    }
  }

  proc get_default {line} {
    set inx [lsearch -exact $line "-default"]
    if {$inx == -1} {
      return 0
    } else {
      return 1
    }
  }

  proc get_group {line name} {
    set inx [lsearch -exact $line "-clockgroup"]
    if {$inx == -1} {
      return "${name}_async_SDC" 
    }
    set grp [lindex $line $inx+1]
    regsub -all {\{|\}} $grp "" grp
    return $grp
  }

  proc check_group {group clock} {
    variable group_array
    if {[catch {set clk_l $group_array($group)}]} {
      catch {unset group_array(${clock}_async_SDC)}
      add_group $group $clock
    }
  }

  proc add_group {group clock} {
    variable group_array
    if {[catch {set val $group_array($group)}]} {
      set group_array($group) [list $clock]
    } else {
      set group_array($group) [linsert $group_array($group) end $clock]
    }
  }

  proc infer_group {fpi} {
    while {![eof $fpi]} {
      set line [get_clean_ln $fpi]
      if {[lindex $line 4] eq "inferred"} {
        set grp [lindex $line 5]
        set clk [lindex $line 0]
        regsub -all {\{|\}} $grp "" grp
        add_group $grp $clk
      }
    }
  }

  proc derive_group {fpi} {
    while {![eof $fpi]} {
      set line [get_clean_ln $fpi]
      if {[lindex $line 4] eq "derived" && [lindex $line 5] eq "(from"} {
        set src [lindex $line 6]
        regsub {\)} $src "" src
        set grp [lindex $line 7]
        set clk [lindex $line 0]
        regsub -all {\{|\}} $grp "" grp
        check_group $grp $src
        add_group $grp $clk
      }
    }
  }

  proc get_qual {obj} {
    set q ""
    regexp {^(.:)} $obj q
    switch $q {
      "p:" {
        regsub $q $obj "" obj
        regsub {.*} $obj {[get_ports {&}]} obj
      }
      "b:" {
        regsub $q $obj "" obj
        regsub {.*} $obj {[get_ports {&}]} obj
      }
      "n:" {
        regsub $q $obj "" obj
        regsub {.*} $obj {[get_nets {&}]} obj
      }
      "i:" {
        regsub $q $obj "" obj
        regsub {.*} $obj {[get_cells {&}]} obj
      }
      "t:" {
        regsub $q $obj "" obj
        regsub {.*} $obj {[get_pins {&}]} obj
      }
      "c:" {
        regsub $q $obj "" obj
        regsub {.*} $obj {[get_clocks {&}]} obj
      }
    }
    return $obj
    
  }

  proc get_clk_dly {line} {
    set from_e [lindex $line 1]
    set from_c [lindex $line 2]
    regsub -all {\{|\}} $from_c "" from_c
    regsub -all {^.:} $from_c "" from_c
    if {![regexp {^c:} $from_c]} {
      regsub {^} $from_c {c:} from_c
    }
#    set from_c [get_qual $from_c]
    set to_e [lindex $line 3]
    set to_c [lindex $line 4]
    regsub -all {\{|\}} $to_c "" to_c
    regsub -all {^.:} $to_c "" to_c
    if {![regexp {^c:} $to_c]} {
      regsub {^} $to_c {c:} to_c
    }
#    set to_c [get_qual $to_c]
    set dly [lindex $line 5]
    return [list $from_e $from_c $to_e $to_c $dly]
  }

  proc build_cmd_fdc {cmd} {
    variable comment
    if {$comment ne ""} {
      return "$cmd -comment $comment"
    } else {
      return $cmd
    }
  }
    
  proc set_qual {obj} {
    switch -regexp -- $obj {
      {^t:} {return "pins"}
      {^p:} {return "ports"}
      {^n:} {return "nets"}
      {^i:} {return "cells"}
      default {return "ports"}
    }
  }

  proc morph_con {line} {
    variable group_array
    variable comment
    variable trans_err
    variable trans_err_msg
    variable batch
    variable all_in
    variable all_out
    variable wave_err
    variable route_delay
#### $batch != -1  --> In batch mode
    set wave_err 0
    set route_delay {}
    set new_line $line
    set line [strip_comment $line]
    set line_l [split $line]
    set cmd [lindex $line_l 0]
    switch $cmd {
      "define_clock" {
        set name_inx [lsearch -exact $line_l "-name"]
        if {$name_inx != -1 || $batch != -1} {
          if {$name_inx != -1} {
            set name_txt [lindex $line_l $name_inx+1]
          } else {
            set name_txt [set_clk_obj $line_l ""]
          }
          regsub -all {\{|\}} $name_txt "" name_txt
#          set clk_obj [get_qual [set_clk_obj $line_l $name_txt]]
          set clk_obj [set_clk_obj $line_l $name_txt]
          regsub {^b:} $clk_obj "p:" clk_obj
          if {$batch == -1} {  ;# Do this check if not in batch mode
#            if {![regexp {^\[get_} $clk_obj] && $clk_obj ne ""} {}
            if {![regexp {^.:} $clk_obj] && $clk_obj ne ""} {
              puts "ERROR:  Clock not translated; please add clock object qualifier (p: n: ...) for:  $line"
              set trans_err_msg "ERROR:  Clock not translated; please add clock object qualifier (p: n: ...) for:"
              set trans_err 1
              return $new_line
            }  
          } else {   ;# For regressions, assume port object
            if {![regexp {^.:} $clk_obj] && $clk_obj ne ""} {
              regsub {.*} $clk_obj "p:&" clk_obj
            }
          }
          regsub {^.:} $name_txt "" name_txt
          set period [set_per $line_l]
          set wave [set_wave $line_l $period]
          set route_delay [set_route $line_l $name_txt]
          regsub {^\\} $period "" period
          set group [get_group $line_l $name_txt]
          add_group $group $name_txt
          if {$wave ne ""} {
            set waveform "-waveform \{$wave\}"
          } else {
            set waveform ""
          }
          set new_cmd [build_cmd_fdc "create_clock"]
          if {$clk_obj ne ""} {
            set clk_qual [set_qual $clk_obj]
            set new_line "$new_cmd -name \{$name_txt\} \[get_${clk_qual} \{$clk_obj\}\] -period $period $waveform"
          } else {
            set new_line "$new_cmd -name \{$name_txt\} -period $period $waveform"
          }
        } else {
          puts "ERROR:  Clock not translated; please specify -name for:  $line"
          set trans_err_msg "ERROR:  Clock not translated; please specify -name for:"
          set trans_err 1
        }
        if {!$wave_err} {
          return $new_line
        } else {
          return $line
        }
      }
      "define_clock_delay" {
        set clk_dly_l [get_clk_dly $line_l]
        if {[lindex $clk_dly_l 0] eq "-rise"} {
          set from ":r"
        } else {
          set from ":f"
        }
        if {[lindex $clk_dly_l 2] eq "-rise"} {
          set to ":r"
        } else {
          set to ":f"
        }
        if {[lindex $clk_dly_l 4] eq "-false"} {
          set new_cmd [build_cmd_fdc "set_false_path"]
          set new_line "$new_cmd -from \{[lindex $clk_dly_l 1]$from\} -to \{[lindex $clk_dly_l 3]$to\}"
        } else {
          set new_cmd [build_cmd_fdc "set_max_delay"]
          set new_line "$new_cmd -from \{[lindex $clk_dly_l 1]$from\} -to \{[lindex $clk_dly_l 3]$to\} [lindex $clk_dly_l 4]"
        }
        return $new_line
      }
      "define_input_delay" {
        if {![get_default $line_l]} {
#          set port_obj [get_qual [get_port_obj $line_l]]
          set port_obj [get_port_obj $line_l]
        } else {
          set port_obj {[all_inputs]}
#          set port_obj {{$all_inputs_fdc}}
          set all_in 1
        }
        set dly [lindex $line_l 2]
        if {[regexp {[^0-9\.-]} $dly] && ![regexp {^\$} $dly]} {
          puts "ERROR:  Bad delay value for define_input_delay:  $dly"
          set trans_err_msg "ERROR:  Bad delay value for define_input_delay:  $dly"
          set trans_err 1
          return $new_line
        }
        regsub {^\$.*} $dly {{&}} dly
        set clk_alias  [get_clk $line_l]
        if {[regsub {:f\}} $clk_alias "\}" clk_alias]} {
          set fall 1
        } else {
          set fall 0 
          regsub {:r\}} $clk_alias "\}" clk_alias
        }
#        set clk_alias [get_qual $clk_alias]
        set new_cmd [build_cmd_fdc "set_input_delay"]
        if {$clk_alias eq ""} {
          set new_line "$new_cmd $port_obj $dly -add_delay"
        } else {
          if {$fall} {
            set new_line "$new_cmd $port_obj $dly -clock $clk_alias -clock_fall -add_delay"
          } else {
            set new_line "$new_cmd $port_obj $dly -clock $clk_alias -add_delay"
          }
        }
        return $new_line
      }
      "define_output_delay" {
        if {![get_default $line_l]} {
#          set port_obj [get_qual [get_port_obj $line_l]]
          set port_obj [get_port_obj $line_l]
        } else {
          set port_obj {[all_outputs]}
#          set port_obj {{$all_outputs_fdc}}
          set all_out 1
        }
        set dly [lindex $line_l 2]
        if {[regexp {[^0-9\.-]} $dly] && ![regexp {^\$} $dly]} {
          puts "ERROR:  Bad delay value for define_output_delay:  $dly"
          set trans_err_msg "ERROR:  Bad delay value for define_output_delay:  $dly"
          set trans_err 1
          return $new_line
        }
        regsub {^\$.*} $dly {{&}} dly
        set clk_alias [get_clk $line_l]
        if {[regsub {:f\}} $clk_alias "\}" clk_alias]} {
          set fall 1
        } else {
          set fall 0 
          regsub {:r\}} $clk_alias "\}" clk_alias
        }
#        set clk_alias [get_qual $clk_alias]
        set new_cmd [build_cmd_fdc "set_output_delay"]
        if {$clk_alias eq ""} {
          set new_line "$new_cmd $port_obj $dly -add_delay"
        } else {
          if {$fall} {
            set new_line "$new_cmd $port_obj $dly -clock $clk_alias -clock_fall -add_delay"
          } else {
            set new_line "$new_cmd $port_obj $dly -clock $clk_alias -add_delay"
          }
        }
        return $new_line
      }
      "define_false_path" {
        set from_obj [get_obj_list $line "from"]
        set from_stat 0
        if {$from_obj ne ""} {
          set from_stat [check_line $from_obj]
        }
        set to_obj [get_obj_list $line "to"]
        set to_stat 0
        if {$to_obj ne ""} {
          set to_stat [check_line $to_obj]
        }
        set thru_obj [get_obj_list $line "through"]
        set thru_stat 0
        if {$thru_obj ne ""} {
          set thru_stat [check_line $thru_obj]
        }
        return [output_cons "false" $new_line $from_stat $to_stat $thru_stat $from_obj $to_obj $thru_obj]
      }
      "define_multicycle_path" {
        set from_obj [get_obj_list $line "from"]
        set from_stat 0
        if {$from_obj ne ""} {
          set from_stat [check_line $from_obj]
        }
        set to_obj [get_obj_list $line "to"]
        set to_stat 0
        if {$to_obj ne ""} {
          set to_stat [check_line $to_obj]
        }
        set thru_obj [get_obj_list $line "through"]
        set thru_stat 0
        if {$thru_obj ne ""} {
          set thru_stat [check_line $thru_obj]
        }
        if {[string first "-start" $line] == -1} {
          set start_end "-end"
        } else {
          set start_end "-start"
        }
        set mult [get_val $line]
        return [output_cons "MCP" $new_line $from_stat $to_stat $thru_stat $from_obj $to_obj $thru_obj $mult $start_end]
      }
      "define_path_delay" {
        set dly [get_max $line]
        set line [strip_max $line]
        set from_obj [get_obj_list $line "from"]
        set from_stat 0
        if {$from_obj ne ""} {
          set from_stat [check_line $from_obj]
        }
        set to_obj [get_obj_list $line "to"]
        set to_stat 0
        if {$to_obj ne ""} {
          set to_stat [check_line $to_obj]
        }
        set thru_obj [get_obj_list $line "through"]
        set thru_stat 0
        if {$thru_obj ne ""} {
          set thru_stat [check_line $thru_obj]
        }
        return [output_cons "delay" $new_line $from_stat $to_stat $thru_stat $from_obj $to_obj $thru_obj "" "" $dly]
      }
      "define_reg_input_delay" {
         regsub {^define} $line "set" line
         return $line
      }
      "define_reg_output_delay" {
         regsub {^define} $line "set" line
         return $line
      }
    }
  }

#####  get -max value; line is a string
  proc get_max {line} {
    set s_index [string first "-max" $line]
    incr s_index 4
    while {1} {
      if {[regexp {\s} [string index $line $s_index]]} {
        incr s_index
        continue
      } else {
        break
      }
    }
    set e_index $s_index
    while {1} {
      if {[regexp {[^\s]} [string index $line $e_index]]} {
          incr e_index
          continue
      } else {
        break
      }
    }
    return [string range $line $s_index $e_index]
  }

####  This proc reports errors and assembles the new constraint
  proc output_cons {cmd new_line from_stat to_stat thru_stat from_obj to_obj thru_obj {mult ""} {start_end ""} {dly_val ""}} {
    variable trans_err_msg
    variable trans_err

    switch $cmd {
      "false" {set synplcty "define_false_path"; set synpsys "set_false_path"}
      "MCP" {set synplcty "define_multicycle_path"; set synpsys "set_multicycle_path"}
      "delay" {set synplcty "define_path_delay"; set synpsys "set_max_delay"}
    }
    set synpsys [build_cmd_fdc $synpsys]

    foreach type {from to through} stat "$from_stat $to_stat $thru_stat"  {
      switch $type {
        "from" {set obj_list $from_obj}
        "to" {set obj_list $to_obj}
        "through" {set obj_list $thru_obj}
      }
      if {$stat} {
        switch $stat {
          1 {
            puts "ERROR:  Bad -$type list for $synplcty:  $obj_list \n        Missing qualifier(s) (i: p: n: ...)" 
            set trans_err_msg "ERROR:  Bad -$type list for $synplcty  $obj_list \n        Missing qualifier(s) (i: p: n: ...)" 
            set trans_err 1
          }
          2 {
            puts "ERROR:  Bad -$type list for $synplcty:  $obj_list \n        Mixing of object types not permitted"
            set trans_err_msg "ERROR:  Bad -$type list for $synplcty  $obj_list \n        Mixing of object types not permitted"
            set trans_err 1
          }
          3 {
            puts "ERROR:  Bad -$type list for $synplcty:  $obj_list \n        Mixing of object types and missing qualifiers not permitted"
            set trans_err_msg "ERROR:  Bad -$type list for $synplcty  $obj_list \n        Mixing of object types and missing qualifiers not permitted"
            set trans_err 1
          }
          default {puts "Unknown ERROR in -$type list"}
        }
      }
    }
    if {!($from_stat || $to_stat || $thru_stat)} {
      set from_obj [obj_norm $from_obj]
      if {[regexp {\[\s*(find|expand){1}} $from_obj]} {
        regsub {.*} $from_obj {{&}} from_obj
        regsub -all {\\} $from_obj "" from_obj
      }
      set to_obj [obj_norm $to_obj]
      if {[regexp {\[\s*(find|expand){1}} $to_obj]} {
        regsub {.*} $to_obj {{&}} to_obj
        regsub -all {\\} $to_obj "" to_obj
      }
      set thru_obj [obj_norm $thru_obj]
      if {[regexp {\[\s*(find|expand){1}} $thru_obj]} {
        regsub {.*} $thru_obj {{&}} thru_obj
        regsub -all {\\} $thru_obj "" thru_obj
      }
      switch -regexp -- $synpsys {
        {set_false_path} {
          set new_line "$synpsys \\\n"
        }
        {set_max_delay} {
          set new_line "$synpsys \{$dly_val\} \\\n"
        }
        {set_multicycle_path} {
          set new_line "$synpsys \{$mult\} $start_end \\\n"
        }
      }
      if {$from_obj ne ""} {
        set new_line "$new_line     -from \\\n"
        foreach i $from_obj {
          if {[regexp {^\$} $i]} {
            regsub {.*} $i {{&}} i
          }
          set new_line "$new_line       $i \\\n"
        }
      }
      if {$to_obj ne ""} {
        set new_line "$new_line     -to \\\n"
        foreach i $to_obj {
          if {[regexp {^\$} $i]} {
            regsub {.*} $i {{&}} i
          }
          set new_line "$new_line       $i \\\n"
        }
      }
      if {$thru_obj ne ""} {
        set new_line "$new_line     -through \\\n"
        foreach i $thru_obj {
          if {[regexp {^\$} $i]} {
            regsub {.*} $i {{&}} i
          }
          set new_line "$new_line       $i \\\n"
        }
      }
      regsub {\\\n$} $new_line "\n" new_line
    }
    return $new_line
  }

####  This proc normalizes the input string for spaces and such.
####  the string is the list of objects

  proc obj_norm {obj_l} {
    regsub -all {(\{)(\s)+} $obj_l {\1} obj_l ;#Remove spaces between curly
    regsub -all {(\s)+(\})} $obj_l {\2} obj_l
    regsub -all {\}\]} $obj_l {\} \]} obj_l   ;#Need space between curly & close square
    regsub -all {\\(\})} $obj_l {\1} obj_l    ;#Remove escpaes of both bracket types
    regsub -all {\\(\])} $obj_l {\1} obj_l
    regsub -all {^\[} $obj_l {\\&} obj_l      ;#Restore escapes of the start and end delimiters
    regsub -all {\]$} $obj_l {\\&} obj_l
    regsub -all {\{} $obj_l {\\&} obj_l
    regsub -all {\}} $obj_l {\\&} obj_l
    return $obj_l
  }


####  extract find and expand commands
####  treat line as a string
  proc extract_col {cmd line fpo} {
    variable cmd_num
    set l_line $line
    regsub -all {\[\s+}  $l_line {[} l_line
    regsub -all {\s+\]}  $l_line {]} l_line
    set s_inx [string first "\[$cmd " $l_line]
    while {$s_inx != -1} {
      set loc [expr $s_inx+6]
      set nested 0
      while {1} {
        if {[regexp {\[} [string index $l_line $loc]]} {
          incr nested
        }
        if {[regexp {\]} [string index $l_line $loc]] && !$nested} {
          break
        } elseif {[regexp {\]} [string index $l_line $loc]] && $nested} {
          incr nested -1
        }
        incr loc
      }
      set exp [string range $l_line $s_inx $loc]
      regsub {^\[} $exp "{" exp
      regsub {\]$} $exp "}" exp
      puts $fpo "define_scope_collection fdc_cmd_${cmd_num} $exp"
      set l_line [string replace $l_line $s_inx $loc "\$fdc_cmd_${cmd_num}"]
      set s_inx [string first "\[$cmd " $l_line]
      incr cmd_num
    }
    return $l_line
  }

####  This proc collects any -comment {....} and separates it from the input string,
####  then returns the modified string.  Comment will be in the variable
  proc strip_comment {line} {
    variable comment
    set l_line $line
    set comment ""
    set s_inx [string first "-comment" $l_line]
    if {$s_inx == -1} {
      return $line
    } 
    set loc [expr $s_inx+8]
    while {1} {
      if {[regexp {\s} [string index $l_line $loc]]} {
        incr loc
        incr c -1
        continue
      } else {
        break
      }
    }    ;# should be at open curly bracket
    set c_start $loc
    set nested 0
    incr loc
    while {1} {
      if {[regexp {\{} [string index $l_line $loc]]} {
        incr nested
      }
      if {[regexp {\}} [string index $l_line $loc]] && !$nested} {
        break
      } elseif {[regexp {\}} [string index $l_line $loc]] && $nested} {
        incr nested -1
      }
      incr loc
    }
    set comment [string range $l_line $c_start $loc]
    set line [string replace $line $s_inx $loc]
    return [regsub -all {\s{2,}} $line " "]
  }


####  Use this proc to grab constraint values that don't have an accompanying 
####  -option.  The "opts" is a regexp with the options that have values;
####  thus, you don't want to return one of these values
  proc get_val {line {opts {(-from|-to|-through)+}}} {
    set s_chars [list {\{} {\[}]
    set e_chars [list {\}} {\]}]
    regsub -all {(\{)(\s)+} $line {\1} line ;#Remove spaces between curly
    regsub -all {(\s)+(\})} $line {\2} line
    foreach s $s_chars e $e_chars {
      regsub {\\} $s "" s
      regsub {\\} $e "" e
      set loc "end"
      while {1} {
        set s_index [string last $s $line $loc]
        set e_index [string first $e $line $s_index]
        if {$s_index != -1} {
          set line [string replace $line $s_index $s_index "@"]
          set line [string replace $line $e_index $e_index "@"]
          regsub -all {\s} [string range $line $s_index $e_index] "" atom
          set line [string replace $line $s_index $e_index $atom]
          set loc [expr $s_index-1]
        } else {
          break
        }
      }
    }
    regsub -all {\[|\]} $line {\\&} line
    regsub -all {\{|\}} $line {\\&} line
    set inx_l [lsearch -regexp -start 1 -all $line {^[^-]}]
    foreach x $inx_l {
      if {[regexp $opts [lindex $line $x-1]]} {
        continue
      } else {
        return [lindex $line $x]
      }
    }
  }


  proc xdc_clock_group {} {

    variable placement
#    variable pr_dir_global
    variable impl_dir
#    variable impl_ovride
#    variable impl_result
    variable grp_names
    variable clock_array
    variable net_array
    set pr_dir_global ""
    set impl_ovride 0
    set impl_result [impl -result_file]
    q_place
    if {[regexp {edf$} $impl_result]} {
      set edif "_edif"
    } else {
      set edif ""
    }
    regsub -all {\\} $impl_result {/} srm
    regsub {\.[a-zA-Z]+$} $srm ".srm" srm
    regsub {.*\/([^\/]+$)} $srm {$impl_dir/\1} srm
    regsub {\$impl_dir} $srm "$impl_dir" srm
    regsub -all {\\} $impl_result {/} xdc
    regsub {\.[a-zA-Z]+$} $xdc "${edif}.xdc" xdc
    regsub {.*\/([^\/]+$)} $xdc {$impl_dir/\1} xdc
    regsub {\$impl_dir} $xdc "$impl_dir" xdc
    set xdc_new ${xdc}_new
    set r_list [get_pr_dir "" 0]
    if {[lindex $r_list 0]} {
      puts "No active P&R job"
      return 1
    }
    set pr_dir [lindex $r_list 1]
    set out_script $pr_dir/clock_groups.tcl


    if {[catch {open $xdc r} fpi_xdc]} {
      puts "ERROR:  Can't open $xdc"
      return 1
    }
    if {[catch {open $xdc_new w} fpo_xdc]} {
      puts "ERROR:  Can't open $xdc_new"
      return 1
    }
    if {[catch {open $out_script w} fpo_tcl_xdc]} {
      puts "ERROR:  Can't open $out_script"
      return 1
    }
    open_file $srm

    parse_xdc_clk_grp $fpi_xdc $fpo_xdc
    close $fpi_xdc
    close $fpo_xdc
    file copy -force $xdc_new $xdc
    file_close $srm
    write_tcl $fpo_tcl_xdc
    close $fpo_tcl_xdc
  }

  proc write_tcl {fpo} {

    variable clock_array
    variable net_array
    variable grp_names


    puts $fpo "set fpo \[open \"clock_groups.xdc\" w\]"
    foreach grp $grp_names {
      set clk 0
      set net 0
      while {1} {
        incr net
        if {![catch {set net_name $net_array($grp,$net)}]} {
          puts $fpo "set ${grp}_${net} \[get_clocks -of_objects \[get_nets \{$net_name\}\]\]"
        } else {
         break
        }
      }
      puts -nonewline $fpo "puts \$fpo \"set_clock_groups -name $grp -asynchronous -group \\\[get_clocks \\\[list "
      while {1} {
        incr clk
        if {![catch {set clk_name $clock_array($grp,$clk)}]} {
          puts -nonewline $fpo "$clk_name "
        } else {
          break
        }
      }
      puts -nonewline $fpo "\\\]\\\]\""
      puts $fpo " "
    }
    puts $fpo "close \$fpo"
    puts $fpo "read_xdc clock_groups.xdc"
  }
  proc parse_xdc_clk_grp {fpi fpo} {

    variable clock_array
    variable net_array
    variable grp_names

    set grp_names {}
    catch {unset clock_array}
    catch {unset net_array}

    while {![eof $fpi]} {
      gets $fpi line
      set new_line $line
      set line [clean_line_sdc $line]
      if {[regexp {^set_clock_groups .*_derived_clock} $line]} {
        set clk 0
        set net 0
        set new_line #$new_line
        regsub -all {\}\]} $line "" line
        regsub -all {\{|\}} $line "" line
        set l_list [join $line]
        set grp_name [lindex $l_list 2]
        set grp_names [linsert $grp_names end $grp_name]
        set c_list [lrange $l_list 6 end]
        foreach item $c_list {
          if {[regexp {_derived_clock} $item]} {
            regsub {^.*\|} $item "" item_root
            regsub {_CLKIN.$} $item_root "" item_root
            regsub {\[[0-9]+\]$} $item_root {*&} item_root
            set inst_l [c_list [find -hier -inst *$item_root -filter @inst_of == keepbuf]]
            if {[llength $inst_l] > 1} {
              foreach item1 $inst_l {
# isolate inst.leaf from item1
                regsub -all {\(|\)|\[|\]|\/|\||\\} $item1 {\\&} item1_rexp
                regsub {^.*\.([^\.]+\.[^\.]+$)} $item1_rexp {\1} item1_rexp
                regsub {i:} $item1_rexp "" item1_rexp
                regsub {\|} $item "." item
                if {[regexp $item1_rexp $item]} {
                  break
                }
              }
            } else {
              set item1 $inst_l
            }
            set net_obj [lindex [c_list [expand -level 1 -net -from $item1]] end]
            regsub {n:} $net_obj "" net_obj
            regsub -all {\\\.} $net_obj "@" net_obj
            regsub -all {\.} $net_obj {/} net_obj
            regsub -all {@} $net_obj {_} net_obj
            incr net
            set net_array($grp_name,$net) $net_obj
            incr clk
            set clock_array($grp_name,$clk) \$${grp_name}_${net}
          } else {
            incr clk
            set clock_array($grp_name,$clk) $item
          }
        }
      }
      puts $fpo $new_line
    }
  }


############################################
######  Report the FDC query results  ######
############################################
  proc check_fdc_query {args} {
    global tcl_library
    global env
    variable os
    variable result_array
    variable fdc_array
    variable fdc_template
    variable ibufs
    variable obufs
    variable inferred_clks
    variable default_period
    variable in_c_fdc
    variable regs_c
    variable debug
    variable OnePass
  
    if {[lindex $args 0] ne "" && [lindex $args 0] ne "-full_check"} {
      puts "Usage:  \"check_fdc_query \[-full_check\]\""
      return 1
    }
    if {[catch {set os $env(OS)}]} {
      set os $env(OSTYPE)
    }
    if {[lindex $args 0] eq "-full_check"} {
      set full 1
    } else {
      set full 0
    }
    set fdc_query_db [space_clean_file [impl -dir] "fdc_query_db.tcl"]
    catch {file delete -force $fdc_query_db}
    set conf [space_clean_file [impl -dir] "testconf.txt"]
    set conf_save [space_clean_file [impl -dir] "testconf_user.txt"]
    back_file $conf $conf_save
    regsub -all {\\} $tcl_library {/} tcl_lib_glob
    set find_out [space_clean_file $tcl_lib_glob "find_out.txt"]
    if {[file exists $find_out]} {
      file copy -force $find_out $conf
    } else {
      puts "ERROR:  Can't find $find_out"
      return 1
    }
    set query_file [space_clean_file $tcl_lib_glob "fdc_query.fdc"]
    if {![file exists $query_file]} {
      puts "ERROR:  Can't find $query_file"
      return 1
    }
    set top [top_result]
    set fdc_infer_file [space_clean_file [impl -dir] "${top}_infer.fdc"]
    if {$fdc_template} {
      set temp_file [space_clean_file $tcl_lib_glob "fdc_template.fdc"]
      if {![file exists $temp_file]} {
        puts "ERROR:  Can't find $temp_file"
        return 1
      }
      set flist [impl_files -constraint]
      set flist [space_clean $flist]
      set_option -constraint -clear
      set_option -fpga_constraint ""
      catch {project_file -remove $temp_file}
      add_file -fpga_constraint $temp_file
      if {$inferred_clks} {
        add_file -fpga_constraint $fdc_infer_file
      }
    }
    catch {project_file -remove $query_file}
    add_file -fpga_constraint $query_file
    set flist_fdc [impl_files -fpga_constraint]
    set flist_fdc [space_clean $flist_fdc]
    if {[llength $flist_fdc] == 1} {
      set flist_fdc [impl_files -constraint]
      set flist_fdc [space_clean $flist_fdc]
    }
    if {!$fdc_template} {
      foreach x $flist_fdc {
        catch {file mtime $x [clock seconds]}
        break
      }
    }
    project_file -move $query_file ""
    if {$full} {
      set srr_file1 [space_clean_file [impl -dir] "${top}.srr"]
      set srr_file1_bak [space_clean_file [impl -dir] "${top}_bak.srr"]
      set srr_file [space_clean_file [impl -dir] "${top}_cck.srr"]
      set srr_file_bak [space_clean_file [impl -dir] "${top}_cck_bak.srr"]
      back_file $srr_file $srr_file_bak
      back_file $srr_file1 $srr_file1_bak
      set stat [project -run constraint_check -fg]
    } else {
      set srr_file [space_clean_file [impl -dir] "${top}.srr"]
      set srr_file_bak [space_clean_file [impl -dir] "${top}_bak.srr"]
      back_file $srr_file $srr_file_bak
      if {!$fdc_template || $inferred_clks} {
        set stat [project -run compile -fg]
      } else {
        set stat [project -run compile -clean -fg]
      }
    }
    if {![file exists $srr_file]} {
      puts "ERROR:  Could not find $srr_file"
      return 1
    } elseif {$stat >= 2} {
      set srr_file2_bak [space_clean_file [impl -dir] "${top}_fdc.srr"]
      puts "ERROR:  See $srr_file2_bak"
      back_file $srr_file $srr_file2_bak
      open_file $srr_file2_bak
      restore_file $srr_file $srr_file_bak
      if {$full} {
        restore_file $srr_file1 $srr_file1_bak
      }
      project_file -remove $query_file
      file delete -force $conf
      catch {file delete -force $fdc_query_db}
      restore_file $conf $conf_save
      return 1
    }
    if {[catch {open $srr_file r} fpi]} {
      puts "ERROR:  Could not open $srr_file"
      restore_file $srr_file $srr_file_bak
      if {$full} {
        restore_file $srr_file1 $srr_file1_bak
      }
      project_file -remove $query_file
      file delete -force $conf
      catch {file delete -force $fdc_query_db}
      restore_file $conf $conf_save
      return 1
    }
    set found 0
    set result 0
    set inx 0
    while {![eof $fpi]} {
      gets $fpi line
      if {[regexp {^Results of find command \(no match\):} $line]} {
        set result 0
        continue
      }
      if {[regexp {^Results of find command: (get_|all_|define_collection){1}} $line]} {
        set inx_strg [string range $line 25 end]
        set result_array($inx_strg,0) $inx_strg
        set result 1
        incr inx
        set last_line {}
        continue
      }
      if {![regexp {^\s+} $line] && $result} {
        set result 0
        continue
      }
      if {$result} {
        if {![regexp {^\s+\(} $line] && $line ne $last_line} {
          set result_array($inx_strg,$result) $line
          set last_line $line
          incr result
        }
      }
    }
    close $fpi
    set temp_sdc_file [space_clean_file [impl -dir] "${top}_template.sdc"]
    set cck_fdc_file [space_clean_file [impl -dir] "${top}_cck_fdc.rpt"]
    if {[catch {open $cck_fdc_file w} fpo]} {
      puts "ERROR:  Could not open $cck_fdc_file"
      restore_file $srr_file $srr_file_bak
      if {$full} {
        restore_file $srr_file1 $srr_file1_bak
      }
      project_file -remove $query_file
      file delete -force $conf
      catch {file delete -force $fdc_query_db}
      restore_file $conf $conf_save
      return 1
    }
    set srs_clk_list {}
    if {$fdc_template} {
      if {[catch {open $temp_sdc_file w} fpo1]} {
        puts "ERROR:  could not open $temp_sdc_file"
        return 1
      }
      if {!$inferred_clks} {
        catch {open $fdc_infer_file w} fpo2
      }
      set srs_file [space_clean_file [impl -dir] "${top}.srs"]
      open_file $srs_file
      if {[sizeof_collection [find -hier -inst * -filter {@inst_of == IBUF*}]]} {
        set ibufs 1
      } else {
        set ibufs 0
      }
      if {[sizeof_collection [find -hier -inst * -filter {@inst_of == OBUF*}]]} {
        set obufs 1
      } else {
        set obufs 0
      }
      set regs_c [make_all_reg_col]
#      set all_in [find -port * -in [c_diff [define_collection [object_list [all_inputs]]] [define_collection [object_list [all_clocks 1]]]]]
      set all_in [make_in_col]
      set all_seq_i [make_in_reg_col $all_in]
      set all_out  [find -port * -in [define_collection [object_list [all_outputs]]]]
      set all_seq_o [make_out_reg_col $all_out]
      set srs_clk_list [object_list [all_clocks 1]]
      puts "Generating FDC Template..."
    }
    puts $fpo "FDC query commands results"
    puts $fpo "**************************"
    set all_clk_list {}
    if {$inx == 0} {
      puts $fpo "(none)"
    } else {
      if {![file exists $fdc_query_db]} {
        puts $fpo "@W: : No FDC file info available"
        set no_info 1
      } else {
        set no_info 0
        source $fdc_query_db
      }
      if {!$no_info} {
        for {set fdc_entry 1} {1} {incr fdc_entry} {
          if {![catch {set inx_key $fdc_array($fdc_entry,col)}]} {
            set result 0
            puts $fpo "###############################"
            puts $fpo "$fdc_array($fdc_entry,line1)"
            puts $fpo "$fdc_array($fdc_entry,line2)"
            puts $fpo "Results of query command: $inx_key"
            set clk_list [list]
            set is_clock 0
            for {set res 1} {1} {incr res} {
              if {![catch {set y $result_array($inx_key,$res)}]} {
                if {[regexp {^get_clocks } $inx_key]} {
                  set is_clock 1
                  regsub {_keep} $y "_derived_clock" y
                  regsub {^\s+} $y "" y1
                  if {$fdc_template && [lsearch -exact $srs_clk_list $y1] != -1} {
                    set clk_list [linsert $clk_list end $y1]
                    if {![regexp {_derived_clock} $y]} {
                      set all_clk_list [linsert $all_clk_list end [regsub {^\s+} $y "p:"]]
                    }
                  }
                }
                puts $fpo "$y"
                set result 1
              } else {
                if {!$result} {
                  puts $fpo "    (none)"
                }
                break
              }
            }
            if {$fdc_template && $is_clock} {
              set clk [lindex $clk_list 0]
              puts $fpo1 "#################################################################################"
              if {[sizeof_collection [find -port $clk]]} {
                puts $fpo1 "define_clock -name \{$clk\} \{p:$clk\} -period $default_period -clockgroup ${clk}_clkgroup"
              } else {
                puts $fpo1 "define_clock -name \{$clk\} \{t:$clk\} -period $default_period -clockgroup ${clk}_clkgroup"
              }
              set in_c_fdc 1
              in_ports_per_clk $clk_list $all_seq_i $fpo1
              set in_c_fdc 0
              out_ports_per_clk $clk_list $all_seq_o $fpo1
              puts $fpo1 "#################################################################################"
            }
          } else {
            set foo [expr $fdc_entry + 1]
            if {[catch {set inx_key $fdc_array($foo,line1)}]} {
              break
            }
            puts $fpo "###############################"
            puts $fpo "$fdc_array($fdc_entry,line1)"
            puts $fpo "$fdc_array($fdc_entry,line2)"
            puts $fpo "Results of query command: <null>"
            puts $fpo "    (none)"
          }
        }
      }
    }
    if {$fdc_template} {
      if {!$inferred_clks} {
        if {[llength $all_clk_list]} {
          set all_clk_col [define_collection $all_clk_list]
        } else {
          set all_clk_col [find 1]
        }
        if {!$OnePass} {
          set inferred_clks [do_infer_clks $all_clk_col $fpo2]
        }
      } else {
        project_file -remove $fdc_infer_file
      }
      close $fpo1
      catch {close $fpo2}
      file_close $srs_file
      puts "Done."
      project_file -remove $temp_file
    }
    close $fpo
    if {!$fdc_template} {
      open_file $cck_fdc_file
    }
    file delete -force $conf
    project_file -remove $query_file
    catch {file delete -force $fdc_query_db}
    catch {unset result_array}
    catch {unset fdc_array}
#    restore_file $conf $conf_save
    restore_file $srr_file $srr_file_bak
    if {$full} {
      restore_file $srr_file1 $srr_file1_bak
    }
    return 0
  }

##  Make a collection of non-clock input ports
  proc make_in_col {} {
    set col [define_collection [object_list [all_inputs]]]
    set ret_col $col
    foreach_in_collection c $col {
      if {[get_prop -prop is_clock [lindex [object_list [get_nets -of_objects $c]] 0]] eq "1"} {
        set ret_col [remove_from_collection $ret_col $c]
      }
    }
    return $ret_col
  }

  proc start_time {{cmd ""}} {
    puts  "Start: [clock format [clock seconds] -format  "%a %b %e %H:%M:%S %Z %Y" ] $cmd"
  }

  proc end_time {{cmd ""}} {
    puts  "End:   [clock format [clock seconds] -format  "%a %b %e %H:%M:%S %Z %Y" ] $cmd"
  }

  proc make_in_reg_col {port_c } {
    variable ibufs
    set ret_c [find 1]
    foreach p [c_list $port_c] {
      if {![sizeof_collection [find $p]]} {
        continue
      }
      set reg_c [expand -hier -seq -from $p]
      foreach r [c_list $reg_c] {
        set clk [get_prop -prop clock $r]
        if {![catch {set foo $port_regs($p,$clk)}]} {
          continue
        } else {
          set port_regs($p,$clk) $r
          set ret_c [c_union $ret_c [define_collection $r]]
        }
      }
    }
    if {$ibufs} {
      foreach i [c_list [find -hier -inst * -filter {@inst_of != IBUFG* && (@inst_of == IBUF* || @inst_of == IOBUF*)}]] {
        set reg_c [expand -hier -seq -from $i]
        foreach r [c_list $reg_c] {
          set clk [get_prop -prop clock $r]
          if {![catch {set foo $port_regs($i,$clk)}]} {
            continue
          } else {
            set port_regs($i,$clk) $r
            set ret_c [c_union $ret_c [define_collection $r]]
          }
        }
      }
    }
    return $ret_c
  }

  proc make_out_reg_col {port_c} {
    variable obufs
    set ret_c [find 1]
    foreach p [c_list $port_c] {
      if {![sizeof_collection [find $p]]} {
        continue
      }
      set reg_c [expand -hier -seq -to $p]
      foreach r [c_list $reg_c] {
        set clk [get_prop -prop clock $r]
        if {![catch {set foo $port_regs($p,$clk)}]} {
          continue
        } else {
          set port_regs($p,$clk) $r
          set ret_c [c_union $ret_c [define_collection $r]]
        }
      }
    }
    if {$obufs} {
      foreach i [c_list [find -hier -inst * -filter {@inst_of == OBUF* || @inst_of == IOBUF*}]] {
        set reg_c [expand -hier -seq -to $i]
        foreach r [c_list $reg_c] {
          set clk [get_prop -prop clock $r]
          if {![catch {set foo $port_regs($i,$clk)}]} {
            continue
          } else {
            set port_regs($i,$clk) $r
            set ret_c [c_union $ret_c [define_collection $r]]
          }
        }
      }
    }
    return $ret_c
  }

  proc make_all_reg_col {} {
    set ret_c [find 1]
      foreach r [c_list [find -hier -seq *]] {
        set clk [get_prop -prop clock $r]
        if {![catch {set foo $regs($clk)}]} {
          continue
        } else {
          set regs($clk) $r
          set ret_c [c_union $ret_c [define_collection $r]]
        }
      }
    return $ret_c
  }

  proc do_infer_clks {clk_col fpo2} {
    variable in_c_fdc
    set num_infer 0
    set min "::tcl::mathfunc::min"
    set max "::tcl::mathfunc::max"
    set src_list {}
    set in_c_fdc 1
    set top_clks_l [all_fanin -to [find -net * -filter {@clock == * && !@is_gated_clock}] -start] 
    if {[llength [split [join $top_clks_l]]]} {
      set top_clks [define_collection [join $top_clks_l]]
    } else {
      set top_clks [find 1]
    }
    if {[sizeof_collection $top_clks]} {
      set top_clks [c_diff $top_clks $clk_col]
      set clks [concat [split [join [all_fanin -to [find -hier -net * -filter {@clock == *inferred_clock*}] -start -flat]]] [get_object_name $top_clks]]
    } else {
      set clks [split [join [all_fanin -to [find -hier -net * -filter {@clock == *inferred_clock*}] -start -flat]]]
    }
    set in_c_fdc 0
#puts "TOP_CLKS: [get_object_name $top_clks]"
#puts "CLK:  $clks"
    foreach i $clks {
      incr num_infer
      if {[regexp {\[(\d)+:(\d)+\]} $i r j k]} {
        for {set l [$min $j $k]} {$l<=[$max $j $k]} {incr l} {
          regsub [regsub -all {\[|\]} $r {\\&}]$ $i "\[$l\]" i_i
          set src_list [linsert $src_list end $i_i]
        }
      } else {
        set src_list [linsert $src_list end $i]
      }
    }
    foreach i $src_list {
#puts "SRC: $i"
      regexp {^.:} $i qual
      if {$qual eq "t:"} {
        set n [regsub {t:} $i {}]
        puts $fpo2 "create_clock -name \{$n\} \[get_pins \{$i\}\] -period 100"
      } else {
        set n [regsub {p:} $i {}]
        puts $fpo2 "create_clock -name \{$n\} \[get_ports \{$i\}\] -period 100"
      }
      puts $fpo2 "set_clock_groups -asynchronous -name \{${n}_group\} -group \[get_clocks -include_generated_clocks \{$n\}\]"
    }
    return $num_infer
  }

if {[product_type] eq "protocompiler" || [product_type] eq "protocompiler_dx" || [product_type] eq "protocompiler_s"} {
  set prod "protocompiler"
} else {
  set prod "legacy"
}
set no_usage 0

############################################
####  Options per command
####
############################################
############################################
####  Type <list_c> can be Tcl list or a collection
####  Type <col> can only be a collection
####  Type <list> can only be a Tcl list, not a collection
############################################
###   New <help> entry implemented; option with no <help> entry are hidden, but still work
############################################
####  proto_correlate       ##############

#### -impl_name is part of the signature and is used to cretae the project_dir & impl_active variables in pro_ise_corr; it will 
#### be constructed here, so we ignore the option in this context
#### -impl_result is part of the signature and is used to cretae the impl_dir variable in pro_ise_corr; it will 
#### be constructed here, so we ignore the option in this context
#### New:  for GUI implementation,  the above 2 options will be requried.
set options(proto_correlate,-impl_name)                [add_option "-impl_n.*		reqs    {-gui}     <value> <strg>"]
set options(proto_correlate,-impl_result)              [add_option "-impl_r.*		reqs    {-gui}     <value> <strg>"]
#set options(proto_correlate,-delay)                    [add_option "-del.*		ignore"]
#set options(proto_correlate,-offset)                   [add_option "-o.*		ignore"]
#set options(proto_correlate,-clock)                    [add_option "-c.*		ignore"]
set options(proto_correlate,-qor)                      [add_option "-qor.*		plural	{1}	<value>	0 1"]
#set options(proto_correlate,-tig)                      [add_option "-t.*		ignore"]
#set options(proto_correlate,-reset)                    [add_option "-rese.*		ignore"]
set options(proto_correlate,-scf_mode)                 [add_option "-scf_mode		excl	{-xdc_mode,-sdc_verif}	reqs	{-pr_dir}	<help>"]
set options(proto_correlate,-xdc_mode)                 [add_option "-xdc_mode		excl    {-scf_mode}		reqs	{-pr_dir}	<help>"]
set options(proto_correlate,-xdc_place)                [add_option "-xdc_place		reqs	{-pr_dir,-xdc_mode}"]
set options(proto_correlate,-pr_dir)                   [add_option "-pr_dir		plural	{1}	<value>	<strg>	<help>"]
set options(proto_correlate,-result_gold)              [add_option "-result_gold	excl	{-xdc_mode}	<value>	<strg>"]
set options(proto_correlate,-indices)                  [add_option "-indices		plural	{1}	<value>	<list>"]
set options(proto_correlate,-ta_index)                 [add_option "-ta_index		plural	{1}	<value>	<int>	<help>"]
set options(proto_correlate,-qii_index)                [add_option "-qii_index		plural	{1}	<value>	<int>	<help>"]
set options(proto_correlate,-trce_index)               [add_option "-trce_index		plural	{1}	<value>	<int>	<help>"]
set options(proto_correlate,-paths_per)                [add_option "-paths_per		plural	{1}	<value>	<int>	<help>"]
set options(proto_correlate,-num_paths)                [add_option "-num_paths		plural	{1}	<value>	<int>"]
set options(proto_correlate,-slack)                    [add_option "-slack		plural	{1}	<value>	<strg>"]
set options(proto_correlate,-hstdm_report)             [add_option "-hstdm_report	plural	{1}	<value>	<strg>"]
set options(proto_correlate,-sdc_verif)                [add_option "-sdc_verif		plural	{1}	<help>"]
set options(proto_correlate,-hold)                     [add_option "-hold		plural	{1}"]
set options(proto_correlate,-effort)                   [add_option "-effort		reqs	{-sdc_verif}	<value>	low medium high"]
set options(proto_correlate,-sort_by)                  [add_option "-sort_by		plural	{1}	<value>	end start slack"]
set options(proto_correlate,-load_sta)                 [add_option "-load_sta		plural	{1}	<help>"]
set options(proto_correlate,-default_sta)              [add_option "-default_sta	plural	{1}	<help>"]
set options(proto_correlate,-back_anno)                [add_option "-back_anno		plural	{1}	<help>"]
set options(proto_correlate,-regress)                  [add_option "-regress		plural	{1}"]
set options(proto_correlate,-gui)                      [add_option "-gui		reqs	{-impl_name,-impl_result}"]

############################################
####  all_fanin/all_fanout    ##############

set options(all_fanout,-clock_tree)       [add_option "-c.*		excl	{-from}		<help>"]
set options(all_fanout,-from)             [add_option "-fr.*		excl	{-clock_tree}	<value>	<list_c>	<help>"]
set options(all_fanout,-endpoints_only)   [add_option "-en.*		plural	{1}		<help>"]
set options(all_fanout,-exclude_bboxes)   [add_option "-ex.*		plural	{1}		<help>"]
set options(all_fanout,-break_on_bboxes)  [add_option "-b.*		plural	{1}		<help>"]
set options(all_fanout,-only_cells)       [add_option "-o.*		plural	{1}		<help>"]
set options(all_fanout,-flat)             [add_option "-fl.*		plural	{1}		<help>"]
set options(all_fanout,-levels)           [add_option "-l.*		plural	{1}		<value>	<int>		<help>"]
set options(all_fanout,-trace_arcs)       [add_option "-t.*		plural	{1}		<value>	all timing	<help>"]

set options(all_fanin,-to)                [add_option "-to		plural	{1}		<value>	<list_c>	<help>"]
set options(all_fanin,-startpoints_only)  [add_option "-s.*		plural	{1}		<help>"]
set options(all_fanin,-exclude_bboxes)    [add_option "-ex.*		plural	{1}		<help>"]
set options(all_fanin,-break_on_bboxes)   [add_option "-b.*		plural	{1}		<help>"]
set options(all_fanin,-only_cells)        [add_option "-o.*		plural	{1}		<help>"]
set options(all_fanin,-flat)              [add_option "-f.*		plural	{1}		<help>"]
set options(all_fanin,-levels)            [add_option "-l.*		plural	{1}		<value>	<int>		<help>"]
set options(all_fanin,-trace_arcs)        [add_option "-tr.*		plural	{1}		<value>	all timing	<help>"]

############################################
#### create_fdc_template      ##############

set options(create_fdc_template,-uniquify) 		[add_option "-u.*		ignore"]
set options(create_fdc_template,-in_delay) 		[add_option "-i.*		plural	{1}	<value>	<float>	<help>"]
set options(create_fdc_template,-out_delay) 		[add_option "-ou.*		plural	{1}	<value>	<float>	<help>"]
set options(create_fdc_template,-period) 		[add_option "-p.*		plural	{1}	<value>	<float>	<help>"]
set options(create_fdc_template,-no_io_delay) 		[add_option "-no_i.*		excl	{-in_delay,-out_delay}	<help>"]
set options(create_fdc_template,-no_clock_source)	[add_option "-no_c.*		plural	{1}	<help>"]
set options(create_fdc_template,-one_pass)		[add_option "-on.*		plural	{1}	<help>"]

#################################################
####       check_hstdm_timing      ##############
set options(check_hstdm_timing,-slack)                  [add_option "-slack		plural	{1}	<value>	<float>	<help>	 -- Only report paths with a slack less than the given value.  Default is 1500 nS."]
set options(check_hstdm_timing,-port2tx)                [add_option "-port2tx		plural	{1}			<help>	 -- Report any paths from input ports to the Transmit logic."]
set options(check_hstdm_timing,-rx2port)                [add_option "-rx2port		plural	{1}			<help>	 -- Report any paths from the Receive logic to output ports."]
set options(check_hstdm_timing,-rx2tx)                  [add_option "-rx2tx		plural	{1}			<help>	 -- Report any paths from the Receive logic to the Transmit logic (multi-hop)."]
set options(check_hstdm_timing,-rx2user)                [add_option "-rx2user		plural	{1}			<help>	 -- Report any paths from the Receive logic to user logic."]
set options(check_hstdm_timing,-user2tx)                [add_option "-user2tx		plural	{1}			<help>	 -- Report any paths from user logic to the Transmit logic."]
set options(check_hstdm_timing,-rx2umr)                 [add_option "-rx2umr		plural	{1}			<help>	 -- Report any paths from the Receive logic to the UMR logic."]
set options(check_hstdm_timing,-umr2rx)                 [add_option "-umr2rx		plural	{1}			<help>	 -- Report any paths from the UMR logic to the Receive logic."]
set options(check_hstdm_timing,-write_fdc)              [add_option "-write_fdc               plural  {1}                     <help>   -- Write out FDC files with DPO constraints for paths missing a timing exception."]
set options(check_hstdm_timing,-default_delay)          [add_option "-default_delay     reqs    {-write_fdc}    <value> <float>  <help>   -- DPO delay value to use when writing missing constraints, default is 8"]
if {$prod eq "protocompiler"} {
  set options(check_hstdm_timing,-write_xdc)            [add_option "-write_xdc         reqs    {-write_fdc}    <value> <strg>   <help>   -- Add missing DPOs to the given XDC file."]
}
############################################
####       report_timing      ##############

set options(report_timing,-to)                        [add_option "-to			excl	{-rise_to,-fall_to}	<value>	<list_c>	<help>	 -- Report paths to the specified port, register, register pin, or clock."]
set options(report_timing,-rise_to)                   [add_option "-rise_to		excl	{-to,-fall_to}		<value>	<list_c>	<help>	 -- Report paths to the rising edge of the specified clock."]
set options(report_timing,-fall_to)                   [add_option "-fall_to		excl	{-rise_to,-to}		<value>	<list_c>	<help>	 -- Report paths to the falling edge of the specified  clock."]
set options(report_timing,-from)                      [add_option "-fr.*		excl	{-rise_from,-fall_from}	<value>	<list_c>	<help>	 -- Report paths from the specified port, register, register pin, or clock."]
set options(report_timing,-rise_from)                 [add_option "-rise_f.*		excl	{-from,-fall_from}	<value>	<list_c>	<help>	 -- Report paths from the rising edge of the specified clock."]
set options(report_timing,-fall_from)                 [add_option "-fall_f.*		excl	{-rise_from,-from}	<value>	<list_c>	<help>	 -- Report paths from the falling edge of the specified clock."]
set options(report_timing,-through)                   [add_option "-th.*		plural	{1}			<value>	<list_c>	<help>	 -- Report paths through the specified net or pin."]
#set options(report_timing,-delay_type)                [add_option "-del.*		plural	{1}			<value>	max		<help>	max"]
set options(report_timing,-max_paths)                 [add_option "-m.*			plural	{1}			<value>	<int>		<help>	 -- Maximum paths to report for a path group."]
set options(report_timing,-hold)                      [add_option "-hold		plural	{1}			<help>	-- Pass -hold option to Vivado."]
set options(report_timing,-slack_margin)              [add_option "-slack_m.*		excl	{-xdc_par}		<value>	<float>		<help>	 -- Reports paths within the specified margin of the worst slack."]
set options(report_timing,-nworst)                    [add_option "-nw.*		plural	{1}			<value>	<int>		<help>	 -- In -xdc_par mode, report <int> worst paths per end point. Ignored otherwise."]
if {$prod eq "legacy"} {
  set options(report_timing,-xdc_par)                 [add_option "-xdc_p.*		plural	{1}			<help>	-- Run the report_timing command in Vivado with the specified options."]
  set options(report_timing,-hstdm_par)               [add_option "-hstdm_par$		plural	{1}			<help>	-- Run HSTDM QoR report in Vivado."]
  set options(report_timing,-hstdm_par_cons)          [add_option "-hstdm_par_.*	plural	{1}			<help>	-- Run HSTDM missing constraints check in Vivado."]
  set options(report_timing,-time_view)               [add_option "-ti.*		excl	{-xdc_par,-file}	<help>	-- Create a custom timing report for viewing in the Timing Report View GUI."]
  set options(report_timing,-file)                    [add_option "-fi.*$		plural	{1}			<value>	<strg>		<help>	-- Redirect report to specified file."]
} else {
  set options(report_timing,-par_dir)                 [add_option "-par.*		plural	{1}			<value>	<strg>		<help>	-- Use the specified P&R results directory."]
  set options(report_timing,-hstdm_par)               [add_option "-hstdm_par$		reqs	{-par_dir}		<help>	-- Run HSTDM QoR report in Vivado.  Requires -par_dir option."]
  set options(report_timing,-hstdm_par_cons)          [add_option "-hstdm_par_.*	reqs	{-par_dir}		<help>	-- Run HSTDM missing constraints check in Vivado.  Requires -par_dir option."]
#  set options(report_timing,-xdc_par)                 [add_option "-xdc_p.*		reqs	{-par_dir}		<help>	-- Run the report_timing command in Vivado with the specified options.  Requires -par_dir option."]
#  set options(report_timing,-par_dir)                 [add_option "-par.*		plural	{1}			<value>	<strg>"]
#  set options(report_timing,-hstdm_par)               [add_option "-hstdm_par$		reqs	{-par_dir}"]
#  set options(report_timing,-hstdm_par_cons)          [add_option "-hstdm_par_.*	reqs	{-par_dir}"]
  set options(report_timing,-xdc_par)                 [add_option "-xdc_p.*		reqs	{-par_dir}"]
  set options(report_timing,-file)                    [add_option "-fi.*$		plural	{1}			<value>	<strg>"]
  set options(report_timing,-ctd_file)                [add_option "-ct.*$		plural	{1}			<value>	<strg>"]
  set options(report_timing,-xdc_file)                [add_option "-xdc_f.*$		reqs	{-par_dir}		<value>	<strg>"]
  set options(report_timing,-gui)                     [add_option "-gui			plural	{1}"]
  set options(report_timing,-time_view)               [add_option "-time_view		reqs	{-gui,-xdc_par}"]
}

#set options(report_timing,-path_type)                 [add_option "-pat.*		default	full"]
set options(report_timing,-write_ctd)                 [add_option "-w.*                 excl    {-xdc_par}"]
set options(report_timing,-quiet)                     [add_option "-q.*			plural	{1}"]

set options(report_timing,-delay_type)                [add_option "-del.*		ignore"]
set options(report_timing,-path_type)                 [add_option "-pat.*		ignore"]
set options(report_timing,-input_pins)                [add_option "-i.*			ignore"]
set options(report_timing,-nets)                      [add_option "-ne.*		ignore"]
set options(report_timing,-transition_time)           [add_option "-tran.*		ignore"]
set options(report_timing,-crosstalk_delta)           [add_option "-cr.*		ignore"]
set options(report_timing,-capacitance)               [add_option "-ca.*		ignore"]
set options(report_timing,-effective_capacitance)     [add_option "-ef.*		ignore"]
set options(report_timing,-attributes)                [add_option "-a.*			ignore"]
set options(report_timing,-physical)                  [add_option "-ph.*		ignore"]
set options(report_timing,-enable_preset_clear_arcs)  [add_option "-en.*		ignore"]
set options(report_timing,-nosplit)                   [add_option "-nos.*		ignore"]
set options(report_timing,-sort_by)                   [add_option "-so.*		ignore"]

set options(report_timing,-rise_through)              [add_option "-rise_th.*		unsup"]
set options(report_timing,-fall_through)              [add_option "-fall_th.*		unsup"]
set options(report_timing,-slack_greater_than)        [add_option "-slack_g.*		unsup_msg	Use -slack_margin <float>"]
set options(report_timing,-slack_lesser_than)         [add_option "-slack_l.*		unsup_msg	Use -slack_margin <float>"]
set options(report_timing,-lesser_path)               [add_option "-le.*		unsup"]
set options(report_timing,-greater_path)              [add_option "-gre.*		unsup"]
set options(report_timing,-loops)                     [add_option "-lo.*		unsup"]
set options(report_timing,-group)                     [add_option "-gro.*		unsup"]
set options(report_timing,-trace_latch_borrow)        [add_option "-trac.*		unsup"]
set options(report_timing,-derate)                    [add_option "-der.*		unsup"]
set options(report_timing,-normalized_slack)          [add_option "-nor.*		unsup"]
set options(report_timing,-scenarios)                 [add_option "-sc.*		unsup"]
set options(report_timing,-temperature)               [add_option "-te.*		unsup"]
set options(report_timing,-voltage)                   [add_option "-v.*			unsup"]
set options(report_timing,-unique_pins)               [add_option "-u.*			unsup"]
set options(report_timing,-start_end_pair)            [add_option "-st.*		unsup"]

set exampleuses(report_timing)                        { {"Report timing for the design from and to the rising edge of the clock named \"clk\"" \
                                                         "-rise_from {c:clk} -rise_to {c:clk}" }
                                                      }


############################################
####       all_registers      ##############
set options(all_registers,-no_hierarchy)              [add_option "-n.*			plural		{1}	<help>"]
set options(all_registers,-clock)                     [add_option "-clock		plural		{1}	<value>	<strg>	<help>"]
set options(all_registers,-rise_clock)                [add_option "-r.*			plural		{1}	<value>	<strg>	<help>"]
set options(all_registers,-fall_clock)                [add_option "-f.*			plural		{1}	<value>	<strg>	<help>"]
set options(all_registers,-cells)                     [add_option "-ce.*		plural		{1}	<help>"]
set options(all_registers,-data_pins)                 [add_option "-d.*			plural		{1}	<help>"]
set options(all_registers,-clock_pins)                [add_option "-clock_.*		plural		{1}	<help>"]
set options(all_registers,-output_pins)               [add_option "-o.*			plural		{1}	<help>"]

set options(all_registers,-slave_clock_pins)          [add_option "-s.*			ignore"]
set options(all_registers,-inverted_output)           [add_option "-i.*			ignore"]
set options(all_registers,-level_sensitive)           [add_option "-l.*			ignore"]
set options(all_registers,-edge_triggered)            [add_option "-e.*			ignore"]
set options(all_registers,-master_slave)              [add_option "-m.*			ignore"]

############################################
####       all_outputs      ##############
set options(all_outputs,-clock)                       [add_option "-c.*		unsup"]
set options(all_outputs,-edge_triggered)              [add_option "-e.*		ignore"]
set options(all_outputs,-level_sensitive)             [add_option "-l.*		ignore"]

############################################
####       all_inputs      ##############
set options(all_inputs,-clock)                        [add_option "-c.*		unsup"]
set options(all_inputs,-edge_triggered)               [add_option "-e.*		ignore"]
set options(all_inputs,-level_sensitive)              [add_option "-l.*		ignore"]

############################################
####       get_ports      ##############
set options(get_ports,-hierarchical)                  [add_option "-hier.*		excl	{-of_objects}"]
set options(get_ports,-nocase)                        [add_option "-n.*			plural	{1}		<help>"]
set options(get_ports,-regexp)                        [add_option "-re.*		excl	{-exact}	<help>"]
set options(get_ports,-exact)                         [add_option "-e.*			excl	{-regexp}	<help>"]
set options(get_ports,-filter)                        [add_option "-f.*			plural	{1}			<value>	<list>		<help>"]
set options(get_ports,-of_objects)                    [add_option "-o.*			excl	{-hierarchical}		<value>	<list_c>	<help>"]
set options(get_ports,<pattern>)                      [add_option "^\[^-\].*		excl	{-of_objects}	<help>"]
set options(get_ports,-quiet)                         [add_option "-q.*			ignore"]

############################################
####       get_pins      ##############
set options(get_pins,-hierarchical)                  [add_option "-hier.*		excl	{-of_objects}	<help>"]
set options(get_pins,-nocase)                        [add_option "-n.*			plural	{1}		<help>"]
set options(get_pins,-regexp)                        [add_option "-re.*			excl	{-exact}	<help>"]
set options(get_pins,-exact)                         [add_option "-e.*			excl	{-regexp}	<help>"]
set options(get_pins,-filter)                        [add_option "-f.*			plural	{1}			<value>	<list>		<help>"]
set options(get_pins,-of_objects)                    [add_option "-o.*			excl	{-hierarchical}		<value>	<list_c>	<help>"]
set options(get_pins,<pattern>)                      [add_option "^\[^-\].*		excl	{-of_objects}	<help>"]
set options(get_pins,-leaf)                          [add_option "-l.*			reqs    {-of_objects}	<help>"]
set options(get_pins,-quiet)                         [add_option "-q.*			ignore"]

############################################
####       get_cells      ##############
set options(get_cells,-hierarchical)                  [add_option "-hier.*		excl	{-of_objects}		<help>"]
set options(get_cells,-nocase)                        [add_option "-n.*			plural	{1}			<help>"]
set options(get_cells,-regexp)                        [add_option "-re.*		excl	{-exact}		<help>"]
set options(get_cells,-exact)                         [add_option "-e.*			excl	{-regexp}		<help>"]
set options(get_cells,-filter)                        [add_option "-f.*			plural	{1}			<value>	<list>		<help>"]
set options(get_cells,-of_objects)                    [add_option "-o.*			excl	{-hierarchical}		<value>	<list_c>	<help>"]
set options(get_cells,<pattern>)                      [add_option "^\[^-\].*		excl	{-of_objects}		<help>"]
set options(get_cells,-all)                           [add_option "-a.*			ignore"]
set options(get_cells,-quiet)                         [add_option "-q.*			ignore"]
set options(get_cells,-rtl)                           [add_option "-rt.*		unsup"]
set options(get_cells,-select)                        [add_option "-s.*			plural	{1}			<help>"]

############################################
####       get_nets      ##############
set options(get_nets,-hierarchical)                  [add_option "-hier.*		excl	{-of_objects}		<help>"]
set options(get_nets,-nocase)                        [add_option "-n.*			plural	{1}			<help>"]
set options(get_nets,-regexp)                        [add_option "-re.*			excl	{-exact}		<help>"]
set options(get_nets,-exact)                         [add_option "-e.*			excl	{-regexp}		<help>"]
set options(get_nets,-filter)                        [add_option "-f.*			plural	{1}			<value>	<list>		<help>"]
set options(get_nets,-of_objects)                    [add_option "-o.*			excl	{-hierarchical}		<value>	<list_c>	<help>"]
set options(get_nets,<pattern>)                      [add_option "^\[^-\].*		excl	{-of_objects}		<help>"]
set options(get_nets,-all)                           [add_option "-a.*			ignore"]
set options(get_nets,-quiet)                         [add_option "-q.*			ignore"]
set options(get_nets,-rtl)                           [add_option "-rt.*			unsup"]
set options(get_nets,-top_net_of_hierarchical_group) [add_option "-t.*			unsup"]
set options(get_nets,-segments)                      [add_option "-s.*			unsup"]

############################################
####       get_clocks      ##############
set options(get_clocks,-regexp)                      [add_option "-r.*			plural  {1}"]
set options(get_clocks,-nocase)                      [add_option "-n.*			plural	{1}"]
set options(get_clocks,-filter)                      [add_option "-f.*			unsup"]
set options(get_clocks,-quiet)                       [add_option "-q.*			ignore"]
set options(get_clocks,-of_objects)                  [add_option "-o.*			plural	{1}			<value>	<list_c>	<help>"]
set options(get_clocks,-include_generated_clocks)    [add_option "-i.*			unsup"]
set options(get_clocks,<pattern>)                    [add_option "^\[^-\].*		excl	{-of_objects}		<help>"]

####  Returns a regexp to use for seraching $args for options that require a value
proc get_opts_w_val_exp {cmd} {
  variable options
  set exp "\(" 
  set opts [array names options "${cmd},*"]
  foreach x $opts {
    if {[lindex $options($x) 3] eq "<value>"} {
      set exp "${exp}[lindex $options($x) 0]|"
    }
  }
  regsub {\|$} $exp "" exp 
  regsub {$} $exp "\)+" exp
  return $exp
}

####  Returns a regexp to use for seraching $args for options without values
proc get_opts_no_val_exp {cmd} {
  variable options
  set exp "\(" 
  set opts [array names options "${cmd},*"]
  foreach x $opts {
    if {[lindex $options($x) 3] ne "<value>" && ![regexp {(ignore|unsup.*)+} [lindex $options($x) 1]] } {
      set exp "${exp}[lindex $options($x) 0]|"
    }
  }
  regsub {\|$} $exp "" exp 
  regsub {$} $exp "\)+" exp
  return $exp
}

proc get_exp {cmd opt} {
  variable options
  if {[catch {set val [lindex $options($cmd,$opt) 0]}] || [lindex $options($cmd,$opt) 0] eq ""} {
    return 0
  } else {
   return $val
  }
}

proc get_type {cmd opt {check_off 0}} {
  variable options
  if {[catch {set val [lindex $options($cmd,$opt) [expr $check_off + 1]]}] || [lindex $options($cmd,$opt) 1] eq ""} {
    return 0
  } else {
    return $val
  }
}

proc get_type_val {cmd opt {check_off 0}} {
  variable options
  if {[catch {set val [lindex $options($cmd,$opt) [expr $check_off + 2]]}] || [lindex $options($cmd,$opt) 2] eq ""} {
    return 0
  } else {
    regsub -all {\{|\}} $val "" val
    return [split $val ,]
  }
}

proc get_unsup_msg {cmd opt} {
  variable options
  if {[catch {set val [lindex $options($cmd,$opt) 1]}] || [lindex $options($cmd,$opt) 1] eq ""} {
    return 0
  } elseif {$val ne "unsup_msg"} {
    return 0
  } else {
    set msg [lrange $options($cmd,$opt) 2 end]
    return [join $msg]
  }
}

proc get_help_val {cmd opt} {
  variable options
  if {[catch {set help_inx [lsearch -exact $options($cmd,$opt) "<help>"]}] || $help_inx == -1} {
    return 0
  } else {
    set i [incr help_inx]
    return [lrange $options($cmd,$opt) $help_inx end]
  }
}

proc get_opt_val {cmd opt} {
  variable options
  set i [lsearch -exact $options($cmd,$opt) "<value>"]
  if {$i == -1} {
    return 0
  }
  if {[catch {set val [lindex $options($cmd,$opt) [expr $i + 1]]}] || [lindex $options($cmd,$opt) [expr $i + 1]] eq "" || [lindex $options($cmd,$opt) $i] eq "<help>"} {
    return 0
  } else {
    incr i 2
    while {[lindex $options($cmd,$opt) $i] ne "" && [lindex $options($cmd,$opt) $i] ne "<help>"} {
      set val [linsert $val end [lindex $options($cmd,$opt) $i]] 
      incr i
    }
    return $val
  }
}

####  Check if item is a valid option for the command
####  Return:
####  0:  Undefined or invalid value
####  <full_option_name>:  Full name of the option
proc check_opt {cmd item {not_opt 0}} {
  variable options
  
  set opts [array names options "${cmd},*"]
  foreach x $opts {
    regsub ${cmd}, $x "" x
    if {($not_opt && [regexp -- [get_exp $cmd $x] $item]) || \
        ([regexp -- [get_exp $cmd $x] $item] && [regexp -- ${item}.* $x])} {
      return $x
    }
  }
  return 0
}

####  Check if item_l is/has -help
####  Return:
####  0:  No Help
####  1:  Print Help
proc check_opt_help {cmd item_l} {
  variable options
  variable no_usage

  set opts [array names options "${cmd},*"]
  set opts [lsort $opts]
  set opt_inx_l [lsearch -regexp $item_l {^-help}]
  if {$opt_inx_l == -1} {
    return 0
  }
  if {!$no_usage} {
    puts "Usage: $cmd"
  }
  foreach x $opts {
    regsub ${cmd}, $x "" o
    if {![regexp {(ignore|unsup.*)+} [get_type $cmd $o]]} {
      set val [get_help_val $cmd $o]
      if {$val ne "0"} {
        set type [get_opt_val $cmd $o]
        regsub {0} $type "" type
        puts " [format "%-25s %-.120s" "$o $type" $val]" ;#"
      }
    } 
  }
  variable exampleuses
  if { ![catch {llength $exampleuses($cmd)}] } {
	variable prod
	set rptcmd $cmd
    if {$prod eq "protocompiler"} {
      if { ${rptcmd} == "report_timing" } { set rptcmd "report timing -generate" }
    }
    puts "Examples:"
    set cnt 1
	# this format matches examples in CPP
    foreach e $exampleuses($cmd) {
      set desc [lindex $e 0]
      set exam [lindex $e 1]
      puts " $cnt. $desc:"
      puts "     $rptcmd $exam"
	  incr cnt
    }
  }
  return 1
}
####  Check if item_l are all valid options for the cmd
####  Return:
####  0:  There is an invalid or ambiguous option
####  1:  All options in item_l are valid for cmd
proc check_opt_all {cmd item_l} {
  variable options

  set opts [array names options "${cmd},*"]
  set opt_inx_l [lsearch -all -regexp $item_l {^-}]
  foreach i $opt_inx_l {
    set good 0
    set item [lindex $item_l $i]
    foreach x $opts {
      regsub ${cmd}, $x "" x
      if {[regexp -- [get_exp $cmd $x] $item] && [regexp -- ${item}.* $x]} {
        set good 1
      }
    }
    if {!$good} {
#      puts "@E: :Error, $cmd, invalid or ambiguous option: $item"
      puts "Error, $cmd, invalid or ambiguous option: $item"
      return 0
    }
  }
  return 1
}

####  Check if item_l has any (valid) options that will be defaulted
####  to a specific value regardless of the given value
proc check_opt_default {cmd item_l} {
  variable options

  set opts [array names options "${cmd},*"]
  set opt_inx_l [lsearch -all -regexp $item_l {^-}]
  foreach i $opt_inx_l {
    set item [lindex $item_l $i]
    foreach o $opts {
      regsub ${cmd}, $o "" o
      if {[check_opt_is $cmd $o $item] && [get_type $cmd $o] eq "default"} {
        puts "@N: :$cmd, option $o defaults to \"[get_opt_val $cmd $o]\""
      }
    }
  }
}


####  Check if item_l has any (valid) options that will be ignored
proc check_opt_ignore {cmd item_l} {
  variable options

  set opts [array names options "${cmd},*"]
  set opt_inx_l [lsearch -all -regexp $item_l {^-}]
  foreach i $opt_inx_l {
    set item [lindex $item_l $i]
    foreach o $opts {
      regsub ${cmd}, $o "" o
      if {[check_opt_is $cmd $o $item] && [get_type $cmd $o] eq "ignore"} {
        puts "@W: :$cmd, option $o will be ignored in Analyst"
      }
    }
  }
}

####  Check if item_l has any (valid) options that are not supported
proc check_opt_unsup {cmd item_l} {
  variable options

  set val 0
  set opts [array names options "${cmd},*"]
  set opt_inx_l [lsearch -all -regexp $item_l {^-}]
  foreach i $opt_inx_l {
    set item [lindex $item_l $i]
    foreach o $opts {
      regsub ${cmd}, $o "" o
      if {[check_opt_is $cmd $o $item]} { 
        if {[get_type $cmd $o] eq "unsup"} {
#          puts "@E: :$cmd, option $o is not supported in Analyst"
          puts "Error: $cmd, option $o is not supported in Analyst"
          set val 1
        } elseif {[get_type $cmd $o] eq "unsup_msg"} {
#          puts "@E: :$cmd, option $o is not supported in Analyst.  [get_unsup_msg $cmd $o]"
          puts "Error: $cmd, option $o is not supported in Analyst.  [get_unsup_msg $cmd $o]"
          set val 1
        }
      }
    }
  }
  return $val
}


####  Check if item_l index is a value NOT preceeded by an option that 
####  requires a value for the given command
####  1:  Optionless value
####  0:  Value is for an option
#### -1:  The indexed item is an option
proc check_val_no_opt {cmd item_l inx} {
  set item  [lindex $item_l $inx]
  if {[regexp -- {^-} $item]} {
    return -1
  }
  set item1 [lindex $item_l $inx-1]
  set item1 [check_opt $cmd $item1 [regexp {^[^-]} $item1]]
  if {(![regexp -- {^-} $item1] || ([regexp -- {^-} $item1] && [get_opt_val $cmd $item1] eq "0")) && \
       ![regexp -- {^-} $item]} {
    return 1
  } else {
    return 0
  }
}


####  Check if item_l has any (valid) options that are mutually exclusive
proc check_opt_excl {cmd item_l} {
  variable options

  set err_l {}
  set val 0
  set opts [array names options "${cmd},*"]
  set l [llength $item_l]
  for {set i 0} {$i<$l} {incr i} {
    set not_opt [check_val_no_opt $cmd $item_l $i]
    if {$not_opt == 0} {
      continue
    }
    if {$not_opt == -1} {
      set not_opt 0
    }
    set item [lindex $item_l $i]
    foreach o $opts {
      regsub ${cmd}, $o "" o
      set check [get_type $cmd $o]
      if {[check_opt_is $cmd $o $item $not_opt] && ($check eq "excl" || [get_type $cmd $o 2] eq "excl")} {
        if {$check eq "excl"} {
          set xopts [get_type_val $cmd $o]
        } else {
          set xopts [get_type_val $cmd $o 2]
        }
        foreach x $xopts {
          if {[check_opt_l $cmd $x $item_l]} {
            if {[lsearch -exact $err_l "$x $o"] == -1} {
              puts "@E: :$cmd, option $o and option $x are mutually exclusive"
              set err_l [linsert $err_l end "$o $x"]
              set val 1
            }
          }
        }
      }
    }
  }
  return $val
}

####  Check if item_l has any (valid) options that require another option to also be specified
proc check_opt_reqs {cmd item_l} {
  variable options

  set err_l {}
  set val 0
  set opts [array names options "${cmd},*"]
  set l [llength $item_l]
  for {set i 0} {$i<$l} {incr i} {
    set not_opt [check_val_no_opt $cmd $item_l $i]
    if {$not_opt == 0} {
      continue
    }
    if {$not_opt == -1} {
      set not_opt 0
    }
    set item [lindex $item_l $i]
    foreach o $opts {
      regsub ${cmd}, $o "" o
      set check [get_type $cmd $o]
      if {[check_opt_is $cmd $o $item $not_opt] && ($check eq "reqs" || [get_type $cmd $o 2] eq "reqs")} {
        if {$check eq "reqs"} {
          set xopts [get_type_val $cmd $o]
        } else {
          set xopts [get_type_val $cmd $o 2]
        }
        foreach x $xopts {
          if {![check_opt_l $cmd $x $item_l]} {
            if {[lsearch -exact $err_l "$x $o"] == -1} {
              puts "@E: :$cmd, option $o requires option $x to also be specified"
              set err_l [linsert $err_l end "$o $x"]
              set val 1
            }
          }
        }
      }
    }
  }
  return $val
}
####  Check if item is the given valid command & option.
####  This is the check that allows specifying abbreviated options
####  on the command line.  E.g., "check_opt_is all_fanin -only_cells $opt"
####  Var not_opt means check only if it is a valid value.
####  Return:
####  0:  Undefined or invalid value
####  1:  Valid value for cmd & option
proc check_opt_is {cmd opt item {not_opt 0}} {
  variable options

  if {[catch {set foo $options($cmd,$opt)}]} {
    return 0
  }
  if {($not_opt && [regexp -- [get_exp $cmd $opt] $item]) || \
      ([regexp -- [get_exp $cmd $opt] $item] && [regexp -- ${item}.* $opt])} {
    return 1
  } else {
    return 0
  }
}

####  Check if item_l contains the given valid command & option-expression
####  Return:
####  0:  Undefined or invalid value
####  1:  Valid value for cmd & option
proc check_opt_l {cmd opt item_l} {
  variable options

  if {[catch {set foo $options($cmd,$opt)}]} {
    return 0
  }
  foreach x $item_l {
    if {[regexp -- [get_exp $cmd $opt] $x] && [regexp -- ${x}.* $opt]} {
      return 1
    }
  }
  return 0
}

####  Check if item is a valid value for the given command & option-expression
####  If checking item for <list>, <list_c>, or <col>, item should come in as a
####  list.  E.g., "check_opt_val all_fanout {-fr.*} [split [join [lindex $args <index>]]]"
####  Return:
####  0:  Undefined or invalid value
####  1:  Valid value for cmd & option
####  2:  Valid collection value for cmd & option
####
proc check_opt_val {cmd opt item} {
#  variable options_val
  variable options

  if {[catch {set val [get_opt_val $cmd $opt]}]} {
    return 0
  }
  if {$val eq "<list>"} {
    if {[lsearch -regexp $item {^s:[0-9]+$}] != -1 || [llength $item] == 0 || [lsearch -regexp $item {^\-}] != -1} {
      return 0
    } else {
      return 1
    }
  } 
  if {$val eq "<list_c>" || $val eq "<col>"} {
    if {[lsearch -regexp $item {^s:[0-9]+$}] != -1} {
      return 2
    } elseif {$val eq "<list_c>" && [llength $item] != 0 && $item ne "{}" && [lsearch -regexp $item {^\-}] == -1} {
      return 1
    } else {
      return 0
    }
  }
  if {$val eq "<int>"} {
    if {[regexp {^[0-9]+$} $item]} {
      return 1
    } else {
      return 0
    }
  }
  if {$val eq "<float>"} {
    if {[regexp {^[0-9\.]+$} $item]} {
      return 1
    } else {
      return 0
    }
  }
  if {$val eq "<strg>"} {
    if {![regexp {^s:} $item] && ![regexp {^\-} $item] && $item ne ""} {
      return 1
    } else {
      return 0
    }
  }
#### Last option, check a list of explicit values  ####
  foreach x $val {
    if {$item eq $x} {
      return 1
    }
  }
  return 0
}

proc g_impl_dir {} {
  variable prod
  if {$prod eq "protocompiler"} {
    return [database query -state_dir]
  } else {
    return [impl -dir]
  }
}

proc g_opt {opt} {
  variable prod
  if {$prod eq "protocompiler"} {
    regsub {^-} $opt "" opt
    return [option get $opt]
  } else {
    return [get_option $opt]
  }
}

proc s_opt {opt val} {
  variable prod
  if {$prod eq "protocompiler"} {
    regsub {^-} $opt "" opt
    option set -hidden $opt $val
  } else {
    set_option $opt $val
  }
}

#### Populate a directory that will be used as the timing correlation directory
####
set top_proto ""
set slta 0
set back_anno "default"
set ctd_ba ""
set force_ba 0
#############################################################################
##### proto_correlate   ####
#############################################################################
proc proto_correlate {args} {
  variable top_proto
  variable slta
  variable back_anno
  variable ctd_ba
  variable check_hstdm
  variable ignore_sys_clk
  variable regression_mode
  variable supp_err
  variable force_ba

  set opts_w_val_exp_s [get_opts_w_val_exp proto_correlate]
  set opts_no_val_exp_s [get_opts_no_val_exp proto_correlate]

  if {[check_opt_help proto_correlate $args]} {
    return 0
  }
#### Check that all in argument list are valid options and combinations
  if {![check_opt_all proto_correlate $args]} {
    return 1
  }
#  check_opt_default proto_correlate $args
#  check_opt_ignore proto_correlate $args
  if {[check_opt_unsup proto_correlate $args] || [check_opt_excl proto_correlate $args]} {
    puts "Error:  command ignored"
    return 2
  }
#### Check if a specified option requires another option to also be specified
  if {[check_opt_reqs proto_correlate $args]} {
    puts "Error, command ignored"
    return 2
  }
  set start_dir [pwd]
####  Need to be in a map or system_generate state
  set state [database query_state -run_type]
  if {$state ne "map" && $state ne "system_generate"} {
    puts "ERROR:  You must be in a \"map\" or \"system_generate\" state to run Timing Correlation"
    return 2
  }
  set state_name "timing_correlation_[database query -name]_[database get_state]"
  goto_work_dir
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set pr_dir ""
  set result_gold ""
  set xdc_mode 0
  set scf_mode 0
  set sdc_verif 0
  set slta 0
  set back_anno "default"
  set ctd_ba ""
  foreach x $opt_inx_l {
#### -pr_dir option
    if {[check_opt_is proto_correlate {-pr_dir} [lindex $args $x]]} {
      set check [check_opt_val proto_correlate {-pr_dir} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set pr_dir [split [join [lindex $args [expr $x + 1]]]]
        if {[regexp {^[^\/]+} $pr_dir]} {
          set pr_dir ${start_dir}/$pr_dir
        }
#        set xdc_mode 1
      } else {
        puts "@E: :Error, proto_correlate, must be: -pr_dir <strg>"
        cd $start_dir
        return 2
      }
    }
#### -impl_name option
    if {[check_opt_is proto_correlate {-impl_name} [lindex $args $x]]} {
      set check [check_opt_val proto_correlate {-impl_name} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set impl_name [split [join [lindex $args [expr $x + 1]]]]
      } else {
        puts "@E: :Error, proto_correlate, must be: -impl_name <strg>"
        cd $start_dir
        return 2
      }
    }
#### -impl_result option
    if {[check_opt_is proto_correlate {-impl_result} [lindex $args $x]]} {
      set check [check_opt_val proto_correlate {-impl_result} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set impl_result [split [join [lindex $args [expr $x + 1]]]]
      } else {
        puts "@E: :Error, proto_correlate, must be: -impl_result <strg>"
        cd $start_dir
        return 2
      }
    }
#### -result_gold option
    if {[check_opt_is proto_correlate {-result_gold} [lindex $args $x]]} {
      set check [check_opt_val proto_correlate {-result_gold} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set result_gold [split [join [lindex $args [expr $x + 1]]]]
        if {[regexp {^[^\/]+} $result_gold]} {
          set result_gold ${start_dir}/$result_gold
        }
        set sdc_verif 1
      } else {
        puts "@E: :Error, proto_correlate, must be: -result_gold <strg>"
        cd $start_dir
        return 2
      }
    }
  }
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  set sdc_flag 0
  set regression_mode 0
  set gui 0
  foreach x $opt_inx_l {
#### -xdc_mode option
    if {[check_opt_is proto_correlate {-xdc_mode} [lindex $args $x]]} {
      set xdc_mode 1
    }
#### -scf_mode option
    if {[check_opt_is proto_correlate {-scf_mode} [lindex $args $x]]} {
      set scf_mode 1
    }
#### -sdc_verif option
    if {[check_opt_is proto_correlate {-sdc_verif} [lindex $args $x]]} {
      set sdc_verif 1
      set sdc_flag 1
    }
#### -regress option
    if {[check_opt_is proto_correlate {-regress} [lindex $args $x]]} {
      set regression_mode 1
    }
#### -back_anno option
    if {[check_opt_is proto_correlate {-back_anno} [lindex $args $x]] || $force_ba} {
      set ctd_ba "_BA"
      if {$state eq "map"} {
        set back_anno "ba"
      } else {
        set back_anno "slta"
      }
    }
#### -gui option
    if {[check_opt_is proto_correlate {-gui} [lindex $args $x]]} {
      set gui 1
    }
  }
  if {$result_gold eq "" && !$sdc_verif && !$xdc_mode && !$scf_mode} {
    puts "@E: :Error, proto_correlate, must specify at least one of -xdc_mode, -scf_mode, -sdc_verif, or -result_gold"
    cd $start_dir
    return 2
  }
  if {!$gui} {
    file mkdir $state_name
    cd $state_name
  } else {
    file mkdir [file dirname $impl_result]
    cd [file dirname $impl_result]
  }
  file mkdir synlog
  set sdc_corr [expr $sdc_verif && $xdc_mode]
  if {$state eq "system_generate"} {
    if {$xdc_mode || $scf_mode} {
      puts "@E: :Error, correlation with Place and Route is only valid from the \"map\" state"
      cd $start_dir
      return 2
    }
    set slta 1
    if {!$gui} {
      export_file *.srm
    } else {
      set top [lindex [file split $impl_result] end]
      regsub {\.[a-zA-Z]+$} $top "" top
      export file system_generate.log
      file rename -force system_generate.log ${top}.srm
    }
  } else {
#  export_file *.srm
    if {![export_result]} {
      cd $start_dir
      return 2
    }
  }
  if {!$gui && [catch {glob -directory [pwd] *.srm} impl_result]} {
    puts "ERROR:  Can't find synthesis results"
    cd $start_dir
    return 2
  }
  set top [lindex [file split $impl_result] end]
#  set impl_result [pwd]/$top
  regsub {\.[a-zA-Z]+$} $top "" top

#### Setup needed files   ####
  set top_proto $top
  if {!$check_hstdm} {
    if {[catch {glob -directory . ${top}${ctd_ba}_ctd.txt} CTD] || [file mtime ${top}.srm] > [file mtime ${top}${ctd_ba}_ctd.txt]} {
      s_opt reporting_filename [pwd]/${top}${ctd_ba}.ta
      report timing -generate -mode $back_anno -write_ctd -out $top
      s_opt reporting_filename ""
#      export report ${top}_ctd.txt.rpt			;#### still needed
#      file rename -force ${top}_ctd.txt.rpt ${top}_ctd.txt
    }
  }
  if {$state eq "map"} {
    export report map.srr
    file rename -force map.srr synlog/${top}_fpga_mapper.srr
  } else {
    export report time_budget.log
    file rename -force time_budget.log synlog/${top}_fpga_mapper.srr
  }
  if {!$gui} {
    set impl_name [pwd]/tim.prj|$state_name
  }
#### Build the command   ####
  set  f [info frame -1]
  set  corr_cmd [dict get $f cmd]
  set inx [lsearch -regexp $corr_cmd {^\-pr}]
  if {$inx != -1} {
    set corr_cmd [lreplace $corr_cmd $inx [expr $inx + 1]]
  }
#  regsub {\-pr[^\s]*\s+[^\s\-$]+} $corr_cmd "" corr_cmd
#  regsub {\-resu[^\s]*\s+[^\s\-$]+} $corr_cmd "" corr_cmd
  regsub {\s+\-back[^\s]*} $corr_cmd "" corr_cmd
  regsub {\s+\-gui[^\s]*} $corr_cmd "" corr_cmd
  regsub {\s+\-regress[^\s]*} $corr_cmd "" corr_cmd
#puts "CMD: $corr_cmd"
  if {$xdc_mode} {
    if {$sdc_verif} {
#### synth --> par correlate
      set ignore_sys_clk 1
      regsub {proto_correlate} $corr_cmd "corr_synth_gui" corr_cmd
    } else {
#### Xilinx par --> synth correlate; always -effort high
      regsub {\-effo[^\s]*\s+[^\s\-$]+} $corr_cmd "" corr_cmd
      regsub {proto_correlate} $corr_cmd "pro_ise_corr" corr_cmd
    }
    set cmd "$corr_cmd -impl_name $impl_name -impl_result $impl_result -pr_dir $pr_dir"
  } elseif {$scf_mode} {
#### Quartus par --> synth correlate; always -effort high
    regsub {\-effo[^\s]*\s+[^\s\-$]+} $corr_cmd "" corr_cmd
    regsub {proto_correlate} $corr_cmd "pro_qii_corr" corr_cmd
    regsub {\s+\-scf[^\s]*} $corr_cmd "" corr_cmd
    regsub {\s+\-default_st[^\s]*} $corr_cmd "" corr_cmd
    set cmd "$corr_cmd -impl_name $impl_name -impl_result $impl_result -pr_dir $pr_dir"
  } else {
#### gold synth --> synth correlate
    regsub {\s+\-sd[^\s]*} $corr_cmd "" corr_cmd
    regsub {$} $corr_cmd " -sdc_verif" corr_cmd
    regsub {\-effo[^\s]*\s+[^\s\-$]+} $corr_cmd "" corr_cmd
    regsub {$} $corr_cmd " -effort high" corr_cmd
    if {![regexp -nocase {STRATIX10|ARRIA10|CYCLONE10|BASECAMP|HAPS-AL} [g_opt technology]] || $check_hstdm} {
      regsub {proto_correlate} $corr_cmd "corr_synth_gui" corr_cmd
      if {$result_gold eq ""} {
        regsub {\.[a-zA-Z]+$} $impl_result "${ctd_ba}_ctd.txt" impl_result1
        set cmd "$corr_cmd -impl_name $impl_name -impl_result $impl_result -result_gold $impl_result1"
      } else {
        set cmd "$corr_cmd -impl_name $impl_name -impl_result $impl_result -result_gold $result_gold"
      }
    } else {
      regsub {proto_correlate} $corr_cmd "pro_qii_corr" corr_cmd
      set cmd "$corr_cmd -impl_name $impl_name -impl_result $impl_result"
    }
  }
#puts "CMD_final:  $cmd"
  set stat [eval $cmd]
  cd $start_dir
  set ignore_sys_clk 0
  if {$stat && !$supp_err} {
    return -code error "Errors found."
  } else {
    return $stat
  }
   
}

proc export_result {}  {
  if {[catch {export vivado -path [pwd]}]} {
    if {[catch {export quartus -path [pwd]}]} {
      puts "ERROR: Can't find synthesis results"
      return 0
    }
    catch {glob -directory [pwd] *.vqm} top
  } else {
    catch {glob -directory [pwd] *.edf} top
  }
  export file map.srr
  set tmp [lindex [file split $top] end]
  regsub {\.edf} $tmp ".srm" tmp
  regsub {\.vqm} $tmp ".srm" tmp
  file rename -force $top [pwd]/$tmp
  catch {file delete -force [glob -directory [pwd] *.xdc]}
  return 1
}

proc export_file {f_name} {
  export state -hier -path export_temp
  set dir [pwd]
  cd export_temp
  catch {file delete [glob HAPS*.srm]}
  if {[catch {glob -directory [pwd] $f_name} result]} {
    puts "ERROR:  Can't find $f_name"
    cd ..
    file delete -force export_temp
    return
  }
  set tmp [lindex [file split $result] end]
  file rename -force $result $dir/$tmp
  cd ..
  file delete -force export_temp
#  file copy -force [database query -state_dir]/$f_name [pwd]/.
}
#############################################################################
##### report_timing   ####
#############################################################################
proc report_timing {args} {
  variable placement_rules
  variable num_paths_xdc
  variable paths_per_xdc
  variable ta_file
  variable error_msg
  variable placement
  variable dcp_file
  variable pr_dir_global
  variable prod
  variable par_cmd
  variable view_mode
  variable no_usage
  variable rst_time
  variable xdc_file
  global env
  global tcl_library

  set placement_rules 0
  set placement ""
  set error_msg ""
  set to_msg ""
  set from_msg ""
  set thru_msg ""
  set par_cmd ""
  set paths_per_xdc 1
  set num_paths_xdc 1
  set pr_dir_global ""
  set Xdc_result "_route"
  if {$prod eq "legacy"} {
    set no_usage 0
  } else {
    set no_usage 1
  }

#  set opts_w_val_exp_s {(-to|-rise_to|-fall_to|-fr.*|-rise_f.*|-fall_f.*|-th.*|-del.*|-m.*|-slack_m.*|-fi.*)+}
  set opts_w_val_exp_s [get_opts_w_val_exp report_timing]
  set opts_no_val_exp_s [get_opts_no_val_exp report_timing]

  if {[check_opt_help report_timing $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all report_timing $args]} {
    return -code error "Error:  command ignored"
  }
  check_opt_default report_timing $args
  check_opt_ignore report_timing $args
  if {[check_opt_unsup report_timing $args] || [check_opt_excl report_timing $args]} {
    return -code error "Error:  command ignored"
  }
#### Check if a specified option requires another option to also be specified
  if {[check_opt_reqs report_timing $args]} {
    return -code error "Error:  command ignored"
  }

  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set to_list {}
  set from_list {}
  set thru_list {}
  set max_paths 1
  set margin "-1.0"
  set top [top_result]
  set start_dir [pwd]
  set p_dir [pwd]
  set ta_file ""
  set xdc_file ""
  set file_ta 0
  set rst_time 0
  if {$prod eq "legacy"} {
    cd [g_impl_dir]
  } else {
    set p_dir [file dirname [database query -path]]
    set top [file tail [database query -path]]
  }
  foreach x $opt_inx_l {
#### -to option
    foreach o {-to -rise_to -fall_to} {
      if {[check_opt_is report_timing $o [lindex $args $x]]} {
        set check [check_opt_val report_timing $o [split [join [lindex $args [expr $x + 1]]]]]
        if {$check} {
          set to_list [split [join [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]]]
          if {[regexp {^s:} [lindex $to_list 0]]} {
            set to_list [get_object_name $to_list]
          }
          if {$o eq "-rise_to" && [lsearch -regexp $to_list {^c:}] != -1} {
            foreach i [lsearch -all -regexp $to_list {^c:}] {
              set foo [lindex $to_list $i]
              regsub -all {\{|\}} $foo "" foo
              regsub {$} $foo ":r" foo
              set to_list [lreplace $to_list $i $i $foo]
            }
          }
          if {$o eq "-fall_to" && [lsearch -regexp $to_list {^c:}] != -1} {
            foreach i [lsearch -all -regexp $to_list {^c:}] {
              set foo [lindex $to_list $i]
              regsub -all {\{|\}} $foo "" foo
              regsub {$} $foo ":f" foo
              set to_list [lreplace $to_list $i $i $foo]
            }
          }
        } else {
          set to_msg "Error, report_timing $o: Bad or empty list.  If using \"get_*\" queries, try opening an Analyst Tech view first (*.srm)"
        }
      }
    }
#### -from option
    foreach o {-from -rise_from -fall_from} {
      if {[check_opt_is report_timing $o [lindex $args $x]]} {
        set check [check_opt_val report_timing $o [split [join [lindex $args [expr $x + 1]]]]]
        if {$check} {
          set from_list [split [join [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]]]
          if {[regexp {^s:} [lindex $from_list 0]]} {
            set from_list [get_object_name $from_list]
          }
          if {$o eq "-rise_from" && [lsearch -regexp $from_list {^c:}] != -1} {
            foreach i [lsearch -all -regexp $from_list {^c:}] {
              set foo [lindex $from_list $i]
              regsub -all {\{|\}} $foo "" foo
              regsub {$} $foo ":r" foo
              set from_list [lreplace $from_list $i $i $foo]
            }
          }
          if {$o eq "-fall_from" && [lsearch -regexp $from_list {^c:}] != -1} {
            foreach i [lsearch -all -regexp $from_list {^c:}] {
              set foo [lindex $from_list $i]
              regsub -all {\{|\}} $foo "" foo
              regsub {$} $foo ":f" foo
              set from_list [lreplace $from_list $i $i $foo]
            }
          }
        } else {
          set from_msg "Error, report_timing $o: Bad or empty list.  If using \"get_*\" queries, try opening an Analyst Tech view first (*.srm)"
        }
      }
    }
#### -through option
    foreach o {-through} {
      if {[check_opt_is report_timing $o [lindex $args $x]]} {
        set check [check_opt_val report_timing $o [split [join [lindex $args [expr $x + 1]]]]]
        if {$check} {
          set thru_list_i [split [join [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]]]
          if {[regexp {^s:} [lindex $thru_list_i 0]]} {
            set thru_list_i [get_object_name $thru_list_i]
          }
          if {$thru_list eq {}} {
            set thru_list $thru_list_i
          } else {
            set thru_list "$thru_list , $thru_list_i"
          }
        } else {
          set thru_msg "Error, report_timing $o: Bad or empty list.  If using \"get_*\" queries, try opening an Analyst Tech view first (*.srm)"
        }
      }
    }
#### -max_paths option
    if {[check_opt_is report_timing {-max_paths} [lindex $args $x]]} {
      set check [check_opt_val report_timing {-max_paths} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set max_paths [split [join [lindex $args [expr $x + 1]]]]
#        set num_paths_xdc $max_paths
      } else {
        return -code error "Error, report_timing, must be: -max_paths <int>"
      }
    }
#### -slack_margin option
    if {[check_opt_is report_timing {-slack_margin} [lindex $args $x]]} {
      set check [check_opt_val report_timing {-slack_margin} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set margin [split [join [lindex $args [expr $x + 1]]]]
      } else {
        return -code error "Error, report_timing, must be: -slack_margin <float>"
      }
    }
#### -nworst option
    if {[check_opt_is report_timing {-nworst} [lindex $args $x]]} {
      set check [check_opt_val report_timing {-nworst} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set paths_per_xdc [split [join [lindex $args [expr $x + 1]]]]
      } else {
        return -code error "Error, report_timing, must be: -nworst <int>"
      }
    }
#### -file option
    if {[check_opt_is report_timing {-file} [lindex $args $x]]} {
      set check [check_opt_val report_timing {-file} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set ta_file [split [join [lindex $args [expr $x + 1]]]]
        if {[regexp {^[^\/]+} $ta_file]} {
          set ta_file [pwd]/$ta_file
        }
        set file_ta 1
      } else {
        return -code error "Error, report_timing, must be: -file <strg>"
      }
    }
#### -ctd_file option
    if {[check_opt_is report_timing {-ctd_file} [lindex $args $x]]} {
      set check [check_opt_val report_timing {-ctd_file} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set ta_file [split [join [lindex $args [expr $x + 1]]]]
        set file_ta 1
      } else {
        return -code error "Error, report_timing, must be: -ctd_file <strg>"
      }
    }
#### -xdc_file option
    if {[check_opt_is report_timing {-xdc_file} [lindex $args $x]]} {
      set check [check_opt_val report_timing {-xdc_file} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set xdc_file [split [join [lindex $args [expr $x + 1]]]]
        set rst_time 1
      } else {
        return -code error "Error, report_timing, must be: -xdc_file <strg>"
      }
    }
#### -par_dir option
    if {[check_opt_is report_timing {-par_dir} [lindex $args $x]]} {
      set check [check_opt_val report_timing {-par_dir} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set pr_dir [split [join [lindex $args [expr $x + 1]]]]
        if {[regexp {^[^\/]+} $pr_dir]} {
          set pr_dir [pwd]/$pr_dir
        }
      } else {
        return -code error "Error, report_timing, must be: -par_dir <strg>"
      }
    }
  }
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  set xdc_mode 0
  set view_mode 0
  set hstdm_mode 0
  set hstdm_qor 0
  set hstdm_cons 0
  set ctd_mode 0
  set quiet_mode 0
  set gui_mode 0
  foreach x $opt_inx_l {
#### -xdc_par option
#### Change of strategy:  if -xdc_par is specified, don't process any further and simply pass the command line on to PnR tool.
    if {[check_opt_is report_timing {-xdc_par} [lindex $args $x]]} {
      set xdc_mode 1
      set  f [info frame -1]
      set  par_cmd [dict get $f cmd]
      regsub {\-ti[^\s]*} $par_cmd "" par_cmd
      regsub {\-xdc_p[^\s]*} $par_cmd "" par_cmd
      regsub {\-fi[^\s]*\s+[^\s$]+} $par_cmd "" par_cmd
      regsub {\-par[^\s]*\s+[^\s$]+} $par_cmd "" par_cmd
      regsub {\-xdc_f[^\s]*\s+[^\s$]+} $par_cmd "" par_cmd
      regsub {\-gui} $par_cmd "" par_cmd
    }
#### -write_ctd option
    if {[check_opt_is report_timing {-write_ctd} [lindex $args $x]]} {
      set ctd_mode 1
    }
#### -gui option
    if {[check_opt_is report_timing {-gui} [lindex $args $x]]} {
      set ctd_mode 0
      set gui_mode 1
      if {$xdc_mode && ![regexp {\/} $par_cmd]} {
        regsub -all {\\\\\\(\[)([0-9]+)\\\\\\(\])} $par_cmd {#\1\2#\3} par_cmd
        regsub -all {\\\\} $par_cmd "@" par_cmd
        regsub -all {(\s|\{).:} $par_cmd {\1} par_cmd
        regsub -all {\.} $par_cmd {/} par_cmd
        regsub -all {\\\/} $par_cmd {.} par_cmd
        regsub -all {,} $par_cmd "_" par_cmd
        regsub -all {\\} $par_cmd "" par_cmd
        regsub -all {@} $par_cmd {\\\\} par_cmd
        regsub -all {#} $par_cmd {\\} par_cmd
      }
    }
#### -quiet option
    if {[check_opt_is report_timing {-quiet} [lindex $args $x]]} {
      set quiet_mode 1
    }
#### -time_view option
    if {[check_opt_is report_timing {-time_view} [lindex $args $x]]} {
      set view_mode 1
    }
#### -hstdm_par option
    if {[check_opt_is report_timing {-hstdm_par} [lindex $args $x]]} {
      set hstdm_mode 1
      set hstdm_qor 1
      set xdc_mode 1
      regsub -all {\\} $tcl_library {/} tcl_lib_glob
      set hstdm_tcl [space_clean_file $tcl_lib_glob "HSTDM_Qor_rpt.tcl"]
      if {![file exists $hstdm_tcl]} {
        return -code error "ERROR:  Can't find $hstdm_tcl"
      }
    }
#### -hstdm_par_cons option
    if {[check_opt_is report_timing {-hstdm_par_cons} [lindex $args $x]]} {
      set hstdm_mode 1
      set hstdm_cons 1
      set xdc_mode 1
      regsub -all {\\} $tcl_library {/} tcl_lib_glob
      set hstdm_tcl [space_clean_file $tcl_lib_glob "HSTDM_Qor_rpt.tcl"]
      if {![file exists $hstdm_tcl]} {
        return -code error "ERROR:  Can't find $hstdm_tcl"
      }
    }
  }
  if {!$xdc_mode} {
    if {[regexp {cpm_(snd|rcv)_HSTDM} $from_list]} {
      regsub -all {\\} $from_list "" from_list
    }
    if {[regexp {cpm_(snd|rcv)_HSTDM} $to_list]} {
      regsub -all {\\} $to_list "" to_list
    }
    if {[regexp {(sysip_inst|ident_coreinst)} $from_list]} {
      regsub -all {\\} $from_list "" from_list
    }
    if {[regexp {(sysip_inst|ident_coreinst)} $to_list]} {
      regsub -all {\\} $to_list "" to_list
    }
    if {$to_msg ne "" || $from_msg ne "" || $thru_msg ne ""} {
      if {!$quiet_mode} {
        puts "$to_msg"
        puts "$from_msg"
        puts "$thru_msg"
      }
      return -code error
    }
  }
  if {$prod eq "legacy"} {
    if {!$view_mode} {
      set default_ta_file [space_clean_file [g_impl_dir] "${top}.ta"]
    } else {
      set default_ta_file [space_clean_file [g_impl_dir] "${top}_view_mode.ta"]
    }
  } else {
    if {!$view_mode} {
      set default_ta_file [space_clean_file $p_dir "${top}.ta"]
    } else {
      set default_ta_file [space_clean_file $p_dir "${top}_view_mode.ta"]
    }
    if {[database query_state -run_type] eq "system_generate"} {
      regsub -all {\\} $from_list "" from_list
      regsub -all {\\} $to_list "" to_list
    }
  }
  set ctd [g_opt reporting_ctd]
  if {$file_ta} {
    if {![regexp {\/} $ta_file]} {
      if {$prod eq "legacy"} {
        set ta_file [g_impl_dir]/$ta_file
      } else {
        set ta_file $p_dir/$ta_file
      }
    }
  } else {
    set ta_file $default_ta_file
  }
  if {!$xdc_mode} {
    if {$view_mode || $ctd_mode} {
      s_opt reporting_ctd slack
    } else {
      s_opt reporting_ctd off
    }
    set filter [make_filter $from_list $thru_list $to_list]
    s_opt reporting_margin $margin
    s_opt reporting_filter $filter
    s_opt reporting_number_paths $max_paths
    s_opt reporting_netlist ""
    if {$prod eq "protocompiler"} {
      if {$file_ta && $ctd_mode} {
        s_opt reporting_filename $ta_file
      }
	  # the timing report job is invoked when this script finishes
      return 0
    } else {
#      catch {s_opt reporting_skip_timing 0}
      s_opt reporting_filename $ta_file
      project -run -fg timing
    }
  } else {
##### run report_timing in Vivado
    if {!$file_ta} {
      regsub {.ta$} $default_ta_file ".sta_vivado" ta_file
    }
    if {$prod eq "legacy"} {
      set r_list [get_pr_dir "" 0]
      if {[lindex $r_list 0]} {
        s_opt reporting_ctd $ctd
        cd $start_dir
        return -code error "No active P&R job"
      }
      set pr_dir [lindex $r_list 1]
    } else {
      if {[database query_state -run_type] ne "map"} {
        s_opt reporting_ctd $ctd
        cd $start_dir
        return -code error "ERROR:  Must be in a \"map\" state to run this"
      }
    }
    set dcp_file ""
    if {[catch {cd $pr_dir}]} {
      s_opt reporting_ctd $ctd
      cd $start_dir
      return -code error "ERROR:  P&R directory not found"
    }
    catch {glob -directory . *} f_list
    if {[catch {set tmp $env(XILINX_VIVADO)}]} {
      s_opt reporting_ctd $ctd
      cd $start_dir
      return -code error "ERROR:  env variable XILINX_VIVADO needs to be defined"
    }
#    set from_list [prep_for_xdc $from_list]
#    set to_list [prep_for_xdc $to_list]
#    set thru_list [prep_for_xdc $thru_list]
#    if {$from_list eq "<NULL>" || $to_list eq "<NULL>" || $thru_list eq "<NULL>"} {
#      puts "ERROR:  You must specify object qualifiers in the from/to/through filters (get_cells, i:, get_nets, n:, etc.)"
#      s_opt reporting_ctd $ctd
#      cd $start_dir
#      return 1
#    }
    if {$prod ne "legacy"} {
      if {[catch {glob -directory [pwd] *.edf} impl_result]} {
        if {[catch {glob -directory [pwd] *.vm} impl_result]} {
          puts "ERROR:  Can't find a synthesis netlist (*.edf or *.vm)"
          cd $start_dir
          return 2
        }
      }
      set top [lindex [file split $impl_result] end]
      regsub {\.[a-zA-Z]+$} $top "" top
    }
    if {[llength [lsearch -all -regexp $f_list "post${Xdc_result}\.dcp"]] != 1} {
      if {[llength [lsearch -all -regexp $f_list "${top}\.dcp"]] != 1} {
        if {[llength [lsearch -all -regexp $f_list "post_route\.dcp"]] != 1} {
          s_opt reporting_ctd $ctd
          cd $start_dir
          return -code error "ERROR:  No Post Placement/Routing Check Point file found (*.dcp) in $pr_dir."
        } else {
          set dcp_file $pr_dir/[lsearch -inline -regexp $f_list "post_route\.dcp"]
        }
      } else {
        set dcp_file $pr_dir/[lsearch -inline -regexp $f_list "${top}\.dcp"]
      }
    } else {
      set dcp_file $pr_dir/[lsearch -inline -regexp $f_list "post${Xdc_result}\.dcp"]
    }
    regsub -all {\\} $tmp {/} tmp
    set vivado ${tmp}/bin/vivado
    if {!$hstdm_mode} {
      make_vivado_ta $pr_dir $from_list $to_list $thru_list
      catch {file delete -force $ta_file}
      if {$prod eq "legacy"} {
        catch {exec $vivado -mode batch -source run_tim_dump.tcl -log vivado_TA.log} stat
      } else {
        catch {file rename -force vivado.log tmp.log}
        catch {launch vivado -script run_tim_dump.tcl}
        catch {file rename -force vivado.log vivado_TA.log}
        catch {file rename -force tmp.log vivado.log}
      }
      if {[catch {glob $ta_file}]} {
        puts "ERROR: $ta_file was not generated from Vivado"
        puts "Please see: ${pr_dir}/vivado_TA.log"
        s_opt reporting_ctd $ctd
        cd $start_dir
        return -code error
      }
      puts "Vivado timing report: $ta_file"
    } else {
      set hstdm_scr [space_clean_file [pwd] "report_hstdm_qor"]
      set hstdm_qor_dcp_path "${pr_dir}"
      set hstdm_qor_output_path "${pr_dir}"
      if {$hstdm_qor} {
        # arguments could be "-dcp_path" "-output_path" "-open_checkpoint" "-report_missing_constraints" "-report_number_slices"
        # do not report number of slices, because it is not very useful for user. majorly for internal debugging
        set hstdm_argv "report_hstdm_qor -dcp_path \"${hstdm_qor_dcp_path}\" -output_path \"${hstdm_qor_output_path}\" -open_checkpoint 1 -report_missing_constraints $hstdm_cons"
      } else {
        set hstdm_argv "report_hstdm_missing_constraints_wrapper -dcp_path \"${hstdm_qor_dcp_path}\" -output_path \"${hstdm_qor_output_path}\" -open_checkpoint 1"
      }
      # tclargs has to be the last arguments
      puts "INFO:  Vivado run status:       ${hstdm_scr}.log"
      catch {exec $vivado -mode batch -source ${hstdm_tcl} -notrace -log ${hstdm_scr}.log -nojournal -tclargs ${hstdm_argv} } stat
      puts "INFO:  For HSTDM Reports, see:  ${hstdm_qor_output_path}/HSTDM_Qor_rpt"
    }
  }
  if {!$hstdm_mode} {
    if {!$file_ta && !$ctd_mode && !$view_mode} {
      set fpi [open $ta_file r]
      while {![eof $fpi]} {
        puts [gets $fpi]
      }
      close $fpi
    }
  }
  s_opt reporting_ctd $ctd
  cd $start_dir
  return 0
}

set check_hstdm 0
proc check_hstdm_timing {args} {
  variable hstdm_thresh
  variable hstdm_fdc
  variable xdc_file_tdm
  variable file_xdc
  variable default_dpo
  variable check_hstdm
  variable prod
  variable supr_msg
  variable rx_clocks
  variable tx_clocks
  variable umr_clocks

  set opts_w_val_exp_s [get_opts_w_val_exp check_hstdm_timing]
  set opts_no_val_exp_s [get_opts_no_val_exp check_hstdm_timing]

  if {[check_opt_help check_hstdm_timing $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all check_hstdm_timing $args]} {
    return -code error "Error:  command ignored"
  }

#### Check if a specified option requires another option to also be specified
  if {[check_opt_reqs check_hstdm_timing $args]} {
    return -code error "Error:  command ignored"
  }

  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set hstdm_thresh 1500
  set xdc_file_tdm ""
  set hstdm_fdc 0
  set file_xdc 0
  set default_dpo 8.000
  set hstdm_found 0
  foreach x $opt_inx_l {
#### -slack option
    if {[check_opt_is check_hstdm_timing {-slack} [lindex $args $x]]} {
      set check [check_opt_val check_hstdm_timing {-slack} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set hstdm_thresh [split [join [lindex $args [expr $x + 1]]]]
      } else {
        return -code error "Error, report_hstdm_timing, must be: -slack <float>"
      }
    }
#### -write_xdc option
    if {[check_opt_is check_hstdm_timing {-write_xdc} [lindex $args $x]]} {
      set check [check_opt_val check_hstdm_timing {-write_xdc} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set xdc_file_tdm [split [join [lindex $args [expr $x + 1]]]]
        set file_xdc 1
      } else {
        return -code error "Error, check_hstdm_timing, must be: -write_xdc <strg>"
      }
    }
#### -default_delay option
    if {[check_opt_is check_hstdm_timing {-default_delay} [lindex $args $x]]} {
      set check [check_opt_val check_hstdm_timing {-default_delay} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set default_dpo [split [join [lindex $args [expr $x + 1]]]]
        set file_xdc 1
      } else {
        return -code error "Error, check_hstdm_timing, must be: -default_delay <float>"
      }
    }
  }
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  set do_all 1
  set p2t 0
  set r2p 0
  set r2t 0
  set r2usr 0
  set usr2t 0
  set r2umr 0
  set umr2r 0
  foreach x $opt_inx_l {
#### -port2tx option
    if {[check_opt_is check_hstdm_timing {-port2tx} [lindex $args $x]]} {
      set p2t 1
    }
#### -rx2port option
    if {[check_opt_is check_hstdm_timing {-rx2port} [lindex $args $x]]} {
      set r2p 1
    }
#### -rx2tx option
    if {[check_opt_is check_hstdm_timing {-rx2tx} [lindex $args $x]]} {
      set r2t 1
    }
#### -rx2user option
    if {[check_opt_is check_hstdm_timing {-rx2user} [lindex $args $x]]} {
      set r2usr 1
    }
#### -user2tx option
    if {[check_opt_is check_hstdm_timing {-user2tx} [lindex $args $x]]} {
      set usr2t 1
    }
#### -rx2umr option
    if {[check_opt_is check_hstdm_timing {-rx2umr} [lindex $args $x]]} {
      set r2umr 1
    }
#### -umr2rx option
    if {[check_opt_is check_hstdm_timing {-umr2rx} [lindex $args $x]]} {
      set umr2r 1
    }
#### -write_fdc option
    if {[check_opt_is check_hstdm_timing {-write_fdc} [lindex $args $x]]} {
      set hstdm_fdc 1
    }
  }
  set do_all [expr !($p2t | $r2p | $r2t | $r2usr | $usr2t | $r2umr | $umr2r)]

  if {$prod eq "legacy"} {
    cd [g_impl_dir]
    set top [top_result]
    set impl \{[project -file]|[impl -active]\}
    set result \{[regsub -all {\\} [impl -result_file] "/"]\}
    set srm_file [space_clean_file [impl -dir] "${top}.srm"]
    set ctd_file [space_clean_file [impl -dir] "${top}_ctd.txt"]
    set itd_tcl [space_clean_file [impl -dir] "sdc_verif_itd.tcl"]
    open_file $srm_file
    set f_list [impl -result_file]
    regsub -all {\\} $f_list "/" f_list
  } else {
    set start_dir [pwd]
    if {$file_xdc} {
      if {![regexp {^\/} $xdc_file_tdm]} {
        set xdc_file_tdm $start_dir/$xdc_file_tdm
      }
    }
  ####  Need to be in a map state
    set state [database query_state -run_type]
    if {$state ne "map"} {
      return -code error "Error:  You must be in a \"map\" state to run check_hstdm_timing"
    }
    set state_name "timing_correlation_[database query -name]_[database get_state]"
    goto_work_dir
    file mkdir $state_name
    cd $state_name
    set f_list [export file -list]
    if {[lsearch $f_list *.est] != -1} {
      set top [lsearch -inline $f_list *.est]
    } else {
      set top "default.est"
    }
    set f_list [pwd]/$top
    regsub {\.[a-zA-Z]+$} $top "" top
    design open
    set check_hstdm 1
    set itd_tcl [pwd]/sdc_verif_itd.tcl
    set ctd_file [pwd]/${top}_ctd.txt
  }
  if {[file exists "no_HSTDM_found"]} {
    catch {file delete -force "no_HSTDM_found"}
  }

#  regsub {\.[a-zA-Z]+$} $f_list "_hstdm_tim_toSystem.rpt" out_file
#  catch {file delete -force $itd_tcl}
#  if {![catch {report_timing  -to [get_clocks System] -max 1000 -file ${top}.ta -write_ctd -quiet}]} {
#    set cmd_strg "pro_ise_corr -paths_per 1000 -sdc_verif -default_sta -load_sta -impl_name $impl -impl_result $result -hstdm_report $out_file"
#    eval $cmd_strg
#  }
#
#  regsub {\.[a-zA-Z]+$} $f_list "_hstdm_tim_fromSystem.rpt" out_file
#  catch {file delete -force $itd_tcl}
#  if {![catch {report_timing -from [get_clocks System] -max 1000 -file ${top}.ta -write_ctd -quiet}]} {
#    set cmd_strg "pro_ise_corr -paths_per 1000 -sdc_verif -default_sta -load_sta -impl_name $impl -impl_result $result -hstdm_report $out_file"
#    eval $cmd_strg
#  }
  set supr_msg 1
  set fdc_file [file dirname $f_list]/hstdm_missing.fdc
  set usr_clks [get_user_clocks]
  if {$do_all || $p2t} {
    regsub {\.[a-zA-Z]+$} $f_list "_hstdm_tim_port2tdmtx.rpt" out_file
    regsub {\.[a-zA-Z]+$} $f_list "_port2tdmtx.fdc" out_file_fdc
    catch {file delete -force $itd_tcl}
    if {$prod eq "legacy"} {
      if {![catch {report_timing -from [all_inputs] -to $tx_clocks  -file ${top}.ta -write_ctd -quiet}]} {
        set cmd_strg "pro_ise_corr -paths_per 100000 -sdc_verif -default_sta -load_sta -impl_name $impl -impl_result $result -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for port to Tx."
      }
    } else {
      s_opt reporting_filename [pwd]/${top}.ta
      if {![catch {report timing -generate -from [all_inputs] -to $tx_clocks  -out $top -write_ctd -quiet}]} {
        set cmd_strg "proto_correlate -effort low -paths_per 100000 -sdc_verif -load_sta -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for port to Tx."
      }
    }
    if {[file exists $fdc_file]} {
      file rename -force $fdc_file $out_file_fdc
      puts "Info:  Missing timing exceptions file created, see $out_file_fdc"
    }
  }
  
  if {$do_all || $r2p} {
    regsub {\.[a-zA-Z]+$} $f_list "_hstdm_tim_tdmrx2port.rpt" out_file
    regsub {\.[a-zA-Z]+$} $f_list "_tdmrx2port.fdc" out_file_fdc
    catch {file delete -force $itd_tcl}
    if {$prod eq "legacy"} {
      if {![catch {report_timing -from $rx_clocks -to [all_outputs]  -file ${top}.ta -write_ctd -quiet}]} {
        set cmd_strg "pro_ise_corr -paths_per 100000 -sdc_verif -default_sta -load_sta -impl_name $impl -impl_result $result -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for Rx to port."
      }
    } else {
      s_opt reporting_filename [pwd]/${top}.ta
      if {![catch {report timing -generate -from $rx_clocks -to [all_outputs]  -out $top -write_ctd -quiet}]} {
        set cmd_strg "proto_correlate -effort low -paths_per 100000 -sdc_verif -load_sta -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for Rx to port."
      }
    }
    if {[file exists $fdc_file]} {
      file rename -force $fdc_file $out_file_fdc
      puts "Info:  Missing timing exceptions file created, see $out_file_fdc"
    }
  }
  
  if {$do_all || $r2t} {
    regsub {\.[a-zA-Z]+$} $f_list "_hstdm_tim_tdmrx2tdmtx.rpt" out_file
    regsub {\.[a-zA-Z]+$} $f_list "_tdmrx2tdmtx.fdc" out_file_fdc
    catch {file delete -force $itd_tcl}
    if {$prod eq "legacy"} {
      if {![catch {report_timing -from $rx_clocks -to $tx_clocks  -file ${top}.ta -write_ctd -quiet}]} {
        set cmd_strg "pro_ise_corr -paths_per 100000 -sdc_verif -default_sta -load_sta -impl_name $impl -impl_result $result -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for Rx to Tx."
      }
    } else {
      s_opt reporting_filename [pwd]/${top}.ta
      if {![catch {report timing -generate -from $rx_clocks -to $tx_clocks  -out $top -write_ctd -quiet}]} {
        set cmd_strg "proto_correlate -effort low -paths_per 100000 -sdc_verif -load_sta -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } elseif {![catch {report timing -generate -from [get_cells {cpm_rcv*.data_out[*]}] -to [get_cells {cpm_snd*.cpm_data}] -quiet}]} {
          set cmd_strg "proto_correlate -effort low -paths_per 100000 -sdc_verif -load_sta -hstdm_report $out_file"
          eval $cmd_strg
          incr hstdm_found
      } else {
        puts "Info:  No Paths for Rx to Tx."
      }
    }
    if {[file exists $fdc_file]} {
      file rename -force $fdc_file $out_file_fdc
      puts "Info:  Missing timing exceptions file created, see $out_file_fdc"
    }
  }
  
  if {$do_all || $r2usr} {
    regsub {\.[a-zA-Z]+$} $f_list "_hstdm_tim_tdmrx2user.rpt" out_file
    regsub {\.[a-zA-Z]+$} $f_list "_tdmrx2user.fdc" out_file_fdc
    catch {file delete -force $itd_tcl}
    if {$prod eq "legacy"} {
      if {![catch {report_timing -from $rx_clocks -to $usr_clks  -file ${top}.ta -write_ctd -quiet}]} {
        set cmd_strg "pro_ise_corr -paths_per 100000 -sdc_verif -default_sta -load_sta -impl_name $impl -impl_result $result -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for Rx to User logic."
      }
    } else {
      s_opt reporting_filename [pwd]/${top}.ta
      if {![catch {report timing -generate -from $rx_clocks -to $usr_clks  -out $top -write_ctd -quiet}]} {
        set cmd_strg "proto_correlate -effort low -paths_per 100000 -sdc_verif -load_sta -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for Rx to User logic."
      }
    }
    if {[file exists $fdc_file]} {
      file rename -force $fdc_file $out_file_fdc
      puts "Info:  Missing timing exceptions file created, see $out_file_fdc"
    }
  }
  
  if {$do_all || $usr2t} {
    regsub {\.[a-zA-Z]+$} $f_list "_hstdm_tim_user2tdmtx.rpt" out_file
    regsub {\.[a-zA-Z]+$} $f_list "_user2tdmtx.fdc" out_file_fdc
    catch {file delete -force $itd_tcl}
    if {$prod eq "legacy"} {
      if {![catch {report_timing -to $tx_clocks -from $usr_clks  -file ${top}.ta -write_ctd -quiet}]} {
        set cmd_strg "pro_ise_corr -paths_per 100000 -sdc_verif -default_sta -load_sta -impl_name $impl -impl_result $result -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for User logic to Tx."
      }
    } else {
      s_opt reporting_filename [pwd]/${top}.ta
      if {![catch {report timing -generate -to $tx_clocks -from $usr_clks  -out $top -write_ctd -quiet}]} {
        set cmd_strg "proto_correlate -effort low -paths_per 100000 -sdc_verif -load_sta -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for User logic to Tx."
      }
    }
    if {[file exists $fdc_file]} {
      file rename -force $fdc_file $out_file_fdc
      puts "Info:  Missing timing exceptions file created, see $out_file_fdc"
    }
  }
  
  if {$do_all || $r2umr} {
    regsub {\.[a-zA-Z]+$} $f_list "_hstdm_tim_rx2umr.rpt" out_file
    regsub {\.[a-zA-Z]+$} $f_list "_rx2umr.fdc" out_file_fdc
    catch {file delete -force $itd_tcl}
    if {$prod eq "legacy"} {
      if {![catch {report_timing -to $umr_clocks -from  $rx_clocks  -file ${top}.ta -write_ctd -quiet}]} {
        set cmd_strg "pro_ise_corr -paths_per 100000 -sdc_verif -default_sta -load_sta -impl_name $impl -impl_result $result -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for Rx to UMR."
      }
    } else {
      s_opt reporting_filename [pwd]/${top}.ta
      if {![catch {report timing -generate -to $umr_clocks -from $rx_clocks  -out $top -write_ctd -quiet}]} {
        set cmd_strg "proto_correlate -effort low -paths_per 100000 -sdc_verif -load_sta -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for Rx to UMR."
      }
    }
    if {[file exists $fdc_file]} {
      file rename -force $fdc_file $out_file_fdc
      puts "Info:  Missing timing exceptions file created, see $out_file_fdc"
    }
  }
  
  if {$do_all || $umr2r} {
    regsub {\.[a-zA-Z]+$} $f_list "_hstdm_tim_umr2rx.rpt" out_file
    regsub {\.[a-zA-Z]+$} $f_list "_umr2rx.fdc" out_file_fdc
    catch {file delete -force $itd_tcl}
    if {$prod eq "legacy"} {
      if {![catch {report_timing -from $umr_clocks -to  $rx_clocks  -file ${top}.ta -write_ctd -quiet}]} {
        set cmd_strg "pro_ise_corr -paths_per 100000 -sdc_verif -default_sta -load_sta -impl_name $impl -impl_result $result -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for UMR to Rx."
      }
    } else {
      s_opt reporting_filename [pwd]/${top}.ta
      if {![catch {report timing -generate -from $umr_clocks -to $rx_clocks  -out $top -write_ctd -quiet}]} {
        set cmd_strg "proto_correlate -effort low -paths_per 100000 -sdc_verif -load_sta -hstdm_report $out_file"
        eval $cmd_strg
        incr hstdm_found
      } else {
        puts "Info:  No Paths for UMR to Rx."
      }
    }
    if {[file exists $fdc_file]} {
      file rename -force $fdc_file $out_file_fdc
      puts "Info:  Missing timing exceptions file created, see $out_file_fdc"
    }
  }

  if {!$hstdm_found} {
    catch {open "no_HSTDM_found" w} p
    close $p
  }
  if {$prod ne "legacy"} {
    cd $start_dir
    set check_hstdm 0
    s_opt reporting_filename ""
    design close [design get]
  }
  puts "HSTDM reporting is done."
  puts "For path categories that exist, see: [file dirname $f_list]/*_hstdm_tim_*.rpt"
  catch {file delete -force $itd_tcl}
  catch {file delete -force $ctd_file}
  set supr_msg 0
}

proc get_user_clocks {} {
  variable rx_clocks
  variable tx_clocks
  variable umr_clocks

  set rx_clocks [get_clocks {cpm_fast_clock hstdm_rx*}]
  set rx_l [object_list $rx_clocks]
  set tx_clocks [get_clocks {cpm_fast_clock hstdm_clkgen* d_txclkdiv* hstdm_txclk* hstdm_native*txclk*}]
  set tx_l [object_list $tx_clocks]
  set umr_clocks [get_clocks -regexp {umr_clk_gen.* .*umrbus_pllinst.* .*umr_clk.*}]
  set umr_clk_l [object_list $umr_clocks]
  set all_clk_l [object_list [all_clocks]]
  set rx_tx_l   [object_list [get_clocks -regexp {^hstdm_.* d_txclkdiv.* cpm_fast_clock}]]
  set rx_tx_l [concat $rx_tx_l $umr_clk_l]
#  set rx_tx_l [concat $rx_tx_l c:System]
  set rx_tx_l [concat $rx_tx_l c:(no]
  set rx_tx_l [concat $rx_tx_l c:clock)]
  foreach c $rx_tx_l {
    set all_clk_l [remove_from_list $all_clk_l $c]
  }
  return [list [join $all_clk_l]]
}

proc set_view {} {
  variable view_mode
  set view_mode 1
}

proc clear_view {} {
  variable view_mode
  set view_mode 0
}

  proc prep_for_xdc {list} {
    set new_string " "
    set no_qual 0
    set vm [regexp {\.vm$} [impl -result_file]]
    foreach x $list {
      regsub {.*} $x {{&}} x
      regsub -all {\\\.} $x {@} x
      regsub -all {\.} $x {/} x
      regsub -all {\\\/} $x {.} x
      regsub -all {,} $x "_" x
      regsub -all {\\} $x "" x
      regsub -all {@} $x "." x
      if {[regsub {i:} $x "" x]} {
        if {$vm} {
          regsub {\{(.*)\}} $x {{\1 \1}} x
          regsub {(\[[0-9]+\]\}$|\}$)} $x {_Z\1} x
        }
        regsub {.*} $x {[get_cells &]} x
      } elseif {[regsub {n:} $x "" x]} {
        regsub {.*} $x {[get_nets &]} x
      } elseif {[regsub {t:} $x "" x]} {
        regsub {.*} $x {[get_pins &]} x
      } elseif {[regsub {p:} $x "" x]} {
        regsub {.*} $x {[get_ports &]} x
      } else {
        set no_qual 1
      }
      set new_string [string replace $new_string 0 end "[string range $new_string 0 end] $x"]
    }
    if {$no_qual} {
      return "<NULL>"
    } else {
      return $new_string
    }
  }

  proc make_vivado_ta {pr_dir from_list to_list thru_list} {
    variable num_paths_xdc
    variable paths_per_xdc
    variable dcp_file
    variable ta_file
    variable par_cmd
    variable xdc_file
    variable rst_time

    set from_strg ""
    set to_strg ""
    set thru_strg ""
    set file_o  $pr_dir/run_tim_dump.tcl
    set fpo [open $file_o w]
#    puts $fpo "proc dot2slash {args} {"
#    puts $fpo [info body dot2slash]
#    puts $fpo "}"
    puts $fpo "set_param sta.maxSourcesPerClock -1"
    puts $fpo "read_checkpoint $dcp_file"
    puts $fpo "link_design"
    if {$rst_time} {
      puts $fpo "if \{\[file exists $xdc_file\]\} \{"
      puts $fpo "  reset_timing"
      puts $fpo "  read_xdc $xdc_file"
      puts $fpo "\}"
    }
#    puts $fpo "config_timing_corners -corner Slow -delay max"
#    puts $fpo "config_timing_corners -corner Fast -delay max"
    if {$from_list ne " "} {
      set from_strg "-from \[list$from_list\]"
    }
    if {$to_list ne " "} {
      set to_strg "-to \[list$to_list\]"
    }
    if {$thru_list ne " "} {
      set thru_strg "-through \[list$thru_list\]"
    }
    puts $fpo "$par_cmd -file $ta_file"
#    puts $fpo "report_timing $from_strg $to_strg $thru_strg -max_paths $num_paths_xdc -nworst $paths_per_xdc -file $ta_file"
#    if {$from_list eq "" || $to_list eq ""} {
#      puts $fpo "report_timing -max_paths $num_paths_xdc -nworst $paths_per_xdc -file $default_ta_file"
#    } else {
#      puts $fpo "report_timing -from \[list$from_list\] -to \[list$to_list\] -max_paths $num_paths_xdc -nworst $paths_per_xdc -file $default_ta_file"
#    }
    puts $fpo "exit"
    close $fpo
  }

proc make_filter {from_list thru_list to_list} {
  set strg "\{"
  if {[llength $from_list] != 0} {
    set strg "${strg}-from \{"
    foreach x $from_list {
      set strg "${strg}$x "
    }
    set strg "${strg}\} "
  }
  if {[llength $to_list] != 0} {
    set strg "${strg}-to \{"
    foreach x $to_list {
      set strg "${strg}$x "
    }
    set strg "${strg}\} "
  }
  set pos 0
  if {[llength $thru_list] != 0} {
    set strg "${strg}-through \{"
    foreach x $thru_list {
      if {$x eq ","} {
        set pos 1
        continue
      } else {
        if {!$pos} {
          set strg "${strg}$x "
        } else {
          set strg "${strg}\} -through \{$x "
          set pos 0
        }
      }
    }
    set strg "${strg}\}"
  }
  set strg "${strg}\}"
  if {$strg eq "{}"} {
    set strg ""
  }
  regsub -all {\/} $strg "." strg
  return [regsub -all {\\\\} $strg {\\}]
}

#############################################################################
##### all_fanout   ####
#############################################################################
proc all_fanout {args} {
  variable port
  variable pin
  variable inst
  variable seq

#  set opts_w_val_exp_s {(-fr.*|-l.*|-t.*)+}
#  set opts_no_val_exp_s {(-en.*|-ex.*|-b.*|-o.*|-fl.*)+}
  set opts_w_val_exp_s [get_opts_w_val_exp all_fanout]
  set opts_no_val_exp_s [get_opts_no_val_exp all_fanout]

  if {[check_opt_help all_fanout $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all all_fanout $args]} {
    return 1
  }
#### Check for required options and exclusivity, -from and -clock_tree
  if {(![check_opt_l all_fanout {-from} $args] && ![check_opt_l all_fanout {-clock_tree} $args]) || \
       [check_opt_excl all_fanout $args]} {
    puts "@E: :Error, all_fanout, must specify one of the following: -clock_tree OR -from <list>"
    return 1
  }
  set clk_tree [check_opt_l all_fanout {-clock_tree} $args]

#### Assign values to variables while also checking validity of the value types
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set col 0
  set obj_l {} 
  set level 0
  set type "all"
  foreach x $opt_inx_l {
#### -from option
    if {[check_opt_is all_fanout {-from} [lindex $args $x]]} {
      set check [check_opt_val all_fanout {-from} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 2} {
        set col [lindex $args [expr $x + 1]]
      } elseif {$check == 1} {
        set obj_l [split [join [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]]]
        if {[lsearch -all -regexp $obj_l {^[^.:]{2,}}] ne {}} {
          puts "@E: :Error, all_fanout, objects require qualifiers {i:, t:, p:, n:}"
          return 1
        }
      } else {
        puts "@E: :Error, all_fanout, must be: -from <col or obj_list>"
        return 1
      }
    } 
#### -levels option
    if {[check_opt_is all_fanout {-levels} [lindex $args $x]]} {
      set check [check_opt_val all_fanout {-levels} [lindex $args [expr $x + 1]]]
      if {$check == 1} {
#        set level "-level [lindex $args [expr $x + 1]]"
        set level [lindex $args [expr $x + 1]]
      } else {
        puts "@E: :Error, all_fanout, must be: -levels <int>"
        return 1
      }
    } 
#### -trace_arcs option
    if {[check_opt_is all_fanout {-trace_arcs} [lindex $args $x]]} {
      set check [check_opt_val all_fanout {-trace_arcs} [lindex $args [expr $x + 1]]]
      if {$check == 1} {
        set type [lindex $args [expr $x + 1]]
        if {$type eq "timing"} {
          puts "@W: : Warning, all_fanout, \"-trace_arcs timing\" not supported, defaulting to \"-trace_arcs all\" "
          set type "all"
        }
      } else {
        puts "@E: : Error, all_fanout, must be: -trace_arcs <all or timing>"
        return 1
      }
    }
  }
  set end_points ""
  set port 1
  set inst 0
  set seq 0
  set pin 1
  set excl_bb 0
  set break_bb 0
  set cells ""
  set flat 0
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  foreach x $opt_inx_l {
    if {[check_opt_is all_fanout {-endpoints_only} [lindex $args $x]]} {
      set end_points "-seq -port"
    }
    if {[check_opt_is all_fanout {-exclude_bboxes} [lindex $args $x]]} {
      set excl_bb 1
    }
    if {[check_opt_is all_fanout {-break_on_bboxes} [lindex $args $x]]} {
      set break_bb 1
    }
    if {[check_opt_is all_fanout {-only_cells} [lindex $args $x]]} {
      set cells "-inst"
    }
    if {[check_opt_is all_fanout {-flat} [lindex $args $x]]} {
      set flat 1
    }
  }
  if {$end_points ne "" && $cells ne ""} {
    set end_points "-seq"
    set cells ""
    set port 0
    set inst 0
    set pin 0
    set seq 1
  } elseif {$end_points ne "" && $cells eq ""} {
    set port 1
    set inst 0
    set pin 1
    set seq 1
  } elseif {$end_points eq "" && $cells ne ""} {
    set port 0
    set inst 1
    set pin 0
    set seq 1
  } elseif {$end_points eq "" && $cells eq ""} {
    set end_points "-port"
    set cells "-pin"
  }

#### Construct an expand command that will run for every element for -clock_tree or -from <col or obj_list>.
#### The actual expand is always -flat (equivalent to expand -hier), but if -flat is not specified, only objects in the 
#### hierarchy of each start point are returned.  If -only_cells is NOT specified, only pins and ports are 
#### returned; nets are never returned.  If -flat is specified, don't return hierarchical ports.
####

  if {$clk_tree} {
    set obj_l [c_list [find -port * -in [expand -level 1 -port -to [find -net * -filter {@is_clock}]] -filter {@direction == input}]]
#    set obj_l [split [join [timing_corr_aux::all_fanin -flat -start -to [find -pin *.* -filter {@is_clock && @direction == input}]]]]
  } else {
    if {$col ne "0"} {
      set obj_l [c_list $col]
    }
  }
  foreach x $obj_l {
    if {![regexp {^.:} $x]} {
      continue
    }
    if {[regexp {^p:} $x]} {
      if {[sizeof_collection [find -port $x -filter {@direction == output}]]} {
        continue
      }
    }
    set curr_inst $x
    regsub -all {\\(\.|\[|\])+} $curr_inst "@" curr_inst
    regsub -all {\[|\]} $curr_inst {\\&} curr_inst
    if {[regexp {^p:} $curr_inst] || ![regsub -all {\.} $curr_inst "." foo]} {
      set curr_inst "."
    } else {
      regsub {\.[^\.]+$} $curr_inst "." curr_inst
      if {[regexp {^t:} $curr_inst]} {
        regsub {(\.|.:)[^\.]+.$} $curr_inst "." curr_inst
      }
      regsub {^.} $curr_inst "." curr_inst
      regsub {\[|\]} $curr_inst {\\&} curr_inst
    }
#      set exp_str "expand -hier -level $level $cells $end_points -from \{$x\}"
    if {!$pin} {
      set exp_str "expand -hier -level $level -inst -from \{$x\}"
    } else {
      set exp_str "expand -hier -level $level -port -pin -inst -from \{$x\}"
    }
    if {![catch {set foo $expd_rslt}]} {
      set expd_rslt [add_to_list $expd_rslt [c_list [eval $exp_str]]]
#      set expd_rslt [add_to_collection $expd_rslt [eval $exp_str]]
    } else {
      set expd_rslt [c_list [eval $exp_str]]
#      set expd_rslt [eval $exp_str]
    }
    if {$level == 0 || $level > 1 } {
      set expd_rslt [buf_fwd $expd_rslt]
    }
#### Process collection (for each iteration) per filter options 
    if {!$clk_tree} {
      set expd_rslt [remove_from_list $expd_rslt $x]
#      set expd_rslt [remove_from_collection $expd_rslt $x]
    }
    set expd_rslt [clean_hier_p $expd_rslt]
    set expd_rslt [all_fan_filter "input" $expd_rslt $excl_bb $flat $curr_inst $clk_tree]
  }
#  if {[catch {set foo [c_list $expd_rslt]}]} {}
  if {[catch {set foo $expd_rslt}]} {
    return {}
  } else {
#    set expd_rslt [clean_hier_p [c_list $expd_rslt]]
    return [list [join $expd_rslt]]
  }
}

#######################################################################################
##### all_fanin    ####
#######################################################################################
proc all_fanin {args} {
  variable port
  variable pin
  variable inst
  variable seq

#  set opts_w_val_exp_s {(-to.*|-l.*|-tr.*)+}
#  set opts_no_val_exp_s {(-s.*|-ex.*|-b.*|-o.*|-fl.*)+}
  set opts_w_val_exp_s [get_opts_w_val_exp all_fanin]
  set opts_no_val_exp_s [get_opts_no_val_exp all_fanin]
  set thru_bufg 0

  if {[check_opt_help all_fanin $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all all_fanin $args]} {
    return 1
  }
#### Check for required options, -to
  if {![check_opt_l all_fanin {-to} $args]} {
    puts "@E: :Error, all_fanin, must specify -to <list>"
    return 1
  }
#### Assign values to variables while also checking validity of the value types
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set col 0
  set obj_l {} 
  set level 0
  set type "all"
  foreach x $opt_inx_l {
#### -to option
    if {[check_opt_is all_fanin {-to} [lindex $args $x]]} {
      set check [check_opt_val all_fanin {-to} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 2} {
        set col [lindex $args [expr $x + 1]]
      } elseif {$check == 1} {
        set obj_l [split [join [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]]]
        if {[lsearch -all -regexp $obj_l {^[^.:]{2,}}] ne {}} {
          puts "@E: :Error, all_fanin, objects require qualifiers {i:, t:, p:, n:}"
          return 1
        }
      } else {
        puts "@E: :Error, all_fanin, must be: -to <col or obj_list>"
        return 1
      }
    } 
#### -levels option
    if {[check_opt_is all_fanin {-levels} [lindex $args $x]]} {
      set check [check_opt_val all_fanin {-levels} [lindex $args [expr $x + 1]]]
      if {$check == 1} {
        set level [lindex $args [expr $x + 1]]
      } else {
        puts "@E: :Error, all_fanin, must be: -levels <int>"
        return 1
      }
    } 
#### -trace_arcs option
    if {[check_opt_is all_fanin {-trace_arcs} [lindex $args $x]]} {
      set check [check_opt_val all_fanin {-trace_arcs} [lindex $args [expr $x + 1]]]
      if {$check == 1} {
        set type [lindex $args [expr $x + 1]]
        if {$type eq "timing"} {
          puts "@W: : Warning, all_fanin, \"-trace_arcs timing\" not supported, defaulting to \"-trace_arcs all\" "
          set type "all"
        }
      } else {
        puts "@E: : Error, all_fanin, must be: -trace_arcs <all or timing>"
        return 1
      }
    }
  }
  set start_points ""
  set port 1
  set inst 0
  set seq 0
  set pin 1
  set excl_bb 0
  set break_bb 0
  set cells ""
  set flat 0
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  foreach x $opt_inx_l {
    if {[check_opt_is all_fanin {-startpoints_only} [lindex $args $x]]} {
      set start_points "-seq -port"
    }
    if {[check_opt_is all_fanin {-exclude_bboxes} [lindex $args $x]]} {
      set excl_bb 1
    }
    if {[check_opt_is all_fanin {-break_on_bboxes} [lindex $args $x]]} {
      set break_bb 1
    }
    if {[check_opt_is all_fanin {-only_cells} [lindex $args $x]]} {
      set cells "-inst"
    }
    if {[check_opt_is all_fanin {-flat} [lindex $args $x]]} {
      set flat 1
    }
  }
  if {$start_points ne "" && $cells ne ""} {
    set start_points "-seq"
    set cells ""
    set port 0
    set inst 0
    set pin 0
    set seq 1
  } elseif {$start_points ne "" && $cells eq ""} {
    set port 1
    set inst 0
    set pin 1
    set seq 1
  } elseif {$start_points eq "" && $cells ne ""} {
    set port 0
    set inst 1
    set seq 1
    set pin 0
  } elseif {$start_points eq "" && $cells eq ""} {
    set start_points "-port"
    set cells "-pin"
  }

#### Construct an expand command that will run for every element for -to <col or obj_list>.
#### The actual expand is always -flat (equivalent to expand -hier), but if -flat is not specified, only objects in the 
#### hierarchy of each start point are returned.  If -only_cells is NOT specified, only pins and ports are 
#### returned; nets are never returned.  If -flat is specified, don't return hierarchical ports.
####

  if {$col ne "0"} {
    set obj_l [c_list $col]
  }
  foreach x $obj_l {
    if {![regexp {^.:} $x] || ![sizeof_collection [find $x]]} {
      continue
    }
    if {[regexp {^p:} $x]} {
      if {[sizeof_collection [find -port $x -filter {@direction == input}]]} {
        continue
      }
    }
    set curr_inst $x
    regsub -all {\\(\.|\[|\])+} $curr_inst "@" curr_inst
    regsub -all {\[|\]} $curr_inst {\\&} curr_inst
    if {[regexp {^p:} $curr_inst] || ![regsub -all {\.} $curr_inst "." foo]} {
      set curr_inst "."
    } else {
      regsub {\.[^\.]+$} $curr_inst "." curr_inst
      if {[regexp {^t:} $curr_inst]} {
        regsub {(\.|.:)[^\.]+.$} $curr_inst "." curr_inst
      }
      regsub {^.} $curr_inst "." curr_inst
      regsub {\[|\]} $curr_inst {\\&} curr_inst
    }
#      set exp_str "expand -hier -level $level $cells $start_points -from \{$x\}"
    if {!$pin} {
      set exp_str "expand -hier -level $level -inst -to \{$x\}"
    } else {
      set exp_str "expand -hier -level $level -port -pin -inst -to \{$x\}"
    }
    if {![catch {set foo $expd_rslt}]} {
      set expd_rslt [add_to_list $expd_rslt [c_list [eval $exp_str]]]
#      set expd_rslt [add_to_collection $expd_rslt [eval $exp_str]]
    } else {
      set expd_rslt [c_list [eval $exp_str]]
#      set expd_rslt [eval $exp_str]
    }
    if {$thru_bufg} {
      set expd_rslt [buf_bkwd $expd_rslt]
    }
#### Process collection (for each iteration) per filter options 
    set expd_rslt [remove_from_list $expd_rslt $x]
    set expd_rslt [clean_hier_p $expd_rslt]
#    set expd_rslt [remove_from_collection $expd_rslt $x]
#    set expd_rslt [define_collection [clean_hier_p [c_list $expd_rslt]]]
    set expd_rslt [all_fan_filter "output" $expd_rslt $excl_bb $flat $curr_inst]
  }
#  if {[catch {set foo [c_list $expd_rslt]}]} {}
  if {[catch {set foo $expd_rslt}]} {
    return {}
  } else {
#    set expd_rslt [clean_hier_p [c_list $expd_rslt]]  ;#this was creating the list from the collection
    if {!$inst && $pin} {
      set expd_rslt [clean_inst $expd_rslt]
    }
    return [list [join $expd_rslt]]
  }
}


#####
##### Clean hier ports out where remove_from_collection failed
#####
proc clean_hier_p {p_list} {
  set ret_list {}
  foreach i $p_list {
    if {![regexp {\|p:} $i] && ![regexp {^p:.+\.} $i]} {
      set ret_list [linsert $ret_list end $i]
    }
  }
  return $ret_list
}

#####
##### Clean instances out where remove_from_collection failed
#####
proc clean_inst {p_list} {
  set ret_list {}
  foreach i $p_list {
    if {![regexp {i:} $i]} {
      set ret_list [linsert $ret_list end $i]
    }
  }
  return $ret_list
}

#####
##### Xilinx buf_thru
#####
proc buf_fwd {items} {
  set ret_list $items
#  set col [c_list $col]
#  foreach x $col {}
  foreach x $items {
    if {![regexp {^i:} $x]} {
      continue
    }
    if {[sizeof_collection [find -inst $x -filter {@inst_of == *BUF* && @syn_lib_cell}]]} {
      set exp_str "expand -hier -port -pin -inst -from \{$x\}"
#      set new_list [eval $exp_str]
      set new_list [c_list [eval $exp_str]]
      set new_list [remove_from_list $new_list $x]
#      set ret_list [add_to_collection $ret_list [buf_fwd $new_list]]
      set ret_list [add_to_list $ret_list [buf_fwd $new_list]]
    }
  }
  return $ret_list
}

proc buf_bkwd {col} {
  set ret_col [copy_collection $col]
  set col [c_list $col]
  foreach x $col {
    if {![regexp {^i:} $x]} {
      continue
    }
    if {[sizeof_collection [find -inst $x -filter {@inst_of == *BUF* && @syn_lib_cell}]]} {
      set exp_str "expand -hier -port -pin -inst -to \{$x\}"
      set new_col [eval $exp_str]
      set ret_col [add_to_collection $ret_col [buf_bkwd $new_col]]
    }
  }
  return $ret_col
}

proc remove_from_list {item_l item} {
  set inx [lsearch -all -exact $item_l $item]
  if {$inx == -1} {
    return $item_l
  }
  foreach x $inx {
    set item_l [lreplace $item_l $x $x]
  }
  return $item_l
}

proc add_to_list {item_l items} {
  foreach x $items {
    if {[lsearch -exact $item_l $x] != -1} {
      continue
    }
    set item_l [linsert $item_l end $x]
  }
  return $item_l
}

#############################################################################################
#####   fan filter   ####
#############################################################################################
proc all_fan_filter {dir col bbox flat curr_inst {clk 0}} {
  variable port
  variable pin
  variable inst
  variable seq
  variable in_c_fdc

  if {$dir eq "output"} {
    set op_dir "input"
  } else {
    set op_dir "output"
  }
  set ret_col $col
  foreach x  $col {
    set x_l $x
    regsub -all {\{|\}} $x_l "" x_l
#    if {![regexp {^.:} $x_l]} {
#      set ret_col [remove_from_collection $ret_col $x]
#      continue
#    }
    if {[regexp {^p:} $x_l]} {
      if {$dir eq "output"} {
        set port_c [find -port $x_l -filter {@direction == $output}]
      } else {
        set port_c [find -port $x_l -filter {@direction == $input}]
      }
      if {!$port || ([sizeof_collection $port_c] && !$clk)} {
        set ret_col [remove_from_list $ret_col $x]
        continue
      }
    }
    if {[regexp {^i:} $x_l]} {
      if {($bbox && [sizeof_collection [find -inst $x_l -filter {@is_black_box}]]) || \
          (!$inst && ![sizeof_collection [find -inst $x_l -filter {@is_sequential || @is_black_box}]]) || \
          (($pin || !$seq) && [sizeof_collection [find -inst $x_l -filter {@is_sequential || @is_black_box}]]) || \
           [sizeof_collection [find -inst $x_l -filter {@is_hierarchical == 1}]]} {
        set ret_col [remove_from_list $ret_col $x]
        continue
      }
    }
    if {[regexp {^t:} $x_l]} {
      if {!$pin} {
        set ret_col [remove_from_list $ret_col $x]
        continue
      } 
      if {$in_c_fdc && [sizeof_collection [find -pin $x_l -filter "@direction == $op_dir"]]} {
        regsub {t:(.+)\.[^\.]+$} $x_l {i:\1} foo
        if {[sizeof_collection [find -inst $foo -filter {!@is_hierarchical}]]} {
          set ret_col [remove_from_list $ret_col $x]
          continue
        }
      }
      if {($seq && ![sizeof_collection [find -inst [regsub {t:(.*)\.[^\.]+$} $x_l {i:\1}] -filter {@is_sequential || @is_black_box}]]) || \
          ($flat && [sizeof_collection [find -inst [regsub {t:(.*)\.[^\.]+$} $x_l {i:\1}] -filter {@is_hierarchical}]])} {
        set ret_col [remove_from_list $ret_col $x]
        continue
      }
    }
    if {!$flat} {
      regsub -all {\\(\.|\[|\])+} $x_l "@" x_l
      if {$curr_inst eq "."} {
        if {[regexp {^p:} $x_l]} {
          continue
        }
        if {[regexp {^i:} $x_l]} {
          if {[regsub -all {\.} $x_l {.} foo] == 0} {
            continue
          } else {
            set ret_col [remove_from_list $ret_col $x]
            continue
          }
        }
        if {[regexp {^t:} $x_l]} {
          if {[regsub -all {\.} $x_l {.} foo] == 1} {
            continue
          } else {
            set ret_col [remove_from_list $ret_col $x]
            continue
          }
        }
      } else {
        if {[regexp {^p:} $x_l]} {
          set ret_col [remove_from_list $ret_col $x]
          continue
        }
        if {[regsub $curr_inst $x_l "" foo]} {
          if {[regexp {^t:} $x_l]} {
            if {[regsub -all {\.} $foo {.} bar] <= 1} {
            } else {
              set ret_col [remove_from_list $ret_col $x]
            }
          } elseif {[regsub -all {\.} $foo {.} bar] != 0} {
            set ret_col [remove_from_list $ret_col $x]
          }
        } else {
          set ret_col [remove_from_list $ret_col $x]
        }
      }
    }
  }
  return  $ret_col
#  return  [define_collection $ret_col]
}
set in_c_fdc 0
############################################
####  FDC Template routines   ##############
############################################
  set fdc_template 0
  set inferred_clks 0
  set OnePass 0
  proc create_fdc_template {args} {
    variable fdc_template
    variable clocks_array
    variable prj_org
    variable fdc_template_file
    variable inferred_clks
    variable default_in_delay
    variable default_out_delay
    variable default_period
    variable no_io_delay
    variable no_clock_source
    variable OnePass
    
    set opts_no_val_exp_s [get_opts_no_val_exp create_fdc_template]
    set opts_w_val_exp_s [get_opts_w_val_exp create_fdc_template]

    if {[check_opt_help create_fdc_template $args]} {
      return 0
    }
#### Check that all in argument list are valid options
    if {![check_opt_all create_fdc_template $args]} {
      return 1
    }
#### Check for exclusive options
    if {[check_opt_excl create_fdc_template $args]} {
      puts "Error, command ignored"
      return 1
    }
    set inferred_clks 0
    set uniq 0
    set no_io_delay 0
    set no_clock_source 0
    set OnePass 0
    set default_in_delay 0
    set default_out_delay 0
    set default_period 10
#### Check for options with no value
    set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
    foreach x $opt_inx_l {
      if {[check_opt_is create_fdc_template {-uniquify} [lindex $args $x]]} {
        set uniq 1
      }
      if {[check_opt_is create_fdc_template {-no_io_delay} [lindex $args $x]]} {
        set no_io_delay 1
      }
      if {[check_opt_is create_fdc_template {-no_clock_source} [lindex $args $x]]} {
        set no_clock_source 1
      }
      if {[check_opt_is create_fdc_template {-one_pass} [lindex $args $x]]} {
        set OnePass 1
      }
    }
#### Check for options with value
    set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
    foreach x $opt_inx_l {
      if {[check_opt_is create_fdc_template {-in_delay} [lindex $args $x]]} {
        set check [check_opt_val create_fdc_template {-in_delay} [lindex $args [expr $x + 1]]]
        if {$check == 1} {
          set default_in_delay [lindex $args [expr $x + 1]]
        } else {
          puts "@E: : Error, create_fdc_template, must be -in_delay <float>"
          return 1
        }
      }
      if {[check_opt_is create_fdc_template {-out_delay} [lindex $args $x]]} {
        set check [check_opt_val create_fdc_template {-out_delay} [lindex $args [expr $x + 1]]]
        if {$check == 1} {
          set default_out_delay [lindex $args [expr $x + 1]]
        } else {
          puts "@E: : Error, create_fdc_template, must be -out_delay <float>"
          return 1
        }
      }
      if {[check_opt_is create_fdc_template {-period} [lindex $args $x]]} {
        set check [check_opt_val create_fdc_template {-period} [lindex $args [expr $x + 1]]]
        if {$check == 1} {
          set default_period [lindex $args [expr $x + 1]]
        } else {
          puts "@E: : Error, create_fdc_template, must be -period <float>"
          return 1
        }
      }
    }

    cd [project -dir]
    set_option -constraint -clear
    set_option -fpga_constraint ""
#    set_option -hdl_qload 0
    set dist 0
    catch {set dist [get_option -distributed_synthesis]}
    catch {set_option -distributed_synthesis 0}
    set_option -run_prop_extract 1
    set_option -fast_synthesis 1
    project -save [project_data -file]
    if {$uniq} {
      uniquify
    }
    catch {unset clocks_array}
    cd [project -dir]
    set top [top_result]
    set fdc_template 1
    set fdc_template_file "" 
    set stat [check_fdc_query]
    if {$stat} {
      puts "ERROR:  create_fdc_template failed"
      set fdc_template 0
      return 1
    }
    if {$inferred_clks != 0} {
      puts "Run 2nd pass..."
      catch {unset clocks_array}
      set fdc_template_file "" 
      set stat [check_fdc_query]
      if {$stat} {
        puts "ERROR:  create_fdc_template failed"
        set fdc_template 0
        return 1
      }
    }
    set temp_sdc_file [space_clean_file [impl -dir] "${top}_template.sdc"]
    add_file -constraint $temp_sdc_file
    sdc2fdc
    set fdc_template 0
    project_file -remove $temp_sdc_file
    catch {set_option -distributed_synthesis $dist}
    if {$uniq} {
      if {[catch {file delete -force [impl -dir]/synwork}]} {
        puts "WARNING:  Could not delete [impl -dir]/synwork."
      }
      project -close [project_data -file] 
      project -load $prj_org 
      if {$fdc_template_file ne ""} {
        add_file -fpga_constraint $fdc_template_file
      }
    }
  }

  proc uniquify {} {
    variable prj_org
    cd [impl -dir]
    set prj_org [project_data -file]
    regsub {(.*)\.prj} $prj_org {\1_fdc.prj} prj_bak
    set_option -run_prop_extract 1
    project -run -fg compile
    after 3000
#    set rslt [impl -result_file]
    set top [top_result]
#    regsub {\....$} $rslt {.srs} srs
    open_file [impl -dir]/${top}.srs
    after 3000
    select -instances
    filter
    save_netlist -filtered  [impl -dir]/fdc_temp.srs
    file_close [impl -dir]/${top}.srs
    catch {project_file *.v -remove}
    catch {project_file *.sv -remove}
    catch {project_file *.vh* -remove}
    catch {project_file *.srs -remove}
    catch {project_file *.edn -remove}
    catch {project_file *.ndf -remove}
    catch {project_file *.ngc -remove}
    catch {project_file *.ngo -remove}
    add_file -syn [impl -dir]/fdc_temp.srs
#    set_option -result_file $rslt
    project -save $prj_bak
    puts "New uniquified project file: $prj_bak"
  }

#######
  proc remove_comb {c_pins} {
    set r_list {}
    foreach x $c_pins {
      regsub -all {\{|\}} $x "" y
      regexp {(.*)(\.[^\.]+)$} $y b z a
      regsub {t:} $z {i:} y
      if {[sizeof_collection [find -hier -inst $y -filter {@syn_lib_cell == 1 || @is_sequential || @inst_of == *altpll*}]]} {
          set r_list [linsert $r_list end $x]
      }
    }
    return [define_collection $r_list]
  }

set flip_none 0
#######
  proc clk_seq {all_seq_c x_exp {edge ""}} {
    variable multi_clk
    variable multi_cnt
    variable flip_none

    if {$flip_none} {
      set none [find 1]
    } else {
      set none [copy_collection $all_seq_c]
    }
    set ret_l {}
    foreach x [get_object_name $all_seq_c] {
      set clk_l [get_prop -prop clock $x]
      set edge_l [get_prop -prop clock_edge $x]
      if {[regsub -all {,} $clk_l "" clk_l]} {
        incr multi_clk
        incr multi_cnt
        regsub -all {,} $edge_l "" edge_l
      }
      set clk_l [split $clk_l]
      set edge_l [split $edge_l]
      set inx [lsearch -exact $clk_l $x_exp]
      if {$inx != -1} {
        if {$edge ne ""} {
          if {[lindex $edge_l $inx] ne $edge} {
            continue
          }
        }
        set ret_l [linsert $ret_l end $x]
      }
    }
    if {[llength $ret_l]} {
      return [define_collection $ret_l]
    } else {
      return $none
    }
  }

####  go thru clock gating or keepbuf
  proc thru_clk_gate {net_i filter {excl ""}} {
    variable break_to_top
    if {$break_to_top} {
      return {}
    }
    set cell_l {}
    set pin_l {}
    set keeps_l [c_list [find -hier -inst * -in [expand -hier -level 1 -inst -from $net_i] -filter {!@is_hierarchical}]]
    if {$excl ne ""} {
      set keeps_l [remove_from_list $keeps_l $excl]
    }
    set get_exp "get_nets"
    foreach c $keeps_l {
      if {[get_prop -prop is_keepbuf $c] ne "<nil>" || ([get_prop -prop is_clock_gating $c] ne "<nil>" && [get_prop -prop is_sequential $c] eq "<nil>") || [get_prop -prop inst_of $c] eq "buf"} {
        set cell_l [add_to_list $cell_l $c]
        set tmp_p [get_pins -of_objects $c -filter {@direction == output}]
        if {[llength [object_list $tmp_p]]} {
          regsub -all {\\} $pin_l {\\\\} pin_l
          set pin_l [add_to_list $pin_l $tmp_p]
          regsub -all {\{|\}} $pin_l "" pin_l
          set get_exp "get_nets -of_objects \{$pin_l\} -filter \{$filter\}"
          set tmp_n [get_nets -of_objects $tmp_p]
          if {[llength [object_list $tmp_n]]} {
            set tmp_c [thru_clk_gate $tmp_n $filter $c]
            if {$tmp_c ne "{}"} {
              set cell_l [add_to_list $cell_l $tmp_c]
            }
          }
        }
      }
    }
    if {[llength [object_list [eval $get_exp]]]} {
     set break_to_top 1
    }
    return $cell_l
  }

####  Check if leaf net is part of clock name
  proc check_clk_net {clk net} {
    regsub -all {\\\.} $net "@" net
    if {[regexp {\.} $net]} {
      regsub {n:.+\.([^\.]+)$} $net {\1} net
    }
    regsub -all {@} $net {_} net
    regsub {(^.+)(\[.+\])$} $net {\1.+\2} net
    regsub -all {\[|\]} $net {\\&} net
    return [regexp $net $clk]
  }

####  Pick the item from the list that is the longest string
  proc get_strg_long {item_l} {
    set ret_i [lindex $item_l 0]
    set len [string length $ret_i]
    foreach i $item_l {
      if {[string length $i] > $len} {
        set ret_i $i
      }
    }
    return $ret_i
  }

####  Clear out pins from the list that are not potential sources of the 
####  clock being sought after
  proc filter_pins_for {pin_l filter clk} {
    variable break_to_top
    set ret_l $pin_l
    set l_size [llength $pin_l]
    set net_match 0
    foreach p $pin_l {
      if {[regexp {^p:} $p]} {
        if {[regexp {\[[0-9]+:[0-9]+\]} $p] || [get_prop -prop direction $p] ne "input"} {
          set ret_l [remove_from_list $ret_l $p]
        }
        continue
      }
      set nets_exp "expand -level 1 -net -from \{$p\}"
      set nets [eval $nets_exp]
      set nets [c_list $nets]
      set nets [get_strg_long $nets]
      if {[get_prop -prop clock $nets] eq "<nil>"} {
#### if here, could be a keepbuf or some other cell blocking; try to jump it
        set break_to_top 0
        set net_match [check_clk_net $clk $nets]
        if {!($l_size > 1 && !$net_match)} {
          set keeps_l [thru_clk_gate $nets $filter]
        } else {
          set keeps_l [object_list [get_cells -of_objects $nets -filter {!@is_hierarchical}]]
          if {[llength $keeps_l]} {
            foreach k $keeps_l {
              set n [get_pins -of_objects $k -filter {@direction == output}]
              if {[llength [object_list $n]]} {
                regsub -all {\{|\}} $n "" n
                set get_exp "get_nets -of_objects \{$n\} -filter \{$filter\}"
                if {[llength [object_list [eval $get_exp]]]} {
                  set break_to_top 1
                  break
                }
              }
            }
          }
        }
        if {!$break_to_top} {
          set ret_l [remove_from_list $ret_l $p]
        }
        continue
      }
      if {[llength $nets]} {
        set find_exp "find -hier -net * -in \[define_collection \{$nets\}\] -filter \{$filter\}"
      } else {
        set find_exp "find 1"
      }
      if {[sizeof_collection [eval $find_exp]]} {
        continue
      } else {
        set ret_l [remove_from_list $ret_l $p]
      }
    }
    return $ret_l
  }

####  find all potential sources for the clock alias
  proc get_clock_source {clk {all 0}} {
    variable in_c_fdc
    variable no_clk_src_msg
    regsub {c:} $clk "" clk
    set clk_keep $clk
    set is_derived [regexp {derived_clock} $clk]
    regsub {\|} $clk "?" clk
#    regsub {.+\?(.+)_derived_clock.*} $clk {\1} net_strg
    regsub {.+\?(.+)(_derived_clock$|_derived_clock.*(\[.+\]*)$)} $clk {\1\3} net_strg
    set filter "@clock == $clk || @clock == \"$clk,*\" || @clock == \"*, $clk,*\" || @clock == \"*, $clk\""
    set find_exp ""
    if {$net_strg ne $clk} {
####  If here, we're looking for a derived clock; find a collection of nets that could lead to 
####  the source by decoding the clock name (above regsub)
      set find_exp "find -hier -net \{$net_strg\}"
      set foo_n [eval $find_exp]
      if {![sizeof_collection $foo_n]} {
        set find_exp ""
      }
    }
    if {$find_exp eq ""} {
      set find_exp "find -hier -net * -filter \{$filter\}"
      set foo_n [eval $find_exp]
    }
    if {[sizeof_collection $foo_n]} {
      set in_c_fdc 1
      set foo_n [get_object_name $foo_n]
      for {set i 0} {1} {incr i} {
        set foo1_n [lindex $foo_n $i]
        if {$foo1_n eq ""} {
          break
        }
        if {![sizeof_collection [find $foo1_n]]} {
          continue
        }
        set bar_p [split [join [all_fanin -to $foo1_n -start -flat]]]
        set bar1_p [lindex $bar_p 0]
        regsub {^.:} $bar1_p "" bar1_p
        if {[sizeof_collection [find -port $bar1_p -filter {@direction == inout}]]} {
          continue
        }
        set in_c_fdc 0
        set bar_p [filter_pins_for $bar_p $filter $clk]
        if {[llength $bar_p]} {
##  check if true source when dealing with derived_clock
          if {$is_derived} {
            set out_break 0
            foreach p $bar_p {
              regsub {t:(.+)\.[^\.]+$} $p {i:\1} inst
              set inst [get_parent_cell $inst]
              set v [get_prop -prop inst_of $inst]
              regsub -all {\[|\]} $v {\\&} v
              set exp "\{^$v\}"
              set exp "regsub $exp \{$clk_keep\} \{&\} clk_keep"
              if {[eval $exp]} {
                set out_break 1
                break
              }
            }
            if {$out_break} {
              break
            }
          } else {
            break
          }
        }
      }
      unset foo_n
      if {$all} {
        return $bar_p
      } else {
        if {[llength $bar_p] > 1} {
          set bar_mod $bar_p
          foreach b $bar_p {
            if {[regsub {p:} $b "" c]} {
              set port 1
              if {[sizeof_collection [find -port $b -filter {@direction == inout}]] || $is_derived} {
                set bar_mod [remove_from_list $bar_mod $b]
                continue
              }
            } else {
              regsub {.:} $c "" c
              set port 0
            }
            if {[get_prop -prop direction $b] eq "output" || [sizeof_collection [find -port $c]]} {
              if {$port || [lindex [filter_pins_for [list $b] $filter $clk] 0] eq $b} {
                return $b
              }
            }
          }
          if {!$no_clk_src_msg} {
            puts "Warning, get_clock_source; can't isolate a source pin."
            puts "Possible objects:"
            puts "$bar_mod"
          }
          return "<unknown>"
        } else {
          if {[regexp {p:} $bar_p]} {
            return [lindex $bar_p 0]
          }
          if {[llength $bar_p]} {
            return [lindex $bar_p 0]
          } else {
            return "<unknown>"
          }
        }
      }
    } else {
      return "<unknown>"
    }
  }

  proc get_parent_cell {i} {
    set rtl [get_prop -prop rtl_name $i]
#    set hier_rtl [get_prop -prop hier_rtl_name $i]
    regsub {i:} $i "" hier_rtl
    regsub -all {\\} $rtl {\\\\} rtl
    regsub -all {\[|\]} $rtl {\\&} rtl
    set exp "\{\\.$rtl\}"
    set exp "regsub $exp \{$hier_rtl\} \"\""
    return [eval $exp]
  }

  proc build_port_c {c_port c_add_port} {
    set l_port [get_object_name $c_port]
    set l_add_port [get_object_name $c_add_port]
    foreach x $l_add_port {
      if {[lsearch -exact $l_port $x] == -1} {
        set l_port [linsert $l_port end $x]
      }
    }
    return [define_collection $l_port]
  }

set no_clk_src_msg 0
#######   Input ports and clock groups
  proc in_ports_per_clk {clk_list all_seq fpo1} {
    variable clocks_array
    variable ibufs
    variable multi_clk
    variable multi_cnt
    variable default_in_delay
    variable no_io_delay
    variable no_clock_source
    variable no_clk_src_msg
    variable regs_c
  
    set clock_name [lindex $clk_list 0]
    set multi_cnt 0
    set unknown 0
    set c_port [find -port $clock_name]
    set port_c [find -port $clock_name]
    foreach x $clk_list {
      set skip_io 0
      set multi_clk 0
      set d_clk_found 0
      regsub {\|} $x "?" x_exp
      set all_seq1 [find -hier -seq * -in $all_seq -filter "@clock == *$x_exp* && !@is_clock_gating"]
      if {[sizeof_collection $all_seq1] == 0} {
        set all_seq1 [find -hier -seq * -in $regs_c -filter "@clock == *$x_exp* && !@is_clock_gating"]
        set skip_io 1
      }
    #### First try to find a source object of a derived clock
      if {[sizeof_collection $all_seq1] && [regexp {derived_clock} $x]} {
        set all_seq1 [clk_seq $all_seq1 $x]
        if {$no_clock_source} {
          set clk_src "<unknown>"
        } else {
          set no_clk_src_msg 1
          set clk_src [get_clock_source $x 0]
          regsub -all {\\} $clk_src {\\\\} clk_src
          set no_clk_src_msg 0
          if {!$unknown && [regexp {<unknown>} $clk_src]} {
            set unknown 1
          }
        }
  #      set clk_src [split [join [all_fanin -to [find -hier -net * -filter "@clock == $x_exp"] -start -flat]]]
        set clocks_array($x,object) [lindex $clk_src 0]
        set d_clk_found 1
      }
      if {!$no_io_delay && !$skip_io} {
        foreach y [c_list $all_seq1] {
          if {![sizeof_collection [find $y]]} {
            continue
          }
          catch {unset ports}
          set ports [expand -hier -port -to $y]
          set ports [clear_hier_ports $ports]
          set ports_1 {}
          set do_lib 0
          if {$ibufs} {
            if {[sizeof_collection [find  -hier -inst * -in [expand -hier -inst -to $y] -filter {@inst_of == IBUF* || @inst_of == IOBUF*}]]} {
              set do_lib 1
            }
          }
          if {$ports eq {} || $do_lib} {
            regsub -all {\{|\}} $y "" y_pins
            regsub {i:} $y_pins "t:" y_pins 
            regsub {.*} $y_pins {&.*} y_pins
            if {[sizeof_collection [find  -pin $y_pins -filter {!@clock}]]} {
              set cells [find  -hier -inst * -in [expand -hier -inst -to [find  -pin $y_pins -filter {!@clock}]] -filter {@syn_lib_cell == 1}]
            } else {
              set cells [find 1]
            }
            if {[llength [get_object_name $cells]] > 0} {
              set ports_1 [back_to_ports $cells]
            } else {
              set ports_1 {}
            }
          }
          if {$ports ne {}} {
            if {[llength [get_object_name $ports]] > 0} {
  #            set c_port [define_collection $c_port $ports]
              set c_port [build_port_c $c_port $ports]
            }
          }
          if {$ports_1 ne {}} {
            set c_port [build_port_c $c_port $ports_1]
  #          set c_port [define_collection $c_port $ports_1]
          }
        }
      }
      if {$x ne $clock_name && $d_clk_found} {
        if {![catch {set foo $clocks_array($x,object)}]} {
          set foo_org $foo
          if {[regexp {^t:.*\.Q\[[0-9]+\]} $foo] && [sizeof_collection [find -pin $foo]]} {
            set foo [get_object_name [expand -level 1 -net -from $foo]]
            regsub -all {\{|\}} $foo "" foo
            set bar 1
          } else {
            set bar 0
          }
          if {$multi_clk} {
            puts $fpo1 "###            $x *  Clock Object: \{$foo_org\}"
          } else {
            puts $fpo1 "###            $x    Clock Object: \{$foo_org\}"
          }
          if {$bar} {
            puts $fpo1 "set_clock_groups -disable -asynchronous -name \{${x}_group\} -group \[get_clocks -of_objects \[get_nets \{$foo\}\]\] \
                -comment \{Derived clock $x from source clock $clock_name\}"
          } else {
            puts $fpo1 "set_clock_groups -disable -asynchronous -name \{${x}_group\} -group \[get_clocks -of_objects \[get_pins \{$foo\}\]\] \
                -comment \{Derived clock $x from source clock $clock_name\}"
          }
        }
      } elseif {$x eq $clock_name} {
        if {$multi_clk} {
          set astrix "*"
        } else {
          set astrix ""
        }
        puts $fpo1 "### Individual \"set_clock_groups\" commands for all \"$clock_name\" derived clocks"
        puts $fpo1 "### appear at the end of this file.  Enabling a given command will make the"
        puts $fpo1 "### given clock asynchronous to all other clocks.  If a given clock (below) does not"
        puts $fpo1 "### appear in the final Performance Summary (in the *.srr file after synthesis),"
        puts $fpo1 "### the clock may have been optimized away due to Gated/Generated Clock Conversion."
        puts $fpo1 "### See the \"CLOCK OPTIMIZATION REPORT\" in the *.srr file."
        puts $fpo1 "### Below is a list of any clocks derived from \"$clock_name\":"
        puts $fpo1 "set_clock_groups -disable -asynchronous -name \{${clock_name}_group\} -group \{$clock_name\} -comment \{Source clock $clock_name group\}"
        puts $fpo1 "###  ${clock_name}$astrix DERIVED CLOCKS:"
      }
    }
    if {$multi_cnt} {
      puts $fpo1 "###"
      puts $fpo1 "###  * Multiple clocks are clocking some or all elements in this clock domain."
      puts $fpo1 "###    The \"-of_objects\" argument in the example \"set_clock_groups\" command"
      puts $fpo1 "###    for this clock should be verified for correctness."
    }
    if {$unknown} {
      puts $fpo1 "###"
      puts $fpo1 "###  <unknown>:  A single clock source object was not found for these derived clocks.  From the Tcl"
      puts $fpo1 "###              shell, you can try the following to list any possible candidates for the clock object:"
      puts $fpo1 "###              % get_clock_source <clock_name>"
    }
    set c_port [remove_from_collection $c_port $port_c]
    set port_c [get_object_name $port_c]
    regsub -all {\{|\}} $port_c "" port_c
    regsub -all {p:} $port_c "c:" port_c
    foreach x [c_list $c_port] {
      puts $fpo1 "define_input_delay \{$x\} $default_in_delay -ref \{${port_c}:r\}"
    }
    return
  }
  
#####
  proc out_ports_per_clk {clk_list all_seq fpo1} {
    variable obufs
    variable default_out_delay
    variable no_io_delay

    if {$no_io_delay} {return}
    set c_port [find -port [lindex $clk_list 0]]
    set port_c [find -port [lindex $clk_list 0]]
  
    foreach x $clk_list {
      regsub {\|} $x "?" x_exp
      set all_seq1 [find  -hier -seq * -in $all_seq -filter "@clock == *$x_exp*"]
      set all_seq1 [clk_seq $all_seq1 $x]
      foreach y [c_list $all_seq1] {
        if {![sizeof_collection [find $y]]} {
          continue
        }
        set ports [expand -hier -port -from $y]
        set ports [clear_hier_ports $ports]
        set ports_1 {}
        set do_lib 0
        if {$obufs} {
          if {[sizeof_collection [find -hier  -inst * -in [expand -hier -inst -from $y] -filter {@inst_of == OBUF* || @inst_of == IOBUF*}]]} {
            set do_lib 1
          }
        }
        if {$ports eq {} || $do_lib} {
          set cells [find  -hier -inst * -in [expand -hier -inst -from $y] -filter {@syn_lib_cell == 1}]
          if {[llength [get_object_name $cells]] > 0} {
            set ports_1 [fwd_to_ports $cells]
          } else {
            set ports_1 {}
          }
        }
        if {$ports ne {}} {
          if {[llength [get_object_name $ports]] > 0} {
#            set c_port [define_collection $c_port $ports]
            set c_port [build_port_c $c_port $ports]
          }
        }
        if {$ports_1 ne {}} {
#          set c_port [define_collection $c_port $ports_1]
          set c_port [build_port_c $c_port $ports_1]
        }
      }
    }
    set c_port [remove_from_collection $c_port $port_c]
    set port_c [get_object_name $port_c]
    regsub -all {\{|\}} $port_c "" port_c
    regsub -all {p:} $port_c "c:" port_c
    foreach x [c_list $c_port] {
      puts $fpo1 "define_output_delay \{$x\} $default_out_delay -ref \{${port_c}:r\}"
    }
    return
  }

######
  proc clear_hier_ports {ports} {
    set new_list {}
    foreach x [get_object_name $ports] {
      regsub -all {\{|\}} $x "" x
      if {[regexp {^p:} $x] && ![regexp {\.} $x]} {
        set new_list [linsert $new_list end $x]
      }
    }
    if {[llength $new_list] > 0} {
      return [define_collection $new_list]
    } else {
      return $new_list
    }
  }
  
######
  proc back_to_ports {cells} {
    set new_list {}
    foreach x [get_object_name $cells] {
      if {![sizeof_collection [find -inst $x]]} {
        continue
      }
      set ports [expand -hier -port -to $x]
      set ports [clear_hier_ports $ports]
      regsub -all {\{|\}} $x "" x_pins
      regsub {i:} $x_pins "t:" x_pins 
      regsub {.*} $x_pins {&.*} x_pins
      if {[sizeof_collection [find -pin $x_pins -filter {!@clock}]]} {
        set cells_1 [find -hier -inst * -in [expand -hier -inst -to [find -pin $x_pins -filter {!@clock}]] -filter {@syn_lib_cell == 1}]
      } else {
        set cells_1 [find 1]
      }
      set cells_1a [find -hier -inst * -in [expand -hier -inst -from $x] -filter {@syn_lib_cell == 1}]
      if {[sizeof_collection $cells_1] > 0} {
        set cells_1 [remove_from_collection $cells_1 $x]
      }
      if {[sizeof_collection $cells_1a] > 0} {
        set cells_1a [remove_from_collection $cells_1a $x]
      }
      if {[lsearch -exact [get_object_name $cells_1a] [lindex [get_object_name $cells_1] 0]] != -1} {
        continue
      }
      if {[llength [get_object_name $cells_1]] > 0} {
        set ports_1 [back_to_ports $cells_1]
      } else {
        set ports_1 {}
      }
      if {$ports ne {}} {
        if {[llength [get_object_name $ports]] > 0} {
          if {$new_list eq {}} {
            set new_list [define_collection $ports]
          } else {
            set new_list [c_union $new_list [define_collection $ports]]
          }
        }
      }
      if {$ports_1 ne {}} {
        if {$new_list eq {}} {
          set new_list [define_collection $ports_1]
        } else {
          set new_list [c_union $new_list [define_collection $ports_1]]
        }
      }
    }
    return $new_list
  }
  
  
  
  proc fwd_to_ports {cells} {
    set new_list {}
    foreach x [get_object_name $cells] {
      if {![sizeof_collection [find -inst $x]]} {
        continue
      }
      set ports [expand -hier -port -from $x]
      set ports [clear_hier_ports $ports]
      regsub -all {\{|\}} $x "" x_pins
      regsub {i:} $x_pins "t:" x_pins 
      regsub {.*} $x_pins {&.*} x_pins
      set cells_1 [find  -hier -inst * -in [expand -hier -inst -from $x] -filter {@syn_lib_cell == 1}]
      if {[sizeof_collection [find -pin $x_pins -filter {!@clock}]]} {
        set cells_1a [find  -hier -inst * -in [expand -hier -inst -to [find -pin $x_pins -filter {!@clock}]] -filter {@syn_lib_cell == 1}]
      } else {
        set cells_1a [find 1]
      }
      if {[sizeof_collection $cells_1] > 0} {
        set cells_1 [remove_from_collection $cells_1 $x]
      }
      if {[sizeof_collection $cells_1a] > 0} {
        set cells_1a [remove_from_collection $cells_1a $x]
      }
      if {[lsearch -exact [get_object_name $cells_1a] [lindex [get_object_name $cells_1] 0]] != -1} {
        continue
      }
      if {[llength [get_object_name $cells_1]] > 0} {
        set ports_1 [fwd_to_ports $cells_1]
      } else {
        set ports_1 {}
      }
      if {$ports ne {}} {
        if {[llength [get_object_name $ports]] > 0} {
          if {$new_list eq {}} {
            set new_list [define_collection $ports]
          } else {
            set new_list [c_union $new_list [define_collection $ports]]
          }
        }
      }
      if {$ports_1 ne {}} {
        if {$new_list eq {}} {
          set new_list [define_collection $ports_1]
        } else {
          set new_list [c_union $new_list [define_collection $ports_1]]
        }
      }
    }
    return $new_list
  }

############################################
####  Fix for XDC, CGC w/ GCC  #############
############################################
  proc fix_cgc_xdc {} {
    set top [top_result]
    if {[regexp {\.edf$} [g_opt result_file]]} {
      set xdc_file "[g_impl_dir]/${top}_edif.xdc"
    } else {
      set xdc_file "[g_impl_dir]/${top}.xdc"
    }
    set xdc_file_fix "[g_impl_dir]/${top}_cgc_fix.xdc"
    if {![file exists $xdc_file]} {
      puts "ERROR:  Could not find XDC file $xdc_file"
      return 1
    }
    if {[catch {open $xdc_file r} fpi_xdc]} {
      puts "ERROR:  Can't open $xdc_file for reading"
      return 1
    }
    if {[catch {open $xdc_file_fix w} fpo_xdc]} {
      puts "ERROR:  Can't open $xdc_file_fix for writing"
      return 1
    }
    while {![eof $fpi_xdc]} {
      gets $fpi_xdc line
      if {![regexp {^\s*create_generated_clock .*SYNOPSYS_XDC_} $line]} {
        puts $fpo_xdc $line
      } else {
        if {[regexp {IS_LEAF == FALSE} $line]} {
          puts $fpo_xdc $line
          continue
        }
        regsub -all {\[\s} $line {[} line
        set start_i [string first "\[get_pins -filter" $line]
        set end_i [string first "\]\]" $line $start_i]
        incr end_i
        set seg [string range $line $start_i $end_i]
        set seg "\[get_pins -of_objects \[get_nets -of_objects ${seg}\] -filter {IS_LEAF == FALSE}\]" 
        set line [string replace $line $start_i $end_i $seg]
        puts $fpo_xdc $line
        gets $fpi_xdc line
        gets $fpi_xdc line
      }
    }
    close $fpi_xdc
    close $fpo_xdc
    if {[catch {file delete $xdc_file}]} {
      puts "ERROR:  Could not overwrite $xdc_file"
      return 1
    }
    file rename $xdc_file_fix $xdc_file
  }
#
# This procedure (prepend) is used implement commands like get_clocks e.g.:
# given a prefix "c:" and an argument list "A { B C } D"
# return a string "c:A c:B c:D". These commands should really be doing netlist 
# searches to get collections of objects instead of calling this procedure.
# 
# If a name is in curly braces, we need to preserve escapes and special characters.
# If a name already has a qualifier, do not add another one.
#
#
proc prepend { pretext strings } {

	set output ""
    regsub -all {\{\s+} $strings "{" strings
    regsub -all {\s+\}} $strings "}" strings

	# each argument is one or more names

	# for each argument
	while { [expr [llength $strings] > 0] } {
		set substring [lindex $strings 0]
		set strings [lrange $strings 1 end]

		# for convenience,
		# replace any spaces and tabs with exactly one space before each name
		set substring " $substring"
		set substring [regsub -all {\s\s*} $substring " " ]
		set substring [string trimright  $substring ]

		# for each name in the argument
		for {set i 0 } { $i >= 0 } { set i [string first " " $substring $i ] } {
			if { [regexp -start $i {\A\s[abpivtncs]:} $substring] } {
				# already has a prefix
			} elseif { [regexp -start $i {\A\s\S*\|[abpivtncs]:} $substring] } {
				# already has a prefix (ugly version)
			} else {
				# prepend name with qualifier
				set substring [string replace $substring $i $i " $pretext" ] 
			}
			incr i
		}
                regsub -all " ${pretext}\{" $substring " \{${pretext}" substring
		# add the results for this argument to that for other arguments
		set output "$output $substring"
	}

	# remove extra spaces
	set output [regsub -all {\s\s*} $output " " ]
	return [string trim $output]

}

#######################################################################################
##### all_registers    ####
#######################################################################################
proc all_registers { args } {
  variable flip_none 

  set opts_w_val_exp_s [get_opts_w_val_exp all_registers]
  set opts_no_val_exp_s [get_opts_no_val_exp all_registers]

  if {[check_opt_help all_registers $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all all_registers $args]} {
    return 1
  }
  check_opt_ignore all_registers $args

#### Assign values to variables while also checking validity of the value types
#### The list of registers to filter is based on the thee clock options
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set clk ""
  set rclk ""
  set fclk ""
  set clk_keep ""
  set rclk_keep ""
  set fclk_keep ""
  set find_f 0
  foreach x $opt_inx_l {
#### -clock option
    if {[check_opt_is all_registers {-clock} [lindex $args $x]]} {
      set check [check_opt_val all_registers {-clock} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set clk [join [lindex $args [expr $x + 1]]]
        regsub {c:} $clk "" clk
        set clk_keep $clk
        regsub {\|} $clk "?" clk
        regsub {(.*)} $clk {@clock == *\1*} clk
        set find_f 1
      } else {
        puts "Error, all_registers -clock, no clock string specified"
        return 1
      }
    } 
#### -rise_clock option
    if {[check_opt_is all_registers {-rise_clock} [lindex $args $x]]} {
      set check [check_opt_val all_registers {-rise_clock} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set rclk [join [lindex $args [expr $x + 1]]]
        regsub {c:} $rclk "" rclk
        set rclk_keep $rclk
        regsub {\|} $rclk "?" rclk
        regsub {(.*)} $rclk {|| @clock == *\1* \&\& @clock_edge == *rise*} rclk
        set find_f 1
      } else {
        puts "Error, all_registers -rise_clock, no clock string specified"
        return 1
      }
    } 
#### -fall_clock option
    if {[check_opt_is all_registers {-fall_clock} [lindex $args $x]]} {
      set check [check_opt_val all_registers {-fall_clock} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set fclk [join [lindex $args [expr $x + 1]]]
        regsub {c:} $fclk "" fclk
        set fclk_keep $fclk
        regsub {\|} $fclk "?" fclk
        regsub {(.*)} $fclk {|| @clock == *\1* \&\& @clock_edge == *fall*} fclk
        set find_f 1
      } else {
        puts "Error, all_registers -fall_clock, no clock string specified"
        return 1
      }
    } 
  }
  set hier "-hier"
  set seq 0
  set pin 0
  set outp ""
  set datap ""
  set clkp ""
#  set clk_filt_exp ""
#  set pin_filt_exp ""
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  foreach x $opt_inx_l {
    if {[check_opt_is all_registers {-no_hierarchy} [lindex $args $x]]} {
      set hier ""
    }
    if {[check_opt_is all_registers {-cells} [lindex $args $x]]} {
      set seq 1
    }
    if {[check_opt_is all_registers {-data_pins} [lindex $args $x]]} {
      set pin 1
      set datap "|| @direction == input && !@clock"
    }
    if {[check_opt_is all_registers {-clock_pins} [lindex $args $x]]} {
      set pin 1
      set clkp "@clock"
    }
    if {[check_opt_is all_registers {-output_pins} [lindex $args $x]]} {
      set pin 1
      set outp "|| @direction == output"
    }
  }
  if {!$pin} {
    set seq 1
  }
  if {$find_f} {
    set clk_filt_exp "\{$clk $rclk $fclk\}"
    regsub {\{\s*\|\| } $clk_filt_exp "\{" clk_filt_exp
    set find_str "find $hier -seq * -filter $clk_filt_exp"
#    set clk_s [get_clock_source $clk_keep]
#    if {$clk_s eq "{}" || $clk_s eq "<unknown>"} {
#      puts "Error, all_registers, no clock source found"
#      return 1
#    }
#    set expd_str "\[expand $hier -seq -from \{$clk_s\}\]"
#    set find_str "find -seq * -in $expd_str -filter $clk_filt_exp"
  } else {
    set find_str "find $hier -seq *"
  }
  set all_seq [eval $find_str]
  if {$find_f} {
    set flip_none 1
    if {$clk ne ""} {
      set all_seq [clk_seq $all_seq $clk_keep]
    }
    if {$rclk ne ""} {
      set all_seq [clk_seq $all_seq $rclk_keep "rise"]
    }
    if {$fclk ne ""} {
      set all_seq [clk_seq $all_seq $fclk_keep "fall"]
    }
    set flip_none 0
  }
  set all_pin {}
  if {$pin && [sizeof_collection $all_seq]} {
    set pin_filt_exp "\{$clkp $datap $outp\}"
    regsub {\{\s*\|\| } $pin_filt_exp "\{" pin_filt_exp
    set find_pin_str "get_pins -of_objects $all_seq -filter $pin_filt_exp" 
#puts "FIND_PINS: $find_pin_str"
    set all_pin [split [join [eval $find_pin_str]]]
    if {[llength $all_pin]} {
      if {$seq} {
        return [list [join [get_object_name [add_to_collection $all_seq $all_pin]]]]
      } else {
        return $all_pin
      }
    } else {
      if {$seq} {
        return [list [join [get_object_name $all_seq]]]
      } else {
        return {}
      }
    } 
  }
  if {![sizeof_collection $all_seq]} {
    return {}
  } else {
    return [list [join [get_object_name $all_seq]]]
  }
}

#######################################################################################
##### get_cells    ####
#######################################################################################
proc get_cells { args } {

  set opts_w_val_exp_s [get_opts_w_val_exp get_cells]
  set opts_no_val_exp_s [get_opts_no_val_exp get_cells]

  if {[check_opt_help get_cells $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all get_cells $args]} {
    return 1
  }
  check_opt_ignore get_cells $args
#### Check that all in argument list are not mutually exclusive
  if {[check_opt_excl get_cells $args] || [check_opt_unsup get_cells $args]} {
    puts "Error, command ignored"
    return 1
  }

#### Assign values to variables while also checking validity of the value types
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set filt_exp ""
  set obj_list ""
  foreach x $opt_inx_l {
#### -filter option
    if {[check_opt_is get_cells {-filter} [lindex $args $x]]} {
      set check [check_opt_val get_cells {-filter} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set filt_exp [lindex $args [expr $x + 1]]
        regsub -all {\\} $filt_exp {\\\\} filt_exp
        regsub -all {"} $filt_exp {\"} filt_exp ;#"
        regsub -all {=~} $filt_exp {==} filt_exp
        regsub -all {!~} $filt_exp {!=} filt_exp
        set filt_exp [join $filt_exp]
        if {![regexp {^(@|!@)} $filt_exp]} {
          if {[regexp {^!} $filt_exp]} {
            regsub {^!} $filt_exp "!@" filt_exp
          } else {
            regsub {^} $filt_exp "@" filt_exp
          }
        }
        regsub {.*} $filt_exp {{&}} filt_exp
      } else {
        puts "Error, get_cells -filter, no expression specified"
        return 1
      }
    } 
#### -of_objects option
    if {[check_opt_is get_cells {-of_objects} [lindex $args $x]]} {
      set check [check_opt_val get_cells {-of_objects} [lindex $args [expr $x + 1]]]
      if {$check} {
        set obj_list [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]
        set obj_list [split [join $obj_list]]
        if {[lsearch -regexp $obj_list {^([^tns]|.[^:])}] != -1} {
          puts "Error, get_cells, -of_objects must be qualified nets or pins, or a collection of nets or pins"
          return 1
        }
        if {[lsearch -regexp $obj_list {^s:}] != -1} {
          set obj_list [get_object_name $obj_list]
        }
      } else {
        puts "Error, get_cells, must be: -of_objects <list_or_col>"
        return 1
      }
    } 
  }
  set hier ""
  set nocase ""
  set regexp ""
  set exact ""
  set select 0
  if {$obj_list eq ""} {
    set pat_list "*"
  } else {
    set pat_list ""
  }
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  foreach x $opt_inx_l {
    if {[check_opt_is get_cells {-hierarchical} [lindex $args $x]]} {
      set hier "-hier"
    }
    if {[check_opt_is get_cells {-nocase} [lindex $args $x]]} {
      set nocase "-nocase"
    }
    if {[check_opt_is get_cells {-regexp} [lindex $args $x]]} {
      set regexp "-regexp"
    }
    if {[check_opt_is get_cells {-exact} [lindex $args $x]]} {
      set exact "-exact"
    }
    if {[check_opt_is get_cells {-select} [lindex $args $x]]} {
      set select 1
    }
    if {[check_val_no_opt get_cells $args $x] == 1 && [check_opt_is get_cells {<pattern>} [lindex $args $x] 1]} {
      regsub -all {\\} [lindex $args $x] {\\\\} pat_list
      set pat_list [split [join $pat_list]]
    }
  }

####  It will be either $pat_list OR $obj_list, not both
  foreach x $pat_list {
    regsub -all {\/} $x {.} x
    regsub {.*} $x {{&}} x
#    regsub -all {\\\\} $x {\\} x
    if {$filt_exp eq ""} {
      set exp_str "find $hier $nocase $exact $regexp -inst $x"
    } else {
      set exp_str "find $hier $nocase $exact $regexp -inst $x -filter $filt_exp"
    }
    
    if {![catch {set foo $rslt}]} {
      set rslt [add_to_collection $rslt [eval $exp_str]]
    } else {
      set rslt [eval $exp_str]
    }
  }
  foreach x $obj_list {
    regsub -all {\/} $x {.} x
    regsub -all {\\\\} $x {\\} x
    if {![sizeof_collection [find $x]]} {
      continue
    }
    if {[regexp {^n:} $x]} {
      set objs [expand -level 1 -inst -to $x]
      set objs [add_to_collection $objs [expand -level 1 -inst -from $x]]
    } elseif {[regexp {^t:} $x]} {
      set objs [find -inst [regsub {t:(.*)\.[^\.]+$} $x {\1}]]
    } else {
      puts "Error, get_cells, -of_objects collection must be qualified nets or pins"
      return 1
    }
    if {$filt_exp eq ""} {
      set exp_str "find $nocase $exact $regexp -hier -inst * -in $objs"
    } else {
      set exp_str "find $nocase $exact $regexp -hier -inst * -in $objs -filter $filt_exp"
    }
    if {![catch {set foo $rslt}]} {
      set rslt [add_to_collection $rslt [eval $exp_str]]
    } else {
      set rslt [eval $exp_str]
    }
  }

  if {[catch {set foo [c_list $rslt]}]} {
    return {}
  } else {
    if {$select} {
      select [join [get_object_name $rslt]]
      filter
    }
    return [list [join [get_object_name $rslt]]]
  }
}

#######################################################################################
##### get_nets    ####
#######################################################################################
proc get_nets { args } {

  set opts_w_val_exp_s [get_opts_w_val_exp get_nets]
  set opts_no_val_exp_s [get_opts_no_val_exp get_nets]

  if {[check_opt_help get_nets $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all get_nets $args]} {
    return 1
  }
  check_opt_ignore get_nets $args
#### Check that all in argument list are not mutually exclusive
  if {[check_opt_excl get_nets $args] || [check_opt_unsup get_nets $args]} {
    puts "Error, command ignored"
    return 1
  }

#### Assign values to variables while also checking validity of the value types
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set filt_exp ""
  set obj_list ""
  foreach x $opt_inx_l {
#### -filter option
    if {[check_opt_is get_nets {-filter} [lindex $args $x]]} {
      set check [check_opt_val get_nets {-filter} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set filt_exp [lindex $args [expr $x + 1]]
        regsub -all {\\} $filt_exp {\\\\} filt_exp
        regsub -all {"} $filt_exp {\"} filt_exp ;#"
        regsub -all {=~} $filt_exp {==} filt_exp
        regsub -all {!~} $filt_exp {!=} filt_exp
        set filt_exp [join $filt_exp]
        if {![regexp {^(@|!@)} $filt_exp]} {
          if {[regexp {^!} $filt_exp]} {
            regsub {^!} $filt_exp "!@" filt_exp
          } else {
            regsub {^} $filt_exp "@" filt_exp
          }
        }
        regsub {.*} $filt_exp {{&}} filt_exp
      } else {
        puts "Error, get_nets -filter, no expression specified"
        return 1
      }
    } 
#### -of_objects option
    if {[check_opt_is get_nets {-of_objects} [lindex $args $x]]} {
      set check [check_opt_val get_nets {-of_objects} [lindex $args [expr $x + 1]]]
      if {$check} {
        set obj_list [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]
        set obj_list [split [join $obj_list]]
        if {[lsearch -regexp $obj_list {^([^tips]|.[^:])}] != -1} {
          puts "Error, get_nets, -of_objects must be qualified ports, cells, or pins; or a collection of ports, cells or pins"
          return 1
        }
        if {[lsearch -regexp $obj_list {^s:}] != -1} {
          set obj_list [get_object_name $obj_list]
        }
      } else {
        puts "Error, get_nets, must be: -of_objects <list_or_col>"
        return 1
      }
    } 
  }
  set hier ""
  set nocase ""
  set regexp ""
  set pat_list ""
  set exact ""
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  foreach x $opt_inx_l {
    if {[check_opt_is get_nets {-hierarchical} [lindex $args $x]]} {
      set hier "-hier"
    }
    if {[check_opt_is get_nets {-nocase} [lindex $args $x]]} {
      set nocase "-nocase"
    }
    if {[check_opt_is get_nets {-regexp} [lindex $args $x]]} {
      set regexp "-regexp"
    }
    if {[check_opt_is get_nets {-exact} [lindex $args $x]]} {
      set exact "-exact"
    }
    if {[check_val_no_opt get_nets $args $x] == 1 && [check_opt_is get_nets {<pattern>} [lindex $args $x] 1]} {
      regsub -all {\\} [lindex $args $x] {\\\\} pat_list
      set pat_list [split [join $pat_list]]
    }
  }

####  It will be either $pat_list OR $obj_list, not both
  foreach x $pat_list {
    regsub -all {\/} $x {.} x
    regsub {.*} $x {{&}} x
    regsub -all {\\\\} $x {\\} x
    if {$filt_exp eq ""} {
      set exp_str "find $hier $nocase $regexp $exact -net $x"
    } else {
      set exp_str "find $hier $nocase $regexp $exact -net $x -filter $filt_exp"
    }
    if {![catch {set foo $rslt}]} {
      set rslt [add_to_collection $rslt [eval $exp_str]]
    } else {
      set rslt [eval $exp_str]
    }
  }
  set objs [find 1]
  foreach x $obj_list {
    regsub -all {\/} $x {.} x
    regsub -all {\\\\} $x {\\} x
    if {![sizeof_collection [find $x]]} {
      continue
    }
    set net_exp [make_exp_hier_net $x]
    set strg_to   "expand -level 1 -net -to \{$x\}"
    set strg_from "expand -level 1 -net -from \{$x\}"
    if {[regexp {^p:} $x]} {
      set strg_in  "find -port \{$x\} -filter \{@direction == in*\}"
      set strg_out "find -port \{$x\} -filter \{@direction == *out*\}"
      if {[sizeof_collection [eval $strg_in]]} {
        set objs [eval $strg_from]
      }  
      if {[sizeof_collection [eval $strg_out]]} {
        set objs [eval $strg_to]
      }
    } elseif {[regexp {^t:} $x]} {
      set strg_in  "find -pin \{$x\} -filter \{@direction == in*\}"
      set strg_out "find -pin \{$x\} -filter \{@direction == *out*\}"
      if {[sizeof_collection [eval $strg_in]]} {
        set objs [eval $strg_to]
      }  
      if {[sizeof_collection [eval $strg_out]]} {
        set objs [eval $strg_from]
      }
    } elseif {[regexp {^i:} $x]} {
      set objs [expand -level 1 -net -to $x]
      set objs [add_to_collection $objs [expand -level 1 -net -from $x]]
    } else {
      puts "Error, get_nets, -of_objects collection must be qualified ports, cells, or pins"
      return 1
    }
    if {$filt_exp eq ""} {
      set exp_str "find $nocase $regexp $exact -hier -net * -in $objs"
    } else {
      set exp_str "find $nocase $regexp $exact -hier -net * -in $objs -filter $filt_exp"
    }
    set rslt_i [eval $exp_str]
    set rslt_i [clean_hier_n [get_object_name $rslt_i] $net_exp]
    if {$rslt_i ne {}} {
      set rslt_i [define_collection $rslt_i]
    } else {
      continue
    }
    if {![catch {set foo $rslt}]} {
      set rslt [add_to_collection $rslt $rslt_i]
    } else {
      set rslt $rslt_i
    }
  }

  if {[catch {set foo [c_list $rslt]}]} {
    return {}
  } else {
    return [list [join [get_object_name $rslt]]]
  }
}

#####
##### Clean nets not in the hierarchy
#####
proc clean_hier_n {n_list n_exp} {
  set ret_list {}
  foreach i $n_list {
    if {$n_exp eq "@TOP"} {
      regsub -all {\\\.} $i "@" i
      if {[regexp {\.} $i]} {
        continue
      } else {
        set ret_list [linsert $ret_list end $i]
      }
    } else {
      if {[regexp $n_exp $i]} {
        set ret_list [linsert $ret_list end $i]
      }
    }
  }
  return $ret_list
}
#####
##### Make expression to filter hierarchy
#####
proc make_exp_hier_net {obj} {
  regsub -all {\\} $obj {\\\\} obj
  set ret_exp ".*"
  if {[regexp {^p:} $obj]} {
    return "@TOP"
  }
  if {[regexp {^i:} $obj]} {
    if {[get_prop -prop "hier_rtl_name" $obj] eq [get_prop -prop "rtl_name" $obj]} {
      return "@TOP"
    }
    regsub {^.:} $obj "n:" obj
    regsub -all {\\\.} $obj "@" obj
    regsub {\.[^\.]+$} $obj "\\." obj
    regsub -all {@} $obj {\\.} obj
    return "^$obj"
  }
  regsub {^.:} $obj "i:" obj
  regsub -all {\\\.} $obj "@" obj
  regsub {\.[^\.]+$} $obj "" obj
  set top 1
  if {[regsub {\.[^\.]+$} $obj "" obj]} {
    set top 0
  }
  if {![regexp {\.} $obj] && $top} {
    return "@TOP"
  }
  regsub -all {@} $obj {\\.} obj
  regsub {^.:} $obj "n:" obj
  regsub {$} $obj "\\." obj
  return "^$obj"
}

#######################################################################################
##### get_pins    ####
#######################################################################################
proc get_pins { args } {

  set opts_w_val_exp_s [get_opts_w_val_exp get_pins]
  set opts_no_val_exp_s [get_opts_no_val_exp get_pins]

  if {[check_opt_help get_pins $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all get_pins $args]} {
    return 1
  }
  check_opt_ignore get_pins $args
#### Check that all in argument list are not mutually exclusive
  if {[check_opt_excl get_pins $args] || [check_opt_unsup get_pins $args]} {
    puts "Error, command ignored"
    return 1
  }

#### Check if a specified option requires another option to also be specified
  if {[check_opt_reqs get_pins $args]} {
    puts "Error, command ignored"
    return 1
  }

#### Assign values to variables while also checking validity of the value types
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set filt_exp ""
  set obj_list ""
  foreach x $opt_inx_l {
#### -filter option
    if {[check_opt_is get_pins {-filter} [lindex $args $x]]} {
      set check [check_opt_val get_pins {-filter} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set filt_exp [lindex $args [expr $x + 1]]
        regsub -all {\\} $filt_exp {\\\\} filt_exp
        regsub -all {"} $filt_exp {\"} filt_exp ;#"
        regsub -all {=~} $filt_exp {==} filt_exp
        regsub -all {!~} $filt_exp {!=} filt_exp
        set filt_exp [join $filt_exp]
        if {![regexp {^(@|!@)} $filt_exp]} {
          if {[regexp {^!} $filt_exp]} {
            regsub {^!} $filt_exp "!@" filt_exp
          } else {
            regsub {^} $filt_exp "@" filt_exp
          }
        }
        regsub {.*} $filt_exp {{&}} filt_exp
      } else {
        puts "Error, get_pins -filter, no expression specified"
        return 1
      }
    } 
#### -of_objects option
    if {[check_opt_is get_pins {-of_objects} [lindex $args $x]]} {
      set check [check_opt_val get_pins {-of_objects} [lindex $args [expr $x + 1]]]
      if {$check} {
        set obj_list [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]
        set obj_list [split [join $obj_list]]
        if {[lsearch -regexp $obj_list {^([^ins]|.[^:])}] != -1} {
          puts "Error, get_pins, -of_objects must be qualified nets or cells, or a collection of nets or cells"
          return 1
        }
        if {[lsearch -regexp $obj_list {^s:}] != -1} {
          set obj_list [get_object_name $obj_list]
        }
      } else {
        puts "Error, get_pins, must be: -of_objects <list_or_col>"
        return 1
      }
    } 
  }
  set hier ""
  set nocase ""
  set regexp ""
  set exact ""
  set leaf ""
  if {$obj_list eq ""} {
    set pat_list "*.*"
  } else {
    set pat_list ""
  }
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  foreach x $opt_inx_l {
    if {[check_opt_is get_pins {-hierarchical} [lindex $args $x]]} {
      set hier "-hier"
    }
    if {[check_opt_is get_pins {-nocase} [lindex $args $x]]} {
      set nocase "-nocase"
    }
    if {[check_opt_is get_pins {-regexp} [lindex $args $x]]} {
      set regexp "-regexp"
    }
    if {[check_opt_is get_pins {-exact} [lindex $args $x]]} {
      set exact "-exact"
    }
    if {[check_opt_is get_pins {-leaf} [lindex $args $x]]} {
      set leaf "-hier"
    }
    if {[check_val_no_opt get_pins $args $x] == 1 && [check_opt_is get_pins {<pattern>} [lindex $args $x] 1]} {
      regsub -all {\\} [lindex $args $x] {\\\\} pat_list
      set pat_list [split [join $pat_list]]
    }
  }

####  It will be either $pat_list OR $obj_list, not both
  foreach x $pat_list {
    regsub -all {\/} $x {.} x
    regsub {.*} $x {{&}} x
    regsub -all {\\\\} $x {\\} x
    if {$filt_exp eq ""} {
      set exp_str "find $hier $nocase $exact $regexp -pin $x"
    } else {
      set exp_str "find $hier $nocase $exact $regexp -pin $x -filter $filt_exp"
    }
    
    if {![catch {set foo $rslt}]} {
      set rslt [add_to_collection $rslt [eval $exp_str]]
    } else {
      set rslt [eval $exp_str]
    }
  }
  foreach x $obj_list {
    regsub -all {\/} $x {.} x
    regsub -all {\\\\} $x {\\} x
    if {![sizeof_collection [find $x]]} {
      continue
    }
    if {[regexp {^n:} $x]} {
#      set objs [expand $leaf -level 1 -pin -to $x]
#      set objs [add_to_collection $objs [expand $leaf -level 1 -pin -from $x]]
      set exp_str "expand $leaf -level 1 -pin -to \{$x\}"
      set objs [eval $exp_str]
      set exp_str "expand $leaf -level 1 -pin -from \{$x\}"
      set objs  [add_to_collection $objs [eval $exp_str]]
    } elseif {[regexp {^i:} $x]} {
      set objs [find -pin [regsub {i:(.*)$} $x {\1.*}]]
    } else {
      puts "Error, get_pins, -of_objects collection must be qualified nets or cells"
      return 1
    }
    if {$leaf eq "-hier"} {
      set objs [define_collection [clean_hier_pins [get_object_name $objs]]]
    }
    if {$filt_exp eq ""} {
      set exp_str "find $nocase $regexp $exact -hier -pin *.* -in $objs"
    } else {
      set exp_str "find $nocase $regexp $exact -hier -pin *.* -in $objs -filter $filt_exp"
    }
    if {![catch {set foo $rslt}]} {
      set rslt [add_to_collection $rslt [eval $exp_str]]
    } else {
      set rslt [eval $exp_str]
    }
  }

  if {[catch {set foo [c_list $rslt]}]} {
    return {}
  } else {
    return [list [join [get_object_name $rslt]]]
  }
}

proc clean_hier_pins {objs} {
  set ret_list {}
  foreach i $objs {
    regsub {\.[^\.]+$} $i "" j
    regsub {^t:} $j "i:" j
    if {![sizeof_collection [find -inst $j -filter {@is_hierarchical}]]} {
      set ret_list [linsert $ret_list end $i]
    }
  }
  if {$ret_list eq {}} {
    return {1}
  } else {
    return $ret_list
  }
}


#######################################################################################
##### get_clocks    ####
#######################################################################################
proc get_clocks { args } {

  set opts_w_val_exp_s [get_opts_w_val_exp get_clocks]
  set opts_no_val_exp_s [get_opts_no_val_exp get_clocks]

  if {[check_opt_help get_clocks $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all get_clocks $args]} {
    return 1
  }
  check_opt_ignore get_clocks $args
#### Check that all in argument list are not mutually exclusive or unsupported
  if {[check_opt_excl get_clocks $args] || [check_opt_unsup get_clocks $args]} {
    puts "Error, command ignored"
    return 1
  }

#### Assign values to variables while also checking validity of the value types
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set filt_exp ""
  set obj_list ""
  foreach x $opt_inx_l {
#### -filter option
#    if {[check_opt_is get_clocks {-filter} [lindex $args $x]]} {
#      set check [check_opt_val get_clocks {-filter} [split [join [lindex $args [expr $x + 1]]]]]
#      if {$check == 1} {
#        set filt_exp [join [lindex $args [expr $x + 1]]]
#        if {![regexp {^@} $filt_exp]} {
#          regsub {^} $filt_exp "@" filt_exp
#        }
#        regsub {.*} $filt_exp {{&}} filt_exp
#      } else {
#        puts "Error, get_clocks -filter, no expression specified"
#        return 1
#      }
#    } 
#### -of_objects option
    if {[check_opt_is get_clocks {-of_objects} [lindex $args $x]]} {
      set check [check_opt_val get_clocks {-of_objects} [lindex $args [expr $x + 1]]]
      if {$check} {
        set obj_list [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]
        set obj_list [split [join $obj_list]]
        if {[lsearch -regexp $obj_list {^([^tns]|.[^:])}] != -1} {
          puts "Error, get_clocks, -of_objects must be qualified nets or pins, or a collection of nets or pins"
          return 1
        }
        if {[lsearch -regexp $obj_list {^s:}] != -1} {
          set obj_list [get_object_name $obj_list]
        }
      } else {
        puts "Error, get_clocks, must be: -of_objects <list_or_col>"
        return 1
      }
    } 
  }
  set hier ""
  set nocase ""
  set regexp ""
  set exact ""
  set glob "-glob"
  if {$obj_list eq ""} {
    set pat_list "*"
  } else {
    set pat_list ""
  }
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  foreach x $opt_inx_l {
    if {[check_opt_is get_clocks {-nocase} [lindex $args $x]]} {
      set nocase "-nocase"
    }
    if {[check_opt_is get_clocks {-regexp} [lindex $args $x]]} {
      set regexp "-regexp"
      set glob ""
    }
    if {[check_val_no_opt get_clocks $args $x] == 1 && [check_opt_is get_clocks {<pattern>} [lindex $args $x] 1]} {
      regsub -all {\\} [lindex $args $x] {\\\\} pat_list
      set pat_list [split [join $pat_list]]
    }
  }

####  It will be a $pat_list OR obj_list, but not both
  set all_clk_l [split [regsub -all {\{|\}} [all_clocks 1] ""]]
  foreach x $pat_list {
    regsub {c:} $x "" x
    regsub -all {\\\\} $x {\\} x
    set exp_str "lsearch $glob $regexp -all $nocase \$all_clk_l \{$x\}"
    set i_list [eval $exp_str]
    foreach i $i_list {
      set clk [lindex $all_clk_l $i]
      regsub {^} $clk "c:" clk
      if {![catch {set foo $rslt}]} {
        set rslt [add_to_list $rslt $clk]
      } else {
        set rslt $clk
      }
    }
  }

  foreach x $obj_list {
    regsub -all {\\\\} $x {\\} x
    if {[regexp {^n:} $x]} {
      set obj [find -net $x]
      if {[sizeof_collection $obj] > 1} {
        puts "Error, get_clocks, -of_objects:  Please use \[get_nets $x\]"
        return 1
      }
    } elseif {[regexp {^t:} $x]} {
      set obj [find -pin $x]
      if {[sizeof_collection $obj] > 1} {
        puts "Error, get_clocks, -of_objects:  Please use \[get_pins $x\]"
        return 1
      }
    }
    set clk_l [split [regsub -all {\{|\}} [all_clocks_obj $obj] ""]]
    foreach i $clk_l {
      regsub {^} $i "c:" i
      if {![catch {set foo $rslt}]} {
        set rslt [add_to_list $rslt $i]
      } else {
        set rslt $i
      }
    }
  }

  if {[catch {set foo $rslt}]} {
    return {}
  } else {
    return [list [join $rslt]]
  }
}

#######################################################################################
##### get_ports    ####
#######################################################################################
proc get_ports { args } {

  set opts_w_val_exp_s [get_opts_w_val_exp get_ports]
  set opts_no_val_exp_s [get_opts_no_val_exp get_ports]

  if {[check_opt_help get_ports $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all get_ports $args]} {
    return 1
  }
  check_opt_ignore get_ports $args
#### Check that all in argument list are not mutually exclusive
  if {[check_opt_excl get_ports $args] || [check_opt_unsup get_ports $args]} {
    puts "Error, command ignored"
    return 1
  }

#### Assign values to variables while also checking validity of the value types
  set opt_inx_l [lsearch -all -regexp $args $opts_w_val_exp_s]
  set filt_exp ""
  set obj_list ""
  foreach x $opt_inx_l {
#### -filter option
    if {[check_opt_is get_ports {-filter} [lindex $args $x]]} {
      set check [check_opt_val get_ports {-filter} [split [join [lindex $args [expr $x + 1]]]]]
      if {$check == 1} {
        set filt_exp [lindex $args [expr $x + 1]]
        regsub -all {\\} $filt_exp {\\\\} filt_exp
        regsub -all {"} $filt_exp {\"} filt_exp ;#"
        regsub -all {=~} $filt_exp {==} filt_exp
        regsub -all {!~} $filt_exp {!=} filt_exp
        set filt_exp [join $filt_exp]
        if {![regexp {^(@|!@)} $filt_exp]} {
          if {[regexp {^!} $filt_exp]} {
            regsub {^!} $filt_exp "!@" filt_exp
          } else {
            regsub {^} $filt_exp "@" filt_exp
          }
        }
        regsub {.*} $filt_exp {{&}} filt_exp
      } else {
        puts "Error, get_ports -filter, no expression specified"
        return 1
      }
    } 
#### -of_objects option
    if {[check_opt_is get_ports {-of_objects} [lindex $args $x]]} {
      set check [check_opt_val get_ports {-of_objects} [lindex $args [expr $x + 1]]]
      if {$check} {
        set obj_list [regsub -all {\\} [lindex $args [expr $x + 1]] {\\\\}]
        set obj_list [split [join $obj_list]]
        if {[lsearch -regexp $obj_list {^([^ins]|.[^:])}] != -1} {
          puts "Error, get_ports, -of_objects must be qualified nets or cells, or a collection of nets or cells"
          return 1
        }
        if {[lsearch -regexp $obj_list {^s:}] != -1} {
          set obj_list [get_object_name $obj_list]
        }
      } else {
        puts "Error, get_ports, must be: -of_objects <list_or_col>"
        return 1
      }
    } 
  }
  set hier ""
  set nocase ""
  set regexp ""
  set exact ""
  if {$obj_list eq ""} {
    set pat_list "*"
  } else {
    set pat_list ""
  }
  set opt_inx_l [lsearch -all -regexp $args $opts_no_val_exp_s]
  foreach x $opt_inx_l {
    if {[check_opt_is get_ports {-hierarchical} [lindex $args $x]]} {
      set hier "-hier"
    }
    if {[check_opt_is get_ports {-nocase} [lindex $args $x]]} {
      set nocase "-nocase"
    }
    if {[check_opt_is get_ports {-regexp} [lindex $args $x]]} {
      set regexp "-regexp"
    }
    if {[check_opt_is get_ports {-exact} [lindex $args $x]]} {
      set exact "-exact"
    }
    if {[check_val_no_opt get_ports $args $x] == 1 && [check_opt_is get_ports {<pattern>} [lindex $args $x] 1]} {
      regsub -all {\\} [lindex $args $x] {\\\\} pat_list
      set pat_list [split [join $pat_list]]
    }
  }

####  It will be either $pat_list OR $obj_list, not both
  foreach x $pat_list {
    regsub -all {\/} $x {.} x
    regsub {.*} $x {{&}} x
    regsub -all {\\\\} $x {\\} x
    if {$filt_exp eq ""} {
      set exp_str "find $hier $nocase $exact $regexp -port $x"
    } else {
      set exp_str "find $hier $nocase $exact $regexp -port $x -filter $filt_exp"
    }
    
    if {![catch {set foo $rslt}]} {
      set rslt [add_to_collection $rslt [eval $exp_str]]
    } else {
      set rslt [eval $exp_str]
    }
  }
  foreach x $obj_list {
    regsub -all {\/} $x {.} x
    regsub -all {\\\\} $x {\\} x
    if {[regexp {^n:} $x]} {
      set objs [expand -level 1 -port -to $x]
      set objs [add_to_collection $objs [expand -level 1 -port -from $x]]
    } else {
      puts "Error, get_ports, -of_objects collection must be qualified nets"
      return 1
    }
    if {$filt_exp eq ""} {
      set exp_str "find $nocase $regexp $exact -port * -in $objs"
    } else {
      set exp_str "find $nocase $regexp $exact -port * -in $objs -filter $filt_exp"
    }
    if {![catch {set foo $rslt}]} {
      set rslt [add_to_collection $rslt [eval $exp_str]]
    } else {
      set rslt [eval $exp_str]
    }
  }

  if {[catch {set foo [c_list $rslt]}]} {
    return {}
  } else {
    return [list [join [get_object_name $rslt]]]
  }
}

#######################################################################################
##### all_inputs    ####
#######################################################################################
proc all_inputs { args } {

  set opts_w_val_exp_s [get_opts_w_val_exp all_inputs]
  set opts_no_val_exp_s [get_opts_no_val_exp all_inputs]

  if {[check_opt_help all_inputs $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all all_inputs $args]} {
    return 1
  }
  check_opt_ignore all_inputs $args
#### Check that all in argument list are not mutually exclusive
  if {[check_opt_excl all_inputs $args] || [check_opt_unsup all_inputs $args]} {
    puts "Error, command ignored"
    return 1
  }
  set rslt [find -port * -filter {@direction == input || @direction == inout}]
  return [list [join [get_object_name $rslt]]]
}

proc object_list {strg} {
  return [split [regsub -all {\{|\}} $strg ""]]
}

#######################################################################################
##### all_outputs    ####
#######################################################################################
proc all_outputs { args } {

  set opts_w_val_exp_s [get_opts_w_val_exp all_outputs]
  set opts_no_val_exp_s [get_opts_no_val_exp all_outputs]

  if {[check_opt_help all_outputs $args]} {
    return 0
  }
#### Check that all in argument list are valid options
  if {![check_opt_all all_outputs $args]} {
    return 1
  }
  check_opt_ignore all_outputs $args
#### Check that all in argument list are not mutually exclusive
  if {[check_opt_excl all_outputs $args] || [check_opt_unsup all_outputs $args]} {
    puts "Error, command ignored"
    return 1
  }
  set rslt [find -port * -filter {@direction == output || @direction == inout}]
  return [list [join [get_object_name $rslt]]]
}

#######################################################################################
##### all_clocks    ####
#######################################################################################
proc all_clocks {{no_qual 0}} {
  set ret_l {}
  set clocks [get_prop -prop clock [find -hier -seq *]]
  foreach x $clocks {
    regsub {,$} $x "" x
    if {$x ne "<nil>"} {
      if {!$no_qual} {
        regsub {^} $x "c:" x
      }
      set ret_l [add_to_list $ret_l $x]
    }
  }
  return [list [join [lsort $ret_l]]]
}

proc all_clocks_obj {obj_c} {
  set ret_l {}
  set derived 0
  set exp "{.*}"
#  if obj_c is an output pin, get the net on the pin
  if {[sizeof_collection [find -hier -pin *.* -in $obj_c -filter {@direction == output}]]} {
    set obj_l [object_list [get_nets -of_objects $obj_c]]
    if {[llength $obj_l]} {
      set obj_c [define_collection $obj_l]
    } else {
      set obj_c [find 1]
    }
  }
  if {![sizeof_collection $obj_c]} {
    return $ret_l
  }
  set clocks [get_prop -prop clock $obj_c]
  if {$clocks eq "<nil>" && [get_prop -prop is_clock $obj_c] eq "1"} {
#  if here, obj_c is probably either a net before a BUFG*, or a BUFG* input, coming after a PLL/MMCM
    set obj_c [find -hier -pin *.* -in [expand -pin -from $obj_c] -filter {@direction == input}]
    if {![sizeof_collection $obj_c]} {
      return $ret_l
    }
    set net_o [get_object_name [find -hier -net * -in [expand -hier -net -level 1 -to $obj_c] -filter {@is_gated_clock}]]
    set match 0
    foreach o $net_o {
      regsub {n:} $o "" o
      regsub -all {\\\.} $o "@" o
      regsub {^.*\.} $o "" o
      regsub -all {@} $o {\\.} o
      set obj [get_pins -of_objects [get_cells -of_objects [get_object_name $obj_c]] -filter {@direction == output}]
      set obj_c [find -hier -net * -in [define_collection [object_list [get_nets -of_objects $obj]]]]
      set clocks [get_prop -prop clock $obj_c]
      set clocks [join $clocks]
      regsub -all {,} $clocks "" clocks
      set clocks [split $clocks]
      set derived 1
      set exp ${o}_derived_clock
      regsub -all {\{|\}} $exp "" exp
#  puts "CLOCKS: $clocks"
#  puts "EXP:    $exp"
      if {[lsearch -regexp $clocks $exp] == -1} {
        continue
      }
      set match 1
      break
    }
    if {!$match} {
      return $ret_l
    }
  }
  foreach x $clocks {
    regsub {,$} $x "" x
    if {$x ne "<nil>"} {
      if {$derived && ![regexp $exp $x]} {
        continue
      }
      set ret_l [add_to_list $ret_l $x]
    }
  }
  return [list [join [lsort $ret_l]]]
}

#proc filter_clocktree {src} {
#  select -clear
#  foreach x [object_list [get_cells [all_fanout -from $src -flat -only_cells] -filter {!@is_sequential}]] {select -append $x} 
#  foreach x [object_list [get_cells [all_fanin -to [all_fanout -from $src -flat] -flat -only_cells] -filter {!@is_sequential}]] {select -append $x}
#  filter
#  return 0
#}

proc get_keepers { args } {
	set output [ prepend "k:" $args ]

	while { [expr [llength $args] > 0] } {
		set param [lindex $args 0]
		if { [regexp {^[-]} $param] } {
			puts "@W: option $param not yet supported for command get_keepers, command will be ignored." 
			set output ""
	    }
		set args [lrange $args 1 end]
	}

	return $output
}

proc get_registers { args } {
	set output [ prepend "r:" $args ]
	
	while { [expr [llength $args] > 0] } {
		set param [lindex $args 0]
		if { [regexp {^[-]} $param] } {
			puts "@W: option $param not yet supported for command get_registers, command will be ignored." 
			set output ""
	    }
		set args [lrange $args 1 end]
	}

	return $output
}

proc go_m0 {} {database set_state m0}
proc goto_work_dir {} {cd [regsub {[^\/]+$} [database query -path] ""]; pwd}


}
}
  
if {[product_type] eq "protocompiler" || [product_type] eq "protocompiler_dx" || [product_type] eq "protocompiler_s"} {
  set prod "protocompiler"
} else {
  set prod "legacy"
}

if {$prod ne "protocompiler"} {
  set cmd_list {
	sdc2fdc
	xdc_clock_group
	all_fanin
	all_fanout
	create_fdc_template
	check_fdc_query
	report_timing
	get_cells
	get_clocks
	get_pins
	get_nets
	get_ports
	get_registers
	get_clock_source
	all_inputs
	all_outputs
	all_registers
	fix_cgc_xdc
	all_clocks
	object_list
	slash2dot
	dot2slash
	start_time
	end_time
	set_view
	clear_view
	check_hstdm_timing
	get_user_clocks
  }
} else {
  set cmd_list {
	all_fanin
	all_fanout
	report_timing
	get_cells
	get_clocks
	get_pins
	get_nets
	get_ports
	get_registers
	get_clock_source
	all_inputs
	all_outputs
	all_registers
	fix_cgc_xdc
	all_clocks
	object_list
	slash2dot
	dot2slash
	proto_correlate
	goto_work_dir
        go_m0
	check_hstdm_timing
  }
}
foreach x $cmd_list {
  if {[info commands $x] ne "$x"} {
    namespace import timing_corr::$x
  }
}

