# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
#perforce.tcl
#Implementation of SCM functionality for the Perforce tool.
#For use with the 2010.2 release of Perforce.

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
    if { [llength $files]==1 } {
        set file [open "|p4 submit -d \"$comment\" $files 2>$redirect" r+];
        while {[gets $file line]>=0} {
            regexp {Change [0-9]+ submitted} $line match;
            if {$match!=""} {
                break;
            }
        }

        #ignore phantom "child process exited abnormally" errors
        catch {close $file} errorMsg;
        if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
	        puts $errorMsg;
        }
        if {$match==""} {

            #error condition - p4 submit operation failed
            puts "Unable to submit $files: $line";

            #return code 2 to signify error condition
            return 2;
        }
    } else {

        #create a template file
        set description " $comment";
        set description [string map {\n "\n "} $description];

        #get a file descriptor for redirected output; we need to do this so that 
        #we can grab the changeset number and move our affected files into it later.
        set file [open "|p4 change -i 2>$redirect" r+]; 
        puts $file "Change: new";
        puts $file "Description:";
        puts $file $description;
        puts $file "Files:";
        puts $file [fconfigure $file -eofchar];
        flush $file;
        set changenum "";
        while {[gets $file line]>=0} {
            regexp {Change ([0-9]+) created} $line match changenum;
            if {$match!=""} {
                break;
            }
        }
        if {$changenum==""} {

            #error condition - create changelist operation failed
            puts "Unable to create changeset: $line";

        	#ignore phantom "child process exited abnormally" errors
            catch {close $file} errorMsg;
        	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
	            puts $errorMsg;
        	}

            #return code 2 to signify error condition
            return 2;
        }

       	#ignore phantom "child process exited abnormally" errors
        catch {close $file} errorMsg;
      	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
            puts $errorMsg;
       	}

        #changenum now holds the number of the new changeset; we now do a 
        #"p4 reopen" to move all of the affected files into the new changeset.
        set file [open "|p4 reopen -c $changenum $files 2>$redirect" r+];
        gets $file line;
        while {$line!=""} {
            regexp { reopened; } $line match;
            if {$match==""} {

                #error condition - p4 reopen operation failed
                puts "Unable to move files to new changeset: $line";

            	#ignore phantom "child process exited abnormally" errors
                catch {close $file} errorMsg;
            	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
	                puts $errorMsg;
        	    }

                #return code 2 to signify error condition
                return 2;
            }
            gets $file line;
        }

      	#ignore phantom "child process exited abnormally" errors
        catch {close $file} errorMsg;
      	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
            puts $errorMsg;
       	}

        #finally, we check in the newly-created changeset with the user-supplied
        #comment.  This will not work for all comments, as including double-quotes ""
        #within the comment itself will cause an incorrect command to be issued.  
        #We ignore such cases here for the sake of clarity and brevity.
        set file [open "|p4 submit -c $changenum 2>$redirect" r+];
        gets $file line;
        while {$line!=""} {
            regexp {Change [0-9]+ submitted} $line match;
            if {$match==""} {

                #error condition - p4 submit operation failed
                puts "Unable to submit changeset $changenum: $line";

            	#ignore phantom "child process exited abnormally" errors
                catch {close $file} errorMsg;
            	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
	                puts $errorMsg;
            	}

                #return code 2 to signify error condition
                return 2;
            }
            gets $file line;
        }

       	#ignore phantom "child process exited abnormally" errors
        catch {close $file} errorMsg;
       	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
            puts $errorMsg;
       	}
    }
    return 0;
}

#check out function
#files is the list of files to be checked out
proc scm_check_out { files } {
	global redirect;
    set match "";
    set file [open "|p4 edit $files 2>$redirect" r+];
    gets $file line;
    while {[string compare $line ""] != 0} {
        regexp {opened for edit} $line match;
        if {$match!=""} {
            gets $file line;
        } else {
        
            #error condition - p4 edit operation failed
            puts "Unable to edit file: $line";

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

#file status command
#Returns the checked-in/checked-out status of the listed files
#The returned string will be formatted as follows:
# {  {file1|red_check} {file3|lock} {file2|lock}...{file_n|lock} }
#The files in the result string are not guaranteed to be listed in any 
#particular order, and implementers should not assume any order.
#However, all files listed in the $files parameter must be accounted
#for at some point in the result string.
proc scm_file_status { files } {
	global redirect;
    set file [open "|p4 fstat $files 2>$redirect" r+];
    set pathState "";
    set path "";
    set match "";
    set filePath "";
    while {[gets $file line]>=0} {
        set match "";
        regexp {Path '(.+)' is not under client's root} $line match filePath;
        if {$match!=""} {
		    set pathState [concat $pathState "{$filePath|nothing}"];
        } else {
            regexp {(.+) - no such file} $line match filePath;
            if {$match!=""} {
		        set pathState [concat $pathState "{$filePath|nothing}"];
            } else {
		        regexp {clientFile (.+)} $line match filePath;
		        if {$match!="" || $line==""} {
			        if {$path!=""} {
				        set pathState [concat $pathState "{$path|lock}"];
			        }
			        set path $filePath;
			        set match "";
			        set filePath "";
		        } else {
			        set match "";
			        regexp {action edit} $line match;
			        if {$match!=""} {
				        set pathState [concat $pathState "{$path|red_check}"];
				        set match "";
				        set path "";
			        } else {
			            set match "";
			            regexp {action add} $line match;
			            if {$match!=""} {
				            set pathState [concat $pathState "{$path|plus}"];
				            set match "";
				            set path "";
						}
		            }
		        }
            }
        }
	}

   	#ignore phantom "child process exited abnormally" errors
    catch {close $file} errorMsg;
   	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
        puts $errorMsg;
   	}
    return $pathState;
}

#add files to repository
proc scm_add_files { files } {
	global redirect;
    set file [open "|p4 add $files 2>$redirect" r+];
    set line "";
    set match "";
    while {[gets $file line]>=0} {
        set match "";
        regexp {opened for add} $line match;
        if {$match==""} {
        
            #error condition - p4 add operation failed
            puts "Unable to add file: $line";

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
	global redirect;
    set file [open "|p4 revert $files 2>$redirect" r+];
    set line "";
    set match "";
    while {[gets $file line]>=0} {
        set match "";
        regexp {, reverted} $line match;
        if {$match==""} {
            regexp { not opened on this client} $line match;
            if {$match==""} {
                regexp {, abandoned} $line match;
                    if {$match==""} {
        
                    #error condition - p4 revert operation failed
                    puts "Unable to revert changes: $line";

                	#ignore phantom "child process exited abnormally" errors
                    catch {close $file} errorMsg;
                	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
	                    puts $errorMsg;
                	}

                    #return code 2 to signify error condition
                    return 2;
                }
            }
        }
    }

   	#ignore phantom "child process exited abnormally" errors
    catch {close $file} errorMsg;
   	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
        puts $errorMsg;
   	}
	return 0;
}

#get latest revision; only affects files that currently have checked_in status
proc scm_get_latest_revision { files } {
	global redirect;
    set file [open "|p4 fstat $files 2>$redirect" r+];
    set path "";
    set match "";
    set filePath "";
    set syncList "";
    set syncFile true;

    #gather list of checked-in files
    while {[gets $file line]>=0} {
        set match "";
        regexp {Path '(.+)' is not under client's root} $line match filePath;
        if {$match!=""} {
            set syncFile false;
        } else {
            regexp {(.+) - no such file} $line match filePath;
            if {$match!=""} {
                set syncFile false;
            } else {
			    regexp {action edit} $line match;
			    if {$match!=""} {
                    set syncFile false;
                } else {
			        regexp {action add} $line match;
			        if {$match!=""} {
                        set syncFile false; 
                    } else {
		                regexp {clientFile (.+)} $line match filePath;
		                if {$match!="" || $line==""} {
			                if {$path!="" && $syncFile==true} {
				                set syncList [concat $syncList " $path"];
			                }
                            if {$match!=""} {
                                set syncFile true;
                            }
			                set path $filePath;
			                set match "";
			                set filePath "";
                        }
                    }
		        }
            }
        }
	}
    exec p4 sync $syncList;

   	#ignore phantom "child process exited abnormally" errors
    catch {close $file} errorMsg;
   	if {[string compare "$errorMsg" "child process exited abnormally"]!=0} {
        puts $errorMsg;
   	}
    return 0;
}