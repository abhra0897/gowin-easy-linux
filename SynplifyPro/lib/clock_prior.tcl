# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
proc default_clock_prior {} {
	cd [impl -dir]
	set f_list [impl -result_file]
	regsub {\.[a-zA-Z]+$} $f_list ".srr" f_list
	regsub -all {\\} $f_list "/" f_list
	if [catch {open $f_list r} fpi1] {
		puts "ERROR: could not open .srr file $f_list"
		return 1
	}
	puts "Found SRR file: $f_list"

	if {[file exists default_clock_prior.sdc]} {
		puts "default_clock_prior.sdc file already exists.  No action taken."
		close $fpi1
		return
	}

	if [catch {open "default_clock_prior.sdc" w} ofile] {
		puts "ERROR: could not create file default_clock_prior.sdc"
		close $fpi1
		return 1
	}
	while {![eof $fpi1]} {
		gets $fpi1 curr_line
		regsub {^ *} $curr_line "" curr_line
		regsub -all {\s{2,}} $curr_line " " curr_line
		if {[regexp {@W.*overriding a derived clock} $curr_line]} {
			regsub {.*object \"([^\"]+)\".*} $curr_line {\1} obj
			puts $ofile "define_attribute {$obj} syn_clock_priority {1}"
		}
	}
	puts "Creating default clock priority assignments in file [impl -dir]/default_clock_prior.sdc"
	puts "You should verify priority values before adding this file to your project."
	close $fpi1
	close $ofile
}
