# Stroke TCL File

# WARNING - argument to sendcommandview must be consistent with #define ACT_xxx values

# note: change the version number only when this file is changed because of
# a change to the mouse stroke code
proc stroke_version { } {
	return 900
}

proc stroke_msg {msg} {
}
proc stroke_next_sheet {} {
	sendcommandview "HDLNextSheet"
}
proc stroke_prev_sheet {} {
	sendcommandview "HDLPreviousSheet"
}

proc stroke_close {} {
	sendcommandview "FileClose"
}

proc stroke_cancel {} {
	ges_enddialog "cancel"
}

proc stroke_push {x y} {
	strokePush -x $x -y $y
	hierpush -vp $x $y
}

proc stroke_pop {} {
	strokePop
	hierpop
}

proc stroke_certpush {x y} {
	certpush $x $y
}

proc stroke_certpop {} {
	certpop
}

proc stroke_zoom_out {xs ys xe ye} {
	strokeZoom -mode out -x $xs -y $ys -width $xe -height $ye
	ges_zoomfactor -out $xs $ys $xe $ye
}

proc stroke_zoom_in {xs ys xe ye} {
	strokeZoom -mode in -x $xs -y $ys -width $xe -height $ye
	ges_zoomfactor -in $xs $ys $xe $ye
}

proc stroke_zoom_area {xl yl xh yh} {
	strokeZoom -mode area -x $xl -y $yl -width $xh -height $yh
	ges_zoomarea $xl $yl $xh $yh
}

proc stroke_zoom_full {} {
	strokeZoom -mode full
	sendcommandview "ViewFullView"
}

proc stroke_zoom_selected {} {
	strokeZoom -mode selected
	sendcommandview "ViewZoomSelected"
}

proc stroke_undo {} {
	sendcommandview "EditUndo"
}

proc stroke_redo {} {
	sendcommandview "EditRedo"
}

proc stroke_filter {} {
	sendcommandview "HDLFilterSchematic"
}
proc stroke_forward {} {
	sendcommandview "HDLForward"
}

proc stroke_back {} {
	sendcommandview "HDLBack"
}

proc stroke_open {} {
	sendcommandview "FileOpen"
}
proc stroke_help_application {} {
	help_help
}
proc stroke_help {} {
	help_help
}
	
proc stroke_new {} {
	sendcommandview "FileNew"
}

#proc stroke_maximize {} {
	#showframe -maximize
#}

#proc stroke_minimize {} {
	#showframe -minimize
#}

proc stroke_ok {} {
	ges_enddialog "ok"
}

proc stroke_no {} {
	ges_enddialog "no"
}

proc stroke_print {} {
	sendcommandview "FilePrint"
}

proc stroke_properties {x y} {
	# Show properties for object (Physical Analyst, FPE)
	# Convert x y (client device) to user coordiantes first
	set uc [gm_client2user $x $y]
	gm_showproppage [lindex $uc 0] [lindex $uc 1]
}

proc stroke_visual_properties {x y} {
	# for analyst
	# select at $org
	visualproperties $x $y
}

proc stroke_find {} {
	sendcommandview "EditFind"
}

proc stroke_critical_path {} {
	# Critical path
	sendcommandview "HDLShowCriticalPath"
}

proc stroke_pan {} {
	sendcommandview "ViewPan"
}


#### 3 X 3 Strokes ######

# Dialogs
define_stroke -3 -tutor -class QDialog  123 {stroke_ok} "OK" "OK the dialog or propety sheet"
define_stroke -3 -tutor -class QDialog  147 {stroke_no} "No" "Send No to the dialog"
define_stroke -3 -tutor -class QDialog 321 {stroke_cancel} "Cancel" "Cancel the dialog or property sheet"

# Graphic View (Analyst, PA, FSM, Amplify, etc)
define_stroke -3 -tutor -class CGuiZoomView 159 {stroke_zoom_area $bounds} "Zoom area" "Zoom into area.\nThe area is defined by the stroke diagonal"
define_stroke -3 -tutor -class CGuiZoomView 951 {stroke_zoom_full} "Zoom full" "Zoom to the full view"
define_stroke -3 -tutor -class HdlAnalystSchView 321 {stroke_prev_sheet} "Previous sheet" "Display the previous sheet"
define_stroke -3 -tutor -class CGuiZoomView 357 {stroke_zoom_in $org $end}  "Zoom in" "Zoom in.\nThe zoom factor is proportional to the stroke length"
define_stroke -3 -tutor -class CGuiZoomView 753 {stroke_zoom_out $org $end}  "Zoom out" "Zoom out.\nThe zoom factor is proportional to the stroke length"
define_stroke -3 -tutor -class CGUIModelView 1235789 {stroke_zoom_selected} "Zoom Selected" "Zoom to show selected objects (Physical Analyst, Floor Plan Editor)"
define_stroke -3 -tutor -class CGuiZoomView 14741 {stroke_filter} "Filter" "Show only selected objects"
define_stroke -3 -tutor -class CGuiZoomView 74123 "stroke_forward" "Forward" "Go forward to next view"
define_stroke -3 -tutor -class CGuiZoomView 96321 "stroke_back" "Back" "Go back to previous view"
define_stroke -3 -tutor -class CGuiZoomView 74123654 "stroke_pan" "Pan" "Enter pan mode (press the left mouse button to pan)"

# Edit (Undo, Redo, find, etc)
define_stroke -3 -tutor 1478963 "stroke_undo" "Undo" "Undo the last operation"
define_stroke -3 -tutor 7412369  "stroke_redo" "Redo" "Redo the last operation"
define_stroke -3 -tutor 32147 "stroke_find" "Find" "Display the Find dialog"

# File
define_stroke -3 -tutor 123698741 {stroke_open} "Open" "Open a file"
#define_stroke -3 -tutor 74123654 {stroke_print} "Print" "Print the view"
#define_stroke -3 -tutor 1596357 {stroke_close} "Close" "Close window"
#define_stroke -3 -tutor 7415963 {stroke_new} "New" "Open a new file"
#define_stroke -3 -tutor 74269 {stroke_maximize } "Maximize" "Maximize the window"
#define_stroke -3 -tutor 14863 {stroke_minimize} "Minimize" "Minimize the window"

# Tutor
define_stroke -3 -tutor -panic 123658 {stroke_tutor} "Stroke Tutor" "Display mouse stroke Tutor"
define_stroke -3 12368 {stroke_tutor} "Stroke Tutor" "Display mouse stroke Tutor"
define_stroke -3 123657 {stroke_tutor} "Stroke Tutor" "Display mouse stroke Tutor"
define_stroke -3 1236587 {stroke_tutor} "Stroke Tutor" "Display mouse stroke Tutor"
define_stroke -3 4123658 {stroke_tutor} "Stroke Tutor" "Display mouse stroke Tutor"
define_stroke -3 41236547 {stroke_tutor} "Stroke Tutor" "Display mouse stroke Tutor"
define_stroke -3 1236547 {stroke_tutor} "Stroke Tutor" "Display mouse stroke Tutor"
define_stroke -3 4123657 {stroke_tutor} "Stroke Tutor" "Display mouse stroke Tutor"

# Help
define_stroke -3 -tutor 14569 {stroke_help} "Help" "Display context help"

# Analysis
define_stroke -3 -tutor -class CGUIModelView 12369 {stroke_properties $org} "Properties" "Display object properties.\nBegin stroke on object"
define_stroke -3 -tutor -class HdlAnalystSchView 12369 {stroke_visual_properties $org} "Properties (Analyst)" "Display visual properties.\nBegin stroke on object"
define_stroke -3 -tutor -class HdlAnalystSchView 3214789 {stroke_critical_path} "Critical Path" "Display critical path in Analyst or Physical Analyst"
define_stroke -3 -tutor -class CAsicView 3214789 {stroke_critical_path} "Critical Path" "Display critical path in Analyst or Physical Analyst"

# Analyst
define_stroke -3 -tutor -class HdlAnalystSchView 123 {stroke_next_sheet} "Next sheet" "Display the next sheet"
define_stroke -3 -tutor -class HdlAnalystSchView 147 {stroke_push $org} "Push" "Descend (push) into a hierarchical instance.\nBegin the stroke on the hierarchical instance."
define_stroke -3 -tutor -class HdlAnalystSchView 741 {stroke_pop} "Pop" "Ascend (Pop) a level of hierarchy"

# Certify
define_stroke -3 -tutor -class CPPartView 147 {stroke_certpush $org} "Push" "Descend (push) into a daughter board.\nBegin the stroke on the board."
define_stroke -3 -tutor -class CPPartView 741 {stroke_certpop} "Pop" "Ascend (Pop) a level of board hierarchy"

# New Analyst
define_stroke -3 -tutor -class AV::View 951 {stroke_zoom_full} "Zoom full" "Zoom to the full view"
define_stroke -3 -tutor -class AV::View 1235789 {stroke_zoom_selected} "Zoom Selected" "Zoom to show selected objects (Physical Analyst, Floor Plan Editor)"
define_stroke -3 -tutor -class AV::View 159 {stroke_zoom_area $bounds} "Zoom area" "Zoom into area.\nThe area is defined by the stroke diagonal"
define_stroke -3 -tutor -class AV::View 357 {stroke_zoom_in $org $end}  "Zoom in" "Zoom in.\nThe zoom factor is proportional to the stroke length"
define_stroke -3 -tutor -class AV::View 753 {stroke_zoom_out $org $end}  "Zoom out" "Zoom out.\nThe zoom factor is proportional to the stroke length"
define_stroke -3 -tutor -class AV::View 147 {stroke_push $org} "Push" "Descend (push) into a hierarchical instance.\nBegin the stroke on the hierarchical instance."
define_stroke -3 -tutor -class AV::View 741 {stroke_pop} "Pop" "Ascend (Pop) a level of hierarchy"
