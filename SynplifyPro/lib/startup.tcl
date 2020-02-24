# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
# $Header: //synplicity/ui2019q3p1/uitools/pm/startup.tcl#1 $
#
# General TCL script sourced at program startup.
#
#

# Set technology aliases
#
# technology_alias <new_name> <old_name>
# or
# technology_alias <real_name(new_name)> <alias_name>
#
technology_alias Axcelerator ax
technology_alias Axcelerator Express
technology_alias PA ProASICPlus
technology_alias 500K ProASIC
technology_alias ispxpga lava
technology_alias ISPMACH4000ZC ISPMACH4000CZ
technology_alias 54sxa 54sxs
technology_alias ProAsic3 pa3
technology_alias ispMACH4000ZC ispMACH4000CZ
technology_alias ISPMACH4000ZC ISPMACH4000CZ
technology_alias STRATIXII Armstrong
technology_alias LATTICE-XP orca5magma
technology_alias LATTICE-ECP orca5ecp
technology_alias LATTICE-SC orca5hsi
technology_alias MachXO LATTICE-MJ
technology_alias SPARTAN-3A-DSP spartan3ax
technology_alias ARRIAII-GX ARRIAII
technology_alias SmartFusion2 SmartFusion4
technology_alias BASECAMP HAPS-BC
technology_alias QProRVirtex5 QRVIRTEX5

# map a vendor package known in synplify to the name known by the vendor tool
# Usage: package_name_map  [<vendorName>] [<SynplifyPackageName>] [<VendorPackageName>]
# Description: Map package names to vendor package names.
#  <vendorName> ............ name of the FPGA vendor.
#  <SynplifyPackageName> ... name of package in Synplify.
# <VendorPackageName> ..... name of package in vendor tool.
#
package_name_map actel FBGAK256 "256 FBGA K"
package_name_map actel FBGAK484 "484 FBGA K"
package_name_map microsemi FBGAK256 "256 FBGA K"
package_name_map microsemi FBGAK484 "484 FBGA K"

# Set Quartus Versions
if { [lsearch [info commands] quartus_version_data] >= 0 } {
quartus_version_data 4.0 -label "Quartus II 4.0" -format ""			-libdir quartus_II40
quartus_version_data 4.1 -label "Quartus II 4.1" -format ""			-libdir quartus_II41
quartus_version_data 4.2 -label "Quartus II 4.2" -format ""			-libdir quartus_II42
quartus_version_data 5.0 -label "Quartus II 5.0" -format vqm41		        -libdir quartus_II50
quartus_version_data 5.1 -label "Quartus II 5.1" -format vqm41		        -libdir quartus_II51
quartus_version_data 6.0 -label "Quartus II 6.0" -format vqm41		        -libdir quartus_II60
quartus_version_data 6.1 -label "Quartus II 6.1" -format vqm41		        -libdir quartus_II61
quartus_version_data 7.0 -label "Quartus II 7.0" -format vqm41		        -libdir quartus_II70
quartus_version_data 7.1 -label "Quartus II 7.1" -format vqm41		        -libdir quartus_II71
quartus_version_data 7.2 -label "Quartus II 7.2" -format vqm41		        -libdir quartus_II72
quartus_version_data 8.0 -label "Quartus II 8.0" -format vqm41				-libdir quartus_II80
quartus_version_data 8.1 -label "Quartus II 8.1" -format vqm41				-libdir quartus_II81
quartus_version_data 9.0 -label "Quartus II 9.0" -format vqm41				-libdir quartus_II90
quartus_version_data 9.1 -label "Quartus II 9.1" -format vqm41				-libdir quartus_II91
quartus_version_data 10.0 -label "Quartus II 10.0" -format vqm41				-libdir quartus_II100
quartus_version_data 10.1 -label "Quartus II 10.1" -format vqm41				-libdir quartus_II101
quartus_version_data 11.0 -label "Quartus II 11.0" -format vqm41				-libdir quartus_II110
quartus_version_data 11.1 -label "Quartus II 11.1" -format vqm41				-libdir quartus_II111
quartus_version_data 12.0 -label "Quartus II 12.0" -format vqm41				-libdir quartus_II120
quartus_version_data 12.1 -label "Quartus II 12.1" -format vqm41				-libdir quartus_II121
quartus_version_data 13.0 -label "Quartus II 13.0" -format vqm41				-libdir quartus_II130
quartus_version_data 13.1 -label "Quartus II 13.1" -format vqm41				-libdir quartus_II131
quartus_version_data 14.1 -label "Quartus II 14.1" -format vqm41				-libdir quartus_II141
quartus_version_data 14.0 -label "Quartus II 14.0" -format vqm41				-libdir quartus_II140
quartus_version_data 15.0 -label "Quartus II 15.0" -format vqm41				-libdir quartus_II150
quartus_version_data 15.1 -label "Quartus II 15.1" -format vqm41				-libdir quartus_II151
quartus_version_data 16.0 -label "Quartus Prime 16.0" -format vqm41				-libdir quartus_prime160
quartus_version_data 16.1 -label "Quartus Prime 16.1" -format vqm41				-libdir quartus_prime161
quartus_version_data 17.0 -label "Quartus Prime 17.0" -format vqm41				-libdir quartus_prime170
quartus_version_data 17.1 -label "Quartus Prime 17.1" -format vqm41				-libdir quartus_prime171
quartus_version_data 18.0 -label "Quartus Prime 18.0" -format vqm41				-libdir quartus_prime180
quartus_version_data 18.1 -label "Quartus Prime 18.1" -format vqm41				-libdir quartus_prime181
quartus_version_data 19.1 -label "Quartus Prime 19.1" -format vqm41				-libdir quartus_prime191
quartus_version_data 19.3 -label "Quartus Prime 19.3" -format vqm41				-libdir quartus_prime193
quartus_version_data 19.2 -label "Quartus Prime 19.2" -format vqm41				-libdir quartus_prime192
}
# Set implementation filter
# Setup file extensions that are visible in implementation directory
impl_filter -reset	srr srs srm srp src sdf sdc sat fsm edn edf lp xnf
impl_filter			est qdf ncf acf tdf tcl vma vhn vhm vm vqm prf ta tasrr
impl_filter			vmd setload def pdef scf areasrr cck syn cnt csp nld srl
impl_filter			log htm tah tlg model vtc taq sxr plg ngo mac lst srd xrf
impl_filter			vqm plc fse sfp vqm sap ucf


# source_if_exists()
#
# source file, but only if it exists
#
proc source_if_exists {tclFilename} {
	if {[file exists $tclFilename]} {
		source $tclFilename
	}
}

# The following code is used to enable the auto-exec feature of TCL.

# define dummy console procedure if it does not exist. Needed for IO in unknown command processing.
if {[string equal [info commands console] ""]} {
	proc console {} { }
}

set tclLibDir [installinfo libdir]
set tcl_library $tclLibDir
set tcl_interactive 1

#source_if_exists $tcl_library/pro_ise_correlate.tcl
source_if_exists $tcl_library/clock_prior.tcl
source_if_exists $tcl_library/syn_to_sdc.tcl
source_if_exists $tcl_library/xdc_to_fdc.tcl
source_if_exists $tcl_library/xilinx/add_vivado_ip.tcl

proc source_find_script {fn} {
	if { [ file pathtype $fn ] == "absolute" } {return $fn}
	global SOURCE_PATH
	if [ info exists SOURCE_PATH ] {
		foreach path ". $SOURCE_PATH" {
			if [ file exists "$path/$fn" ] {
				#puts "found $fn in $path"
				return "$path/$fn"
			}
		}
	}
	return $fn
}
proc add_source_path {path} {
	global SOURCE_PATH
	if [info exists SOURCE_PATH] {
		set SOURCE_PATH [ concat $path $SOURCE_PATH ]
	} else {
		set SOURCE_PATH $path
	}
}
proc remove_source_path {path} {
	global SOURCE_PATH
	if [ info exists SOURCE_PATH ] {
		set idx_list [ lsearch -exact $SOURCE_PATH $path ]
		foreach idx [ lreverse $idx_list ] {
			set SOURCE_PATH [ lreplace $SOURCE_PATH $idx $idx ]
		}
	}
}
rename source source.orig
proc source {args} {
	# source script
	# or
	# source -encoding XXX script
	set fn [lrange $args end end]
	set fn [source_find_script $fn]
	set fn [obffn $fn]
	set encargs [lrange $args 0 end-1]
	#puts "sourcing '$fn' (was 'source $args')"
	set cmd "source.orig $encargs \"$fn\""
	uplevel 1 $cmd
}

if { [ string match "*batch" [shellname] ] || [ string match "*shell" [shellname] ] } {
	rename exec exec.orig
	proc exec {args} {
		if { [ lindex $args end ] == "&" } {
			return -code error {@E: Launching a shell command in background (with &) is not supported from this Tcl shell. Please launch it directly from your native shell.}
		}
		set cmd "exec.orig $args"
		uplevel 1 $cmd
	}
}

set ERROR_VERBOSITY 2
# syn_error_source is called whenever a Synopsys Tcl command issues an error
proc syn_error_info args {
	global ERROR_VERBOSITY
	if { $ERROR_VERBOSITY == 0 } return
	set fi [info frame -3]
	if { [lindex $fi  1] == "source" } {
		# if a Tcl file was being sourced, make sure to show enough information:
		set line [ lindex $fi 3]
		set file [ lindex $fi 5]
		set cmd [lindex $fi 7]
		if { [file extension "$file"] == ".obf" } {
			puts "  while executing \"$cmd\""
		} else {
			puts "  at line $line of $file. Command was \"$cmd\""
		}
		# you could also set a global variable here, if $errorInfo is not enough
	}
}

proc ls {args} {
	set dirpath [lrange $args end end]
	if { ! [file isdirectory $dirpath] } {
		set dirpath [file dirname $dirpath]
	}
	if { [file exists "$dirpath/dbstate.xml"] } {
		puts "Contents of ProtoCompiler database is restricted ([file join [pwd] $dirpath])"
		return ""
	}
	return [eval exec ls $args]
}

set unsupportedcommands {vi vim}
foreach cmd $unsupportedcommands {
	proc $cmd {args} {
		puts "'[info level 0]' is not supported inside FPGA tools. Please launch it from outside the tool."
		return ""
	}
}
unset unsupportedcommands
