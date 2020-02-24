# $Header: //synplicity/ui2019q3p1/ui/analyst/analyst.tcl#1 $
# Analyst TCL procedures

global application_channel
global SERVER_SUSPENDED
global SERVER_SUSPENDED
set application_channel ""

# This procedure changes characters in "name" to those acceptable to ModelSim
proc ConvertName {name} {
    regsub -all {\.} $name / r1
    regsub -all {\[} $r1  ( r2
    regsub -all {\]} $r2 ) r3
    return $r3
}

proc Connect_to_Modelsim {} {
    global env
    set port [lindex [ array get env  MTIPORT ] 1]
    if {[string compare $port ""] == 0 } {
        # MTIPID not set - use default
        # error "MTIPORT not set"
        set port 1025
    }
    Connect_Client $port
    sendrls
}

# Proc to connect the client to the server
proc Connect_Client {port} {
    global SERVER_SUSPENDED

    set s [Connect_Client_core localhost $port]
    return $s
}

# Core Proc to connect the client to the server
# This proc opens the client side of the socket
proc Connect_Client_core {host port} {
    global application_channel
    global SERVER_SUSPENDED

    set s [socket $host $port]
    set application_channel $s
    fconfigure $s -buffering line
    return $s
}


# Base proc to send stuff to the server
proc sendmsg {type cmd args} {
    global application_channel
    global SERVER_SUSPENDED

    set x [puts $application_channel "$type $cmd $args"]
    return $x
}


# Send a command to be executed to the server
proc sendcmd {cmd args} {
    global application_channel
    global SERVER_SUSPENDED

    fconfigure $application_channel -blocking 1
    if {[llength $args] == 0} {
        sendmsg CMD $cmd
    } else {
        sendmsg CMD $cmd $args
    }
    if {[string compare $cmd "exit"] == 0} {
        sendmsg CMD exit
        return
    }
    if {[string compare $cmd "quit"] == 0} {
        sendmsg CMD exit
        return
    }
    set result [gets $application_channel]
    if {[string compare [lindex $result 0] SERVER_FAILURE] == 0} {
        puts "IPC_ERROR: Command failed at Server:"
        puts [lindex $result 1]
    } else {
        if {[llength [lindex $result 1]] > 0} {
            return [lindex $result 1]
        }
    }
}

# Send a display wave command to be executed to the server
proc sendcmd_wav {cmd args} {
    global application_channel
    global SERVER_SUSPENDED

    fconfigure $application_channel -blocking 1
    if {[llength $args] == 0} {
        sendmsg CMD $cmd
    } else {
        sendmsg CMD $cmd $args
    }
    set result [gets $application_channel]
    if {[string compare [lindex $result 0] SERVER_FAILURE] == 0} {
        puts "IPC_ERROR: Command failed at Server:"
        puts [lindex $result 1]
    } else {
        if {[llength [lindex $result 1]] > 0} {
        set new_res "No objects found matching:"
        foreach val [lindex $result 1] {
        if {[llength $val] == 5} {
            if {[string compare [lrange $val 0 3] "No objects found matching"] == 0} {
                lappend new_res [string trimright [lindex $val 4] "."]
            }
        }
        }
            return $new_res
        }
    }
}

proc sendrls {} {
    global application_channel
    global SERVER_SUSPENDED

    sendmsg RLS {}
    puts "Freeing Server Connection"
    set result [gets $application_channel]
    set SERVER_SUSPENDED 1
    #vwait SERVER_SUSPENDED
}
