### proc for getting the ISE version so that a decision can be taken if 
#### .RAMB36_EXP string needs to be appended for RAMB36 instances ####

proc get_ise_ver_4edk { IsePath } {
		set xilinx_fileset "$IsePath/fileset.txt"
                if { [file exists $xilinx_fileset] } {
                      set filesetFile [open $xilinx_fileset]
                      set fileset_list [split [read $filesetFile] \n]
                      close $filesetFile
                      set versionList ""
                      set versionList [lsearch -inline -all -regexp $fileset_list "version="]
                      if { [string match $versionList "" ] != 1 } {
                             set latest_version [regsub {.*version=(.*)\}} $versionList {\1}]
                             set xilinx_ver [regsub {\..*} $latest_version  "" ]
                         } 
                    } else {
			    #### defaulting to ISE 10 version if fileset.txt does not exist###
			    set xilinx_ver 10
		    }
}		    



# Called at the end of each run.
proc syn_on_end_run {runName run_dir implName} {
### Check that this proc gets executed only when only at the end of synthesis 
#and not compile or any other variants of project -run 

if { [string match $runName synthesis] == 1 } {
    #### Check that the project file has a bmm file added to it 
    #### So as to confirm that its a project created by edk2syn utility #######

    set BmmExists [lsearch -regexp [project -filelist] ".*\.bmm" ]
   
    ##### If BmmExists is -1 it implies that the project is not a EDK2SYN converted project and so abort the conversion
   
    if { $BmmExists != -1 } {
       puts "************ BMM Conversion in Progress *****************"
   
       #### Find the BMM File Name ###
       set BmmFile [lsearch -inline -regexp [project -filelist]  ".*\.bmm" ]
         
       ####Check for the file existance of BMM File and if does not exist then stop the BMM conversion
       if { [file exists $BmmFile ] == 0 } {
                 puts "    WARNING: The BMM file \"$BmmName\" doesn't exist, skipping the BMM conversion process"
          } else { 
         
                set BmmName [file tail $BmmFile]
                #### Find the active implementation and the P&R jobs for this implementation ####
                set ImplDir  [impl -dir]
                set ImplName [impl -active]
                set JobList  [job -list]
         
                ### Find the SRS Name for the active implementation ####
                set SrsName [regsub {\..*} [get_option result_file] {.srs} ]
   
                ### Open the RTL view
                catch {set RTL [open_file $SrsName]}
                ### Copy the Original BMM File to all P&R job directories & Modify the file accordingly.
                set clock [clock seconds]    
                foreach EnJob  $JobList {
                    ####Create the P&R directory just to be safe
                    file mkdir $ImplDir/$EnJob
                    file copy $BmmFile $ImplDir/$EnJob/$BmmName.org.$clock
                    puts "    Note: Copied the original BMM file \"$BmmFile\" to \"$ImplDir/$EnJob/$BmmName.org.$clock\" \n"
                    set bmmFile "$ImplDir/$EnJob/$BmmName.org.$clock"
                    set bmmFileID [open $bmmFile "r"]

                    ### Copied BMM FileName logic Changing after c200906. Using Top Level Module name for BMM File in P&R Directory.Date:12thJune2009 ####
                    set Top_Module [get_option top_module]
                    if { [string match $Top_Module ""] } {
                           set PnR_BmmName $BmmName
                           puts "    WARNING: Could not extract Top Level Module Name. Using \"$BmmName\" for BMM file in P&R Directory $EnJob"
                           puts "    WARNING: Please check that the run_ise.tcl file in P&R Directory uses this name for adding the BMM file to ISE project"   
                    } else {
                           set PnR_BmmName $Top_Module.bmm
                           puts "    Note: Using Top Level Module Name \"$Top_Module\" for creating the BMM file in P&R Directory $EnJob"
                    }   
                    #set bmmFileWrite "$ImplDir/$EnJob/$BmmName"
                    set bmmFileWrite "$ImplDir/$EnJob/$PnR_BmmName"    
                    set bmmFileIDWrite [open $bmmFileWrite "w"]
                    while { ![eof $bmmFileID] } {
                           gets $bmmFileID line
                           set val {}
                           ## Check whether the line has vectored numbers 
                           if { [regexp {([a-z].*) +\[.*\;$} $line dummp val] } {
                                    regsub -all / $val "\." mod
                                    set mod "\*$mod"
                                    lappend valList $mod
                                    set name {}
                                    catch {set view [find -hier -flat -inst $mod]}
                                    catch {set name [get_prop -prop hier_rtl_name $view]}

                                                                            
                                     # Fix for Virtex5 & above devices which require the string "RAMB36_EXP" to be appended ###
					set ise_version [ get_ise_ver_4edk [regsub -all {\\} [get_env XILINX] {/}]]
					if { $ise_version < 11 } {
						set RAMB36_inst {}
					        catch {set RAMB36_inst [get_prop -prop inst_of $view] } 
					        if { [string match $RAMB36_inst "RAMB36"] } {
					            regsub {$} $name {.RAMB36_EXP} name
					         }
					}
					####################




                    
                                    if { [regsub -all {\.} $name / name ] } {
                                          regsub $val $line $name newval
                                          puts $bmmFileIDWrite $newval
                                    } else {
                                          puts $bmmFileIDWrite $line
                                    }
                                           
                           } else {
                                    puts $bmmFileIDWrite $line
                           } 
                    }
                
                    close $bmmFileID 
                    close $bmmFileIDWrite 
                }    
                catch {win_close $RTL}
          }    
         
          puts "************ BMM Conversion Done *****************"            
   
          ##### OPT FILE manupulation ##############
          if { [file exists "$ImplDir/synplicity.ucf"] } {
               puts "************ OPT File Conversion in Progress *****************" 

               set OptFile [lsearch -inline -regexp [project -filelist] {.*fast_runtime\.opt}]
               if { [file exists $OptFile] } {
                         file rename -force $OptFile $OptFile.org.$clock
                         puts "    Note: Moved the original file \"$OptFile\" to \"$OptFile.org.$clock\""
                         set OptFileID [open $OptFile.org.$clock "r"]
                         set OptFileIDWrite [open $OptFile "w"]
                         while { ![eof $OptFileID ] } {
                              gets $OptFileID line
                              set modline $line    
                              if { [regexp {\-uc\s+(.*)\;(.*)} $line dummp val remain] } {
                                 set modline "\-uc synplicity.ucf\;$remain"
                              }
                              #### Original OPT file will have -bm <design>.bmm while the top level design name may change from 
                              #### original copied BMM file.So modify the OPT file to add the BMM file by its actual name.
                              if { [regexp {\-bm\s+(.*?)(\s*#.*)} $line dummp val remain] } { 
                                 set modline "\-bm $PnR_BmmName $remain"
                              }
                              puts $OptFileIDWrite $modline
                         }
                         close $OptFileID 
                         close $OptFileIDWrite 
               } else {
                         puts "WARNING: The OPT file $OptFile doesn't exist, skipping the OPT conversion process"
               }
               puts "************ OPT Conversion Done *****************"                        
          }  
 
    }
  
  }
}

# Called at the end of each run.
proc syn_on_press_ctrl_f11 {} {
    puts "************ Export Bitmap Started *****************"
    set prjFile [project -file]
    set prjFileId [open $prjFile "r"]
    set flag 0
    set done 0

    while { ![eof $prjFileId] } {
    gets $prjFileId line
        # Get PAR implementation Name
    if { [regexp {set_option \-job +([^ ]*) -add par} $line dummy parName] } { }

        # Get XMP_DIR Value
    if { [regexp {set XMP_DIR +([^ ]*)} $line dummy XMP_DIR] } { }

        # Get BMM File Name
    if { [regexp "add_file.*\/.*\.bmm" $line dummy] } {
       regsub ".*\/" $dummy "" BmmName       
       regsub "\.bmm" $BmmName "" TOP_NAME       
    }
    }
    close $prjFileId

    set impName [impl -dir]
    set synBitFile "$impName/$parName/$TOP_NAME.bit"
    set synBmmFile "$impName/$parName/${TOP_NAME}_bd.bmm"
    set edkBitFile "$XMP_DIR/implementation/$TOP_NAME.bit"
    set edkBmmFile "$XMP_DIR/implementation/${TOP_NAME}_bd.bmm"

    puts "BMM file: $synBmmFile"
    puts "BIT file: $synBitFile"
    puts "Destination Path: $XMP_DIR/implementation"

    ## Delete the older download.bit file
    if { [file exists "$XMP_DIR/implementation/download.bit"] } {
        file delete $XMP_DIR/implementation/download.bit }
    ## Touch the routed file to stop EDK implementation trigger.
    ## This file is no longer created by XPS, hence commenting out
    #file mtime $XMP_DIR/__xps/${TOP_NAME}_routed [clock seconds]
    ## Backup and copy new BMM and BIT files from Synplify
    if { [file exists "$edkBmmFile"] } {
        file rename -force $edkBmmFile $edkBmmFile.bak }
    if { [file exists "$edkBitFile"] } {
        file rename -force $edkBitFile $edkBitFile.bak }
    file copy -force $synBmmFile $synBitFile $XMP_DIR/implementation/.
    ## Touch these new BMM and BIT files to update the date stamp
    file mtime $edkBmmFile [clock seconds]
    file mtime $edkBitFile [clock seconds]

    puts "************ Export Bitmap Done *****************"
}
