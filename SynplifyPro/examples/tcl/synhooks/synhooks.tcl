# Purpose: This file is intended to allow user-customization and 
# integration of Synplicity's products with end-user version control systems, etc.

# **** IMPORTANT!!! ****
#
# 1) Please move this file out of the Synplicity installation area and modify as required.
# 2) Set the environment variable SYN_TCL_HOOKS to point to the new location of this file. 
#    Example: C:/work/synhooks.tcl
#
#    On Unix: setenv SYN_TCL_HOOKS /home/usr/synhooks.tcl 	
# The above steps are required to make sure that future Synplicity product installations 
# do not overwrite the modified synhooks.tcl file.
#


# Called while creating a new project, please add your default project settings here
proc syn_on_set_project_template {project_path} {

# project_path: Path name to the project being created. 

 puts "*** syn_on_set_project_template called. Options: $project_path"
# TODO: Add your custom code here
}

# Called while creating a new project
proc syn_on_new_project {project_path} {

# project_path: Path name to the project being created. 

 puts "*** syn_on_new_project called. Options: $project_path"
# TODO: Add your custom code here
}

# Called while opening the project
proc syn_on_open_project {project_path} {

# project_path: Path name to the project being opened. 

 puts "*** syn_on_open_project called. Options: $project_path"
# TODO: Add your custom code here
}

# Called after closing the project
proc syn_on_close_project {project_path} {

# project_path: Path name to the project being opened.
 
 puts "*** syn_on_close_project called. Options: $project_path"
# TODO: Add your custom code here
}

#Called at the time of starting the application after opening the previously open project if any.
proc syn_on_start_application {app_name version curdir} {

# app_name: Application name. Ex:synplify_pro
# version:  Version name.     Ex:Synplify Pro 1.0
# curdir:   Run directory.    Ex:C:\designs\design1

 puts "*** syn_on_start_application called. Options: $app_name, $version, $curdir"
# TODO: Add your custom code here
}

# Called at the time of exiting the application
proc syn_on_exit_application {app_name version} {

# app_name: Application name. Ex:synplify_pro
# version:  Version name.     Ex:Synplify Pro 1.0

 puts "*** syn_on_exit_application called. Options: $app_name, $version"
# TODO: Add your custom code here
}

# Called at the start of each run. 
proc syn_on_start_run {runName run_dir implName} {

# runName:      Name of the run Ex: compile, synthesis
# run_dir:      Current run directory.
# implName:     Implementation Name Ex:rev_1

 puts "*** syn_on_start_run called. Options: $runName, $run_dir, $implName"

# example only write your custom code here
# get selected files from the project browser

#    set sel_files [get_selected_files -browser]

#    while {[expr [llength $sel_files] > 0]} {

#        set file_name [lindex $sel_files 0]
#        puts $file_name
#        set sel_files [lrange $sel_files 1 end]
#    }

# TODO: Add your custom code here
}

# Called at the end of each run.
proc syn_on_end_run {runName run_dir implName} {

# runName:      Name of the run Ex: compile, synthesis 
# run_dir:      Current run directory.
# implName:     Implementation Name Ex:rev_1

 puts "*** syn_on_end_run called. Options: $runName, $run_dir $implName"
# TODO: Add your custom code here
}

# Called when the Control-F8 keys are pressed together.
proc syn_on_press_ctrl_f8 {} {

 puts "*** syn_on_press_ctrl_f8 called"
# example only write your custom code here
# get all the selected files from project browser and project directory

#    set sel_files [get_selected_files]

#    while {[expr [llength $sel_files] > 0]} {

#        set file_name [lindex $sel_files 0]
#        puts $file_name
#        set sel_files [lrange $sel_files 1 end]
#    }

# TODO: Add your custom code here
}

# Called when the Control-F9 keys are pressed together.
proc syn_on_press_ctrl_f9 {} {

 puts "*** syn_on_press_ctrl_f9 called"
# example only write your custom code here
# get all the selected files from implementation directory

#    set sel_files [get_selected_files -directory]

#    while {[expr [llength $sel_files] > 0]} {

#        set file_name [lindex $sel_files 0]
#        puts $file_name
#        set sel_files [lrange $sel_files 1 end]
#    }

# TODO: Add your custom code here
}

# Called when the Control-F11 keys are pressed together.
proc syn_on_press_ctrl_f11 {} {

 puts "*** syn_on_press_ctrl_f11 called"
# TODO: Add your custom code here
}
