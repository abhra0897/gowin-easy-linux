# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
#cvs.tcl
#Implementation of SCM functionality for the CVS tool.

proc get_redirect_string {} {
	if {[info tclversion]>="8.5"} {
	    return "@1";
	} 
	return "@stdout";
}

#global variable - redirect stderr to "@stdout" for Tcl versions before 8.5, to "@1" for 8.5 and above
set redirect [get_redirect_string];

#check in function
#files is the list of files to be checked in
#comment is the user-supplied comment to be attached to the checkin
proc scm_check_in { files  comment } {
	global redirect;
    set match "";
    set listsize [llength $files];
    for {set i 0} {$i<$listsize} {incr i} {
        set filename [lindex $files $i];
        set filename [string trim $filename "{}"];
        set file [open "|cvs ci -m \"$comment\" \"$filename\" 2>$redirect" r+];
        set result "";
        while {[gets $file line]>=0} {
            regexp {^done} $line match;
            set result [concat $result $line];
        }
        if {$match==""} {

            #error condition - cvs ci operation failed
            puts "Unable to submit $filename: $result";

            #return code 2 to signify error condition
            return 2;
        }
    } 
    return 0;
}

#file status command
#Returns the checked-in/checked-out status of the listed files
#The returned string will be formatted as follows:
# {  {file1|red_checked} {file3|lock} {file2|lock}...{file_n|lock} }
#The files in the result string are not guaranteed to be listed in any 
#particular order, and implementers should not assume any order.
#However, all files listed in the $files parameter must be accounted
#for at some point in the result string.
proc scm_file_status { files } {
	global redirect;
    set file [open "|cvs status $files 2>$redirect" r+];
    set pathState "";
    set path "";
    set match "";
    set status "";
    set line2 "";
    while {[gets $file line]>=0} {
        set match "";

        #skip lines that don't list a file status
        regexp {Status: (.+)} $line match status;
        if {$match!=""} {
            set filePath [lindex $files 0];
            set files [lrange $files 1 end];
            set match "";
            regexp {Unknown} $status match;
            if {$match!=""} {
                set pathState [concat $pathState "{$filePath|nothing}"];
                continue;
            }
            regexp {Up-to-date} $status match;
            if {$match!=""} {
                set pathState [concat $pathState "{$filePath|red_check}"];
                continue;
            }
            regexp {Locally Modified} $status match;
            if {$match!=""} {
                set pathState [concat $pathState "{$filePath|green_check}"];
                continue;
            }
            regexp {Unresolved Conflict} $status match;
            if {$match!=""} {
                set pathState [concat $pathState "{$filePath|conflict}"];
                continue;
            }
            regexp {Needs Merge} $status match;
            if {$match!=""} {
                set pathState [concat $pathState "{$filePath|conflict}"];
                continue;
            }
            regexp {File had conflicts on merge} $status match;
            if {$match!=""} {
                set pathState [concat $pathState "{$filePath|conflict}"];
                continue;
            }
            regexp {Locally Added} $status match;
            if {$match!=""} {
                set pathState [concat $pathState "{$filePath|plus}"];
                continue;
            }
   
            #if we're here, the status doesn't match any we recognize - just return a default status (currently warning).
            set pathState [concat $pathState "{$filePath|warning}"];
         } 
	}
    return $pathState;
}

#add files to repository
proc scm_add_files { files } {
	global redirect;
    set file [open "|cvs add $files 2>$redirect" r+];
    set line "";
    set match "";
    gets $file line;
    while {[gets $file line]>=0} {
        set match "";
        regexp { scheduling file (.+) for addition} $line match path;
        if {$match==""} {
        
            #error condition - cvs add operation failed
            puts "Unable to add $files: $line";

        	#ignore phantom "child process exited abnormally" errors
            catch {close $file} errorMsg;
        	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
	            puts $errorMsg;
        	}

            #return code 2 to signify error condition
            return 2;
        }
    }

   	#ignore phantom "child process exited abnormally" errors
    catch {close $file} errorMsg;
   	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
        puts $errorMsg;
   	}
    return 0;
}

#revert changes to the specified files
proc scm_revert_changes { files } {
	file delete "$files";
    exec cvs update $files;
    return 0;
}

#get latest revision; only affects files that currently have checked_in status
proc scm_get_latest_revision { files } {
	global redirect;
    set file [open "|cvs status $files 2>$redirect" r+];
    set path "";
    set match "";
    set status "";
    set syncList "";
    set filePath [lindex $files 0];
    set files [lrange $files 1 end];
    while {[gets $file line]>=0} {
        set match "";

        #skip lines that don't list a file status
        regexp {Status: (.+)} $line match status;
        if {$match!=""} {
            set match "";
		    regexp {Unknown} $status match;
            if {$match!=""} {
                set filePath [lindex $files 0];
                set files [lrange $files 1 end];
                continue;
            }
		    regexp {Locally Added} $status match;
            if {$match!=""} {
                set filePath [lindex $files 0];
                set files [lrange $files 1 end];
                continue;
            }
   
            #if we're here, the locally-added/not-in-SCM statuses don't apply and we can assume it's safe to update this file.
            set syncList [concat $syncList " $filePath"];
            set filePath [lindex $files 0];
            set files [lrange $files 1 end];
        } 
    }
    exec cvs update $syncList;

   	#ignore phantom "child process exited abnormally" errors
    catch {close $file} errorMsg;
   	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
        puts $errorMsg;
   	}
    return 0;
}