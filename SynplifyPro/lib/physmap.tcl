# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
# $Header: //synplicity/ui2019q3p1/misc/physmap.tcl#1 $
# $Name$
# TCL commands to implement AmplifyASIC physical constraints
#

#
# set up global variable _lib_
#
#create_top_level_bbox  -bbox <bbox>

# ToDo: Test with spaces
# ToDo: Check for overlaps

proc create_top_level_bbox {args} {
	#puts "$args"
	set args_copy "create_top_level_bbox $args"
	set llcx ""
	set llcy ""
	set urcx ""
	set urcy ""
	if [expr [llength $args] < 2] {
		error "Incorrect number of arguments. create_top_level_bbox usage: create_top_level_bbox -bbox { bbox }"
		return
	}
	while {[expr [llength $args] >0]} {
		set sw [lindex $args 0]
		set objname [lindex $args 1]
		set args [lrange $args 2 end]
		if { [string range $sw 0 0] != {-} } {
			error [format "Unknown word %s is found in the argument list of create_top_level_bbox" $sw]
			return
		}
		if { $sw == "-bbox" } {
			if {[expr [llength $objname] < 4]} {
				error "Bounding box of create_top_level_bbox is incomplete"
				return
			}
			set llcx [lindex $objname 0]
			set llcy [lindex $objname 1]
			set urcx [lindex $objname 2]
			set urcy [lindex $objname 3]
			set create_top_level_bbox_error [ampasic_is_box_legal $llcx $llcy $urcx $urcy]
			if {$create_top_level_bbox_error == "2"} {
				error [format "Illegal geometry box \{%s %s %s %s\} in command: %s" $llcx $llcy $urcx $urcy $args_copy]
				return
			} elseif {$create_top_level_bbox_error == "1"} {
				error [format "Geometry box coordinates are not numerical in command: %s" $llcx $llcy $urcx $urcy $args_copy]
				return
			}
		} else {
			error [format "Unsupported word %s found in the argument list of create_top_level_bbox" $sw]
			return
		}
	}
	if {$llcx == ""} {
		error "Bounding box of create_top_level_bbox is missing"
		return
	}
	set arg "llcx=$llcx,llcy=$llcy,urcx=$urcx,urcy=$urcy"
	ampasic_define_attribute syn_create_top_bbox $arg $args_copy
}

#create_region -name <region_name> [-bbox <bbox>] [-type soft|hard|seq_only_hard|seq_only_soft|group] [-util %]
proc create_region {args} {
	#puts "$args"
	set rgnname ""
	set rgntype ""
	set args_copy "create_region $args"
	set llcx ""
	set llcy ""
	set urcx ""
	set urcy ""
	set util "-1"
	if [expr [llength $args] < 2] {
		error "Incorrect number of arguments. create_region usage: create_region -name {name} -bbox { bbox } -type {soft|hard|seq_hard_only|group}"
		return
	}
	while {[expr [llength $args] >0]} {
		set sw [lindex $args 0]
		set objname [lindex $args 1]
		set args [lrange $args 2 end]
		if { [string range $sw 0 0] != {-} } {
			error [format "Unknown word %s is found in the argument list of create_region" $sw]
			return
		}
		if { $sw == "-name" } {
			set rgnname $objname
		} elseif { $sw == "-bbox" } {
			if {[expr [llength $objname] < 4]} {
				error "Bounding box of create_region is incomplete"
				return
			}
			set llcx [lindex $objname 0]
			set llcy [lindex $objname 1]
			set urcx [lindex $objname 2]
			set urcy [lindex $objname 3]
			set create_region_error [ampasic_is_box_legal $llcx $llcy $urcx $urcy]
			if {$create_region_error == "2"} {
				error [format "Illegal geometry box \{%s %s %s %s\} in command: %s" $llcx $llcy $urcx $urcy $args_copy]
				return
			} elseif {$create_region_error == "1"} {
				error [format "Geometry box coordinates are not numerical in command: %s" $args_copy]
				return
			}
		} elseif { $sw == "-type" } {
			set rgntype $objname
			if {[CheckRegionType $rgntype]} {
				error [format "Illegal region type %s" $rgntype]
				return
			}
			if {$rgntype == "group"} {
				set llcx "-1"
				set llcy "-1"
				set urcx "-1"
				set urcy "-1"
			}
		} elseif { $sw == "-util" } {
			set util $objname
		} else {
			error [format "Unknown word %s is found in the argument list of create_region" $sw]
			return
		}
	}
	if {$rgnname == ""} {
		error "Region name of create_region is missing"
		return
	}
	if {$llcx == ""} {
		error "Bounding box of create_region is missing"
		return
	}
	set arg "llcx=$llcx,llcy=$llcy,urcx=$urcx,urcy=$urcy"
    ampasic_define_attribute syn_create_region $rgnname $rgntype $util $arg $args_copy
}

proc CheckOrn {orn} {
	if {($orn == "n") || ($orn == "s") || ($orn == "e") || ($orn == "w") ||
		($orn == "fn") || ($orn == "fs") || ($orn == "fe") || ($orn == "fw")} {
		return 0
	}
	if {($orn == "N") || ($orn == "S") || ($orn == "E") || ($orn == "W") ||
		($orn == "FN") || ($orn == "FS") || ($orn == "FE") || ($orn == "FW")} {
		return 0
	}
	return 1
}

proc CheckPortUsage {type} {
	if {($type == "SIGNAL") || ($type == "POWER") || ($type == "GROUND") ||
	    ($type == "signal") || ($type == "power") || ($type == "ground")} {
		return 0
	}
	return 1
}
proc CheckPortDir {type} {
	if {($type == "INPUT") || ($type == "OUTPUT") || ($type == "INOUT") ||
	    ($type == "input") || ($type == "output") || ($type == "inout")} {
		return 0
	}
	return 1
}
proc CheckPlacementType {type} {
	if {($type == "fixed") || ($type == "placed") || ($type == "unplaced") || ($type == "cover") ||
		($type == "FIXED") || ($type == "PLACED") || ($type == "UNPLACED") || ($type == "COVER")} {
		return 0
	}
	return 1
}
proc CheckBlockageType {type} {
	if {($type == "soft_placement") || ($type == "placement") || ($type == "hard_placement") ||
		($type == "SOFT_PLACEMENT") || ($type == "PLACEMENT") || ($type == "HARD_PLACEMENT")} {
		return 0
	}
	return 1
}
proc CheckRegionType {type} {
	if {($type == "soft") || ($type == "hard") ||
		($type == "SOFT") || ($type == "HARD") || 
		($type == "seq_only_hard") || ($type == "SEQ_ONLY_HARD") ||
		($type == "seq_only_soft") || ($type == "SEQ_ONLY_SOFT") ||
		($type == "group") || ($type == "GROUP")} {
		return 0
	}
	return 1
}

#Place_instance  -instance <macro_name> [-location <loc>] [-orient <N|S|E|W|FN|FS|FE|FW| >] -placement_type {FIXED | PLACED | COVER | UNPLACED}
proc place_instance {args} {
	#puts "$args"
	set instname ""
	set orn ""
	set plcAttr ""
	set args_copy "place_instnace $args"
	set llcx ""
	set llcy ""
	if [expr [llength $args] < 2] {
		error "Incorrect number of arguments. place_instance usage: place_instance -instance {macro_name} -location { loc } -orient [<N|S|E|W|FN|FS|FE|FW>]"
		return
	}
	while {[expr [llength $args] >0]} {
		set sw [lindex $args 0]
		set objname [lindex $args 1]
		if {[ampasic_is_name_legal $objname "instance"] == "0"} {
			error [format "Illegal instance name %s in command: %s" $objname $args_copy]
			return
		}
		set args [lrange $args 2 end]
		if { [string range $sw 0 0] != {-} } {
			error [format "Unsupported word %s found in the argument list of place_instance" $sw]
			return
		}
		if { $sw == "-instance" } {
			set instname $objname
		} elseif { $sw == "-location" } {
			if {[expr [llength $objname] < 2]} {
				error "Instance location of place_instance command is incomplete"
				return
			}
			set llcx [lindex $objname 0]
			set llcy [lindex $objname 1]
			if {[ampasic_is_point_legal $llcx $llcy] == "0"} {
				error [format "Illegal point \{%s %s\} in command: %s" $llcx $llcy $args_copy]
				return
			}
		} elseif { $sw == "-orient" } {
			set orn $objname
			if {[CheckOrn $orn]} {
				error [format "Incorrect orientation %s in the argument list of place_instance command" $orn]
				return
			}
		} elseif { $sw == "-placement_type" } {
			set plcAttr $objname
			if {[CheckPlacementType $plcAttr]} {
				error [format "Incorrect placement type %s in the argument list of place_instance command" $plcAttr]
				return
			}
		} else {
			error [format "Unsupported word %s found in the argument list of place_instance" $sw]
			return
		}
	}
	if {$instname == ""} {
		error "Instance name is not specified in the argument list of place_instance command"
		return
	}
	if {$plcAttr == ""} {
		error "Placement type is not specified in the argument list of place_instance command"
		return
	}
	if {($plcAttr != "UNPLACED") && ($llcx == "")} {
		error "Instance location is not specified in the argument list of place_instance command"
		return
	}
	set arg "llcx=$llcx,llcy=$llcy"
    ampasic_define_attribute syn_place_instance $instname $orn $plcAttr $arg $args_copy
}

#assign_logic -region <region_name> -instance <instpath>
proc assign_logic {args} {
	#puts "$args"
	set rgnname ""
	set instpath ""
	set args_copy "assign_logic $args"
	set llcx ""
	set llcy ""
	set urcx ""
	set urcy ""
	if [expr [llength $args] < 4] {
		error "Incorrect number of arguments. assign_logic usage: assign_logic -region {region_name} -instance { instpath }"
		return
	}
	while {[expr [llength $args] >0]} {
		set sw [lindex $args 0]
		set objname [lindex $args 1]
		set args [lrange $args 2 end]
		if { [string range $sw 0 0] != {-} } {
			error [format "Unsupported word %s found in the argument list of assign_logic command" $sw]
			return
		}
		if { $sw == "-region" } {
			set rgnname $objname
		} elseif { $sw == "-instance" } {
			set instpath $objname
			if {[ampasic_is_name_legal $instpath "instance"] == "0"} {
				error [format "Illegal instance name %s in command: %s" $instpath $args_copy]
				return
			}
		} else {
			error [format "Unsupported word %s found in the argument list of assign_logic command" $sw]
			return
		}
	}
	if {$rgnname == ""} {
		error "Region name is not specified in the argument list of assign_logic command"
		return
	}
	if {$instpath == ""} {
		error "Instance path is not specified in the argument list of assign_logic command"
		return
	}
    ampasic_define_attribute syn_assign_logic $rgnname $instpath $args_copy
}

proc error {args} {
	ampasic_define_attribute syn_clean_trash;
	ampasic_log_puts "$args"
}

# create_blockage [-name {name}] -bbox {a b c d} -type {hard_placement|soft_placement}
proc create_blockage {args} {
	#puts "$args"
	set args_copy "create_blockage $args"
	set blkname "BNoName"
	set blktype ""
	set llcx ""
	set llcy ""
	set urcx ""
	set urcy ""
	if [expr [llength $args] < 4] {
		error "Incorrect number of arguments. create_blockage usage: create_blockage [-name { name }]  -bbox { bbox } -type { hard_placement|soft_placement }"
		return
	}
	while {[expr [llength $args] >0]} {
		set sw [lindex $args 0]
		set objname [lindex $args 1]
		set args [lrange $args 2 end]
		if { [string range $sw 0 0] != {-} } {
			error [format "Unsupported word %s found in the argument list of create_blockage command" $sw]
			return
		}
		if { $sw == "-name" } {
			set blkname $objname
			if {$blkname == ""} {
				error [format "Missing blockage name in command: %s" $args_copy]
				return
			}
		} elseif { $sw == "-bbox" } {
			if {[expr [llength $objname] < 4]} {
				error "Bounding box is incomplete in the argument list of create_blockage command"
				return
			}
			set llcx [lindex $objname 0]
			set llcy [lindex $objname 1]
			set urcx [lindex $objname 2]
			set urcy [lindex $objname 3]
			set create_blockage_error [ampasic_is_box_legal $llcx $llcy $urcx $urcy]
			if {$create_blockage_error == "2"} {
				error [format "Illegal geometry box \{%s %s %s %s\} in command: %s" $llcx $llcy $urcx $urcy $args_copy]
				return
			} elseif {$create_blockage_error == "1"} {
				error [format "Geometry box coordinates are not numerical in command: %s" $args_copy]
				return
			}
		} elseif { $sw == "-type"} {
			set blktype $objname
			if {[CheckBlockageType $blktype]} {
				error [format "Incorrect placement blockage type in create_blockage command: %s" $args_copy]
				return
			}
		} else {
			error [format "Unsupported word %s found in the argument list of create_blockage command" $sw]
			return
		}
	}
	if {$blktype == ""} {
		error "Blockage type is not specified in the argument list of create_blockage command"
		return
	}
	if {$llcx == ""} {
		error "Blockage bounding box is not specified in the argument list of create_blockage command"
		return
	}
	set arg "llcx=$llcx,llcy=$llcy,urcx=$urcx,urcy=$urcy"
	ampasic_define_attribute syn_create_blockage $blkname $blktype $arg $args_copy
}

#set_port_location -pin <port_name> [-location <loc>] [-layer_name <layer name>] [-layer_area <x1, y1, x2, y2>] [-placement_type <FIXED|PLACED>] [-net <net_name>] [-dir <INPUT|OUTPUT|INOUT>] [-use <SIGNAL|POWER|GROUND>]
proc set_port_location {args} {
	#puts "$args"
	set portname ""
	set args_copy "set_port_location $args"
	set x ""
	set y ""
	set llcx ""
	set llcy ""
	set urcx ""
	set urcy ""
	set plcAttr ""
	set orn ""
	set net ""
	set dir ""
	set use ""
	set layer ""
	if [expr [llength $args] < 2] {
		error "Incorrect number of arguments. set_port_location usage: set_port_location -pin {port_name} -location {x y}"
		return
	}
	while {[expr [llength $args] >0]} {
		set sw [lindex $args 0]
		set objname [lindex $args 1]
		set args [lrange $args 2 end]
		if { [string range $sw 0 0] != {-} } {
			error [format "Unsupported word %s found in the argument list of set_port_location" $sw]
			return
		}
		if { $sw == "-pin" } {
			set portname $objname
			if {[ampasic_is_name_legal $portname "pin"] == "0"} {
				error [format "Illegal pin name %s in command: %s" $portname $args_copy]
				return
			}
		} elseif { $sw == "-location" } {
			if {[expr [llength $objname] < 2]} {
				error [format "port location of set_port_location command is incomplete %s %s" $portname $objname]
				return
			}
			set x [lindex $objname 0]
			set y [lindex $objname 1]
			if {[ampasic_is_point_legal $x $y] == "0"} {
				error [format "Illegal point \{%s %s\} in command: %s" $x $y $args_copy]
				return
			}
		} elseif { $sw == "-placement_type" } {
			set plcAttr $objname
			if {[CheckPlacementType $plcAttr]} {
				error [format "Incorrect placement type %s in the argument list of set_port_location command" $plcAttr]
				return
			}
		} elseif { $sw == "-layer_area" } {
			if {[expr [llength $objname] < 4]} {
				error [format "pin shape of set_port_location command is incomplete %s %s" $portname $objname]
			 	return
			}
			set llcx [lindex $objname 0]
			set llcy [lindex $objname 1]
			set urcx [lindex $objname 2]
			set urcy [lindex $objname 3]
			set set_port_location_error [ampasic_is_box_legal $llcx $llcy $urcx $urcy]
			if {$set_port_location_error  == "2"} {
				error [format "Illegal geometry box \{%s %s %s %s\} in command: %s" $llcx $llcy $urcx $urcy $args_copy]
				return
			} elseif {$set_port_location_error == "1"} {
				error [format "Geometry box coordinates are not numerical in command: %s" $llcx $llcy $urcx $urcy $args_copy]
				return
			}
		} elseif { $sw == "-layer_name" } {
			set layer $objname
		} elseif { $sw == "-orient" } {
			set orn $objname
			if {[CheckOrn $orn]} {
				error [format "Incorrect orientation %s in the argument list of set_port_location command" $orn]
				return
			}
		} elseif { $sw == "-net" } {
			set net $objname
			if {[ampasic_is_name_legal $net "net"] == "0"} {
				error [format "Illegal net name %s in command: %s" $net $args_copy]
				return
			}
		} elseif { $sw == "-dir" } {
			set dir $objname
			if {[CheckPortDir $dir]} {
				error [format "Incorrect pin direction type %s in the argument list of set_port_location command" $dir]
				return
			}
		} elseif { $sw == "-use" } {
			set use $objname
			if {[CheckPortUsage $use]} {
				error [format "Incorrect pin usage type %s in the argument list of set_port_location command" $use]
				return
			}
		} else {
			error [format "Unsupported word %s found in the argument list of set_port_location" $sw]
			return
		}
	}
	if {$portname == ""} {
		error [format "port name is not specified in the command: %s" $args_copy]
		return
	}
	if {$x == "" || $y == ""} {
		error [format "port location is not specified in the command: %s" $args_copy]
		return
	}
    ampasic_define_attribute syn_set_port_location $portname $x $y
}

#preplace_path -from <obj_name> [-thru <instance_name>] [-to <obj_name>] [-location <loc>] [-cluster]
proc preplace_path {args} {
	#puts "$args"
	set fromname ""
	set toname ""
	set thruname ""
	set thruObjs ""
	set args_copy "preplace_path $args"
	set x ""
	set y ""
	set cluster "false"
	set soft "false"
	if [expr [llength $args] < 2] {
		error "Incorrect number of arguments. preplace_path usage: preplace_path -from {obj_name} -to {obj_name}"
		return
	}
	while {[expr [llength $args] >0]} {
		set sw [lindex $args 0]
		set objname [lindex $args 1]
		set args [lrange $args 2 end]
		if { [string range $sw 0 0] != {-} } {
			error [format "Unsupported word %s found in the argument list of set_port_location" $sw]
			return
		}
		if { $sw == "-from" } {
			set fromname $objname
			if { [string range $fromname 1 1] == ":" } {
				if {[string range $fromname 0 0] != "t" && [string range $fromname 0 0] != "i" &&
				    [string range $fromname 0 0] != "p" && [string range $fromname 0 0] != "b"} {
					error [format "Illegal FROM name %s in command: %s" $fromname $args_copy]
					return
				}
			}
		} elseif { $sw == "-to" } {
			set toname $objname
			if { [string range $toname 1 1] == ":" } {
				if {[string range $toname 0 0] != "t" && [string range $toname 0 0] != "i" &&
				    [string range $toname 0 0] != "p" && [string range $toname 0 0] != "b"} {
					error [format "Illegal TO name %s in command: %s" $toname $args_copy]
					return
				}
			}
		} elseif { $sw == "-thru" } {
			set thruname $objname
			if {[ampasic_is_name_legal $thruname "instance"] == "0"} {
				error [format "Illegal THRU name %s in command: %s" $thruname $args_copy]
				return
			}
			if { $thruObjs != "" } {
				lappend thruObjs $thruname
			} else {
				lappend thruObjs $thruname
			}
		} elseif { $sw == "-location" } {
			if {[expr [llength $objname] < 2]} {
				error [format "fix location of preplace_path command is incomplete %s" $objname]
				return
			}
			set x [lindex $objname 0]
			set y [lindex $objname 1]
			if {[ampasic_is_point_legal $x $y] == "0"} {
				error [format "Illegal point \{%s %s\} in command: %s" $x $y $args_copy]
				return
			}
		} elseif { $sw == "-cluster" } {
			set cluster "true"
		} elseif { $sw == "-soft" } {
			set soft "true"
		} elseif { $sw == "-type" } {
			if { $objname == "cluster" } {
				set cluster "true"
			} elseif {$objname == "soft" } {
				set soft "true"
			}
		} else {
			error [format "Unsupported word %s found in the argument list of set_port_location" $sw]
			return
		}
	}
	if {($fromname == "") && ($toname == "") } {
		error "Both FROM and TO object are missing in preplace_path command"
		return
	}
    ampasic_define_attribute syn_preplace_path $fromname $thruObjs $toname $x $y $cluster $soft
}

#create_cluster -name <cluster_name> -instance <module_name>
proc create_cluster {args} {
	#puts "$args"
	set clusname ""
	set rgnname ""
	set instpath ""
	set args_copy "create_cluster $args"
	set llcx "-1"
	set llcy "-1"
	set urcx "-1"
	set urcy "-1"
	set util "-1"
	set rgntype "group"

	if [expr [llength $args] < 2] {
		error "Incorrect number of arguments. create_cluster usage: create_cluster -name {name} -instance {module_name}"
		return
	}
	while {[expr [llength $args] >0]} {
		set sw [lindex $args 0]
		set objname [lindex $args 1]
		set args [lrange $args 2 end]
		if { [string range $sw 0 0] != {-} } {
			error [format "Unknown word %s is found in the argument list of create_region" $sw]
			return
		}
		if { $sw == "-name" } {
			set clusname $objname
			set rgnname $objname
		} elseif { $sw == "-instance" } {
			set instpath $objname
			set llcx "-1"
			set llcy "-1"
			set urcx "-1"
			set urcy "-1"

			if {[ampasic_is_name_legal $instpath "instance"] == "0"} {
				error [format "Illegal instance name %s in command: %s" $instpath $args_copy]
				return
			}

		} else {
			error [format "Unknown word %s is found in the argument list of create_cluster" $sw]
			return
		}
	}
	if {$clusname == ""} {
		error "Cluster name of create_cluster is missing"
		return
	}

	if {$instpath == ""} {
		error "Instance path is not specified in the argument list of create_cluster command"
		return
	}

	set arg "llcx=$llcx,llcy=$llcy,urcx=$urcx,urcy=$urcy"
    ampasic_define_attribute syn_create_region $rgnname $rgntype $util $arg $args_copy

    ampasic_define_attribute syn_assign_logic $rgnname $instpath $args_copy
}

proc CheckOrn {orn} {
	if {($orn == "n") || ($orn == "s") || ($orn == "e") || ($orn == "w") ||
		($orn == "fn") || ($orn == "fs") || ($orn == "fe") || ($orn == "fw")} {
		return 0
	}
	if {($orn == "N") || ($orn == "S") || ($orn == "E") || ($orn == "W") ||
		($orn == "FN") || ($orn == "FS") || ($orn == "FE") || ($orn == "FW")} {
		return 0
	}
	return 1
}
