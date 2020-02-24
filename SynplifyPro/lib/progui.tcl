# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
# $Header: //synplicity/ui2019q3p1/uitools/pm/progui.tcl#1 $ 
#
# User Interface Commands
#

# returns name of shell, e.g. protobatch, certify, certbatch, synplify, synbatch
proc shellname { } {
    set path [ split [ info nameofexecutable ] '/' ]
    set idx [ expr [ llength $path ] - 1 ]
    set execname [ lindex $path $idx ]
    regsub ".exe" $execname "" execname
    return $execname
}

proc project {args} {
    if [expr [llength $args] < 1] {
        help project
    }
    set sw   [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- $sw {
        "_begin_obsolete" { #start of obsolete  }
        "-architecture"   { technology    $args }
        "-part"           { part          $args }
        "-package"        { package       $args }
        "-speed_grade"    { speed_grade   $args }
        "-top_module"     { top_module    $args }
        "_end_obsolete"   { #end of obsolete    }

        "-new"            { eval [concat projectx -new   $args] }
        "-run"            { eval [concat projectx -run  $args] }
        "-launch"         { eval [concat project_launch   $args] }
        "-compile"        { eval [concat projectx -run  compile $args] }
        "-write_netlist"  { eval [concat projectx -run  write_netlist $args] }
        "-load"           { eval [concat projectx -load $args] }
        "open"            { eval [concat projectx -load $args] }
        "import"          { eval [concat projectx -load $args] }
        "-insert"         { eval [concat projectx -insert $args] }
        "-propagate"      { eval [concat projectx -propagate $args] }
        "-insert_library" { eval [concat insert_library $args] }
        "-close"          { eval [concat projectx -close $args] }
        "close"           { eval [concat projectx -close $args] }
        "-save"           { eval [concat projectx -save $args] }
        "-canceljob"      { cancel_job    $args }
        "-result_file"    { eval [concat result_file $args] }
        "-result_format"  { result_format $args }
        "-log_file"       { eval [concat log_file $args] }
        "-file"           { project_attr  -file $args}
        "-main"           { project_attr  -main $args}
        "-dir"            { project_attr  -dir  $args}
        "-name"           { project_attr  -name $args}
        "-list"           { project_attr  -list $args}
        "-list_subprojects" { project_attr  -list_subprojects $args}
        "-filelist"       { eval [concat project_attr  -filelist $args] }
        "-fileorder"      { eval [concat project_file  -fileorder $args] }
        "-movefile"       { eval [concat project_file  -move $args] }
        "-removefile"     { eval [concat project_file  -remove $args] }
        "-addfile"        { add_file $args}
        "-active"         { eval [concat project_attr -active $args] }

        "-archive"        { eval [concat archive_project -archive $args] }
        "-unarchive"      { eval [concat archive_project -unarchive $args] }
        "-copy"           { eval [concat archive_project -copy $args] }

        default 
            { help project }
    }
}

# HELP project
#
set project_help_string "

Project Operations:

project -run    \[-fg\] \[-all\] \[<mode>\] -- run the active implementation of project

    -fg  = wait while run completes; run in foreground
    -all = run all implementations in project

<mode> specifies the type of job to be ran on the implementation.
The default value for <mode> is \"synthesis\" which will run the compile-synthesis job flow

<mode> can be one of the following operations:

compile          - compiles (only) the currently active implementation
write_netlist    - write netlist (only) the currently active implementation
synthesis        - compiles (if necessary) and synthesizes the currently active implementation. This mode is the default for the project -run command.
synthesis_check  - verifies that the design is functionally correct
syntax_check     - verifies that the HDL is syntactically correct
fsm_explorer     - generate the optimal fsm encoding style for finite state machines
preparation      - synthesizes the currently active implementation (only for certify)
prototyping      - run the partition, CPM and trace assigment based the \"prototype_file\" script (only for certify)
slp_generation   - generate paritioned sub SLP projects based the current implementation (only for certify)

Project Settings:

project -new    \[<projectPath>\]   -- create a new project.
project -load   \[<projectPath>\]   -- load a project file.
project -insert \[<projectPath>\]   -- insert a project file into workspace.
project -close  \[<projectName>\]   -- close a project.
project -save   \[<projectName>\]   -- save a project.
project -active \[<projectName>\]   -- set/show active project.
project -dir    \[<projectName>\]   -- show project directory.
project -file   \[<projectName>\]   -- show project file.

project -result_file   \[<resultFilePath>\] -- Change the synthesis result file.
project -result_format \[<resultFormat>\] -- Change the synthesis result format.
project -log_file \[<logfile>\] -- Change the project logfile.

project -name                       -- return the project name.
project -list                       -- return the list of loaded projects.
project -filelist                   -- return list of files contained in project.
project -fileorder <fileName1> <fileName2> ...  -- Reorder files by adding to end of project file list
project -movefile   <fileName1> <fileName2> -- move file1 to follow file2 in HDL file list. If file2 not specified, move to front.
project -removefile <fileName>              -- Remove file from project.
project -addfile    <fileName>              -- add file to project.

project -archive                    -- archive active project to a archive file.
            -project <projectPath>          -- Project to be archived (instead of active project).
            -implement <implementation>     -- Active implementation name.
            -root_dir <direcotry>           -- Top level directory of project files.
            -archive_file <archiveFileName> -- Archive filename.
            -archive_type \[local | customize | full\]  -- Full: archive all input/result files.
                                                        -- Local: archive only local input files.
                                                        -- Customize: user select file list.
            -add_srs                        -- Add .srs files into archive and project files.
            -add_result <implementation>    -- Add implementation retults.

project -unarchive                  -- Un-archive project from a archive file.
            -archive_file <archiveFileName> -- Archive filename.
            -dest_dir <directory>           -- Destination directory.

project -copy                       -- Copy active project to antoher directory.
            -project <projectPath>          -- Project to be archived (instead of active project).
            -implement <implementation>     -- Active implementation name.
            -root_dir <direcotry>           -- Top level directory of project files.
            -dest_dir <directory>           -- Destination directory.
            -copy_type \[local | customize | full\]     -- Full: archive all input/result files.
                                                        -- Local: archive only local input files.
                                                        -- Customize: user select file list.
            -add_srs                        -- Add .srs files into archive and project files.
            -add_result <implementation>    -- Add implementation retults.

 "
set shellflavor [shellname]
if { $shellflavor != "protobatch" && $shellflavor != "protocompiler" } {
    install_command_help "project" $project_help_string
}

# Added for future commands to allow new commands to be added and supported in old software.
# Currently we use the "set_option" command for this purpose.
proc syncom {args} {
    set sw   [lindex $args 0]
    set args [lrange $args 1 end]

    switch -- $sw {
        "impl_files"    -
        "hdl_param"     -
        "hdl_define"    -
        "job"           -
        "syn_source"
                { eval [concat $sw $args] }
        default {
            message "unrecognized command ignored: $sw"
        }
    }
}


proc set_option {args} {

    set sw   [lindex $args 0]
    set args [lrange $args 1 end]

    switch -- $sw {
        "-analysis_constraint"     { eval [concat impl_files -analysis_constraint $args] }
        "-constraint"              { eval [concat impl_files -constraint $args] }
        "-floorplan_def"           { eval [concat impl_files -floorplan $args] }
        "-floorplan"               { eval [concat impl_files -floorplan $args] }
        "-proto_tcl"               { eval [concat impl_files -tcl $args] }
        "-ident_constraint"        { eval [concat impl_files -ident_constraint $args] }
        "-srp_file"                { eval [concat impl_files -partition_syn $args] }
        "-impl_files"              { eval [concat impl_files   $args] }
        "-hdl_param"               { eval [concat hdl_param   $args] }
        "-hdl_define"              { eval [concat hdl_define  $args] }
        "-job"                     { eval [concat sub_impl $args] }
        "-syn_source"              { eval [concat syn_source $args] }
        default {
            eval [concat set_attr $sw $args]
        }
    }
}

# HELP set_option
#
set set_get_option_help_string "
usage:  set_option -<optionName> <optionValue>  -- set option on active implementation
        get_option -<optionName>                -- return option value on active implementation"

if { $shellflavor != "protobatch" && $shellflavor != "protocompiler" } {
    install_command_help "set_option" $set_get_option_help_string
    install_command_help "get_option" $set_get_option_help_string
}


proc get_option {args} {
    set sw   [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- $sw {
        "-floorplan_def"           { eval [concat impl_files -floorplan $args] }
        "-floorplan"               { eval [concat impl_files -floorplan $args] }
        "-proto_tcl"               { eval [concat impl_files -tcl $args] }
        "-srp_file"                { eval [concat impl_files -partition_syn $args] }
        "-impl_files"              { eval [concat impl_files   $args] }
        "-hdl_param"               { eval [concat hdl_param   $args] }
        "-hdl_define"              { eval [concat hdl_define  $args] }
        "-job"                     { eval [concat sub_impl $args] }
        default {
            eval [concat get_attr $sw $args]
        }
    }
}

if { $shellflavor != "protobatch" && $shellflavor != "protocompiler" } {
    install_command_help "add_file" "
-- add a file to the project
    
add_file  \[-<file_type>\] \[-lib <library_name>\] <fileName>

<file_type> specifies the type of file being added. Some valid file types include:

add_file -verilog  fileName \[ fileName \[ ...\] \] \[-folder folderName\]
add_file -vhdl \[-lib libName\[ libName\] \]  fileName \[ fileName \[ ...\] \] \[-folder folderName\]
add_file -include fileName \[ fileName \[ ...\] \]
add_file -tooltag tooltagName -toolargs \[toolArguments\] fileName
add_file -clearbox_verilog fileName \[ fileName \[ ...\] \]
add_file -clearbox_vhdl fileName \[ fileName \[ ...\] \]
add_file -placement_constraint  fileName
add_file -vlog_std standard fileName \[ fileName \[ ...\] \]
"
}
proc add_file {args} {

    set sw   [lindex $args 0]

    if {$sw == "-include_path"} {
        if [expr [llength $args] < 1] {
            warn {add_file usage: add_file option value}
        }
        set args [lrange $args 1 end]

        #Loop through arguments
        for {set i 0} {$i < [llength $args]} {incr i} {
            set arg [lindex $args $i]
            switch -- $sw {
                "-include_path"  { include_path                  $arg }
                default 
                    { warn [format "add_file: unknown option %s" $sw] }
            }
        }
    } else {
        eval [concat add_generic_file $args]
    }
}

proc get_env {envvar} {
    global env
    set envval [lindex [array get env $envvar] 1]
    return $envval
}

# new project implementation command
#
#
proc impl {args} {
    if [expr [llength $args] < 1] {
        help impl
    }
    set sw   [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- $sw {
        "-add"          { eval [concat impl_add $args] }
        "-copy"         { impl_copy   $args }
        "-remove"       { eval [concat impl_remove $args] }
        "-active"       { impl_set    $args }
        "-name"         { eval [concat impl_name $args] }
        "-dir"          { eval [concat impl_data -dir $args] }
        "-fileoption"   { eval [concat impl_data -fileoption $args] }
        "-result_file"  { eval [concat result_file $args] }
        "-list"         { impl_list   }
        default         { eval [concat impl_data $args] }
    }
}

# HELP impl
#
if { $shellflavor != "protobatch" && $shellflavor != "protocompiler" } {
    install_command_help "impl" "\
usage:
impl  -add                             -- add new implementation
      -add  \[<implName>\] \[<model>\] -- add new implementation copied from implementation <model>
      -name \[<implName>\]             -- change/get name of active implementation
      -remove <implName>               -- remove an implementation
      -active \[<implName>\]           -- set/get the active implementation
      -list                            -- list the implementations used in this project
      -result_file                     -- show implementation result file
      -dir                             -- show implementation directory"
}

proc partdata {args} {
    if [expr [llength $args] < 1] {
        help partdata
    }
    set sw   [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- $sw {
        "-load"         { partload       $args }
        "-family"       { eval [concat partfamily_vendor $args] }
        "-part"         { partlist       $args }
        "-grade"        { partgrade      $args }
        "-package"      { partpackage    $args }
        "-oem"          { partoem        $args }
        "-isvalid"      { partvalid      $args }
        "-vendorlist"   { partvendorlist }
        "-vendor"       { jobattr -value "[lindex $args 0].Company" }
        "-attribute"    { jobattr -value "[lindex $args 1].[lindex $args 0]" }
        ""              { help partdata }
        default 
            { warn [format "part: unknown option %s" $sw] }
    }
}

# partfamily_vendor
#
# Return list of families belonging to <vendor>
#
# partfamily_vendor <vendor>
#
proc partfamily_vendor {{vendor ""}} {
    if {$vendor == ""} {
        partfamily
    } else {
        set result {}
        set familyList [partfamily]
        foreach family [partfamily] {
            set familyVendor [jobattr -value $family.Company]
            if {[string compare -nocase $familyVendor $vendor] == 0} {
                lappend result $family
            }
        }
        return $result
    }
}

# part_vendorlist
#
# Return list of families belonging to <vendor>
#
# partfamily_vendor <vendor>
#
proc partvendorlist { } {
    set vendList {};
    set familyList [partfamily]
    foreach family [partfamily] {
        set familyVendor [jobattr -value $family.Company]
        if {$familyVendor != "Synplicity"} {
            if {[lsearch $vendList $familyVendor] == -1} {
                lappend vendList $familyVendor
            }
        }
    }
    return $vendList;
}

# HELP partdata
#
if { $shellflavor != "protobatch" && $shellflavor != "protocompiler" } {
    install_command_help "partdata" "\
usage:
partdata    -load <filename>
partdata    -family \[<vendor>\]              -- list available families for specified vendor
partdata    -part    <family>               -- list family parts
partdata    -vendorlist                     -- list available vendors
partdata    -vendor  <family>               -- return vendor name for family
partdata    -attribute <attribute> <family> -- return attribute value of attribute for family
partdata    -grade   \[<family>:\]<part>      -- list grades for family:part
partdata    -package \[<family>:\]<part>      -- list packages for family:part
partdata    -oem     \[<family>:\]<part>      -- return true is part is oem part"
}
proc jobdata {args} {

    if [expr [llength $args] < 1] {
        help jobdata
    }
    set sw   [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- $sw {
        "-load"         { job_load_data         $args }
        "-jobs"         { job_list              $args }
        "-command"      { job_command           $args }
        "-attr"         { job_attr_list         $args }
        default         { help jobdata }
    }
}


proc jobattr {args} {
    if [expr [llength $args] < 1] {
        help job_attrdef
    }
    set sw   [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- $sw {
        "-list"         { job_attrdef_list      $args }
        "-value"        { job_attr_value        $sw $args }
        "-useroption"   { job_attr_value        $sw $args }
        "-arg"          { job_attr_value        $sw $args }
        default         { job_attrdef           $sw $args }
    }
}

# old name for command_history
proc suDumpHistory {{filename ""}} {
    command_history $filename;

    set numCommands [expr [history nextid]-1]
}



proc command_history2 { {cmd_switch ""} {filename ""}} {
            set fid [open $filename w]
            if {$fid == 0} {
                puts "unable to open file: $filename"
                return;
            }
            set result {}
            set newline ""

            set numCommands [expr [history nextid]-1]
            set firstCommand [expr $numCommands - [tcl::HistKeep]]
            if {$firstCommand < 1} {
                set firstCommand 1
            }

            for {set i $firstCommand } { $i < $numCommands} {incr i 1} {
                set cmd [string trimright [tcl::HistEvent $i] \ \n]
                regsub -all \n $cmd "\n\t" cmd
                if {$cmd != ""} {
                    append result $newline$cmd
                    set newline \n
                }
            }

            if {$filename != ""} {
                set fid [open $filename w]
                puts $fid $result
                close $fid
                set result ""
            }

            puts $fid $result
            close $fid
            set result ""
            puts "TCL command history saved to $filename"

    puts "usage: command_history [-save <filename>]"
}



proc command_history { {cmd_switch ""} {filename ""}} {

    set filewrote 0;

    if {$cmd_switch == ""} {
        set hr [history];
        return $hr;
    }
    if {$cmd_switch == "-save"} {

        if {$filename != ""} {
            set fid [open $filename w]
            if {$fid == 0} {
                puts "unable to open file: $filename"
                return;
            }
            set result {}
            set newline ""

            set numCommands [expr [history nextid]-1]
            set firstCommand [expr $numCommands - [tcl::HistKeep]]
            if {$firstCommand < 1} {
                set firstCommand 1
            }

            for {set i $firstCommand } { $i < $numCommands} {incr i 1} {
                set cmd [string trimright [tcl::HistEvent $i] \ \n]
                regsub -all \n $cmd "\n\t" cmd
                if {$cmd != ""} {
                    append result $newline$cmd
                    set newline \n
                }
            }

            puts $fid $result
            close $fid
            set result ""
            set filewrote 1;
        }
    }

    if { $filewrote == 1 } {
        puts "TCL command history saved to $filename"
    } else {
        puts "usage: command_history \[-save <filename>\]"
    }
}

# Return a command numback commands back in the history log
# numback = 1 returns previous command
#
proc suLastHistCommand {numback} {

    set eventNum [expr [history nextid]- $numback]
    set result [history event $eventNum]
    return $result
}


proc exit {{status 0}} {
    eval [concat su_main_exit $status]
    
}


proc suIsAsic {} {
    set prod_type [product_type]
    if {[string match "amplify" $prod_type] == 1} {
        return 1;
    } else {
        return 0;
    }
}

# Implement suPuts to puts to support old scripts with obsolete suPuts
#
proc suPuts {args} {
    eval [concat puts $args]
}


# write_xilinx_cli()
#
# Write CLI file based on options from the current implementation.
#
# Procedure definition updated to take one more input argument XilinxPath which is just used while calling get_xilinx_ise_version

proc write_xilinx_cli {XilinxPath cli_filename base_filename} {
    global cli_file

    set project_name [project -name]
    set tech_name   [map_xilinx_family_name [get_option -technology]]
    set part_name   [get_option -part]
    set speed_grade [get_option -speed_grade]
    set package     [get_option -package]
    set result_file [get_option -result_file]

    set cli_file [open "$cli_filename" w]

    set xilinx_ver [get_xilinx_ise_version $XilinxPath ]
    if {$xilinx_ver != "" && $xilinx_ver > "5"} {
        set top_level_module_type  "Top-Level Module Type"
    } else {
        set top_level_module_type  "Design Flow"
    }
    if {$xilinx_ver < "7"} {
        set npl_filename "$base_filename.npl"
        puts $cli_file "NewProject($npl_filename)"
        puts $cli_file "OpenProject($npl_filename)"
    } else {
        puts $cli_file "NewProject($base_filename)"
    }
    puts $cli_file "SetProperty(Project Title, $project_name)"
    puts $cli_file "SetProperty(Device Family, $tech_name)"
    puts $cli_file "SetProperty(Device, $part_name)"
    puts $cli_file "SetProperty(Package, $package)"
    puts $cli_file "SetProperty(Speed Grade, $speed_grade)"
    puts $cli_file "SetProperty($top_level_module_type, EDIF)"
    puts $cli_file "AddSource($result_file)"
    puts $cli_file "CloseProject()"

    flush $cli_file
    close $cli_file
}

proc write_xilinx_tcl  { iseLaunch_tcl base_filename } {
    set project_name [project -name]
    set tech_name   [map_xilinx_family_name [get_option -technology]]
    set part_name   [get_option -part]
    set speed_grade [get_option -speed_grade]
    set package     [get_option -package]
    set result_file [get_option -result_file]
    set ucf_file    [impl -dir]/synplicity.ucf


    #### Always Delete the OLD ISE File as OverWrite####
    if { [file exists $base_filename.ise] } {
            catch {file delete -force $base_filename.ise}
        }
    if { [file exists $base_filename.xise] } {
        catch {file delete -force $base_filename.xise}
    }

    set iseLaunch_file [open "$iseLaunch_tcl" w]

    puts $iseLaunch_file "project new \"$base_filename.ise\""
        puts $iseLaunch_file ""
        puts $iseLaunch_file "project set family \"$tech_name\""
        puts $iseLaunch_file "project set device \"$part_name\""
        puts $iseLaunch_file "project set package \"$package\""
        puts $iseLaunch_file "project set speed \"$speed_grade\""
        puts $iseLaunch_file ""
        puts $iseLaunch_file "xfile add \"$result_file\""   
        if { [file exists $ucf_file] } {
                puts $iseLaunch_file "xfile add \"$ucf_file\""
            }
        puts $iseLaunch_file ""
        puts $iseLaunch_file "project close"
        puts $iseLaunch_file ""
        flush  $iseLaunch_file
        close  $iseLaunch_file

}


# Map tech names from Synplify to ISE
array set techMap \
[list \
 {VIRTEX} {VIRTEX} \
 {VIRTEX2} {VIRTEX2} \
 {VIRTEX2P} {VIRTEX2P} \
 {VIRTEX4} {VIRTEX4} \
 {VIRTEX5} {VIRTEX5} \
 {VIRTEXE} {VIRTEXE} \
 {VIRTEX-E} {VIRTEXE} \
 {VIRTEX6} {VIRTEX6} \
 {VIRTEX6-LOWER-POWER} {VIRTEX6 Lower Power} \
 {ARTIX7} {ARTIX7} \
 {ARTIX7-LOW-VOLTAGE} {ARTIX7 Low Voltage} \
 {SPARTAN7} {SPARTAN7} \
 {VIRTEX7} {VIRTEX7} \
 {VIRTEX-EVEREST-FPGAS} {VIRTEX Everest FPGAs} \
 {VIRTEX-ULTRASCALE-FPGAS} {VIRTEX UltraScale FPGAs} \
 {VIRTEX-ULTRASCALEPLUS-FPGAS} {VIRTEX UltraScale+ FPGAs} \
 {VIRTEX-ULTRASCALEPLUS-HBM-FPGAS} {VIRTEX UltraScale+ HBM FPGAs} \
 {KINTEX7} {KINTEX7} \
 {KINTEX7-LOWER-POWER} {KINTEX7 Low Voltage} \
 {KINTEX-ULTRASCALE-FPGAS} {KINTEX UltraScale FPGAs} \
 {KINTEX-ULTRASCALEPLUS-FPGAS} {KINTEX UltraScale+ FPGAs} \
 {KINTEX-ULTRASCALE-RADHARD-FPGAS} {KINTEX UltraScale RadHard FPGAs} \
 {ZYNQ} {ZYNQ} \
 {ZYNQ-ULTRASCALEPLUS-FPGAS} {ZYNQ UltraScale+ FPGAs} \
 {ZYNQ-ULTRASCALEPLUS-RFSOC-FPGAS} {ZYNQ UltraScale+ RFSoC FPGAs} \
 {QZYNQ-ULTRASCALEPLUS-RFSOC-FPGAS} {QZYNQ UltraScale+ RFSoC FPGAs} \
 {QZYNQ-ULTRASCALEPLUS} {QZYNQ UltraScale+ FPGAs} \
 {QVIRTEX-ULTRASCALEPLUS} {QVIRTEX UltraScale+ FPGAs} \
 {QKINTEX-ULTRASCALEPLUS} {QKINTEX UltraScale+ FPGAs} \
 {HAPS-70} {VIRTEX7} \
 {HAPS-HS-V6T} {VIRTEX6} \
 {HAPS-60} {VIRTEX6} \
 {HAPS-600} {VIRTEX6} \
 {HAPS-51T} {VIRTEX5} \
 {HAPS-51FXT} {VIRTEX5} \
 {HAPS-50} {VIRTEX5} \
 {CHIPIT-V5} {VIRTEX5} \
 {QPROVIRTEXH} {QPro Virtex Hi-Rel} \
 {QPROVIRTEXR} {QPro Virtex Rad-Hard} \
 {QPROVIRTEX-EM} {QPro VirtexE Military} \
 {QPROVIRTEX2} {QPro Virtex2 Military} \
 {QPRORVIRTEX2} {QPro Virtex2 Rad Tolerant} \
 {QPROVIRTEX4} {Defense-Grade Virtex-4Q} \
 {QPRORVIRTEX4} {Space-Grade Virtex-4QV} \
 {QPROVIRTEX5} {Defense-Grade Virtex-5Q} \
 {QPRORVIRTEX5} {Virtex-5QV} \
 {QPROVIRTEX6} {Defense-Grade Virtex-6Q} \
 {QPROVIRTEX6-LOWER-POWER} {Defense-Grade Virtex-6Q Lower Power} \
 {QPROSPARTAN6} {Defense-Grade Spartan-6Q} \
 {QPROSPARTAN6-LOWER-POWER} {Defense-Grade Spartan-6Q Lower Power} \
 {DEFENSE-GRADE-ARTIX7} {Defense-Grade Artix7} \
 {DEFENSE-GRADE-KINTEX7} {Defense-Grade Kintex7} \
 {DEFENSE-GRADE-KINTEX7-LOW-VOLTAGE} {Defense-Grade Kintex7 Low Voltage} \
 {DEFENSE-GRADE-KINTEX-ULTRASCALE-FPGAS} {Defense-Grade Kintex UltraScale} \
 {DEFENSE-GRADE-VIRTEX7} {Defense-Grade Virtex7} \
 {DEFENSE-GRADE-ZYNQ} {Defense-Grade Zynq} \
 {XC9500} {XC9500 CPLDs} \
 {XC9500-XL} {XC9500XL CPLDs} \
 {XC9500-XV} {XC9500XV CPLDs} \
 {SPARTAN3} {SPARTAN3} \
 {SPARTAN2} {SPARTAN2} \
 {SPARTAN2E} {SPARTAN2E} \
 {SPARTAN3E} {SPARTAN3E} \
 {SPARTAN3A} {SPARTAN3A} \
 {SPARTAN6} {SPARTAN6} \
 {SPARTAN6-LOWER-POWER} {SPARTAN6 Lower Power} \
 {SPARTAN-3A-DSP} {SPARTAN-3A DSP} \
 {ASPARTAN2E} {Automotive Spartan2E} \
 {ASPARTAN3} {Automotive Spartan3} \
 {ASPARTAN6} {Automotive Spartan6} \
 {ASPARTAN7} {Automotive Spartan7} \
 {AARTIX7} {Automotive Artix7} \
 {AZYNQ} {Automotive Zynq} \
 {AKINTEX7} {Automotive Kintex7} \
 {AZYNQ-ULTRASCALEPLUS-FPGAS} {Automotive Zynq UltraScale+ FPGAs} \
 {ASPARTAN3E} {Automotive Spartan3E} \
 {ASPARTAN3A} {Automotive Spartan3A} \
 {COOLRUNNER2} {CoolRunner2 CPLDs} \
 {COOLRUNNER2S} {CoolRunner2S CPLDs} \
 {COOLRUNNER} {CoolRunner XPLA3 CPLDs} \
 {ACOOLRUNNER2} {Automotive CoolRunner2} \
]

proc map_xilinx_family_name { family_name } {
    global techMap
    set uc_family_name [string toupper $family_name]
    if [info exists techMap($uc_family_name)] {
        return $techMap($uc_family_name)
    }
    return ""
}



### This array list whether a particular taechnology is supported in ISE11 & Above

array set Ise11_Plus_techMap \
[list \
 {VIRTEX} {0} \
 {VIRTEX2} {0} \
 {VIRTEX2P} {0} \
 {VIRTEX4} {1} \
 {VIRTEX5} {1} \
 {VIRTEXE} {0} \
 {VIRTEX-E} {0} \
 {VIRTEX6} {1} \
 {VIRTEX6-LOWER-POWER} {1} \
 {VIRTEX7} {1} \
 {VIRTEX-ULTRASCALE-FPGAS} {1} \
 {VIRTEX-ULTRASCALEPLUS-FPGAS} {1} \
 {VIRTEX-ULTRASCALEPLUS-HBM-FPGAS} {1} \
 {VIRTEX-EVEREST-FPGAS} {1} \
 {ARTIX7} {1} \
 {ARTIX7-LOW-VOLTAGE} {1} \
 {SPARTAN7} {1} \
 {KINTEX7} {1} \
 {KINTEX7-LOWER-POWER} {1} \
 {KINTEX-ULTRASCALE-FPGAS} {1} \
 {KINTEX-ULTRASCALE-RADHARD-FPGAS} {1} \
 {QKINTEX-ULTRASCALEPLUS} {1} \
 {KINTEX-ULTRASCALEPLUS-FPGAS} {1} \
 {ZYNQ} {1} \
 {ZYNQ-ULTRASCALEPLUS-FPGAS} {1} \
 {ZYNQ-ULTRASCALEPLUS-RFSOC-FPGAS} {1} \
 {HAPS-70} {1} \
 {HAPS-HS-V6T} {1} \
 {HAPS-60} {1} \
 {HAPS-600} {1} \
 {HAPS-51T} {1} \
 {HAPS-51FXT} {1} \
 {HAPS-50} {1} \
 {CHIPIT-V5} {1} \
 {QPROVIRTEXH} {0} \
 {QPROVIRTEXR} {0} \
 {QPROVIRTEX-EM} {0} \
 {QPROVIRTEX2} {0} \
 {QPRORVIRTEX2} {0} \
 {QPROVIRTEX4} {1} \
 {QPRORVIRTEX4} {1} \
 {QPROVIRTEX5} {1} \
 {QPRORVIRTEX5} {1} \
 {QPROVIRTEX6} {1} \
 {QPROVIRTEX6-LOWER-POWER} {1} \
 {QPROSPARTAN6} {1} \
 {QPROSPARTAN6-LOWER-POWER} {1} \
 {DEFENSE-GRADE-ARTIX7} {1} \
 {DEFENSE-GRADE-KINTEX7} {1} \
 {DEFENSE-GRADE-KINTEX7-LOW-VOLTAGE} {1} \
 {DEFENSE-GRADE-KINTEX-ULTRASCALE-FPGAS} {1} \
 {DEFENSE-GRADE-VIRTEX7} {1} \
 {DEFENSE-GRADE-ZYNQ} {1} \
 {XC9500} {1} \
 {XC9500-XL} {1} \
 {XC9500-XV} {0} \
 {SPARTAN3} {1} \
 {SPARTAN2} {0} \
 {SPARTAN2E} {0} \
 {SPARTAN3E} {1} \
 {SPARTAN3A} {1} \
 {SPARTAN6} {1} \
 {SPARTAN6-LOWER-POWER} {1} \
 {SPARTAN-3A-DSP} {1} \
 {ASPARTAN2E} {0} \
 {ASPARTAN3} {1} \
 {ASPARTAN6} {1} \
 {ASPARTAN7} {1} \
 {AARTIX7} {1} \
 {AKINTEX7} {1} \
 {AZYNQ} {1} \
 {AZYNQ-ULTRASCALEPLUS-FPGAS} {1} \
 {ASPARTAN3E} {1} \
 {ASPARTAN3A} {1} \
 {COOLRUNNER2} {1} \
 {COOLRUNNER2S} {0} \
 {COOLRUNNER} {1} \
 {ACOOLRUNNER2} {1} \
]





proc check_tech_compatible { family_name } {
    global Ise11_Plus_techMap
    set uc_family_name [string toupper $family_name]
    if [info exists Ise11_Plus_techMap($uc_family_name)] {
        return $Ise11_Plus_techMap($uc_family_name)
    }
    return "-1"
}

# return major version number version  4, 5, 6 ...
# default to version 5
# try to extract version from readme. Simply take 1st digit prior to .
#  e.g.  "ISE Series 5.2i"
proc get_xilinx_ise_version {XilinxPath}  {
    global  xilinx_ver
    set xilinx_ver [get_env {SYN_XILINX_VERSION}]

    if {$xilinx_ver == ""} {
        set xilinx_ver "10" 

        #set xilinx_readme  "[get_env {XILINX}]/readme.txt"
        #set xilinx_fileset "[get_env {XILINX}]/fileset.txt"
        ### Not using "get_env" because 
        #if the XILINX variable is changed using menu Options -> P&R Environment Options and the new path is of form "D:\Xilinx\ISE11"
        ##then get_env returns "D:XilinxISE11" i.e. it the backslashes are interpreted as it is.

                set xilinx_readme  "$XilinxPath/../../readme.txt"
        set xilinx_fileset "$XilinxPath/../../fileset.txt"

        if {[file exists $xilinx_readme]} {
            set readmeFile [open $xilinx_readme]
            gets $readmeFile line1
            set vindex [string first "." $line1]
            if {$vindex > 0} {
                set xilinx_ver [string range $line1 [expr $vindex-2] [expr $vindex-1]]
            }
            close $readmeFile
        } elseif { [file exists $xilinx_fileset] } {
                      set filesetFile [open $xilinx_fileset]
                      set fileset_list [split [read $filesetFile] \n]
                      close $filesetFile
                      set versionList ""
                      set versionList [lsearch -inline -all -regexp $fileset_list "version="]
                      if { [string match $versionList "" ] != 1 } {
                             set latest_version [regsub {.*version=(.*)\}} $versionList {\1}]
                             set xilinx_ver [regsub {\..*} $latest_version  "" ]
                         } 
               }
     
          }
    
    return $xilinx_ver
}

# write_xilinx_npl()
#
# Write NPL file based on options from the current implementation.
#
proc write_xilinx_npl {npl_filename xilinx_ver} {
    global npl_file

    set project_name [project -name]
    set tech_name   [map_xilinx_family_name [get_option -technology]]
    set part_name   [get_option -part]
    set speed_grade [get_option -speed_grade]
    set package     [get_option -package]
    set result_file [get_option -result_file]
    set os_ver [get_env {OS}]
    if {[string match "Windows*" $os_ver] == 1} {
        # On Windows, convert / to backslash
        regsub -all {/} $result_file {\\} result_file 
    }

    set npl_file [open "$npl_filename" w]

    if {$xilinx_ver != "" && $xilinx_ver < "5"} {
        message "Using version 4 NPL file format"

        if {[string first "XC9500" $tech_name] == 0} {
            set speed_grade " "
        } else {
            set part_name   [string tolower $part_name]
            set speed_grade [string tolower $speed_grade]
            set package     [string tolower $package]
        }

        puts $npl_file "JDF E"
        puts $npl_file "PROJECT $project_name"
        puts $npl_file "DESIGN $project_name Normal"
        puts $npl_file "DEVKIT ${part_name}${speed_grade}${package}"
        puts $npl_file "DEVFAM ${tech_name}"
        puts $npl_file "FLOW EDIF"
        puts $npl_file "MODULE ${result_file}"
        puts $npl_file "MODSTYLE ${project_name} Normal"
        puts $npl_file " "
    } else {

        puts $npl_file "JDF F"
        puts $npl_file "PROJECT $project_name"
        puts $npl_file "DESIGN $project_name Normal"
        puts $npl_file "DEVFAM ${tech_name}"
        puts $npl_file "DEVFAMTIME 0"
        puts $npl_file "DEVICE ${part_name}"
        puts $npl_file "DEVICETIME 0"
        puts $npl_file "DEVPKG ${package}"
        puts $npl_file "DEVPKGTIME 0"
        puts $npl_file "DEVSPEED ${speed_grade}"
        puts $npl_file "DEVSPEEDTIME 0"
        puts $npl_file "FLOW EDIF"
        puts $npl_file "FLOWTIME 0"
        puts $npl_file "MODULE ${result_file}"
        puts $npl_file "MODSTYLE ${project_name} Normal"
        puts $npl_file {[STRATEGY-LIST]}
        puts $npl_file "Normal=True"
    }

    flush $npl_file
    close $npl_file
}

# is_file_newer()
#
# return 1 if file1 exists and is newer than file2
#
proc is_file_newer {file1 file2} {

    if ![file exists $file1] {
        return 0
    } else {
        if ![file exists $file2] {
            return 1
        } else {
            expr [file mtime $file1] > [file mtime $file2]
        }
    }
}

# launch_xilinx_ise_npl()
#
# Launch Xilinx ISE process
#
proc launch_xilinx_ise_npl {ise_exe npl_filename version} {

    message "Creating NPL file: $npl_filename"
    write_xilinx_npl $npl_filename $version;

    message "Launching ISE: $ise_exe $npl_filename"
    if {[file exists $ise_exe]} {

        set os_ver [get_env {OS}]
        if {[string match "Windows*" $os_ver] == 1} {
            # On Windows, convert / to backslash
            regsub -all {/} $npl_filename {\\} npl_filename 
        }
        exec $ise_exe $npl_filename &
    } else {
        set error "file not found: $ise_exe"
        message -dialog $error;
    }
    return ""
}

# launch_xilinx_vivado()
#
# Launch Xilinx Vivado process
#
proc launch_xilinx_vivado {vivado_exe root_filename} {

    set vivado_dir [file dirname $vivado_exe]

    return ""
}

# launch_xilinx_ise()
#
# Launch Xilinx ISE process
# First create a Xilinx CLI file based on options from the current implementation.
# Then run pjcli which translates the CLI file to NPL format.
# Xilinx recommends this method to keep the NPL version independent.
#
proc launch_xilinx_ise {ise_exe root_filename} {

    set ise_dir [file dirname $ise_exe]

    set pjcli_exe [file join $ise_dir "pjcli"]  
    set xtclsh_exe [file join $ise_dir "xtclsh"]

    set cli_filename "${root_filename}.cli"
    set ise_tcl_filename "${root_filename}_launchise.tcl"
    set time_filename ${root_filename}.ise_mark

    set xilinx_ver [get_xilinx_ise_version $ise_dir ]

    if {$xilinx_ver < "7"} {
        set result_file "$root_filename.npl"
    } elseif {$xilinx_ver < "12"} {
        set result_file "$root_filename.ise"
    } else {
        set result_file "$root_filename.xise"
    }

    set error ""
    set overwriteExistingNpl 1

    set tech_name   [map_xilinx_family_name [get_option -technology]]
    if {$tech_name == ""} {
        set tech_name [get_option -technology]
        message -dialog "Technology is not supported for ISE launch: $tech_name"
        return "";
    } elseif  { $xilinx_ver > "10" } {
        set check_tech_11 [check_tech_compatible [get_option -technology]]
        if { $check_tech_11 != 1 } {
                message -dialog "Technology \"$tech_name\" is not supported for ISE launch with current ISE version \"$xilinx_ver\".\n Please use a older version of ISE."
        return "";
            }
    }
        
    if {[is_file_newer $result_file $time_filename]} {
        set overwriteExistingNpl [message -question "
Your ISE project file has been modified since the last ISE invocation.
Continuing will overwrite your ISE project file: $result_file.
Any changes that were made to this file from within ISE will be lost.

Do you want to continue ?"]
    }

    if {$overwriteExistingNpl == 1} {
        set use_ise_40_launch 0

        if {$xilinx_ver != "" && $xilinx_ver < "5"} {
            set use_ise_40_launch 1
        }
        if {$use_ise_40_launch} {
            set npl_filename "$root_filename.npl"
            launch_xilinx_ise_npl $ise_exe $npl_filename $xilinx_ver
            
        } else {


                      if { $xilinx_ver > 10 } {
                    ### Create the TCL file for XTCLSH and create an ISE file ###
                    message "Creating TCL file: $ise_tcl_filename"
                write_xilinx_tcl $ise_tcl_filename $root_filename
                message "Creating the ISE Projectfile: $xtclsh_exe \"$ise_tcl_filename\""
                    set ret [catch {eval exec  $xtclsh_exe "$ise_tcl_filename"} res]
            } else {

                message "Creating CLI file: $cli_filename"
                    write_xilinx_cli $ise_dir $cli_filename $root_filename
                    message "Running CLI to NPL translation: $pjcli_exe -filename $cli_filename"
                        set ret [catch {eval exec $pjcli_exe -filename "$cli_filename"} res]
            }


            # currently return code is always 0 regardless of failure.
            # So seach for ERROR in output is only way to detect failure.

            set xtclsh_rc [string toupper $res]
            if {[string first "ERROR" $xtclsh_rc] != -1} {
                              #Temporary workaround, not stoping on following error message -- SY
                          if {[string match "Invalid path, UNC format" $xtclsh_rc] == -1} {
                    message -dialog "Unable to create Xilinx project file.\n$res"
                    return "";
                }
            }

            if {[string length $res] > 0} {
                message $res
            }

            message "Launching ISE: $ise_exe $result_file"
            if {[file exists $ise_exe]} {
                set ret [catch {eval exec $ise_exe "$result_file" &} res]
                set ise_launch_rc [string toupper $res]
                if {[string first "ERROR" $ise_launch_rc] != -1} {
                    message -dialog "Error launching Xilinx ISE."
                    return "";
                }

            } else {
                set error "File not found: $ise_exe"
            }

            if {$error != ""} {
                message -dialog $error
            }

        }

        # Create file marking NPL creation time.
        # If NPL is newer then this file, then it's been modified by some other process
        set time_file [open $time_filename w]
        puts $time_file "Xilinx NPL time marker file"
        flush $time_file
        close $time_file
    }

    return ""
}

# launch_system_command()
#
# Use exec to launch system command
#
proc launch_system_command {command {args ""} {background "1"}} {

    message "Launching: $command"

    #Detect HP-UX and work around a TCL bug that returns an incorrect TCL code
    global tcl_platform
    set os $tcl_platform(os)
    set hp [expr [string compare $os "HP-UX"] == 0]
    set log "/dev/null"

    #Netscape is launched with special arguments to re-use window
    if {[regexp netscape $command]} { 
        if {$hp == 0} { 
            set ncommand [concat $command -remote \"openURL($args,new-window)\"]
            set estat [catch {eval [concat exec $ncommand >> $log]} msg]
            if {$estat} {
                #Failed - try exec again without special arguments
                set estat [catch {eval [concat exec $command $args >> $log &]} msg]
            }             
        } else {
            # Special case for HP
            set ncommand [concat $command -remote \"openURL($args,new-window)\"]
            set estat [catch {eval [concat exec $ncommand >> $log]} msg]
            # HP has problem returning correct estat with the -remote openURL netscape command.
            # Therefore parse msg to try to detect failure. If no failure seen, assume success.
            if {[regexp "not running on display" $msg] ||
                [regexp "No running window found" $msg] ||
                [regexp "couldn't execute" $msg]} {
                #Failed - try exec again without special arguments. This one return correct estat
                set estat [catch {eval [concat exec $command $args >> $log &]} msg]
            } else {
                # assume success if no failure message seen in remote launch attempt
                set estat 0
            }
        }
    } else {
        set estat [catch {eval [concat exec $command $args >> $log &]} msg]
    }

    if {$estat} {
        error $msg
    }

    return $msg
}


# Find Helper commands
#

# Print value or <prop> on each object matching pattern
#
proc nl_print_prop { pattern prop } {
    if {[string first * $pattern] >= 0} {
        foreach sig [find $pattern -filter @$prop] {puts "$sig\n$prop=[nl_get_prop $sig $prop]\n"}
    } else {
        set args [lrange $pattern 0 end]
        foreach sig $args {
            puts "$sig\n$prop=[nl_get_prop $sig $prop]\n"
        }
    }
}

# Print value or <prop> on each object matching pattern
#
proc nl_print_prop_values { signal_name } {
    set first_sig [lindex $signal_name 0]
    set prop_list [nl_get_prop $first_sig -all]

    set args [lrange $signal_name 0 end]
    foreach sig $args {
        puts "\nProperties of $sig\n"
        foreach prop $prop_list {
            set propVal [nl_get_prop $sig $prop]
            if {$propVal != ""} {
                puts "$prop=$propVal"
            }
        }
    }
}

# checks if the synplicity hook is defined
#
proc is_hook_available {cmd} {

    set str [info command $cmd]
    if {[string compare $str $cmd] != 0} {
        return "NO"
    }
    return "YES"
}

# install_identify()
#
#
proc install_identify {identifydir} {

    global tcl_platform
    set os $tcl_platform(os)
    set hp [expr [string compare $os "HP-UX"] == 0]
    if {$hp != 0} { 
        message "Identify not supported for HP\n"
        return 0
    }

    message "Installing Identify\n"

    if {[string match "Windows*" $os] == 1} {
    
        set setup_exe [file join $identifydir "setup.exe"]
        if {[file exists $setup_exe]} {
        
            exec $setup_exe
            return 0
        } else {
            message "Install files for Identify not found"
            return 1
        }
    } else {
        set setup_sh [file join $identifydir "install.sh"]
        if {[file exists $setup_sh]} {
            exec /bin/sh $setup_sh
            return 0
        } else {
            message "Install files for Identify not found\n"
            return 1
        }
    }
    return 0
}


# get_identify_instrumentor()
#
#
proc get_identify_instrumentor {} {

    global tcl_platform
    set os $tcl_platform(os)
    set hp [expr [string compare $os "HP-UX"] == 0]
    if {$hp != 0} { 
        message "Identify not supported for HP\n"
        return 0
    }
    set path ""

    set path [exec which identify_instrumentor]
    return $path
}



if { $shellflavor != "protobatch" && $shellflavor != "protocompiler" } {
    #Alias for the status_report which fetches the contents from status reports
    proc report_area {args } {
        eval [concat status_report -name area_report $args]
    }

    proc report_timing_summary {args } {
        eval [concat status_report -name timing_report $args]
    }

    proc report_opt {args } {
        eval [concat status_report -name opt_report $args]
    }
    #Alias for job => sub_impl  job is now used in protocompiler. In Synplify job was changed to sub_impl
    proc job {args } {
        eval [concat sub_impl $args]
    }
}

proc process_ip_project { args } {
    set projectFile   [lindex $args 0]
    set ipParamFile   [lindex $args 1]
    puts "projectFile=$projectFile"
    puts "ipParamFile=$ipParamFile"

    set fid [open $ipParamFile w]
    puts $fid "ip_name FIFO"
    puts $fid "import_constraints 0"
    puts $fid "synthesis  vivado"
    close $fid

    return "process_ip_project was called" 
}

